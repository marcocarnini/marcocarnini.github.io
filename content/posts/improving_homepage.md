---
title: "Improving the Homepage"
date: 2023-10-31
draft: true
tags: ["Hugo"]
categories: ["Blogging"]
series: "Creating a Hugo Theme"
description: "Improving the homepage: how to add post metadata."
math: true
---

## Showing all posts in the homepage

As a first modification, I start placing all the posts in the home page, and delete the posts page. For deleting the posts page, I change my ``hugo.toml`` from:

```toml
baseURL = 'marcocarnini.com'
languageCode = 'en-us'
title = 'Site from scratch'
theme = 'bareMinimum'

[menu]
[[menu.main]]
name = "Home"
url = "/"
weight = 1

[[menu.main]]
name = "Posts"
url = "/posts/"
weight = 2

[[menu.main]]
name = "Tags"
url = "/tags/"
weight = 3
```

to the following:

```toml
baseURL = 'marcocarnini.com'
languageCode = 'en-us'
title = 'Site from scratch'
theme = 'bareMinimum'

[menu]
[[menu.main]]
name = "Home"
url = "/"
weight = 1
[[menu.main]]
name = "Tags"
url = "/tags/"
weight = 2
```

, I change the file ``themes/bareMinimum/layouts/index.html`` from the initial file

```html
{{ define "main" }}
<div id="home-jumbotron" class="jumbotron text-center">
  <h1 class="title">{{ .Site.Title }}</h1>
</div>
{{ end }}
```

That barely contained the site title to the list of all the posts (with bullet points):

```html
{{ define "main" }}
<div>
  <h1 class="title">{{ .Site.Title }}</h1>
  <ul class="all-posts">
    {{range .Site.RegularPages}}
    <a>
      <a href="{{.Permalink}}">{{.Title}}</a>
    </a>
    {{end}}
  </ul>
</div>
{{ end }}
```

## Changing the footer

Then, I want to replace ``Copyright (c) 2023 Marco Carnini`` with the string ``© 2023 Marco Carnini``. For this, I need to modify the file ``themes/bareMinimum/layouts/partials/footer.html`` from:

```html
<p class="footer text-center">Copyright (c) {{ now.Format "2006"}} Marco Carnini</p>
```

to:

```html
<p class="footer text-center">&copy; {{ now.Format "2006"}} Marco Carnini</p>
```

After this change, the homepage looks like this:

![The new homepage: bullet list of the posts and copyright](/images/newHome.png)

## Enriching the post preview

Currently, I am only posting the title of the post, and link to it. I want to include some other details for each post; for this, I mostly referred to [the hugo page variables documentation](https://gohugo.io/variables/page/). I changed the ``themes/bareMinimum/layouts/index.html`` to be:

```html
{{ define "main" }}
<div>
  <h1 class="title">{{ .Site.Title }}</h1>
  <ul class="all-posts">
    {{range .Site.RegularPages}}
    <div>
      <div class="post_index_title">{{.Title}}</div>
      <div class="post_index_date">{{.Date}}</div>
      <div class="post_index_description">{{.Description}}</div>
      <div class="post_index_wordcount">Words: {{.FuzzyWordCount}}</div>
      <div class="post_index_tags">Tags: {{.Keywords}}</div>
      <div class="post_link"><a href="{{.Permalink}}">Read more</a></div>
    </div>
    {{end}}
  </ul>
</div>
{{ end }}
```

The result in the page is the following:

![The new page with more metadata](/images/index_v02.png)

I decided to replace the ``FuzzyWordCount`` with the actual ``WordCount`` for avoiding rounding the number of words in the post. Additionally, the ``Keywords`` is not displacing the tagsas I assumed. Thus, I replace the ``index.html`` with:

```html
{{ define "main" }}
<div>
  <h1 class="title">{{ .Site.Title }}</h1>
  <ul class="all-posts">
    {{range .Site.RegularPages}}
    <div>
      <div class="post_index_title">{{.Title}}</div>
      <div class="post_index_date">{{.Date}}</div>
      <div class="post_index_description">{{.Description}}</div>
      <div class="post_index_wordcount">Words: {{.WordCount}}</div>
      <div class="post_index_tags">Tags: {{ with .Params.tags }}{{ delimit . ", " }}{{ end }}</div>
      <div class="post_link"><a href="{{.Permalink}}">Read more</a></div>
    </div>
    {{end}}
  </ul>
</div>
{{ end }}
``` 

As I do not see any reason for being so precise with the publication date, I edit *the content* of the posts to be only consider the date. Additionally, I add tags, categories and series to each post; finally, I add an excerpt for the preview on the home page. I edited the preamble of the posts:

```html
---
title: "Creating a Theme from Scratch"
date: 2023-10-29
draft: false
tags: ["Hugo"]
categories: ["Blogging"]
series: "Creating a Theme from Scratch"
description: "How to start creating a Hugo theme from zero."
---
```

```html
---
title: "Improving the Homepage"
date: 2023-10-31
draft: false
tags: ["Hugo"]
categories: ["Blogging"]
series: "Creating a Hugo Theme"
description: "Improving the homepage: how to add post metadata."
---
```

obtaining:

![Homepage with post metadata included](/images/index_v03.png)

## Adding taxonomies

To organize the articles in different cateogories and series, and to use the tags, I create the corresponding taxonomies:

```toml
baseURL = 'marcocarnini.com'
languageCode = 'en-us'
title = 'Site from scratch'
theme = 'bareMinimum'

[menu]
[[menu.main]]
name = "Home"
url = "/"
weight = 1

[[menu.main]]
identifier = "about"
name = "About"
url = "/about/"
weight = 10

[[menu.main]]
identifier = "series"
name = "Series"
url = "/series/"
weight = 20

[[menu.main]]
identifier = "tags"
name = "Tags"
url = "/tags/"
weight = 25

[[menu.main]]
identifier = "categories"
name = "Categories"
url = "/categories/"
weight = 30

[[menu.main]]
identifier = "contact"
name = "Contact"
url = "/contact/"
weight = 35

[taxonomies]
series = 'series'
tags = 'tags'
```

## Not displaying in the homepage links to non-posts

With the loop in the ``themes/bareMinimum/layouts/index.html`` I am iterating over all the Markdown pages; however, I want to exclude from being displayed the ``contact.md`` and the ``about.md`` pages. Currently, they are displayed in this way:

![Homepage displaying also the contact and the about page](/images/link_to_about.png)

Following the [Stackoverflow post](https://stackoverflow.com/questions/65746158/loop-over-posts-in-index-html), I exclude those two pages from being displayed in the homepage. In short, i replace in ``themes/bareMinimum/layouts/index.html`` the following line:

```html
{{range .Site.RegularPages}}
```

with

```html
{{ range  ( where .Site.RegularPages "Type" "posts" ) }}
```

That is, I restricted myself to the pages in the ``content/posts`` folder.

## Changing the Format of the date

While before the date was shown as ``2023-10-31 00:00:00+0000 UTC``, I wnat to style it differently. Following the [hugo documentation](https://gohugo.io/functions/time/format/), I changed the ``themes/bareMinimum/layout/index.html`` row about date from:

```html
<div class="post_index_date">{{.Date}}</div>
```

to 

```html
<div class="post_index_date">{{time.Format "2 January 2006" .Date}}</div>
```

with the new format being like ``2 January 2006``.

## Including the LaTeX support

I wrote about including LaTeX formula in Markdown [somewhere else]({{< ref "adding_latex_capabilities" >}}); without proper configuration, the LaTeX would not be rendered properly:

```html
Thus, the sum of all the multiples of 3 smaller than \(N\) is:

$$S_3=\sum_{i=1}^{i_\text{max}}3i$$

Here, the \(i_\text{max}\) means that I have to limit the possible values of \(i\) to those that satisfy the condition \(3i<N\). That is,

$$i_\text{max} = \left \lfloor \frac{N-1}{3} \right \rfloor$$

where \(\lfloor \cdot \rfloor\) is the floor function. The same reasoning applies to

$$S_5=\sum_{j=1}^{j_\text{max}}5j$$ $$j_\text{max} = \left \lfloor \frac{N-1}{5} \right \rfloor$$

$$S_{15}=\sum_{k=1}^{k_\text{max}}15k$$ $$i_\text{max} = \left \lfloor \frac{N-1}{15} \right \rfloor$$

Thus, the quantity I want to measure is:

$$S=S_3+S_5-S_{15}=\sum_{i=1}^{i_\text{max}}3i + \sum_{j=1}^{j_\text{max}}5j-\sum_{k=1}^{k_\text{max}}15k$$

Here, I subtract $$S_{15}$$ because by summing the multiples of 3 and those of 5 separately, I would count twice the multiples of 15. Simplifying the expression above:

$$S=3\sum_{i=1}^{i_\text{max}}i + 5\sum_{j=1}^{j_\text{max}}j-15\sum_{k=1}^{k_\text{max}}k$$

Since the sum of the first \(M\) numbers is

$$\sum_{l}^M l=\frac{M(M+1)}{2}$$

Thus, the formula for \(S\) can be rewritten as:

$$S=3\frac{i_\text{max}(i_\text{max}+1)}{2}+5\frac{j_\text{max}(j_\text{max}+1)}{2}-15\frac{k_\text{max}(k_\text{max}+1)}{2}$$
```
At first, I create a folder for the helper functions:

```bash
cd themes/bareMinimum/layouts/partials
mkdir helpers
```

and I save in the ``themes/bareMinimum/layouts/partials/helpers/katex.html`` the following file:

```html
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.css">
<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.js"></script>

<script defer src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/contrib/auto-render.min.js" onload="renderMathInElement(document.body);"></script>
```

Finally, I update the ``themes/bareMinimum/layouts/partials/head.html`` to be:

```html
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" type="text/css" href="/css/style.css">
  {{ $title := print .Site.Title " | " .Title }}
  {{ if .IsHome }}{{ $title = .Site.Title }}{{ end }}
  <title>{{ $title }}</title>
  {{ if .Params.math }}{{ partial "helpers/katex.html" . }}{{ end }}
</head>
```

I change the header for this post to include the use of LaTeX inside the page:

```toml
---
title: "Improving the Homepage"
date: 2023-10-31
draft: false
tags: ["Hugo"]
categories: ["Blogging"]
series: "Creating a Hugo Theme"
description: "Improving the homepage: how to add post metadata."
---
```

This way, the math is rendered:

$$S_5=\sum_{j=1}^{j_\text{max}}5j$$ $$j_\text{max} = \left \lfloor \frac{N-1}{5} \right \rfloor$$

$$S_{15}=\sum_{k=1}^{k_\text{max}}15k$$ $$i_\text{max} = \left \lfloor \frac{N-1}{15} \right \rfloor$$

## Show the articles in the taxonomy page

Currently, I have the following layout for a taxonomy page (here, the series one):

![Starting layout for a taxonomy page](/images/first_taxonomy.png)

I want to remove the unitialized date, and display the posts belonging to an item in the taxonomy. In this case, I want to display the posts belonging to a given series. I modify the current ``themes/bareMinimum/layouts/_default/list.html`` from:

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

to:

```html
{{ define "main" }}
<h1>{{ .Title }}</h1>
{{ range .Pages.ByPublishDate.Reverse }}
<p>
  <h3><a class="title" href="{{ .RelPermalink }}">{{ .Title }}</a></h3>
</p>
{{ end }}
{{ end }}
```

This removed the unitialized date. To display a list of posts for each series, instead I iterate over the terms of the taxonomy, and then over all the posts associated to that term. Thus, I update the ``themes/bareMinimum/layouts/_default/list.html``
to be:

```html
{{ define "main" }}
<h1>{{ .Title }}</h1>
{{ range .Pages.ByPublishDate.Reverse }}
<h2><a class="taxonomy-title">{{ .Title }}</a></h2>
<ul>
  {{ range .Pages.ByPublishDate.Reverse }}
  <li><a class="taxonomy-post" href="{{ .RelPermalink }}">{{ .Title }}</a></li>
  {{ end }}
</ul>
{{ end }}
{{ end }}
```

## Adding pagination

At first, I simply add pagination to ``themes/bareMinimum/layouts/index.html`` following [this guide](https://glennmccomb.com/articles/how-to-build-custom-hugo-pagination/):

```html
{{ define "main" }}
{{ define "main" }}
<div>
  <h1 class="title">{{ .Site.Title }}</h1>
  <ul class="all-posts">
    {{ range (where .Paginator.Pages "Type" "posts")}}
    <div class="post-box">
      <div class="post_index_title">{{.Title}}</div>
      <div class="post_index_date">{{time.Format "2 January 2006" .Date}}</div>
      <div class="post_index_description">{{.Description}}</div>
      <div class="post_index_wordcount">Words: {{.WordCount}}</div>
      <div class="post_index_tags">Tags: {{ with .Params.tags }}{{ delimit . ", " }}{{ end }}</div>
      <div class="post_link"><a href="{{.Permalink}}">Read more</a></div>
    </div>
  </ul>
</div>
{{ end }}
{{ template "_internal/pagination.html" . }}
{{ end }}
```
Then, I add the limit of page to be displayed in the ``hugo.toml`` file:

```toml
...
paginate = 4
...
```
I modify analogously the ``themes/bareMinimum/layouts/_default/list.html``:

```html
{{ define "main" }}
<h1>{{ .Title }}</h1>
{{ range .Paginator.Pages.ByPublishDate.Reverse }}
<h2><a class="taxonomy-title">{{ .Title }}</a></h2>
<ul>
  {{ range .Pages.ByPublishDate.Reverse }}
  <li><a class="taxonomy-post" href="{{ .RelPermalink }}">{{ .Title }}</a></li>
  {{ end }}
</ul>
{{ end }}
{{ template "_internal/pagination.html" . }}
{{ end }}
```
