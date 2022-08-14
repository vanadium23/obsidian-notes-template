---
layout: page
title: Цитатник
id: quotes
permalink: /quotes/
---

# Цитатник

{% assign latest_quotes = site.notes | where_exp:"item","item.path contains 'quotes'" | sort: 'modified_at' | reverse %}
{% for note in latest_quotes limit:15 %}
- <span>{{ note.modified_at | date: "%Y-%m-%d" }}</span>&nbsp;<a href="{{ note.url | absolute_url }}">{{ note.title }}</a>
{% endfor %}
