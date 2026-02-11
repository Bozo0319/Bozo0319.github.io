{% extends "_layout.swig" %}

{% block title %} {{ __('menu.categories') }} - {{ config.title }} {% endblock %}

{% block content %}
  <div class="categories">
    <div class="categories-title">
      {{ _p('counter.categories', site.categories.length) }}
    </div>
    <div class="categories-tags">
      {% for category in site.categories.toArray() %}
        {% if category.name != 'journal' %}
          <a class="category-link" href="{{ url_for(category.path) }}">
            {{ category.name }}
          </a>
        {% endif %}
      {% endfor %}
    </div>
  </div>
{% endblock %}
