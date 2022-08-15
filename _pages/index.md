---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
permalink: /
---

<!-- HTML elements for search -->
<input type="text" id="search-input" placeholder="Search blog posts..">
<ul id="results-container"></ul>

<!-- or without installing anything -->
<script src="https://unpkg.com/simple-jekyll-search@latest/dest/simple-jekyll-search.min.js"></script>
<script>
    SimpleJekyllSearch({
        searchInput: document.getElementById('search-input'),
        resultsContainer: document.getElementById('results-container'),
        json: '/_pages/search.json'
    });
</script>