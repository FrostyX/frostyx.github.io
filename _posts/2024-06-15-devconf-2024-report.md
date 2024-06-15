---
layout: post
title: DevConf 2024 report
lang: en
tags: fedora report devconf
---

This year's [DevConf][devconf] was a blast and the best time I had on a
conference probably since [2019 Flock in Budapest][flock]. Thank you all who
make events like these happen.


## Day 1

It all started a bit unfavorable for me. I arrived underslept, forgot
that am supposed to have a ticket, and when I finally got to the
[Go language basis course][go-workshop], which I was very much looking
forward to, the room was already packed and we weren't allowed in.

Without much thinking, I joined the
[Upstream maintainers meetup][upstream-meetup] instead, which turned out to be
a good choice. For me, the most interesting part was a discussion between an
OpenSSL maintainer and an LVM maintainer about why they don't have many
contributions from the community. What I realized afterward:

- People only care about one or two layers below whatever they are working
  on. For the lack of a better example, as a [Copr][copr] developer, I am likely
  to provide feedback or a small patch for [createrepo_c][createrepo] which we
  directly build on top of. But it is very unlikely I will ever submit a patch
  for some of its dependencies like [libxml2][libxml2] or [zchunk][zchunk]. They
  are too far removed from me.
- Even if I was feeling philanthropic and wanted to spend my vacation hacking on
  OpenSSL, I have no idea which of the 2k issues in their tracker would be a
  good fit for me.

Two takeaways for me. First, I think we should try to reach contributors only
one level up and one level down from our project. Also, I would like to pick
five RFEs from the [Copr backlog][copr-backlog] which would be nice to have but
our team won't have time to implement them. Probably ever. I will write a short
paragraph about each of them, score them with difficulty, and list the needed
skills for their completion. I want to see if anyone from the community would be
interested in implementing them.

On my way to another talk, I stumbled into [Florian Festi][ffesti]. We haven't
talked in person for years, so I tried to re-introduce myself. I have high
regard for Florian, so of course, I couldn't even stutter out my name. I don't
know why. He is a kind and friendly dude with a majestic fluffy beard. There was
no reason to be nervous. Anyway, we discussed the insufficiencies of the Python
RPM documentation, and what should be done with them.

The price for the best presentation of the conference goes to
[Evan Goode][evan-goode] for
[Learning from Nix: how other package managers can do better][learning-from-nix].
The topic was novel, the analysis was on point, and I very much appreciate his
speaking skills. After the talk, I lamented about Nix not being packaged for
Fedora, which is in my opinion a big drawback. During the lecture, the whole
room raised their hands that they know Nix. Then the whole room raised their
hands again that they use an RPM-based GNU/Linux distribution. Yet nobody raised
their hand that they actually use Nix. I think the reason is that it isn't
easily available on Fedora. And many of us just are not willing to run
`curl ... |sudo bash`.

After lunch, I finally got the opportunity to meet and chat with
[Dan Čermák][dan-cermak] in person, after having several online discussions
about [rpm-spec-language-server][rpm-lsp]. His lightning talk was on the same
topic - [Creating a Language Server for RPM Spec Files][rpm-lsp-talk]. Cudos for
doing a live demo with a mic in one hand. Also, it was nice to see somebody else
to use Emacs.

## Day 2

This year, I decided to try something different, and ... don't go. I stayed
home, recharged my social battery, and worked on all the action items from the
previous day.

<div class="text-center img-row row">
  <a href="/files/img/social-battery.png"
     title="">
    <img src="/files/img/social-battery.png">
  </a>
</div>

I submitted a [PR with Python API examples for the RPM documentation][rpm-pr]
and texted Evan a [Copr project with Nix][copr-nix] that could be a good
starting point for the official package. I created a
[containerized reproducer for a Vim issue][rpm-lsp-vim] we are having with Dan in
the [rpm-spec-language-server][rpm-lsp] project. And finally, I picked some
interesting Copr RFEs that I would like to offer to the community.

Not attending the second day hugely paid off. I was pumped for Day 3.


## Day 3

I skipped breakfast and came in early to see
[Gickup - Keep your repositories safe][gickup-talk] by
[Andreas Wachter][andreas-wachter]. I was the first one in the room and Andy
promised to do the talk even if I was the only one. Fortunately, more people
came.  Afterward, we had a long chat about the [Gickup][gickup] project and the
things I am planning to contribute. You see, I started working on a similar
project a few weeks ago but Gickup is miles ahead, which is great because now I
don't have to implement all of it by myself from scratch.

Mainly I am planning to create a systemd service so it doesn't have to be run in
a container, add support for backing up project metadata like followers,
stars, etc (a good opportunity to learn Go), and package the tool for Fedora.

On the [Self-hosting/homelab meetup][self-hosting], I learned about new
interesting ways how to over-engineer my 200€ ThinkCentre running from behind
the couch. Specifically, I am planning to take a look at
[healthchecks.io][healthchecks], [Borg][borg], [gethomepage.dev][gethomepage],
and some service for push notifications like [ntfy][ntfy] or [gotify][gotify].

<div class="text-center img-row row">
  <a href="/files/img/wife-acceptance-factor.png"
     title="Imporant consideration for home server - The Wife Acceptance Factor">
    <img src="/files/img/wife-acceptance-factor.png">
  </a>
</div>

During a lunch break, I picked switches for my next mechanical keyboard and
tried to hit 10 WPM on this ... thing.

<div class="text-center img-row row">
  <a href="/files/img/split-keyboard.png"
     title="Not a typo, I really meant 10 WPM, not 100 WPM">
    <img src="/files/img/split-keyboard.png">
  </a>
</div>

I got unexpectedly mentioned in [Michel Lind][michel-lind]'s talk about
[Applying Production Engineering mindset to RPM Packaging for fun and profit][rpm-packaging].
Not going to lie, felt really good.

<div class="text-center img-row row">
  <a href="/files/img/package-review-mentioned.png"
     title="Mum, can you see me?">
    <img src="/files/img/package-review-mentioned.png">
  </a>
</div>

After the lecture, we brainstormed on
moving the [fedora-review][fedora-review] project from Pagure to GitLab so that
we can set up Packit for it and have a proper release process and CI. Which is
currently the biggest pain point of the project. As [Neal Gompa][neal-gompa]
pointed out, that is the exact reason why neither of us publishes a release even
though it is needed. It is so bad I rather generated a downstream patch for the
Fedora package the last time I needed to ship something.

And that was it, the end of the conference.


## Closing thoughts

The event schedule was packed with ten tracks going in parallel at any given
moment. It was virtually impossible to attend everything I wanted to.
Good thing [there are recordings][recordings] to keep me occupied during all my
meals this week.

Also, I am not a social person. I know that, you know that, everybody knows
that. I loved to see you all but I cannot handle being three consecutive days in
crowds of hundreds of people without feeling like shit. That's something I had
to contend and reconcile with. Skipping one day paid off, my social battery held
up, and I am already looking forward to DevConf 2025.

Surprisingly, I felt so great afterward, that on my way home I even
approached a beautiful woman that smiled at me in a park. We had a nice
conversation but she was married so we parted ways after a few minutes. She
liked my compliment though. Hopefully, it made her day better.




[devconf]: https://www.devconf.info/
[go-workshop]: https://pretalx.com/devconf-cz-2024/talk/TNGEQ9/
[upstream-meetup]: https://pretalx.com/devconf-cz-2024/talk/PSGCSK/
[libxml2]: https://gitlab.gnome.org/GNOME/libxml2/-/wikis/home
[zchunk]: https://github.com/zchunk/zchunk
[ffesti]: https://pretalx.com/devconf-cz-2024/speaker/HDHYAH/
[learning-from-nix]: https://pretalx.com/devconf-cz-2024/talk/NNKT3F/
[rpm-lsp]: https://github.com/dcermak/rpm-spec-language-server/
[rpm-lsp-talk]: https://pretalx.com/devconf-cz-2024/talk/RXKMKA/
[rpm-lsp-vim]: https://github.com/dcermak/rpm-spec-language-server/issues/176#issuecomment-2166612811
[gickup-talk]: https://pretalx.com/devconf-cz-2024/talk/EJZQGJ/
[gickup]: https://github.com/cooperspencer/gickup
[andreas-wachter]: https://pretalx.com/devconf-cz-2024/speaker/NZKK3B/
[self-hosting]: https://pretalx.com/devconf-cz-2024/talk/TTCJTB/
[healthchecks]: https://healthchecks.io/
[borg]: https://www.borgbackup.org/
[gethomepage]: https://gethomepage.dev/latest/
[ntfy]: https://ntfy.sh/
[gotify]: https://gotify.net/
[rpm-packaging]: https://pretalx.com/devconf-cz-2024/talk/BXQNEQ/
[flock]: https://frostyx.cz/posts/flock-report-2019
[createrepo]: https://github.com/rpm-software-management/createrepo_c
[copr]: https://copr.fedorainfracloud.org/
[copr-backlog]: https://github.com/orgs/fedora-copr/projects/1
[evan-goode]: https://pretalx.com/devconf-cz-2024/speaker/VSXEDS/
[dan-cermak]: https://pretalx.com/devconf-cz-2024/speaker/KKDM87/
[rpm-pr]: https://github.com/rpm-software-management/rpm-web/pull/54
[copr-nix]: https://copr.fedorainfracloud.org/coprs/prathampatel/nix/
[michel-lind]: https://pretalx.com/devconf-cz-2024/speaker/M3XBXT/
[fedora-review]: https://pagure.io/FedoraReview/
[neal-gompa]: https://pretalx.com/devconf-cz-2024/speaker/GSJ7WA/
[recordings]: https://www.youtube.com/@DevConfs
