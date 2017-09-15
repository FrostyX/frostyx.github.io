---
layout: post
title:
lang: en
categories: dev copr fedora modularity
---

Has your package failed to build in Copr?
_Some more catchy perex and title here_


## Behold copr-rpmbuild

`copr-rpmbuild` is a simple tool for reproducing Copr builds. Upon your needs, it can produce SRPM or RPM package. The best thing is that we use this tool internally within Copr infrastructure, so you can be sure that it reproduces the build under the exactly same conditions.

The basic usage is straightforward

	copr-rpmbuild <task-id>

This will obtain a task (wait, what is _task_? [Read further](#)) from [Copr](#) and attempt to build RPM package into `/var/lib/copr-rpmbuild/results/` directory. Except from the binary package itself, there are also generated mock configs and logs.

If you are interested only in SRPM package, use

	copr-rpmbuild --srpm <build-id>


## Configuration

When no other config is specified, the pre-installed `/etc/copr-rpmbuild/main.ini` is used. This is also a configuration used in Copr stack. You can specify different config file by `--config <path>` parameter. Such config doesn't necessarily have to contain all the possible options, just the ones that you want to change. Let me suggest two alternative configurations


### User-friendly paths

Do not touch to system directories.

	[main]
	resultdir = ~/copr-rpmbuild/results
	lockfile = ~/copr-rpmbuild/lockfile
	logfile = ~/copr-rpmbuild/main.log
	pidfile = ~/copr-rpmbuild/pid


### Different Copr instance

Use Copr [staging](#) instance as an example.

	[main]
	frontend_url = http://copr-fe-dev.cloud.fedoraproject.org
	distgit_lookaside_url = http://copr-dist-git-dev.fedorainfracloud.org/repo/pkgs
	distgit_clone_url = http://copr-dist-git-dev.fedorainfracloud.org/git


## Copr tasks

Finally, let's talk about what copr tasks are and how to identify them. Tasks describe every information needed for creating build environment and producing a RPM package in it. e.g. which mock chroot should be used, what repositories should be allowed there, what packages should be installed, ... and of course information about what is going to be built.

Such task is identified with `task-id` which is combination of `<build-id>-<chroot-name>` (e.g. 123456-fedora-27-x86_64).


## Examples
<pre class="prettyprint lang-bash">
# Default usage
copr-rpmbuild 123456-fedora-27-x86_64

# Build only SRPM package
copr-rpmbuild --srpm 123456

# Use different config
copr-rpmbuild -c ~/my-copr-rpmbuild.ini 123456-fedora-27-x86_64
</pre>
