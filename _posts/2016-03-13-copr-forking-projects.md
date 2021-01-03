---
layout: post
title: Copr - Forking Projects
lang: en
tags: copr fedora changelog howto
---

Do you know the famous <button class="btn btn-default btn-xs"><i class="fa fa-code-fork"></i> Fork</button> button on GitHub? Now this feature is finally here for Copr and it brings us many possible scenarios how to utilize it!

First, lets see how it looks like. We can find the <button class="btn btn-default btn-xs"><i class="fa fa-code-fork"></i> Fork this project</button> button on the right side of the project overview page. It is located in "Other Actions" bubble. Once you are logged in, you will see this button for every project. After clicking on it, you will be redirected to simple page to specify very few details.

![Specify how to fork the project](/files/img/copr-fork-form.png)

The standard use case is obvious - create your own copy of some existing project. Such copy can be own by you personally or by some group that you belong to. But you can do more. It is possible to fork your own projects so for example you are able to freeze your packages in specific version.

It may sound strange, but it is also possible to fork data into existing project. Copr will go through all packages in original project and copy all those which are are not in destination one yet. For existing packages it will copy their newest builds.

<br>

Few notes that you should be aware of:

- While forking any project, the permissions table will **never** be copied
- Copr will not duplicate all builds from the project. It will always make you copy only of the last build of every package.
