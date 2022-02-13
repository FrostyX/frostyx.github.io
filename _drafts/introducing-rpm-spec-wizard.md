---
layout: post
title: Introducing RPM Spec Wizard
lang: en
tags: fedora packaging
---

Do you want to create your first Fedora package but don't know where
to start? Try [RPM Spec Wizard][rpm-spec-wizard], it will guide you
through the process.

If you asked me how to create a Fedora package, I would probably
point you to the [RPM Packaging Guide][rpm-packaging-guide],
[Fedora Packaging Guidelines][fedora-packaging-guidelines], or
this [Packaging Workshop for Beginners][workshop] recording
from [Miroslav Suchý][msuchy]. Upon realizing that your options are an
80 pages document, a comprehensive specification so long, that nobody
ever read it in its entirety, and a lecture with a length of a feature
film, you wouldn't like me very much.

While those are great learning resources, they can be a little bit too
overwhelming for a first-time contributor. That is why we created
[RPM Spec Wizard][rpm-spec-wizard]. It is an interactive guide that
you can simply open, and step by step, provide information that it asks
for.

<div class="text-center img-row row">
  <a href="https://xsuchy.github.io/rpm-spec-wizard/"
     title="RPM Spec Wizard">
    <img src="/files/img/rpm-spec-wizard.png">
  </a>
</div>

No previous knowledge is required, every slide provides an explanation
and links to an appropriate section in the documentation. If you are
worried about privacy, we don't do and don't intend to do anything
with your data. The project is written in Javascript and runs solely
in your web browser. There will never be any backend code, database,
or anything of the sorts. If you are still concerned, running your
personal instance is very easy.

If you have any questions or suggestions, feel free to contact us at
[#fedora-buildsys][fedora-buildsys] or
[devel@lists.fedoraproject.org][mailing-list]


[rpm-spec-wizard]: https://xsuchy.github.io/rpm-spec-wizard/
[github]: https://github.com/xsuchy/rpm-spec-wizard
[rpm-packaging-guide]: https://rpm-packaging-guide.github.io/
[fedora-packaging-guidelines]: https://docs.fedoraproject.org/en-US/packaging-guidelines/
[workshop]: https://www.youtube.com/watch?v=KdIsoYGSNS8
[msuchy]: https://fedoraproject.org/wiki/User:Msuchy
[fedora-buildsys]: https://libera.chat/guides/connect
[mailing-list]: https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/
