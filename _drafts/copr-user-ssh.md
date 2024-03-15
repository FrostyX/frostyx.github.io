---
layout: post
title: SSH access to Copr builders
lang: en
tags: fedora copr
---

Sometimes it can be hard to debug failed [Copr][copr] builds. Maybe they fail
only on a specific architecture and you don't have an [s390x mainframe][ibm-z]
in your spare bedroom, maybe there are [Copr-specific conditions][copr-macros]
in your package, or maybe the Copr builders aren't beefy enough to build it.
To make the debugging process as pain-free as possible, Copr
[now][release-notes] allows connecting to the builder virtual machines using SSH
and running any commands you need.


## Wait! What?

It may be hard to believe but it is true. You can simply click a button to
resubmit a build with enabled SSH access to the builder, specify your
[public SSH][ssh-keys] key, and then connect as root. No bureaucracy, no special
permissions, and no prerequisites. As far as I know, this is an unprecedented
feature in the build-system world.

Please let us know your thoughts once you try it.


## How it works

Submit a build [any way you want][build-source-types] and wait until it
finishes. It doesn't matter whether it fails or succeeds. If something went
wrong and it requires debugging within the Copr infrastructure, click the
`Resubmit and allow SSH` button.


<div class="text-center img-row row">
  <a href="/files/img/rebuild-and-allow-ssh.png"
     title="I already fixed all gain/high so these are gain/medium just for the screenshot">
    <img src="/files/img/rebuild-and-allow-ssh.png">
  </a>
</div>
<br>


You will be redirected to the familiar page for resubmitting builds which has
been in Copr for years. Upon closer inspection, you will notice some changes. At
the top, there are basic instructions on how to interact with the builder, and
in the form, you can specify your public SSH keys. Multiple keys are allowed,
just separate them with a new line.

If you don't know what your or your coworker's keys are, there are a few ways to
find out.

- List public keys on your computer `ls ~/.ssh/*.pub`
- Check anyone's public key on GitHub - <https://github.com/frostyx.keys>
- Check anyone's public key in FAS - <https://accounts.fedoraproject.org/user/frostyx>

If your project provides multiple chroots, ideally submit this build only for
one of them. Then wait until the build starts running and the following text
appears in the `backend.log`.

```
Deployed user SSH key for frostyx
The owner of this build can connect using:
ssh root@44.203.44.242
Unless you connect to the builder and prolong its expiration, it will be shut-down in 2024-03-12 14:40
After connecting, run `copr-builder help' for complete instructions
```

The instructions are self-explanatory. From your computer, run:

```
ssh root@44.203.44.XXX
```

You are greeted with a [MOTD][motd], please make sure to read it.

```
You have been entrusted with access to a Copr builder.
Please be responsible.

This is a private computer system, unauthorized access is strictly
prohibited. It is to be used only for Copr-related purposes,
not as your personal computing system.

Please be aware that the legal restrictions for what you can build
in Copr apply here as well.
https://docs.pagure.org/copr.copr/user_documentation.html#what-i-can-build-in-copr

You can display more help on how to use the builder by running copr-builder:
...
```
If for some reason you can't see the message, please manually run
`copr-builder help`.


You are now `root`. _Remember, with great power comes great responsibility --
[Uncle Ben][great-power]_


## Limitations

- For security reasons, once the build finishes, no results other than spec file
  and logs are fetched to the backend storage and the project repository. The
  builder is also assigned to a unique sandbox preventing it from being re-used
  by any other build, even from the same user
- To avoid wasting resources, only two builders with SSH access can be allocated
  for one user at the same time
- Because of the previous two points, Copr cannot automatically enable SSH
  access when the build fails. The build needs to be manually resubmitted with
  SSH access enabled
- The builder machine is automatically terminated after 1 hour unless you
  prolong its lifespan. The maximum limit is 48 hours
- Some builders are available only through an IPv6 address and you can't choose
  which one you get. If you can't connect, cancel the build and try again, or
  use a machine with working IPv6 as a proxy. To check if IPv6 works on your
  machine, use <https://test-ipv6.com>
- It is not possible to resubmit a build that failed during the SRPM build
  phase. This is only an implementation detail and might change in the future


## Future

It is obvious that this feature is still in its infancy and there is a big room
for improvement. Ideally, your public key should automatically fetched from FAS,
and the form input should support special syntax for allowing keys based on FAS
or GitHub username, e.g. `FAS:msuchy GitHub:praiskup`. There is currently no
support for this feature in the API, `python3-copr`, and `copr-cli` but it is
definitely on the roadmap. We also want to soften some hard edges around
searching the builder IP address and integrate it into the user interface.

As always, happy building. Or should I say debugging?



[copr]: https://copr.fedorainfracloud.org/
[copr-macros]: https://docs.pagure.org/copr.copr/user_documentation.html#rpm-macros
[motd]: https://en.wikipedia.org/wiki/Message_of_the_day
[ibm-z]: https://en.wikipedia.org/wiki/IBM_Z#/media/File:IBM_Z14_(36084219181).jpg
[release-notes]: https://docs.pagure.org/copr.copr/release-notes/2024-03-07.html
[ssh-keys]: https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key
[build-source-types]: https://docs.pagure.org/copr.copr/user_documentation.html#build-source-types
[great-power]: https://www.youtube.com/watch?v=guuYU74wU70
