---
layout: post
title: Prioritize BuildRequires from Copr
lang: en
categories: dev copr fedora
updated: 2019-04-10
---

In this short article, we are going to see how it is possible to prioritize external repositories when building a package in Copr.

Imagine the following [use-case](https://pagure.io/copr/copr/issue/97#comment-446610). You have a package `foo` which depends on package `bar`, i.e., `BuildRequires: bar`. The package `bar` is provided by Fedora repositories in version 1.2, and you have also built the package in version 1.1 in Copr. Now you want to build `foo` and explicitly say, that package `bar` should be installed from your Copr project, even though it is a lesser version than Fedora provides.


## Solution

We have extended the syntax for enabling external Copr repositories to support this feature. For a long time, it has been possible to write them this way.

    copr://<owner>/<project>

Now you can also specify the priority like this:

    copr://<owner>/<project>?priority=<num>
    copr://frostyx/copr-dev?priority=10

Please note that other parameters than `?priority` are currently ignored.

<div class="bs-callout bs-callout-default" id="non-copr-repo">
    <p>Updated: 10. 4. 2019</p>
    <p>
       Upon user requests, we have decided to support priority setting even for non-copr repositories.
       It is now possible to have:
       <pre>https://foo.bar/baz?priority=90</pre>
    </p>
</div>


## DNF

How does it work internally? What priority number should you set? The user-specified value is passed to a repo definition and then it is up to the DNF to properly resolve dependencies. Please see `man dnf.conf` for the details.

    priority
          integer

          The priority value of this repository, default is 99. If there is more than one candidate
          package for a  particular  operation,  the one  from  a  repo with the lowest priority value
          is picked, possibly despite being less convenient otherwise (e.g. by being a lower version).
