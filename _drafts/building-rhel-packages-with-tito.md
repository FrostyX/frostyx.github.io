---
layout: post
title: Building RHEL packages with Tito
lang: en
tags: fedora tito rhel packaging howto workflow
---

Are you a Fedora packager and consider [Tito][tito] to be a valuable
asset in your toolbox? Do you know it can be used for maintaining RHEL
packages as well? I didn't. This article explains how it can be done.

<div class="alert alert-warning" role="alert">
Disclaimer: I maintain a dozen of Fedora packages for years but I am
fairly new to RHEL packaging. I do not claim to be an expert or an
authority on this topic. This article is subjective and describes my
personal workflow for updating RHEL packages.
</div>


## Fedora vs RHEL packaging

Apart from different hostnames, service names, and a great focus on
quality assurance, there is only one difference relevant to
the topic at hand. That is, package sources tarball is never being
changed within an RHEL major release. While this may sound
insignificant, it is the only reason for this whole article, so let me
elaborate.

We have an imaginary upstream project `foo` in version `1.0`. This
project gets packaged into Fedora as `foo-1.0-1` (i.e. package name is
`foo`, its upstream version is `1.0` and this is the first release of
this version in Fedora). When this package gets included in RHEL, its
NVR is going to be the same, `foo-1.0-1`. So far there is no
difference.

Updating this package is when it gets tricky. Upstream publishes
version `1.1`. In Fedora, we take the new upstream sources as they
are, and build a package `foo-1.1-1` on top of them. In RHEL, we never
change the sources. Instead, we create a patch (or series of patches)
that modifies the original sources into the newly published
ones. Therefore the new package in RHEL will be `foo-1.0-2` (the
version number remains the same, release is incremented).

We can choose to do all this patching labor manually or let
[Tito][tito] help us.


## Initial setup

This initial setup needs to be done only once for each package. It's a
bit lengthy but the payoff is worth it.


### Create an intermediate git repository

First, create an empty git repository on some internal forge
(e.g. GitLab) and clone it to your computer.

```bash
git clone git@some-internal-url.com:jkadlcik/foo.git ~/git/rhel/foo
cd ~/git/rhel/foo
```

In case that you use a different email address for internal purposes,
configure your git credentials.

```bash
git config user.name "John Doe"
git config user.email "jdoe@company.ex"
```

Add an upstream repository as a new _remote_ for this git
project. We will use this _remote_ only for pulling, so make sure to
use its HTTPS variant instead of the SSH one. It will help us prevent
accidental pushing of sensitive information out to the world.

```bash
git remote add upstream https://github.com/foo/bar.git
```

Pull everything from upstream.

```bash
git fetch --all
```

Go and see what is the version (ignore the release number) of our
package in RHEL, and point the `main` branch to the Tito tag
associated with this version. Point the `main` branch to the latest
tag. For example, if the package name is `foo` and its version is
`1.5-3`, run the following command.

```bash
git reset --hard foo-1.5-1
```

And finally, push everything to the internal repository.

```bash
git push --follow-tags
```

### Configure Tito

Edit the `.tito/tito.props` file and update the `builder` and `tagger`
variables accordingly.

```python
builder = tito.distributionbuilder.DistributionBuilder
tagger = tito.tagger.ReleaseTagger
```

The `DistributionBuilder` handles the patches generation (from the
current RHEL version into the latest upstream version) when building a
package. The `ReleaseTagger` increments release number instead of
a version number when tagging a new package.

Edit the `.tito/releasers.conf` and append the following releaser.

```ini
[rhel]
releaser = tito.release.DistGitReleaser
branches = rhel-8.5.0
```

In this example I am specifying `rhel-8.5.0` branch, please insert
the branch that you maintain your package in. In the case of multiple
branches, use spaces as separators.

## Cherry-pick the changes

## Prepare the spec file

Now, we are going to manufacture a spec file that contains changes
from both upstream and internal spec files. For the purposes of this
paragraph, let's assume that the latest upstream version is `1.7-1`
and the latest RHEL version is `1.5-3`.

1. We will use the spec file that came from the upstream repository as
   a base
2. Remove all the changelog entries since `1.5-1`.
3. Find the spec file for your package in the internal DistGit service
4. Append (from the top) all the changelog entries recorded between
   `1.5-1` and `1.5-3`.
5. Set the current RHEL version and release. In this example
   `Version: 1.5` and `Release: 3%{?dist}`
6. Perform any additional changes that were made in the RHEL spec file
7. In case the RHEL spec file contains some RHEL-specific patches, do
   **not** copy the patch files and add `PatchN:` records in the spec
   file. Instead, perform those changes directly in this repository
   and commit them.
8. Commit all the changes that we made to the spec file and in the
   `.tito` configuration directory


## Build and test the package locally

To make sure we made all changes correctly, we are going to build the
package locally and test it works as expected before irreversibly
pushing anything to DistGit and eventually embarrassing ourselves with
amends.

```bash
tito build --srpm --test
```

Build the package locally in Mock, or in the internal Copr instance
which provides an actual RHEL chroots.

```
mock -r rocky-8-x86_64 /tmp/tito/foo-1.5-3.git.0.da1346d.fc33.src.rpm
```

Examine the built package, try to install it (in Docker, Mock, etc)
and test that it works as expected.


## Push the changes

If you are sure, tag the package, and push the changes.

```bash
tito tag
git push --follow-tags origin
```

By this point, we should be able to build a non-test SRPM package. We
won't need it but it is a good idea to make sure it works.

```bash
tito build --srpm
```

Push everything into the internal DistGit and submit builds for all
predefined branches.

```bash
tito release rhel
```

When asked if you want to edit the commit message, proceed with
yes. You must reference a ticket demanding this update, e.g.

```
Resolves rhbz#123456
```

Just make sure all the submitted builds succeeded and continue with
the rest of the update process.


## Consequent updates

I haven't done this part yet, thus it will be explained right after I
get through it. The general idea is to run

```bash
git pull --rebase upstream master
```

and resolve all merge conflicts while updating the spec file like we
did in the [Prepare the spec file](#prepare-the-spec-file) section,
[building the package locally](#build-and-test-the-package-locally)
and then [pushing the changes](#push-the-changes).


## Troubleshooting

### Diff contains binary files

If any of the patches that `DistributionBuilder` generates should
contain binary files, you will end up with a fatal error (with a
rather nice wording).

```
ERROR: You are doomed. Diff contains binary files. You can not use this builder
```

In this case, I would suggest trying `UpstreamBuilder` instead.

```python
builder = tito.builder.UpstreamBuilder
```

The difference between those two is that `DistributionBuidler`
generates one patch per upstream version and therefore if any of the
intermediate patches contains binary files, the build fails. Whereas
`UpstreamBuilder` always generates only one patch file at all times,
therefore any intermediate changes don't matter, the patch will
simply contain changes for the resulting upstream state (i.e. if the
latest upstream release is alright, the build will succeed).



[tito]: https://github.com/rpm-software-management/tito
