---
layout: slideshow
reveal: https://cdn.rawgit.com/hakimel/reveal.js/3.3.0
reveal-theme: /css/theme/sky.css
style: /css/slideshow.css
---

{% for sorted in site.slide_sorter %}
{% assign id = "/slides/" | append: sorted %}
{% assign hslide = site.slides | where: "id", id | first %}
<section>
{% assign vslides = hslide.content | split: "<!--split-->" %}
{% assign split =  vslides | size %}
{% for vslide in vslides %}
<section{% if hslide.background %} data-background="{{ site.baseurl }}{{ hslide.background }}"{% endif %}{% if hslide.class %} class="{{ hslide.class }}"{% endif %}>
{{ vslide }}
</section>
{% endfor %}
</section>
{% endfor %}