---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: page
---

{% for note in site.notes %}
- [{{ note.title }}]({{ note.url }})
{% endfor %}