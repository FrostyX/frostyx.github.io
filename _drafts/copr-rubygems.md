---
layout: post
title: Copr - Rubygems
lang: en
categories: copr fedora changelog howto
---

Recently [clime](https://github.com/clime) implemented support for building a RPM package directly from PyPI and Mirek performed very cool [experiment](http://miroslav.suchy.cz/blog/archives/2016/04/21/wip_rebuilding_all_pypi_modules_as_rpm_packages/index.html) of building the whole 79k packages on our dev servers. Today we have similar feature, but for the Ruby people. I hope that you are excited.


So what exactly have been done? There is a service called [RubyGems.org](https://rubygems.org) which hosts community gems. Also there is a tool called [gem2rpm](https://github.com/fedora-ruby/gem2rpm) for converting Gemfile to .spec or alternatively the whole gem to .src.rpm package. Based on this we have created feature which allows you to submit a Copr build directly from your Gem.


## Web interface

As you may expect, the build form is located at Builds > New Build > RubyGems. The only thing that you have to specify is just a gem name. Please see the following screenshot.

![Just provide gem name](/files/img/copr-rubygems.png)


## CLI support

@TODO Specify versions

Since `copr-cli-xy` and `python-copr-xy` you can submit a build via command line.

	copr-cli buildgem <username>/<project> --gem=<name>

For all the possible options please see `copr-cli buildgem --help` or manual page `man copr`.


## How it works

When you submit a build, the Copr dist-git service downloads specified gem, builds the .src.rpm file and then the build process continues exactly same as for other methods. So the interesting part is how gem is converted to source package.

Copr runs exactly this command.

	gem2rpm --fetch --srpm -C <OUTPUT_DIR> <GEM>

So in case that you want to debug your gem locally, you can use this tool and get the exact result as Copr would. If you want to enhance converting capabilities, you should do it on [gem2rpm](https://github.com/fedora-ruby/gem2rpm) side.
