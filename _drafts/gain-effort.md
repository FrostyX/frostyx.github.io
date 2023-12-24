---
layout: post
title: Using gain/effort matrix for my projects
#title: Using gain/effort issue tags
lang: en
tags: workflow GTD howto github time-management project-management
---

My opensource journey got to the stage where the backlog grows
much faster than I am able to process it. Not every good idea is
worth pursuing, not every RFE can be implemented, not every bug
can be fixed. I needed to start prioritizing.

## Planning

In my team at work, we use capacity-based planning (in order to
guesstimate how many tasks can be done within one sprint) and
schedule tasks into the following abstract timeframes - In progress,
in three months, in two years, and someday in the future (which
is an euphemism for "probably never"). I don't need any of these
for my personal projects. There is no team, no sprints of a
given length, and basically no deadlines.

I work on my personal projects in short bursts energy sprinkled
throughout my evenings, weekends, and holidays. For me, the whole
planning can be reduced to a single question - What task should I
pick next? And the answer is simple as well. Something that will
move the project substantially forward, and is easy enough that it
can be sandwiched between my worktime.


## Inspiration

TODO Gain/effort matrix

I always liked how Fedora Infra
[does their planning][fedora-infra-issues].
They set two labels for each ticket. One indicates how much will be
gained by completing the ticket and the other indicates how much
trouble it will cause. Now, I don't like the word trouble. Does it
mean how much trouble the missing feature causes? Or will potentially
cause? Probably not. I suppose it represents how much trouble will
somebody have to undergo to implement it. There is a better word for
that - effort.

The [Packit team][packit-team] uses a
[slightly more complex version][packit-issues] of this system.
They represent the effort component as complexity (as in easyfix,
single task, or epic) and add another factor to the equation by
differentiating between gain and impact. I don't need any of that
for my personal projects.


## Labels

I've decided to setup the following labels for symbolizing the
estimated effort.

{:.table .table-striped}
| Label           | What does it mean?   |
|-----------------|---------------|
| `effort/low`    | task that is easy/short |
| `effort/medium` | task that is medium complex / difficult |
| `effort/high`   | task that is complex/long/difficult |

And the following labels to represent the imagined gain.

{:.table .table-striped}
| Label         | What does it mean?   |
|---------------|---------------|
| `gain/low`    | Tasks that gets us little / isn't very important / makes only 1 person or few happy |
| `gain/medium` | Task that gets us some / is somewhat important / makes some people happy |
| `gain/high`   | Task that gets us a lot / is important / makes many people happy |

This way it is straightforward to pick the next task to work on -
whatever is `effort/low AND gain/high`.


## GitHub

In GitHub repositories, it is trivial to filter such tickets. However,
what is far more interesting is searching such tickets accross all your
repositories at once. For that, we can use the [gh][gh] commandline
tool:

```bash
gh search issues \
    -R frostyx/tracer \
    -R frostyx/fedora-review-service \
    -R frostyx/dotfiles \
    -R rpm-software-management/tito \
    --label effort/low \
    --label gain/high
```

The output looks like this:

TODO screenshot
Alt: I already fixed all effort/low so here are effort/medium
just for the screenshot

Don't like the commandline tool very much? Use the `-w` parameter
to generate a GitHub search query and open it in the web browser.

TODO Screenshot
Alt: [Go to the GitHub search page][gh-search]



[fedora-infra-issues]: https://pagure.io/fedora-infrastructure/issues
[packit-issues]: https://github.com/packit/packit/issues
[packit-team]: https://github.com/packit
[gh]: https://github.com/cli/cli
[gh-search]: https://github.com/search?q=label%3Aeffort%2Flow+label%3Again%2Fhigh+repo%3Afrostyx%2Fdotfiles+repo%3Afrostyx%2Ffedora-review-service+repo%3Afrostyx%2Ftracer+repo%3Arpm-software-management%2Ftito+type%3Aissue&type=issues
