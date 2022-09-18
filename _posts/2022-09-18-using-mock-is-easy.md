---
layout: post
title: Using Mock is easy
lang: en
tags: fedora mock howto packaging
---

There are a lot of articles and documentation pages explaining how to
use [Mock][mock] but I am hesitant to share them with new Fedora
packagers because they make the tool look much scarier than it
actually is. Using Mock is easy!


## Why Mock?

Unlike `rpmbuild` which builds packages directly on your computer
without any isolation, [Mock][mock] spawns a container with a minimal
build environment and builds your package inside. As a consequence:

- A bug in the package won't break your system
- Two people building a package on different computers will _always_
  get the same results
- All `BuildRequires` that you forgot to put into the spec file will
  be revealed


## Setup

Install Mock from the Fedora repositories.

```
sudo dnf install mock
```

By default, Mock can be used only by the root user. Please don't run
it with `sudo` and instead add yourself to the `mock` group.

```
sudo usermod -a -G mock $USER
newgrp mock
```

## Usage

Mock takes an SRPM and produces an RPM package for a given Fedora
version and architecture. If you don't have an SRPM package yet, you
need to build it from a spec file first.

```
rpmbuild -bs /path/to/your/foo.spec
```

And pass the resulting SRPM to Mock.

```
mock /path/to/your/foo.src.rpm
```

By default Mock builds the RPM packages for the Fedora version and
architecture that matches your system. If you want to specify a
different target, use the `-r` parameter and press `<TAB>` twice to see
all the possible options.


## Read further

If interested, you can read more about Mock
[configuration files][mock-config-files],
[containers][mock-containers],
[plugins][mock-plugins],
and other [features][mock-features].

In case you want to build your packages using Mock but you don't want
to do it on your computer, use [Copr][copr]. It's easy, just
follow this [screenshot tutorial][copr-screenshot-tutorial].


[mock]: https://github.com/rpm-software-management/mock/
[mock-config-files]: https://rpm-software-management.github.io/mock/configuration
[mock-containers]: https://rpm-software-management.github.io/mock/#mock-inside-podman-fedora-toolbox-or-docker-container
[mock-plugins]: https://rpm-software-management.github.io/mock/#plugins
[mock-features]: https://rpm-software-management.github.io/mock/#features
[copr]: https://copr.fedorainfracloud.org/
[copr-screenshot-tutorial]: https://docs.pagure.org/copr.copr/screenshots_tutorial.html
