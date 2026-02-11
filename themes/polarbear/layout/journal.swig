{% extends "_layout.swig" %}

{% block title %}{{ page.title or 'Journal' }} - {{ config.title }}{% endblock %}

{% block content %}
<section class="journal-wrap">
  <header class="journal-header">
    <h1>{{ page.title or 'Journal' }}</h1>
  </header>

  {# ===== Tag 筛选条：只显示“被 journal 文章使用过”的 tag ===== #}
  <div class="journal-filter">
    <button class="journal-filter-btn is-active" type="button" data-tag="__all">All</button>

    {% for tag in site.tags %}
      {% set has_journal = false %}

      {% for p in tag.posts %}
        {% set is_journal_post = false %}
        {% if p.categories %}
          {% for c in p.categories %}
            {% if c.name == 'journal' %}
              {% set is_journal_post = true %}
            {% endif %}
          {% endfor %}
        {% endif %}

        {% if is_journal_post %}
          {% set has_journal = true %}
        {% endif %}
      {% endfor %}

      {% if has_journal %}
        <button class="journal-filter-btn" type="button" data-tag="{{ tag.name }}">#{{ tag.name }}</button>
      {% endif %}
    {% endfor %}
  </div>

  {# ===== 列出 journal 广播 ===== #}
  {% set items = [] %}
  {% for post in site.posts %}
    {% set is_journal = false %}
    {% if post.categories %}
      {% for c in post.categories %}
        {% if c.name == 'journal' %}
          {% set is_journal = true %}
        {% endif %}
      {% endfor %}
    {% endif %}
    {% if is_journal %}
      {% set items = items.concat([post]) %}
    {% endif %}
  {% endfor %}

  {% if items.length == 0 %}
    <p class="journal-empty">还没有广播。</p>
  {% else %}
    <div class="journal-list">
      {% for post in items %}
        {# 把该条广播的 tags 拼成 data-tags，供前端筛选 #}
        {% set tagStr = '' %}
        {% if post.tags and post.tags.length %}
          {% for t in post.tags %}
            {% set tagStr = tagStr + t.name + ' ' %}
          {% endfor %}
        {% endif %}

        <article class="journal-item" data-tags="{{ tagStr | trim }}">
          <div class="journal-meta">
            <time datetime="{{ post.date.toISOString() }}">{{ date(post.date, "YYYY-MM-DD HH:mm") }}</time>

            {% if post.tags and post.tags.length %}
              <span class="journal-tags">
                {% for t in post.tags %}
                  <span class="journal-tag">#{{ t.name }}</span>
                {% endfor %}
              </span>
            {% endif %}
          </div>
        <div class="journal-post-title">
            {{ post.title }}
        </div>
          <div class="journal-content">
            {{ post.content }}
          </div>
        </article>
      {% endfor %}
    </div>
  {% endif %}
</section>

<script>
(function(){
  var btns = document.querySelectorAll('.journal-filter-btn');
  var items = document.querySelectorAll('.journal-item');

  function setActive(btn){
    btns.forEach(function(b){ b.classList.remove('is-active'); });
    btn.classList.add('is-active');
  }

  function filter(tag){
    items.forEach(function(it){
      var tags = (it.getAttribute('data-tags') || '').split(/\s+/).filter(Boolean);
      if(tag === '__all') { it.style.display = ''; return; }
      it.style.display = tags.indexOf(tag) >= 0 ? '' : 'none';
    });
  }

  btns.forEach(function(btn){
    btn.addEventListener('click', function(){
      var tag = btn.getAttribute('data-tag');
      setActive(btn);
      filter(tag);
    });
  });
})();
</script>
{% endblock %}