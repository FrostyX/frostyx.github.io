---
layout: default
title: Tags
permalink: /tags/
---

<ul class="list-unstyled">
{% assign sorted_tags = site.tags | sort %}
{% for tag in sorted_tags %}
  <li>
    <a href="/tag/{{ tag[0] }}">{{ tag[0] }}</a>
    ({{ tag[1] | size }})
  </li>
{% endfor %}
</ul>
