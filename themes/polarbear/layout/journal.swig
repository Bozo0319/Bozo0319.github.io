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

  {# ===== 直接渲染 journal 广播（不在 swig 里排序/拼数组）===== #}
  <div class="journal-list" id="journalList">
    {% set journal_count = 0 %}

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
        {% set journal_count = journal_count + 1 %}

        {# 拼 data-tags #}
        {% set tagStr = '' %}
        {% if post.tags and post.tags.length %}
          {% for t in post.tags %}
            {% set tagStr = tagStr + t.name + ' ' %}
          {% endfor %}
        {% endif %}

        <article class="journal-item" data-tags="{{ tagStr | trim }}" data-date="{{ post.date.toISOString() }}">
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

          <div class="journal-content journal-content--collapsed">
            {{ post.content }}
          </div>

          <button class="journal-more" type="button" aria-expanded="false">More</button>
        </article>
      {% endif %}
    {% endfor %}

    {% if journal_count == 0 %}
      <p class="journal-empty">还没有广播。</p>
    {% endif %}
  </div>
</section>

<script>
(function () {
  var list = document.getElementById('journalList');
  if (!list) return;

  // 1) 强制按时间逆序排序（最新在前）
  var nodes = Array.prototype.slice.call(list.querySelectorAll('.journal-item'));
  nodes.sort(function (a, b) {
    var da = new Date(a.getAttribute('data-date')).getTime();
    var db = new Date(b.getAttribute('data-date')).getTime();
    return db - da;
  });
  nodes.forEach(function (n) { list.appendChild(n); });

  // 2) Tag 筛选
  var btns = document.querySelectorAll('.journal-filter-btn');
  function setActive(btn) {
    Array.prototype.forEach.call(btns, function (b) { b.classList.remove('is-active'); });
    btn.classList.add('is-active');
  }

  function filter(tag) {
    nodes.forEach(function (it) {
      var tags = (it.getAttribute('data-tags') || '').split(/\s+/).filter(Boolean);
      if (tag === '__all') { it.style.display = ''; return; }
      it.style.display = tags.indexOf(tag) >= 0 ? '' : 'none';
    });
  }

  Array.prototype.forEach.call(btns, function (btn) {
    btn.addEventListener('click', function () {
      var tag = btn.getAttribute('data-tag');
      setActive(btn);
      filter(tag);
    });
  });
    // 3) 展开/收起：默认折叠 4 行
  list.addEventListener('click', function (e) {
    var btn = e.target.closest('.journal-more');
    if (!btn) return;

    var item = btn.closest('.journal-item');
    if (!item) return;

    var content = item.querySelector('.journal-content');
    if (!content) return;

    var expanded = content.classList.toggle('journal-content--collapsed') === false;
    // 上面这一行逻辑：toggle 后如果 collapsed 被移除了，expanded=true

    btn.setAttribute('aria-expanded', expanded ? 'true' : 'false');
    btn.textContent = expanded ? 'Less' : 'More';
  });
})();
</script>
{% endblock %}
