---
layout: post
title: Making the Fedora Review Process suck less
title: Fedora Package Review Process reimagined
lang: en
tags: fedora packaging
updated: 2026-07-08
---

The [Fedora Package Review Process][package-review-process] is clunky, archaic,
and not on par with what we expect when contributing to Open Source projects in
this century. We all know that, and we all want it to improve. That being said,
we need to realize what is currently our main bottleneck. Even though the
process is not friendly to new contributors, they are doing just fine - at all
times, [we have hundreds of new packages in the queue][queue]. Our biggest
problem is our inability to effectively review them.

I don't think we talk about this problem enough. That's why it felt so
validating to hear [Miro Hrončok][mhroncok] voice my exact thoughts during the
[Flock to Fedora 2026][flock-2026] keynote.

In this blog post, I am going to elaborate on the ideas that we (mostly Miro)
came up with, shooting shit in the hallway after the session.


## Proposing new packages through PRs

This is an obvious one, we talked about the same idea with
[Zbigniew Jędrzejewski-Szmek][zbyszek] at [Flock to Fedora 2025][flock-2025]. It
is a necessary prerequisite for any potential improvements, which will allow us
to have a workflow that contributors are familiar with, inline code comments,
CI/CD, and other things that are not possible in Bugzilla.

Proposing new packages through PRs would be trivial to implement if we
had all Fedora packages in a monorepo. Which we don't, and we probably
don't want to have. And even if we wanted to have, it would require
massive changes throughout the ecosystem.

As a workaround, we discussed having an intermediate repository on the
[forge.fedoraproject.org][forge] into which we would only propose new
packages. It would have [Packit CI][packit-ci] enabled, and therefore every
proposed package would automatically get a scratch build and a test suite run on
top of it. Currently
[supported tests are rpmlint, rpminspect, and license-validate][supported-tests].
We know that adding new tests is easy, as I am currently working on support for
[fedora-review][fedora-review].

Of course, a final approval from a fellow package maintainer would still be
needed. Once accepted, we would merge the PR and automatically create a new
DistGit repository and import the package. Then we would delete all data from
the intermediate repository to keep it clean.


## Bulk review

The review queue is and always has been in hundreds. Many of the packages are
dependencies for something else, and people have no motivation to review them
separately. And even if they do, it's not always easy to test them on their
own. This currently leads to accepting broken packages that nobody tested or
ignoring the tickets completely.

We discussed the possibility of proposing multiple packages within one PR. They
could be reviewed, tested, and accepted all at once.

For such PRs, we could automatically create a new project in Copr and build the
packages in the order they were committed. We could nicely use
[Copr's build batches feature][build-batches] here. If multiple packages were
added in one commit, they could be built in parallel. If the contributor decides
to force-push into their PR, we would wipe the Copr project and start over.


## Auto import into DistGit

There is no reason why the contributor would have to manually run

```bash
fedpkg request-repo my-package 12345
fedpkg request-branch --all-releases

fedpkg clone foo
cd foo
fedpkg import /path/to/the/foo.src.rpm
fedpkg push
fedpkg build

fedpkg switch-branch f44
git rebase rawhide
fedpkg push
fedpkg build
# ...
# repeat for f43, f42, etc
```

We can request all the DistGit repositories and branches for them. And once they
are created, we can automatically import the packages. There are some open
questions though. How can the contributor signalize what branches they want?
Should we use the git history from the PR? Can we use Forgejo actions to trigger
the requests and imports?

## Proposal vs prototype

I realize this is not a formal proposal but merely a blog post on my personal
website. That was an intentional decision. We've been discussing and
bike-shedding this topic for years, and yet we don't have much to show for it. I
am writing this article mainly not to forget the ideas we've had, and even
though I am interested in your thoughts, this is not an RFC. I already started
implementing a prototype, and soon I'll record a demo for you. Then, I'll start
bothering you and asking for feedback.

In my opinion, it doesn't have to be perfect. We just need to kick this off,
implement something small that works, and improve it as time goes.

Maybe I should also say that I am not aiming to replace the current
[Package Review Process][package-review-process]. My goal is to provide an
alternative version of this process and allow contributors to choose which one
they want to follow. Then, someday in the future, if the alternative turns out
to be popular, possibly deprecating the old review process.


[package-review-process]: https://docs.fedoraproject.org/en-US/package-maintainers/Package_Review_Process/
[queue]: https://fedoraproject.org/PackageReviewStatus/reviewable.html
[mhroncok]: https://github.com/hroncok
[zbyszek]: https://fedoraproject.org/wiki/User:Zbyszek
[flock-2026]: https://frostyx.cz/posts/flock-to-fedora-report-2026
[flock-2025]: https://frostyx.cz/posts/flock-to-fedora-report-2025
[forge]: https://forge.fedoraproject.org/
[packit-ci]: https://communityblog.fedoraproject.org/packit-as-fedora-dist-git-ci-final-phase/
[supported-tests]: https://github.com/packit/tmt-plans/tree/main/tests
[fedora-review]: https://github.com/packit/tmt-plans/tree/main/tests/fedora-review
[build-batches]: https://docs.copr.fedorainfracloud.org/user_documentation.html#build-batches
