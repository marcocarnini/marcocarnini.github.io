---
title: "Adding Plots to a Post"
date: 2023-10-09
draft: true
series: "Creating this site"
categories: ["Blogging"]
tags: ["Hugo", "Python", "Matplotlib"]
description: "Adding plots and images to a post."
---

One of the main requirements in order to publish Jupyter notebooks is to be able to attach images to the posts. In this post, I focus on how to attach images, and in finding a standard for the images (like fonts, background and style).

## Attaching an image

In order to attach an image to a post, I follow [this guide](https://stackoverflow.com/questions/71501256/how-to-insert-an-image-in-my-post-on-hugo). I create a folder for the images under the ``static`` folder:

```bash
mkdir static/images
```

I will store the images in this folder, and include them using the syntax:

```markdown
![](/images/image.png)
```

## On a fresh Ubuntu image on WSL

At first, I create a small dataset for creating an example plot:

```python
import pandas as pd
import matplotlib.pyplot as plt


df = pd.DataFrame(
    {
        "A": [1, 5, 7, 3, 4, 0],
        "B": [9, 4, 5, 6, 1, 0],
    }
)


plt.rcParams["font.size"] = 16
plt.figure(figsize=(16, 9))
plt.xlabel("Abscissa")
plt.ylabel("Ordinates")
plt.title("My title")
plt.scatter(df["A"], df["B"], s=100)
plt.grid()
plt.savefig("plot_example.png", dpi=300)
```
    
![First Example Plot](/images/plot_example.png)

I know, this is boring. It is just that I do not dare to consider as a reference style the following:

```python
with plt.xkcd():
    plt.rcParams["font.size"] = 16
    plt.figure(figsize=(16, 9))
    plt.xlabel("Abscissa")
    plt.ylabel("Ordinates")
    plt.title("My title")
    plt.scatter(df["A"], df["B"], s=100)
    plt.grid()
    plt.savefig("plot_example_xkcd.png", dpi=300)
```

    findfont: Font family 'xkcd' not found.
    findfont: Font family 'xkcd Script' not found.
    findfont: Font family 'Humor Sans' not found.
    
![First Attempt with xkcs style — Missing Fonts](/images/plot_example_xkcd.png)

As I got error:
    
```bash
findfont: Font family 'xkcd' not found.
```

I found on [Stack overflow](https://stackoverflow.com/questions/8753835/how-to-get-a-list-of-all-the-fonts-currently-available-for-matplotlib) how to get the list of available fonts: 

```python
import matplotlib.font_manager
from IPython.core.display import HTML


def make_html(fontname):
    return "<p>{font}: <span style='font-family:{font}; font-size: 24px;'>{font}</p>".format(
        font=fontname
    )


code = "\n".join(
    [
        make_html(font)
        for font in sorted(
            set([f.name for f in matplotlib.font_manager.fontManager.ttflist])
        )
    ]
)
HTML("<div style='column-count: 2;'>{}</div>".format(code))
```

Resulting in the following result:

<div style='column-count: 2;'><p>DejaVu Sans: <span style='font-family:DejaVu Sans; font-size: 24px;'>DejaVu Sans</p>
<p>DejaVu Sans Display: <span style='font-family:DejaVu Sans Display; font-size: 24px;'>DejaVu Sans Display</p>
<p>DejaVu Sans Mono: <span style='font-family:DejaVu Sans Mono; font-size: 24px;'>DejaVu Sans Mono</p>
<p>DejaVu Serif: <span style='font-family:DejaVu Serif; font-size: 24px;'>DejaVu Serif</p>
<p>DejaVu Serif Display: <span style='font-family:DejaVu Serif Display; font-size: 24px;'>DejaVu Serif Display</p>
<p>STIXGeneral: <span style='font-family:STIXGeneral; font-size: 24px;'>STIXGeneral</p>
<p>STIXNonUnicode: <span style='font-family:STIXNonUnicode; font-size: 24px;'>STIXNonUnicode</p>
<p>STIXSizeFiveSym: <span style='font-family:STIXSizeFiveSym; font-size: 24px;'>STIXSizeFiveSym</p>
<p>STIXSizeFourSym: <span style='font-family:STIXSizeFourSym; font-size: 24px;'>STIXSizeFourSym</p>
<p>STIXSizeOneSym: <span style='font-family:STIXSizeOneSym; font-size: 24px;'>STIXSizeOneSym</p>
<p>STIXSizeThreeSym: <span style='font-family:STIXSizeThreeSym; font-size: 24px;'>STIXSizeThreeSym</p>
<p>STIXSizeTwoSym: <span style='font-family:STIXSizeTwoSym; font-size: 24px;'>STIXSizeTwoSym</p>
<p>Ubuntu: <span style='font-family:Ubuntu; font-size: 24px;'>Ubuntu</p>
<p>Ubuntu Condensed: <span style='font-family:Ubuntu Condensed; font-size: 24px;'>Ubuntu Condensed</p>
<p>Ubuntu Mono: <span style='font-family:Ubuntu Mono; font-size: 24px;'>Ubuntu Mono</p>
<p>cmb10: <span style='font-family:cmb10; font-size: 24px;'>cmb10</p>
<p>cmex10: <span style='font-family:cmex10; font-size: 24px;'>cmex10</p>
<p>cmmi10: <span style='font-family:cmmi10; font-size: 24px;'>cmmi10</p>
<p>cmr10: <span style='font-family:cmr10; font-size: 24px;'>cmr10</p>
<p>cmss10: <span style='font-family:cmss10; font-size: 24px;'>cmss10</p>
<p>cmsy10: <span style='font-family:cmsy10; font-size: 24px;'>cmsy10</p>
<p>cmtt10: <span style='font-family:cmtt10; font-size: 24px;'>cmtt10</p></div>

I follow the following [Stackoverflow post](https://stackoverflow.com/questions/39614381/how-to-get-xkcd-font-working-in-matplotlib) to install the ``fonts-humor-sans`` fonts together with ``roboto``:

```bash
sudo apt-get install fonts-humor-sans
sudo apt-get install fonts-roboto
```
Then, I delete the ``matplotlib`` cache:

```bash
rm -r ~/.cache/matplotlib
```

I restart my Jupyter notebook, and check against the newly available fonts. On a Debian Machine, I got the following lines (notice the presence of the new fonts):

```python
code = "\n".join(
    [
        make_html(font)
        for font in sorted(
            set([f.name for f in matplotlib.font_manager.fontManager.ttflist])
        )
    ]
)
HTML("<div style='column-count: 2;'>{}</div>".format(code))
```




<div style='column-count: 2;'><p>C059: <span style='font-family:C059; font-size: 24px;'>C059</p>
<p>D050000L: <span style='font-family:D050000L; font-size: 24px;'>D050000L</p>
<p>DejaVu Math TeX Gyre: <span style='font-family:DejaVu Math TeX Gyre; font-size: 24px;'>DejaVu Math TeX Gyre</p>
<p>DejaVu Sans: <span style='font-family:DejaVu Sans; font-size: 24px;'>DejaVu Sans</p>
<p>DejaVu Sans Display: <span style='font-family:DejaVu Sans Display; font-size: 24px;'>DejaVu Sans Display</p>
<p>DejaVu Sans Mono: <span style='font-family:DejaVu Sans Mono; font-size: 24px;'>DejaVu Sans Mono</p>
<p>DejaVu Serif: <span style='font-family:DejaVu Serif; font-size: 24px;'>DejaVu Serif</p>
<p>DejaVu Serif Display: <span style='font-family:DejaVu Serif Display; font-size: 24px;'>DejaVu Serif Display</p>
<p>Droid Sans Fallback: <span style='font-family:Droid Sans Fallback; font-size: 24px;'>Droid Sans Fallback</p>
<p>FontAwesome: <span style='font-family:FontAwesome; font-size: 24px;'>FontAwesome</p>
<p>Humor Sans: <span style='font-family:Humor Sans; font-size: 24px;'>Humor Sans</p>
<p>Latin Modern Math: <span style='font-family:Latin Modern Math; font-size: 24px;'>Latin Modern Math</p>
<p>Latin Modern Mono: <span style='font-family:Latin Modern Mono; font-size: 24px;'>Latin Modern Mono</p>
<p>Latin Modern Mono Caps: <span style='font-family:Latin Modern Mono Caps; font-size: 24px;'>Latin Modern Mono Caps</p>
<p>Latin Modern Mono Light: <span style='font-family:Latin Modern Mono Light; font-size: 24px;'>Latin Modern Mono Light</p>
<p>Latin Modern Mono Light Cond: <span style='font-family:Latin Modern Mono Light Cond; font-size: 24px;'>Latin Modern Mono Light Cond</p>
<p>Latin Modern Mono Prop: <span style='font-family:Latin Modern Mono Prop; font-size: 24px;'>Latin Modern Mono Prop</p>
<p>Latin Modern Mono Prop Light: <span style='font-family:Latin Modern Mono Prop Light; font-size: 24px;'>Latin Modern Mono Prop Light</p>
<p>Latin Modern Mono Slanted: <span style='font-family:Latin Modern Mono Slanted; font-size: 24px;'>Latin Modern Mono Slanted</p>
<p>Latin Modern Roman: <span style='font-family:Latin Modern Roman; font-size: 24px;'>Latin Modern Roman</p>
<p>Latin Modern Roman Caps: <span style='font-family:Latin Modern Roman Caps; font-size: 24px;'>Latin Modern Roman Caps</p>
<p>Latin Modern Roman Demi: <span style='font-family:Latin Modern Roman Demi; font-size: 24px;'>Latin Modern Roman Demi</p>
<p>Latin Modern Roman Dunhill: <span style='font-family:Latin Modern Roman Dunhill; font-size: 24px;'>Latin Modern Roman Dunhill</p>
<p>Latin Modern Roman Slanted: <span style='font-family:Latin Modern Roman Slanted; font-size: 24px;'>Latin Modern Roman Slanted</p>
<p>Latin Modern Roman Unslanted: <span style='font-family:Latin Modern Roman Unslanted; font-size: 24px;'>Latin Modern Roman Unslanted</p>
<p>Latin Modern Sans: <span style='font-family:Latin Modern Sans; font-size: 24px;'>Latin Modern Sans</p>
<p>Latin Modern Sans Demi Cond: <span style='font-family:Latin Modern Sans Demi Cond; font-size: 24px;'>Latin Modern Sans Demi Cond</p>
<p>Latin Modern Sans Quotation: <span style='font-family:Latin Modern Sans Quotation; font-size: 24px;'>Latin Modern Sans Quotation</p>
<p>Lato: <span style='font-family:Lato; font-size: 24px;'>Lato</p>
<p>MathJax_AMS: <span style='font-family:MathJax_AMS; font-size: 24px;'>MathJax_AMS</p>
<p>MathJax_Caligraphic: <span style='font-family:MathJax_Caligraphic; font-size: 24px;'>MathJax_Caligraphic</p>
<p>MathJax_Fraktur: <span style='font-family:MathJax_Fraktur; font-size: 24px;'>MathJax_Fraktur</p>
<p>MathJax_Main: <span style='font-family:MathJax_Main; font-size: 24px;'>MathJax_Main</p>
<p>MathJax_Math: <span style='font-family:MathJax_Math; font-size: 24px;'>MathJax_Math</p>
<p>MathJax_SansSerif: <span style='font-family:MathJax_SansSerif; font-size: 24px;'>MathJax_SansSerif</p>
<p>MathJax_Script: <span style='font-family:MathJax_Script; font-size: 24px;'>MathJax_Script</p>
<p>MathJax_Size1: <span style='font-family:MathJax_Size1; font-size: 24px;'>MathJax_Size1</p>
<p>MathJax_Size2: <span style='font-family:MathJax_Size2; font-size: 24px;'>MathJax_Size2</p>
<p>MathJax_Size3: <span style='font-family:MathJax_Size3; font-size: 24px;'>MathJax_Size3</p>
<p>MathJax_Size4: <span style='font-family:MathJax_Size4; font-size: 24px;'>MathJax_Size4</p>
<p>MathJax_Typewriter: <span style='font-family:MathJax_Typewriter; font-size: 24px;'>MathJax_Typewriter</p>
<p>MathJax_Vector: <span style='font-family:MathJax_Vector; font-size: 24px;'>MathJax_Vector</p>
<p>MathJax_Vector-Bold: <span style='font-family:MathJax_Vector-Bold; font-size: 24px;'>MathJax_Vector-Bold</p>
<p>MathJax_WinChrome: <span style='font-family:MathJax_WinChrome; font-size: 24px;'>MathJax_WinChrome</p>
<p>MathJax_WinIE6: <span style='font-family:MathJax_WinIE6; font-size: 24px;'>MathJax_WinIE6</p>
<p>Nimbus Mono PS: <span style='font-family:Nimbus Mono PS; font-size: 24px;'>Nimbus Mono PS</p>
<p>Nimbus Roman: <span style='font-family:Nimbus Roman; font-size: 24px;'>Nimbus Roman</p>
<p>Nimbus Sans: <span style='font-family:Nimbus Sans; font-size: 24px;'>Nimbus Sans</p>
<p>Nimbus Sans Narrow: <span style='font-family:Nimbus Sans Narrow; font-size: 24px;'>Nimbus Sans Narrow</p>
<p>Noto Mono: <span style='font-family:Noto Mono; font-size: 24px;'>Noto Mono</p>
<p>Noto Sans Mono: <span style='font-family:Noto Sans Mono; font-size: 24px;'>Noto Sans Mono</p>
<p>P052: <span style='font-family:P052; font-size: 24px;'>P052</p>
<p>Roboto: <span style='font-family:Roboto; font-size: 24px;'>Roboto</p>
<p>Roboto Condensed: <span style='font-family:Roboto Condensed; font-size: 24px;'>Roboto Condensed</p>
<p>STIXGeneral: <span style='font-family:STIXGeneral; font-size: 24px;'>STIXGeneral</p>
<p>STIXNonUnicode: <span style='font-family:STIXNonUnicode; font-size: 24px;'>STIXNonUnicode</p>
<p>STIXSizeFiveSym: <span style='font-family:STIXSizeFiveSym; font-size: 24px;'>STIXSizeFiveSym</p>
<p>STIXSizeFourSym: <span style='font-family:STIXSizeFourSym; font-size: 24px;'>STIXSizeFourSym</p>
<p>STIXSizeOneSym: <span style='font-family:STIXSizeOneSym; font-size: 24px;'>STIXSizeOneSym</p>
<p>STIXSizeThreeSym: <span style='font-family:STIXSizeThreeSym; font-size: 24px;'>STIXSizeThreeSym</p>
<p>STIXSizeTwoSym: <span style='font-family:STIXSizeTwoSym; font-size: 24px;'>STIXSizeTwoSym</p>
<p>Standard Symbols PS: <span style='font-family:Standard Symbols PS; font-size: 24px;'>Standard Symbols PS</p>
<p>TeX Gyre Adventor: <span style='font-family:TeX Gyre Adventor; font-size: 24px;'>TeX Gyre Adventor</p>
<p>TeX Gyre Bonum: <span style='font-family:TeX Gyre Bonum; font-size: 24px;'>TeX Gyre Bonum</p>
<p>TeX Gyre Chorus: <span style='font-family:TeX Gyre Chorus; font-size: 24px;'>TeX Gyre Chorus</p>
<p>TeX Gyre Cursor: <span style='font-family:TeX Gyre Cursor; font-size: 24px;'>TeX Gyre Cursor</p>
<p>TeX Gyre Heros: <span style='font-family:TeX Gyre Heros; font-size: 24px;'>TeX Gyre Heros</p>
<p>TeX Gyre Heros Cn: <span style='font-family:TeX Gyre Heros Cn; font-size: 24px;'>TeX Gyre Heros Cn</p>
<p>TeX Gyre Pagella: <span style='font-family:TeX Gyre Pagella; font-size: 24px;'>TeX Gyre Pagella</p>
<p>TeX Gyre Schola: <span style='font-family:TeX Gyre Schola; font-size: 24px;'>TeX Gyre Schola</p>
<p>TeX Gyre Termes: <span style='font-family:TeX Gyre Termes; font-size: 24px;'>TeX Gyre Termes</p>
<p>URW Bookman: <span style='font-family:URW Bookman; font-size: 24px;'>URW Bookman</p>
<p>URW Gothic: <span style='font-family:URW Gothic; font-size: 24px;'>URW Gothic</p>
<p>Z003: <span style='font-family:Z003; font-size: 24px;'>Z003</p>
<p>cmb10: <span style='font-family:cmb10; font-size: 24px;'>cmb10</p>
<p>cmex10: <span style='font-family:cmex10; font-size: 24px;'>cmex10</p>
<p>cmmi10: <span style='font-family:cmmi10; font-size: 24px;'>cmmi10</p>
<p>cmr10: <span style='font-family:cmr10; font-size: 24px;'>cmr10</p>
<p>cmss10: <span style='font-family:cmss10; font-size: 24px;'>cmss10</p>
<p>cmsy10: <span style='font-family:cmsy10; font-size: 24px;'>cmsy10</p>
<p>cmtt10: <span style='font-family:cmtt10; font-size: 24px;'>cmtt10</p>
<p>dsrom10: <span style='font-family:dsrom10; font-size: 24px;'>dsrom10</p>
<p>esint10: <span style='font-family:esint10; font-size: 24px;'>esint10</p>
<p>eufm10: <span style='font-family:eufm10; font-size: 24px;'>eufm10</p>
<p>msam10: <span style='font-family:msam10; font-size: 24px;'>msam10</p>
<p>msbm10: <span style='font-family:msbm10; font-size: 24px;'>msbm10</p>
<p>rsfs10: <span style='font-family:rsfs10; font-size: 24px;'>rsfs10</p>
<p>stmary10: <span style='font-family:stmary10; font-size: 24px;'>stmary10</p>
<p>wasy10: <span style='font-family:wasy10; font-size: 24px;'>wasy10</p></div>

Then, I produce the same plot using the ``Raboto`` font:

```python
plt.rcParams["font.size"] = 16
plt.rcParams["font.family"] = "Roboto"


plt.figure(figsize=(16, 9))
plt.xlabel("Abscissa")
plt.ylabel("Ordinates")
plt.title("My title")
plt.scatter(df["A"], df["B"], s=100)
plt.grid()
plt.savefig("plot_example_roboto.png", dpi=300)
```
    
![Plot using Roboto Fonts](/images/plot_example_roboto.png)
   
I increase the fonts (to size 20) in the plot to increase readability; I remove the label on the ordinate axis for not forcing the reader to an effort in reading a rotated text. The result is the following:

![Plot using Roboto Fonts — Increased readability](/images/plot_example_roboto_edited.png)
