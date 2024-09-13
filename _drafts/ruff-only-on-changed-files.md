---
layout: post
title: Ruff my dirty code
lang: en
tags: ruff python dev github
---

[Static analysis tools][static-analysis-tools] have their limitations but
regardless they help us quickly discover many types of bugs. That is not a
controversial take. What may be disputed is whether enabling them is worth the
effort and I would say it most definitely is.  In this article we are going to
take a look at how to report problems only for new code, lowering the barrier to
entry to the minimum.


## The dilemma

Creating a new project from scratch is so enjoyable, isn't it? No technical
debt, no backward compatibility, no compromises, all the code is beautifully
formatted and brilliantly architected. We don't really need to run any static
analysis tools but we do it anyway just so that they can say that "All checks
passed!" and that we are awesome. Obviously, I am being sarcastic, but the point
is that enabling such tools for new projects is easy.

Now, let's consider projects that have been developed in the span of
decades. Everything is a mess. Running [pylint][pylint], [mypy][mypy] or
[ruff][ruff] overwhelms you with hundreds or thousands of reports and leaves you
with the following dilemma - Should you just abandon all hope and pretend that
this never happened?  Should you pollute your codebase with a bunch of `#
pylint: disable=foo` comments? Or should you devote the next month of your life
to rewriting all the problematic code while risking to introduce even more bugs
in the process?

There is one more option that worked for our team quite well for years now -
running static analysis tools for the whole project but reporting only
newly introduced problems.

## Reporting only new problems

There is a tool called [csdiff][csdiff] which takes two lists of defects
(formatted errors from static analysis tools) and prints only defects that
changed. This can be understood either as fixed or newly added defects,
depending on whether they appear in the first or second list.

We created a tool called [vcs-diff-lint][vcs-diff-lint] which does the obvious
thing. It runs [pylint][pylint], [mypy][mypy], and [ruff][ruff] for the `main`
branch of your git repository, and then runs them again for your current
branch. There we have our two lists of defects which get internally passed to
csdiff. The output looks like this.

```
$ vcs-diff-lint
Error: RUFF_WARNING:
fedora_distro_aliases/__init__.py:23:20: F821[undefined-name]: Undefined name `requests`

Error: MYPY_ERROR:
fedora_distro_aliases/__init__.py:11: mypy[error]: "None" has no attribute "append"  [attr-defined]
```

We can clearly see that our code introduced two new errors. Sometimes it may be
useful to also see how many existing errors our code fixed. In that case, use
`vcs-diff-lint --print-fixed-errors`.

Please follow the [installation instructions][install-tool] here.


## Github Action

I don't trust myself (or anyone else for that matter) to run the `vcs-diff-lint`
tool manually for every proposed change. And neither should you. There is an
easy-to-use [GitHub action][github-action] that runs the tool automatically for
every pull request. It tries to be as user-friendly as possible and reports the
problems as comments directly in your "Files changed" section.

<div class="text-center img-row row">
  <a href="/files/img/vcs-diff-lint-github.png"
     title="vcs-diff-lint action commenting your code">
    <img src="/files/img/vcs-diff-lint-github.png">
  </a>
</div>

Please follow the [installation instructions][install-action] here.


## Ruff support

Ruff is all the rage nowadays, and rightfully so. It checks our whole codebase
in under a second (20ms actually) while mypy takes its sweet time and finishes
around a one-minute mark. Up until recently, the `vcs-diff-lint` tool supported
only [pylint][pylint] and [mypy][mypy] but since the last release, [ruff][ruff]
is supported as well. Please give it a try.

As a matter of fact, I am writing this article as a celebration of the
[new vcs-diff-lint release][release].


## But what about diff-cover

Speaking about differential static analysis, you may have already heard about
[diff-cover][diff-cover]. It has many more contributors and GitHub stars so why
would I recommend trying `vcs-diff-lint` instead?

- `diff-cover` doesn't provide a GitHub action
- `diff-cover` runs static analysis for the whole project but reports only
  problems for lines changed by the patch. This can't fundamentally catch
  problems caused by the changed code but lying outside of it. For example when
  you add a parameter to a function definition but forget to update all of its
  calls
- `vcs-diff-lint` supports `ruff` and `ruff` is cool now



[static-analysis-tools]: https://luminousmen.com/post/python-static-analysis-tools
[pylint]: https://github.com/pylint-dev/pylint
[mypy]: https://github.com/python/mypy
[ruff]: https://github.com/astral-sh/ruff
[csdiff]: https://github.com/csutils/csdiff
[vcs-diff-lint]: https://github.com/fedora-copr/vcs-diff-lint
[github-action]: https://github.com/fedora-copr/vcs-diff-lint-action
[install-tool]: https://github.com/fedora-copr/vcs-diff-lint
[install-action]: https://github.com/fedora-copr/vcs-diff-lint-action
[release]: https://github.com/fedora-copr/vcs-diff-lint/releases/tag/vcs-diff-lint-6.1-1
[diff-cover]: https://github.com/Bachmann1234/diff_cover
