---
layout: post
title: Please keep fedora-review alive
lang: en
tags: fedora packaging fedora-review
---

The `fedora-review` is an essential tool for reviewing new Fedora packages. It
helps us ensure that they are of a good enough quality, don't violate any
licenses, and don't unpleasantly surprise our users. And it needs more
developers.


## Stats

Thousands of new packages are added to Fedora every year and approximately half
of them are reviewed using the `fedora-review` tool. Every year, a couple of
hundred packages are created using a spec file generator
(e.g. [rust2rpm][rust2rpm]) and reviewers often shortcut the process using their
own [simplified checklist][simplified-checklist]. The rest of the packages are
not being reviewed via the `fedora-review` tool for reasons that I can only
speculate. You can check [how I obtained the data][chart-readme].


<div class="text-center img">
  <img src="/files/img/fedora-review-stats/chart.png" alt="" />
  <p>
    Package reviews throughout the years and
    <code>fedora-review</code> usage in the blue color.
  </p>
</div>


Unfortunately, the [fedora-review][fedora-review] project doesn't receive as
much love and attention it needs. All of the current maintainers are prominent
members of the Fedora community, and as such, they are occupied with other
high-priority projects, leaving the <br>`fedora-review` as a _side gig_. In any
case, big thanks to every one of them for making the time to work on this
project at all. It's appreciated.


## We really need it

According to the [Package Review Guidelines][package-review-guidelines],
reviewers need to go through a checklist of 31 items that every new package
**must**, and 9 items that it **should** comply with. On top of this, there are
additional checks based on the programming languages used for the package source
code. They are more loosely defined but for example, I found at least
[28 items for python][python-packaging-guidelines].

Let's take a closer look at one of the more amusing items on the checklist for
every package.

> **MUST**: The package must meet the Packaging Guidelines .

The Fedora [Packaging Guidelines][fedora-packaging-guidelines] is a
**738 pages long** document (It is a website actually, so I saved each subpage
into PDF and counted the pages). Moreover, it is a live document, so every
reviewer needs to keep up with the changes.

I think that we can agree that without any automation, this is a lot of manual
labor. That's where the [fedora-review][fedora-review] tool comes in handy. It
cuts down the number of manual checks to about half. I also think we didn't reach
its limits yet, many more checks can be (semi)automatized, it's _only_ a matter
of implementing it.

Do the math - If implementing one check costs 2 hours of developer time, and it
saves one minute to a reviewer - with 1000 reviews per year, that's 16 hours
saved per year.

Additionally, the [Fedora Review Service][fedora-review-service] now
automatically runs `fedora-review` for each package review ticket, saving the
reviewers even more time.


Every `fedora-review` improvement saves us time and money, please keep
developing it.


[chart-readme]: https://github.com/FrostyX/frostyx.github.io/tree/master/files/img/fedora-review-stats/README.md
[package-review-guidelines]: https://docs.fedoraproject.org/en-US/packaging-guidelines/ReviewGuidelines/
[python-packaging-guidelines]: https://docs.fedoraproject.org/en-US/packaging-guidelines/Python/
[fedora-packaging-guidelines]: https://docs.fedoraproject.org/en-US/packaging-guidelines/
[fedora-review]: https://pagure.io/FedoraReview
[fedora-review-service]: https://github.com/FrostyX/fedora-review-service
[rust2rpm]: https://pagure.io/fedora-rust/rust2rpm
[simplified-checklist]: https://bugzilla.redhat.com/show_bug.cgi?id=2150616#c1
