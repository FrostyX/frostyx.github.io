---
layout: post
title: Contribute to Copr
lang: en
tags: fedora copr
---

I had a realization on this year's DevConf. Even if people wanted to contribute
to large opensource projects, they have no idea how. Or they don't realize they
can contribute in the first place, and that such a thing would be
apreaciated. That's why I wanted to try this experiment and offer 5 interesting
RFEs for the community to implement.

## About the project

Copr is a build system and third-party package repository for RPM-based
distributions. It's similar to AUR for example. The project has been around
since 2012 and became an integral part of the Fedora packaging ecosystem, with
many conference talks and articles mentioning it. We currently host 29000
projects from 7000 Fedora users and the package downloads are in milions.


## Why you should contribute

At this moment, there are 275 valid and triaged issues and RFEs in the issue
tracker. In this board, you can see the roadmap for the next months, years, and
possible futures. To get some feature implemented sooner, the best bet is to
submit a pull request. That is one obvious reason to contribute. Another is
improving your skills as a developer. It may be more fun and more useful than
creating another TODO application from scratch. Last but not least, it's never a
bad idea to collaborate and show your skill to people who can do job
referrals. That's how I got my dream job 9 years ago. I think this is a great
opportunity for students looking to get some infield experience during the
summer break.


## Not feeling competent

Don't worry if you feel don't competent enough to contribute. We have a
documentation for setting up your local development environment, tests and a
review process to improve the code quality, and a Matrix channel for more formal
communication. If you ever get stuck during the process, please ping me and
mention this article.


## How you can contribute

You can of course pick any issue from the Copr issue tracker. Or pick any other
project for that matter. In this article, I wanted to compile a list of
interesting and useful RFEs that our team won't have time to implement in the
near future. Please let us know if you would like to collaborate with us on any
of them. We will get you started and make sure you have all the information you
need.


## 1. Validation for external repositories

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Trivial</td></tr>
  <tr><th>Required skills:</th><td>Python</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/3150">https://github.com/fedora-copr/copr/issues/3150</a></td></tr>
</table>

Copr projects can depend on other projects. Such a dependency can be specified
via a fully qualified URL or a shortcut in the `copr://owner/project` format. It
would be nice to have a validation making sure that users cannot set a
dependency on non-existing projects (due to typos for example).


## 2. Possibility to force delete a project

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Easy</td></tr>
  <tr><th>Required skills:</th><td>Python</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/2629">https://github.com/fedora-copr/copr/issues/2629</a></td></tr>
</table>

Through the Copr CLI utility, it is possible to delete an existing project with
all of its builds. This however fails when some of the builds are not yet
finished. We would like to improve the relevant API endpoint to automatically
cancel all running builds, making sure that no matter the state of the project,
it can be deleted.


## 3. Dark mode support

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Medium</td></tr>
  <tr><th>Required skills:</th><td>HTML, CSS, Javascript</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/3150">https://github.com/fedora-copr/copr/issues/3150</a></td></tr>
</table>

The Copr website offers only one theme and that is a black text on a white
background. According to many online articles, dark mode web designs are
getting increasingly more poupar, helping to reduce the eye strain and power
consumption. We would like our users to have the option to choose whether they
prefer light or dark mode of the website.


## 4. Webhook history

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Medium</td></tr>
  <tr><th>Required skills:</th><td>Python, HTML</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/304">https://github.com/fedora-copr/copr/issues/304</a></td></tr>
</table>

Copr provides integration with Git forges like GitHub, GitLab, and Bitbucket
through webhooks. When everything works smoothly, it's great. However, when
builds are not being triggered when they should be, or conversely, they are
triggered multiple times, it is hard for users to debug the issue. We would to
have a table of all received webhooks, that would allow project owners to
understand what exactly happened.


## 5. Actions overview

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Hard</td></tr>
  <tr><th>Required skills:</th><td>Python, HTML</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/1108">https://github.com/fedora-copr/copr/issues/1108</a></td></tr>
</table>

Copr is a complex system, requiring various so called "actions" to run in the
background. For example, in a project overview, there is a button for
regenerating its repositories. When clicked, it generates an asynchronyous
action which performend on an entirely different server. It usually takes
seconds to complete but it may take longer depending on the current queue. It
may even fail some unexpected reason. Project owners currently have no way of
knowing what actions affected their projects and whether they finished
successfully. We would like to have a table for every project, showing all
actions that happened.
