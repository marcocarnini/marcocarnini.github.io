---
title: "Adding a basic CSS to the theme"
date: 2023-10-31
draft: true
tags: ["Hugo", "CSS"]
categories: ["Blogging"]
series: "Creating a Hugo Theme"
description: "How to create a basic CSS for a Hugo theme"
math: true
---

## Setting the default fonts

I start from setting the fonts globally. I chose some sans-serif fonts:

```css
body {
    font-family: "Trebuchet MS",Arial,Roboto,sans-serif;
    width: 45rem;
    text-align: justify;
    text-justify: inter-word;
    margin: auto; /* https://blog.hubspot.com/website/center-text-in-css*/
}
```

## Highlighting the headers

For highlighting the headings, I create a blue box around the heading:

```css
h1,h2,h3 {
    background-color: blue;
    color: white;
    padding-left: 1.0rem;
}
```

## Styling the ``code`` tags

Consider the following sentence:

```html
<p>Then, I create ... in <code>euler.py</code>:</p>
```

from [the first Euler problem]({{< ref "/posts/Euler1" >}} "The first Euler problem"). I want to highlight the filename; I make it bold and red:

```css
p > code{
    font-weight: 1000;
    color: red;
    font-size: 1.1rem;
}
```

## Styling the quotes

Here, I adapt the style that [I found here](https://css-tricks.com/snippets/css/simple-and-nice-blockquote-styling/)

```css
blockquote {
    background: lightgrey;
    border-left: 0.5rem solid black;
    margin: 1.5rem 0.5rem;
    padding: 0.5rem 0.5rem;
    font-style: oblique;
}

blockquote p {
    display: inline;
}
```

## Styling the pagination

The default look of the pagination is not good:

![Pagination default style](/images/pagination.png)

The corresponding HTML code is the following:

```html
<ul class="pagination pagination-default">
    <li class="page-item disabled">
        <a aria-disabled="true" aria-label="First" class="page-link" role="button" tabindex="-1">
            <span aria-hidden="true">&laquo;&laquo;</span></a>
    </li>
    <li class="page-item disabled">
        <a aria-disabled="true" aria-label="Previous" class="page-link" role="button" tabindex="-1">
            <span aria-hidden="true">&laquo;</span></a>
    </li>
    <li class="page-item active">
        <a aria-current="page" aria-label="Page 1" class="page-link" role="button">1</a>
    </li>
    <li class="page-item">
        <a href="/page/2/" aria-label="Page 2" class="page-link" role="button">2</a>
    </li>
    <li class="page-item">
        <a href="/page/2/" aria-label="Next" class="page-link" role="button">
            <span aria-hidden="true">&raquo;</span></a>
    </li>
    <li class="page-item">
        <a href="/page/2/" aria-label="Last" class="page-link" role="button">
            <span aria-hidden="true">&raquo;&raquo;</span></a>
    </li>
</ul>
```

At first, I hide the pagination items that are disabled:

```css
li.page-item.disabled {
    display: none;
}
```

## Styling the posts

I could reorder through the CSS, but I prefer reordering by changing ``themes/bareMinimum/layouts/index.html``:

```html
{{ define "main" }}
{{ define "main" }}
<div>
    <h1 class="title">{{ .Site.Title }}</h1>
    <ul class="all-posts">
        {{ range (where .Paginator.Pages "Type" "posts")}}
        <div class="post-box">
            <div class="post_index_title">{{.Title}}</div>
            <div class="second-row">
                <div class="post_index_description">{{.Description}}</div>
                <div class="post_link"><a href="{{.Permalink}}">Read more</a></div>
            </div>
            <div class="post_index_wordcount">Words: {{.WordCount}}</div>
            <div class="post_index_date">{{time.Format "2 January 2006" .Date}}</div>
            <div class="post_index_tags">Tags: {{ with .Params.tags }}{{ delimit . ", " }}{{ end }}</div>
        </div>
    </ul>
</div>
{{ end }}
{{ template "_internal/pagination.html" . }}
{{ end }}
```

Then, I style the second row:

```css
div.second-row {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
}
```

Then, I style the post box

```css
div.post-box {
    display: rows;
    flex-direction: columns;
    background: lightgrey;
    border: 0.5rem solid white;
    padding: 0.5rem;
}
```

and then the title:

```css
div.post_index_title {
    font-weight: 900;
    font-size: 1.2rem;
    order: 1;
}
```

## Styling the navigation bar

I make the fonts larger, bold, white and not underlined

```css
a.nav-link {
    color: white;
    font-weight: 900;
    padding: 0.5rem;
    font-size: 1.6rem;
    text-decoration: none;
}
```

An I create a navigation bar completely blue:

```css
.nav {
    display: flex;
    flex-direction: rows;
    justify-content: space-between;
    background-color: blue;
}
```

## Styling the copyright note

For some pages (for exaple, the ``About`` page) the copyright is too close to the rest of the text. I add some vertical space:

```css
p.footer {
    padding-top: 4rem;
}
```

## Making date format uniform

Currently, the date for the posts is displayed in a the format ``31 October 2023``. Inside the posts, however, it is displayed in the format ``Oct 31, 2023``.
To fix the inconsistency, I change ``themes/bareMinimum/layouts/partials/metadata.html`` from:

```html
{{ $dateTime := .PublishDate.Format "2006-01-02" }}
{{ $dateFormat := .Site.Params.dateFormat | default "Jan 2, 2006" }}
<time datetime="{{ $dateTime }}">{{ .PublishDate.Format $dateFormat }}</time>
{{ with .Params.tags }}
{{ range . }}
{{ $href := print (absURL "tags/") (urlize .) }}
<a class="myposts" href="{{ $href }}">{{ . }}</a>
{{ end }}
{{ end }}
```

to

```html
{{ $dateTime := .PublishDate.Format "2006-01-02" }}
{{ $dateFormat := .Site.Params.dateFormat | default "2 Jan 2006" }}
<time datetime="{{ $dateTime }}">{{ .PublishDate.Format $dateFormat }}</time>
{{ with .Params.tags }}
{{ range . }}
{{ $href := print (absURL "tags/") (urlize .) }}
<a class="myposts" href="{{ $href }}">{{ . }}</a>
{{ end }}
{{ end }}
```

## Refactoring

At first, I notice that the headings and the navigation bar share some properties:

```css
h1,h2,h3{
    background-color: blue;
    border-radius: 0.8rem;
    color: white;
    font-weight: 900;
    padding-left: 0.5rem;
}
...
a.nav-link {
    color: white;
    font-weight: 900;
    padding: 0.5rem;
    font-size: 1.6rem;
    text-decoration: none;
}
```

I refactor to:

```css
h1,h2,h3,a.nav-link {
    color: white;
    background-color: blue;
    font-weight: 900;
}
h1,h2,h3 {
    padding-left: 0.5rem;
    border-radius: 0.8rem;
}
a.nav-link {
    padding: 0.5rem;
    font-size: 1.6rem;
    text-decoration: none;
}
```

Additionally, I extract all the colors I hard-coded. I refer to [this link](https://www.shutterstock.com/blog/10-gorgeous-color-schemes-for-websites?utm_campaign=CO%3DRoEU_LG%3DEN_BU%3DIMG_AD%3DDSA_TS%3Dlggeneric_RG%3DEUAF_AB%3DACQ_CH%3DSEM_OG%3DCONV_PB%3DGoogle&ds_cid=71700000103332475&ds_ag=FF%3DColors_AU%3DProspecting&utm_medium=cpc&ds_agid=58700008193311482&utm_source=GOOGLE&gclid=Cj0KCQiAmNeqBhD4ARIsADsYfTeA3GppG5iYZo3d7JvxZpLGiitd_wXSqIUdSdh-sGA5obYmByV131QaAmZpEALw_wcB&amp=1&gclsrc=aw.ds&kw=&ds_eid=700000001517862&gad_source=1) for the color choices (I am using scholar).

I replace

* ``blue`` 333D51
* ``red`` with D3AC2B
* ``lighgray`` with CBD0D8
* ``white`` with F4F3EA

For variable definition, I refer to [this page](https://www.w3schools.com/css/css3_variables.asp)

```css
:root {
    --first: #333D51;
    --second: #D3AC2B;
    --third: #CBD0D8;
    --forth: #F4F3EA; 
}
```

## Styling the tables

```css
th {
    background: var(--first);
    padding-right: 1rem;
    padding-left: 1rem;
    color: white;
}

td {
    background: var(--forth);
    padding-right: 1rem;
    padding-left: 1rem;
    color: black;
}

table {
    border: 0.1rem solid;
    border-color: var(--first);
}
```
## Styling plots

```css
img {
    max-width: 100%;
    border: 0.1rem solid var(--first);
    border-radius: 2rem;
    width: 45rem;
}
```