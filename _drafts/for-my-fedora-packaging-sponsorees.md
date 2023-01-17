---
layout: post
title: For my Fedora packaging sponsorees
lang: en
tags: fedora packaging
---

You have just been sponsored to the Fedora `packager` group and your
review ticket was formally granted the `fedora-review+` flag?


## Finishing the review

Go back to the [Package Review Process][package-review-contributor]
documentation page. We already completed the following steps

> - The reviewer will review your package [...] Once the reviewer is happy
>    with the package, the fedora-review flag will be set to +, indicating
>    that the package has passed review.
>
> - If you have not yet been sponsored, request sponsorship by raising an
>    issue at packager-sponsors.

Continue by configuring `fedpkg` and requesting a DistGit repository
for your package.


## DistGit

You will maintain your Fedora package within a DistGit
repository. Please [read more about DistGit][distgit-readme] and
[about fedpkg][fedpkg], its client tool.

Here is how a [typical packaging session][typical-fedpkg-session]
looks like, but I recommend a different approach.

Let's say that you want to update to a new upstream version of the
package (or add your initial package after the review).

You already know how to create a SRPM file, so do it your favorite
way. Be it [tito][tito], [rpmbuild][rpmbuild], download it from
[Copr][copr], etc.


```bash
# Do any changes in the spec file that you need
# (You don't have to use vim)
vim foo.spec

# Your package is named `foo` in this example.
file /path/to/your/foo.src.rpm
```

```
# You will probably do this just once
fedpkg clone foo
cd foo

# Upload the new sources and commit the new spec file
fedpkg import /path/to/your/foo.src.rpm
fedpkg show

# Push the spec changes and build for rawhide
fedpkg push
fedpkg build
```

You need to update each branch, and submit a build for it manually. Do
this for every branch.

```
fedpkg switch-branch f37
git rebase rawhide
fedpkg push
fedpkg build
```

After you submited all builds, go to the [Bodhi][bodhi] website and
create a [New Update][bodhi-new-update]


## Copr or Mock

Before building package in [Koji][koji], it is a good idea to build it
in [Copr][copr] or [Mock][mock] and fix any potential bugs. We have a
nice [screenshot tutorial on how to use
Copr][copr-sreenshot-tutorial], and
[using Mock is easy as well][using-mock-is-easy].



[package-review-contributor]: https://docs.fedoraproject.org/en-US/package-maintainers/Package_Review_Process/#_contributor
[distgit-readme]: https://github.com/release-engineering/dist-git/blob/main/README.md
[fedpkg]: https://docs.fedoraproject.org/en-US/package-maintainers/Package_Maintenance_Guide/
[typical-fedpkg-session]: https://docs.fedoraproject.org/en-US/package-maintainers/Package_Maintenance_Guide/#typical_fedpkg_session
[copr]: https://copr.fedorainfracloud.org/
[mock]: https://rpm-software-management.github.io/mock/
[koji]: https://koji.fedoraproject.org/koji/
[bodhi]: https://bodhi.fedoraproject.org/
[copr-screenshot-tutorial]: https://docs.pagure.org/copr.copr/screenshots_tutorial.html
[using-mock-is-easy]: http://frostyx.cz/posts/using-mock-is-easy
[bodhi-new-update]: https://bodhi.fedoraproject.org/updates/new
