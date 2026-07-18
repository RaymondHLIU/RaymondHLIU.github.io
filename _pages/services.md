---
layout: home
title: "Services — Hao Liu"
permalink: /services/
description: "Editorial, organizational, and reviewing service by Hao Liu."
author_profile: false
---

<header class="page-heading">
  <h1>Services</h1>
</header>

<section class="academic-section academic-section--first" aria-labelledby="editorial-service-heading">
  <header class="academic-section__header academic-section__header--simple">
    <h2 id="editorial-service-heading">Editorial and Organizational Service</h2>
  </header>

  <ul class="service-list">
    {% for service in site.data.services.editorial_and_organizational %}
      <li>{% if service.url %}<a href="{{ service.url | escape }}">{{ service.organization }}</a>{% else %}<strong>{{ service.organization }}</strong>{% endif %}<span>{{ service.role }}</span></li>
    {% endfor %}
  </ul>
</section>

<section class="academic-section" aria-labelledby="program-committee-heading">
  <header class="academic-section__header academic-section__header--simple">
    <h2 id="program-committee-heading">Conference Service</h2>
  </header>

  <div class="service-grid">
    {% for conference in site.data.services.conferences %}
      <article><h3>{{ conference.name }}</h3><p>{{ conference.years }}</p></article>
    {% endfor %}
  </div>
</section>

<section class="academic-section" aria-labelledby="journal-reviewing-heading">
  <header class="academic-section__header academic-section__header--simple">
    <h2 id="journal-reviewing-heading">Journal Reviewing</h2>
  </header>

  <ul class="journal-list">
    {% for journal in site.data.services.journals %}<li>{{ journal }}</li>{% endfor %}
  </ul>
</section>
