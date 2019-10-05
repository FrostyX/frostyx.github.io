---
layout: post
title: Vim :Gbrowse support for Pagure
lang: en
categories: dev fedora vim plugin pagure
---

<blockquote class="blockquote">
  <p class="mb-0">When you go to <i>this</i> directory, there is <i>this</i> file. Open it and see a function
  <i>foo</i> definition. In it, there is an incorrect condition. It is at line <i>123</i>.</p>
  <footer class="blockquote-footer">Every software developer working in a team, daily</footer>
</blockquote>

As software developers and sysadmins, we tend to communicate with other people much more than we could have ever
imagined (when choosing this career path mainly as a way to escape the society). Particularly, we discuss semi-real,
self-invented computer problems that supposedly need to be solved and that involves mentioning some existing pieces of
code.

Let's imagine your colleague asks where in the codebase is implemented some functionality. Unless you have an eidetic
memory, you need to switch to your IDE and do a little of detective work to find out. Now, there is the boring part -
explaining someone else what you are looking at. Only if there was a way for them to just see your editor.
Instead, you are left with only two options, one more dull than the other.

1. You can explain in which file it is, on what line(s), and describe approximately how it looks like.
2. You can go to the site, where your codebase is hosted, navigate to the file/line(s) by yourself and send a link to it.


Thank god (or rather notorious Mr. [Tim Pope][tpope]) for [vim-fugitive][vim-fugitive]! Besides many great features,
it provides a `:Gbrowse` command which opens the current file, line or visual selection in your web browser.
The support for various hosting sites is implemented in separate plugins, which are currently available for
[GitHub][github], [GitLab][gitlab], [Bitbucket][bitbucket], [Gitee][gitee] and now also even for [Pagure][pagure]!


## Usage

While working with your code in vim, you can (select one or more lines and) type `:Gbrowse`.

<div class="text-center img">
  <a href="/files/img/gbrowse-vim.png" title=":Gbrowse in vim">
    <img src="/files/img/gbrowse-vim.png" alt="" />
  </a>
</div>


Hit enter and it opens in your browser.

<div class="text-center img">
  <a href="/files/img/gbrowse-chromium.png" title=":Gbrowse in vim">
    <img src="/files/img/gbrowse-chromium.png" alt="" />
  </a>
</div>

Please see [these animated gifs][gifs] for all the use-cases.


## Installation

Use [vundle][vundle], [pathogen][pathogen] or any other favorite way to install vim plugins. Don't forget to install
the [tpope/vim-fugitive][vim-fugitive] plugin first.

    Plugin 'tpope/vim-fugitive'
    Plugin 'FrostyX/vim-fugitive-pagure'

Alternatively, you can install the `vim-fugitive-pagure` RPM package available through
[frostyx/vim-fugitive-pagure][copr] Copr repository. I will try to get it into official Fedora repositories soon!


Let me know what do you think.



[tpope]: https://github.com/tpope
[vim-fugitive]: https://github.com/tpope/vim-fugitive
[github]: https://github.com/tpope/vim-rhubarb
[gitlab]: https://github.com/shumphrey/fugitive-gitlab.vim
[bitbucket]: https://github.com/tommcdo/vim-fubitive
[gitee]: https://github.com/linuxsuren/fugitive-gitee.vim
[pagure]: https://github.com/FrostyX/vim-fugitive-pagure
[gifs]: https://github.com/FrostyX/vim-fugitive-pagure#gbrowse-in-action
[vundle]: https://github.com/VundleVim/Vundle.vim
[pathogen]: https://github.com/tpope/vim-pathogen
[copr]: https://copr.fedorainfracloud.org/coprs/frostyx/vim-fugitive-pagure/
