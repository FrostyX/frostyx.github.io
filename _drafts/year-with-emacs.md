---
layout: post
title: A Year with Emacs
lang: en
tags: dev fedora emacs vim
---

After a decade of exclusively using Vim for all my text editting, I
decided to explore the other side of the barricade and see what the
ethernal adversary is doing. Ever since that day, I live in Emacs.


## Why?

Why would I commit such a heinous crime? After ten years, I came close
to hitting my peak knowledge about VIm. Of course, nobody can truly
claim know Vim in its full depth but many people such as myself get to
the point where the learning curve slows to a deadly pace and new tips
just slightly adjust your approach when solving obscure scenarios. The
only real game-changer yet to be conquered was plugins development. I
[tried][vim-fugitive-pagure] but I dislike VimL as a language for
writing code and thus I have no intention in doing so.

On the other hand, I am fascinated by functional paradigm and Lisp in
particular. This alone, was a strong enough hook for migrating to
Emacs. I won't hit the ceiling regarding custom package development.

Also, I came to realize, that my Vim workflow is different than for
the most other users (at least in my social circle). Everyone seems to
have a shell-centric approach, find-ing, grep-ing, cat-ing their way
though a project and then opening the intended file in Vim, editting
and closing. I do the same thing when it comes to searching things
within a project but I have a separate terminal for that. When it
comes to Vim, I start it once, do everything from within, and then
close it after six months when a new Fedora is released and I need to
upgrade. If it reminds you of something, its Emacs.

There was a couple other features that mildly lured me into the Emacs
world but about them later.


## Preview

On my triple-monitor setup, two of them are dedicated to maximized
Emacs frames. This is how my PIM screen looks like.

TODO screenshot

The main monitor is designated for development.

TODO screenshot

## Migration (my misconceptions)

Due to my heavy addiction to Vim keybindings and modal editing, a
non-negotiable requisite was a decent Vim emulator inside of
Emacs. As it turned out, Evil is not only a great name but also a
great piece of software. However, it is often marketed in a way, that
you don't have to learn Emacs key bindings at all. This was a big
selling point for me, that turned out to not be true.

Yes, Evil is probably the best Vim emulator out there and provides
support for every Vim feature that I know of. The thing we need to
realize is that Emacs has much broader scope than text editting. It is
more of an application platform rather than just an editor. Think of a
Venn diagram where one circle represents the whole Emacs and its
subset, inner circle representing the text editting, which is covered
by Evil. Naturally, for its complement, there cannot be any Vim
keybinds because Vim doesn't support such things. Don't worry
though. You can get far with learning M-x for running commands, M-:
for elisp evaluation, and custom key bindings.

Another unpleasant surprise was that my .vimrc was completely useles
for the migration. For some reason I expected Evil to parse and apply
my current Vim configuration (e.g. ...) and even use the Vim plugins I
had installed. You can laugh at me now. That, of course, is not
possible but in the end it cost me just a couple extra days of field
work. Most of the popular Vim plugins has an authentic Emacs clones.

To spare some time, see this plugin migration table.

TODO plugins migration table

For the migrating the Vim configuration itself, you will need to read
the manual (or my Emacs config) because it is not possible to cover
here. However, I still think it would be pretty amazing if we could
write some package that would parse .vimrc and print elisp code doing
the same thing for Evil. Anyone wants to colaborate on that?

So far, this whole thing may seem like a chore with no benefits. Well,
buckle up.

## IDE on steroids

During the last year, I was basically living in Emacs. It started with
writing code but then Emacs quickly became my RSS agregator, task
manager, IRC client, Email client and kept consuming all standalone
programs. They all share the same configuration language, keybindings,
theme, etc. Thanks to Evil (and some customs), those keybindings
happen to be Vim-like. I love this great paradox that thanks to Emacs,
I have more Vim in my life.

As a consequence, all of these _applications_ are integrated together
and it possible to seamlesly create tasks based on emails, paste
short pieces of code into IRC, viewing a git history and jumping to
the changed files, sending a SQL query to a coworker via email, the
possibilities are endless. Without ever touching a mouse or even
needing the system clipboard. It's all in the Vim/Evil registers, so
yanking and pasting like a true gentleman.

For the past ten years, I was trying to achieve such setup using a
combination of Tmux, Vim, Mutt, Weechat, and other tools but the
experience is vastly different. No matter what, it feels like using a
several single-purpose programs, each of them isolated in its own
bubble and with no way of cooperating with each other.

## Literate config

Since the operating system becames just a bootloader for Emacs (and
maybe a web browser), it means that every _application_ is used and
configured within Emacs. Luckily for us, it has the best configuration
apparatus ever invented. Remember the literate programming paradigm,
that was only briefly noted in school programming curriculum as a
slow, retarded cousin of procedural, and object-oriented paradigms? It
turns out to be pretty fucking awesome after all.

Emacs configuration can be written in Org mode document and can look
like a book explaining various features, settings and customizations,
with a thorough code samples coverage. Quite literaly because it can
be exported as a web page or stylized PDF. See my config on GitHub to
get the idea.

TODO screenshot

## IRC with Vim keybindings

## Org mode for tasks

## Email client, finally

## RSS

## Magit

## Database

## Emacs in browser




[vim-fugitive-pagure]: #
