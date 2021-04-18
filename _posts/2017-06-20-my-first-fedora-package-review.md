---
layout: post
title: My first fedora package review
lang: en
tags: fedora howto packaging fedora-review
---

Recently I've done my first fedora [package review](https://fedoraproject.org/wiki/Package_Review_Process) and this very short post is about usage of `fedora-review` tool.


## Usage

Standard usage is very straightforward. You just need to know the bug ID for review request

	fedora-review -b 123456

It will complain that you should build the package in rawhide, so basically this is a way to go

	fedora-review -b 123456 --mock-config fedora-rawhide-x86_64


## My usage

Since this was my first review and I certainly lack lot of experience in the field of packaging, I didn't want to just blindly give tips what should be changed and how. I wanted to test it first.

I took spec file and sources from what the `fedora-review` generated and put it into `~/rpmbuild/SPECS` and `~/rpmbuild/SOURCES`. I suppose, that it would also be possible to obtain spec directly from bugzilla, open it and see how sources should be obtained.

Then I could edit it as I wanted, build it and see whether my suggestions are helpful or not

	rpmbuild -bs ~/rpmbuild/SPECS/foo.spec
	fedora-review -rn ~/rpmbuild/SRPMS/foo-0.2-1.fc25.src.rpm --mock-config fedora-rawhide-x86_64


## References

1. <https://fedoraproject.org/wiki/Package_Review_Process>
2. <https://fedoraproject.org/wiki/Packaging:ReviewGuidelines>
3. <https://fedoraproject.org/wiki/Packaging:Guidelines>
