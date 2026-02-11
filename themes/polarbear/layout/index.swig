{% extends "_layout.swig" %}
{% import '_macro/post.swig' as post_template %}

{% block title %} {{ config.title }} - {{ config.description }}{% endblock %}

{% block content %}
    <div id="primary" class="home">
        {% for post in page.posts %}

            {# 判断是否 journal #}
            {% set is_journal = false %}
            {% if post.categories %}
                {% for c in post.categories.toArray() %}
                    {% if c.name == 'journal' %}
                        {% set is_journal = true %}
                    {% endif %}
                {% endfor %}
            {% endif %}

            {# 不是 journal 才渲染到首页 #}
            {% if not is_journal %}
                {{ post_template.render(post) }}
            {% endif %}

        {% endfor %}
        {% include "_partial/pagination.swig" %}
    </div>
    {% include "_partial/widget.swig" %}
{% endblock %}