---
title: "Euler Problem 1 — Multiples of 3 and 5"
date: 2023-11-21
draft: false
math: true
series: "Problems from Project Euler"
categories: ["Programming"]
tags: ["Python", "Mathematics"]
description: "Euler Problem 1 — Summing the multiples of 3 and 5."
---

[Project Euler](https://projecteuler.net/about) hosts interesting mathematical/programming challenges. Quoting the site itself:

> The first one-hundred or so problems are generally considered to be easier than the problems which follow.

In this post, I am presenting my solution to the first problem. I do not have the intention to spoil the problem for anyone. However, the solutions for the first 100 problems can be posted 

> as long as any discussion clearly aims to instruct methods, not just provide answers, and does not directly threaten to undermine the enjoyment of solving later problems.

The problem [can be found here](https://projecteuler.net/problem=1). For convenience, I quoted verbatim here:

> If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23. Find the sum of all the multiples of 3 or 5 below 1000.

## Creating the test cases

I start by manually creating the test cases. The multiples need to be smaller than an integer *N*. 

* For *N* equals to 10, the example provided in the problem is 23.
* For *N* equals to 7, the multiples are 3, 5, 6. The expected result is 14.
* For *N* equals to 8, the multiples are 3, 5, 6. The expected result is 14.
* For *N* equals to 20, the multiples are 3, 5, 6, 9, 12, 15, 18. The expected result is 78.
* For *N* equals to 30, the multiples are 3, 5, 6, 9, 12, 15, 18, 20, 21, 24, 27. The expected result is 195.

In term of Python code, the tests in file ``test_euler1.py`` are the following:

```python
import pytest
from euler import multiples


def test_0():
    assert multiples(7) == 14


def test_1():
    assert multiples(8) == 14


def test_2():
    assert multiples(10) == 23


def test_3():
    assert multiples(20) == 78


def test_4():
    assert multiples(30) == 195
```

Then, I create the template for the function that I need to implement in ``euler.py``:

```python
def multiples(N: int) -> int:
    return N
```

Naturally, if I start testing:

```bash
pytest -v test_euler1.py
```

all the test failed.

## The reasoning for getting the solution

The reasoning is the following:

* all the multiple of 3 can be written as \\(3i\\) with \\(i \in \mathbb{N}\\), 
* all the multiplie of 5 can be written as \\(5j\\) with \\(j \in \mathbb{N}\\),  
* all the multiple of 15 can be written as \\(15k\\) with \\(k \in \mathbb{N}\\). 

Thus, the sum of all the multiples of 3 smaller than \\(N\\) is:

$$S_3=\sum_{i=1}^{i_\\text{max}}3i$$

Here, the \\(i_\\text{max}\\) means that I have to limit the possible values of \\(i\\) to those that satisfy the condition \\(3i<N\\). That is, 

$$i_\\text{max} = \left \lfloor \frac{N-1}{3} \right \rfloor$$

where \\(\\lfloor \cdot \\rfloor\\) is the floor function. The same reasoning applies to

  
$$S_5=\sum_{j=1}^{j_\\text{max}}5j$$
$$j_\\text{max} = \left \lfloor \frac{N-1}{5} \right \rfloor$$

$$S_{15}=\sum_{k=1}^{k_\\text{max}}15k$$
$$i_\\text{max} = \left \lfloor \frac{N-1}{15} \right \rfloor$$

Thus, the quantity I want to measure is:

$$S=S_3+S_5-S_{15}=\sum_{i=1}^{i_\\text{max}}3i + \sum_{j=1}^{j_\\text{max}}5j-\sum_{k=1}^{k_\\text{max}}15k$$

Here, I subtract $$S_{15}$$ because by summing the multiples of 3 and those of 5 separately, I would count twice the multiples of 15. Simplifying the expression above:

$$S=3\sum_{i=1}^{i_\\text{max}}i + 5\sum_{j=1}^{j_\\text{max}}j-15\sum_{k=1}^{k_\\text{max}}k$$

Since the sum of the first \\(M\\) numbers is

$$\sum_{l}^M l=\frac{M(M+1)}{2}.$$

Thus, the formula for \\(S\\) can be rewritten as:

$$S=3\frac{i_\text{max}(i_\text{max}+1)}{2}+5\frac{j_\text{max}(j_\text{max}+1)}{2}-15\frac{k_\text{max}(k_\text{max}+1)}{2}$$

## The implementation

The implementation of the formula is quite straighforward:

```python
def multiples(N: int) -> int:
    i_m = (N - 1) // 3
    j_m = (N - 1) // 5
    k_m = (N - 1) // 15

    return int(
        3 * i_m * (i_m + 1) / 2 + 5 * j_m * (j_m + 1) / 2 - 15 * k_m * (k_m + 1) / 2
    )
```

Of course, all the test quoted above ran successfully.

The final result can be obtained with:

```python
from euler import multiples

mutiples(1000)
```
