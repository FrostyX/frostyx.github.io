---
layout: post
title: Ruff only on changed files
lang: en
tags: ruff python
---

Ruff is all the rage nowadays, and rightfuly so. It checks our whole codebase in
under a second (20ms actually) while mypy takes it's sweet time and finishes
around a one minute mark. That being said, this is an appreciation post for both
of these tools, and we will take a look how to run them only on changed code.


## New projects

Creating a new project from scratch is so enjoyable, isn't it? No technical
debt, no backward compatibility, no compromises, all the code is beautifuly
formatted and briliantly architected.  We don't really need to run `pylint`,
`mypy` or `ruff` but we do it anyway just so that it can say that "All checks
passed!" and that we are awesome.

TODO sacrcasm sign

Obviously, I am being sacrastic. But the point is that enabling static analysis
tools for new projects is easy.


## Dilema for legacy projects - Fix everything or not use linters

Now, let's consider projects that has been developped in the span of
decades. Everything is a mess. Running `mypy` or `ruff` overwhelms you with
hundreds or thousands of reports and leaves you with the following dilemma.

Should you just abbandon all hope and forget that this ever happened? Should you
pollute your codebase with a bunch of `# pylint: disable=foo` comments? Or
should you devote the next month of your life into rewriting all the problematic
code while risking to introduce even more bugs in the process?

There is one more option, that our team happily does for years - running `mypy`
(and now `ruff` only on changed files).



## Middleground vcs-diff-lint

There is a tool called csdiff which takes two lists of defects (basically Pylint
errors) and prints only those that changed. They can be understood either as
fixed or newly added defects, depending on whether they appear in the first or
second list of defects.

We created a tool called vcs-diff-lint which does the obvious thing. It runs
`pylint`, `mypy`, and/or, `ruff` for the `main` branch of your git repository,
and then runs them again for your current branch. There are our two lists of
defects which get internally passed to csdiff. And the output is:

```
$ vcs-diff-lint --print-fixed-errors
# ================
#  Added warnings
# ================

Error: PYLINT_WARNING:
fedora_distro_aliases/__init__.py:23:12: E0602[undefined-variable]: bodhi_active_releases: Undefined variable 'Munch'

Error: PYLINT_WARNING:
fedora_distro_aliases/__init__.py:70:13: E0602[undefined-variable]: Distro: Undefined variable 'Munch'

# ================
#  Fixed warnings
# ================

Error: PYLINT_WARNING:
fedora_distro_aliases/__init__.py:55:28: C0209[consider-using-f-string]: get_distro_aliases: Formatting a regular string which could be an f-string
```

We can see two new errors that we introduced in our branch, that we should
definitely fix, and one error that was found in our codebase but this branch
fixes it.

Please see the installation instructions here.


## Github Action

I don't trust myself or anyone else to run the `vcs-diff-lint` tool manually for
every proposed change. And neither should you. There is an easy to use GitHub
action that runs it automatically for every pull request. It tries to be as user
friendly as possible and reports the problems as comments directly in your
"Files changed" section.

TODO screenshot

Please follow the installation instructions here.


## Ruff

Up until recenly, the only supported tools were Pylint and mypy but since the
last release, Ruff is supported as well. Please give it a try.
