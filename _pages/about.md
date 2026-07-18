---
layout: home
permalink: /
title: "Hao Liu — Agentic Systems"
excerpt: "Hao Liu is an Associate Professor at HKUST(GZ) working on agentic systems for complex digital and physical worlds."
author_profile: false
redirect_from:
  - /about/
  - /about.html
---

{% assign profile = site.data.profile %}
{% assign home = site.data.home %}

<section class="home-intro" aria-labelledby="home-name">
  <div class="home-intro__copy">
    <h1 id="home-name">{{ profile.name }}</h1>

    <p class="home-bio">{{ profile.bio }}</p>

    <nav class="home-links" aria-label="Profile links">
      {% for link in profile.links %}
        <a{% if link.internal %} class="home-links__internal"{% endif %} href="{{ link.url | escape }}">{{ link.label }}</a>
      {% endfor %}
    </nav>
  </div>

  <figure class="home-portrait">
    <img src="{{ site.baseurl }}{{ profile.portrait.src }}" alt="{{ profile.portrait.alt }}">
  </figure>
</section>

<section class="home-overview" id="research" aria-labelledby="research-heading">
  <header class="home-overview__header">
    <h2 id="research-heading">{{ home.research.heading }}</h2>
    <p>{{ home.research.lead }}</p>
  </header>

  <div class="home-questions home-questions--overview" aria-label="Core research capabilities">
    {% for capability in home.research.capabilities %}
      <article class="home-question">
        <span class="home-question__number">{{ capability.number }}</span>
        <h3>{{ capability.title }}</h3>
        <p>{{ capability.description }}</p>
      </article>
    {% endfor %}
  </div>

  <p class="home-section__footer-link home-section__footer-link--research"><a href="{{ site.baseurl }}{{ home.research.link.url }}">{{ home.research.link.label }}</a></p>
</section>

<section class="home-section" aria-labelledby="updates-heading">
  <header class="home-section__header home-section__header--label-only">
    <h2 class="home-section__eyebrow" id="updates-heading">Recent updates</h2>
  </header>

  {% include news-list.html featured_only=true use_summary=true limit=5 %}
  <p class="home-news-link"><a href="{{ site.baseurl }}/news/">Older news →</a></p>
</section>

<section class="home-section" id="join-us" aria-labelledby="join-us-heading">
  <header class="home-section__header">
    <p class="home-section__eyebrow">{{ home.join.eyebrow }}</p>
    <h2 class="home-section__title" id="join-us-heading">{{ home.join.title }}</h2>
  </header>

  <div class="home-join">
    {% for opportunity in home.join.opportunities %}
      <article>
        <h3>{{ opportunity.title }}</h3>
        <p>{% include inline-markdown.html content=opportunity.content %}</p>
      </article>
    {% endfor %}
  </div>
</section>
