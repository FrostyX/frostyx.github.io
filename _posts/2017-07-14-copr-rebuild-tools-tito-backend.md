---
layout: post
title: Copr Rebuild Tools - Tito backend
lang: en
tags: copr fedora howto packaging
---

Did you read my [last post](http://frostyx.cz/posts/copr-rebuild-tools) about [Copr Rebuild Tools](https://github.com/fedora-copr/copr-rebuild-tools)? It is a handy tool for mass rebuilding packages in Copr. Sources of such packages could
come from [PyPI](https://pypi.python.org/pypi) or [RubyGems](https://rubygems.org/) - that was only two implemented [backends](https://github.com/fedora-copr/copr-rebuild-tools#backends) yet. Now we also have a support for Tito projects with multiple packages. Lets look at it.


## About Tito

<blockquote class="text-muted">
    <p>Tito is a tool for managing RPM based projects using git for their source code repository.</p>
    <footer><a href="https://github.com/dgoodwin/tito">Tito home page</a></footer>
</blockquote>


## Basic setup of tito backend

As usual, we have to create the config file first. Let's say `project.ini`.

    [general]
    project =                   ; Leave it empty, tito releaser will do this for us
                                ; If you want use --new-packages, you need to set it
    [tito]
    path = ~/git/project        ; Path to our project's root directory
    releaser = copr-dev         ; Releaser name from releasers.conf of the project

Obviously, you need to have this tito releaser properly configured for the project. Please read `man releasers.conf` to see how to do it.
Also, you may notice, that there is no `copr-config` attribute that we are used to. That is because it is no way how to specify copr config which should tito use. Therefore default `~/.config/copr` is used. Please update it accordingly.


Once this is done, we can release all the packages to Copr

    copr-rebuild --config project.ini tito submit


## Real-world usage

We were asked to rebuild packages from the [Foreman](https://www.theforeman.org/) project to Copr. When you closely look into the [packaging repo](https://github.com/theforeman/foreman-packaging/tree/rpm/develop), there is just a **lot** of packages. We could go through them one by one, but this would be a waste of time. Since expected ratio of succeeded builds was relatively high, I chose to submit them all and then take a special care of failed packages. So I've created a two tito releasers.

    # Releases for Fedora
    [copr]
    releaser = tito.release.CoprReleaser
    project_name = @theforeman/foreman-nightly

    # SCL collection with EPEL builds
    [copr-tfm]
    releaser = tito.release.CoprReleaser
    project_name = @theforeman/tfm-foreman-nightly
    builder.scl = tfm

With such, we can go to an arbitrary package directory in the repo and run `tito release copr` or `tito release copr-tfm` to build the package in the specified Copr project.

Now, when you examine `tito.props` of the foreman-packaging repository, you may notice that there are several groups of packages. Some of them should be built into [@theforeman/foreman-nightly](https://copr.fedorainfracloud.org/coprs/g/theforeman/foreman-nightly/) and some of them into [@theforeman/tfm-foreman-nightly](https://copr.fedorainfracloud.org/coprs/g/theforeman/tfm-foreman-nightly/). Not all of them into both projects. Copr-rebuild-tools unfortunately can't parse `tito.props` (yet), so we need to create another files defining a sets of packages.

Save this as `foreman-nightly-packages`

    foreman-bootloaders-redhat
    nodejs-babel-core
    nodejs-babel-loader
    nodejs-babel-plugin-transform-object-assign
    # ...

And this as `tfm-foreman-nightly-packages`

    rubygem-activerecord-session_store
    rubygem-addressable
    rubygem-ancestry
    rubygem-apipie-bindings
    # ...

Then we can finally create a config file for `copr-rebuild`. Let's say `foreman.ini`.

    [general]
    path = ~/git/foreman-packaging
    backend = tito
    owner = @theforeman

    [copr]
    releaser = copr
    set = ./foreman-nightly-packages
    project = foreman-nightly

    [copr-tfm]
    releaser = copr-tfm
    set = ./tfm-foreman-nightly-packages
    project = tfm-foreman-nightly
    scl = tfm

And we are done! Packages can be easily (re)built into their Copr projects by using

    copr-rebuild --config foreman.ini copr submit
    copr-rebuild --config foreman.ini copr-tfm submit

Once the builds are finished, we might want to focus only on failed packages in order to fix them and resubmit them again. There is no need to submit them one-by-one, we still can use copr rebuild tools. We also don't need to filter them or something. Just use `copr-rebuild` command with `--new-packages` parameter. This will build only packages that weren't successfully built in the project yet.
