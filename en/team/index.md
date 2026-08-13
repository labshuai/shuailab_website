---
title: Team
description: Meet the investigators and trainees of the Shuai Wang Tri Lab.
lang: en
lang_code: en
translation_key: team
alternate_url: /zh/team/
permalink: /en/team/
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

{% include list.html data="members" component="portrait" filter="role != 'principal-investigator' and role != 'collaborator'" %}
