---
layout: post
title: Qtile screenshot
lang: en
categories: desktop qtile
---

Do you like to share screenshots of your desktop? Do you use [Qtile](http://qtile.org)? Then keep reading!

Probably you have been using [scrot](#) for this matter so far. It is a great tool, but it allows you to take only screenshot of your current group (workspace). But what to do, when you want to show all of your groups? Then you use [qtile-screenshot](#).

[![Example screenshot from FrostyX's laptop](/files/img/qtile-screenshot-thumb.png)](/files/img/qtile-screenshot-full.png)


## Installation

This tool is not packaged for any Linux distribution yet, so you have basically two options how to get it. Choose the preferred one:

	pip install --user qtile-screenshot

or

	git clone https://github.com/FrostyX/qtile-screenshot.git


## Usage

Basic usage is just running `qtile-screenshot` command. It will go through all your groups, take screenshot of each one and then merge them together. Please see the following list of possible arguments to modify it's behaviour.

	optional arguments:
	  --desktops
	  --workspaces
	  --groups [GROUPS [GROUPS ...]],
	      workspaces that only should be on the screenshot

	  -e, --with-empty
	      make screenshot even from empty workspaces

	  --one-empty
	      show at most one empty groups if there is such

	  -o OUTPUT, --output OUTPUT
	      path to output directory or path to screenshot file


## Example

So how exactly I made the screenshot located above in this blog post?

	qtile-screenshot --groups i r d --output /tmp

And my screenshot was saved as `/tmp/qtile_2016-04-25_20:30:15`.

---

Share your desktop with us.
