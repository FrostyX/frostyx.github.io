---
layout: post
title: Stop distro hopping for great good
lang: en
tags: linux fedora
---

I spend a lot of time on Reddit, Mastodon, and Youtube and
frequently come accross people switching from one GNU/Linux
distribution to another. Asking for recommendations. Of course,
they are free to do whatever they want and assess their reasons
for hopping by their own judgement. Even though I will probable be heavily
downvoted for this, I'd like to recommend an alternative which I think is more
meaningful.


## Distro hopping is okay

Before burning me at the cross like a heretic, please let me
acknowledge there are good reasons for distro hopping.

For instance, frequently switching distributions is a great
learning experience for new linux users, as a form of an
exposure therapy. It can help with the fear of installing
operating systems, give an opportunity for a do-over for common
pitfalls such as imperfect disk partitions. I'll help you
explore what distributions are out there, get familiar with
their strenghts and weakneses, and have tho knowledge in the bank.
Once new use-case arises (you need to deploy a server, some IoT
device, hack your car ...), you already know the best tool for the
job.

Some distributions are just different and there is no way to
recreate the experience. If an immutable distribution is the best
choice for your situation, switching from Fedora Workstation to
Fedora Silverblue is a no-brainer. If reproducibility has the
utmost value, ditching your standard distributions for NixOS might
be a good idea. If you want your perfect Lisp machine, GNU Guix
will get you there.

Distro hopping because of a new job is perfectly justifiable
as well. I loved my Gentoo dearly and would be using it till
the end of days. However, after getting hired by RedHat to work
on an RPM packaging ecosystem, it just doesn't make sense to
run anything else on my workstation othen Fedora.

Distributions also come and go. You don't have to use
Mandrake Linux just because that's what you've always used.
In fact, you probably shouldn't.

The last point that I want to address is that installing
a distribution in a VirtualBox machine just to take a quick
glance at what is new, and then deleting the machine isn't
something I would consider to be distro hopping.


## My distro hopping journey

My journey started in 2008 by installing Slackware on a PC
that my friends assembled basically out of garbage. Then
migrating my Laptop from Windows Vista to Ubuntu. I hopped
Kubuntu because it looked cooler, and Debian because of the
joke that "Ubuntu is an ancient African word, meaning - I can't
configure Debian". I hopped to CrunchBang because #! was l33t.
I hopped to Sabayon because Gentoo was too scary, and then I
hopped to Arch because I wanted to tell people, that _I use
Arch btw_. Then I hopped to Gentoo because it was the only
thing left to conquer. Finally, I hopped to Fedora because of
my job.

As you can see, I did plenty of distro hopping and I had
only the best of reasons for doing so.


## Problems with distro hopping

It seems to me that my fellow distro hoppers has similarly shallow reasons. The
grass is simply always greener on the other side. Please let me elaborate on why
I think it is not worth your time.

One of the major problems is that it won't probably teach you as much as you
think. When you migrate from Slackware, to Debian, Void Linux, and then to
Gentoo, you will get your hands on various [init systems][init-systems]. Namely,
SysVinit, Systemd, runit, and OpenRC. But is this knowledge useful and have you
trully learned something in the first place? Admitedly, you can compare the user
experience of each of those systems, which may prove itself useful when creating
a new init system. But besides that, you learned to say "hello" in Japanese,
French, and Portugese while never planning to visit those countries. The same
goes for [package managers][package-managers]. Switching from RPM to APT,
Pacman, or Portage teaches you different syntax for doing the same thing, while
any of them are transferable. And the end result is always the same, you learn
how to search, install, and remove packages. My grandma knows how to do
that. The problem is, you are always moving only laterally.

Another major problem is that the mere fact of distro hopping doesn't create any
value for anybody and therefore isn't satisfying. Afterall, nobody cares that
you can use your customized system if you don't use it for anything and its
whole point of existence is to exist. I know, you will tell me, that we do it
because we like the challenge. But that isn't truely satisfying either, that's
why we chase the next high so soon afterward. We are addicts, basically.

My point is that GNU/Linux distributions, window managers, text editors, and
programming languages are not the end game. They are only tools to be used for
achieving the end game. There is only one exception and that is if you are a
developer or maintainer of such tools. And YOU can be that person.

Last but not least, difference between some distributions is so miniscule that
reinstalling the whole system because of it is a lunacy in my book. If some
distribution only enables a third-party repository, uses a different window
manager, or a different theme, you can do that on your current distribution. And
you'll probably get much more out of it.


## Get involved

Okay, so what to do when you are enthusiastic about GNU/Linux distributions (or
potentially window managers, text editors, or programming languages)? Well
that's simple my dear nerd. Start contributing to one. There are tons of work
that need to be done, volunteers are more than welcome, and you can bet your
contributions will make people's lives easier.

At the core of every GNU/Linux distribution is its packaging
ecosystem. The major distributions offer 20k-50k packages in the main
repositories and whatever number of packages in additional third party
repositories. That may sound like a lot but important pieces of software are
missing wherever you look. Remember what applications you needed to install by
clonning their git repository and running some obscure `make && make install`
variant. Package them, it's not that dificult. Did you get some of your packages
into the official repositories? There was probably a review process
involved. Try to touch it from the other end, review somebody else's package. By
then, you form some opinions on how to improve some of the processes, pitch them
to others. There is always a next level.

Every software has bugs. More popular it is, more of them gets reported. And you
wouldn't believe how few developers work on major projects like package
managers, window managers, and various desktop components. Let me be completely
random here, DNF5 has ~200 open issues, Qtile has ~150 open issues, Neovim has
~1500 open issues. If you use them, some of the issues certainly affect you as
well. Pick the one which annoys you the most, get intimate with it (learn
everything you can about it), submit a pull request with a fix. Be the hero that
people need.

Is fixing the bug beyond your abilities? Do not despair, there are other things
you can do. One of the most time consuming tasks for developers is to figure
out, how to reproduce the issue. If you can figure this out for them, they will
be genuenly thankful. It is also the best way to stack the odds in the favor
that somebody will fix the issue.

Free and open-source software is used all over the world by all kinds of
people. Many of them not speaking English. Consider helping with translating
your distribution to languages that you speak.

Software engineers usually despise writing so documentation and wiki pages are
often outdated, incomplete, or never existed in the first place. Whenever you
have to figure out how to do something instead of following instructions, be the
one who writes them. The person trying to achieve the same thing in the future
will thank you. Maybe the person will be you. If you prefer writing on your own
terms, start a blog.

Another thing that software engineers are particularly bad at is graphics. We
suck at choosing colorschemes for our websites, creating logos for our projects,
and making things visually appealing in general. If you have an artistic spirit
in you, this is a perfect opportunity to contribute.


## What's in it for you?

Helping others is fine and all but what's in it for you?

Put the list of ten distributions that you used in your resume and nobody will
care. No more than if you have listed one. For the recruiter it will simply mean
"Linux experience, checked. Next question ...". However, put the list of ten
projects that you contributed to in your resume, and you have something to talk
about for the next hour. I never had to jump through any hoops on job inteviews
such as hand-written coding on the whiteboard, implementing assigments under the
terror of a stopwatch, or never-ending homeworks. We could simply talk about my
past and current projects because there is a lot of code on my My GitHub profile
and many articles on my blog.

It may sound cheesy to you as it did to me but many great minds of our time
agree serving and helping others is deeply satisfying endeavor which gives your
life a meaning. I am no philosopher but my experience support this theory. If
this sounds ridiculous to you, just try it.

Free and open-source projects are shaped by their contributors. Often there is
no governing body, no corporate interests, no lizzard people pulling the
strings behind the scene. Things are usually done the way there are because some
random person did it that way. If you propose better or different solution, you
can shape the project for the better of everybody, including yourself.



[init-systems]: #
[package-managers]: #
[dnf5-issues]: https://github.com/rpm-software-management/dnf5/issues
[qtile-issues]: https://github.com/qtile/qtile/issues
[neovim-issues]: https://github.com/neovim/neovim/issues
