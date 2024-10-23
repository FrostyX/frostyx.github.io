---
layout: post
title: Copr Modularity, the End of an Era
lang: en
tags: copr fedora modularity
---

Our team has put a lot of effort into the possibility of
[building modules in Copr][modularity-docs-copr].  This feature went through
[many iterations and rewrites from scratch][modularity-retrospect] as the
concepts, requirements, and goals of [Fedora Modularity][fedora-modularity] kept
changing. This will be my last article about this topic because we are planning
to drop Modularity and all of its functionality from Copr. The only exception
are [Module hotfixes][module-hotfixes], which are staying for good.


## Why?

The Fedora Modularity project never really took off, and building modules in
Copr even less so.  We've had only 14 builds in the last two years. It's not
feasible to maintain the code for so few users. Modularity has also been
[retired since Fedora 39][modularity-end-fedora] and will die with RHEL 9.

<div class="text-center img-row row">
  <div style="width:550px;font-size:17px;display:inline-block;">
    <svg class="line-chart"></svg>
    <script src="https://cdn.jsdelivr.net/npm/chart.xkcd@1/dist/chart.xkcd.min.js"></script>
    <script>
      const svg = document.querySelector('.line-chart')
      new chartXkcd.Line(svg, {
          title: 'Copr module builds throughout the years',
          data: {
              labels:['2015', '2016', '2017', '2018', '2019', '2020','2021', '2022', '2023', '2024'],
              datasets: [{
                  data: [0, 11, 67, 86, 82, 95, 63, 54, 5, 9],
              }]
          },
          options: {yTickCount: 5}
      });
    </script>
    <noscript>Enable Javascript to see a cute XKCD looking chart.</noscript>
  </div>
</div>

Additionally, one of our larger goals for the upcoming years is to start using
[Pulp as a storage for all Copr build results][pulp-epic]. This requires
rewriting several parts of the backend code. Factoring in reimplementation for
module builds would result in many development hours wasted for very little
benefit. All projects with modules will remain in the current storage until the
Modularity is finally dropped.


## Schedule

In the ideal world, we would keep the feature available as long as RHEL 9 is
supported, but we cannot wait until [2032][rhel-9-support].

- October 2024 - All Modularity features in Copr are now deprecated
- April 2025 - It won't be possible to submit new module builds
- October 2025 - Web UI and API endpoints for getting module information will
  disappear
- April 2026 - All module information will be removed from the database, and
  their build results will be removed from our storage


## Communication

It was me who introduced all the Modularity code into Copr, so it should also be
me who decommissions it. Feel free to ping me directly if you have any questions
or concerns, but you are also welcome to reach out on the
[Copr Matrix channel][matrix], [mailing list][mailing-list], or in the form of
[GitHub issues][github-issues]. In the meantime, I will contact everybody who
submitted a module build in Copr in the past two years and make sure they don't
rely on this feature.


[modularity-docs-copr]: https://docs.fedoraproject.org/en-US/modularity/building-modules/copr/building-modules-in-copr/
[modularity-retrospect]: https://frostyx.cz/posts/copr-modularity-in-retrospect
[fedora-modularity]: https://docs.pagure.org/modularity/
[module-hotfixes]: https://frostyx.cz/posts/module-hotfixes-in-copr
[modularity-end-fedora]: https://fedoraproject.org/wiki/Changes/RetireModularity
[rhel-9-support]: https://access.redhat.com/support/policy/updates/errata
[matrix]: https://matrix.to/#/#buildsys:fedoraproject.org
[mailing-list]: https://lists.fedorahosted.org/archives/list/copr-devel@lists.fedorahosted.org/
[github-issues]: https://github.com/fedora-copr/copr/issues
[pulp-epic]: https://github.com/fedora-copr/copr/issues/2533
