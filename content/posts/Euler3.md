---
title: "Euler Problem 3 — Largest Prime Factor"
date: 2023-11-21
draft: false
math: true
series: "Problems from Project Euler"
categories: ["Programming"]
tags: ["Python", "Mathematics"]
description: "Euler Problem 3 — Finding the Largest Prime Factor."
---

[Project Euler](https://projecteuler.net/about) hosts interesting mathematical/programming challenges. Quoting the site itself:

> The first one-hundred or so problems are generally considered to be easier than the problems which follow.

In this post, I am presenting my solution to the first problem. I do not have the intention to spoil the problem for anyone. However, the solutions for the first 100 problems can be posted 

> as long as any discussion clearly aims to instruct methods, not just provide answers, and does not directly threaten to undermine the enjoyment of solving later problems.

The problem [can be found here](https://projecteuler.net/problem=3). For convenience, I include it here:

> The prime factors of 13195 are 5, 7, 13 and 29. What is the largest prime factor of the number 600851475143?

## Creating the test cases

I start by manually creating the test cases.  

* For *n* equals to 1, the expected result is 1.
* For *n* equals to 64, the expected result is 1.
* For *n* equals to 62, the expected result is 31.
* For *n* equals to 35, the expected result is 7.
* For *n* equals to 150, the expected result is 5.
* For *n* equals to 6, the expected result is 3.
* For *n* equals to 47, the expected result is 47.

In term of Python code, the tests in file ``test_euler3.py`` are the following:

```python
import pytest
from euler import largest_prime_factor


def test_0():
    assert largest_prime_factor(1) == 1


def test_1():
    assert largest_prime_factor(64) == 2


def test_2():
    assert largest_prime_factor(62) == 31


def test_3():
    assert largest_prime_factor(35) == 7


def test_4():
    assert largest_prime_factor(150) == 5


def test_5():
    assert largest_prime_factor(6) == 3


def test_6():
    assert largest_prime_factor(47) == 47
```

Then, I create the template for the function that I need to implement in ``euler.py``:

```python
def largest_prime_factor(n: int) -> int:
    return 0
```

Naturally, if I start testing:

```bash
pytest -v test_euler3.py
```

all the test failed.

## Solution

The idea is to use brute force: I iterate through all the integers starting from 2 (the first prime number) and the the value provided as input (``x``); I initialize the ``current_max_divisor`` to 1:

```python
import math


def largest_prime_factor(x: int) -> int:
    current_max_divisor = 1
    i = 2

    while i <= x:
        i = i + 1
```

I test whether the current ``i`` is a divisor for ``x`` with the following:

```python
(x % i) == 0
```

I iterate over the powers of ``i``, dividing as long as the power of ``i`` is a divisor for ``x``. Take for example ``x=24`` and let ``i=2``. Then i keep dividing by 2 as long as ``x`` can no longer be divided by the power of two. Thus the code snippet:

```python
while (x % i) == 0:
  current_max_divisor = i
  x = x // i
``` 

at the first iteration:

```python
24 % 2 == 0
```

the condition is true, then ``current_max_divisor`` is 2. I divide ``x`` (and replace it) with ``24//2`` (integer division). Now, ``i`` remains equal to 2, ``x`` is 12. The condition

```python
12 % 2 == 0
```

it still true, thus I divide ``x`` by 2 again. 

```python
6 % 2 == 0
```

is still holds true, thus I further divide by 2. 

```python
3 % 2 == 0
```

is false; then, in increment ``i`` by one; thus, ``i=3``. I can divide 3 by ``i``, obtaining a new value for ``current_max_divisor``. Now, ``x`` is equal to 1, thus I exit the loop.

To summarize, the final code is:

```python
import math


def largest_prime_factor(x: int) -> int:
    current_max_divisor = 1
    i = 2

    while i <= x:
        while (x % i) == 0:
            current_max_divisor = i
            x = x // i
        i = i + 1

    return int(current_max_divisor)
```

and the result can be obtained by:

```python
largest_prime_factor(600851475143)
```
