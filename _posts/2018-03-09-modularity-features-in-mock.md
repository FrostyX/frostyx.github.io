---
layout: post
title: Modularity features in Mock
lang: en
tags: dev mock fedora modularity
---


In this article, we are going to talk about Mock and how to build packages on top of modules in it. While some cool use-cases come to mind, for the time being, let's call it an experiment.


## Buildroot

Mock uses configs for defining the build environment. We are going to take one of the preinstalled configurations and modify it. But which one to take? In the past, one of the modularity goals was to have modular-only buildroot, so in this case, the `custom-1-x86_64` (or another architecture) was the best choice. The idea has [changed](https://communityblog.fedoraproject.org/modularity-dead-long-live-modularity/) and now we want to build modules (i.e. their packages) in standard Fedora buildroot, such as `fedora-28-x86_64`. Let's start from there.

    cp /etc/mock/fedora-28-x86_64.cfg ./modular-fedora-28-x86_64.cfg
    vim ./modular-fedora-28-x86_64.cfg


## DNF

Things are a little bit complicated because of the fact, that DNF with modularity features is not in Fedora yet, neither it is in upstream. We need to get it from Copr repository - [mhatina/dnf-modularity-stable](https://copr.fedorainfracloud.org/coprs/mhatina/dnf-modularity-stable/). If you are brave enough, you can install it on your host system, but we are going to talk about a better option here.

Open the project in your browser and click on the appropriate repofile for your buildroot, in our example <button class="btn btn-xs">Fedora 28</button>. Now we are going to add it to our mock config.

    config_opts['yum.conf'] = """
    ...

    #repos
    ...

    <-------- We are going to add here
    """


The particular DNF repo will look like this.

    [mhatina-dnf-modularity-stable]
    name = Copr repo for dnf-modularity-stable owned by mhatina
    baseurl = https://copr-be.cloud.fedoraproject.org/results/mhatina/dnf-modularity-stable/fedora-$releasever-$basearch/
    enabled = 1
    ....

I've removed some less necessary lines from the original repofile to keep the example short, but you can use it without any changes just fine.

As a consequence of modularity code not being merged into DNF upstream, it can happen that dnf package in Fedora has a greater version then a dnf package built in the Copr repo. Naturally, the greater version is going to be installed into the Mock buildroot, so we have to do a little trick. Find the `updates` repo and exclude the dnf package from it.

    [updates]
    ...
    exclude=dnf

Now we can be sure that the proper DNF will be installed. However, another trick is going to be needed. Consider this, the DNF is going to be installed, but will it be used to create the rest of the buildroot? Actually not, the DNF from your host is going to be used for this. We need to add the following line to the top of the config file

    config_opts['use_bootstrap_container'] = True

This way Mock creates a minimal buildroot containing the DNF with modularity features and then operates within this buildroot to create the final buildroot in which the package is going to be built. That means that `dnf module ...` command will be available while creating the final buildroot. A bit complicated right? Fortunately, we don't have to worry about this too much, and just easily configure the bootstrap container to be used.


## Module in buildroot

First of all, we need to have some module built - either in Koji or Copr. Have you read the recent article about [How to build modules in Copr](/posts/how-to-build-modules-in-copr)? It's pretty cool! Let's assume that we have the `httpd:master` module from that article built in Copr. Now we can add it's repository into the buildroot the same way as the DNF before.

    [frostyx-testmodule_httpd-master-20180128084132]
    name = Copr modules repo for frostyx/testmodule/httpd-master-20180128084132
    baseurl = ...
    enabled = 1
    ...

Alright, the module is available in the buildroot. It doesn't mean that it is going to be installed though. Scroll up to the top of the configuration file and add

    config_opts['module_install'] = ['httpd:master/default']

It means that Mock will execute `dnf module install httpd:master/default` while constructing the buildroot.


## Build the package

The `httpd:master` module in its `default` profile provides the `httpd` package. Now we can have a package dependant on `httpd`

    BuildRequires: httpd

and be able to build it.

    mock -r ./modular-fedora-28-x86_64.cfg /path/to/your/package.src.rpm
