---
layout: post
title: My first Emacs contribution
lang: en
categories: dev emacs lisp workflow
---

@TODO perex matcing the title

This year finally dared to migrate from Vim to Emacs. Utilizing Evil of course, I wasn't capable of magically growing new extremities from my body to constantly press all the Emacs chords. Neither was I capable of doubling my brain capacity to even remember them.

<div class="text-center img-row row">
  <a href="/files/img/emacs-user.jpg">
    <img src="/files/img/emacs-user.jpg" alt="" />
  </a>
  <p>
    Thank you National Geographic and <a href="http://pinterest.com/pin/518406607076836477">Pinterest</a> for this rare depiction of a typical Emacs user in his native environment.
  </p>
</div>


## TODO

Even though I was using Vim for almost ten years and have highly customized and personalized configuration, with a lot of enabled plugins, the migration was quite smooth. A general rule of thumb is, for every possible Vim plugin, there is a better or worse (still sufficient) Emacs alternative. The only hard thing is to find them. Maybe let's discuss this topic in a following article.

There is an exception to this rule - One man show plugins, particularly those you've written and maintain yourself. In my case, it is a [FrostX/vim-fugitive-pagure][vim-fugitive-pagure] plugin, which provides a <pagure.io> support for `:Gbrowse` command. I colaborate with my coworkers remotelly and frequently use this feature. There ~~is~~ was no Emacs alternative so I missed the feature since the migration. I finally decided to implement a <pagure.io> support for [browse-at-remote][browse-at-remote] and there is what I learned from my first Emacs contribution.

Disclaimer: As I repeatedly mentioned, this was my first experience with writting packages for Emacs, therefore this is not an authoritative description of how things works and should be done.


## Gates to hell

Because of the very nature of Lisp language (ability to ...) and Emacs philosophy to assimilate everything, things get very weird very fast. It is a vast underestimation to say, that workflows when using Emacs are unconventional, compared to the rest of the world. That is unquestionably a positive thing but the problem is, that there seems to be a very little material showing the real life usages of Emacs. In this case, explaining how to proceed when writing one's own package. Don't get me wrong, there is a powerfull documentation within Emacs but in the 2020 I would expect a lot of youtube videos, blogs, reddit posts, giving an insinght to custom methods of individual developers.


## TODO

The general ... of advanced Emacs users ([Emacsites][emacsite]) is to start their computer, run Emacs, and never ever leave it. If, god forbids, there is a need to launch and interact with any other application, we need to unite and implement the functionality within an Emacs package. Using other applications strictly violates the believes of the [Church Of Emacs][church-of-emacs].

For new users, this concept is initially very hard to grasp and needs to progress gradually. As a newbie myself, I tried to utilize as many command line tools outside of Emacs and succeeded with following workflow for contributing to an existing package.

First, we will need [Cask][cask], which is a project management tool for Emacs projects (packages). Please see the [installation manual][cask-installation-manual]. It is a bit disapointing there are no official packages for linux distributions. We need to definitelly repent from our sins and create cask package for Fedora. But until then, we need to go with:

	curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python
	cask upgrade-cask
	export PATH="$HOME/.cask/bin:$PATH"

Clone a package that you are interested and change your working directory:

	git clone https://github.com/rmuslimov/browse-at-remote
	cd browse-at-remote

And install all the project dependencies:

	cask install

Hopefully the project has at least some unit tests. In my case, author used [ERT][ert] library. I don't know how many alternatives are there but it seems like a go-to option. You can simply run all the tests with:

	cask exec ert-runner

Now, lets proceed with some [test-driven development][tdd] until the desired feature is finished.

@TODO debugger and print

Let's see the feature in action. Up until this point you probably included the package in your `init.el` like this:

	(use-package browse-at-remote
	  :ensure t)

Temporarily remove it and load the enhanced package from your local storage:

	(add-to-list 'load-path (expand-file-name "~/git/browse-at-remote"))
	(require 'browse-at-remote)

And reload your Emacs configuration by pressing:

	M-x load-file RET

You should be done now. If not, repeat a necessary subset of previous steps.


[vim-fugitive-pagure]: https://github.com/FrostyX/vim-fugitive-pagure
[browse-at-remote]: https://github.com/rmuslimov/browse-at-remote
[cask]: https://cask.readthedocs.io/en/latest/
[cask-installation-manual]: https://cask.readthedocs.io/en/latest/guide/installation.html
[ert]: https://www.gnu.org/software/emacs/manual/html_node/ert/index.html
[tdd]: https://en.wikipedia.org/wiki/Test-driven_development
[church-of-emacs]: https://www.emacswiki.org/emacs/ChurchOfEmacs
[emacsite]: https://stallman.org/extra/church.html
