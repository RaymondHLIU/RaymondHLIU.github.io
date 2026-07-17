---
layout: home
permalink: /publications/full/
title: "Full Publication List — Hao Liu"
excerpt: "Publications by Hao Liu and collaborators."
author_profile: false
---

<header class="page-heading page-heading--split">
  <div>
    <h1>Full publication list</h1>
    <p class="publications-heading__meta">2016–2026</p>
  </div>
  <a class="publications-heading__link" href="{{ site.baseurl }}/publications/">← Selected publications</a>
</header>

<section class="publications-page" aria-label="Publication list">
  <div class="publications-toolbar">
    <p class="publications-note">Student advisees are <span class="publications-note__student">underlined</span>; * marks corresponding authors. Paper links are included when a stable publisher, preprint, or local PDF is available. Source code is generally released through <a href="https://github.com/usail-hkust">our group’s GitHub</a>.</p>

    <nav class="publication-year-index" aria-label="Jump to publication year">
      {% for group in site.data.publications.groups %}
      <a href="#publications-{{ group.id }}">
        <span>{{ group.year }}</span>
      </a>
      {% endfor %}
    </nav>
  </div>

  <div class="publications-list">
    {% for group in site.data.publications.groups %}
    <section class="publication-year" id="publications-{{ group.id }}" aria-labelledby="publications-{{ group.id }}-title">
      <header class="publication-year__heading">
        <h2 id="publications-{{ group.id }}-title">{{ group.year }}</h2>
      </header>
      <ul>
        {% for citation in group.papers %}
        <li>{{ citation | markdownify }}</li>
        {% endfor %}
      </ul>
    </section>
    {% endfor %}
  </div>
</section>
