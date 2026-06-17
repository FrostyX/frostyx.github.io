---
layout: post
title: Making the Fedora Review Process suck less
lang: en
tags: fedora packaging
---

The Fedora Review Process is clunky, archaic, and not on par with what we expect
when contributing to Open Source projects in this century. We all know that, and
we all want it to improve. That being said, discussions about this topic
usually focus on being more user-friendly to the contributors.

Miro Hrončok was the only I've heard saying that more importantly, we need to
make the process more friendly for the reviewers. Because the most important
issue is actually our inability to effectively review the packages that are
already in the queue.

In this blog post I am going to elaborate on the ideas that we (mostly Miro)
came up with, shooting shit in the hallway at Flock to Fedora 2026.


## Proposing new packages through PRs

This is an obvious one, we've talked about the same with zbysek on Flock to
Fedora 2025. It is a necessary prequisite for any potential improvements.

Proposing new packages through PRs would be trivial if we had a monorepo with
all Fedora packages. Which we don't, and we probably don't want to.

As a workaround, we discussed having a special repository on
forge.fedoraproject.org into which we would propose new packages. It would have
Packit CI enabled, and therefore every proposed package would automatically get
a scratch build and a test suite run on top of it. Currently supported are TODO,
and we know that adding new tests is easy. Of course a final approval from a
fellow package maintainer would still be needed.

Once accepted, we would merge the PR, get the package into DistGit, and delete
all data from this repository to keep it clean.


## Bulk review

The review queue is, and always has been in hundreds. Many of the packages are
dependencies for something else and people have no motivation to review them
separately. And even if they do, it's not always easy to test them on their
own. This currently leads to accepting broken packages that nobody tested or
ignoring the tickets completely.

We discussed the possibility to propose multiple packages within one PR. They
could be reviewed, tested, and accepted all at once.

For such PRs we could automatically create a new project in Copr and build the
packages in the order they were committed. We could nicely use Copr build
batches feature here. If multiple packages were added in one commit, they
could be built in parallel. If the contributor decides to force-push into
their PR, we would wipe the Copr project and start over.


## Auto import into DistGit

There is no reason why would the contributor had to manually run

```
TODO
```

We can request all the DistGit repositories and branches for them. And once they
are created, we can automatically import the packages. There are some open
questions though. How can the contributor signalize what branches they want?
Should we use the git history from the PR? Can we use Forgejo actions to trigger
the requests and imports?

## Proposal vs PoC

I realize this is not a formal proposal but merely a blog post on my personal
website. That was an intentional decision. We've been discussing and
bike-shedding this topic for years, and have nothing to show for it. I am
writing this article mainly to not forget the ideas we've had, but the first
chance I get, I am going to implement a proof of concept and record a demo for
you.

It doesn't have to be perfect, we just need to kick this off and implement
something small that works and can be improved as the time goes.
