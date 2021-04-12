---
layout: post
title: Running fedora-review after Copr build
lang: en
tags: dev copr fedora fedora-review
---

The single most requested feature in the _Copr whatever survey_ was
support for automated running of `fedora-review` tool after builds. We
finally deployed it into production.


## Why you should care

Many people use Copr as a stepping stone towards getting their package
into the official Fedora repositories. The
[Package Review Process][package-review-process] can take a while and
Copr is often used as a temporary host and a place where to test the
package before it goes to Fedora. One of the mandatory steps of this
process is reviewing the package with `fedora-review` tool. Typically,
this needs to be done manually in the command-line but it is not the
only option anymore!


## Running fedora-review

Copr allows you to opt-in for automatically running `fedora-review`
tool after each build in a given project.

<div class="text-center img-row row">
  <a href="/files/img/fedora-review-project-settings.png">
    <img src="/files/img/fedora-review-project-settings.png"
         alt="Enable fedora-review in the project settings" />
  </a>
</div>

Alternativelly, you can modify your project in the command-line

```bash
copr-cli modify frostyx/ueberzug --fedora-review on
```

Or create a new project specifically for the review

```bash
copr-cli create frostyx/ueberzug-review --chroot fedora-rawhide-x86_64 --fedora-review
```

The build status is not affected by the `fedora-review` result,
i.e. the build is not marked as failed because of a failed
review. It's up to the user to examine the results. Click on the
`review.txt` link for the chroot that you are interested in (most
likely Fedora Rawhide).

<div class="text-center img-row row">
  <a href="/files/img/fedora-review-results-table.png">
    <img src="/files/img/fedora-review-results-table.png"
         alt="See the review.txt log in build results" />
  </a>
</div>

The `review.txt` contains instructions how to work with the
report. When submitting the package into the official Fedora
repositories, you will download this file from Copr to your computer,
edit it as instructed in its preamble and then paste it into your
[request for review in bugzilla][request-for-review-in-bugzilla].

<div class="text-center img-row row">
  <a href="/files/img/fedora-review-txt.png">
    <img src="/files/img/fedora-review-txt.png"
		 alt="Fedora review output" />
  </a>
</div>


## What's next?

TODO


[package-review-process]: https://fedoraproject.org/wiki/Package_Review_Process
[request-for-review-in-bugzilla]: https://bugzilla.redhat.com/bugzilla/enter_bug.cgi?product=Fedora&format=fedora-review
