---
layout: post
title: Emacs - Browse At Pagure
lang: en
categories: dev emacs vim pagure
---

<!--
title: Emacs - Browse At Pagure
title: Emacs M-x browse-at-remote
title: M-x browse-at-remote for Pagure
-->

Code in Emacs, make a visual selection, `M-x browse-at-remote` to open on pagure.io, share.

Recently I have published an [article][vim-gbrowse-support-for-pagure] about [tpope/vim-fugitive][vim-fugitive] plugin for Vim and its feature that I value the most. That is non-other than `:Gbrowse` command which allows you to easily open a current file or line selection in a web browser. Other contributors already implemented support for [GitHub][github], [GitLab][gitlab], [Bitbucket][bitbucket], and [Gitee][gitee], so I decided to ... and created [vim-fugitive-pagure][vim-fugitive-pagure] to support Pagure.

This year's resolution for me was to migrate to Emacs and since that, the only thing I am missing is :Gbrowse feature. To be precise, there is a [browse-at-remote][browse-at-remote] package providing more than sufficient alternative, but Pagure support is missing. [Not anymore!][pr-63]


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
