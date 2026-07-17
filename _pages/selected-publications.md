---
layout: home
permalink: /publications/
title: "Publications — Hao Liu"
excerpt: "Selected publications by Hao Liu and collaborators."
author_profile: false
---

<header class="page-heading page-heading--split">
  <div>
    <h1 id="selected-publications-title">Selected publications</h1>
  </div>
  <a class="publications-heading__link" href="{{ site.baseurl }}/publications/full/">Full publication list →</a>
</header>

<nav class="publication-index" aria-label="Selected publication themes">
  {% for theme in site.data.selected_publications %}
  <a href="#{{ theme.id }}-title"><span>{{ theme.number }}</span>{{ theme.title }}</a>
  {% endfor %}
</nav>

<div class="selected-publications" aria-labelledby="selected-publications-title">
  {% assign publication_index = 0 %}
  {% for theme in site.data.selected_publications %}
  <section class="publication-theme" aria-labelledby="{{ theme.id }}-title">
    <header class="publication-theme__heading">
      <span class="publication-theme__number">{{ theme.number }}</span>
      <h2 id="{{ theme.id }}-title">{{ theme.title }}</h2>
    </header>

    {% for paper in theme.papers %}
    {% assign publication_index = publication_index | plus: 1 %}
    <article class="publication-feature">
      <a class="publication-feature__media{% if paper.logo %} publication-feature__media--logo{% endif %}" href="{{ paper.url }}" aria-label="Read {{ paper.short_title | default: paper.title }}">
        <img src="{{ site.baseurl }}{{ paper.image }}" loading="{% if publication_index == 1 %}eager{% else %}lazy{% endif %}"{% if publication_index == 1 %} fetchpriority="high"{% endif %} alt="{{ paper.image_alt }}">
      </a>
      <div class="publication-feature__content">
        <p class="publication-feature__meta">{{ paper.venue }} · {{ paper.topic }}</p>
        <h2><a href="{{ paper.url }}">{{ paper.title }}</a></h2>
        <p class="publication-feature__authors">{{ paper.authors }}</p>
        <p class="publication-feature__summary">{{ paper.summary }}</p>
        <nav class="publication-feature__links" aria-label="{{ paper.short_title | default: paper.title }} links">
          <a href="{{ paper.url }}">Paper</a>
          <a href="{{ site.baseurl }}{{ paper.bibtex }}" download>BibTeX</a>
          {% for link in paper.links %}<a href="{{ link.url }}">{{ link.label }}</a>{% endfor %}
        </nav>
      </div>
    </article>
    {% endfor %}
  </section>
  {% endfor %}
</div>
