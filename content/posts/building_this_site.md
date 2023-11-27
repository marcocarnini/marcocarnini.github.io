---
title: "Building a new site"
date: 2023-09-30
draft: false
series: "Creating this site"
categories: ["Blogging"]
tags: ["Hugo"]
description: "How to build a new site with Hugo."
---

This is the first post on my site, and I dedicate it to describe step by step how I created it. I use Hugo and simple Markdown — and quite a lot of command line. I am working on a testing Debian (WSL, to be specific).

## How to set up the site

To start I install ``hugo``,

```bash
sudo apt-get install hugo
hugo version	
```

The version I am using at the time of writing this is:

```bash
hugo v0.113.0+extended linux/amd64 BuildDate=2023-08-30T08:06:23Z VendorInfo=debian:0.113.0-3
```

I create a new folder for the site:

```bash
hugo new site mysite
cd mysite
```

Out of the themes, I chose [calligraphy](https://themes.gohugo.io/themes/calligraphy/).

```bash
git submodule add https://github.com/pacollins/calligraphy.git
```

I take my ``hugo.toml`` and change from the initial file configuration of the theme:

```toml
baseURL = 'http://example.org/'
languageCode = 'en-us'
title = 'My New Hugo Site'
```

```bash
cp themes/calligraphy/exampleSite/config.toml hugo.toml
```

to 

```toml
baseURL = 'marcocarnini@gmail.com'
languageCode = 'en-us'
title = 'The Data Science Explorer'
theme = 'calligraphy'
```

Create the first post (the one you are reading):

```bash
hugo new content posts/building_this_site.md
```

I got this error:

```bash
Start building sites …
hugo v0.113.0+extended linux/amd64 BuildDate=2023-08-30T08:06:23Z VendorInfo=debian:0.113.0-3
ERROR 2023/10/01 15:54:31 render of "home" failed: "/home/marco/ancora/themes/calligraphy/layouts/...
ERROR 2023/10/01 15:54:31 render of "taxonomy" failed: "/home/marco/ancora/themes/calligraphy/layouts/...
ERROR 2023/10/01 15:54:31 render of "taxonomy" failed: "/home/marco/ancora/themes/calligraphy/layouts/...
ERROR 2023/10/01 15:54:31 render of "taxonomy" failed: "/home/marco/ancora/themes/calligraphy/layouts/...
Total in 227 ms
Error: error building site: render: failed to render pages: render of "taxonomy" failed: "/home/marco/...
```

Following the [instructions I found here](https://discourse.gohugo.io/t/range-image-resize-nil-pointer-evaluating-resource-resource-resize/41535), I create and ``img`` subfolder of ``assets``; then, I downloaded the icon [from here](https://pikwizard.com/s/photo/artificial+intelligence/) an image and store it in the ``assets`` folder 

```bash
mkdir assets/img
cp fb28eae4d2a891d77a5ece755083710a.jpg assets/img/screenshot.jpg
```

While passionate about calligraphy, I think the current icon is not representative of the content I want to fill this site with. To be clear, I want to replace this icon:

![Favicon](/images/favicon.png)

with something about Machine Learning or AI. I chose a free icon about AI [from here](https://uxwing.com/artificial-intelligence-ai-chip-icon/), and [converted it into favicon](https://favicon.io/favicon-converter/). After downloading, I place the favicons in the ``static/favicon``. The final look is the following:

![Favicon](/images/favicon_after.png)

I personally find the default text width a little to narrow. I read about the comment in the first lines of ``themes/calligraphy/data/styles.toml``:

```toml
# widths
width-site = "65rem"
width-content = "70ch" # Accepts any value. The optimal line length for readibility is 50-75.
width-content-min = "50ch" # Accepts only "ch" unit.
width-aside = "35ch" # Accepts any value. The default is 1/5 of width-content.
width-aside-min = "35ch" # Accepts only "ch" unit.
```

As I want to include mostly Python code, I refer to [PEP8](https://peps.python.org/pep-0008/) and use the maximum length to wrap around (99 spaces). Thus, I change the ``styles.toml`` to be:

```toml
# widths
width-site = "65rem"
width-content = "99ch" # Accepts any value. The optimal line length for readibility is 50-75.
width-content-min = "50ch" # Accepts only "ch" unit.
width-aside = "20ch" # Accepts any value. The default is 1/5 of width-content.
width-aside-min = "35ch" # Accepts only "ch" unit.
```

After that, with

```bash
hugo server &
```

I launched the webservers that builds and serves the site locally. However, to deploy on Github Pages I follow verbatim [this guide](https://gohugo.io/hosting-and-deployment/hosting-on-github/) — I did not change either the Hugo version despite using an older one nor the branch name. Everything worked out of the box. 

