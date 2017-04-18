---
layout: post
title: Copr &lt;3 Modularity
lang: en
categories: dev copr fedora
---


[Modularity](https://fedoraproject.org/wiki/Modularity) is an exciting, new initiative aimed at resolving the issue of diverging lifecycles of different *components* within Fedora. The building block of this idea is a **module**, which is a set of RPM packages that are well tested together as a solution. Module defines its components and dependencies and then it can be built into **artifact** such as repository or container.

## Modularity in Copr

In last releases we introduced a lot of interesting things regarding modularity. You can now use copr-cli for submitting an existing modulemd to be built or alternatively generate modulemd from your project through few easy steps in your browser. We also made a cool UI for viewing modules.


### How to submit a module via copr-cli

Now we have a new command `copr-cli build-module ...` for submitting module builds into Copr and it is very easy to use. It expect you to select one of the optional parameters `--url` or `--yaml` to specify a modulemd source. And that is basically it. You can also specify an owner and project name like you can do it for other copr-cli commands.

<pre class="prettyprint">
# Most simple is just to submit a build from localy stored modulemd yaml file
copr-cli build-module --yaml ~/git/testmodule/testmodule.yaml

# Guys from Factory 2.0 may be also interested in submitting yaml files stored in some SCM
copr-cli build-module --url git://pkgs.fedoraproject.org/modules/testmodule.git?#9082569

# To specify an owner and project name, use positional argument as usual
copr-cli make-module --yaml ~/git/testmodule/testmodule.yaml @copr/testmodule
</pre>


Watch this two minutes long video to see building modules in action

<div class="embed-responsive embed-responsive-16by9">
    <iframe class="embed-responsive-item" src="https://www.youtube.com/embed/mkHJg5QmAxg"></iframe>
</div>


### Background
Let's very briefly talk about how this works. There is a [Module Build Service](https://pagure.io/fm-orchestrator) (aka MBS) which orchestrates all the magic related to modules. It takes care about obtaining the dependencies for the module, order in which they should be built, etc. Copr runs own instance of this service and after you submit a build to the frontend, it passes it to MBS which takes control about it and orchestrates the rest of the process. If you want to know more, look forward to an upcoming article about it.


## Limitations
Try it and tell us the limitations. What needs to be improved in order to make you start using this feature?

Few limitations we already know about:

- When submitting via `--url` option, only certain URLs are allowed ([pkgs.stg.fedoraproject.org](git://pkgs.stg.fedoraproject.org/modules/) and [pkgs.fedoraproject.org](git://pkgs.fedoraproject.org/modules/)). This restriction comes from MBS (issue [#513](https://pagure.io/fm-orchestrator/issue/513)) and hopefully should be removed soon.
- No user access to logs. Unfortunately when something fails and it shouldn't you have to ping an admin to examine the logs, you can't do it by yourself yet


## What next
In next article we will look on generating a modulemd from a copr project and building it without any knowledge about creating modules whatsoever. And where the development should proceed? It is mainly up to you and use-cases that you want to achieve. Let us know your ideas in the comment section below or on our [mailing list](https://lists.fedorahosted.org/admin/lists/copr-devel.lists.fedorahosted.org/).


## References
- [1] <https://fedoraproject.org/wiki/Modularity>
- [2] <https://www.youtube.com/watch?v=mkHJg5QmAxg>
- [3] <https://pagure.io/fm-orchestrator>
