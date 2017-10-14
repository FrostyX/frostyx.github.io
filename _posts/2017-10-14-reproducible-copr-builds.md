---
layout: post
title: Reproducible Copr builds
lang: en
categories: dev copr fedora
---

Well, sort of. Has your package failed to build in [Copr](http://copr.fedoraproject.org/)? We introduce a new tool called `copr-rpmbuild` which allows you to reproduce it locally and make the debugging process much easier.


## Behold copr-rpmbuild

`copr-rpmbuild` is a simple tool for reproducing Copr builds. Upon your needs, it can produce SRPM or RPM package. The best thing is that we use this tool internally within Copr infrastructure, so you can be sure that it reproduces the build under exactly same conditions.

The basic usage is straightforward

	copr-rpmbuild --build-id <id> --chroot <name>

This will obtain a task definition from Copr and attempt to build RPM package into `/var/lib/copr-rpmbuild/results/` directory. Except the binary package itself, there are also generated mock configs and logs.

If you are interested only in SRPM package, use

	copr-rpmbuild --srpm --build-id <id>


## Disclaimer

Did I get you on the buzzword _reproducible builds_? Well, let me clarify what does it mean in this context. Copr stores a definition of every build. We call such definition a _build task_, and it contains information needed to create the desired buildroot and produce a package in it. For instance, there is a name of mock chroot that should be used, what repositories should be allowed there, what packages should be installed, ... and of course information about what is going to be built in it.

The meaning of _reproducing_ a build is creating a local build from the same task as the original one. It is not guaranteed that the output will always be a 100% same. It may vary when using a different mock version or non-standard configuration on a client side and in situations when the package operates with build timestamp of itself.


## Configuration

When no other config is specified, the pre-installed `/etc/copr-rpmbuild/main.ini` is used. This is also a configuration file used in Copr stack. You can specify a different config file by `--config <path>` parameter. Such config doesn't necessarily have to contain all the possible options, just the ones that you want to change. Let me suggest two alternative configurations


### User-friendly paths

Do not touch system directories.

	[main]
	resultdir = ~/copr-rpmbuild/results
	lockfile = ~/copr-rpmbuild/lockfile
	logfile = ~/copr-rpmbuild/main.log
	pidfile = ~/copr-rpmbuild/pid


### Different Copr instance

Use Copr [staging](http://copr-fe-dev.cloud.fedoraproject.org/) instance as an example.

	[main]
	frontend_url = http://copr-fe-dev.cloud.fedoraproject.org
	distgit_lookaside_url = http://copr-dist-git-dev.fedorainfracloud.org/repo/pkgs
	distgit_clone_url = http://copr-dist-git-dev.fedorainfracloud.org/git


## Examples
<pre class="prettyprint lang-bash">
# Default usage
copr-rpmbuild --build-id 123456 --chroot fedora-27-x86_64

# Build only SRPM package
copr-rpmbuild --srpm --build-id 123456

# Use different config
copr-rpmbuild -c ~/my-copr-rpmbuild.ini --build-id 123456 --chroot fedora-27-x86_64
</pre>
