---
layout: post
title: Guide for rpkg from Tito user
lang: en
categories: dev copr fedora
---

Since the beginning of the [rpkg](https://pagure.io/rpkg-util) project, it was known as a client tool for [DistGit](https://clime.github.io/2017/05/20/DistGit-1.0.html). Times changed and a new era for rpkg is here. It was enhanced with project management features, so we can safely label it as a [tito](https://github.com/dgoodwin/tito) alternative.

A features review, pros and cons and user guide is a theme for a whole new article. In this short post I, as a long-time tito user, want to show rpkg alternatives for the tito commands, that I frequently use.

For more information about the rpkg features, please read [the documentation](https://docs.pagure.org/rpkg-util).


## Cheat sheet

{:.table}
| Tito command                                     | rpkg alternative                  |
| ------------------------------------------------ | --------------------------------- |
| `tito build --srpm --test`                       | `rpkg srpm`                       |
| `tito build --rpm --test`                        | `rpkg local`                      |
| `tito build --tgz --test`                        | `rpkg spec --sources`             |
| `tito build ... --rpmbuild-options=--nocheck`    |                                   |
| `tito tag`                                       | `rpkg tag`                        |
| Undo a tito tag                                  | `rpkg tag -d <tagname>`           |
| Push a tito tag                                  | `rpkg push`                       |
| `tito release <copr-releaser>`                   | `rpkg build`                      |


## Working with last tag

You may notice, that all tito build commands in the cheat sheet table have `--test` parameter. That's because rpkg always works with the last commit. So how to build a package from the last tag? We need to _checkout_ it first.

    git checkout <tag>
	rpkg local
