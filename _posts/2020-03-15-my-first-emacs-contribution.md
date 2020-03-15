---
layout: post
title: My first Emacs contribution
lang: en
categories: dev emacs lisp workflow
---

You may already notice, that I like to customize and improve the tools that I use daily, share the configuration with others and write blog posts about what I learned while doing it. On today's menu, Emacs and its packages.

This year I finally dared to migrate from Vim to Emacs - utilizing [Evil][evil] of course. I wasn't capable of magically growing new extremities from my body to constantly press all the Emacs chords. Neither was I capable of doubling my brain capacity to even remember them.

<div class="text-center img-row row">
  <a href="/files/img/emacs-user.jpg">
    <img src="/files/img/emacs-user.jpg" alt="" />
  </a>
  <p>
    Thank you National Geographic and <a href="http://pinterest.com/pin/518406607076836477">Pinterest</a> for this rare depiction of a vanilla Emacs user in his native environment.
  </p>
</div>


Even though I was using Vim for almost ten years and have a highly customized and personalized configuration with a lot of enabled plugins, the migration was quite smooth. A general rule of thumb is, for every possible Vim plugin, there is a better or worse (still sufficient) Emacs alternative. The only hard thing is to find them. Maybe let's discuss this topic in another article.

There is an exception to this rule though - one-man show plugins, particularly those you've written and maintain yourself. In my case, it is a [FrostX/vim-fugitive-pagure][vim-fugitive-pagure] plugin, which provides a [pagure.io][pagure] support for `:Gbrowse` command. I collaborate with my coworkers remotely and make frequent use of it. There ~~is~~ was no Emacs alternative so I missed the feature since migration. I finally [decided to implement][browse-at-pagure] a [pagure.io][pagure] support for [browse-at-remote][browse-at-remote] and here follows what I learned from my first Emacs contribution.

<div class="alert alert-warning" role="alert">
Disclaimer: As I repeatedly mentioned, this was my first experience with writing packages for Emacs, therefore this is not an authoritative manual of how things work and should be done.
</div>


## Still ranting

Because of the very nature of Lisp language (its ability to modify programs while they run) and Emacs philosophy to consume everything, things get very weird very fast. It is a vast underestimation to say, that workflows when using Emacs are unconventional, compared to the rest of the world. Although it is a positive thing, the problem is that there seems to be very little material showing the real-life usages of Emacs. In this case, explaining how to proceed when writing one's own package. Don't get me wrong, there is powerful documentation within Emacs but in 2020 I would expect a lot of youtube videos, blogs, reddit posts, etc giving an insight to custom methods of individual developers.


## Assimilate everything

A dream of advanced Emacs users ([Emacsites][emacsite]) is to start their computer, run Emacs, and never ever leave it. If God forbids there is a need to launch and interact with any other application, we need to unite and implement the functionality within an Emacs package. Using other applications is against the beliefs of the [Church Of Emacs][church-of-emacs].

For new users, this concept is initially very hard to grasp, so it makes sense to progress gradually. As a newbie myself, I tried to utilize as many command-line tools outside of Emacs and ended up with the following workflow for contributing to an existing package.


## My workflow

First, we will need [Cask][cask], which is a management tool for Emacs projects (packages). Please see the [installation manual][cask-installation-manual]. It is a bit disappointing that there are no official packages for Linux distributions, we definitely need to repent from our sins and create a cask package for Fedora. But until then, we need to go with:

```bash
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
export PATH="$HOME/.cask/bin:$PATH"
cask upgrade-cask
```

Clone a package that you are interested in and change your working directory:

```bash
git clone https://github.com/rmuslimov/browse-at-remote
cd browse-at-remote
```

Install all the package dependencies:

```bash
cask install
```

Hopefully, the project has at least some unit tests. In my case, the author used a library called [ERT][ert]. I don't know how many alternatives are there but it seems like a go-to option. You can simply run all the tests with:

```bash
cask exec ert-runner
```

Now, let's proceed with some [test-driven development][tdd] until the desired feature is finished. I spend several hours [trying to figure out how to have an interactive debugger][how-to-use-debugger] using [edebug][edebug] but unsuccessfully. Therefore, I needed to get by using just `(print foo)` to evaluate expressions.

Once the feature is done, let's see it in action. Up until this point you probably included the package in your `init.el` like this:

```lisp
(use-package browse-at-remote
  :ensure t)
  ```

Temporarily remove it and load the enhanced package from your local directory:

```lisp
(add-to-list 'load-path (expand-file-name "~/git/browse-at-remote"))
(require 'browse-at-remote)
```

And reload your Emacs configuration by pressing:

```
M-x load-file RET
```

or restarting the Emacs entirely. You should be done now. If not, repeat a necessary subset of previous steps.


<div class="pull-right">
<code><strike>C-x C-c</strike></code> <code>:wq</code>
</div>


[evil]: https://github.com/emacs-evil/evil
[vim-fugitive-pagure]: https://github.com/FrostyX/vim-fugitive-pagure
[browse-at-remote]: https://github.com/rmuslimov/browse-at-remote
[cask]: https://cask.readthedocs.io/en/latest/
[cask-installation-manual]: https://cask.readthedocs.io/en/latest/guide/installation.html
[ert]: https://www.gnu.org/software/emacs/manual/html_node/ert/index.html
[tdd]: https://en.wikipedia.org/wiki/Test-driven_development
[church-of-emacs]: https://www.emacswiki.org/emacs/ChurchOfEmacs
[emacsite]: https://stallman.org/extra/church.html
[pagure]: https://pagure.io/
[edebug]: https://www.gnu.org/software/emacs/manual/html_node/elisp/Edebug.html
[how-to-use-debugger]: https://www.reddit.com/r/emacs/comments/fempfv/how_to_use_debugger/fjrdndo/?utm_source=share&utm_medium=web2x
[browse-at-pagure]: http://frostyx.cz/posts/emacs-browse-at-pagure
