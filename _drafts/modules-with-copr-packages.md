---
layout: post
title: Modules with Copr packages
lang: en
categories: dev copr fedora modularity
---


In the [last article](/posts/copr-loves-modularity) we talked about Fedora modularity project and how to submit a module to be built in Copr. There was a limitation though - all components needed to be official fedora packages. This is no longer true and now you can build a module on top of packages from Copr!


Lets assume that you have your [modulemd yaml](https://pagure.io/modulemd/blob/master/f/spec.yaml) file created and you want to add a package from Copr into it. We are going to modify a `components` section, which so far should look like this

    components:
        rpms:
            ed:
                rationale: A build dependency of mksh.
                ref: master
            mksh:
                rationale: The main package of the module.
                buildorder: 1
                ref: master

We can append a Copr package like this

            hello:
                rationale: An example of Copr package
                ref: 9d1ced1
                repository: 'http://copr-dist-git.fedorainfracloud.org/git/frostyx/hello/hello.git'

wait, wait, wait ... but, where can I find the `ref` and `repository` for my package? Follow this short image tutorial.

---

Open your builds tab and select the build that you want to re-build as part of a module. Then click on it's ID.
<img src="/files/img/builds.png" alt="Builds tab" class="img-responsive center-block">
<br>

Git hash, that you should use as a `ref` is in the results table named as "Dist Git Source". Use it and then click on it.
<img src="/files/img/build-results.png" alt="Build results" class="img-responsive center-block">
<br>

Use a first part of the URL as `repository`
<img src="/files/img/cgit.png" alt="Build results" class="img-responsive center-block">
<br>

---

Simple as that. Go and try it.


## References
- [1] <http://frostyx.cz/posts/copr-loves-modularity>
- [2] <https://pagure.io/modulemd/blob/master/f/spec.yaml>
