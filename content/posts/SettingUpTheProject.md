---
title: "Exploring the Data"
date: 2023-10-17
draft: true
series: "Tabular Playground Series — August 2022"
categories: ["Data Science"]
tags: ["Python", "Machine Learning", "Classification", "Kaggle"]
description: "Exploring the August 2022 tabular playground dataset."
---

The starting point is [Tabular Playground Series — Aug 2022](https://www.kaggle.com/competitions/tabular-playground-series-aug-2022): it is a binary classification problem on tabular data to familiarize with classification and Kaggle competitions.

## Structuring the project

I start by storing the input files in the folder ``input``:

```bash
input/sample_submission.csv
input/test.csv
input/train.csv
```

I create a folder for the processed data, ``processed_data``. I save the notebooks in the ``scripts`` folder. I use the following ``poetry`` configuration file:

```toml
[tool.poetry]
name = "tabular"
version = "0.1.0"
description = ""
authors = ["Marco Carnini <marcocarnini@gmail.com>"]
readme = "README.md"

[tool.poetry.dependencies]
python = "^3.11,<3.13"
numpy = "^1.26.1"
scikit-learn = "^1.3.1"
pandas = "^2.1.1"
matplotlib = "^3.8.0"
jupyter = "^1.0.0"
notebook = "^7.0.6"
tabulate = "^0.9.0"


[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"

```

## Reading the input data

As a starting point, I read the training data and calculate the number of rows and columns:

```python
import pandas as pd


df = pd.read_csv("../input/train.csv")
print(df.shape)
```

    (26570, 26)


I do the same for the test set:


```python
test = pd.read_csv("../input/test.csv")
print(test.shape)
```

    (20775, 25)


The columns in the training data are the following:


```python
for i in df.columns:
    print(i)
```

    id
    product_code
    loading
    attribute_0
    attribute_1
    attribute_2
    attribute_3
    measurement_0
    measurement_1
    measurement_2
    measurement_3
    measurement_4
    measurement_5
    measurement_6
    measurement_7
    measurement_8
    measurement_9
    measurement_10
    measurement_11
    measurement_12
    measurement_13
    measurement_14
    measurement_15
    measurement_16
    measurement_17
    failure


The column ``failure`` is what I need to predict. The failures (*i.e.*, the entries with ``failure`` equal to one) are present with frequency:


```python
(df["failure"] == 1).mean()
```




    0.21260820474219044



Thus the dataset is unbalanced. The fact that I need to calculate the [``AUC``](https://en.wikipedia.org/wiki/Receiver_operating_characteristic) as a metrics seems logical. I inspect also the format for the submission: I need to use the ``id`` to match the expected results. A preview of the file is the following:


```python
from IPython.display import display
from IPython.display import Markdown


submission = pd.read_csv("../input/sample_submission.csv")
display(Markdown(submission.head().to_markdown(index=False)))
```


|    id |   failure |
|------:|----------:|
| 26570 |         0 |
| 26571 |         0 |
| 26572 |         0 |
| 26573 |         0 |
| 26574 |         0 |


## Creating a baseline model

In order to assess the correct format of the submissions, and for reference when training the data, I start by submitting a model where all the occurrences are predicted to belong to the most frequent class (*i.e.*, no failure).


```python
submission["failure"] = 0
submission.to_csv("baseline.csv", index=False)
```

As expected, the results are not very interesting:

![Baseline Performance](/images/tabular_baseline.png)

In the next posts, I will focus on building an actual model.
