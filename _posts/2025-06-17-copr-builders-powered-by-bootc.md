---
layout: post
title: Copr builders powered by bootc
lang: en
tags: fedora copr bootc image-builder
---

As of today, all Copr builder virtual machines are now being spawned from
[bootc][bootc] images, which is no small feat because the builder infrastructure
involves multiple architectures (x86_64, aarch64, ppc64le, s390x), multiple
clouds (Amazon AWS, IBM Cloud), and on-premise hypervisors. It scales up to
[400 builders running simultaneously][builders-at-once] and peaking at
[30k builds a day][builds-a-day].


# Before bootc

You can find some interesting history and previous numbers in Pavel's article -
[Fedora Copr farm of builders - status of July 2021][farm-2021]. The part it
leaves out is how we used to generate the Copr builder images.

The process is documented in the
[official Copr documentation][how-to-upgrade-builders]. In a nutshell, it
involved manually spawning a VM from a fresh [Fedora Cloud][fedora-cloud] image,
running Ansible playbooks to provision it, and then using custom scripts to
upload the image to the right place. Because we need to build the images
natively, we had to follow this process for every architecture.

The easiest workflow was for x86_64 builders running on our own hypervisors. It
meant connecting to the hypervisor using SSH and running a custom
[copr-image][copr-image] script from the [praiskup/helpers][praiskup-helpers]
repository. While its usage looks innocent, internally it had to execute many
`virt-sysprep` commands. It also required some
[guestfish hacks][guestfish-hacks] to modify `cloud-init` configuration inside
of the image so that it works outside of an actual cloud. Then, finally, using
the [upload-qcow2-images][upload-qcow2-images] script to upload the image into
libvirt.

The same exact workflow for ppc64le builders. However, internally it had a
special case uploading the image also to OSU OSL OpenStack.

For s390x builders, we don't have a hypervisor where we could natively build the
image. Thus we needed to [spawn a new VM in IBM Cloud][prepare-s390x] and run
the previously mentioned [copr-image][copr-image] script inside of it. Once
finished, we needed to upload the image to IBM Cloud. This is supposed to be
done using the [ibmcloud][ibmcloud] tool, but the problem is that
[it is not FOSS][ibmcloud-not-foss], and as such, it cannot be packaged for
Fedora. We don't want to run random binaries from the internet, so we
[containerized it][ibmcloud-container].

At this point, only x86_64 and aarch64 images for Amazon AWS remain.

While not straightforward to create a new AMI from a local qcow2 image, it's
quite easy to [create an AMI from a running EC2 instance][instance-to-ami]. That
was our strategy. Spawn a new instance from a fresh [Fedora Cloud][fedora-cloud]
image, provision it, and then create an AMI from it.


# Current situation

I disliked exactly three aspects concerning the previous solution. It required a
lot of manual work, the process was different for every cloud and architecture,
and the bus factor was less than one.

Even though at this moment generating a fresh set of builder images still
requires about the same amount of manual work as before, there is a potential
for future automation. By switching to [bootc][bootc] and
[Image Builder][image-builder], we were able to offload some dirty work to them
while also unifying the process to follow the same steps for all architectures
and clouds (with minor caveats).

The [current process is temporarily documented here][bootc-readme]. We spawn a
VM for every architecture and use it to build the system image from our
[Containerfile][containerfile] via the
[quay.io/centos-bootc/bootc-image-builder][bootc-image-builder]. Then we fetch
the results and upload them where needed.

For Amazon AWS, we can utilize the `image-builder upload` feature which is
amazing. But for other clouds and hypervisors, we still need our custom
[upload-qcow2-images][upload-qcow2-images] and
[quay.io/praiskup/ibmcloud-cli][ibmcloud-container]. If `image-builder` could
implement the missing support and enable uploading to all of them, that would be
a major win for us.


# Future plans

My goal is simple, I want one-button deployment. Well, almost.

When a change is made to our [Containerfile][containerfile], or when triggered
manually, or periodically after a period of inactivity, I want the images to be
automatically built for all architectures and uploaded to all the necessary
places. Then seeing a list of image names and AMIs that I can either choose to
use or ignore.

The [bootc-image-builder-action][bootc-image-builder-action] seems like the
perfect candidate, but the problem is that it cannot natively build images for
ppc64le and s390x.


[SNThrailkill][snthrailkill] recommended [GitLab Runners][gitlab-runners] but
that would require us to maintain the runner VMs, which is annoying. Moreover,
there is a potential chicken-and-egg problem, meaning that if we break our
image, we might not be able to spawn a VM to build a new working image. We also
wouldn't be able to use the existing GitHub action and would have to port it for
GitLab.

At this moment, our team is leaning towards Konflux and a tekton pipeline for
building images. Fedora Konflux instance is limited to x86_64 and aarch64, so we
would temporarily have to use an internal Red Hat instance which provides all
the architectures needed by us.

Many questions are yet to be answered. Is Konflux ready? Does the pipeline for
building images already exist? Does it support everything we need? Is it built
on top of `image-builder` so that we can use its `upload` feature?


# Pitfalls along the way

Hopefully, this can help [Image Builder][image-builder] and [bootc][bootc]
developers better understand their blind spots in the onboarding process, and
also prevent new users from repeating the same mistakes.

Before discovering that [bootc][bootc] exists, our original approach was to use
just [Image Builder][image-builder] and its [blueprints][blueprint], and
automatize the process using [Packit][packit-integration].  There were several
problems. It was easy to build the image locally from our blueprint, but it
[wasn't possible to upload the same blueprint][blueprint-vs-api] to be built in
a hosted Image Builder service. Additionally, I had several issues with the
[Blueprint TOML format][blueprint]. The order of operations is pre-defined
(e.g. all users are always created before any packages are installed). There is
no escape hatch to run a custom command. And finally, it's yet another
specification to learn. My recommendation? Just go with [bootc][bootc].

Our main problem with bootc is the immutability of the filesystem. Can somebody
please help me understand whether the immutable filesystem is a fundamental
building block, a key piece of technology that enables bootable containers, or
whether it is an unrelated feature? If it is technologically possible, our team
would love to see officially supported mutable bootc base images. Currently, we
are going forward with a
[hack to make the root filesystem transient][transient-filesystem].

One of the issues that probably stems out of the immutable filesystem is the
necessity to [change the default location of the RPM database][rpm-database].
This hack is baked into the bootc base images and we needed to revert it because
it causes Mock to fail under some specific circumstances. This unfortunately
cost us many many hours of debugging.

The process of building system images is quite storage intensive in
`/var/lib/containers` and `/run`. To avoid running out of disk space on our
virtual machines, we had to
[turn our swap partition into a data volume][disk-workaround] and mount the
problematic directories there. Not sure if there is something that
`image-builder` can do to make this a less of problem.

We build the system images natively on VMs of the same architecture that they
are targeted for, but then we fetch all of them to an x86_64 machine and upload
the images to the respective clouds from there. We discovered a
[bug in cross-arch upload to AWS][cross-arch-upload], which was promptly
confirmed and fixed by the [image-builder team][image-builder-team]. Big
customer satisfaction right here.

We also struggled with setting up AWS permissions for the `image-builder upload`
command to work correctly.  We tried running it, fixing the insufficient
permissions it complained about, running it again, and again, and so on.  I
don't recommend this approach. It turns out there is a
[documentation page with instructions][aws-upload-docs].

I hope this chapter doesn’t come across as too discouraging. In fact, we found
workarounds for all of our problems, and we are now happily using this in
production. So you can probably too.


[farm-2021]: https://pavel.raiskup.cz/blog/copr-farm-of-builders.html
[how-to-upgrade-builders]: https://github.com/fedora-copr/copr/blob/4221580a0fe1d30116e5841ff5eafe27bf9baead/doc/how_to_upgrade_builders.rst
[fedora-cloud]: https://fedoraproject.org/cloud/download
[praiskup-helpers]: https://github.com/praiskup/helpers/
[guestfish-hacks]: https://github.com/praiskup/helpers/blob/5a207be90dbd9358c7d35b1b1a664a6461d91119/bin/eimg-prep.in#L39-L86
[upload-qcow2-images]: https://pagure.io/fedora-infra/ansible/blob/48f66663a43f3a3407278d21b7d4957ed29f1d1c/f/roles/copr/backend/templates/provision/upload-qcow2-images
[ibmcloud]: https://cloud.ibm.com/docs/cli/index.html
[ibmcloud-not-foss]: https://github.com/IBM-Cloud/ibm-cloud-cli-release/issues/162
[ibmcloud-container]: https://github.com/praiskup/ibmcloud-cli-fedora-container
[prepare-s390x]: https://pagure.io/fedora-infra/ansible/blob/5aea865ef90c0bfbe5b7626aeb14e932fbf40c0f/f/roles/copr/backend/files/copr-prepare-s390x-image-builder
[copr-image]: https://github.com/praiskup/helpers/blob/main/bin/copr-image.in
[bootc-readme]: https://github.com/fedora-copr/copr-image-builder/blob/main/README-bootc.md
[bootc-image-builder-action]: https://github.com/osbuild/bootc-image-builder-action
[gitlab-runners]: https://docs.gitlab.com/runner/
[builds-a-day]: https://copr.fedorainfracloud.org/status/stats/
[builders-at-once]: https://download.copr.fedorainfracloud.org/resalloc/pools
[blueprint]: https://osbuild.org/docs/user-guide/blueprint-reference/
[transient-filesystem]: https://github.com/fedora-copr/copr-image-builder/commit/1fcbff98f59a7832ec5d008c5ec850998280ebe4
[rpm-database]: https://github.com/fedora-copr/copr-image-builder/commit/1965820aeed581592525a4fd0fa4d55625151b4d
[disk-workaround]: https://github.com/fedora-copr/copr-image-builder/blob/9311d0abb54881eb5145f4b601192df426e4cd11/prepare-worker
[cross-arch-upload]: https://github.com/osbuild/image-builder-cli/pull/218
[aws-upload-docs]: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/image_builder_guide/chap-documentation-image_builder-test_chapter5
[blueprint-vs-api]: https://issues.redhat.com/browse/HMS-4884
[packit-integration]: https://packit.dev/docs/cli/build/in-image-builder
[bootc-image-builder]: https://quay.io/repository/centos-bootc/bootc-image-builder
[containerfile]: https://github.com/fedora-copr/copr-image-builder/blob/main/Containerfile
[snthrailkill]: https://accounts.fedoraproject.org/user/snthrailkill/
[image-builder]: https://osbuild.org/
[bootc]: https://docs.fedoraproject.org/en-US/bootc/getting-started/
[image-builder-team]: https://github.com/osbuild
[instance-to-ami]: https://github.com/praiskup/resalloc-aws/blob/fe2d666501b33cb3775206790b714ef5551b41de/bin/resalloc-aws-new#L327-L342
