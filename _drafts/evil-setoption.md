---
layout: post
title: Evil :set option
lang: en
tags: emacs vim
---

Do you miss all the easy-to-use `:set` commands such as `:set wrap`,
`:set number`, `:set colorcolumn`, `:set expandtab`, and others from
Vim?

## Narcissistic rant

Even though the Evil project itself doesn't claim any such title, the
folk wisdom says that Evil is the best Vim emulation ever
implemented. Naturally, my expectations were high, and boy was I blown
away anyway.

Evil does everything perfectly (or at least good enough to fool me) -
modes, macros, window management, plugins, colon commands (although
not all of them are implemented - I am looking at you `:retab`), etc.

For me, the only major letdown was missing support for `:set`
commands. For instance, my favorite ones - `:set wrap`,
`:set colorcolumn=80`, `:set number`, and `:set expandtab`. Of course,
Emacs has alternatives to achieve all of them. The problem is merely
non-existing `:set` command and therefore inability to access the
options with ease.

## Introducing evil-set-option

For this reason, I created [evil-set-option][github].

Use Quelpa (or your prefered package manager) to install the package.

```lisp
(use-package evil-set-option
  :ensure t
  :quelpa (evil-set-option
           :fetcher github
           :repo "FrostyX/evil-set-option"
           :branch "main")
  :config
  (evil-set-option-mode))
```

And now you can run your favorite `:set` commands.

```
:set wrap
:set number
:set colorcolumn=80
```

and more. See it in action.

TODO gif

Initially, I implemented support for only 20 options that seem to be
the most popular. In case of missing support for your favorite ones,
please submit a [new issue][issues].

In case an option is supported but uses different Emacs settings or
modes that you would prefer, simply replace it with your
implementation.

```lisp
;; TODO Add a real example
;; For example line numbers in old Emacs or something
(defun evil-set-option-number (value)
  (display-line-numbers-mode (if value 1 0))
  (setq display-line-numbers value))
```

## Future plans

I have a bigger picture in mind. The `evil-set-option` won't get
bloated with another functionality apart from adding support for more
and more options. My plan is to create a new package called
`evil-vimrc` that will provide the ability to parse a `.vimrc`
file. The hypothetical code will look like this

```lisp
;; TODO
(evil-vimrc-load "~/.vimrc")
```

And the `~/.vimrc` as expected.

```
set nocompatible
set nowrap
set title
set hlsearch
set incsearch
set ignorecase
...
```

Or alternativelly, defining the `.vimrc` configuration within Emacs
Lisp.

```lisp
;; TODO
(with-evil-vimrc
 (:set nocompatible)
 (:set nowrap)
 (:set title)
 (:set hlsearch)
 (:set ignorecase))
```

Stay tuned.

[evil]: #
[vim]: #
[github]: https://github.com/FrostyX/evil-set-option
[issues]: #
