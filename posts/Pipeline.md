## Refactoring

So far, the model was built interactively with Jupyter notebooks. Here I want to reorganize the code into functions and pipelines. At first, I read the input files:


```python
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import cross_val_score


def read_data() -> tuple:
    return (
        pd.read_csv("../input/4910797b-ee55-40a7-8668-10efd5c1b960.csv"),
        pd.read_csv("../input/702ddfc5-68cd-4d1d-a0de-f5f566f76d91.csv"),
        pd.read_csv("../input/0bf8bc6e-30d0-4c50-956a-603fc693d966.csv"),
    )


def clean_data(train: pd.DataFrame, test: pd.DataFrame) -> tuple:
    train.drop(["recorded_by"], axis=1, inplace=True)
    test.drop(["recorded_by"], axis=1, inplace=True)

    train["source"] = "train"
    test["source"] = "test"
    temp = pd.concat(
        (
            train[
                [
                    "source",
                    "id",
                    "latitude",
                    "longitude",
                    "region_code",
                    "district_code",
                ]
            ],
            test[
                [
                    "source",
                    "id",
                    "latitude",
                    "longitude",
                    "region_code",
                    "district_code",
                ]
            ],
        )
    )

    region_imputation = (
        temp.loc[train["longitude"] >= 29, ["latitude", "longitude", "region_code"]]
        .groupby("region_code")
        .agg(["mean", "median"])
    )
    region_imputation.columns = [
        "r-latitude-mean",
        "r-latitude-median",
        "r-longitude-mean",
        "r-longitude-median",
    ]

    district_imputation = (
        temp.loc[train["longitude"] >= 29, ["latitude", "longitude", "district_code"]]
        .groupby("district_code")
        .agg(["mean", "median"])
    )
    district_imputation.columns = [
        "d-latitude-mean",
        "d-latitude-median",
        "d-longitude-mean",
        "d-longitude-median",
    ]

    missing = (
        temp.loc[temp["longitude"] < 29, :]
        .merge(region_imputation, how="left", on="region_code")
        .merge(district_imputation, how="left", on="district_code")
    )
    missing.drop(
        ["latitude", "longitude", "region_code", "district_code"], axis=1, inplace=True
    )

    nonmissing = temp.loc[temp["longitude"] >= 29, :].copy()
    nonmissing["r-latitude-mean"] = nonmissing["latitude"]
    nonmissing["r-latitude-median"] = nonmissing["latitude"]
    nonmissing["r-longitude-mean"] = nonmissing["longitude"]
    nonmissing["r-longitude-median"] = nonmissing["longitude"]
    nonmissing["d-latitude-mean"] = nonmissing["latitude"]
    nonmissing["d-latitude-median"] = nonmissing["latitude"]
    nonmissing["d-longitude-mean"] = nonmissing["longitude"]
    nonmissing["d-longitude-median"] = nonmissing["longitude"]
    nonmissing.drop(
        ["latitude", "longitude", "region_code", "district_code"], axis=1, inplace=True
    )

    imputed = pd.concat((missing, nonmissing))
    train_impute = imputed.loc[imputed["source"] == "train",].drop(["source"], axis=1)
    test_impute = imputed.loc[imputed["source"] == "test",].drop(["source"], axis=1)
    train = train.merge(train_impute, how="left", on="id")
    test = train.merge(train_impute, how="left", on="id")

    return train, test


def train_model(train: pd.DataFrame, labels: pd.DataFrame) -> np.array:
    X = train.select_dtypes(include=["int64", "float64"])
    Y = labels.status_group.ravel()
    model = RandomForestClassifier(random_state=2020)
    return cross_val_score(model, X, Y, cv=10, n_jobs=-1)


train, test, labels = read_data()
train, test = clean_data(train, test)
rf_scores = train_model(train, labels)
print(rf_scores)
```

    [0.72037037 0.73299663 0.71666667 0.71919192 0.72962963 0.72104377
     0.72474747 0.71447811 0.71094276 0.72222222]



```python
print(np.mean(rf_scores), "+/-", np.std(rf_scores))
```

    0.7212289562289562 +/- 0.006320848257728567


## Exploring other features

So far, only two features were explored and briefly analyzed: ``latitude`` and ``longitude``. However, the following variables are being used currently:

* **id**
* **amount_tsh**
* **gps_height**
* **longitude**
* **latitude**
* **num_private**
* **region_code**
* **district_code**
* **population**
* **construction_year**
* ~**r-latitude-mean**~
* ~**r-latitude-median**~
* ~**r-longitude-mean**~
* ~**r-longitude-median**~
* ~**d-latitude-mean**~
* ~**d-latitude-median**~
* ~**d-longitude-mean**~
* ~**d-longitude-median**~

## Inspecting ``construction_year``


```python
import seaborn as sns
import matplotlib.pyplot as plt
%matplotlib inline


plt.figure(figsize=(8, 8))
sns.distplot(train["construction_year"])
plt.title("Construction year")
plt.savefig("img/piu-construction_year.png", dpi=600, bbox_inches="tight")
plt.show()
```


![png](Pipeline_files/Pipeline_4_0.png)


It seems like may values for ``construction_year`` were not filled and were actually imputed with zero. Excluding them from the visualization


```python
plt.figure(figsize=(8, 8))
sns.distplot(train["construction_year"][train["construction_year"] > 0])
plt.title("Construction year")
plt.savefig("img/piu-construction_year.png", dpi=600, bbox_inches="tight")
plt.show()
```


![png](Pipeline_files/Pipeline_6_0.png)



```python
print(np.median(train["construction_year"][train["construction_year"] > 0]))
print(np.mean(train["construction_year"][train["construction_year"] > 0]))
print(np.mean(train["construction_year"] == 0))
```

    2000.0
    1996.8146855857951
    0.34863636363636363



```python
train.select_dtypes(include=["int64", "float64"]).corr()
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
      <th>id</th>
      <th>amount_tsh</th>
      <th>gps_height</th>
      <th>longitude</th>
      <th>latitude</th>
      <th>num_private</th>
      <th>region_code</th>
      <th>district_code</th>
      <th>population</th>
      <th>construction_year</th>
      <th>r-latitude-mean</th>
      <th>r-latitude-median</th>
      <th>r-longitude-mean</th>
      <th>r-longitude-median</th>
      <th>d-latitude-mean</th>
      <th>d-latitude-median</th>
      <th>d-longitude-mean</th>
      <th>d-longitude-median</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>id</th>
      <td>1.000000</td>
      <td>-0.005321</td>
      <td>-0.004692</td>
      <td>-0.001348</td>
      <td>0.001718</td>
      <td>-0.002629</td>
      <td>-0.003028</td>
      <td>-0.003044</td>
      <td>-0.002813</td>
      <td>-0.002082</td>
      <td>0.001660</td>
      <td>0.001644</td>
      <td>0.001150</td>
      <td>0.001497</td>
      <td>0.000988</td>
      <td>0.000795</td>
      <td>0.001697</td>
      <td>0.001429</td>
    </tr>
    <tr>
      <th>amount_tsh</th>
      <td>-0.005321</td>
      <td>1.000000</td>
      <td>0.076650</td>
      <td>0.022134</td>
      <td>-0.052670</td>
      <td>0.002944</td>
      <td>-0.026813</td>
      <td>-0.023599</td>
      <td>0.016288</td>
      <td>0.067915</td>
      <td>-0.051745</td>
      <td>-0.051663</td>
      <td>0.016547</td>
      <td>0.014648</td>
      <td>-0.049825</td>
      <td>-0.050074</td>
      <td>0.013176</td>
      <td>0.012282</td>
    </tr>
    <tr>
      <th>gps_height</th>
      <td>-0.004692</td>
      <td>0.076650</td>
      <td>1.000000</td>
      <td>0.149155</td>
      <td>-0.035751</td>
      <td>0.007237</td>
      <td>-0.183521</td>
      <td>-0.171233</td>
      <td>0.135003</td>
      <td>0.658727</td>
      <td>-0.006344</td>
      <td>-0.004918</td>
      <td>0.020924</td>
      <td>0.000739</td>
      <td>0.018568</td>
      <td>0.015687</td>
      <td>-0.013609</td>
      <td>-0.021744</td>
    </tr>
    <tr>
      <th>longitude</th>
      <td>-0.001348</td>
      <td>0.022134</td>
      <td>0.149155</td>
      <td>1.000000</td>
      <td>-0.425802</td>
      <td>0.023873</td>
      <td>0.034197</td>
      <td>0.151398</td>
      <td>0.086590</td>
      <td>0.396732</td>
      <td>-0.278592</td>
      <td>-0.271274</td>
      <td>0.602232</td>
      <td>0.504602</td>
      <td>-0.148443</td>
      <td>-0.163625</td>
      <td>0.430983</td>
      <td>0.387213</td>
    </tr>
    <tr>
      <th>latitude</th>
      <td>0.001718</td>
      <td>-0.052670</td>
      <td>-0.035751</td>
      <td>-0.425802</td>
      <td>1.000000</td>
      <td>0.006837</td>
      <td>-0.221018</td>
      <td>-0.201020</td>
      <td>-0.022152</td>
      <td>-0.245278</td>
      <td>0.984854</td>
      <td>0.983406</td>
      <td>-0.355146</td>
      <td>-0.321631</td>
      <td>0.950389</td>
      <td>0.954897</td>
      <td>-0.295109</td>
      <td>-0.278772</td>
    </tr>
    <tr>
      <th>num_private</th>
      <td>-0.002629</td>
      <td>0.002944</td>
      <td>0.007237</td>
      <td>0.023873</td>
      <td>0.006837</td>
      <td>1.000000</td>
      <td>-0.020377</td>
      <td>-0.004478</td>
      <td>0.003818</td>
      <td>0.026056</td>
      <td>0.008410</td>
      <td>0.008480</td>
      <td>0.045207</td>
      <td>0.045393</td>
      <td>0.009550</td>
      <td>0.009423</td>
      <td>0.045142</td>
      <td>0.044816</td>
    </tr>
    <tr>
      <th>region_code</th>
      <td>-0.003028</td>
      <td>-0.026813</td>
      <td>-0.183521</td>
      <td>0.034197</td>
      <td>-0.221018</td>
      <td>-0.020377</td>
      <td>1.000000</td>
      <td>0.678602</td>
      <td>0.094088</td>
      <td>0.031724</td>
      <td>-0.235809</td>
      <td>-0.236366</td>
      <td>0.136658</td>
      <td>0.142857</td>
      <td>-0.243651</td>
      <td>-0.243054</td>
      <td>0.146052</td>
      <td>0.146919</td>
    </tr>
    <tr>
      <th>district_code</th>
      <td>-0.003044</td>
      <td>-0.023599</td>
      <td>-0.171233</td>
      <td>0.151398</td>
      <td>-0.201020</td>
      <td>-0.004478</td>
      <td>0.678602</td>
      <td>1.000000</td>
      <td>0.061831</td>
      <td>0.048315</td>
      <td>-0.199225</td>
      <td>-0.199032</td>
      <td>0.257504</td>
      <td>0.256453</td>
      <td>-0.195203</td>
      <td>-0.196832</td>
      <td>0.253374</td>
      <td>0.249374</td>
    </tr>
    <tr>
      <th>population</th>
      <td>-0.002813</td>
      <td>0.016288</td>
      <td>0.135003</td>
      <td>0.086590</td>
      <td>-0.022152</td>
      <td>0.003818</td>
      <td>0.094088</td>
      <td>0.061831</td>
      <td>1.000000</td>
      <td>0.260910</td>
      <td>-0.010893</td>
      <td>-0.010340</td>
      <td>0.076672</td>
      <td>0.070220</td>
      <td>-0.001168</td>
      <td>-0.002297</td>
      <td>0.065044</td>
      <td>0.061826</td>
    </tr>
    <tr>
      <th>construction_year</th>
      <td>-0.002082</td>
      <td>0.067915</td>
      <td>0.658727</td>
      <td>0.396732</td>
      <td>-0.245278</td>
      <td>0.026056</td>
      <td>0.031724</td>
      <td>0.048315</td>
      <td>0.260910</td>
      <td>1.000000</td>
      <td>-0.212801</td>
      <td>-0.211077</td>
      <td>0.489476</td>
      <td>0.471190</td>
      <td>-0.180753</td>
      <td>-0.184569</td>
      <td>0.454230</td>
      <td>0.442705</td>
    </tr>
    <tr>
      <th>r-latitude-mean</th>
      <td>0.001660</td>
      <td>-0.051745</td>
      <td>-0.006344</td>
      <td>-0.278592</td>
      <td>0.984854</td>
      <td>0.008410</td>
      <td>-0.235809</td>
      <td>-0.199225</td>
      <td>-0.010893</td>
      <td>-0.212801</td>
      <td>1.000000</td>
      <td>0.999966</td>
      <td>-0.328388</td>
      <td>-0.314077</td>
      <td>0.988994</td>
      <td>0.990349</td>
      <td>-0.301289</td>
      <td>-0.293724</td>
    </tr>
    <tr>
      <th>r-latitude-median</th>
      <td>0.001644</td>
      <td>-0.051663</td>
      <td>-0.004918</td>
      <td>-0.271274</td>
      <td>0.983406</td>
      <td>0.008480</td>
      <td>-0.236366</td>
      <td>-0.199032</td>
      <td>-0.010340</td>
      <td>-0.211077</td>
      <td>0.999966</td>
      <td>1.000000</td>
      <td>-0.326834</td>
      <td>-0.313470</td>
      <td>0.990145</td>
      <td>0.991363</td>
      <td>-0.301360</td>
      <td>-0.294182</td>
    </tr>
    <tr>
      <th>r-longitude-mean</th>
      <td>0.001150</td>
      <td>0.016547</td>
      <td>0.020924</td>
      <td>0.602232</td>
      <td>-0.355146</td>
      <td>0.045207</td>
      <td>0.136658</td>
      <td>0.257504</td>
      <td>0.076672</td>
      <td>0.489476</td>
      <td>-0.328388</td>
      <td>-0.326834</td>
      <td>1.000000</td>
      <td>0.993092</td>
      <td>-0.297678</td>
      <td>-0.301174</td>
      <td>0.979837</td>
      <td>0.968785</td>
    </tr>
    <tr>
      <th>r-longitude-median</th>
      <td>0.001497</td>
      <td>0.014648</td>
      <td>0.000739</td>
      <td>0.504602</td>
      <td>-0.321631</td>
      <td>0.045393</td>
      <td>0.142857</td>
      <td>0.256453</td>
      <td>0.070220</td>
      <td>0.471190</td>
      <td>-0.314077</td>
      <td>-0.313470</td>
      <td>0.993092</td>
      <td>1.000000</td>
      <td>-0.300189</td>
      <td>-0.301790</td>
      <td>0.996497</td>
      <td>0.990802</td>
    </tr>
    <tr>
      <th>d-latitude-mean</th>
      <td>0.000988</td>
      <td>-0.049825</td>
      <td>0.018568</td>
      <td>-0.148443</td>
      <td>0.950389</td>
      <td>0.009550</td>
      <td>-0.243651</td>
      <td>-0.195203</td>
      <td>-0.001168</td>
      <td>-0.180753</td>
      <td>0.988994</td>
      <td>0.990145</td>
      <td>-0.297678</td>
      <td>-0.300189</td>
      <td>1.000000</td>
      <td>0.999559</td>
      <td>-0.299376</td>
      <td>-0.297495</td>
    </tr>
    <tr>
      <th>d-latitude-median</th>
      <td>0.000795</td>
      <td>-0.050074</td>
      <td>0.015687</td>
      <td>-0.163625</td>
      <td>0.954897</td>
      <td>0.009423</td>
      <td>-0.243054</td>
      <td>-0.196832</td>
      <td>-0.002297</td>
      <td>-0.184569</td>
      <td>0.990349</td>
      <td>0.991363</td>
      <td>-0.301174</td>
      <td>-0.301790</td>
      <td>0.999559</td>
      <td>1.000000</td>
      <td>-0.299490</td>
      <td>-0.296138</td>
    </tr>
    <tr>
      <th>d-longitude-mean</th>
      <td>0.001697</td>
      <td>0.013176</td>
      <td>-0.013609</td>
      <td>0.430983</td>
      <td>-0.295109</td>
      <td>0.045142</td>
      <td>0.146052</td>
      <td>0.253374</td>
      <td>0.065044</td>
      <td>0.454230</td>
      <td>-0.301289</td>
      <td>-0.301360</td>
      <td>0.979837</td>
      <td>0.996497</td>
      <td>-0.299376</td>
      <td>-0.299490</td>
      <td>1.000000</td>
      <td>0.998206</td>
    </tr>
    <tr>
      <th>d-longitude-median</th>
      <td>0.001429</td>
      <td>0.012282</td>
      <td>-0.021744</td>
      <td>0.387213</td>
      <td>-0.278772</td>
      <td>0.044816</td>
      <td>0.146919</td>
      <td>0.249374</td>
      <td>0.061826</td>
      <td>0.442705</td>
      <td>-0.293724</td>
      <td>-0.294182</td>
      <td>0.968785</td>
      <td>0.990802</td>
      <td>-0.297495</td>
      <td>-0.296138</td>
      <td>0.998206</td>
      <td>1.000000</td>
    </tr>
  </tbody>
</table>
</div>



### Imputing with a model


```python
from sklearn.ensemble import RandomForestRegressor


X = train.select_dtypes(include=["int64", "float64"]).loc[
    train["construction_year"] > 0, :
]
Y = X.construction_year.ravel()
X.drop(["construction_year"], axis=1, inplace=True)
model = RandomForestRegressor(random_state=2020)
rf_scores = cross_val_score(
    model, X, Y, cv=10, n_jobs=-1, scoring="neg_mean_squared_error"
)
```


```python
print(rf_scores)
```

    [-69.1032461  -69.25243787 -67.54833352 -65.76045412 -65.98857922
     -68.69079548 -66.85597834 -62.17621339 -63.09343673 -68.43594433]



```python
model.fit(X, Y)
```




    RandomForestRegressor(bootstrap=True, ccp_alpha=0.0, criterion='mse',
                          max_depth=None, max_features='auto', max_leaf_nodes=None,
                          max_samples=None, min_impurity_decrease=0.0,
                          min_impurity_split=None, min_samples_leaf=1,
                          min_samples_split=2, min_weight_fraction_leaf=0.0,
                          n_estimators=100, n_jobs=None, oob_score=False,
                          random_state=2020, verbose=0, warm_start=False)




```python
model.predict(X)
```




    array([1999.47, 2005.41, 2008.93, ..., 1999.  , 1992.3 , 2002.  ])




```python
np.sqrt(np.mean((Y-model.predict(X))**2))
```




    3.01306678540479




```python
from sklearn.linear_model import LinearRegression


model = LinearRegression()
lin_scores = cross_val_score(
    model, X, Y, cv=10, n_jobs=-1, scoring="neg_mean_squared_error"
)
```


```python
print(lin_scores)
```

    [-157.93164489 -161.59832909 -154.32962147 -152.44825225 -159.00582027
     -155.3088363  -152.00369456 -149.26156576 -149.03934272 -158.89908401]



```python
from xgboost import XGBRegressor


model = XGBRegressor()
xgb_scores = cross_val_score(
    model, X, Y, cv=10, n_jobs=-1, scoring="neg_mean_squared_error"
)
```


```python
print(xgb_scores)
```

    [-89.86001896 -87.66991309 -86.2814411  -83.93712904 -86.29519166
     -89.89196578 -83.41551574 -83.08570435 -79.96698577 -90.85749749]


Thus I will use a Random Forest to impute. 


```python

```
