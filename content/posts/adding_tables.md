---
title: "Adding Markdown Tables to a Post"
date: 2023-10-04
draft: false
series: "Creating this site"
categories: ["Blogging"]
tags: ["Hugo", "Markdown", "Jupyter", "Python"]
description: "Adding Markdown tables to a post."
---

The intent of using Markdown and Hugo for my site is to directly export from a Jupyter notebook into a post. However, when I preview a dataframe with ``head`` and export the notebook, I obtain a HTML table that is not nicely rendered or styled. The intent is to export in pure Markdown, and let the Hugo theme dictate what the aspect of the table should be.

## The naive approach

I start with the creation of a ``pandas`` dataframe in the first cell of a notebook:

```python
import pandas as pd


df = pd.DataFrame(
    {
        "A": [1, 5, 7, 3, 4, 0],
        "B": [9, 4, 5, 6, 1, 0],
        "C": ["ABC", "BAC", "CAB", "ABC", "BAC", "CAB"],
    }
)
df
```

When downloading the Jupyter notebook as Markdown, the table was generated as the following HTML file:

```html
<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>9</td>
      <td>ABC</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>4</td>
      <td>BAC</td>
    </tr>
    <tr>
      <th>2</th>
      <td>7</td>
      <td>5</td>
      <td>CAB</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>6</td>
      <td>ABC</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>1</td>
      <td>BAC</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0</td>
      <td>0</td>
      <td>CAB</td>
    </tr>
  </tbody>
</table>
</div>
```

This is rendered as:

<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>A</th>
      <th>B</th>
      <th>C</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>1</td>
      <td>9</td>
      <td>ABC</td>
    </tr>
    <tr>
      <th>1</th>
      <td>5</td>
      <td>4</td>
      <td>BAC</td>
    </tr>
    <tr>
      <th>2</th>
      <td>7</td>
      <td>5</td>
      <td>CAB</td>
    </tr>
    <tr>
      <th>3</th>
      <td>3</td>
      <td>6</td>
      <td>ABC</td>
    </tr>
    <tr>
      <th>4</th>
      <td>4</td>
      <td>1</td>
      <td>BAC</td>
    </tr>
    <tr>
      <th>5</th>
      <td>0</td>
      <td>0</td>
      <td>CAB</td>
    </tr>
  </tbody>
</table>
</div>


## Using ``tabulate``

On the other hand, I can use the ``tabulate`` package to convert the table into a string containing a valid Markdown table. The following line:

```python
print(df.to_markdown(index=False))
```

produce these output in te notebook:

```bash
|   A |   B | C   |
|----:|----:|:----|
|   1 |   9 | ABC |
|   5 |   4 | BAC |
|   7 |   5 | CAB |
|   3 |   6 | ABC |
|   4 |   1 | BAC |
|   0 |   0 | CAB |
```

However, once the notebook is exported into Markdown, the table is not rendered because of the trailing spaces. This the way it would be rendered:

    |   A |   B | C   |
    |----:|----:|:----|
    |   1 |   9 | ABC |
    |   5 |   4 | BAC |
    |   7 |   5 | CAB |
    |   3 |   6 | ABC |
    |   4 |   1 | BAC |
    |   0 |   0 | CAB |

As I do not want to manually remove the trailing space, I am going to use a smarter approach.

## Using ``display``

I can display Markdown rendered code in the notebook using ``IPython``:

```python
from IPython.display import display
from IPython.display import Markdown


display(Markdown(df.to_markdown(index=False)))
```

With this approach, the table is rendered in the notebook and in the exported Mardown. Here how it looks like:

|   A |   B | C   |
|----:|----:|:----|
|   1 |   9 | ABC |
|   5 |   4 | BAC |
|   7 |   5 | CAB |
|   3 |   6 | ABC |
|   4 |   1 | BAC |
|   0 |   0 | CAB |

The ``index=False`` argument to ``to_markdown()`` eliminate the indices from the visualization of the dataframe.

## Refactoring to a function

For the sake of brevity, I create a function that display the table as above removing the indices, and with the option to only display a ``nrows`` number of rows:

```python
def dm(df: pd.DataFrame, nrows=None):
    display(Markdown(df.head(nrows).to_markdown(index=False)))
    
    
dm(df)
```

|   A |   B | C   |
|----:|----:|:----|
|   1 |   9 | ABC |
|   5 |   4 | BAC |
|   7 |   5 | CAB |
|   3 |   6 | ABC |
|   4 |   1 | BAC |
|   0 |   0 | CAB |

Displaying only two rows would result in:

```python
dm(df, 2)
```

|   A |   B | C   |
|----:|----:|:----|
|   1 |   9 | ABC |
|   5 |   4 | BAC |

