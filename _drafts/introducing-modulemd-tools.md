---
layout: post
title: Introducing modulemd-tools
lang: en
categories: dev copr fedora modularity
---

If you have been following what is happening in the Fedora world for the past few years, the [Fedora Modularity][fedora-modularity] project couldn't escape your eye. It has been a subject of many discussions, opinions, and critique. I am pleased to tell you, that the biggest pain points (at least for me) are finally being addressed.


## Background

A lot of teams are involved in the development of Fedora Modularity and vastly more people are affected by it as packagers and end-users. It is obvious, that each group has its own priorities, use-cases and therefore different opinions on what is good or bad about the current state of the project. Personally, I was privileged to represent yet another, often forgotten, group of users - third-party build systems.

Our team is directly responsible for the development and maintenance of Copr and a few years ago we decided to support building modules alongside building just regular packages. We stumbled upon many frustrating pitfalls that I don't want to discuss right now but the major one was definitely not enough tools for working with modules. That was understandable in the early stages of development but it has been years and we still don't have tools for building modules on our own, without relying on the Fedora infrastructure. You may [recall me expressing the need][frostyx-flock-2019] for them at the Flock 2019 conference.

Well, brace yourselves, the change is coming. We are now introducing [modulemd-tools][modulemd-tools].


## Modulemd-tools

The simple fact is, that module YAML definitions are meant to be (partially) generated, and up until now there was no tool for doing so. That affected everyone building modules on their own. We are now introducing a project called [modulemd-tools][modulemd-tools] which is a collection of small tools for parsing and generating modulemd YAML files. It is now packaged in Fedora so you can easily install it.

```bash
dnf install modulemd-tools
```

So far it provides two scripts and it is up to you to pick which suits you best.


## dir2module

This script takes essential module information such as its name, stream, version, architecture, etc from the command line parameters. Then it either recursively finds all RPM packages within a specified directory or reads a list of them from a text file. Then it generates a module definitions to a YAML file or to the standard output.

Its simple usage might look like this.

```bash
$ dir2module foo:devel:123:f32:x86_64 -m "Summary and stuff" --dir .

Created foo:devel:123:f32:x86_64.modulemd.yaml
```

The first positional parameter is a string in NSVCA format, for more information see [NSVCA vs NEVRA][NSVCA-vs-NEVRA]. Now, the more complicated example specifying a license and requirements and what not can look like this.

```bash
$ dir2module foo:devel:123:f32:x86_64 -m "Summary and stuff" --dir ~/rpmbuild/RPMS/ -l GPLv2 -r mod1:stream1 -r mod2:stream2 --force --stdout

---
document: modulemd
version: 2
data:
  name: foo
  stream: devel
# ...
```


## repo2module

The point of `repo2module` is the same as for the previous script - it generates a module YAML definition based on some input parameters. The difference is that it doesn't work on a directory-level but rather takes an existing YUM repository in its input.

```bash
$ repo2module --module-name=testmodule --module-stream=stable . modules.yaml
```


## What's next?

That's up to you. What specific tasks regarding modulemd YAML generation or parsing do you do? Share them with us. On our current roadmap is to implement [modularity support into createrepo_c][RHBZ-1795936] and then replace all the custom [code in Copr][copr-pagure] by using these tools and help other build system developers to do the same. In the endgame, all Copr, [OBS][obs], and [MBS][mbs] will internally use the same tooling, and therefore it is going to be safe for you, users, to start using them as well because they will become de-facto a standard.



[fedora-modularity]: https://docs.fedoraproject.org/en-US/modularity/
[frostyx-flock-2019]: http://frostyx.cz/posts/flock-report-2019#modularity
[modulemd-tools]: https://github.com/rpm-software-management/modulemd-tools
[NSVCA-vs-NEVRA]: https://docs.fedoraproject.org/en-US/modularity/architecture/nsvca/
[RHBZ-1795936]: https://bugzilla.redhat.com/show_bug.cgi?id=1795936
[copr-pagure]: https://pagure.io/copr/copr/
[obs]: https://openbuildservice.org/
[mbs]: https://pagure.io/fm-orchestrator
