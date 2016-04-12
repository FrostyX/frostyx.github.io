---
layout: post
title: Copr CLI - Building from Tito, Mock and PyPI
lang: en
published: false
categories: copr fedora changelog howto
---

It has been a while since Copr supports building directly from Git repository which is managed by Tito, or more freely building via Mock SCM. Since last release it is also possible to generate a `.spec` file and submit a build from PyPI package. You can read more about it [here](http://miroslav.suchy.cz/blog/archives/2016/03/29/new_features_in_copr/). What was missing about this features was command line support. Which is finally done now!


## Tito
	copr-cli buildtito <username>/<project> --git-url=<url>

Options:

	--git-url URL
	    Url to a project managed by Tito, required.

	--git-dir DIRECTORY
	    Relative path from Git root to directory containing .spec file.

	--git-branch BRANCH
	    Checokut specific branch on the repository.

	--test
	    To build from the last commit instead of the last release tag.

## Mock
	copr-cli buildmock <username>/<project> --scm-url=<url> --spec=<path/to/foo.spec>

Options:

	--scm-type TYPE
	    Specify versioning tool, default is git.

	--scm-url URL
	    Url to a project versioned by Git or SVN, required.

	--scm-branch BRANCH
	    Checokut specific branch on the repository.

	--spec FILE
	    Relative path from SCM root to .spec file, required.


## PyPI
	copr-cli buildpypi frostyx/foo --packagename=<pypi-pkgname>

Options:

	--pythonversions [VERSION [VERSION ...]]
	    For what Python versions to build (by default: 3 2)

	--packageversion PYPIVERSION
	    Version of the PyPI package to be built (by default latest)

	--packagename PYPINAME
	    Name of the PyPI package to be built, required.



Of course there are lot of other possible options for this commands. Please see manual page by running `man copr-cli` to see more info.


Happy building everyone ;-)
