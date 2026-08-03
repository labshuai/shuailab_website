---
title: News
nav:
  order: 5
  tooltip: Latest news and research updates
---

# {% include icon.html icon="fa-solid fa-newspaper" %}News

{% include section.html %}

{% include search-box.html %}

{% include tags.html tags=site.tags %}

{% include search-info.html %}

{% include list.html data="posts" component="post-excerpt" %}
