---
layout: post
title: LSP for Vim Boomers
lang: en
tags: video vim lsp python
---

There are many great videos and articles about configuring NeoVim LSP
using quickstart plugins or opinionated NeoVim distributions. Here I
would like to focus on people who still use Vim and refuse to use
plugins and custom configuration.

This is a supporting article for my [LSP for Vim Boomers][video]
video, so you can easily copy-paste things. Please watch the video for more information.

<div class="text-center img-row row">
<iframe width="784" height="441" src="https://www.youtube.com/embed/-aIPEOxUCUY?si=qvz4LF3C0s9tWx82" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>



### Installation

```
mkdir -p ~/.vim/pack/vendor/start
cd ~/.vim/pack/vendor/start
git clone https://github.com/prabirshrestha/vim-lsp.git
sudo dnf install python3-lsp-server+all
```

### Configuration

```vim
let g:lsp_diagnostics_enabled = 0

if executable('pylsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
```

### Appendix

There is a plugin not mentioned in the video called
[vim-lsp-settings][vim-lsp-settings]. It features a long list of
programming languages, and for each, configuration which LSP
server should be used. If you wish to make the tradeoff and
depend on one more plugin in exchange for a shorter `~/.vimrc`, then
throw away the Python-specific configuration from the previous example
and do

```
cd ~/.vim/pack/vendor/start
git clone https://github.com/prabirshrestha/vim-lsp.git
```


[video]: https://www.youtube.com/watch?v=-aIPEOxUCUY
[vim-lsp-settings]: https://github.com/mattn/vim-lsp-settings
