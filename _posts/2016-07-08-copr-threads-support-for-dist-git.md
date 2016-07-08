---
layout: post
title: Copr - Threads support for dist-git
lang: en
categories: copr fedora
---

In recent experiments we tried to rebuild all packages from [PyPI](https://pypi.python.org) and [RubyGems](http://rubygems.org/) which show us some weak spots of [Copr](http://copr.fedoraproject.org/). There already were [few](https://lists.fedorahosted.org/archives/list/copr-devel@lists.fedorahosted.org/thread/OCODBMV56D6I32GGOVUGYG2AJG3IQGNF/) improvements done, however today we will talk about parallelizing Copr-dist-git.


TL;DR: Copr-dist-git now imports sources in multiple threads


## Why?

The current Copr-dist-git allowed importing your sources in only one thread. It was fine for daily use, because building of most packages takes considerably more time than importing their sources. But building over 100 000 small packages at once? This is a completely new story. In such case, importing was the bottleneck. See how the simplified Copr stack looks like to fully understand the problem.


## Copr stack

As you see in the image below, you tell Copr via it's web frontend or CLI to build some package. Then frontend sends a request to Copr-dist-git to import and save your sources. After it is done, frontend will ask backend to build them. However backend will not build it by itself and passes the task to one of many builders, which are realized as OpenStack virtual machines.


<div class="text-center img">
	<img src="/files/img/copr-stack-parallel-dist-git.png" alt="Simplified Copr stack" />
</div>


Notice that most parts of the process are just simple requests between Copr services and the building is done by many VMs. Now you can imagine the problem when downloading e.g. gem from [RubyGems](http://rubygems.org) to Copr-dist-git and constructing the `.src.rpm` takes about 5-10s for every gem, one by one for thousands of gems, while their building takes about the same time, but can be done on lot of machines concurrently.


## Solution

As a consequence of this matter we decided to reimplement Copr-dist-git to import sources in multiple threads. The architecture is scalable and theoretically allows us using as many threads as we want, but right now we only required faster importing of many packages than their building so we decided to have three importing threads of Copr-dist-git. Eventually we can add some more, but for now we wanted to avoid unnecessary deadlocks and stuff.


See the comparison of importing 1000 packages on current and new Copr-dist-git.


<div class="container">
	<div class="row col-md-5">
		<table class="table table-bordered">
			<tr><th>Version</th><th>Time</th></tr>
			<tr><td>copr-dist-git-0.19</td><td>1 hour 15 minutes</td></tr>
			<tr><td>dev</td><td>45 minutes</td></tr>
		</table>
	</div>
</div>
