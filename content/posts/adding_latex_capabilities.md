---
title: "Adding LaTeX Capabilities"
date: 2023-10-02
draft: false
math: true
series: "Creating this site"
categories: ["Blogging"]
tags: ["Hugo", "LaTeX"]
description: "Adding support for LaTeX equations"
---

I find very complicated to write about Data Science without using mathematical formulas. That is why I think that the Medium editor is very unconvenient for scientific writing. While obviously there are many pubblications on Data Science, the articles turns to be quite shallow in term of details. I love and daily read from [Towards Data Science](https://towardsdatascience.com/) and [MLearning.ai](https://medium.com/mlearning-ai); however, there is an obvious restraint from writing too much Math-dense articles.

If adding formulas were trivial, you will not find so many posts about adding mathematical formula on Medium:

* [How to Embed Math Equations on Medium using Embed.fun](https://medium.com/embeds/embed-math-equations-on-medium-using-embed-fun-5a1652696757)
* [Writing Math (LaTeX) Formulas in Medium](https://matteocapitani.medium.com/writing-math-latex-formulas-in-medium-4987a2be60d6)
* [How to write mathematics on Medium](https://medium.com/@tylerneylon/how-to-write-mathematics-on-medium-f89aa45c42a0)
* [How to Embed Beautiful Math equations in Medium](https://medium.com/@kiranachyutuni/how-to-embed-beautiful-math-equations-in-medium-a041a64dd4e3)

Imagine you want to write a tutorial on training a Decision Tree. Going through a lengthy process for each formula you insert. You will sacrifice the completeness of the explanation in favor of saving some effort. Adding this feature should not be that complicated, as any decent Markdown editor nowadays incorporate it. The fact that after many years Medium does not include it in the standard editor is a sign that either Mathematical writing is just a small niche for Medium, or that there is no effort in improving the editor.

On the other hand, for someone used to write in LaTeX since a long time (since the first semester at University), I would rather export directly from a Jupyter notebook without too much editing rather than having a little monetization for my posts. The procedure to include Mathematical formula with Hugo is quite straightforward.

## LaTeX

As I want to include LaTeX mathematical formulas, like:

```latex
I = \int_0^\infty \mathrm{d}x \mathrm{e}^{-x^2}
```

it is not added. I follow [this guide](https://mertbakir.gitlab.io/hugo/math-typesetting-in-hugo/). I start by copying all the folders and files from the theme ``layouts`` to the corresponding folder:

```bash
cp  -r ../../../themes/calligraphy/layouts/* layouts/
```

I created ``layouts/partials/helpers/katex.html`` as in the guide, and I added in the ``layouts/partials/site/header.html``:

```html
{{ if .Params.math }}{{ partial "helpers/katex.html" . }}{{ end }}
```

Then, I modify my post header from:

```markdown
---
title: "Building a new site"
date: 2023-09-30
draft: false
---
```

to the version of this post:

```markdown
---
title: "Building a new site"
date: 2023-09-30
draft: false
math: true
---
```

$$I = \int_0^\infty \mathrm{d}x \mathrm{e}^{-x^2}$$

The support of LaTeX command is quite good: I can also use ``cases``:

```latex
f(x)=\begin{cases}x & \text{if }x>0\\\\0 & \text{if } x\leq 0\end{cases}
```

and it is correctly rendered:

$$f(x)=\begin{cases}x & \text{if }x>0\\\\0 & \text{if } x\leq 0\end{cases}$$

I commonly use ``underbrace``:

```latex
I = \int_0^{2\pi} \underbrace{2\sin x \cos x}_{\sin 2x}\text{d}x
```

$$I = \int_0^{2\pi} \underbrace{2\sin x \cos x}_{\sin 2x}\text{d}x$$

I like to use ``cancel``:

```latex
14-4-5-6-10=\cancel{14}-\cancel{4}-5-6-\cancel{10}
```

$$14-4-5-6-10=\cancel{14}-\cancel{4}-5-6-\cancel{10}$$

Finally, I can insert inline math with the following syntax:

```latex
\\(k \in \mathbb{K}\\)
```
That is rendered inline like \\(k \in \mathbb{K}\\) (notice that *I need to escape the backslash*).
