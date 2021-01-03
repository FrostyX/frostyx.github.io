---
layout: post
title: Emacs - Browse At Pagure
lang: en
tags: dev emacs vim pagure
---

TL;DR: Work in Emacs, select some lines, press `M-x browse-at-remote` to open it on pagure.io, and share the URL.

Recently I have published an article about `:Gbrowse` command in Vim, that allows you to open a current file or line selection on a remote hosting platform, such as [GitHub][github], [GitLab][gitlab], etc. The command is provided by [tpope/vim-fugitive][vim-fugitive] plugin, you should definitely check it out. Other contributors already implemented support for various hosting sites, so I decided to go ahead and create [vim-fugitive-pagure][vim-fugitive-pagure] extension to support also [pagure.io][pagure.io].

One of the annual goals that I set for myself was to finally migrate to Emacs. Everything is going well, the only thing that I am missing since then is the `:Gbrowse` feature. To be precise, there is a [browse-at-remote][browse-at-remote] package providing more than sufficient alternative, but Pagure support is missing. Well, [not anymore][pr-63]!


## Usage

While working with your code in Emacs, select one or more lines and run `M-x browse-at-remote`.

<div class="text-center img">
  <img class="gifplayer" src="/files/img/browse-at-remote/browse-at-remote.png" alt="" />
</div>


## Installation

The package is available on [MELPA][on-melpa].

``` lisp
(use-package browse-at-remote
  :ensure t)
```



[pagure.io]: https://pagure.io/
[vim-gbrowse-support-for-pagure]: http://frostyx.cz/posts/vim-gbrowse-support-for-pagure
[vim-fugitive]: https://github.com/tpope/vim-fugitive
[github]: https://github.com/tpope/vim-rhubarb
[gitlab]: https://github.com/shumphrey/fugitive-gitlab.vim
[bitbucket]: https://github.com/tommcdo/vim-fubitive
[gitee]: https://github.com/linuxsuren/fugitive-gitee.vim
[vim-fugitive-pagure]: https://github.com/FrostyX/vim-fugitive-pagure
[browse-at-remote]: https://github.com/rmuslimov/browse-at-remote
[pr-63]: https://github.com/rmuslimov/browse-at-remote/pull/63
[on-melpa]: https://melpa.org/#/browse-at-remote
