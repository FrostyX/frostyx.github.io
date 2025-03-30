---
layout: post
title: Storing Copr results in Pulp, any volunteers?
lang: en
tags: fedora copr pulp
---

Over the last year, the Copr team has put a lot of effort into supporting Pulp
as a storage for build results. Eventually, all data will be migrated into Pulp,
but at this early stage, we are looking for volunteers who are willing to try
the changes and report bugs.


## Why would you even volunteer

That is a good question because even though there will be a tremendous benefit
in regard to the Copr maintenance, this migration won't bring any changes for
the end-users. Best case scenario, they won't even notice.

That's where you can help us. If you like testing new things and discussing them
with developers, you can be among the first users that have (some) of their
project results stored in Pulp. Together we can make sure all quirks and corner
cases work as expected and make the transition period as smooth as possible
for the more casual users.

## How to volunteer

If you want to migrate an existing Copr project to Pulp, or create a new one,
please contact anyone from the Copr team on [Matrix][matrix],
[mailing list][copr-devel], or via [an issue][issues].

You can also create a new Copr project with Pulp storage using this command:

```
copr-cli create your-new-project \
    --storage pulp
    --chroot fedora-rawhide-x86_64 \
    --chroot fedora-42-x86_64 \
    --chroot fedora-41-x86_64
```


## What should and shouldn't work

All the basic features are already ported and work just fine. When creating a
new project with Pulp storage, submitting builds, enabling the project via DNF,
and then installing packages from it, you shouldn't notice any difference.

This is a list of features that are not supported yet:

- [Project forking][3497] - Copr project with Pulp storage can be forked but it
  will copy only the project information, settings, list of builds and packages,
  etc. But it will not copy the build results.
- [Manual createrepo][3498] - This feature is useful when maintaining large
  software stacks, read more about
  [Creating repositories manually][manual-createrepo] in our documentation.
- [Appstream metadata][3499] - Pulp doesn't support this feature so it is
  possible it will get deprecated and removed from Copr entirely

If you discover any features and use cases that worked before but don't work
with Pulp, [please report them][issues].


Any volunteers are greatly appreciated.



[3497]: https://github.com/fedora-copr/copr/issues/3497
[3498]: https://github.com/fedora-copr/copr/issues/3498
[3499]: https://github.com/fedora-copr/copr/issues/3499
[3448]: https://github.com/fedora-copr/copr/issues/3448
[2901]: https://github.com/fedora-copr/copr/issues/2901
[manual-createrepo]: https://docs.pagure.org/copr.copr/user_documentation.html#id7
[issues]: https://github.com/fedora-copr/copr/issues
[matrix]: https://matrix.to/#/#buildsys:fedoraproject.org
[copr-devel]: mailto:copr-devel@lists.fedorahosted.org
