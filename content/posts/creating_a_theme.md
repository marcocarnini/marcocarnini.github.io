---
title: "Creating a Theme from Scratch"
date: 2023-10-29
draft: false
tags: ["Hugo", "HTML"]
categories: ["Blogging"]
series: "Creating a Hugo Theme"
description: "How to start creating a Hugo theme from zero."
---

While I like many themes from [the corresponding hugo page](https://themes.gohugo.io/), with this post I start creating a new theme for my own site, with the goal to explore and use some CSS (and Markdown/Hugo, of course). For simplcity, I start from a completely new site with ``hugo``:

```bash
hugo new site from_scratch
```

The folder ``themes`` is empty. Normally, I would clone an existing theme, and start configuring. In this example, however, I want to work step by step. For reference, I follow [this guide](https://retrolog.io/blog/creating-a-hugo-theme-from-scratch/). I create a completely new theme, and I call it ``bareMinimum``:

```bash
hugo new theme bareMinimum
```

This lead to the following structure for the folder ``themes/bareMinimum``:

```bash
bareMinimum/
├── archetypes
│   └── default.md
├── hugo.toml
├── layouts
│   ├── 404.html
│   ├── _default
│   │   ├── baseof.html
│   │   ├── list.html
│   │   └── single.html
│   ├── index.html
│   └── partials
│       ├── footer.html
│       ├── header.html
│       └── head.html
├── LICENSE
├── static
│   ├── css
│   └── js
└── theme.toml
```

Then, I create a new post:

```bash
hugo new content posts/creating_a_theme.md
```

and edit the ``hugo.toml`` file:

```toml
baseURL = "/"
languageCode = "en-us"
title = "Site from scratch"
theme = "bareMinimum"
```

I build my site:

```bash
hugo
```

obtaining (I cut the output to the first columns for clarity):

```
Start building sites …
hugo v0.113.0+extended linux/amd64 BuildDate=2023-08-30T08:06:23Z VendorInfo=debian:0.113.0-3
WARN 2023/10/29 11:25:09 found no layout file for "html" for kind "home": You should create a...
WARN 2023/10/29 11:25:09 found no layout file for "html" for kind "taxonomy": You should create a...
WARN 2023/10/29 11:25:09 found no layout file for "html" for kind "taxonomy": You should create a...

                   | EN
-------------------+-----
  Pages            |  3
  Paginator pages  |  0
  Non-page files   |  0
  Static files     |  0
  Processed images |  0
  Aliases          |  0
  Sitemaps         |  1
  Cleaned          |  0

Total in 23 ms
```

So, no *errors*, but some important warning. In the next session, I am going to fix them.

## Creating the partials

I keep following [retrolog.io guide](https://retrolog.io/blog/creating-a-hugo-theme-from-scratch/), but I choose not to include ``bootstrap``. I first create my ``themes/bareMinimum/layouts/partials/head.html``:

```html
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" type="text/css" href="/css/style.css">
    {{ $title := print .Site.Title " | " .Title }}
    {{ if .IsHome }}{{ $title = .Site.Title }}{{ end }}
    <title>{{ $title }}</title>
</head>
```
which is (quoting retrolog.io):

> This will be the place for metadata like the document title, character set, styles, scripts, and other meta information

Then, I create ``themes/bareMinimum/layouts/partials/header.html``:

```html
<div id="nav-border" class="container">
    <nav id="nav" class="nav justify-content-center">
        {{ range .Site.Menus.main }}
        <a class="nav-link" href="{{ .URL }}">
        {{ if .Pre }}
        {{ $icon := printf "<i data-feather=\"%s\"></i> " .Pre | safeHTML }}
        {{ $icon }}
        {{ end }}
        {{ $text := print .Name | safeHTML }}
        {{ $text }}
        </a>
        {{ end }}
    </nav>
</div>
```

that represent the beginning of each page in the site, and a footer ``themes/bareMinimum/layouts/partials/footer.html``:

```html
<p class="footer text-center">Copyright (c) {{ now.Format "2006"}} Marco Carnini</p>
```
This is the bottom of each page, adding the copyright information.

## Default layouts

As a first step, I create a minimalistic layout for my homepage (``themes/bareMinimum/layouts/index.html``):

```html
{{ define "main" }}
<div>
  <h1 class="title">{{ .Site.Title }}</h1>
</div>
{{ end }}
```

I keep the ``themes/bareMinimum/layouts/_default/baseof.html`` as the initial, default value:

```html
<!DOCTYPE html>
<html>
    {{- partial "head.html" . -}}
    <body>
        {{- partial "header.html" . -}}
        <div id="content">
        {{- block "main" . }}{{- end }}
        </div>
        {{- partial "footer.html" . -}}
    </body>
</html>
```

For ``themes/bareMinimum/layouts/_default/list.html``, I consider the following:

```html
{{ define "main" }}
<h1>{{ .Title }}</h1>
{{ range .Pages.ByPublishDate.Reverse }}
<p>
    <h3><a class="title" href="{{ .RelPermalink }}">{{ .Title }}</a></h3>
    {{ partial "metadata.html" . }}
    <a class="summary" href="{{ .RelPermalink }}">
        <p>{{ .Summary }}</p>
    </a>
</p>
{{ end }}
{{ end }}
```

and for ``themes/bareMinimum/layouts/_default/single.html``:

```html
{{ define "main" }}
<h1>{{ .Title }}</h1>
{{ partial "metadata.html" . }}
<br><br>
{{ .Content }}
{{ end }}
```

## The site

The look and feel of the site is not eye-catching. The home page look like this:

![Home Page — Version 0.1](/images/home01.png)

The page with the list of all posts look like this:

![Posts Page — Version 0.1](/images/Posts01.png)

A single post, instead look like this:

![Post — Version 0.1](/images/Content01.png)

Of course, some customization some styling are needed to improve: thus, I need to create a CSS for my theme.

