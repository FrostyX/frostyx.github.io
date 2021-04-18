---
layout: post
title: Running fedora-review after Copr build
lang: en
tags: dev copr fedora fedora-review packaging
---

The single most requested feature in the last Copr RFE survey was support
for an automatized running of the `fedora-review` tool after builds. We finally
deployed it into production.


## Why is it relevant

Many people use [Copr][copr] as a stepping stone towards getting their packages
into the official Fedora repositories. The
[Package Review Process][package-review-process] can take a while and
Copr is often used for testing the package before it goes to Fedora, and as a
temporary repository for users. One of the mandatory steps of the review
process is checking the package with the `fedora-review` tool. Typically,
this needs to be done manually in the command line but it is not the
only option anymore!


## Running fedora-review

Copr allows you to opt-in for automatically running the `fedora-review`
tool after each build in a given project. See your project settings for the
following option.

<div class="text-center img-row row">
  <a href="/files/img/fedora-review-project-settings.png">
    <img src="/files/img/fedora-review-project-settings.png"
         alt="Enable fedora-review in the project settings" />
  </a>
</div>

Alternatively, you can modify your project in the command-line

```bash
copr-cli modify frostyx/ueberzug --fedora-review on
```

Or create a new project specifically for the review

```bash
copr-cli create frostyx/ueberzug-review --chroot fedora-rawhide-x86_64 --fedora-review
```

The build status is not affected by the `fedora-review` result,
i.e. the build is not marked as failed just because of a failed
review. It's up to the user to examine the results. Click on the
`review.txt` link for the chroot that you are interested in (most
likely Fedora Rawhide) to see the full output.

<div class="text-center img-row row">
  <a href="/files/img/fedora-review-results-table.png">
    <img src="/files/img/fedora-review-results-table.png"
         alt="See the review.txt log in build results" />
  </a>
</div>

The `review.txt` contains instructions for how to work with the
report. When submitting a
[request for review in Bugzilla][request-for-review-in-bugzilla], you will
download this file from Copr to your computer, edit it as instructed in its
preamble, and then paste it as a comment in the Bugzilla request.

<div class="text-center img-row row">
  <a href="/files/img/fedora-review-txt.png">
    <img src="/files/img/fedora-review-txt.png"
		 alt="Fedora review output" />
  </a>
</div>


## What's next?

Our goal is to make the [Package Review Process][package-review-process]
for Copr users as simple and automatized as possible. In the next step, we are
going to focus on a simplified form for creating review-related projects. The
idea is to provide just a project name and the rest of the settings will be
pre-configured appropriately.

The end-game dream is to have an integration allowing to submit and update a
[review request][request-for-review-in-bugzilla] directly from
[Copr][copr].



[copr]: https://copr.fedorainfracloud.org/
[package-review-process]: https://fedoraproject.org/wiki/Package_Review_Process
[request-for-review-in-bugzilla]: https://bugzilla.redhat.com/bugzilla/enter_bug.cgi?product=Fedora&format=fedora-review
