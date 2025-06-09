---
layout: post
title: Flock to Fedora report 2025
lang: en
tags: fedora flock report
---

[Flock to Fedora][flock] is my favorite conference and this year was no
exception.

Too many good presentations and workshops to name them all. But I want to
mention at least the most surprising (in a good way) ones. It takes some courage
to be the first person to go for a lightning talk, especially when lightning
talks aren't even scheduled and organizers open the floor at the very
moment. [Smera][smeragoel], I tip my hat to you. Also, I was meaning to ask,
how do graphic designers choose the FOSS project they want to work on? As an
engineer, I typically get involved in sofware that I use but is broken somehow,
or is missing some features. I am curious what is it like for you. Another
pleasant surprise was [Marta][mlewando] and her efforts to
[replace grub with nmbl][nmbl]. I will definitely try having **n**o **m**ore
**b**oot **l**oader. In a VM though, I'd still like to boot my workstation :D.


## Random thoughts

We bunked with [Pavel][praiskup], which made me
[think of this office scene][delightful].

Something happened to me repeatedly during this conference and amused me every
time. I introduced myself to a person, we talked for five minutes, and then the
person asked "so what do you do in Fedora?". I introduced myself once more, by
my nickname. To which the immediate reaction was "Ahaaa, now I know exactly what
you do!". I am still laughing about this. Organizers, please bring back FAS
usernames on badges.

It was nice to hear [Copr][copr] casually mentioned in every other
presentation. It makes the work that much more rewarding.

My favorite presentation was
[Bootable Containers: Moving From Concept to Implementation][bootable-containers].
I've spent all my free time over the last couple of months trying to create a
[bootc image for Copr builders][copr-image-builder], and seeing
[Sean][snthrailkill] falling into and crawling out of all the same traps as
myself was just cathartic. We later talked in the hallway and I appreciated how
quickly he matched my enthusiasm about the project. He gave me some valuable
advice regarding CI/CD for the system images. Man, now I am even more hyped.

I learned about [Fedora Ready][fedora-ready], an amazing initiative to partner
with laptop vendors and provide [a list of devices][fedora-ready-list] that
officially support Fedora. [Slimbook][slimbook] loves Fedora so much that they
even offer a [laptop with Fedora engravings][slimbook-fedora]. How amazing would
it be if my employer provided this option for a company laptop? What surprised
me, was not seeing [System76][system76] on the list. I am a fan of theirs, so I
am considering reaching out.

Feeling a tap on your shoulder 30 seconds after you push a commit is never a
good sign. When you turn around, [Karolina][ksurma] is looking into your eyes
and saying that f'd up, you immediately know that push was a bad idea. For a
petite lady, she can be quite terrifying :D. I am exaggerating for effect. We
had a nice chat afterward and I pitched an idea for an RPM macro that would
remove capped versions from [Poetry][poetry] dependencies. That should make our
lives easier, no?

One of my favorite moments this year was chilling out with [Zbigniew][zbyszek]
on a boat deck, cruising the Vltava River, and watching the sunset over the
beautiful city of Prague. Kinda romatic if you ask me. Just joking, but indeed,
it was my pleasure to get to know you Zbigniew.


## The JefFPL exchange

The conference began with a bittersweet moment - the passing of the Fedora
Project Leadership mantle from [Matthew Miller][mattdm] to
[Jeff Spaleta][jspaleta].

I didn't know Jeff before, probably because he was busy doing really effin cool
stuff in Alaska, but we had an opportunity to chat in the hallway after the
session. He is friendly, well-spoken, and not being afraid to state his
opinions. Good qualities for a leader. That being said, Matthew left giant shoes
to fill, so I think it is reasonable not to be overly enthusiastic about the
change just yet.

Matthew, best wishes in your next position, but at the same time, we are sad to
see you go.


## FESCo and Fedora Council

The [FESCo Q&A][fesco-qa] and the [Fedora Council AMA][fedora-council-ama] were
two different sessions on two different days, but I am lumping them together
here. Both of them dealt with an
[unspecified Proven Packager incident][incident], the lack of communication
surrounding it, and the inevitable loss of trust as a consequence.

I respectfully disagree with this sentiment.

Let's assume [FESCo][fesco] actions were wrong. So what?  I mean,
really. Everybody makes mistakes. I wrote bugfixes that introduced twice as many
new bugs, I accidentally removed data in production, and I am regularly wrong in
my PR comments. Yet I wasn't fired, demoted, or lost any trust from the
community. Everybody makes mistakes, it's par for the course. **Even if**
[FESCo][fesco] made a mistake (I am not in the position to judge whether they
did or not), it would not overshadow the majority of decisions they made
right. They didn't lose any of my trust.

As for the policies governing [Proven Packagers][proven-packagers], one incident
in a decade does not necessarily imply that new rules are needed. It's possible
to just make a gentlemen's agreement, shake hands, and move on.

That being said, I wanted to propose the same thing as
[Alexandra Fedorova][bookwar]. Proven Packagers are valuable in emergencies,
and I think, it is a bad idea to disband them. But requiring +1 from at least
one other person before pushing changes, makes sense to me. Alexandra proposed
+1 from at least one other Proven Packager, but I would broaden the eligible
reviewers to also include [Packager Sponsors][packager-sponsors] and
[FESCo][fesco] members. I would also suggest requiring the name of the reviewer
to be clearly mentioned in the commit description.


---

Don't be sad if you missed the conference. [There are recordings][recordings].



[flock]: https://fedoraproject.org/flock/
[smeragoel]: https://accounts.fedoraproject.org/user/smeragoel/
[mlewando]: https://accounts.fedoraproject.org/user/mlewando/
[nmbl]: https://copr.fedorainfracloud.org/coprs/mlewando/nmbl-poc/
[praiskup]: https://accounts.fedoraproject.org/user/praiskup/
[delightful]: /files/img/delightful.png
[copr]: https://copr.fedorainfracloud.org/
[bootable-containers]: https://cfp.fedoraproject.org/flock-to-fedora-2025/talk/WPBWC7/
[copr-image-builder]: https://github.com/fedora-copr/copr-image-builder
[snthrailkill]: https://accounts.fedoraproject.org/user/snthrailkill/
[fedora-ready]: https://docs.fedoraproject.org/en-US/marketing/ready/
[fedora-ready-list]: https://docs.fedoraproject.org/en-US/marketing/ready/list/#fedora-ready-approved-devices
[slimbook]: https://slimbook.com/en/
[slimbook-fedora]: https://slimbook.com/en/fedora
[system76]: https://system76.com/
[ksurma]: https://accounts.fedoraproject.org/user/ksurma/
[poetry]: https://github.com/python-poetry/poetry
[zbyszek]: https://accounts.fedoraproject.org/user/zbyszek/
[mattdm]: https://accounts.fedoraproject.org/user/mattdm/
[jspaleta]: https://accounts.fedoraproject.org/user/jspaleta/
[fesco-qa]: https://cfp.fedoraproject.org/flock-to-fedora-2025/talk/ERLNR9/
[fedora-council-ama]: https://cfp.fedoraproject.org/flock-to-fedora-2025/talk/FKVCHK/
[incident]: https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/thread/BQIXJAZXUMGOHLTNJHAZFHWVTF7PIATB/#SCO44FAQ5INRIKCVESB43LZHAJBQKCDR
[fesco]: https://docs.fedoraproject.org/en-US/fesco/
[proven-packagers]: https://docs.fedoraproject.org/en-US/fesco/Provenpackager_policy/
[bookwar]: https://accounts.fedoraproject.org/user/bookwar/
[packager-sponsors]: https://docs.pagure.org/fedora-sponsors/
[recordings]: https://www.youtube.com/@fedora/streams
