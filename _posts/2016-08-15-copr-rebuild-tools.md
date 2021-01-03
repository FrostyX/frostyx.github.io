---
layout: post
title: Copr Rebuild Tools
lang: en
tags: dev copr fedora howto
---

So we re-built whole [PyPI](https://pypi.python.org) and [RubyGems](http://rubygems.org/) as RPM packages. But how exactly we did it?

At first, we just didn't care about how to submit as many builds. Priority was to smooth rough edges in Copr to be even handle such load, therefore we only created few hacky scripts for obtaining all modules (gems) and submitting them one by one to Copr.

Although it was good enough then, in my opinion it needed to be upgraded so I decided to start project called [copr-rebuild-tools](https://github.com/FrostyX/copr-rebuild-tools). It allows you to do all kind of stuff that you may need for mass rebuilding packages.


## Features

Some of the features (see full [list](https://github.com/FrostyX/copr-rebuild-tools#features) on project page):

- Submitting all packages from given [backend](https://github.com/FrostyX/copr-rebuild-tools#backends)
- Possibility to specify the last submitted package and continue from following one
- Possibility to submit only new packages (or only new versions of packages)
- Possibility to rebuild only given set of packages
- Statistics of success rate

Killer feature is that this tool considers services such as PyPI or Rubygems as "backends" and is aimed to be extensible by writing another backends with ease. Use a [guide](https://github.com/FrostyX/copr-rebuild-tools/blob/master/backends/README.md) how to implement them. It is ridiculously easy.



## Usage

First, obtain `copr-rebuild-tools` from git. It may be properly released and packaged in the future, but until then you have no other option except git.

	git clone ...
	cd copr-rebuild-tools

Next, you are supposed to create config for your project. It may look like this.

	[general]
	copr-config = ~/.config/copr  ; You can easily use another instance of Copr service
	sleep = 20                    ; Seconds between submitting build after another

	[pypi]                        ; Backend alias - this is the name that you will specify in CLI
	owner = @copr
	project = PyPI
	python-version = 2 3          ; Whatever properties that backend implementation is able to work with

See some [existing confings](https://github.com/FrostyX/copr-rebuild-tools/tree/master/config) for better example. Once you have the config, you are ready to go. This is how `copr-rebuild` usage looks like.

	copr-rebuild -c <config> <backend> <action>

Parameters kind of explain themselves. You need to specify `<config>` which is path to your config file and `<backend>` which is backend alias in this file. Then you specify `<action>` and its additional parameters. Use `--help` for possible actions.

So hello world example can be

	copr-rebuild -c config.ini pypi submit


## Examples

Rebuild only newer gems that you already have in copr

	copr-rebuild -c ~/config.ini rubygems submit --new-versions

Build only first 100 gems positioned after `foo`

	copr-rebuild -c ~/config.ini rubygems submit --previous foo --limit 100

See success ratio of your project

	copr-rebuild -c ~/config.ini pypi stats

Get list of successfully built packages

	copr-rebuild -c ~/config.ini pypi successful

Build only set of openstack modules

	[openstack]
	; ...
	backend = pypi
	set = ./openstack-modules ; Path to file containing one module name per line

	copr-rebuild -c ~/config.ini openstack submit
