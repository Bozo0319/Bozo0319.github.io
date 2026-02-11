{% if theme.widget.Tags %}
  <section id="tags" class="widget-area widget_tags">
    <h3 class="widget-title">Tags</h3>

    <ul class="tag-list">
      {% for tag in site.tags %}
        {# 判断这个 tag 是否被“非 journal”文章使用过 #}
        {% set has_non_journal = false %}

        {% for p in tag.posts %}
          {% set is_journal_post = false %}

          {% if p.categories %}
            {% for c in p.categories %}
              {% if c.name == 'journal' %}
                {% set is_journal_post = true %}
              {% endif %}
            {% endfor %}
          {% endif %}

          {% if not is_journal_post %}
            {% set has_non_journal = true %}
          {% endif %}
        {% endfor %}

        {% if has_non_journal %}
          <li class="tag-list-item">
            <a class="tag-list-link" href="{{ url_for(tag.path) }}">
              {{ tag.name }}
            </a>
            <span class="tag-list-count">{{ tag.length }}</span>
          </li>
        {% endif %}

      {% endfor %}
    </ul>

  </section>
{% endif %}