---
layout: post
title: Modularity in retrospect
lang: en
categories: copr fedora modularity
---

This article is about the journey that we made since [Fedora modularity project](https://docs.pagure.org/modularity/) started and we decided get involved and provide modularity features in [Copr](http://copr.fedoraproject.org/). It has been a long and difficult road and we are still not on its end, because the whole modularity project is a living organism that is still evolving and changing. Though, we are happy to be part of it.


## First demo
More than year ago, in let's say the dark ages, nothing existed. Just the void, ... well ok, enough metaphors. At that time, the whole modularity was just a design on the paper, any real implementation existed. Then we came with possibly one of the first prototypes. It was a simple feature that allowed for a user to assign a modulemd yaml file to a chroot in the project settings. When packages was built in such project/chroot and the repodata was created, we added the modulemd into them. This was a first piece of modularity code in Copr and the beggining of our journey.


## The "webform"
After a discussion we decided to which audience we want to target. We realized that the modularity team (later known as factory 2.0) will at first focus on experienced users, i.e. themselves. For us, it meant that the whole space targeted on complete begginers will not be covered soon, so we focused on this area.

Ask yourself a question. If your entire community are people with diverse, but at least fundamental knowledge of RPM packaging, what is the most challenging thing that they need to do, to be able to distribute their software as a module? They all need to learn how to write a modulemd yaml file. It isn't a rocket sience, but it is time consuming and also at that time the only guide was a docummented [template file](https://pagure.io/modulemd/blob/master/f/spec.yaml). This could be enough to discourage a lot of people. We saw a chance to attract people by simplifying things.

Idea of "the webform" was born. We implemented a form for creating modules without any knowledge requirement. User could just specify the module name, version and release (currently it is name, stream and version) and select from all the packages built in the particular project, which should be part of the module. Then Copr parsed it, constructed a yaml via [python-modulemd](http://modulemd.readthedocs.io) library and it continued the pipeline so the module was built (accordingly to what was considered "to be built" at that time). This was a killer feature for Copr. You can see a demo [here](https://www.youtube.com/watch?v=uNW8QEzsdDg).


## DNF 1.x
Copr was able to _build modules_ and generate repofiles for them. However nobody could be sure, whether it was done correctly and the output was as expected, because there was no official way, how to install the modules on the client machine. To be percise, some prototypes existed. Modularity features for DNF was implemented as the [fm-dnf-plugin](https://pagure.io/fm-dnf-plugin) and [fm-modulemd-resolver](https://pagure.io/fm-modulemd-resolver). There was a little problem though - it didn't worked with the most recent version of modulemd format. We decided to update the code in order to use the DNF plugin in our tests to ensure that we build the modules as we should. The funny thing is that meanwhile the DNF plugin was stated as obsoleted in favor of DNF 2.0 with internal support for modularity. Hence, my pull requests [PR#5](https://pagure.io/fm-dnf-plugin/pull-request/5) and [PR#1](https://pagure.io/fm-modulemd-resolver/pull-request/1) were destined to be forever unmerged.


## Module Build Service
aka MBS, aka fm-orchestrator, formerly known as Říďa (from czech comic book [Čtyřlístek](https://comicsdb.cz/comics/1312/ctyrlistek-092-rida-to-zaridi)), is a service for orchestrating a module build in configured build service, such as Koji, Copr or Mock.

As the complexity of building modules grew it was a particularly good idea not to re-invent a wheel and use/improve a tools that Factory 2.0 already created. The most important for us was MBS as it should have been possible to resolve module build dependencies, configure the buildroot and schedule the builds in right order. Moreover the logic was abstracted to general code that was common for all builders, so from our perspective it was a handy little blackbox managed and internaly reworked by people who defined the Modularity.

It was on us to implement the [Copr builder](https://pagure.io/copr/module-build-service-copr/blob/master/f/module_build_service_copr/builder/CoprModuleBuilder.py) and deploy our own instance of this service. As we quickly found out, we were the first ones who wanted to do so. There was no ansible playbook for deployment and moreover, it wasn't even packaged for Fedora. Packaging was eventuelly done by the upstream and we came with the [playbook](https://pagure.io/fm-orchestrator/issue/220). You can see the demo of our first builds via MBS [here](https://www.youtube.com/watch?v=28wJ5qT8glA).


## Buildroot from modules
As you can see from the previous demo, we used to build modules in Fedora rawhide chroot. This contradicted with one of the former modularity goals which was a fully modular system (and also fully modular buildroot). We solved it by building modules in `custom-1-x86_64` chroot with enabled external repository to base-runtime (and later platform) module. You can see the demo [here](https://www.youtube.com/watch?v=mlo27-CIXD8).

We took it even further. Although a MBS conctructs a buildroot from modules, it actually kind of cheats. It determines which modules should be installed into the buildroot and then finds out which packages are provided by those modules. Those are installed into the buildroot. This makes a sence maybe as a workaround, but I consider it wrong from the design perspective. This made us implement a support for [Mock](https://github.com/rpm-software-management/mock) to be able to [directly install modules into the buildroot](https://github.com/rpm-software-management/mock/wiki/Release-Notes-1.4.2).


## Modules with Copr packages
How to built modules from Copr packages? Wait for an upcomming article. It will be very short with a lot of images :-).


## MBS Plugins
@TODO module-build-service-copr


## Modules based on Copr modules
@TODO


## Hybrid Modularity
Just before Christmas break a highly awaited article [Modularity is Dead, Long Live Modularity!](https://communityblog.fedoraproject.org/modularity-dead-long-live-modularity/) was published. If you haven't read it yet, I recommend you to do so. It explains how the Modularity design is going to be changed. From the Copr perspective, the most important revelation is that the buildroot is not going to be composed from modules anymore. Instead, the standard Fedora buildroot will be used.


## Conclusion
What to take from this already too long article? Things change. Moreover, things regarding modularity change very fast and very often and it is sometimes dificult for us to find the right way how to do things and to cath up the hot news. In the following article we are going to talk about how you can currently build modules in Copr and how the current user interface looks like.
