---
title: "Talks and Presentations"
permalink: /talks/
author_profile: true
---
<ul class="talk-list">
  {% for talk in site.data.talks.items %}
    <li>
      <strong>{{ talk.title }}</strong>. {{ talk.format }} at
      {% if talk.venue_url %}<a href="{{ talk.venue_url }}">{{ talk.venue }}</a>{% else %}{{ talk.venue }}{% endif %}{% if talk.location %}, {{ talk.location }}{% endif %}.
      <em>{{ talk.date }}</em>.
    </li>
  {% endfor %}
</ul>
