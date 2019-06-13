---
layout: post
title: Dropping copr-rpmbuild SCM support
lang: en
categories: dev copr fedora
---

First of all, let me assure you that this **doesn't mean** dropping the [SCM method](https://docs.pagure.org/copr.copr/user_documentation.html#scm) from Copr itself. That is an awesome feature and will remain available. In this article, we are going to discuss only an interface for one of the Copr internal tools, `copr-rpmbuild`.

Within [Copr](https://copr.fedorainfracloud.org/) stack we use a tool called `copr-rpmbuild`. Its main purpose is to fetch a definition of a build task from [frontend](https://copr.fedorainfracloud.org/) and build SRPM or RPM package. We execute the `copr-rpmbuild` tool from dedicated OpenStack instances, that are used as builders, but it is possible to use this command anywhere and reproduce a build outside of the Copr infrastructure.

The standard usage is following:

	copr-rpmbuild --build-id <BUILD_ID> --srpm              # For SRPM
	copr-rpmbuild --build-id <BUILD_ID> --chroot <CHROOT>   # For RPM

That is how the `copr-rpmbuild` is used within Copr infrastructure. Based on `<BUILD_ID>` or `<BUILD_ID>-<CHROOT>` it is constructed an URL to a task definition, which is then fetched and processed.

Some time ago, we have added support for specifying SCM parameters directly through a command line and avoiding the requirement on communication with Copr frontned. It looked like this:

    copr-rpmbuild scm --clone-url <GIT_REPO> --chroot <CHROOT>

While the intention behind this feature was (and still is) good, the actual implementation is quite unfortunate and therefore we decided to drop it. If you are using it, don't worry, there is a replacement.


## Reasoning

But first, let's talk about what was good about `copr-rpmbuild scm` that we want to preserve and what was the reason to drop it so we can avoid the same mistake in the new implementation.

### Pros:
- It allowed building packages without needing to talk to frontend
- As a consequence, it was usable independently on official Copr instance

### Cons:
- It allowed building packages without needing a task definition. This sounds positive, but as a consequence, the task definition needed to be artificially constructed inside the `copr-rpmbuild`
- It was not used within Copr infrastructure and therefore violated the main purpose of `copr-rpmbuild`, which is reproducing Copr build the same way it was done in Copr
- To some extent, it just duplicated what [rpkg](https://pagure.io/rpkg-util) does


## Replacement

We are realizing the difficulties of using `copr-rpmbulid` with unofficial Copr instances or even using it without any frontend available (in tests or some mock environment, etc). Because of this, we are adding the following parameters.

	copr-rpmbuild --task-url <URL> --chroot <CHROOT>
	copr-rpmbuild --task-file <PATH> --chroot <CHROOT>

With `--task-url` it doesn't matter where on the internet the task is located. It is not limited to any specific Copr instance or URL format and it doesn't require any additional configuration. Similarly with `--task-file` you can use any task definition that you have locally stored. If you can, please migrate from `copr-rpmbuild scm` to one of those methods.

The last resort, if you really need to use `copr-rpmbuild` for building from SCM without having a task definition, please **inspire** yourself with the following code to create a wrapper over the `copr-rpmbuild`. It will take the SCM parameters as input and generate a task definition.

{% gist ba098eb74147842174aff59017f1af43 scm2task.py %}

Once you generate a valid task definition, you can use the new `--task-file` parameter.

{% gist ba098eb74147842174aff59017f1af43 copr-rpmbuild-scm.sh %}

Thank you for understanding.<br>
We apologize for any inconveniences.
