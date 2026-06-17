---
layout: post
title: Flock to Fedora report 2026
lang: en
tags: fedora flock report
---

This post is tough to write because [Flock to Fedora][flock-to-fedora] is my
favorite conference, and [last year's Flock][flock-2025] might have been the
best conference I've ever been to. I love the Fedora community, Prague is
beautiful, the venue is nice, we always have so many interesting talks and
workshops, the organizers do an amazing job preparing this event for us, so I
feel really guilty saying that I did not have much fun this year. That is 100%
on me, though. Flock bears no blame.

It wasn't exactly the wisest decision ever to run
[my first half-marathon][half-marathon] the very evening before the conference,
and then waking up early to commute to Prague. It must have hit me much more
than I was willing to admit. I feel fine physically, but I can't pay attention
to anything because nothing feels exciting. That is the most lifeless I've felt
in a long time.

So, in case anyone is wondering ... it was me, not you.


### Highlights

Despite all that, these were the highlights of the event for me.

#### [Forging Fedora Project’s Future With Forgejo][forging-fedora]

Great job on the migration from [pagure.io](https://pagure.io) to
[forge.fedoraproject.org](https://forge.fedoraproject.org). It was
handled exceptionally well. Next, we look forward to the migration of
[src.fedoraproject.org](https://src.fedoraproject.org) to Forgejo, which can't come
soon enough. [Tomáš Hrčka][tomas-hrcka] teased us that this migration may take
considerably less time than the previous one because they already know how to do
things (e.g., deploy Forgejo, etc).

#### [DIY AI: Build a Private, Customizable Chatbot on Lean Hardware][chatbot]

[Ellis Low][ellis-low] showed us how to run an LLM on our laptops through Llama
and how to interact with it. I really appreciated him saying that, except for
this one small text-in, text-out magic black box, everything else is standard
software engineering as we know it.

#### [Fedora Council Strategic Proposals + FESCo Q&A][council-and-fesco]

Most of the discussion revolved around a decline of new contributors and us
failing to connect with the next generation. "They talk about changing
wallpaper, we talk about burnout" -- [Aleksandra Fedorova][aleksandra-fedorova].

#### [What's Cooking in Copr, Testing Farm, tmt, Packit and Log Detective][pte]

I found [Pavel Raiskup][pavel-raiskup]'s return to the stage hilarious.

#### [Scrapers gotta scrape scrape scrape][scrapers-gotta-scrape]

As presentations go, [Kevin Fenzi][kevin-fenzi]'s talk about AI scrapers was
the best. It started with minor A/V dificulities, which is a nice reminder
to not feel bad, the next time it happens to you, because it happens to
everybody. Even the main infra guy. Semi-joking aside, I enjoyed the brief
history of web scraping and Kevin's taxonomy of scrapers, clearly showing that
not all scrapers are the same (e.g.,
[web.archive.org](https://web.archive.org/)). However, the current AI scrapers
are the plague of the internet, and I am so glad the Fedora Infra team fights
them as best as they can to keep our services running.

#### Chat with Adam

I ran into my former Copr team mate [Adam Šamalík][adam-samalik] in the hallway,
and we had a nice chat about life. When we still worked together (10 years ago,
oh how the time flies), I randomly asked him what he did on a weekend. "We had
no plans, so we bought plane tickets and went on a date to Amsterdam with my
girlfriend". Fucking what?! That was the coolest response ever. Since that
day, I remember it every time my creaking, lazy bones struggle to do something
spontaneous. Why am I telling it now? Adam is now happily living in the
Netherlands full-time. Funny how one impromptu decision can completely change
your life.

#### Chat with Emmanuel

Made friends with [Emmanuel Seyman][emmanuel-seyman]. He said hello after seeing
the [Fedora Podcast episode with me as a guest][fedora-podcast]. I really
enjoyed our chat, and I am going to follow up online because I think he'll
really like [Sundaram Krishnan][sundaram-krishnan]'s project
[coprtree][coprtree].

#### Chat with Miro

[Miro Hrončok][miro-hroncok] shared some of his ideas about improving the
[Fedora Package Review Process][review-process] with me. This deserves an
article on its own, so stay tuned.


[flock-to-fedora]: https://fedoraproject.org/flock/
[flock-2025]: https://frostyx.cz/posts/flock-to-fedora-report-2025
[forging-fedora]: https://cfp.fedoraproject.org/flock-to-fedora-2026/talk/BTDZAA/
[chatbot]: https://cfp.fedoraproject.org/flock-to-fedora-2026/talk/DYZJHQ/
[council-and-fesco]: https://cfp.fedoraproject.org/flock-to-fedora-2026/talk/PHZW3D/
[pte]: https://cfp.fedoraproject.org/flock-to-fedora-2026/talk/FHYW3G/
[scrapers-gotta-scrape]: https://cfp.fedoraproject.org/flock-to-fedora-2026/talk/FWSYWR/
[adam-samalik]: https://cfp.fedoraproject.org/flock-to-fedora-2026/talk/8GWWTY/
[tomas-hrcka]: https://cfp.fedoraproject.org/flock-to-fedora-2026/speaker/V3TBBG/
[ellis-low]: https://cfp.fedoraproject.org/flock-to-fedora-2026/speaker/M9CWQQ/
[aleksandra-fedorova]: https://cfp.fedoraproject.org/flock-to-fedora-2026/speaker/TGZDY8/
[pavel-raiskup]: https://github.com/praiskup
[emmanuel-seyman]: https://fedoraproject.org/wiki/User:Eseyman
[sundaram-krishnan]: https://github.com/sundaram123krishnan/
[miro-hroncok]: https://cfp.fedoraproject.org/flock-to-fedora-2026/speaker/RTZAUD/
[kevin-fenzi]: https://cfp.fedoraproject.org/flock-to-fedora-2026/speaker/G8QMRU/
[coprtree]: https://github.com/sundaram123krishnan/coprtree
[fedora-podcast]: https://www.youtube.com/watch?v=m59OdC3BLp0
[review-process]: https://docs.fedoraproject.org/en-US/package-maintainers/Package_Review_Process/
[half-marathon]: https://www.runczech.com/cs/akce/mattoni-running-festival-olomouc-2026/zavody/mattoni-1-2maraton-olomouc
