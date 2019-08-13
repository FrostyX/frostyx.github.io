---
layout: post
title: Flock report 2019
lang: en
categories: copr fedora flock report modularity
---

This year's [Flock](flock) is over so the right thing to do now, is capture its best moments. This time, the conference
took place in the unbelievably beautiful Budapest, starting from Thursday 8 aug and carried on till the end
of the week. I would like to thank all organisers and sponsors for putting the effort and resources into hosting such
a great conference and also my employer for giving me an opportunity to attend. It was a wild ride!


## A lot of fun

@TODO what about some not dumb title?

I traveled with the majority of Red Hatters from Brno by a private bus and that was where all the fun begun. Our four
hour ride thoroughly supervised Miroslav Suchý as a bus captain. And by that I mean entertaining us with his witty
standup comedy. I was in charge of ordering the autobus.

@TODO Maybe mirek's photo if there is any
@TODO I am helping meme

For the whole time, it was perfectly taken care of us. On wednesday, there was no official program so we could rest
after the drive and explore the city by ourselves, but the following evenings we cruised the river on a boat, had
a city tour with a guide, Candy XXX, board games, non-english events and slideshow karaoke.

For me, this was the first time of staying right in the venue and it was incredibly comfortable. As a hefty guy
involved in streght sports, need to eat a lot. And the food situaion was literally fantastic. Breakfast and lunch
were served in a form of an all you can eat buffet, we also had a countless of coffee breaks with snacks and a diet
coke everywhere.

Now it sounds like sightseeing trip full of fine dining, but in fact, this was [Flock To Fedora 2019](flock)!
I just wanted start this blog post with all the extras. Now, let's dive into the important things.

This year, we had multiple panels focused mainly on packaging, automation, containers, python, modularity and more.
Talks were probably evenly distributed throughout more various topics, it's just that I am mostly interested in these
areas.


## Packaging and Automation

The [packaging (and automation) panel](packaging-and-automation) started with [Neal Gompa](ngompa) and [Igor Gnatenko](ignatenkobrain) talking
about saving packagers' time by automating the rebuild of packages when their dependency changes, and also not
requiring them to write changelog and manage release number manually, but rather generate them from git. The talk
was called [Improving Packaging Experience with Automation](improving-packaging-experience-with-automation).

Then I've attended the
[Bring your upstream releases to Fedora Rawhide in one step](bring-your-upstream-releases-to-fedora-rawhide-in-one-step)
led by [Tomáš Tomeček](ttomecek1). This talk was about the [packit tool](packit-tool) and the
[packit service](packit-service). He presented how to automatically build an RPM package in [Copr](copr) for every
pull reqeust in your Git Hub project.

Then [Michal Novotný](clime) shared his vision of the [rpkg](rpkg) being the go-to tool for working with DistGit,
unified across the whole realm of the RPM distributions. He named his talk
[rpkg, the next generation packaging utility — call for feedback](rpkg-the-next-generation-packaging-utility-call-for-feedback).

There were many more, but unfortunatelly I couldn't be on ten places at the same time.


## Containers

My next primary focus was on [containers](containers) because there is a lot of containers-related work ahead of me
in upcomming months. One of the technologies that I barely knew about is [podman](podman). However, thanks to the
[Valentin Rothberg](rothberg) who deputized [Dan Walsh](rhatdan) in a talk
[Replacing Docker with Podman](replacing-docker-with-podman) and then workshop
[Containers Birds-of-a-Feather](containers-birds-of-a-feather) where I got answered my specific questions about
migrating from [docker-compose](docker-compose), I am now pretty confident about migrating to podman.

Another very interesting and lifesaving lecture was *briefly* named
[communishift: A OpenShift cluster for Fedora community managed applications](communishift-a-openshift-cluster-for-fedora-community-managed-applications)
and led by [Kevin Fenzi](kevinfenzi1). The [fedora infrastructure](fedora-infrastructure) has launched a community
openshift for hosting and self-managing Fedora-related services.

I didn't knew very much about [Fedora CoreOS](fedora-coreos) and its goal sounded very promising, so I've attended
a lecture from lovely [Sinny Kumari](sinnykumari1) and [Jakub Cajka](jcajka1) to discover more.

The containers pannel was probably the most beneficial for me, too bad I couldn't catch more talks.


## Modularity

The last year I went to everything modularity-related, so this time I picked just one workshop -
[Modularity & packager experience birds-of-a-feather](modularity-packager-experience-birds-of-a-feather).
And I couldn't pick better as this was one of the most constructive discussions I've been part of (on such event).
I believe that this was thanks to the [Adam Šamalík](asamalik)'s moderation of the whole workshop. The audience shouted
every possible topic that they wanted to discuss, then all of use voted to figure out what are the most interesting
topics for the most of us. We split the workshop into several fifteen minutes blocks dedicated one for each topic.
We strictly complied this rule and it paid off.

Experts in this area such as Stephen Gallagher, Langdon White, Petr Šabata and Adam Samalik underwent trial by fire,
and in my eyes, succeeded. Personally, I spent too much time on [modularity support for Copr](modularity-support-for-copr) and it turned out,
that Neal Gompa did the same for [OBS](obs). Basically, Vít Ondruch captured all of our issues with a simple line -
*MBS is a blackbox*. Which is accurate because nobody of us really knows what actions and in what order the [MBS](mbs)
does during the build process. We demanded reverse engineering the MBS build process and properly documenting it.
Furthermore, I've expressed the fact, that running an own MBS instance for each third-party build system is a
*bullsh\*t* and proposed to extract its functionality into reusable library or a series of smaller tools.

We have discussed many more topics, but I didn't really took many notes about those, that didn't concern me.


## Missed talks

Since the conference proceeded in three to four panels in paralel and we haven't discovered time travel yet, there is
an eminent probability of missing some lectures. Personally I regret missing
[NeuroFedora: FOSS and open (neuro)science](neurofedora-foss-and-open-neuroscience),
[State of Fedora Security](state-of-fedora-security),
[Silverblue: On the way to the future of Fedora Workstation](silverblue-on-the-way-to-the-future-of-fedora-workstation),
and [Future of release-monitoring.org](future-of-release-monitoringorg).

I am looking forward to see the recordings.


## Awesome people

@TODO list people here
- Parádní video od @tatica
- Group photo


## Next steps

- Splitnout Copr docker  stack abychom měli jeden proces per kontejner
- Testy v community openshiftu
- Migrace Copru do openshiftu
- Pro python už asi funguje automatické generování buildrequires



@TODO images: Badges + tux, dan walsh, oficical logo (maybe tshirt)


[flock]: #
[packit-tool]: #
[packit-service]: #
[copr]: #
[rpkg]: #
[podman]: #
[fedora-coreos]: #
[obs]: #
[modularity-support-for-copr]: #
[mbs]: #

[ngompa]: https://flock2019.sched.com/speaker/ngompa
[ignatenkobrain]: https://flock2019.sched.com/speaker/ignatenkobrain
[ttomecek1]: https://flock2019.sched.com/speaker/ttomecek1
[clime]: https://flock2019.sched.com/speaker/clime
[rothberg]: https://flock2019.sched.com/speaker/rothberg
[rhatdan]: https://flock2019.sched.com/speaker/rhatdan
[kevinfenzi1]: https://flock2019.sched.com/speaker/kevinfenzi1
[sinnykumari1]: https://flock2019.sched.com/speaker/sinnykumari1
[jcajka1]: https://flock2019.sched.com/speaker/jcajka1
[asamalik]: https://flock2019.sched.com/speaker/asamalik

[packaging-and-automation]: https://flock2019.sched.com/overview/type/Packaging+and+Automation
[containers]: https://flock2019.sched.com/overview/type/Containers

[improving-packaging-experience-with-automation]: https://flock2019.sched.com/event/SH8l/improving-packaging-experience-with-automation
[replacing-docker-with-podman]: https://flock2019.sched.com/event/SAOb/replacing-docker-with-podman
[fedora-coreos-preview-to-stable]: https://flock2019.sched.com/event/SJqB/fedora-coreos-preview-to-stable
[future-of-release-monitoringorg]: https://flock2019.sched.com/event/SH9V/future-of-release-monitoringorg
[fedora-red-hat-and-ibm]: https://flock2019.sched.com/event/SDXJ/fedora-red-hat-and-ibm
[what-can-we-do-for-cross-distro-collaboration-in-packaging]: https://flock2019.sched.com/event/SJvt/what-can-we-do-for-cross-distro-collaboration-in-packaging
[let-the-bot-create-your-releases]: https://flock2019.sched.com/event/SKpg/let-the-bot-create-your-releases
[rpkg-the-next-generation-packaging-utility-call-for-feedback]: https://flock2019.sched.com/event/SHOA/rpkg-the-next-generation-packaging-utility-call-for-feedback
[neurofedora-foss-and-open-neuroscience]: https://flock2019.sched.com/event/S5mC/neurofedora-foss-and-open-neuroscience
[state-of-fedora-security]: https://flock2019.sched.com/event/S5nV/state-of-fedora-security
[bring-your-upstream-releases-to-fedora-rawhide-in-one-step]: https://flock2019.sched.com/event/SAP3/bring-your-upstream-releases-to-fedora-rawhide-in-one-step
[silverblue-on-the-way-to-the-future-of-fedora-workstation]: https://flock2019.sched.com/event/SKW6/silverblue-on-the-way-to-the-future-of-fedora-workstation
[how-do-we-do-rust-packaging-in-fedora]: https://flock2019.sched.com/event/SJvA/how-do-we-do-rust-packaging-in-fedora
[what-stability-means-and-how-to-do-better]: https://flock2019.sched.com/event/SH8C/what-stability-means-and-how-to-do-better
[snaps-vnulb-fedora-fedora-ecosystem-progress-update]: https://flock2019.sched.com/event/SHOg/snaps-vnulb-fedora-fedora-ecosystem-progress-update
[communishift-a-openshift-cluster-for-fedora-community-managed-applications]: https://flock2019.sched.com/event/SJcm/communishift-a-openshift-cluster-for-fedora-community-managed-applications
[fedora-vnulb-python-what-to-do-next]: https://flock2019.sched.com/event/SJi4/fedora-vnulb-python-what-to-do-next
[modularity-packager-experience-birds-of-a-feather]: https://flock2019.sched.com/event/SJL4/modularity-packager-experience-birds-of-a-feather
[containers-birds-of-a-feather]: https://flock2019.sched.com/event/SAOt/containers-birds-of-a-feather
[introductory-packit-workshop-start-working-with-source-git-and-continuous-integration]: https://flock2019.sched.com/event/S7nl/introductory-packit-workshop-start-working-with-source-git-and-continuous-integration
[community-platform-engineering-hackfest]: https://flock2019.sched.com/event/T8WY/community-platform-engineering-hackfest
[fedora-onboarding-portal-streamlining-the-newcomers-experience-and-bootstrapping]: https://flock2019.sched.com/event/SJJZ/fedora-onboarding-portal-streamlining-the-newcomers-experience-and-bootstrapping
[automatic-bug-reporting-for-dummies]: https://flock2019.sched.com/event/SJpH/automatic-bug-reporting-for-dummies
[meet-your-fesco]: https://flock2019.sched.com/event/SJve/meet-your-fesco
