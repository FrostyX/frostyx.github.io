---
layout: post
title: Upvoting projects in Copr
lang: en
tags: copr fedora
---

Let's take a minute of our time and upvote our favorite projects in
Copr to appreciate the great work their maintainers put it.

There are tens of thousands of projects in [Copr][copr] with vast
differences in the quality of packages they provide and how well they
are maintained. Many of them are just testing projects without any
further purpose, others provide production-ready software valuable
for many users. For a long time, we wanted to give projects some
badge or a shiny plaque, that would reflect their popularity among
users, and I am happy to announce, that we finally launched upvoting
(and downvoting) of projects in Copr.


## Project Score

We do not want to define what upvote or downvote mean and rather let
everyone to have their own interpretation of those words. If you like
the project (for whatever reason - you may like the software it
provides, it may be extraordinarily well maintained, you just want to
support the project, or anything else that is important for you),
please give it the thumbs up. If you feel negative about a project (it
may be for example dangerous to enable it), don't be afraid to give
the thumbs down. The score will then reflect the general popularity
of a project.

At this moment, Copr just shows the score in a project detail page,
there are no features tied to it yet. They are definitely going to be
some benefits for popular projects soon, we are just not sure which
ones. Please let us know what features you would like to see! We are
currently considering the following:

- Add a possibility to sort projects by their score
- Revive the idea of [Fedora Playground][playground] and automatically
  provide the highest-rated projects within one playground repository.
- Add a page with popular projects, that would show the highest scored
  projects in absolute numbers, projects trending this month, and the
  most controversial ones.
- Do not introduce any additions and leave the score to be just
  feedback for the project maintainer and other users.

These ratings will also help us pick new projects for our
trying-to-be-monthly series
[4 cool new projects to try in COPR][dturecek-magazine].


## User Interface

There are many options when it comes to scoring content online -
Numeric value 1-10, one to five stars, likes or hearts, and
possibly a lot of others. We perceive thumbs up / thumbs down scoring
to be a simple, yet effective solution, so we went for it. The actual
user-interface is inspired by [Reddit][reddit] and
[Stack Overflow][stackoverflow], which I believe are well-known
platforms among Copr users.

<div class="text-center img-row row">
  <a href="/files/img/copr-project-score.png">
    <img src="/files/img/copr-project-score.png"
		 alt="I have already upvoted this project" />
  </a>
</div>

The highlighted upward arrow signalizes that I already upvoted
this project. Similarly, a downvoted project would be highlighted
with red color. Click the highlighted arrow to remove your vote,
or point your cursor to the score number, it will show you the
number of upvotes and the number of downvotes for the project as
two separate numbers.

Do you find the interface intuitive and user-friendly or would
you rather like see some improvements done to it? Please, let
us know. Currently, there is no `copr-cli` or API support for
upvoting and downvoting projects.



[copr]: https://copr.fedorainfracloud.org
[playground]: https://fedoraproject.org/wiki/Playground
[dturecek-magazine]: https://fedoramagazine.org/author/dturecek
[fedora-magazine]: https://fedoramagazine.org/series/copr
[reddit]: https://www.reddit.com/new
[stackoverflow]: https://stackoverflow.com
