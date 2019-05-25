# Functions


```r
library(tidyverse)
```



```
## Warning: package 'ggplot2' was built under R version 3.5.3
```

```
## Warning: package 'tibble' was built under R version 3.5.3
```

```
## Warning: package 'tidyr' was built under R version 3.5.3
```

```
## Warning: package 'readr' was built under R version 3.5.2
```

```
## Warning: package 'purrr' was built under R version 3.5.3
```

```
## Warning: package 'dplyr' was built under R version 3.5.2
```

```
## Warning: package 'stringr' was built under R version 3.5.2
```

```
## Warning: package 'forcats' was built under R version 3.5.1
```

```
## Warning: package 'survminer' was built under R version 3.5.1
```

```
## Warning: package 'ggpubr' was built under R version 3.5.1
```

```
## Warning: package 'magrittr' was built under R version 3.5.1
```

```
## Warning: package 'car' was built under R version 3.5.1
```

```
## Warning: package 'carData' was built under R version 3.5.1
```

```
## Warning: package 'ggbiplot' was built under R version 3.5.1
```

```
## Warning: package 'plyr' was built under R version 3.5.1
```

```
## Warning: package 'scales' was built under R version 3.5.1
```

```
## Warning: package 'ggrepel' was built under R version 3.5.1
```

```
## Warning: package 'broom' was built under R version 3.5.2
```

```
## Warning: package 'rstan' was built under R version 3.5.3
```

```
## Warning: package 'StanHeaders' was built under R version 3.5.1
```



##  Making some R functions


 Let's write some simple R functions to convert temperatures,
and later to play with text.



(a) A temperature in Celsius is converted to one in Kelvin by
adding 273.15. (A temperature of $-273.15$ Celsius, 0 Kelvin, is the "absolute zero" 
temperature that nothing can be colder than.) Write a
function called `c_to_k` that converts an input Celsius
temperature to one in Kelvin, and test that it works.

Solution


This is mostly an exercise in structuring your function
correctly. Let's call the input `C` (uppercase C, since
lowercase c has a special meaning to R):

```r
c_to_k <- function(C) {
  C + 273.15
}
c_to_k(0)
```

```
## [1] 273.15
```

```r
c_to_k(20)
```

```
## [1] 293.15
```

     

This is the simplest way to do it: the last line of the function, if
calculated but not saved, is the value that gets returned to the
outside world. The checks suggest that it worked.

If you're used to Python or similar, you might prefer to calculate the
value to be returned and then return it. You can do that in R too:


```r
c_to_k <- function(C) {
  K <- C + 273.15
  return(K)
}
c_to_k(0)
```

```
## [1] 273.15
```

```r
c_to_k(20)
```

```
## [1] 293.15
```

 

That works just as well, and for the rest of this question, you can go
either way.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">R style is to use the last line of the function  for the return value, unless you are jumping out of the function  before the end, in which case use *return*.</span>


(b) Write a function to convert a Fahrenheit temperature to
Celsius. The way you do that is to subtract 32 and then multiply by
$5/9$. 

Solution


On the model of the previous one, we should call this
`f_to_c`. I'm going to return the last line, but you can
save the calculated value and return that instead:

```r
f_to_c <- function(F) {
  (F - 32) * 5 / 9
}
f_to_c(32)
```

```
## [1] 0
```

```r
f_to_c(50)
```

```
## [1] 10
```

```r
f_to_c(68)
```

```
## [1] 20
```

     

Americans are very good at saying things like "temperatures in the 50s", 
which don't mean much to me, so I like to have benchmarks to
work with: these are the Fahrenheit versions of 0, 10, and 20 Celsius.

Thus "in the 50s" means "between about 10 and 15 Celsius".


(c) *Using the functions you already wrote*, write a function
to convert an input Fahrenheit temperature to Kelvin.

Solution


This implies that you can piggy-back on the functions you just
wrote, which goes as below. First you convert the Fahrenheit to
Celsius, and then you convert *that* to Kelvin. (This is less
error-prone than trying to use algebra to get a formula for this
conversion and then implementing that):

```r
f_to_k <- function(F) {
  C <- f_to_c(F)
  K <- c_to_k(C)
  return(K)
}
f_to_k(32)
```

```
## [1] 273.15
```

```r
f_to_k(68)
```

```
## [1] 293.15
```

     

These check because in Celsius they are 0 and 20 and we found the
Kelvin equivalents of those to be these values earlier.

I wrote this one with a `return` because I thought it made the
structure clearer: run one function, save the result, run another
function, save the result, then return what you've got.


(d) Rewrite your Fahrenheit-to-Celsius convertor to take a
suitable default value and check that it works as a default.

Solution


You can choose any default you like. I'll take a default of 68
(what I would call "a nice day"):

```r
f_to_c <- function(F = 68) {
  (F - 32) * 5 / 9
}
f_to_c(68)
```

```
## [1] 20
```

```r
f_to_c()
```

```
## [1] 20
```

     

The change is in the top line of the function. You see the result: if
we run it without an input, we get the same answer as if the input had
been 68.


(e) What happens if you feed your Fahrenheit-to-Celsius convertor
a *vector* of Fahrenheit temperatures? What if you use it in a
`mutate`? 

Solution


Try it and see:

```r
temps <- seq(30, 80, 10)
temps
```

```
## [1] 30 40 50 60 70 80
```

```r
f_to_c(temps)
```

```
## [1] -1.111111  4.444444 10.000000 15.555556 21.111111 26.666667
```

     

Each of the Fahrenheit temperatures gets converted into a Celsius
one. This is perhaps more useful in a data frame, thus:


```r
tibble(temps = seq(30, 80, 10)) %>%
  mutate(celsius = f_to_c(temps))
```

```
## # A tibble: 6 x 2
##   temps celsius
##   <dbl>   <dbl>
## 1    30   -1.11
## 2    40    4.44
## 3    50   10   
## 4    60   15.6 
## 5    70   21.1 
## 6    80   26.7
```

 

All the temperatures are side-by-side with their equivalents.

Here's another way to do the above:


```r
temps <- seq(30, 80, 10)
temps %>%
  enframe(value = "fahrenheit") %>%
  mutate(celsius = f_to_c(temps))
```

```
## # A tibble: 6 x 3
##    name fahrenheit celsius
##   <int>      <dbl>   <dbl>
## 1     1         30   -1.11
## 2     2         40    4.44
## 3     3         50   10   
## 4     4         60   15.6 
## 5     5         70   21.1 
## 6     6         80   26.7
```

 

`enframe` creates a two-column data frame out of a vector (like
`temps`). A vector can have "names", in which case they'll be
used as the `name` column; the values will go in a column
called `value` unless you rename it, as I did.


(f) Write another function called `wrap` that takes two
arguments: a piece of text called `text`, which defaults to
`hello`, and another piece of text called `outside`,
which defaults to `*`. The function returns `text`
with the text `outside` placed before and after, so that
calling the function with the defaults should return
`*hello*`. To do this, you can use `str_c` from
`stringr` (loaded with the `tidyverse`) which places
its text arguments side by side and glues them together into one
piece of text.  Test your function briefly.

Solution


This:

```r
wrap <- function(text = "hello", outside = "*") {
  str_c(outside, text, outside)
}
```

     

I can run this with the defaults:


```r
wrap()
```

```
## [1] "*hello*"
```

 

or with text of my choosing:


```r
wrap("goodbye", "_")
```

```
## [1] "_goodbye_"
```

 

I think that's what I meant by "test briefly".


(g) What happens if you want to change the default
`outside` but use the default for `text`? How do you
make sure that happens? Explore.

Solution


The obvious thing is this, which doesn't work:

```r
wrap("!")
```

```
## [1] "*!*"
```

     

This takes *`text`* to be `!`, and `outside`
to be the default. How do we get `outside` to be `!`
instead? The key is to specify the input by name:


```r
wrap(outside = "!")
```

```
## [1] "!hello!"
```

 

This correctly uses the default for `text`.

If you specify inputs without names, they are
taken to be in the order that they appear in the function
definition. As soon as they get out of order, which typically happens
by using the default for something early in the list, as we did here
for `text`, you have to specify names for anything that comes
after that. These are the names you put on the function's top line.

You can always use names:


```r
wrap(text = "thing", outside = "**")
```

```
## [1] "**thing**"
```

 

and if you use names, they don't even have to be in order:


```r
wrap(outside = "!?", text = "fred")
```

```
## [1] "!?fred!?"
```

 


(h) What happens if you feed your function `wrap` a vector
for either of its arguments? What about if you use it in a
`mutate`? 

Solution


Let's try:

```r
mytext <- c("a", "b", "c")
wrap(text = mytext)
```

```
## [1] "*a*" "*b*" "*c*"
```

     


```r
myout <- c("*", "!")
wrap(outside = myout)
```

```
## [1] "*hello*" "!hello!"
```

 

If one of the inputs is a vector, the other one gets "recycled" as
many times as the vector is long. What if they're both vectors?


```r
mytext2 <- c("a", "b", "c", "d")
wrap(mytext2, myout)
```

```
## [1] "*a*" "!b!" "*c*" "!d!"
```

 

This uses the two inputs in parallel, repeating the short one as
needed. But this, though it works, gives a warning:


```r
wrap(mytext, myout)
```

```
## Warning in stri_c(..., sep = sep, collapse = collapse, ignore_null = TRUE):
## longer object length is not a multiple of shorter object length
```

```
## [1] "*a*" "!b!" "*c*"
```

 

This is because the shorter vector (of length 2 here) doesn't go
evenly into the longer one (length 3). It gives a warning because this
is probably not what you wanted.

The `mutate` thing is easier, because all the columns in a data
frame have to be the same length. `LETTERS` is a vector with
the uppercase letters in it:


```r
tibble(mytext = LETTERS[1:6], myout = c("*", "**", "!", "!!", "_", "__")) %>%
  mutate(newthing = wrap(mytext, myout))
```

```
## # A tibble: 6 x 3
##   mytext myout newthing
##   <chr>  <chr> <chr>   
## 1 A      *     *A*     
## 2 B      **    **B**   
## 3 C      !     !C!     
## 4 D      !!    !!D!!   
## 5 E      _     _E_     
## 6 F      __    __F__
```

 





##  The Collatz sequence


 The Collatz sequence is a sequence of integers $x_1, x_2,
\ldots$ defined in a
deceptively simple way: if $x_n$ is the current term of the sequence,
then $x_{n+1}$ is defined as $x_n/2$ if $x_n$ is even, and $3x_n+1$ if
$x_n$ is odd.
We are interested in understanding how this sequence
behaves; for example, what happens to it as $n$ gets large, for
different choices of the first term $x_1$? We will explore this
numerically with R; the ambitious among you might like to look into
the mathematics of it.



(a) What happens to the sequence when it reaches 4? What would be
a sensible way of defining where it ends? Explain briefly.

Solution


When the sequence reaches 4 (that is, when its current term is 4),
the next term is 2 and the one after that is 1. Then the following
term is 4 again ($(3 \times 1)+1$) and then it repeats
indefinitely, $4, 2, 1, 4, 2, 1, \ldots$. 
I think a sensible way to define where the sequence ends is to say
"when it reaches 1", since if you start at 2 you'll never reach
4 (so "when it reaches 4" won't work), and it seems at least
plausible that it will hit the cycle 4, 2, 1 sometime.


(b) Write an R function called `is_odd` that returns
`TRUE` if its input is an odd number and `FALSE` if it
is even (you can assume that the input is an integer and not a
decimal number). To do *that*, you can use the function `%%` where 
`a %% b` is the remainder when `a` is divided by
`b`. To think about oddness or evenness, consider the
remainder when you divide by 2.

Solution


Let's try this out. For example, 5 is odd and 6 is even, so

```r
5 %% 2
```

```
## [1] 1
```

```r
6 %% 2
```

```
## [1] 0
```

     

When a number is odd, its remainder on dividing by 2 is 1, and when
even, the remainder is 0. There is an additional shortcut here in that
1 is the numeric value of `TRUE` and 0 of `FALSE`, so
all we have to do is calculate the remainder on dividing by 2, turn it
into a `logical`, and return it:


```r
is_odd <- function(x) {
  r <- x %% 2
  as.logical(r)
}
```

 

You probably haven't seen `as.logical` before, but it's the
same idea as `as.numeric`: turn something that looks like a
`TRUE` or `FALSE` into something that actually
*is*. 

We should test it:


```r
is_odd(19)
```

```
## [1] TRUE
```

```r
is_odd(12)
```

```
## [1] FALSE
```

```r
is_odd(0)
```

```
## [1] FALSE
```

 

0 is usually considered an even number, so this is good.


(c) Write an R function called
`hotpo1`
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">*Hotpo* is short for half or triple-plus-one.</span> 
that takes an
integer as input and returns the next number in the Collatz
sequence. To do this, use the function you just wrote that
determines whether a number is even or odd.

Solution


The logic is "if the input is odd, return 3 times it plus 1, otherwise return half of it". 
The R structure is an
`if-then-else`: 

```r
hotpo1 <- function(x) {
  if (is_odd(x)) 3 * x + 1 else x / 2
}
```

     

In R, the condition that is tested goes in brackets, and then if the
value-if-true and the value-if-false are single statements, you just
type them. (If they are more complicated than that, you put them in
curly brackets.) Now you see the value of writing `is_odd`
earlier; this code almost looks like the English-language description
of the sequence. If we had not written `is_odd` before, the
condition would have looked something like 


```r
if (x %% 2 == 1) 3 * x + 1 else x / 2
```

 

which would have been a lot harder to read.

All right, let's try that out:


```r
hotpo1(4)
```

```
## [1] 2
```

```r
hotpo1(7)
```

```
## [1] 22
```

```r
hotpo1(24)
```

```
## [1] 12
```

 

That looks all right so far.


(d) Now write a function `hotpo` that will return the whole
Collatz sequence for an input $x_1$. For this, assume that you will
eventually get to 1.

Solution


This is a loop, but not a `for` loop (or something that we
could do with a `map`), because we don't know how many
times we have to go around. This is the kind of thing that we
should use a `while` loop for: 
"keep going while a condition is true".
In this case, we should keep going if we haven't reached 1 yet. If
we haven't reached 1, we should generate the next value of the
sequence and glue it onto what we have so far. To initialize the
sequence, we start with the input value. There is an R trick to
glue a value onto the sequence, which is to use `c` with a
vector and a value, and save it back into the vector:

```r
hotpo <- function(x) {
  sequence <- x
  term <- x
  while (term > 1) {
    term <- hotpo1(term)
    sequence <- c(sequence, term)
  }
  sequence
}
```

     
I use `term` to hold the current term of the sequence, and
overwrite it with the next one (since I don't need the old one any
more). 

Does it work?


```r
hotpo(4)
```

```
## [1] 4 2 1
```

```r
hotpo(12)
```

```
##  [1] 12  6  3 10  5 16  8  4  2  1
```

```r
hotpo(97)
```

```
##   [1]   97  292  146   73  220  110   55  166   83  250  125  376  188   94
##  [15]   47  142   71  214  107  322  161  484  242  121  364  182   91  274
##  [29]  137  412  206  103  310  155  466  233  700  350  175  526  263  790
##  [43]  395 1186  593 1780  890  445 1336  668  334  167  502  251  754  377
##  [57] 1132  566  283  850  425 1276  638  319  958  479 1438  719 2158 1079
##  [71] 3238 1619 4858 2429 7288 3644 1822  911 2734 1367 4102 2051 6154 3077
##  [85] 9232 4616 2308 1154  577 1732  866  433 1300  650  325  976  488  244
##  [99]  122   61  184   92   46   23   70   35  106   53  160   80   40   20
## [113]   10    5   16    8    4    2    1
```

 

97 is a wild ride, but it does eventually get to 1. 

Extra: where I originally saw this, which was "Metamagical Themas"
by Douglas Hofstadter, he was illustrating the programming language
Lisp and the process of recursion, whereby you define a function in
terms of itself. This one is a natural for that, because the Collatz
sequence starting at $x$ is $x$ along with the Collatz sequence
starting at the next term. For example, if you start at 12, the next
term is 6, so that the Collatz sequence starting at 12 is 12 followed by
the Collatz sequence starting at 6. There is no dependence any further
back. You can do recursion in R also; there is no problem with a
function calling itself:


```r
hotpo_rec <- function(x) {
  if (x == 1) 1 else c(x, hotpo_rec(hotpo1(x)))
}
```

 

Recursive functions have two parts: a "base case" that says how you
know you are done (the 1 here), and a "recursion" that says how you
move to a simpler case, here working out the next term, getting the
whole sequence for that, and gluing the input onto the front. It seems
paradoxical that you define a function in terms of itself, but what
you are doing is calling a simpler sequence, in this case one that is
length one shorter than the sequence for the original input. Thus, we
hope,
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">Nobody knows whether you *always* get to 1, but also nobody has ever found a case where you don't. Collatz's conjecture, that you will get to 1 eventually, is known to be true for all starting $x_1$ up to some absurdly large number, but not for *all* starting points.</span>
we will eventually reach 1.

Does it work?


```r
hotpo_rec(12)
```

```
##  [1] 12  6  3 10  5 16  8  4  2  1
```

```r
hotpo_rec(97)
```

```
##   [1]   97  292  146   73  220  110   55  166   83  250  125  376  188   94
##  [15]   47  142   71  214  107  322  161  484  242  121  364  182   91  274
##  [29]  137  412  206  103  310  155  466  233  700  350  175  526  263  790
##  [43]  395 1186  593 1780  890  445 1336  668  334  167  502  251  754  377
##  [57] 1132  566  283  850  425 1276  638  319  958  479 1438  719 2158 1079
##  [71] 3238 1619 4858 2429 7288 3644 1822  911 2734 1367 4102 2051 6154 3077
##  [85] 9232 4616 2308 1154  577 1732  866  433 1300  650  325  976  488  244
##  [99]  122   61  184   92   46   23   70   35  106   53  160   80   40   20
## [113]   10    5   16    8    4    2    1
```

 

It does.

Recursive functions are often simple to understand, but they are not
always very efficient. They can take a lot of memory, because they
have to handle the intermediate calls to the function, which they have
to save to use later (in the case of `hotpo_rec(97)` there are a
lot of those). Recursive functions are often paired with a technique
called "memoization", where each time you calculate the function's
value, you *save* it in another array. The first thing you do in
the recursive function is to check whether you already have the
answer, in which case you just look it up and return it. It was a lot
of work here to calculate the sequence from 97, but if we had saved
the results, we would already have the answers for 292, 146, 73, 220
and so on, and getting those later would be a table lookup rather than
another recursive calculation.


(e) Write two (very small) functions that take an entire sequence
as input and return (i) the length of the sequence and (ii) the
maximum value it attains.

Solution


These are both one-liners. Call the input whatever you like:


```r
hotpo_len <- function(sequence) length(sequence)
hotpo_max <- function(sequence) max(sequence)
```

 

Because they are one-liners, you don't even need the curly brackets,
although there's no problem if they are there.

Testing:


```r
hotpo_len(hotpo(12))
```

```
## [1] 10
```

```r
hotpo_max(hotpo(97))
```

```
## [1] 9232
```

 

This checks with what we had before.


(f) Make a data frame consisting of the values 11 through 20, and,
using `tidyverse` ideas, obtain a data frame containing the
Collatz sequences starting at each of those values, along with their
lengths and their maximum values. Which sequence is longest? Which
one goes up highest?

Solution


This one uses `map` ideas: an actual `map` for the
sequence, and `map_dbl` for the length and maximum value,
since these are both actually integers but the calculation in our
functions actually uses decimals.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">I should have been more careful in my functions to make sure everything was integers, and, in particular, to do integer division by 2 because I knew that this division was going to come out even.</span> 
Thus, a pipeline:

```r
tibble(x = 11:20) %>%
  mutate(sequence = map(x, ~ hotpo(.))) %>%
  mutate(length = map_dbl(sequence, ~ hotpo_len(.))) %>%
  mutate(high = map_dbl(sequence, ~ hotpo_max(.)))
```

```
## # A tibble: 10 x 4
##        x sequence   length  high
##    <int> <list>      <dbl> <dbl>
##  1    11 <dbl [15]>     15    52
##  2    12 <dbl [10]>     10    16
##  3    13 <dbl [10]>     10    40
##  4    14 <dbl [18]>     18    52
##  5    15 <dbl [18]>     18   160
##  6    16 <dbl [5]>       5    16
##  7    17 <dbl [13]>     13    52
##  8    18 <dbl [21]>     21    52
##  9    19 <dbl [21]>     21    88
## 10    20 <dbl [8]>       8    20
```

     

First, we obtain a list-column containing the sequences, then two
ordinary columns of their lengths and their maximum values. The
`map` is the same each time: for each of the first thing, run
the function on *it*, where "it" is represented by the dot.

The sequences for 18 and 19 are the longest, but the sequence for 15
goes up the highest.



