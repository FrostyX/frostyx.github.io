---
layout: post
title: Rebuilding the entire RubyGems in Copr
lang: en
tags: copr fedora rubygems
updated: 2021-11-15
---

We took all 166&nbsp;699 packages from [RubyGems.org][rubygems] and
rebuilt them in [Copr][copr]. Let's explore the results together.


## Success rate

From the 166&nbsp;699 Gems hosted on [RubyGems.org][rubygems],
98&nbsp;816 of them were successfully built in [Copr][copr] for Fedora
Rawhide. That makes a 59.3% success rate. For the rest of them, it
is important to distinguish in what build phase they failed. Out of
67&nbsp;883 failures, 62&nbsp;717 of them happened while converting
their [Gemfile][gemfile] into [spec][spec] and only 5&nbsp;166 when
building the actual RPM packages. It means that if a Gem can be
properly converted to a [spec][spec] file, there is a 95% probability
for it to be successfully built into RPM.

<div class="text-center img-row row">
  <a href="/files/img/rubygems-success-rate.png"
     title="The exact number of failures caused by missing license vs other SRPM failures will be updated">
    <img src="/files/img/rubygems-success-rate.png">
  </a>
</div>

By far, the majority of failures were caused by a missing license
field for the particular Gems. There is likely nothing wrong with
them, and technically, they could be built without any issues, but we
simply don't have legal rights to do so. Therefore such builds were
aborted before even downloading the sources. This affected 62&nbsp;049
packages.


## More stats

All Gems were rebuilt within the [@rubygems/rubygems][copr-rubygems]
Copr project for `fedora-rawhide-x86_64` and `fedora-rawhide-i386`.

We submitted all builds _at once_, starting on Sep 11, 2021, and the
whole rebuild was finished on Oct 17, 2021. It took Copr a little over
a month, and within that time, the number of pending builds peaked at
129&nbsp;515.

<div class="text-center img-row row">
  <a href="/files/img/rubygems-builds-graph.png"
     title="The pending builds peaked at 129515">
    <img src="/files/img/rubygems-builds-graph.png">
  </a>
</div>

The number of running builds doesn't represent 24&nbsp;468 running
builds at once but rather the number of builds that entered the
`running` state on that day. It doesn't represent Copr throughput
accurately though, as we worked on eliminating performance issues
along the way. A similar mass rebuild should take a fraction of the
time now.

The resulting RPM packages ate 55GB per chroot, therefore 110GB in
total. SRPM packages in the amount of 640MB were created as a
byproduct.

The repository metadata has 130MB and it takes DNF around 5 minutes on
my laptop (Lenovo X1 Carbon) to enable the repository and install a package
from it for the first time (because it needs to create a cache).
Consequent installations from the repository are instant.


## In perspective

To realize if those numbers are anyhow significant or interesting, I
think we need to compare them with other repositories.

{:.table .table-bordered .table-hover}
| \#                           | @rubygems/rubygems | Fedora Rawhide (F36) | EPEL8         |
| ---------------------------- | ------------------ | -------------------- | ------------- |
| **The Number of packages**   | 98&nbsp;816        | 34&nbsp;062          | 4&nbsp;806    |
| **Size per chroot**          | 55GB               | 83GB                 | 6.7GB         |
| **Metadata size**            | 130MB              | 61MB                 | 11MB          |
| `dnf makecache`              | ~5 minutes         | ~22 seconds          | 1 second      |


## Motivation

What was the point of this _experiment_ anyway?

The goal was to rebuild all packages from a third-party hosting
service that is specific to some programming language. There was no
particular reason why we chose [RubyGems.org][rubygems] among other
options.

We hoped to pioneer this area, figure out the pain points, and make it
easier for others to mass-rebuild something that might be helpful to them.
While doing so, we had the opportunity to improve the Copr service and
test the performance of the whole RPM toolchain against large repositories.

There are reasons why to avoid installing packages directly via `gem`,
`pip`, etc, but that's for a whole other discussion. Let me just
reference a [brief answer from Stack Overflow][stack-overflow-pip].


## Internals

Surprisingly enough, the mass rebuild itself wasn't that
challenging. The real work manifested itself as its consequences
(unfair queue, slow `createrepo_c`, timeouts everywhere). Rebuilding
the whole [RubyGems.org][rubygems] was as easy as:

1. Figuring out a way to convert a [Gemfile][gemfile] into
   [spec][spec]. Thank you, [gem2rpm][gem2rpm]!

2. Figuring out how to submit a single Gem into Copr. In this case, we
   have built-in support for [gem2rpm][gem2rpm] (see
   [the documentation][docs-rubygems]), therefore it was as easy as
   `copr-cli buildgem ...`. Similarly, we have built-in support for
   PyPI. For anything else, you would have to utilize the
   [Custom source method][custom-method] (at least until the support
   for such tool/service is built into Copr directly).

3. Iterating over the whole [RubyGems.org][rubygems] repository and
   submitting gems one by one. A simple script is more than
   sufficient, but we utilized [copr-rebuild-tools][copr-rebuild-tools]
   that I wrote many years ago.

4. Setting up automatic rebuilds of new Gems. The
   [release-monitoring.org][release-monitoring] (aka Anitya) is
   perfect for that. We [check][anitya-script] for new
   [RubyGems.org][rubygems] updates every hour, and it would be
   trivial to add support for any other [backend][anitya-backends].
   Thanks to Anitya, the repository will always provide the most
   up-to-date packages.


## Takeaway for RubyGems

If you maintain any Gems, please make sure that you have properly set
their license. If you develop or maintain any piece of software, for
that matter, please make sure it is publicly known under which license
it is available.

Contrary to the common belief, unlicensed software, even though
publicly available on [GitHub][github] or [RubyGems][rubygems], is in
fact protected by copyright, and therefore cannot be legally used
(because a license is needed to grant usage rights). As such,
unlicensed software is neither [Free software][free-software] nor
[open source][open-source], even though technically it can be
downloaded and installed by anyone.

If I could have a wishful message towards [RubyGems.org][rubygems]
maintainers, please consider placing a higher significance on
licensing and make it [required instead of
recommended][rubygems-metadata].

For the reference, here is a list of all 65&nbsp;206 unlicensed Gems
generated by the following script (on Nov 14 2021).
https://gist.github.com/FrostyX/e324c667c97ff80d7f145f5c2c936f27#file-rubygems-unlicensed-list

```bash
#!/bin/bash
for gem in $(gem search --remote |cut -d " " -f1) ; do
   url="https://rubygems.org/api/v1/gems/$gem.json"
   metadata=$(curl -s $url)
   if ! echo $metadata |jq -e '.licenses |select(type == "array" and length > 0)'\
      >/dev/null; then
       echo $metadata |jq -r '.name'
   fi
done
```

There are also 3&nbsp;157 packages that don't have their license field set
on [RubyGems.org][rubygems] but we were able to parse their license
from the sources.
https://gist.github.com/FrostyX/e324c667c97ff80d7f145f5c2c936f27#file-rubygems-license-only-in-sources-list


## Takeaway for DNF

It turns out DNF handles large repositories without any major
difficulties. The only inconvenience is how long it takes to create
its cache. To reproduce, enable the repository.

```
dnf copr enable @rubygems/rubygems
```

And create the cache from scratch. It will take a while (5 minutes for
the single repo on my machine).

```
dnf makecache
```

I am not that familiar with DNF internals, so I don't really know if
this is something that can be fixed. But it would certainly be
worth exploring if any performance improvements can be done.


## Takeaway for createrepo_c

We cooperated with `createrepo_c` developers on multiple performance
improvements in the past, and these days `createrepo_c` works
perfectly for large repositories. There is nothing crucial left to do,
so I would like to briefly describe how to utilize `createrepo_c`
optimization features instead.

First `createrepo_c` run for a large repo will always be slow, so just
get over it. Use the `--workers` parameter to specify how many threads
should be spawned for reading RPMs. While this brings a significant
speedup (and cuts the time to half), the problem is, that even listing
a large directory is too expensive. It will take tens of minutes.

Specify the `--pkglist` parameter to let `createrepo_c` generate a new
file containing the list of all packages in the repository. It will
help us to speed up the consecutive `createrepo_c` runs. For them,
specify also `--update`, `--recycle-pkglist`, and `--skip-stat`. The
repository regeneration will take only a couple of seconds
([437451f][437451f]).

## Takeaway for appstream-builder

On the other hand, `appstream-builder` takes more than 20 minutes to
finish, and we didn't find any way to make it run faster. As a
(hopefully) temporary solution, we added a possibility to disable
[AppStream][appstream] metadata generation for a given project
([PR#742][pr742]), and recommend owners of large projects to do so.

From the long-term perspective, it may be worth checking out whether
there are some possibilities to improve the `appstream-builder`
performance. If you are interested, see upstream issue
[#301][appstream-301].


## Takeaway for Copr

The month of September turned into one big stress test, causing Copr
to be temporarily incapacitated but helping us provide a better
service in the long-term. Because we never had such a big project in
the past, we experienced and fixed several issues in the UX and data
handling on the frontend and backend. Here are some of them:

- Due to periodically logging all pending builds, the apache log
  skyrocketed to 20GB and consumed all available disk space
  ([PR#1916][pr1916]).
- Timeouts when updating project settings ([PR#1968][pr1968])
- Unfair repository locking caused some builds unjustifiably long to
  be finished ([PR#1927][pr1927]).
- We used to delegate pagination to the client to provide a
  better user experience (and honestly, to avoid implementing it
  ourselves). This made listing builds and packages in a large project
  either take a long time or timeout. We switched to backend
  pagination for projects with more than 10&nbsp;000 builds/packages
  ([PR#1908][pr1908]).
- People used to scrap the monitor page of their projects but that
  isn't an option anymore due to the more conservative pagination
  implementation. Therefore we added proper support for project
  monitor into the API and `copr-cli` ([PR#1953][pr1953]).
- The API call for obtaining all project builds was too slow for large
  projects. In the case of the `@rubygems/rubygems` project, we
  managed to reduce the required time from around 42 minutes to 13
  minutes ([PR#1930][pr1930]).
- The `copr-cli` command for listing all project packages was too slow
  and didn't continuously print the output. In the case of the
  `@rubygems/rubygems` project, we reduced its time from around 40
  minutes to 35 seconds ([PR#1914][pr1914]).


## Let's build more

To achieve such mass rebuild, no special permissions, proprietary
tools, or any requirements were necessary. Any user could have done
it. In fact, some of them already did.

- [iucar/cran][copr-cran]
- [@python/python3.10][copr-python]
- [PyPI][pypi] rebuild is being worked on by
  [Karolina Surma][befeleme]

But don't be fooled, Copr can handle more. Will somebody try
[Npm][npm], [Packagist][packagist], [Hackage][hackage], [CPAN][cpan],
[ELPA][elpa], etc? Let us know.

I would suggest starting with [Copr Mass Rebuilds
documentation][doc-mass-rebuilds].



[rubygems]: https://rubygems.org/
[gemfile]: https://bundler.io/gemfile.html
[spec]: https://rpm-packaging-guide.github.io/#what-is-a-spec-file
[copr-rubygems]: https://copr.fedorainfracloud.org/coprs/g/rubygems/rubygems/
[free-software]: https://www.gnu.org/philosophy/free-sw.en.html
[open-source]: https://opensource.com/resources/what-open-source
[rubygems-metadata]: https://guides.rubygems.org/specification-reference/
[copr-python]: https://copr.fedorainfracloud.org/coprs/g/python/python3.10/
[copr-cran]: https://copr.fedorainfracloud.org/coprs/iucar/cran/
[npm]: https://www.npmjs.com/
[hackage]: https://hackage.haskell.org/
[cpan]: https://www.cpan.org/
[elpa]: https://elpa.gnu.org/
[packagist]: https://packagist.org/
[doc-mass-rebuilds]: https://docs.pagure.org/copr.copr/user_documentation.html#mass-rebuilds
[gem2rpm]: https://github.com/fedora-ruby/gem2rpm
[docs-rubygems]: https://docs.pagure.org/copr.copr/user_documentation.html#rubygems
[custom-method]: https://docs.pagure.org/copr.copr/custom_source_method.html#custom-source-method
[copr-rebuild-tools]: https://github.com/fedora-copr/copr-rebuild-tools
[release-monitoring]: https://release-monitoring.org/
[anitya-script]: https://pagure.io/copr/copr/blob/main/f/frontend/coprs_frontend/run/check_for_anitya_version_updates.py
[anitya-backends]: https://release-monitoring.org/static/docs/user-guide.html#backends
[pr1916]: https://pagure.io/copr/copr/pull-request/1916
[pr1968]: https://pagure.io/copr/copr/pull-request/1968
[pr1927]: https://pagure.io/copr/copr/pull-request/1927
[pr1908]: https://pagure.io/copr/copr/pull-request/1908
[pr1953]: https://pagure.io/copr/copr/pull-request/1953
[pr1930]: https://pagure.io/copr/copr/pull-request/1930
[pr1914]: https://pagure.io/copr/copr/pull-request/1914
[437451f]: https://github.com/rpm-software-management/createrepo_c/commit/437451f3bea5430c0a6f678b2a65ebbbbcb12de0
[pr742]: https://pagure.io/copr/copr/pull-request/742
[appstream]: https://www.freedesktop.org/software/appstream/docs/
[appstream-301]: https://github.com/hughsie/appstream-glib/issues/301
[third-party-policy]: https://docs.fedoraproject.org/en-US/fesco/Third_Party_Repository_Policy/
[stack-overflow-pip]: https://stackoverflow.com/a/33584893/3285282
[github]: https://github.com/
[pypi]: https://pypi.org/
[befeleme]: https://github.com/befeleme
[copr]: https://copr.fedorainfracloud.org/
