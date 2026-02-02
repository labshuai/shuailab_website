---
title: Team
nav:
  order: 3
  tooltip: About our team
---

# {% include icon.html icon="fa-solid fa-users" %}Team

We possess a dynamic and well-structured talent pool, where team members combine profound clinical expertise with rigorous scientific training, actively engaging in graduate education and teaching reform.

{% include section.html %}

{% include list.html data="members" component="portrait" filter="name == 'Shuai Wang'" %}

{% include section.html %}

{% include list.html data="members" component="portrait" filter="role == 'principal-investigator' and name != 'Shuai Wang'" %}

{% include section.html %}

{% include list.html data="members" component="portrait" filter="role != 'principal-investigator'" %}

{% include section.html background="images/background.jpg" dark=true %}

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

{% include section.html %}

{% capture content %}

{% include figure.html image="images/photo.jpg" %}
{% include figure.html image="images/photo.jpg" %}
{% include figure.html image="images/photo.jpg" %}

{% endcapture %}

{% include grid.html style="square" content=content %}
