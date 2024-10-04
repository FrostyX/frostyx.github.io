---
layout: post
title: Do you want to contribute to Copr?
lang: en
tags: fedora copr
updated: 2024-10-04
---

I had a realization at [this year's DevConf][devconf]. Even if people want to
contribute to large open-source projects, they have no idea how. Or they don't
even realize they can contribute in the first place and that such a thing would
be appreciated That's why I wanted to try this experiment and offer 5
interesting RFEs for the Fedora community to implement.

## Why you should contribute

[Copr][copr] is a build system and third-party package repository for RPM-based
distributions. It's similar to [AUR][aur] for example. The project has been
around since 2012 and has become an integral part of the Fedora packaging
ecosystem, as corroborated by many conference talks and articles mentioning
it. We currently host 29000 projects from 7000 Fedora users and the package
downloads are in millions.

At this moment, there are [275 valid and triaged issues and RFEs][issues] in the
issue tracker. On [this board][kanban], you can see the roadmap for the upcoming
months, years, and possible futures. One obvious reason for contributing to the
project is getting a feature implemented sooner. Another reason is to improve
your skills as a software developer. It may be more fun and more useful than
creating a new TODO application from scratch. Last but not least, it's never a
bad idea to show your skills and collaborate with people who can do job
referrals. [That's how][thesis] I got my dream job 9 years ago. I think this is
a great opportunity for students looking to get some infield experience during
the summer break.

Don't worry if you don't feel competent enough to contribute. We have
[documentation][compose] for setting up your local development environment,
tests and a review process to improve the code quality, and a
[Matrix channel][matrix] for more informal communication. If you ever get stuck
somewhere in the process, please [ping me][frostyx] and mention this article.


## How you can contribute

Of course, you can pick any issue from the [Copr issue tracker][issues] that
seems interesting to you. Or you can pick any other project for that matter,
help is appreciated everywhere. However, In this article, I wanted to put
together a list of interesting and useful RFEs that our team won't have time to
implement in the near future. Please let us know if you would like to
collaborate with us on any of them. We will get you started and make sure you
have all the information you need.


### 1. External repository validation <i class="fa fa-check"></i>

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Trivial</td></tr>
  <tr><th>Required skills:</th><td>Python</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/1178">fedora-copr/copr#1178</a></td></tr>
  <tr><th>Contributor:</th><td><a href="https://github.com/jaitjacob">@jaitjacob</a></td></tr>
</table>

Copr projects can depend on other projects. It is possible to specify such a
dependency via a fully qualified URL or a shortcut in the `copr://owner/project`
format. It would be nice to have a validation making sure that users cannot set
a dependency on a non-existing project (due to typos for example).


### 2. Possibility to force delete a project

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Easy</td></tr>
  <tr><th>Required skills:</th><td>Python</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/2629">fedora-copr/copr#2629</a></td></tr>
  <tr><th>Contributor:</th><td><a href="https://fosstodon.org/@ProfessorCode">@ProfessorCode</a></td></tr>
</table>

Through the [Copr CLI][copr-cli] utility, it is possible to delete an existing
project with all of its builds. This, however, fails when some of the builds are
not yet finished. We would like to improve the respective API endpoint to
automatically cancel all running builds, making sure that no matter the state of
the project, it can be deleted.


### 3. Dark mode support

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Medium</td></tr>
  <tr><th>Required skills:</th><td>HTML, CSS, Javascript</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/3150">fedora-copr/copr#3150</a></td></tr>
</table>

The [Copr website][copr] offers only one theme and that is black text on a white
background. According to many online articles, dark-mode web designs are
getting increasingly more popular, helping to reduce eye strain and power
consumption. We would like our users to have the option to choose whether they
prefer light or dark mode of the website.


### 4. Webhook history

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Medium</td></tr>
  <tr><th>Required skills:</th><td>Python, HTML</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/304">fedora-copr/copr#304</a></td></tr>
  <tr><th>Contributor:</th><td><a href="https://github.com/jaitjacob">@jaitjacob</a></td></tr>
</table>

Copr provides integration with Git forges like [GitHub][github],
[GitLab][gitlab], and [Bitbucket][bitbucket] through webhooks. Usually,
everything works smoothly. However, when builds are not being triggered when
they should be, or conversely, when they are triggered multiple times, it is
hard for users to debug the issue. We would to have a table of all received
webhooks. This would allow project owners to understand
what exactly happened.


### 5. Actions overview

<table style="margin-bottom:10px;">
  <tr><th style="min-width:120px;">Difficulty:</th><td>Hard</td></tr>
  <tr><th>Required skills:</th><td>Python, HTML</td></tr>
  <tr><th>Ticket:</th><td><a href="https://github.com/fedora-copr/copr/issues/1108">fedora-copr/copr#1108</a></td></tr>
</table>

Copr is a complex system, requiring various so-called "actions" to run in the
background. For example, in a project overview, there is a button for
regenerating the project repositories. When clicked, it triggers an
asynchronous action which is performed on an entirely different server. It
usually takes seconds to complete but it may take longer depending on the
current queue. It may even fail for some unexpected reason. Project owners
have no way of knowing what actions affected their projects and whether they
finished successfully. We would like to have a table for every project, showing
all the actions that happened.




[devconf]: https://frostyx.cz/posts/devconf-2024-report
[copr]: https://copr.fedorainfracloud.org
[aur]: https://aur.archlinux.org/
[issues]: https://github.com/fedora-copr/copr/issues
[kanban]: https://github.com/orgs/fedora-copr/projects/1
[thesis]: https://research.redhat.com/blog/theses/determine-applications-affected-by-upgrade/
[compose]: https://frostyx.cz/posts/copr-docker-compose-without-supervisord
[matrix]: https://matrix.to/#/#buildsys:fedoraproject.org
[frostyx]: https://github.com/FrostyX
[copr-cli]: https://developer.fedoraproject.org/deployment/copr/copr-cli.html
[github]: https://github.com/
[gitlab]: https://gitlab.com/
[bitbucket]: https://bitbucket.org/
