---
title: "Training a First Model"
date: 2023-10-19
draft: true
series: "Tabular Playground Series — August 2022"
categories: ["Data Science"]
tags: ["Python", "Machine Learning", "Classification", "Kaggle", "Random Forest"]
description: "Training a baseline model."
---

In this article, I build the first model. As a first step, I generate a simple model ignoring any possible complication: I discard any columns containing missing values and all the categorical columns. 

I do not try to build new features nor to select the most relevant ones. Later, I will iteratively explore new features, impute missing data and encode the categorical variables.

## Reading the data

As a first step, I read the data:


```python
import numpy as np
import pandas as pd
from IPython.display import display
from IPython.display import Markdown


df = pd.read_csv("../input/train.csv")
print(df.shape)
```

    (26570, 26)


Then, I check the types of all the columns:


```python
temp1 = df.dtypes.reset_index()
temp1.columns = ["Column", "Type"]
display(Markdown(temp1.to_markdown(index=False)))
```


| Column         | Type    |
|:---------------|:--------|
| id             | int64   |
| product_code   | object  |
| loading        | float64 |
| attribute_0    | object  |
| attribute_1    | object  |
| attribute_2    | int64   |
| attribute_3    | int64   |
| measurement_0  | int64   |
| measurement_1  | int64   |
| measurement_2  | int64   |
| measurement_3  | float64 |
| measurement_4  | float64 |
| measurement_5  | float64 |
| measurement_6  | float64 |
| measurement_7  | float64 |
| measurement_8  | float64 |
| measurement_9  | float64 |
| measurement_10 | float64 |
| measurement_11 | float64 |
| measurement_12 | float64 |
| measurement_13 | float64 |
| measurement_14 | float64 |
| measurement_15 | float64 |
| measurement_16 | float64 |
| measurement_17 | float64 |
| failure        | int64   |


Then, I estimate the frequency of missing values for each column:


```python
temp2 = df.isna().mean().reset_index()
temp2.columns = ["Column", "Missing frequency"]
display(Markdown(temp2.to_markdown(index=False)))
```


| Column         |   Missing frequency |
|:---------------|--------------------:|
| id             |          0          |
| product_code   |          0          |
| loading        |          0.00940911 |
| attribute_0    |          0          |
| attribute_1    |          0          |
| attribute_2    |          0          |
| attribute_3    |          0          |
| measurement_0  |          0          |
| measurement_1  |          0          |
| measurement_2  |          0          |
| measurement_3  |          0.0143395  |
| measurement_4  |          0.0202484  |
| measurement_5  |          0.0254422  |
| measurement_6  |          0.0299586  |
| measurement_7  |          0.0352653  |
| measurement_8  |          0.039443   |
| measurement_9  |          0.0461799  |
| measurement_10 |          0.0489274  |
| measurement_11 |          0.0552503  |
| measurement_12 |          0.0602559  |
| measurement_13 |          0.066767   |
| measurement_14 |          0.0705307  |
| measurement_15 |          0.0756116  |
| measurement_16 |          0.0794129  |
| measurement_17 |          0.0859616  |
| failure        |          0          |


I summarize the results of the data exploration in a single table:


```python
metadata = temp1.merge(temp2)
display(Markdown(metadata.to_markdown(index=False)))
```


| Column         | Type    |   Missing frequency |
|:---------------|:--------|--------------------:|
| id             | int64   |          0          |
| product_code   | object  |          0          |
| loading        | float64 |          0.00940911 |
| attribute_0    | object  |          0          |
| attribute_1    | object  |          0          |
| attribute_2    | int64   |          0          |
| attribute_3    | int64   |          0          |
| measurement_0  | int64   |          0          |
| measurement_1  | int64   |          0          |
| measurement_2  | int64   |          0          |
| measurement_3  | float64 |          0.0143395  |
| measurement_4  | float64 |          0.0202484  |
| measurement_5  | float64 |          0.0254422  |
| measurement_6  | float64 |          0.0299586  |
| measurement_7  | float64 |          0.0352653  |
| measurement_8  | float64 |          0.039443   |
| measurement_9  | float64 |          0.0461799  |
| measurement_10 | float64 |          0.0489274  |
| measurement_11 | float64 |          0.0552503  |
| measurement_12 | float64 |          0.0602559  |
| measurement_13 | float64 |          0.066767   |
| measurement_14 | float64 |          0.0705307  |
| measurement_15 | float64 |          0.0756116  |
| measurement_16 | float64 |          0.0794129  |
| measurement_17 | float64 |          0.0859616  |
| failure        | int64   |          0          |


## The pipeline

I start with some mock functions for the full pipeline from data to the submission:


```python
def read_data():
    return 0


def split_validation():
    return 0


def feature_engineering():
    return 0


def train_model():
    return 0


def validate_model():
    return 0


def store_performance():
    return 0


def create_submission():
    return 0


if __name__ == "__main__":
    read_data()
    split_validation()
    feature_engineering()
    train_model()
    validate_model()
    create_submission()
    store_performance()
```

I start by creating the ``read_data`` function:


```python
def read_data() -> tuple:
    return pd.read_csv("../input/train.csv"), pd.read_csv("../input/test.csv")


train, test = read_data()
```

For the validation, I split the training set into 10 folds by creating a temporary variable ``fold`` with random integers between 0 and 9:


```python
nfolds = 10


np.random.seed(2023)
df["fold"] = np.random.randint(0, nfolds, train.shape[0])
set(df["fold"])
```




    {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}



I refactored into a function:


```python
def split_validation(N: int, nfolds: int) -> pd.Series:
    np.random.seed(2023)
    return np.random.randint(0, nfolds, N)


nfolds = 10
train["fold"] = split_validation(train.shape[0], nfolds)
```

For the first model, I only consider for simplicity columns without missing data and of numeric type. From the dataframe ``metadata``, I only select the columns that have no missing data and that are numerical:


```python
metadata[(metadata["Type"] != "object") & (metadata["Missing frequency"] == 0)]
```




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
      <th>Column</th>
      <th>Type</th>
      <th>Missing frequency</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>id</td>
      <td>int64</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>attribute_2</td>
      <td>int64</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>attribute_3</td>
      <td>int64</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>measurement_0</td>
      <td>int64</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>measurement_1</td>
      <td>int64</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>measurement_2</td>
      <td>int64</td>
      <td>0.0</td>
    </tr>
    <tr>
      <th>25</th>
      <td>failure</td>
      <td>int64</td>
      <td>0.0</td>
    </tr>
  </tbody>
</table>
</div>



I want the list of columns that satisfy the condition:


```python
metadata.loc[
    (metadata["Type"] != "object") & (metadata["Missing frequency"] == 0), "Column"
].to_list()
```




    ['id',
     'attribute_2',
     'attribute_3',
     'measurement_0',
     'measurement_1',
     'measurement_2',
     'failure']



I then refactor into a single function:


```python
def feature_engineering(train: pd.DataFrame, test: pd.DataFrame) -> tuple:
    temp1 = train.dtypes.reset_index()
    temp1.columns = ["Column", "Type"]
    temp2 = df.isna().mean().reset_index()
    temp2.columns = ["Column", "Missing frequency"]
    metadata = temp1.merge(temp2)
    excluded = ["id", "failure", "fold"]
    columns = [
        i
        for i in metadata.loc[
            (metadata["Type"] != "object") & (metadata["Missing frequency"] == 0),
            "Column",
        ].to_list()
        if i not in excluded
    ]

    return train[["fold", "failure"] + columns].copy(), test[columns + ["id"]].copy()


train, test = feature_engineering(train, test)
```

I validate that the folds are balanced in therms of failure rate:


```python
temp = train.groupby("fold")["failure"].mean().reset_index()
temp.columns = ["Fold", "Failure rate"]
display(Markdown(temp.sort_values("Fold").to_markdown(index=False)))
```


|   Fold |   Failure rate |
|-------:|---------------:|
|      0 |       0.218013 |
|      1 |       0.2213   |
|      2 |       0.210666 |
|      3 |       0.218095 |
|      4 |       0.218257 |
|      5 |       0.197368 |
|      6 |       0.199697 |
|      7 |       0.211315 |
|      8 |       0.209546 |
|      9 |       0.221339 |


and in terms of number of observations:


```python
temp = train["fold"].value_counts().reset_index()
temp.columns = ["Fold", "Number of observations"]
display(Markdown(temp.sort_values("Fold").to_markdown(index=False)))
```


|   Fold |   Number of observations |
|-------:|-------------------------:|
|      0 |                     2587 |
|      1 |                     2770 |
|      2 |                     2644 |
|      3 |                     2719 |
|      4 |                     2662 |
|      5 |                     2660 |
|      6 |                     2639 |
|      7 |                     2669 |
|      8 |                     2577 |
|      9 |                     2643 |


I train the first model:


```python
from sklearn.ensemble import RandomForestClassifier


Y = train["failure"].to_list()
X = train.drop(["failure"], axis=1)
model = RandomForestClassifier(random_state=2023).fit(X, Y)
```

I refactor into a function:


```python
from sklearn.ensemble import RandomForestClassifier


def train_model(df: pd.DataFrame):
    Y = df["failure"].to_list()
    X = df.drop(["failure"], axis=1)
    return RandomForestClassifier(random_state=2023).fit(X, Y)


model = train_model(train)
```

For validating the model, I train on all the data but those in the ``fold`` and calculate the metric (the area under the curve) on it:


```python
from sklearn.metrics import roc_auc_score


fold = 0
X_train = train[train["fold"] != fold]
X_val = train[train["fold"] == fold]

model = train_model(X_train)
Y_predict = model.predict(X_val.drop(["failure"], axis=1))
roc_auc_score(X_val["failure"], Y_predict)
```




    0.5039641638883339



I refactor into a function:


```python
from sklearn.metrics import roc_auc_score


def validate_model(fold: int, train: pd.DataFrame) -> float:
    X_train = train[train["fold"] != fold]
    X_val = train[train["fold"] == fold]
    model = train_model(X_train.drop(["fold"], axis=1))
    Y_predict = model.predict(X_val.drop(["failure", "fold"], axis=1))
    return roc_auc_score(X_val["failure"], Y_predict)


for i in range(nfolds):
    print(validate_model(i, train))
```

    0.5015946929460144
    0.5059618481048461
    0.4970222605700502
    0.492557415694866
    0.4994574301875588
    0.5118969555035129
    0.5029505203841067
    0.5000185306851299
    0.501700485463372
    0.5191908998031447


I estimate the average performance, and estimate the dispersion of the scores:


```python
scores = [validate_model(i, train) for i in range(nfolds)]
print(np.mean(scores), "+/-", np.std(scores))
```

    0.5032351039342602 +/- 0.007206988478255747


Then, I create a dataframe associating the current model version with the performance on the folds:


```python
version = 0.1
performance = pd.DataFrame({"Version": [version] * nfolds, "Scores": scores})
display(Markdown(performance.to_markdown(index=False)))
performance.to_csv(f"performance_{version}.csv", index=False)
```


|   Version |   Scores |
|----------:|---------:|
|       0.1 | 0.501595 |
|       0.1 | 0.505962 |
|       0.1 | 0.497022 |
|       0.1 | 0.492557 |
|       0.1 | 0.499457 |
|       0.1 | 0.511897 |
|       0.1 | 0.502951 |
|       0.1 | 0.500019 |
|       0.1 | 0.5017   |
|       0.1 | 0.519191 |


I refactor into a function:


```python
def store_performance(version: float, scores: list) -> None:
    performance = pd.DataFrame({"Version": [version] * nfolds, "Scores": scores})
    performance.to_csv(f"performance_{version}.csv", index=False)


store_performance(0.1, scores)
```

After storing the performance, I can retrain on all the ``train``ing dataset:


```python
model = train_model(train.drop(["fold"], axis=1))
```

I can score the ``test`` set:


```python
test["failure"] = model.predict(test.drop(["id"], axis=1))
test.to_csv(f"submission_{version}.csv", index=False)
```

I refactor into a function for creating the submission:


```python
def create_submission(model, test: pd.DataFrame) -> None:
    test["failure"] = model.predict(test.drop(["id"], axis=1))
    test[["id", "failure"]].to_csv(f"submission_{version}.csv", index=False)


create_submission(model, test.drop(["failure"], axis=1))
```

## Refactoring into a single function

Finally, I refactor all the pipeline into a single script:




```python
import numpy as np
import pandas as pd
from sklearn.metrics import roc_auc_score
from sklearn.ensemble import RandomForestClassifier


def read_data() -> tuple:
    return pd.read_csv("../input/train.csv"), pd.read_csv("../input/test.csv")


def split_validation(N: int, nfolds: int) -> pd.Series:
    np.random.seed(2023)
    return np.random.randint(0, nfolds, N)


def feature_engineering(train: pd.DataFrame, test: pd.DataFrame) -> tuple:
    temp1 = train.dtypes.reset_index()
    temp1.columns = ["Column", "Type"]
    temp2 = df.isna().mean().reset_index()
    temp2.columns = ["Column", "Missing frequency"]
    metadata = temp1.merge(temp2)
    excluded = ["id", "failure", "fold"]
    columns = [
        i
        for i in metadata.loc[
            (metadata["Type"] != "object") & (metadata["Missing frequency"] == 0),
            "Column",
        ].to_list()
        if i not in excluded
    ]
    return train[["fold", "failure"] + columns].copy(), test[columns + ["id"]].copy()


def train_model(df: pd.DataFrame):
    Y = df["failure"].to_list()
    X = df.drop(["failure"], axis=1)
    return RandomForestClassifier(random_state=2023).fit(X, Y)


def validate_model(fold: int, train: pd.DataFrame) -> float:
    X_train = train[train["fold"] != fold]
    X_val = train[train["fold"] == fold]

    model = train_model(X_train.drop(["fold"], axis=1))
    Y_predict = model.predict(X_val.drop(["failure", "fold"], axis=1))
    return roc_auc_score(X_val["failure"], Y_predict)


def store_performance(version: float, scores: list) -> None:
    performance = pd.DataFrame({"Version": [version] * nfolds, "Scores": scores})
    performance.to_csv(f"performance_{version}.csv", index=False)


def create_submission(model, test: pd.DataFrame) -> None:
    test["failure"] = model.predict(test.drop(["id"], axis=1))
    test[["id", "failure"]].to_csv(f"submission_{version}.csv", index=False)


if __name__ == "__main__":
    nfolds = 10
    train, test = read_data()
    train["fold"] = split_validation(train.shape[0], nfolds)
    train, test = feature_engineering(train, test)
    model = train_model(train.drop(["fold"], axis=1))
    create_submission(model, test)
```

In the next article, I want to improve the Feature Engineering part of the pipeline while maintaining the rest (like the data reading, submission preparation and performance storing).


```python

```
