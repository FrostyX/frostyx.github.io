---
layout: post
title: Module hotfixes in Copr
lang: en
tags: dev copr fedora modularity
---

The rise of Fedora Modularity helped us solve some difficulties, but at the same time brought a new set of unique problems. One of them is a need for `module_hotfixes` repositories.


## What's the problem anyway?

The package version resolution was straightforward in the pre-modularity era. If multiple repositories provided the same package, the one with the highest version was preferred.

[It is more complicated now][package-filtering]. If there is a module stream enabled within the system and this stream provides a package, it is preferred over its non-modular variant regardless of its version. This may be a very surprising behavior for many people, so please let me reiterate it once more - DNF will filter out all newer package versions from non-modular repositories if you have it installed as a part of a module.

However, as it turned out, we occasionally need to override module packages by _regular_ ones. For this very reason, `module_hotfixes` repositories were introduced and DNF will upgrade to higher version packages from these repositories.


## Copr

[By now][PR], it is possible to have `module_hotfixes` repositories also in [Copr][copr]. There is the following checkbox in your project settings:

    [ ] This repository contains module hotfixes
        This will make packages from this project available on along with
        packages from the active module streams.

You can also modify this option via command line:

    copr-cli modify frostyx/foo --module-hotfixes on

Then the end-user repository looks like this:

    [copr:copr.fedorainfracloud.org:frostyx:foo]
    name=Copr repo for foo owned by frostyx
    ...
    module_hotfixes=1

Additionally, if any other project uses this one as an external repository (by `copr://frostyx/foo`), then the `module_hotfixes=1` setting will be used also at the build time.


[package-filtering]: https://dnf.readthedocs.io/en/latest/modularity.html#package-filtering
[copr]: https://copr.fedorainfracloud.org/
[PR]: https://pagure.io/copr/copr/pull-request/1097
