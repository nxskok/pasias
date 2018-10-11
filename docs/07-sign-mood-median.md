# The sign test and Mood's median test


```r
library(tidyverse)
```

```
## ── Attaching packages ─────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
## ✔ readr   1.1.1     ✔ forcats 0.3.0
```

```
## ── Conflicts ────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

```r
library(smmr)
```





 A researcher is trying to design a maze that can be run by
rats in about 60 seconds. One particular maze was run by a sample of
21 rats, with the times shown in
[http://www.utsc.utoronto.ca/~butler/c32/maze.txt](http://www.utsc.utoronto.ca/~butler/c32/maze.txt). 



(a) Read the data into R. What (if anything) are the data values
delimited by?

Solution


Take a look at the data file first. There is only one column of
data, so you can treat it as being delimited by anything you like:
a space, or a comma (the file can also be treated as a
`.csv`), etc.:

```r
myurl="http://www.utsc.utoronto.ca/~butler/c32/maze.txt"
times=read_delim(myurl," ")
```

```
## Parsed with column specification:
## cols(
##   time = col_double()
## )
```

```r
times
```

```
## # A tibble: 21 x 1
##     time
##    <dbl>
##  1  38.4
##  2  46.2
##  3  62.5
##  4  38  
##  5  62.8
##  6  33.9
##  7  50.4
##  8  35  
##  9  52.8
## 10  60.1
## # ... with 11 more rows
```



(b) Run a sign test, doing it yourself as we did in class:
count the number of values above and below 60, take the *smaller*
of those, and find the probability of a value of that or smaller still
on a binomial distribution with $n=21$ and $p=0.5$ (we have 21 data
points), doubling the answer because the test is two-sided.



Solution



Count how many values are above and below 60:


```r
times %>% count(time>60)
```

```
## # A tibble: 2 x 2
##   `time > 60`     n
##   <lgl>       <int>
## 1 FALSE          16
## 2 TRUE            5
```
5 above and 16 below. Then find out how likely it is that a binomial
with $n=21, p=0.5$ would produce 5 or fewer successes:


```r
p=sum(dbinom(0:5,21,0.5))
p
```

```
## [1] 0.01330185
```

or if you prefer count upwards from 16:


```r
sum(dbinom(16:21,21,0.5))
```

```
## [1] 0.01330185
```

and double it to get a two-sided P-value:


```r
2*p  
```

```
## [1] 0.0266037
```

We'll compare this with `smmr` in a moment.




(c) Install my package `smmr`, if you haven't already. To do
this, you first need to install the package `devtools` (if you
haven't already),
by going to the console and typing


```r
install.packages("devtools")
```

When that's all done, install `smmr` thus:


```r
library(devtools)
install_github("nxskok/smmr")
```

That all needs to be done only once. Then, each R Studio session where
you want to use `smmr` needs this:


```r
library(smmr)
```

As usual, only the `library` thing only needs to be done every
time. 

When you have `smmr` installed, use `sign_test` from
that package to re-run your sign test. Do you get the same P-value?



Solution


The sign test function takes a data frame, an (unquoted) column
name from that data frame of data to test the median of, and a
null median (which defaults to 0 if you omit it):

```r
library(smmr)
sign_test(times,time,60)
```

```
## $above_below
## below above 
##    16     5 
## 
## $p_values
##   alternative    p_value
## 1       lower 0.01330185
## 2       upper 0.99640131
## 3   two-sided 0.02660370
```

This shows you two things: a count of the values below and above the
null median, and then the P-values according to the various
alternative hypotheses you might have. 

In our case, we see again the 16 maze-running times below 60 seconds
and 5 above (one of which was a long way above, but we don't care
about that here). We were testing whether the median was different
from 60, so we look at the two-sided P-value of 0.0266, which is
exactly what we had before.

If `sign_test` doesn't work for you (perhaps because it needs
a function `enquo` that you don't have), there is an
alternative function `sign_test0` that doesn't use it. It
requires as input a *column* of values (extracted from the data
frame) and a null median, thus:


```r
sign_test0(times$time,60)
```

```
## $above_below
## below above 
##    16     5 
## 
## $p_values
##   alternative    p_value
## 1       lower 0.01330185
## 2       upper 0.99640131
## 3   two-sided 0.02660370
```

The output should be, and here is, identical.




(d) Package `smmr` also has a function
`pval_sign`, which has the same input as
`sign_test`, but with the null median *first*.
Run it on your data and see what it gives.



Solution


Try it and see:

```r
pval_sign(60,times,time)
```

```
## [1] 0.0266037
```

The two-sided P-value, and that is all. We'll be using this in a minute.

Alternatively, there is also this, which needs a null median and a
*column* as input:


```r
pval_sign0(60,times$time)
```

```
## [1] 0.0266037
```




(e) Obtain a 95\% confidence interval for the median based on these
data. Do this two ways. First, use the trial and error way from class
(either the try-lots-of-values way or the bisection way; either is good).
Second, use `ci_median` from `smmr`. The latter takes
as input a data frame, a column name (unquoted) and optionally a
`conf.level` that defaults to 0.95.



Solution


The reason for showing you `pval_sign` in the previous
part is that this is a building block for the confidence interval.
What we do is to try various null medians
and find out which ones give P-values less than 0.05 (outside the
interval) and which ones bigger (inside). 
We know that the value 60 is
outside the 95\% CI, and the sample median is close to 50 (which we
expect to be inside), so sensible values to try for the upper end of
the interval would be between 50 and 60:


```r
pval_sign(58,times,time)
```

```
## [1] 0.0266037
```

```r
pval_sign(55,times,time)
```

```
## [1] 0.6636238
```

So, 55 is inside the interval and 58 is outside. I could investigate
further in similar fashion, but I thought I would try a whole bunch of null
medians all at once. That goes like this:


```r
meds=seq(55,58,0.25)
meds
```

```
##  [1] 55.00 55.25 55.50 55.75 56.00 56.25 56.50 56.75 57.00 57.25 57.50
## [12] 57.75 58.00
```

```r
pvals=map_dbl(meds,pval_sign,times,time)
data.frame(meds,pvals)
```

```
##     meds      pvals
## 1  55.00 0.66362381
## 2  55.25 0.38331032
## 3  55.50 0.26317596
## 4  55.75 0.18924713
## 5  56.00 0.18924713
## 6  56.25 0.18924713
## 7  56.50 0.07835388
## 8  56.75 0.07835388
## 9  57.00 0.07835388
## 10 57.25 0.07835388
## 11 57.50 0.07835388
## 12 57.75 0.02660370
## 13 58.00 0.02660370
```

So values for the median all the way up to and including 57.5 are in
the confidence interval.

What `map_dbl` does is to take a vector of values, here the
ones in `meds` (55 through 58 in steps of 0.25), feed them into
a function, here `pval_sign`, one by one and gather together
the results. `pval_sign` has two other inputs, `times` and
`time`, which are added to `map_dbl` at the end. (They
are the same no matter what median we are testing.)  So, putting the
calculated P-values side by side with the null medians they belong to
shows you which medians are inside the confidence interval and which
are outside.

The function is called `map_dbl` because *my* function
called `pval_sign` that is called repeatedly returns a single
decimal number (a `dbl`). There is also, for example,
`map_chr` for repeatedly calling a function that returns a
single piece of text, and plain `map` that is used when the
repeatedly-called function returns a data frame.

Since you don't know about `map_dbl`, I didn't want to confuse
things more than necessary, but now that you *do* know what it
does, you might be in a better position to understand this more
Tidyverse-flavoured code, with the `map_dbl` inside a
`mutate` and the data frame created as we go:


```r
tibble(meds=seq(55,58,0.25)) %>%
mutate(pvals=map_dbl(meds,pval_sign,times,time)) 
```

```
## # A tibble: 13 x 2
##     meds  pvals
##    <dbl>  <dbl>
##  1  55   0.664 
##  2  55.2 0.383 
##  3  55.5 0.263 
##  4  55.8 0.189 
##  5  56   0.189 
##  6  56.2 0.189 
##  7  56.5 0.0784
##  8  56.8 0.0784
##  9  57   0.0784
## 10  57.2 0.0784
## 11  57.5 0.0784
## 12  57.8 0.0266
## 13  58   0.0266
```

Now for the other end of the interval. I'm going to do this a
different way: more efficient, but less transparent. The first thing I
need is a pair of values for the median: one inside the interval and
one outside. Let's try 40 and 50:


```r
pval_sign(40,times,time)
```

```
## [1] 0.00719738
```

```r
pval_sign(50,times,time)
```

```
## [1] 1
```

OK, so 40 is outside and 50 is inside. So what do I guess for the next
value to try? I could do something clever like assuming that the
relationship between hypothesized median and P-value is *linear*,
and then guessing where that line crosses 0.05. But I'm going to
assume *nothing* about the relationship except that it goes
uphill, and therefore crosses 0.05 somewhere. So my next guess is
halfway between the two values I tried before:


```r
pval_sign(45,times,time)
```

```
## [1] 0.07835388
```

So, 45 is inside the interval, and my (slightly) improved guess at the
bottom end of the interval is that it's between 40 and 45. So next, I
try halfway between *those*:


```r
pval_sign(42.5,times,time)
```

```
## [1] 0.0266037
```

42.5 is outside, so the bottom end of the interval is between 42.5 and 45.

What we are doing is narrowing down where the interval's bottom end
is. We started by knowing it to within 10, and now we know it to
within 2.5. So if we keep going, we'll know it as accurately as we wish.

This is called a "bisection" method, because at each step, we're
dividing our interval by 2.

There is one piece of decision-making at each step: if the P-value for
the median you try is greater than 0.05, that becomes the top end of
your interval (as when we tried 45); if it is less, it becomes the
bottom end (when we tried 42.5).

This all begs to be automated into a loop. It's not a
`for`-type loop, because we don't know how many times we'll be
going around. It's a `while` loop: keep going while something
is true. Here's how it goes:


```r
lo=40
hi=50
while(abs(hi-lo)>0.1) {
try=(hi+lo)/2
ptry=pval_sign(try,times,time)
print(c(try,ptry))
if (ptry<0.05) {
lo=try
} else {
hi=try
}
}
```

```
## [1] 45.00000000  0.07835388
## [1] 42.5000000  0.0266037
## [1] 43.7500000  0.0266037
## [1] 44.37500000  0.07835388
## [1] 44.0625000  0.0266037
## [1] 44.2187500  0.0266037
## [1] 44.2968750  0.0266037
```

```r
lo
```

```
## [1] 44.29688
```

```r
pval_sign(lo,times,time)
```

```
## [1] 0.0266037
```

```r
hi
```

```
## [1] 44.375
```

```r
pval_sign(hi,times,time)
```

```
## [1] 0.07835388
```

The loop stopped because 44.297 and 44.375 are less than 0.1
apart. The first of those is outside the interval and the second is
inside. So the bottom end of our interval is 44.375, to this
accuracy. If you want it more accurately, change 0.1 in the
`while` line to something smaller (but then you'll be waiting
longer for the answer). 

I put the `print` statement in the loop so that you could see
what values were being tried, and what P-values they were
producing. What happens with these is that the P-value jumps at each
data value, so you won't get a P-value exactly 0.05; you'll get one
above and one below.

Likewise, you can use the function with a zero on its name and feed it
a column rather than a data frame and a column name:


```r
meds=seq(55,58,0.25)
meds
```

```
##  [1] 55.00 55.25 55.50 55.75 56.00 56.25 56.50 56.75 57.00 57.25 57.50
## [12] 57.75 58.00
```

```r
pvals=map_dbl(meds,pval_sign0,times$time)
data.frame(meds,pvals)
```

```
##     meds      pvals
## 1  55.00 0.66362381
## 2  55.25 0.38331032
## 3  55.50 0.26317596
## 4  55.75 0.18924713
## 5  56.00 0.18924713
## 6  56.25 0.18924713
## 7  56.50 0.07835388
## 8  56.75 0.07835388
## 9  57.00 0.07835388
## 10 57.25 0.07835388
## 11 57.50 0.07835388
## 12 57.75 0.02660370
## 13 58.00 0.02660370
```

Or adapt the idea I had above for bisection.
All that was a lot of work, but I wanted you to see it all once, so that you
know where the confidence interval is coming from. `smmr` also
has a function `ci_median` that does all of the above without
you having to do it. As I first wrote it, it was using the trial and
error thing with `map_dbl`, but I chose to rewrite it with the
bisection idea, because I thought that would be more accurate.


```r
ci_median(times,time)
```

```
## [1] 44.30747 57.59766
```

This is a more accurate interval than we got above. (The
`while` loop for the bisection keeps going until the two
guesses at the appropriate end of the interval are less than 0.01
apart, by default.)\endnote{You can change this by adding something
like `tol=1e-4` to the end of your `ci_median`.} 

If you want some other confidence level, you add `conf.level`
on the end, as you would for `t.test`:


```r
ci_median(times,time,conf.level=0.75)
```

```
## [1] 46.20444 55.49473
```

A 75\% CI, just for fun. This is a shorter interval than the 95\% one,
as it should be.

Likewise there is a `ci_median0` that takes a column and an
optional confidence level:


```r
ci_median0(times$time)
```

```
## [1] 44.30747 57.59766
```

```r
ci_median0(times$time,conf.level=0.75)
```

```
## [1] 46.20444 55.49473
```

with the same results. Try `ci_median` first, and if it
doesn't work, try `ci_median0`.








 A famous cookie manufacturer claims that
their bags of chocolate chip cookies contain ``more than 1100
chocolate chips on average''. A diligent group of students buys 16
bags of these cookies and counts the number of chocolate chips in each
bag. The results are in [http://www.utsc.utoronto.ca/~butler/c32/chips.txt](http://www.utsc.utoronto.ca/~butler/c32/chips.txt).



(a) Read in and display (some of) the data.


Solution


I'll pretend it's a
`.csv` this time, just for fun.  Give the data frame a
name different from `chips`, so that you don't get
confused:

```r
bags=read_csv("chips.txt")
```

```
## Parsed with column specification:
## cols(
##   chips = col_integer()
## )
```

```r
bags
```

```
## # A tibble: 16 x 1
##    chips
##    <int>
##  1  1219
##  2  1214
##  3  1087
##  4  1200
##  5  1419
##  6  1121
##  7  1325
##  8  1345
##  9  1244
## 10  1258
## 11  1356
## 12  1132
## 13  1191
## 14  1270
## 15  1295
## 16  1135
```

That looks sensible.       



(b) Build your own sign test in R for testing that the median is
1100 chocolate chips, against the alternative that it is greater.
(Do this as in class: count the appropriate thing,
compare it with an appropriate binomial distribution, and obtain a
P-value.


Solution


The null median is 1100, so we count the number
of values above and below:


```r
bags %>% count(chips<1100)
```

```
## # A tibble: 2 x 2
##   `chips < 1100`     n
##   <lgl>          <int>
## 1 FALSE             15
## 2 TRUE               1
```

The un-standard thing there is that we can put a logical condition
directly into the `count`. If you don't think of that, you can
also do this, which creates a new variable `less` that is
`TRUE` or `FALSE` for each bag appropriately:


```r
bags %>% mutate(less=(chips<1100)) %>% count(less)
```

```
## # A tibble: 2 x 2
##   less      n
##   <lgl> <int>
## 1 FALSE    15
## 2 TRUE      1
```

or the more verbose


```r
bags %>% mutate(less=(chips<1100)) %>%
group_by(less) %>% summarize(howmany=n())
```

```
## # A tibble: 2 x 2
##   less  howmany
##   <lgl>   <int>
## 1 FALSE      15
## 2 TRUE        1
```

Just one value below, with all the rest above. 
Getting the right P-value, properly, requires some careful thought
(but you will probably get the right answer anyway). If the
alternative hypothesis is true, and the median is actually bigger than
1100 (say, 1200), you would expect half the data values to be bigger
than 1200 and half smaller. So *more* than half the data values
would be bigger than *1100*, and fewer than half of them would be
less than 1100. So, if we are going to reject the null (as it looks as
if we will), that small number of values below 1100 is what we want.

The P-value is the probability of a value 1 or less in a binomial
distribution with $n=16, p=0.5$:


```r
sum(dbinom(0:1,16,0.5))
```

```
## [1] 0.0002593994
```

Or, equivalently, count *up* from 15:


```r
sum(dbinom(15:16,16,0.5))
```

```
## [1] 0.0002593994
```

This is correctly one-sided, so we don't have to do anything with
it. 



(c) Use my R package `smmr` to reproduce your sign test
above, and verify that you get consistent results. (See the
maze-design question for instructions on installing this, if you
haven't yet.)


Solution


This will mean reading the output carefully:

```r
library(smmr)
sign_test(bags,chips,1100)
```

```
## $above_below
## below above 
##     1    15 
## 
## $p_values
##   alternative      p_value
## 1       lower 0.9999847412
## 2       upper 0.0002593994
## 3   two-sided 0.0005187988
```

This time, we're doing a one-sided test, specifically an
*upper-tail* test, since we are looking for evidence that the
median is *greater than* 1100. The results are exactly what we
got "by hand": 15 values above and one below, and a P-value (look
along the `upper` line) of 0.00026.
 The two-sided P-value of 0.00052 rounds to the same 0.0005 as SAS got.

Alternatively, you can do this:


```r
sign_test0(bags$chips,1100)
```

```
## $above_below
## below above 
##     1    15 
## 
## $p_values
##   alternative      p_value
## 1       lower 0.9999847412
## 2       upper 0.0002593994
## 3   two-sided 0.0005187988
```

with the same result (but only go this way if you need to).



(d) Use `smmr` to obtain a 95\% confidence interval for the
median number of chocolate chips per bag of cookies.


Solution


Once everything is in place, this is simplicity itself:

```r
ci_median(bags,chips)
```

```
## [1] 1135.003 1324.996
```

1135 to 1325. I would round these off to whole numbers, since the data
values are all whole numbers. These values are all above 1100, which
supports the conclusion we got above that the median is above
1100. This is as it should be, because the CI is ``all those medians
that would *not* be rejected by the sign test''. 

Or, 


```r
ci_median0(bags$chips)
```

```
## [1] 1135.003 1324.996
```









 I've mentioned several times that the sign test has less
power than the $t$-test. Let's investigate this with a specific example.

Let's suppose we are testing $H_0: \mu=40$ against $H_a: \mu \ne 40$,
where $\mu$ is the population mean (and median, as we shall see). Our
population actually has a normal distribution with mean 50 and SD 15,
so that the null hypothesis is *wrong* and we want to reject it
most of the time. On the other hand, the population actually *is*
normally-distributed and so the $t$-test is the right one to use.

(This is an old question, so I tackle the simulated power differently
than I did it in class this time. But see if you can follow what I do
here.)



(a) Use `power.t.test` to find the probability that a
$t$-test correctly rejects the null hypothesis using a sample size
of $n=10$.


Solution



```r
power.t.test(delta=50-40,n=10,sd=15,type="one.sample",alternative="two.sided")
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 10
##           delta = 10
##              sd = 15
##       sig.level = 0.05
##           power = 0.4691805
##     alternative = two.sided
```

The power is 0.469. Not great, but we'll see how this stacks up
against the sign test.




(b) What code in R would draw a random sample of size 10 from the
*true* population distribution and save the sample in a variable?



Solution


The data actually have a normal distribution with mean 50 and
SD 15, so we use `rnorm` with this mean and SD, obtaining
10 values:

```r
x=rnorm(10,50,15)  
x
```

```
##  [1] 50.56866 44.78518 49.89290 35.70511 56.74026 37.23364 48.58599
##  [8] 54.90412 48.41221 55.52626
```




(c) What code would count how many of the sampled values are less
than 40 and how many are greater (or equal)? 



Solution


 The way we know this is to put `x` into a data frame first:

```r
tibble(x) %>% count(x<40)
```

```
## # A tibble: 2 x 2
##   `x < 40`     n
##   <lgl>    <int>
## 1 FALSE        8
## 2 TRUE         2
```

2 values less (and 8 greater-or-equal).




(d) It turns out the sign test would reject $H_0: M=40$ against
$H_a: M \ne 40$ at $\alpha=0.05$ if the smaller of the numbers in the
last part is 1 or less. ($M$ is the population median.) 
Add to your pipeline to obtain `TRUE`
if you should reject the null for your
data and `FALSE` otherwise. 



Solution


This is actually easier than you might think. The output from
`count` is a data frame with a column called `n`,
whose minimum value you want. I add to my pipeline:

```r
tibble(x) %>% count(x<40) %>%
summarize(the_min=min(n)) %>%
mutate(is_rejected=(the_min<=1))
```

```
## # A tibble: 1 x 2
##   the_min is_rejected
##     <dbl> <lgl>      
## 1       2 FALSE
```

This will fail sometimes. If all 10 of your sample values are greater
than 40, which they might turn out to be, you'll get a table with only
one line, `FALSE` and 10; the minimum of the `n` values
is 10 (since there is only one), and it will falsely say that you
should not reject. The fix is


```r
tibble(x) %>% count(x<40) %>%
summarize(the_min=min(n)) %>%
mutate(is_rejected=(the_min<=1 | the_min==10))
```

```
## # A tibble: 1 x 2
##   the_min is_rejected
##     <dbl> <lgl>      
## 1       2 FALSE
```

The above is almost the right thing, but not quite: we only want that value
that I called `is_rejected`, rather than the whole data frame,
so a `pull` will grab it:


```r
tibble(x) %>% count(x<40) %>%
summarize(the_min=min(n)) %>%
mutate(is_rejected=(the_min<=1 | the_min==10)) %>%
pull(is_rejected)
```

```
## [1] FALSE
```

You might be wondering where the "1 or less" came from. Getting a
P-value for the sign test involves the binomial distribution: if the
null is correct, each data value is independently either above or
below 40, with probability 0.5 of each, so the number of values below
40 (say) is binomial with $n=10$ and $p=0.5$. The P-value for 1
observed value below 40 and the rest above is


```r
2*pbinom(1,10,0.5)  
```

```
## [1] 0.02148438
```

which is less than 0.05; the P-value for 2 values below 40 and the
rest above is 


```r
2*pbinom(2,10,0.5)    
```

```
## [1] 0.109375
```

which is bigger than 0.05. 

You might have encountered the term "critical region" for a
test. This is the values of your test statistic that you would reject
the null hypothesis for. In this case, the critical region is 1 and 0
observations below 40, along with 1 and 0 observations above 40.

When you're thinking about power, I think it's easiest to think in
terms of the critical region (rather than directly in terms of
P-values) since you have a certain $\alpha$ in mind all the way
through, 0.05 in the power examples that I've done. The steps are then:



* Work out the critical region for your test, the values of the
test statistic (or sample mean or sample count) that would lead to
rejecting the null hypothesis.


* Under your particular alternative hypothesis, find the
probability of falling into your critical region.


When I say "work out", I mean either calculating (along the lines of
STAB57), or simulating, as we have done here.



(e) Use `rerun` to simulate the above process 1000 times:
drawing a random sample from a normal distribution with mean 50 and SD
15, counting the number of values below and above 40, rejecting if the
minimum of those is 1 or less, then counting the number of rejections
out of 1000.



Solution


The way we've used `rerun` is to use it to select the
random samples, and then we use `map` ideas to do what we
want to do with each random sample, along the lines of what we did
with the one random sample above.
This is liable to go wrong the first few times, so make sure that
each line works before you go on to the next. (`rerun` will
produce you a `list` of random samples, with each of which
you want to do something.) While you're debugging, try it with a
small number of random samples like 5.
I start with setting the random number seed, so it comes out the
same each time. I discuss the results below and the code below that.

```r
set.seed(457299)
rerun(1000,rnorm(10,50,15)) %>% 
map(~tibble(x=.)) %>% 
map(~count(.,x<40)) %>% 
map(~summarize(.,the_min=min(n))) %>% 
map(~mutate(.,is_rejected=(the_min<=1 | the_min==10))) %>% 
map_lgl(~pull(.,is_rejected)) %>% 
tibble(was_true=.) %>% 
count(was_true)
```

```
## # A tibble: 2 x 2
##   was_true     n
##   <lgl>    <int>
## 1 FALSE      757
## 2 TRUE       243
```

The estimated power of the sign test is 0.243, since that was the
number of times a simulated sample gave us 0 or 1 values above or
below 40 (and the rest on the other side).

All right, that code is seriously scary. Let me try to take you
through it.



* The `rerun` line is the same kind of thing we had before:
generate 1000 different random samples of size 10 from a normal
distribution with mean 50 and SD 15.

* The output from the previous step is a `list` of
vectors. But we like data frames to count things in, so for each
vector we turn it into a data frame, filling a column called
`x` with whatever was in each vector (that random sample). So
now we have 1000 data frames each containing a column called
`x`.

* Next, in each of those data frames, count up how many of the
`x` values are less than 40. This will produce a data frame
each time containing a column `n` that is the
frequencies. Here and below, the `.`  is used to denote
"it": that is, each of the elements of the list created originally
by `rerun` that we are doing something with. Also, at the
moment, the output for each element of the list is a data frame, so
we stick with `map` for the time being.

* Next, for each of those tables of frequencies, find the smallest
one and call it `the_min`. (As discussed above, all the
values might be bigger than 40, in which case `the_min` will
be 10 rather than 0, which we handle next.)

* Next, we create a new column called `is_rejected` which
says that we should reject a median of 40 if the minimum value we
just calculated is 1 or less, or if it happens to be 10, in which
case that would have been the only entry in the frequency table, so
that the missing one would have been zero.

* Next, we pull out only the true-or-false value in
`is_rejected`. At last, the answer here is not a data frame
but a simple logical value; `map_lgl` is like
`map_dbl` except that the thing we are doing returns a
`TRUE` or a `FALSE` rather than a number.

* At this point we have a vector of 1000 true-or-false. We want to
count them, so we put them into a data frame (with a column called
`was_true`), and in the last line, count them up. There are
243 (correct) rejections and 757 (incorrect) non-rejections.


You may now breathe again. 

I'm now thinking a better way to do this is to write a function that
takes a sample (in a vector) and returns a TRUE or FALSE according to
whether or not a median of 40 would be rejected for that sample:


```r
is_reject=function(x) {
tibble(x=x) %>%
count(x<40) %>%
summarize(the_min=min(n)) %>%
mutate(is_rejected=the_min<=1 | the_min==10) %>%
pull(is_rejected)
}
```

Now, we have to use that. This function will be "mapped" over for
each of the random samples that come out of `rerun`, but now
there will be only one `map` because the complication of the
multiple `maps` has been subsumed into this one function. I'll
set my random number seed so that I get the same results as before:


```r
set.seed(457299)
rerun(1000,rnorm(10,50,15)) %>%
map_lgl(~is_reject(.)) %>%
tibble(rejected=.) %>%
count(rejected)
```

```
## # A tibble: 2 x 2
##   rejected     n
##   <lgl>    <int>
## 1 FALSE      757
## 2 TRUE       243
```

Same results, and yeah, I like that a lot better.



(f) Which is more powerful in this case, the sign test or the
$t$-test? How do you know?



Solution


The power of the sign test is estimated as 0.243, which is quite a bit less
than the power of the $t$-test, which we found back in (a) to be
0.469. So the $t$-test, in this situation where it is valid, is
the right test to use: it is (a) valid and (b) more powerful.
So the $t$-test is more powerful. One way to think about how
*much* more powerful is to ask ``how much smaller of a sample
size would be needed for the $t$-test to have the same power as
this sign test?'' The power of my sign test was 0.243, so in
`power.t.test` we set
`power` equal to that and
omit the sample size `n`:


```r
power.t.test(delta=50-40,power=0.243,sd=15,type="one.sample",alternative="two.sided")
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 5.599293
##           delta = 10
##              sd = 15
##       sig.level = 0.05
##           power = 0.243
##     alternative = two.sided
```
A sample of size 6 gives the same power for the $t$-test that a
sample of size 10 does for the sign test. The ratio of these two
sample sizes is called the *relative efficiency* of the two
tests: in this case, the $t$-test is $10/6=1.67$ times more
efficient. The data that you have are being used ``more
efficiently'' by the $t$-test.
It is possible to derive\endnote{Meaning, I forget how to do it.
But it has something to do with looking at alternatives that are
very close to the null.}  the limiting relative efficiency of
the $t$ test relative to the sign test when the data are actually
normal, as the sample size gets larger. This turns out not to
depend on how far wrong the null is (as long as it is the same for
both the $t$-test and the sign test). This ``asymptotic relative
efficiency'' is $\pi/2=1.57$. Our relative efficiency for power
0.243, namely 1.67, was pretty close to this, even though our
sample sizes 10 and 6 are not especially close to infinity.
This says that, if your data are actually from a normal
distribution, you do a lot better to use the $t$-test than the
sign test, because the sign test is wasteful of data (it only uses
above/below rather than the actual values). 
If your data are *not* from a normal distribution, then the
story can be very different. 
Of course you knew I would investigate this. There is a
distribution called the "Laplace" or "double exponential"
distribution, that has very long tails.\endnote{If you've ever run
into the exponential distribution, you'll recall that this is
right skewed with a very long tail. The Laplace distribution looks
like two of these glued back to back.} The distribution is not in
base R, but there is a package called `smoothmest` that
contains a function `rdoublex` to generate random values from
this distribution. So we're going to do a simulation investigation
of the power of the sign test for Laplace data, by the same
simulation technique that we did above. Like the normal, the Laplace
distribution is symmetric, so its mean and median are the same
(which makes our life easier).\endnote{This is about the *only*
way in which the normal and Laplace distributions are alike.}

Let's test the hypothesis that the median is zero. We'll suppose that
the true median is 0.5 (this is called `mu` in
`rdoublex`). The first problem we run into is that we can't use
`power.t.test` because they assume normal data, which we are
far from having. So we have to do two simulations: one to simulate the
power of the $t$ test, and one to simulate the power of the sign test.

To simulate the $t$ test, we first have to generate some Laplace data
with the true mean of 0.5. We'll use a sample size of 50 throughout
these simulations.


```r
library(smoothmest)
```

```
## Loading required package: MASS
```

```
## 
## Attaching package: 'MASS'
```

```
## The following object is masked from 'package:dplyr':
## 
##     select
```

```r
rl=rdoublex(50,mu=0.5)
rl
```

```
##  [1] -0.33323285  0.70569291 -1.22513053  0.68517708  0.12778518
##  [6]  0.50749949  0.26700527  1.90236874  0.53288312 -0.37374732
## [11]  0.27256566  0.53365929  0.43581431 -0.01545866  0.18594908
## [16] -0.40403202  1.13540289  0.16137306 -0.23360644 -0.74050354
## [21]  2.92089551 -2.72173880  0.48428815  1.23636045  0.17078618
## [26]  1.72456334  0.07903058  0.25210411  0.09512810  2.52310082
## [31] -2.13629814  0.81851434  0.74615575 -0.26068744  2.70683355
## [36]  1.46981530  1.45646489 -0.20232517  6.65249860  1.51575026
## [41] -0.07606399 -1.11338640 -1.20427995 -0.70986104 -1.66466321
## [46]  0.55346854  0.66091469  0.72100677  0.92025176  0.98922656
```

This seems to have some unusual values, far away from zero:


```r
tibble(rl) %>%
ggplot(aes(sample=rl))+
stat_qq()+stat_qq_line()
```

<img src="07-sign-mood-median_files/figure-html/unnamed-chunk-48-1.png" width="672" />

You see the long tails compared to the normal.

Now, we feed these values into `t.test` and see whether we
reject a null median of zero (at $\alpha=0.05$):


```r
tt=t.test(rl)  
tt
```

```
## 
## 	One Sample t-test
## 
## data:  rl
## t = 2.2556, df = 49, p-value = 0.0286
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  0.04959344 0.85981931
## sample estimates:
## mean of x 
## 0.4547064
```

Or we can just pull out the P-value and even compare it to 0.05:


```r
pval=tt$p.value  
pval
```

```
## [1] 0.02859596
```

```r
is.reject=(pval<=0.05)
is.reject
```

```
## [1] TRUE
```
$

This one has a small P-value and so the null median of 0 should be
(correctly) rejected.

We'll use these ideas to simulate the power of the $t$-test for these
data, testing a mean of 0. This uses the same ideas as for any power
simulation; the difference here is the true distribution:


```r
rerun(1000,rdoublex(50,mu=0.5)) %>%
map(~t.test(.,mu=0)) %>%
map_dbl("p.value") ->
pvals
```

and then count them:


```r
tibble(pvals) %>% count(pvals<=0.05)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE             304
## 2 TRUE              696
```

And now we simulate the sign test. Since what we want is a P-value
from a vector, the easiest way to do this is to use
`pval_sign0` from `smmr`, which returns exactly the
two-sided P-value that we want, so that the procedure is a step simpler:


```r
rerun(1000,rdoublex(50,mu=0.5)) %>%
map_dbl(~pval_sign0(0,.)) ->
pvals_sign
```

and then


```r
tibble(pvals_sign) %>% count(pvals_sign<=0.05)
```

```
## # A tibble: 2 x 2
##   `pvals_sign <= 0.05`     n
##   <lgl>                <int>
## 1 FALSE                  239
## 2 TRUE                   761
```

For data from this Laplace
distribution, the power of this $t$-test is 0.696, but the power of
the sign test on the same data is 0.761, *bigger*.  For
Laplace-distributed data, the sign test is *more* powerful than
the $t$-test.

This is not to say that you will ever run into data that comes from
the Laplace distribution. But the moral of the story is that the sign
test *can* be more powerful than the $t$-test, under the right
circumstances (and the above simulation is the "proof" of that
statement). So a blanket statement like ``the sign test is not very
powerful'' needs to be qualified a bit: when your data come from a
sufficiently long-tailed distribution, the sign test can be more
powerful relative to the $t$-test than you would think.

I finish by "unloading" the two packages that got loaded:


```r
detach(package:smoothmest, unload=T)
detach(package:MASS, unload=T)
```






