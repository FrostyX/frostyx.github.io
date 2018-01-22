---
layout: post
title: Modules with Copr packages
lang: en
categories: dev copr fedora modularity
---


In the [last article](/posts/how-to-build-modules-in-copr), we have talked about [Fedora modularity project](https://docs.pagure.org/modularity/) and how to submit a module to be built in Copr. If you choose to write a modulemd file manually, you may be puzzled on how to have a package built in Copr as the part of the module. This is exactly what this article is going to be about.

Let's assume that you have your [modulemd yaml](https://pagure.io/modulemd/blob/master/f/spec.yaml) file created and you want to add a package from Copr into it. We are going to modify the `components` section, which should so far look like this

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
                rationale: An example package built in Copr
                ref: 9d1ced1
                repository: 'http://copr-dist-git.fedorainfracloud.org/git/frostyx/hello/hello.git'

wait, wait, wait ... but, where can I find the `ref` and `repository` for my package? Follow this short image tutorial.

---

Open the builds tab in your project and find the build that should be a part of your module. Then click on its ID.
<img src="/files/img/builds.png" alt="Builds tab" class="img-responsive center-block">
<br>

Scroll down the detail page to see the results box. In the "Dist Git Source" column, you can find the git hash, that is supposed to be used as `ref`. Write it down and then click on it.
<img src="/files/img/build-results.png" alt="Build results" class="img-responsive center-block">
<br>

Now you can see the Copr [dist git](https://clime.github.io/2017/05/20/DistGit-1.0.html). Use the first part of the URL as `repository`
<img src="/files/img/cgit.png" alt="Build results" class="img-responsive center-block">
<br>

---

Simple as that. Go and try :-)
