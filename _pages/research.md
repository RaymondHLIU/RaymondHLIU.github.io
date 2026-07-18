---
layout: home
permalink: /research/
title: "Research — Hao Liu"
excerpt: "Research on agentic systems for complex digital and physical worlds."
author_profile: false
---

{% assign research = site.data.research %}

<header class="page-heading page-heading--with-lead">
  <h1>Research</h1>
  <p>{{ research.lead }}</p>
</header>

<figure class="research-framework">
  <picture>
    <source media="(max-width: 560px)" srcset="{{ site.baseurl }}{{ research.framework.mobile_image }}">
    <img src="{{ site.baseurl }}{{ research.framework.desktop_image }}" alt="{{ research.framework.alt }}">
  </picture>
  <figcaption>{{ research.framework.caption }}</figcaption>
</figure>

<section class="research-perspectives" aria-labelledby="research-perspectives-heading">
  <h2 id="research-perspectives-heading">Surveys &amp; perspectives</h2>
  <ul>
    {% for paper in research.perspectives %}<li><a href="{{ paper.url | escape }}">{{ paper.title }}</a></li>{% endfor %}
  </ul>
</section>

<section class="research-page__body" aria-label="Research themes and related work">
  {% include selected-research-theme.html %}

  <p class="home-section__footer-link"><a href="{{ site.baseurl }}{{ research.full_publications.url }}">{{ research.full_publications.label }}</a></p>
</section>
