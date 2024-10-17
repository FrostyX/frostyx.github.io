---
layout: post
title: Copr Modularity, the end of an era
lang: en
tags: copr fedora modularity
---


Our team has put a lot of effort into supporting the Fedora Modularity project
by adding the possibility of building modules in Copr. This feature went through
many iterations and rewrites from scratch as the concepts, requirements, and
goals kept changing. This will be my last article about Fedora Modularity
because we are planning to drop all its functionality from Copr.


## Why?

The Fedora Modularity project never really took off. And building modules in
Copr even less so.  We've had only 14 builds in the last two years. It's not
feasible to maintain the code for so few users.  The modularity has also been
retired since Fedora 39 and will die with RHEL 9.

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
          options: {}
      });
    </script>
    <noscript>Enable Javascript to see a cute XKCD looking chart.</noscript>
  </div>
</div>


## Schedule

In the ideal world, we would keep the feature available as long as RHEL 9 is
supported but we cannot wait until 2032.

- October 2024 - All modularity features in Copr are now deprecated
- April 2025 - It won't be possible to submit new module builds
- October 2025 - Web UI and API endpoints for getting module information will
  disappear
- April 2026 - All module information will be removed from the database and all
  module build results will be removed from our storage


## Communication

It was me who introduced all the modularity code into Copr, so it must also be
me who decommissions it. I need closure from this bad relationship.

Feel free to ping me directly if you have any questions or concerns but you are
also welcome to reach out on Matrix, mailing-list, or in the form of issues. In
the meantime, I will contact everybody who submitted a module build in Copr in
the past two years and make sure they don't rely on this feature.



[modularity-end-fedora]: https://fedoraproject.org/wiki/Changes/RetireModularity
