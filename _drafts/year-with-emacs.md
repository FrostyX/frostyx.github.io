---
layout: post
title: A Year with Emacs
lang: en
tags: dev fedora emacs vim
---

After a decade of exclusively using
[Vim for all my text editing][vim-for-everything], I decided to
explore the other side of the barricade and see what the eternal
adversary is doing. Ever since that day, I live in [Emacs][emacs].


## Why?

Why would I commit such a heinous crime? After ten years, I came close
to hitting my peak knowledge about VIm. Of course, nobody can truly
claim to know Vim in its full depth but many people such as myself get to
the point where the learning curve slows to a deadly pace and new tips
just slightly adjust your approach when solving obscure scenarios. The
only real game-changer yet to be conquered was plugins development. I
[tried][vim-fugitive-pagure] but I dislike [VimL][viml] as a language
for writing code and thus I have no intention of doing so.

On the other hand, I am fascinated by [functional paradigm][functional]
and [Lisp][lisp] in particular. This alone, was a strong enough hook for
migrating to Emacs. I won't hit the ceiling regarding custom package
development.

Also, I came to realize, that my Vim workflow is different than for
most other users (at least in my social circle). Everyone seems to
have a shell-centric approach, find-ing, grep-ing, cat-ing their way
through a project, and then opening the intended file in Vim, editing,
and closing. I do the same thing when it comes to searching things
within a project but I have a separate terminal for that. When it
comes to Vim, I start it once, do everything from within, and then
close it after six months when a new [Fedora is released][fedora-releases]
and I need to upgrade. If it reminds you of something, it's Emacs.

There were a couple of other features that mildly lured me into the Emacs
world but about them later.


## Preview

On my triple-monitor setup, two of them are dedicated to maximized
Emacs frames. This is how my PIM screen looks like.

<div class="text-center img-row row">
  <a href="/files/img/emacs-pim-frame.png">
    <img src="/files/img/emacs-pim-frame-thumb.png"
		 alt="My side monitor dedicated to PIM" />
  </a>
</div>

The main monitor is designated for development.

<div class="text-center img-row row">
  <a href="/files/img/emacs-dev-frame.png">
    <img src="/files/img/emacs-dev-frame-thumb.png"
		 alt="My main monitor that I use for development" />
  </a>
</div>

The goal was to make the setup identical to
[my previous Vim configuration][vim-setup].


## Migration (my misconceptions)

Due to my heavy addiction to Vim keybindings and modal editing, a
non-negotiable requisite was a decent Vim emulator inside of
Emacs. As it turned out, [Evil][evil] is not only a great name but also a
great piece of software. However, it is often marketed in a way, that
you don't have to learn Emacs key bindings at all. This was a big
selling point for me, that turned out to not be true.

Yes, Evil is probably the best Vim emulator out there and provides
support for every Vim feature that I know of. The thing we need to
realize is that Emacs has a much broader scope than text editing. It is
more of an application platform rather than just an editor. Think of a
Venn diagram where one circle represents the whole Emacs and its
subset, inner circle representing the text editing, which is covered
by Evil. Naturally, for its complement, there cannot be any Vim
keybindings because Vim doesn't support such things. Don't worry
though. You can get far with learning `M-x` for running commands, `M-:`
for Elisp evaluation, and custom key bindings.

Another unpleasant surprise was that my [.vimrc][vimrc] was completely useless
for the migration. For some reason I expected Evil to parse and apply
my current Vim configuration (e.g. ...) and even use the Vim plugins I
had installed. You can laugh at me now. That, of course, is not
possible but in the end, it cost me just a couple extra days of fieldwork. Most
of the popular Vim plugins have authentic Emacs clones.

To spare some time, see this plugin migration table.

{:.table .table-striped}
| Vim plugin                             | Emacs alternative                     | Note                                 |
| -------------------------------------- | ------------------------------------- | ------------------------------------ |
| [Vundle.vim][vundle]                   | [use-package][use-package]            | Emacs has a built-in package manager |
| [vim-fugitive][fugitive]               | [magit][magit]                        |                                      |
| [vim-rhubarb][rhubarb]                 | [browse-at-remote][browse-at-remote]  |                                      |
| [vim-sleuth][sleuth]                   | [dtrt-indent][dtrt]                   |                                      |
| [vim-fugitive-pagure][fugitive-pagure] | [browse-at-remote][browse-at-remote]  |                                      |
| [nerdtree][nerdtree]                   | [neotree][neotree]                    | Use [dired][dired] instead, trust me |
| [fzf.vim][fzf]                         | [helm][helm]                          | Much more then just fzf              |
| [tcomment_vim][tcomment]               | [evil-commentary][commentary]         |                                      |
| [matchit][matchit]                     | [evil-matchit][evil-matchit]          |                                      |
| [delimitMate][delimitmate]             | [smartparens][smartparens]            |                                      |
| [Vim-Jinja2-Syntax][jinja2]            | [jinja2-mode][jinja2-mode]            |                                      |
| [vim-markdown][markdown]               | [markdown-mode][markdown-mode]        |                                      |
| [syntastic][syntastic]                 | [company-mode][company-mode]          |                                      |
| [vimwiki][vimwiki]                     | [org-mode][org-mode]                  |                                      |
| [goyo.vim][goyo]                       | [writeroom][writeroom]                |                                      |
| [base16-vim][base16]                   | [base16-theme][base16-theme]          |                                      |
| [vim-css-color][css-color]             | [rainbow-mode][rainbow-mode]          |                                      |



For migrating the Vim configuration itself, you will need to read
the manual (or my Emacs config) because it is not possible to cover
here. However, I still think it would be pretty amazing if we could
write some package that would parse `.vimrc` and print Elisp code doing
the same thing for Evil. Anyone wants to collaborate on that?

So far, this whole thing may seem like a chore with no benefits. Well,
buckle up.


## IDE on steroids

During the last year, I was basically living in Emacs. It started with
writing code but then Emacs quickly became my RSS aggregator, task
manager, IRC client, Email client and kept consuming all standalone
programs. They all share the same configuration language, keybindings,
theme, etc. Thanks to Evil (and some customs), those keybindings
happen to be Vim-like. I love this great paradox that thanks to Emacs,
I have more Vim in my life.

As a consequence, all of these _applications_ are integrated together
and it possible to seamlessly create tasks based on emails, paste
short pieces of code into IRC, viewing a git history and jumping to
the changed files, sending a SQL query to a coworker via email, the
possibilities are endless. Without ever touching a mouse or even
needing the system clipboard. It's all in the Vim/Evil registers, so
yanking and pasting like a true gentleman.

For the past ten years, I was trying to achieve such a setup using a
combination of [Tmux][tmux], [Vim][vim], [Mutt][mutt], [Weechat][weechat], and
other tools but the experience is vastly different. No matter what, it feels
like using several single-purpose programs, each of them isolated in its own
bubble and with no way of cooperating with each other.


## Literate config

Since the operating system becomes just a bootloader for Emacs (and
maybe a web browser), it means that every _application_ is used and
configured within Emacs. Luckily for us, it has the best configuration
apparatus ever invented. Remember the
[literate programming paradigm][literate-programming],
which was only briefly noted in school programming curriculum as a
slow, retarded cousin of procedural, and object-oriented paradigms? It
turns out to be pretty fucking awesome after all.

Emacs configuration can be written in an [Org-mode][org-mode] document and can
look like a book explaining various features, settings, and customizations, with
thorough code sample coverage. Quite literally because it can be exported as a
web page or stylized PDF. See [my config on GitHub][emacs-config] to get the
idea.

<div class="text-center img-row row">
  <a href="/files/img/emacs-config-source.png">
    <img src="/files/img/emacs-config-source.png"
		 alt="The whole Emacs configuration can be an Org document" />
  </a>
</div>

The Org configuration file renders beautifully on GitHub and possibly other Git
forges.

<div class="text-center img-row row">
  <a href="/files/img/emacs-config-web.png">
    <img src="/files/img/emacs-config-web.png"
		 alt="The config is beautifully rendered on GitHub" />
  </a>
</div>


## IRC with Vim keybindings

[Weechat][weechat-homepage] is an exceptionally good piece of software but to be
honest I was aching to replace it for quite some time. There just wasn't a
better alternative. My frustrations were caused solely by two pitfalls.

~~Copy-pasting from Tmux + Weechat combo is god-awful and borderline
psychotic. Imagine Weechat window vertically split into multiple
panes. Since it is an application running in a single terminal
window, the terminal has no perception of any separation, splits, or
panes that are displayed within. Selecting a multi-line text with a
mouse, therefore, isn't limited to the desired pane but rather to
everything that stands in the way. The copied text then contains
mixed messages from multiple chat windows, ASCII symbols that were
used as separators, timestamps, and all.~~ Copy-pasting from Tmux + Weechat is
quite alright if you are aware of
[rectangle selection][tmux-rectangle-selection].

Apart from this, I was always uncomfortable with
[Weechat's approach to generated configuration files][weechat-configs].
While it is generally looked at as a feature allowing to configure Weechat from
within itself, saving its current state, and eliminating the need to edit the
configuration file in its written form. I never grew accustomed to this paradigm
and prefer to edit configuration files by hand.

[Circe][circe] is in many aspects inspired by Weechat and inherits some of its
traits while eradicating the pitfalls beyond perfectly. Circe chat
windows are standard Emacs buffers with full Vim emulation and shared
registers with the whole ecosystem. Lisp configuration also surpasses
anything else we could wish for.

<div class="text-center img-row row">
  <a href="/files/img/circe.png">
    <img src="/files/img/circe.png"
		 alt="Circe IRC client" />
  </a>
</div>


## Email client, finally

Accessing email in the terminal was a recurring nerd-fantasy of mine ever since
I started using GNU/Linux in 2008. Up until very recently, all my
attempts of achieving this holy grail rendered futile.

Finally, I could check this out of my list thanks to a combination of
[mbsync][mbsync] and [mu4e][mu4e]. There is nothing much to say. It is an email
client. Inside of Emacs. But for some undefinable reasons, it is the
greatest thing ever invented.

The hardest part isn't the email client configuration itself but
rather synchronization with IMAP (in the age of two-factor
authentication). If you are interested, I wrote a whole article on
this topic - [Synchronize your 2FA Gmail with mbsync][mbsync-blogpost]

<div class="text-center img-row row">
  <a href="/files/img/mu4e.png">
    <img src="/files/img/mu4e.png"
		 alt="Mu4e mail client" />
  </a>
</div>


## Magit

[Magit][magit] is one of the tools that I would refuse to believe that I might
enjoy using. What's the point with `git diff`, `git add`, and `git
commit` commands already hard-wired in my muscle memory in such a
manner, that executing them resembles more of an involuntary spasm
rather than typing words.

Yet, I am forever hooked to Magit now. One shall never stage a whole
file before checking its `git diff` (because of possible unwanted
changes). That's two commands per file, all the time. Whereas Magit
provides a compact view of files and their changes at once. Staging a
whole file or its chunks is then a matter of pressing one key.

Committing, pushing, Iterating over a series of commits, blaming,
rebasing, everything is a bit more convenient. I still use the `git`
command for more complicated operations though.

<div class="text-center img-row row">
  <a href="/files/img/magit.png">
    <img src="/files/img/magit.png"
		 alt="Magit" />
  </a>
</div>


## Emacs in browser

As a software engineer, I frequently engage in technical discussions on
various git forge sites (such as [GitHub][github], [Pagure.io][pagure]), and
[Reddit][reddit]. Consequently, I write comments containing pieces of code on
daily basis (either being code reviews and suggestions, bug
reproducers, or proposed solutions).

My workflow would usually involve firing up the good ol' text editor,
pre-formatted the code there, and then copy-pasted it into the comment
text area. Omitting this step, and editing the code directly in the
web browser is sometimes bearable but especially adjusting whitespace
sucks that much, that you eventually end up spawning a text editor and
regretting you didn't do it in the first place.

[Edit with Emacs][edit-with-emacs] is a handy convenience tool that
provides a key binding to make a temporary Emacs frame with the
contents of your text area. After you are done, it pipes the output
back to the browser.

There is nothing special about this functionality in regards to Emacs
and surely there is a plugin out there doing this with any text
editor.

On the contrary, I think Emacs lags behind Neovim in this scenario,
which is able to transform the textarea into a Neovim instance
directly in the web browser thanks to [Firenvim][firenvim].

<div class="text-center img-row row">
  <a href="/files/img/edit-with-emacs.png">
    <img src="/files/img/edit-with-emacs.png"
		 alt="Magit" />
  </a>
</div>



[vim-for-everything]: /posts/software-tips-for-nerds#vim-for-everything
[emacs]: https://www.gnu.org/software/emacs/
[viml]: https://learnvimscriptthehardway.stevelosh.com/
[vim-fugitive-pagure]: /posts/vim-gbrowse-support-for-pagure
[functional]: https://xkcd.com/1270/
[lisp]: https://lisp-lang.org/
[fedora-releases]: https://en.wikipedia.org/wiki/Fedora_version_history#Version_history
[vim-setup]: /files/img/2019-desktop.png
[evil]: https://github.com/emacs-evil/evil
[vimrc]: https://github.com/FrostyX/dotfiles/blob/master/.vimrc
[tmux]: /posts/software-tips-for-nerds#tmux
[weechat]: /posts/software-tips-for-nerds#weechat
[mutt]: http://www.mutt.org/
[vim]: https://github.com/vim/vim
[literate-programming]: https://en.wikipedia.org/wiki/Literate_programming
[org-mode]: https://orgmode.org/
[emacs-config]: https://github.com/FrostyX/dotfiles/blob/master/.emacs.d/frostyx.org
[weechat-homepage]: https://weechat.org/
[weechat-configs]: https://weechat.org/files/doc/devel/weechat_faq.en.html#editing_config_files
[circe]: https://github.com/jorgenschaefer/circe
[tmux-rectangle-selection]: https://superuser.com/a/693990
[mbsync]: https://wiki.archlinux.org/title/isync
[mu4e]: https://www.djcbsoftware.nl/code/mu/mu4e.html
[magit]: https://magit.vc/
[mbsync-blogpost]: http://frostyx.cz/posts/synchronize-your-2fa-gmail-with-mbsync
[edit-with-emacs]: https://github.com/stsquad/emacs_chrome
[github]: https://github.com/
[pagure]: https://pagure.io/
[reddit]: https://reddit.com/
[firenvim]: https://github.com/glacambre/firenvim

[vundle]: https://github.com/VundleVim/Vundle.vim
[fugitive]: https://github.com/tpope/vim-fugitive
[rhubarb]: https://github.com/tpope/vim-rhubarb
[sleuth]: https://github.com/tpope/vim-sleuth
[fugitive-pagure]: https://github.com/FrostyX/vim-fugitive-pagure
[nerdtree]: https://github.com/preservim/nerdtree
[fzf]: https://github.com/junegunn/fzf.vim
[tcomment]: https://github.com/junegunn/fzf.vim
[matchit]: https://github.com/adelarsq/vim-matchit
[delimitmate]: https://github.com/Raimondi/delimitMate
[jinja2]: https://github.com/Glench/Vim-Jinja2-Syntax
[markdown]: https://github.com/plasticboy/vim-markdown
[syntastic]: https://github.com/vim-syntastic/syntastic
[vimwiki]: https://github.com/vimwiki/vimwiki
[goyo]: https://github.com/junegunn/goyo.vim
[base16]: https://github.com/chriskempson/base16-vim
[css-color]: https://github.com/ap/vim-css-color

[use-package]: https://github.com/jwiegley/use-package
[magit]: https://github.com/magit/magit
[browse-at-remote]: https://github.com/rmuslimov/browse-at-remote
[dtrt]: https://github.com/jscheid/dtrt-indent
[neotree]: https://github.com/jaypei/emacs-neotree
[dired]: https://www.gnu.org/software/emacs/manual/html_node/emacs/Dired.html
[helm]: https://github.com/emacs-helm/helm
[commentary]: https://github.com/linktohack/evil-commentary
[evil-matchit]: https://github.com/redguardtoo/evil-matchit
[smartparens]: https://github.com/Fuco1/smartparens
[jinja2-mode]: https://github.com/paradoxxxzero/jinja2-mode
[markdown-mode]: https://github.com/jrblevin/markdown-mode
[company-mode]: https://github.com/company-mode/company-mode
[writeroom]: https://github.com/joostkremers/writeroom-mode
[base16-theme]: https://github.com/belak/base16-emacs
[rainbow-mode]: https://elpa.gnu.org/packages/rainbow-mode.html
