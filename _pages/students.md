---
layout: home
title: "Students — Hao Liu"
permalink: /students/
description: "Student achievements and alumni supervised by Hao Liu."
author_profile: false
---

<header class="page-heading">
  <h1>Students</h1>
</header>

<section class="academic-section academic-section--first" aria-labelledby="student-achievements-heading">
  <header class="academic-section__header academic-section__header--simple">
    <h2 id="student-achievements-heading">Student Achievements</h2>
  </header>

  <ul class="achievement-list achievement-list--flat">
    {% for achievement in site.data.students.achievements %}
      <li>
        <strong>{{ achievement.name }}</strong>
        <span>{% if achievement.url %}<a href="{{ achievement.url | escape }}">{{ achievement.award }}</a>{% else %}{{ achievement.award }}{% endif %}</span>
      </li>
    {% endfor %}
  </ul>
</section>

<section class="academic-section" aria-labelledby="alumni-heading">
  <header class="academic-section__header academic-section__header--simple">
    <h2 id="alumni-heading">Alumni</h2>
  </header>

  <div class="people-groups">
    <ul class="people-list people-group">
      {% for person in site.data.students.alumni.students %}
        <li><strong>{{ person.name }}</strong><span>{{ person.degree }}, {{ person.year }} → {{ person.destination }}</span></li>
      {% endfor %}
    </ul>

    <ul class="people-list people-group people-group--assistants">
      {% for person in site.data.students.alumni.assistants %}
        <li><strong>{{ person.name }}</strong><span>{{ person.role }} · {{ person.background }}{% if person.destination %} → {{ person.destination }}{% endif %}</span></li>
      {% endfor %}
    </ul>
  </div>
</section>
