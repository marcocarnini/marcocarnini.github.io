---
title: "Adding Taxonomies"
date: 2023-10-10
draft: true
series: "Creating this site"
categories: ["Blogging"]
tags: ["Hugo"]
description: "Adding taxonomies to a site: categories, series and tags."
---

I discovered Hugo when reviewing [*Hugo in Action*](https://www.manning.com/books/hugo-in-action) from [Manning](https://www.manning.com/). But I understood the potential of the tool only when looking for a theme for a new site — and then discoveries the different taxonomies that were normally supported. 

For this site, I discovered that

* Series of posts are supported,
* Tags, and
* Categories

I wanted to use all of them, thus I started by including in all the posts a different incipit. For this post, for example, I add the category ``Blogging`` and the tag ``Hugo``.

```bash
---
title: "Adding Taxonomies"
date: 2023-10-10
draft: false
series: "Creating this site"
categories: ["Blogging"]
tags: ["Hugo"]
---

```

Additionally, I need to change my ``hugo.toml`` file to include not only the ``About`` tab, but also:

```toml
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
```
