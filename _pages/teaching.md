---
layout: home
title: "Teaching — Hao Liu"
permalink: /teaching/
description: "Courses taught by Hao Liu at HKUST(GZ)."
author_profile: false
---

<header class="page-heading">
  <h1>Teaching</h1>
</header>

<section class="academic-section academic-section--compact academic-section--first" aria-labelledby="current-courses-heading">
  <header class="academic-section__header academic-section__header--simple">
    <h2 id="current-courses-heading">Current Courses</h2>
  </header>

  {% include course-list.html courses=site.data.teaching.current current=true %}
</section>

<section class="academic-section academic-section--compact" aria-labelledby="past-courses-heading">
  <header class="academic-section__header academic-section__header--simple">
    <h2 id="past-courses-heading">Past Courses</h2>
  </header>

  {% include course-list.html courses=site.data.teaching.past %}
</section>
