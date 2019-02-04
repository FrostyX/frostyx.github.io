---
layout: post
title: Removing outdated chroots
lang: en
categories: copr fedora
---

This article explains what does removing outdated chroots in Copr means and why it is a good thing. It will help you understand our motivation to for doing it, as well as your new responsibilities in case you keep some software alive even for an EOL distribution.


## Introduction

Even though Copr currently supports building packages for Fedora, EPEL, Mageia, let's talk about just Fedora to keep this article simple. The same principles apply also for other distributions, they just differ in small nuances such as lenght of release cycle.

Let's briefly talk about Fedora release cycle. There are always two stable versions (at this point F28 and F29) and rawhide. These are enabled also in Copr and you can build packages for them. Once a next version is released, the oldest one gets marked as _End Of Life (EOL)_ and it is not possible to build official packages for it and push updates. In Copr, we try to give users more time to migrate and allow them to build packages even for it for another several weeks/months. You can see, that the F27 is still enabled in Copr and it is still possible to build packages for it.

Now we are getting to the actual topic of this article. Can you guess, what happens with the repositories once the chroots for a particular EOL distribution gets disabled? Interestingly enough, nothing happens to them. If you have created a project in the humble Copr beginnings and built some packages for e.g. F21, you can still boot your old laptop and install them. As awesome as it sounds, we are planning to change this a little.


## What does it mean

Starting today, you will receive an email once upon a time, saying that some of your projects have some builds for a chroot, that is now outdated. You will be informed, that the data in the chroot are going to be deleted in N days unless you take an action. By doing so, you will be able to prolong the amount of time until the data are deleted. You will never be able to turn the garbage collector off, but if you really care about the data, you will be able to periodically prolong the time upon deletion and keep them indefinitelly.

The notification email will look like this.

<div class="text-center img">
  <a href="/files/img/upcoming-deletion-of-outdated-chroots.png">
    <img src="/files/img/upcoming-deletion-of-outdated-chroots-crop.png" alt="" />
  </a>
</div>

Of course, I got this one from devel instance, thats why there is a link to localhost. You will receive one email notifying you about all your projects. Not one email per project. We chose that to avoid unnecessary spaming.

You can read the [Copr outdated chroots removal policy](#) if this change affects you.


## Why do we need it

Long story short, we are quickly getting out of disk space. Our daily consuption continually grows and we currently store about 10GB/day. During last year we have used 2TB and we are accelerating, so for this year we are going to need even more. Assuming the same growth as in the past, we will consume up to 2.5TB and the following year up to 5TB.

See this graph of Copr data consumption since the start of the project. The data were collected by [@msuchy](#) and presented on fedora infra [mailing list](#).

<div class="text-center img">
  <a href="/files/img/copr-storage.png">
    <img src="/files/img/copr-storage-crop.png" alt="" />
  </a>
</div>

<br>
Let's see how much disk space was needed for particular Fedora releases.

| Distribution | Disk usage |
|--------------|------------|
| Fedora 21    | 82 GB      |
| Fedora 22    | 132 GB     |
| Fedora 23    | 241 GB     |
| Fedora 24    | 343 GB     |
| Fedora 25    | 438 GB     |
| Fedora 26    | 775 GB     |
| EPEL 5       | 9.7 GB     |
| EPEL 6       | 132 GB     |
{: .table .table-bordered}


<br>
We also have an idea of how much data is required for alternative architectures in comparison to intel.

| Architecture   | Disk usage |
|----------------|------------|
| ppc64le        | 307 GB     |
| x86_64, i686   | 5.5 TB     |
{: .table .table-bordered}


## What benefits it brings

So, we are going to remove something, that is a _bad_ thing. But it will have many positive consequences. Most importantly, it will allow us to survive (regarding disk space) this year. This alone, would be sufficient reason, because we are slowly running out of options to store some space. We want to also add some features. For example, from the table above we know, that alternative architectures don't require that much space and with [Mock's forcearch](https://github.com/rpm-software-management/mock/wiki/Feature-forcearch) we have a possibility to support them without having dedicated builders on that architecture. We definitely aim to support aarch64 and XY! For a quite long time we have also been discussing a possibility to build containers and btrees for Fedora silverblue project, but it always wrecked on not having enough disk space. We might revisit these ideas again.


## Resources

- [1] [Copr outdated chroots removal policy](#)
- [2] [Storage at copr-be \| infrastructure@lists.fedoraproject.org](https://lists.fedoraproject.org/archives/list/infrastructure@lists.fedoraproject.org/thread/V5NNMXNKS4KD7DPGALR5XFDN6SYJZNML/#4TPN77UWDPTKLMJLY4EM4PYXCKMQD3IU)
- [3] <https://github.com/rpm-software-management/mock/wiki/Feature-forcearch>
