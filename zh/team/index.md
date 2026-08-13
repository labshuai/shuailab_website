---
title: 团队成员
description: 了解王帅联合实验室的研究人员和学生团队。
lang: zh
lang_code: zh-CN
translation_key: team
alternate_url: /en/team/
permalink: /zh/team/
nav:
  order: 3
  tooltip: 了解研究团队
---

# {% include icon.html icon="fa-solid fa-users" %}团队成员

我们拥有充满活力、结构合理的人才梯队。团队成员兼具深厚的临床经验和严谨的科研训练，并积极参与研究生培养与教学改革。

{% include section.html %}

{% include list.html data="members" component="portrait" filter="name == 'Shuai Wang'" %}

{% include section.html %}

{% include list.html data="members" component="portrait" filter="role == 'principal-investigator' and name != 'Shuai Wang'" %}

{% include section.html %}

{% include list.html data="members" component="portrait" filter="role != 'principal-investigator' and role != 'collaborator'" %}
