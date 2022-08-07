---
layout: post
title: Emacs - Evil :set option
lang: en
tags: emacs vim evil
---

Do you miss all the easy-to-use `:set` commands from Vim? You know,
`:set wrap`, `:set number`, `:set colorcolumn`, `:set expandtab`, etc.

## Narcissistic rant

Even though the [Evil][evil] project itself doesn't claim any such
title, urban legends say that Evil is the best Vim emulator ever
implemented. Naturally, my expectations were high. And yet, I was
blown away. Evil does everything perfectly (or at least well enough to
fool me) - modes, macros, window management, plugins, colon commands
(although not all of them are implemented - I am looking at you
`:retab`).

For me, the only major letdown was missing support for `:set`
options such as `:set wrap`, `:set number`, and so on.
Of course, Emacs has its own commands for achieving the same behavior. My issue
is simply the non-existing`:set` command and, therefore, inability to use the
options that I already know.


## Introducing evil-set-option

For this reason, I created [evil-set-option][github].


<div class="text-center img">
  <img class="gifplayer" src="/files/img/evil-set-option/evil-set-option.png" alt="" />
  <p>Click, it's a gif!</p>
</div>


## Installation

Use Quelpa (or
any package manager that you prefer) to install the package.

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

## Supported options

Currently, only a dozen of options that seemed to be the most
popular, are supported. Vim comes with [hundreds of
options][vim-options], and for understandable reasons, I wasn't going
to implement all of them within the first release. Please [let me
know][issues] what are your favorite options that we simply must have.

The list of all currently supported options [can be found
here][supported-options].

## Custom option behavior


Sometimes the default implementation of an option might not be
applicable. You might want to use a different mode that suits your build more,
you might run an older version of Emacs, that doesn't support some modes,
etc. In such cases, you can override the default implementation.

```lisp
;; The default implementation for `:set number' uses
;; `display-line-numbers-mode' which is available since Emacs 26.
;; See https://www.emacswiki.org/emacs/LineNumbers
;; You can override it to use `linum-mode' instead

(defun evil-set-option-number (value)
  (linum-mode (if value 1 0)))
```

## Future plans

I have a bigger picture in mind. The `evil-set-option` package won't
get
bloated with another functionality apart from supporting more
and more options. My plan is to create a new package called
`evil-vimrc` that will provide the ability to parse a `.vimrc` file -
although very naively. [VimL][viml] is a full-featured scripting
language and it would require executing the config file code to parse
the options accurately. I don't think that would be time worth
spending. A dummy implementation that parses all `set` statements is
still going to be useful in many cases.

The hypothetical usage will look like this

```lisp
(evil-vimrc-load "~/.vimrc")
```

And the `~/.vimrc` as expected.

```
set nocompatible
set nowrap
set title
set expandtab
```

Or alternativelly, defining the `.vimrc` configuration within Emacs
Lisp.

```lisp
(evil-vimrc
 (:set nocompatible)
 (:set nowrap)
 (:set title)
 (:set expandtab))
```

Stay tuned.

[evil]: https://github.com/emacs-evil/evil
[github]: https://github.com/FrostyX/evil-set-option
[issues]: https://github.com/FrostyX/evil-set-option/issues
[vim-options]: http://vimdoc.sourceforge.net/htmldoc/quickref.html#option-list
[supported-options]: https://github.com/FrostyX/evil-set-option/blob/main/options.org
[viml]: https://learnvimscriptthehardway.stevelosh.com/
