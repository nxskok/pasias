# Matched pairs t and sign test


```r
library(tidyverse)
```

```
## ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
## ✔ tibble  1.4.2     ✔ dplyr   0.7.8
## ✔ tidyr   0.8.2     ✔ stringr 1.3.1
## ✔ readr   1.3.1     ✔ forcats 0.3.0
```

```
## ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

```r
library(smmr)
```



##  Measuring body fat


 Athletes are concerned with measuring their body fat
percentage. Two different methods are available: one using ultrasound,
and the other using X-ray technology. We are interested in whether
there is a difference in the mean body fat percentage as measured by
these two methods, and if so, how big that difference is. Data on 16
athletes are at
[link](http://www.utsc.utoronto.ca/~butler/c32/bodyfat.txt). 



(a) Explain briefly why a matched pairs analysis is more
suitable for these data than a two-independent-samples analysis
(using a two-sample $t$-test). You might find that looking at the
data (clicking on the link) helps you figure this out.


Solution


The data file looks like this:

```

athlete xray ultrasound
1 5.00 4.75
2 7 3.75
3 9.25 9
4 12 11.75
5 17.25 17
6 29.5 27.5
7 5.5 6.5
8 6 6.75
9 8 8.75
10 8.5 9.5
11 9.25 9.5
12 11 12
13 12 12.25
14 14 15.5
15 17 18
16 18 18.25

```

The data are two measurements for each of the 16 athletes: that
is, each athlete had their body fat percentage measured using
*both* of the two methods. 
Extra: a two-sample $t$ approach would be reasonable if one set of 16
athletes had been measured by X-ray and *another different*
set of 16 athletes had been measured by ultrasound. (That is, if
there had been 32 athletes in total, with each one randomly
assigned to *one* of the measurement methods.) But that's not
what happened. It is easy to measure one athlete's body fat
percentage using both of the two methods, so a matched pairs
design is easy to implement (as well as being better). If you use
two independent samples (each athlete doing only one measurement
method), you introduce an extra source of variability: athletes
differ one from another in body fat, as well as differing possibly
by measurement method. If you use a matched-pairs design, you
remove the athlete-to-athlete differences, leaving only the
differences due to measurement method.




(b) Read in the data and check that you have a sensible number of
rows and columns.



Solution


This kind of thing. Since you looked at the data (didn't you?),
you'll know that the values are separated by single spaces:


```r
myurl="http://www.utsc.utoronto.ca/~butler/c32/bodyfat.txt"
bodyfat=read_delim(myurl," ")
```

```
## Parsed with column specification:
## cols(
##   athlete = col_double(),
##   xray = col_double(),
##   ultrasound = col_double()
## )
```

```r
bodyfat  
```

```
## # A tibble: 16 x 3
##    athlete  xray ultrasound
##      <dbl> <dbl>      <dbl>
##  1       1  5          4.75
##  2       2  7          3.75
##  3       3  9.25       9   
##  4       4 12         11.8 
##  5       5 17.2       17   
##  6       6 29.5       27.5 
##  7       7  5.5        6.5 
##  8       8  6          6.75
##  9       9  8          8.75
## 10      10  8.5        9.5 
## 11      11  9.25       9.5 
## 12      12 11         12   
## 13      13 12         12.2 
## 14      14 14         15.5 
## 15      15 17         18   
## 16      16 18         18.2
```

 

16 rows (athletes) and 3 columns, one for each measurement
method and one labelling the athletes. All good.

Since 16 is not too much bigger than 10, I got the whole data frame
here. (At least, I think that's the reason I got more than 10 rows.)
In an R Notebook, you'll see the first ten rows as normal, with a
button to click to see the other six.





(c) Carry out a suitable test to determine whether the means are
the same or different. (At this point, obtain the R output including a P-value.)



Solution


Feed the two columns into `t.test` along with
`paired=T`. This is a two-sided test, so we don't have to
take any special steps for that. Note that we're back to the
"old-fashioned" version of `t.test` that *does not*
allow `data=`, so we have to go the `with` way:


```r
with(bodyfat,t.test(xray,ultrasound,paired=T))
```

```
## 
## 	Paired t-test
## 
## data:  xray and ultrasound
## t = -0.30801, df = 15, p-value = 0.7623
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.7425068  0.5550068
## sample estimates:
## mean of the differences 
##                -0.09375
```

 




(d) What do you conclude from the test?



Solution


The P-value of 0.7623 is not at all small, so there is no way we can
reject the null hypothesis.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">My hat stays on my head.</span> There
is no evidence of a difference in means; we can act as if the two
methods produce the same mean body fat percentage. 
That is to say, on this evidence we can use either method, whichever
one is cheaper or more convenient.





(e) Obtain a 95\% confidence interval for the population mean
difference. How is the interval consistent with your test?



Solution


You don't even need to do any more coding: the test was two-sided,
so just pick the confidence interval off the output above: $-0.74$
to 0.56. 
The interval includes both positive and negative values (or, 0 is
inside the interval), so the difference could go either way. This is
entirely consistent with not being able to reject the null.




(f) Calculate the differences, and make a normal quantile plot of
them. Is there any evidence that normality of differences fails?
Explain briefly. 



Solution


The smoothest
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">I learned yesterday that the Welsh word for *ironing* is *smwddio*, which seems weird until you say    it out loud: it sounds like *smoothio*.</span> 
way to do this is to
use a pipeline: use a `mutate` to create the column of
differences, and then pipe that into `ggplot`, omitting the
data frame that would normally go first (the input data frame here
is the new one with the differences in it, which doesn't have a
name). I'll make a normal quantile plot in a moment, but if you
haven't seen that yet, the plot to make is a histogram:

```r
bodyfat %>% mutate(diff=xray-ultrasound) %>%
ggplot(aes(x=diff))+geom_histogram(bins=6)
```

<img src="08-matched-pairs-sign_files/figure-html/unnamed-chunk-4-1.png" width="672"  />

   

I don't know whether you'd call that "approximately normal" or
not. We are in kind of a double-bind with this one: the sample size is
small, so normality matters, but with a small sample, the data might
not look very normal. It's kind of skewed right, but most of the
evidence for the skewness is contained in those two observations with
difference 2 and above, which is pretty flimsy evidence for
anything. (In the normal quantile plot below, the suggestion is that
those two observations really are a bit too large. It's easier to tell
there.) 

Below, I'm repeating the calculation of the differences, which is
inefficient. If I'm going to draw two graphs of the differences, the
right way is to calculate the differences \emph{and save the data
frame}, then use that new data frame twice. But you're probably only
going to draw either the histogram or the normal quantile plot, not
both, so you can use the appropriate one of my two bits of code. The
normal quantile plot:

```r
bodyfat %>% mutate(diff=xray-ultrasound) %>%
ggplot(aes(sample=diff))+stat_qq()+stat_qq_line()
```

<img src="08-matched-pairs-sign_files/figure-html/unnamed-chunk-5-1.png" width="672"  />

   
This is showing a little evidence of skewness or outliers  (depending
on your point of view: either is good). The lowest and highest values
are both too high, and the pattern of points on the plot is kind of
curved (which would be evidence of skewness). Or you could say that
the two highest values are too high, with the other values being more
or less in line (that would be evidence of outliers at the upper
end). I like outliers better than skewness, since those bottom-end
points are not far off the line. I would also accept 
"no substantial problems", 
if you can make the case that those two highest points are
not too far off the line. With only 16 observations as we have here,
even truly normal data would stray off the line a bit.

As ever, your explanation is more important than your conclusion. Can
you justify what you think?

If you took your differences the other way around, as
`ultrasound` minus `xray`, your plot will also be the
other way around, with the "outliers" at the bottom. That's good
too.

Where this is going (which I didn't ask you) is whether or not we
trust the result of the matched pairs test. I would say that the test
is so far from being significant, and the failure of normality is not
gross, that it is hard to imagine *any* alternative test coming
up with a significant result. So I would be happy to trust this paired
$t$-test.








##  Throwing baseballs and softballs


 Can students throw a baseball farther than a softball? A
statistics class, containing 24 students, went out to a football field
to try to answer this question. Each student warmed up and then threw
each type of ball as far as they could. The order of ball types was
randomized: some students threw the baseball first, and some threw the
softball first. (A softball is bigger than a baseball, so we might
expect that a softball would be harder to throw a long way than a
baseball.) The data are in
[http://www.utsc.utoronto.ca/~butler/c32/throw.txt](http://www.utsc.utoronto.ca/~butler/c32/throw.txt) in three
columns: the first is a number identifying the student, the second is
the distance thrown with the baseball (in yards) and the third is the
distance thrown with the softball (also in yards).



(a) Read the data into R. You'll need to supply some names
to the columns.


Solution


This kind of thing:

```r
myurl="http://www.utsc.utoronto.ca/~butler/c32/throw.txt"
throws=read_delim(myurl," ",col_names=c("student","baseball","softball"))
```

```
## Parsed with column specification:
## cols(
##   student = col_double(),
##   baseball = col_double(),
##   softball = col_double()
## )
```

```r
throws
```

```
## # A tibble: 24 x 3
##    student baseball softball
##      <dbl>    <dbl>    <dbl>
##  1       1       65       57
##  2       2       90       58
##  3       3       75       66
##  4       4       73       61
##  5       5       79       65
##  6       6       68       56
##  7       7       58       53
##  8       8       41       41
##  9       9       56       44
## 10      10       70       65
## # ... with 14 more rows
```

This is one of those times where we have to tell R what names to give
the columns. Or you can put `col_names=F` and leave the
columns called `X1, X2, X3` or whatever they end up as.



(b) Calculate a column of differences, baseball minus softball,
*in* the data frame.


Solution


Add it to the data frame using `mutate`. Use the
right-arrow assignment to create what I called
`throws2` below, or put something like
`throws2=` on the beginning of the line. Your choice.


```r
throws %>% mutate(diff=baseball-softball) ->
throws2
```



(c) Carry out a sign test in R, testing the null hypothesis
that the median difference is zero, against the alternative that
it is greater than zero. Obtain a P-value. Your option whether you use
`smmr` or not.


Solution


I think using `smmr` is way easier, so I'll do that
first. There is even a shortcut in that the null median defaults to
zero, which is exactly what we want here:


```r
library(smmr)
sign_test(throws2,diff)
```

```
## $above_below
## below above 
##     2    21 
## 
## $p_values
##   alternative      p_value
## 1       lower 9.999971e-01
## 2       upper 3.302097e-05
## 3   two-sided 6.604195e-05
```

We want, this time, the upper-tailed one-sided test, since we want to
prove that students can throw a baseball a *longer* distance
than a softball. Thus the P-value we want is 0.000033.

To build it yourself, you know the steps by now.
First step is to count how many differences are greater and less than zero:

```r
table(throws2$diff>0)
```

```
## 
## FALSE  TRUE 
##     3    21
```

or


```r
table(throws2$diff<0)
```

```
## 
## FALSE  TRUE 
##    22     2
```

or, since we have things in a data frame,


```r
throws2 %>% count(diff>0)
```

```
## # A tibble: 2 x 2
##   `diff > 0`     n
##   <lgl>      <int>
## 1 FALSE          3
## 2 TRUE          21
```

or count those less than zero. I'd take any of those.

Note that these are *not all the same*. One of the differences is
in fact exactly zero. The technically right thing to do with the zero
difference is to throw it away (leaving 23 differences with 2 negative
and 21 positive). I would take that, or 2 or 3 negative differences
out of 24 (depending on whether you count "greater than zero" or
"less than zero"). We hope that this won't make a material
difference to the P-value; it'll make some difference, but won't (we
hope) change the conclusion about whether to reject.

Second step is to get a P-value for whichever one of those you got,
from the appropriate binomial distribution. 

The P-value is the probability of getting 21 (or 22) positive
differences out of 24 (or 23) or more, since this is the end of the
distribution we should be at if the alternative hypothesis is correct.
Thus any of these will get you a defensible P-value:


```r
sum(dbinom(21:23,23,0.5))
```

```
## [1] 3.302097e-05
```

```r
sum(dbinom(22:24,24,0.5))
```

```
## [1] 1.7941e-05
```

```r
sum(dbinom(21:24,24,0.5))
```

```
## [1] 0.0001385808
```

```r
sum(dbinom(0:2,23,0.5))
```

```
## [1] 3.302097e-05
```

```r
sum(dbinom(0:2,24,0.5))
```

```
## [1] 1.7941e-05
```

```r
sum(dbinom(0:3,24,0.5))
```

```
## [1] 0.0001385808
```

The first and fourth of those are the same as `smmr` (throwing
away the exactly-median value). 

As we hoped, there is no *material* difference here: there is no
doubt with any of these possibilities that we will reject a median
difference of zero in favour of a median difference greater than
zero. 







##  Throwing baseballs and softballs, again


 Previously, you carried out a sign test to determine
whether students could throw a baseball farther than a softball. This
time, we will calculate a confidence interval for the median
difference baseball minus softball, using the results of sign tests.



(a) Read the data into R from
[link](http://www.utsc.utoronto.ca/~butler/c32/throw.txt), giving
appropriate names to the columns, and add a column of
differences. 


Solution


I did it this way, combining the reading
of the data with the calculation of the differences in *one* pipe:


```r
myurl="http://www.utsc.utoronto.ca/~butler/c32/throw.txt"
throws = read_delim(myurl," ",col_names=c("student","baseball","softball")) %>%
mutate(diff=baseball-softball)
```

```
## Parsed with column specification:
## cols(
##   student = col_double(),
##   baseball = col_double(),
##   softball = col_double()
## )
```

```r
throws  
```

```
## # A tibble: 24 x 4
##    student baseball softball  diff
##      <dbl>    <dbl>    <dbl> <dbl>
##  1       1       65       57     8
##  2       2       90       58    32
##  3       3       75       66     9
##  4       4       73       61    12
##  5       5       79       65    14
##  6       6       68       56    12
##  7       7       58       53     5
##  8       8       41       41     0
##  9       9       56       44    12
## 10      10       70       65     5
## # ... with 14 more rows
```

 



(b) Use `smmr` to find a 95\% confidence interval for the
median difference.


Solution


`ci_median`, with 95\% being the default confidence level:


```r
ci_median(throws,diff)
```

```
## [1] 2.002930 8.999023
```

 

2 to 9. The ends of a CI for the median will be data values, which are
all whole numbers, so round off that 8.999.



(c) What function in `smmr` will run a two-sided sign test
and return only the P-value? Check that it works by testing whether the
median difference for your data is zero or different from zero.


Solution


The rest of the way, we are trying to reproduce that confidence
interval by finding it ourselves.
The function is called `pval_sign`. If you haven't run into it
before, in R Studio click on Packages, find `smmr`, and
click on its name. This will bring up package help, which
includes a list of all the functions in the package, along with
a brief description of what each one does. (Clicking
on a function name brings up the help for that function.)
Let's check that it works properly by repeating the previous
`sign_test` and verifying that `pval_sign` gives
the same thing:

```r
sign_test(throws,diff,0)
```

```
## $above_below
## below above 
##     2    21 
## 
## $p_values
##   alternative      p_value
## 1       lower 9.999971e-01
## 2       upper 3.302097e-05
## 3   two-sided 6.604195e-05
```

```r
pval_sign(0,throws,diff)
```

```
## [1] 6.604195e-05
```

       

The P-values are the same (for the two-sided test) and both small, so
the median difference is not zero.



(d) Based on your P-value, do you think 0 is inside the confidence
interval or not? Explain briefly.


Solution


Absolutely not. The median difference is definitely not
zero, so zero cannot be in the confidence interval.
Our suspicion, from the one-sided test from earlier, is that
the differences were mostly positive (people could throw a
baseball farther than a softball, in most cases). So the
confidence interval ought to contain only positive values.
I ask this because it drives what happens below.



(e) Obtain a 95\% confidence interval for the population
median difference, baseball minus softball, using a
trial-and-error procedure that determines whether a number of
possible medians are inside or outside the CI.


Solution


 I've given you a fair bit of freedom to tackle this as you
 wish. Anything that makes sense is good: whatever mixture of
 mindlessness, guesswork and cleverness that you want to employ.
The most mindless way to try some values one at a time and see what
 you get, eg.:

```r
pval_sign(1,throws,diff)
```

```
## [1] 0.001489639
```

```r
pval_sign(5,throws,diff)
```

```
## [1] 1.168188
```

  

So median 1 is outside and median 5 is inside the 95\% interval. Keep
trying values until you've figured out where the lower and upper ends
of the interval are: where the P-values cross from below 0.05 to
above, or vice versa.

Something more intelligent is to make a long list of potential
medians, and get the P-value for each of them, eg.:


```r
d=tibble(my.med=seq(0,20,2))
d %>% mutate(pvals=map_dbl(my.med,~pval_sign(.,throws,diff)))
```

```
## # A tibble: 11 x 2
##    my.med      pvals
##     <dbl>      <dbl>
##  1      0 0.0000660 
##  2      2 0.0525    
##  3      4 0.839     
##  4      6 0.678     
##  5      8 0.210     
##  6     10 0.0227    
##  7     12 0.00149   
##  8     14 0.0000660 
##  9     16 0.0000359 
## 10     18 0.00000572
## 11     20 0.00000298
```

 

2 is just inside the interval, 8 is also inside, and 10 is
outside. Some closer investigation:


```r
d=tibble(my.med=seq(0,2,0.5))
d %>% mutate(pvals=map_dbl(my.med,~pval_sign(.,throws,diff)))
```

```
## # A tibble: 5 x 2
##   my.med     pvals
##    <dbl>     <dbl>
## 1    0   0.0000660
## 2    0.5 0.000277 
## 3    1   0.00149  
## 4    1.5 0.0227   
## 5    2   0.0525
```

 

The bottom end of the interval actually is 2, since 2 is inside and
1.5 is outside.


```r
d=tibble(my.med=seq(8,10,0.5))
d %>% mutate(pvals=map_dbl(my.med,~pval_sign(.,throws,diff)))
```

```
## # A tibble: 5 x 2
##   my.med  pvals
##    <dbl>  <dbl>
## 1    8   0.210 
## 2    8.5 0.152 
## 3    9   0.0525
## 4    9.5 0.0227
## 5   10   0.0227
```

 

The top end is 9, 9 being inside and 9.5 outside.

Since the data values are all whole numbers, I think this is accurate enough.
The most sophisticated way is the "bisection" idea we saw before. We
already have a kickoff for this, since we found, mindlessly, that 1 is
outside the interval on the low end and 5 is inside, so the lower
limit has to be between 1 and 5. Let's try halfway between, ie.\ 3:


```r
pval_sign(3,throws,diff)
```

```
## [1] 0.3833103
```

 

Inside, so lower limit is between 1 and 3. This can be automated, thus:


```r
lo=1
hi=3
while(abs(hi-lo)>0.1) {
try=(lo+hi)/2
ptry=pval_sign(try,throws,diff)
if (ptry>0.05) {
hi=try
} else {
lo=try
}
}
c(lo,hi)
```

```
## [1] 1.9375 2.0000
```

 

The difficult bit is to decide whether the value `try` becomes
the new `lo` or the new `hi`. If the P-value for the
median of `try` is greater than 0.05, `try` is inside
the interval, and it becomes the new `hi`; otherwise it's
outside and becomes the new `lo`. Whatever the values are,
`lo` is always outside the interval and `hi` is always
inside, and they move closer and closer to each other.

At the other end of the interval, `lo` is inside and
`hi` is outside, so there is a little switching around within
the loop. For starting values, you can be fairly mindless: for
example, we know that 5 is inside and something big like 20 must be outside:


```r
lo=5
hi=20
while(abs(hi-lo)>0.1) {
try=(lo+hi)/2
ptry=pval_sign(try,throws,diff)
if (ptry>0.05) {
lo=try
} else {
hi=try
}
}
c(lo,hi)
```

```
## [1] 8.984375 9.042969
```

 

The interval goes from 2 to (as calculated here) about 9. (This is
apparently the same as `ci_median` in `smmr` got.)
`ci_median` uses the bisection method with a smaller "tolerance" than we
did, so its answer is more accurate. It looks as if the interval goes
from 2 to 9: that is, students can throw a baseball on average between
2 and 9 feet further than they can throw a softball.







## Changes in salary



 A company is growing and would like to attract more
employees. The company would like to advertise that salaries there are
increasing. To do this, the company randomly samples 20 employees that
have been working there since January 2016, and for each of these
employees, records their salary in January 2016 and January 2017. The
data, with salaries in thousands of dollars, are in
[link](https://www.utsc.utoronto.ca/~butler/c32/salaryinc.txt). 



(a) Read the data into R and demonstrate that you have two
salaries for each of 20 employees.

Solution


Looking at the file, we see that the values are separated by
exactly one space:

```r
my_url="https://www.utsc.utoronto.ca/~butler/c32/salaryinc.txt"
salaries=read_delim(my_url," ")
```

```
## Parsed with column specification:
## cols(
##   employee = col_character(),
##   jan2016 = col_double(),
##   jan2017 = col_double()
## )
```

```r
salaries
```

```
## # A tibble: 20 x 3
##    employee jan2016 jan2017
##    <chr>      <dbl>   <dbl>
##  1 A           36      39.5
##  2 B           41.2    47  
##  3 C           40      45  
##  4 D           42.8    49  
##  5 E           51      57.8
##  6 F           50.5    54  
##  7 G           56      62  
##  8 I           57.8    69.9
##  9 J           62      66.8
## 10 K           65.5    71  
## 11 L           66      72  
## 12 M           68.9    74  
## 13 N           71      80  
## 14 O           72.3    79  
## 15 P           74.6    80  
## 16 Q           77      83.1
## 17 R           79.9    82.5
## 18 S           81      92  
## 19 T           83.2    85  
## 20 U           90     101
```

     

There are 20 employees (rows), and two columns of salaries: for each
employee in the data set, their salary in January 2016 and in January
2017 (thus, two salaries for each employee).


(b) To compare the salaries, explain briefly why a
matched-pairs test would be better than a two-sample test.

Solution


A matched-pairs test would be better because we have two
observations (salaries) for each subject (employee). A two-sample
test would be appropriate if we had two separate sets of
employees, one set with their salaries recorded in 2016 and the
other with their salaries recorded in 2017. That is not what we
have here.
You can go after this either way: why a matched-pairs approach is
appropriate, or why a two-sample approach is not (or a bit of both).


(c) Make a suitable graph to assess the assumptions for a
matched-pairs $t$-test. What does your graph tell you?

Solution


This requires thought first before you do any coding (and this is
the reason for this one being four points). What has to be at
least approximately normally distributed is the set of
*differences*, salary at one time point minus the salary at
the other, for each employee. The individual salaries don't have
to be normally distributed at all. 
We don't have the differences here, so we have to calculate them
first. The smoothest way is to make a pipeline:

```r
salaries %>%
mutate(diff=jan2017-jan2016) %>%
ggplot(aes(sample=diff))+stat_qq()+stat_qq_line()
```

<img src="08-matched-pairs-sign_files/figure-html/unnamed-chunk-25-1.png" width="672"  />

     

A couple of coding notes: (i) you can take the differences 2016 minus
2017 if you like (then they will tend to be negative), (ii)
`ggplot` used in a pipeline like this does *not* have a
data frame first (the data frame used is the nameless output from the
`mutate`, with the differences in it). 

Also, there's no problem doing the `mutate`, saving that, and
then feeding the saved data frame into `ggplot`. If you find
that clearer, go for it.

As for what I see: I think those points get a bit far from the
line at the high and low ends: the high values are too high and the
low values are too low, which is to say that we have outliers at both
ends, or the distribution has long tails (either way of saying it is
good). 

The important conclusion here is whether these differences are normal
*enough* to trust a matched pairs $t$-test here. We have a sample
of size 20, so the central limit theorem will help us some, but you
can reasonably say that these tails are too long and that we should
not trust a matched-pairs $t$-test.

I actually wanted you to practice doing a matched-pairs $t$-test
anyway, hence my comment in the next part, but the result is probably
not *so* trustworthy.


(d) Carry out a suitable matched-pairs $t$-test on these data. (If you
thought in the previous part that this was the wrong thing to do, do
it anyway for the purposes of this assignment.) What do you conclude?

Solution


The company is trying to prove that salaries are *increasing*
over time, so we need a one-sided alternative.
Following through the procedure, even though you may not trust it much:

```r
with(salaries, t.test(jan2016, jan2017, alternative="less", paired=T))
```

```
## 
## 	Paired t-test
## 
## data:  jan2016 and jan2017
## t = -10.092, df = 19, p-value = 2.271e-09
## alternative hypothesis: true difference in means is less than 0
## 95 percent confidence interval:
##       -Inf -5.125252
## sample estimates:
## mean of the differences 
##                  -6.185
```

     

You could also have the years the other way around, in which case the
alternative has to be the other way around as well:


```r
with(salaries, t.test(jan2017, jan2016, alternative="greater", paired=T))
```

```
## 
## 	Paired t-test
## 
## data:  jan2017 and jan2016
## t = 10.092, df = 19, p-value = 2.271e-09
## alternative hypothesis: true difference in means is greater than 0
## 95 percent confidence interval:
##  5.125252      Inf
## sample estimates:
## mean of the differences 
##                   6.185
```

 

Or, if you saved the data frame with the differences in it, do a
one-sample test on those, again making sure that you get the
`alternative` right. I didn't save it, so I'm calculating the
differences again:


```r
salaries %>%
mutate(diff=jan2017-jan2016) %>%
with(.,t.test(diff, mu=0, alternative="greater"))
```

```
## 
## 	One Sample t-test
## 
## data:  diff
## t = 10.092, df = 19, p-value = 2.271e-09
## alternative hypothesis: true mean is greater than 0
## 95 percent confidence interval:
##  5.125252      Inf
## sample estimates:
## mean of x 
##     6.185
```

 

Whichever way you do it, the P-value is the same $2.271 \times
10^{-9}$, which is a whole lot less than 0.05, so there is no doubt at
all that salaries are increasing.

(Your intuition ought to have expected something like this, because
everyone's 2017 salary appears to be greater than their 2016 salary.)

Extra: you might be feeling that we ought to be doing a matched-pairs
sign test, which you could do this way:


```r
library(smmr)
salaries %>%
mutate(diff=jan2017-jan2016) %>%
sign_test(diff,0)
```

```
## $above_below
## below above 
##     0    20 
## 
## $p_values
##   alternative      p_value
## 1       lower 1.000000e+00
## 2       upper 9.536743e-07
## 3   two-sided 1.907349e-06
```

 

and then take the "upper" P-value, which is in the same ballpark as
the one from the $t$-test. So the salaries really are increasing,
whether you believe the $t$-test or not. And note that *every  single employee's salary increased*.

(Again, the "missing" data frame in `sign_test` is the nameless
one with the differences in it.)


(e) The company would like to estimate  \emph{how
much} salaries are increasing, on average. Obtain some output that
will enable the company to assess this, and tell the CEO which piece
of the output they should look at.

Solution


A confidence interval. 95\% is fine. As before, we have to run
`t.test` again because we ran a one-sided test and a
confidence interval for us is two-sided:

```r
with(salaries, t.test(jan2017, jan2016, paired=T))
```

```
## 
## 	Paired t-test
## 
## data:  jan2017 and jan2016
## t = 10.092, df = 19, p-value = 4.542e-09
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  4.902231 7.467769
## sample estimates:
## mean of the differences 
##                   6.185
```

     

Between about \$5,000 and about \$7,500. This is what to tell the CEO.

 



##  Body fat revisited


 Athletes are concerned with measuring their body fat
percentage. Two different methods are available: one using ultrasound,
and the other using X-ray technology. We are interested in whether
there is a difference in the mean body fat percentage as measured by
these two methods, and if so, how big that difference is. Data on 16
athletes are at
[link](http://www.utsc.utoronto.ca/~butler/c32/bodyfat.txt). 

We saw this data set before.




(a) Read in the data again.



Solution


This kind of thing. Since you looked at the data (didn't you?),
you'll know that the values are separated by single spaces:


```r
myurl="http://www.utsc.utoronto.ca/~butler/c32/bodyfat.txt"
bodyfat=read_delim(myurl," ")
```

```
## Parsed with column specification:
## cols(
##   athlete = col_double(),
##   xray = col_double(),
##   ultrasound = col_double()
## )
```

```r
bodyfat  
```

```
## # A tibble: 16 x 3
##    athlete  xray ultrasound
##      <dbl> <dbl>      <dbl>
##  1       1  5          4.75
##  2       2  7          3.75
##  3       3  9.25       9   
##  4       4 12         11.8 
##  5       5 17.2       17   
##  6       6 29.5       27.5 
##  7       7  5.5        6.5 
##  8       8  6          6.75
##  9       9  8          8.75
## 10      10  8.5        9.5 
## 11      11  9.25       9.5 
## 12      12 11         12   
## 13      13 12         12.2 
## 14      14 14         15.5 
## 15      15 17         18   
## 16      16 18         18.2
```

 




(b) Calculate the differences, and make a normal quantile plot of
them. Is there any evidence that normality of differences fails?
Explain briefly. 



Solution


This is a good place to look ahead. We'll need the differences in two
places, most likely: first for the normal quantile plot, and second
for the matched-pairs sign test. So we should calculate and save them first:


```r
bodyfat %>% mutate(diff=xray-ultrasound) -> bodyfat2
```

 

I seem to be using a 2 on the end to name my
dataframe-with-differences, but you can use whatever name you like.

Then, not forgetting to use the data frame that we just made:


```r
ggplot(bodyfat2,aes(sample=diff))+stat_qq()+stat_qq_line()
```

<img src="08-matched-pairs-sign_files/figure-html/unnamed-chunk-33-1.png" width="672"  />

   
This is showing a little evidence of skewness or outliers  (depending
on your point of view: either is good). The lowest and highest values
are both too high, and the pattern of points on the plot is kind of
curved (which would be evidence of skewness). Or you could say that
the two highest values are too high, with the other values being more
or less in line (that would be evidence of outliers at the upper
end). I like outliers better than skewness, since those bottom-end
points are not far off the line. I would also accept 
"no substantial problems", 
if you can make the case that those two highest points are
not too far off the line. With only 16 observations as we have here,
even truly normal data would stray off the line a bit.

As ever, your explanation is more important than your conclusion. Can
you justify what you think?

If you took your differences the other way around, as
`ultrasound` minus `xray`, your plot will also be the
other way around, with the "outliers" at the bottom. That's good
too.





(c) Previously, we did a matched-pairs $t$-test for these data. In
the light of your normal quantile plot, do you think that was a good
idea? Explain briefly.



Solution


We are looking for the differences to be approximately normal,
bearing in mind that we have a sample of size 16, which is not
that large. Say what you think here; the points, if I were giving
any here, would be for the way in which you support it.
The comment I made before when we did a matched-pairs $t$-test
was that the P-value was so large and non-significant that it was
hard to imagine any other test giving a significant
result. Another way of saying that is that I considered these
differences to be "normal enough", given the circumstances.
You might very well take a different view. You could say that
these differences are clearly not normal, and that the sample size
of 16 is not large enough to get any substantial help from the
Central Limit Theorem. From that point of view, running the
$t$-test is clearly not advisable.




(d) Use the sign test appropriately to compare the two methods for
measuring body fat. (Use `smmr` if you wish.) What do you
conclude, as ever in the context of the data?



Solution


That means using a sign test to test the null hypothesis that the
median difference is zero, against the alternative that it is not
zero. (I don't see anything here to indicate that we are looking only
for positive or only for negative differences, so I think two-sided is
right. You need some reason to do a one-sided test, and there isn't
one here.)

Remembering again to use the data frame that has the differences in it:


```r
sign_test(bodyfat2, diff, 0)
```

```
## $above_below
## below above 
##    10     6 
## 
## $p_values
##   alternative   p_value
## 1       lower 0.2272491
## 2       upper 0.8949432
## 3   two-sided 0.4544983
```

 

The two-sided P-value is 0.4545, so we are nowhere near rejecting the
null hypothesis that the median difference is zero. There is no
evidence that the two methods for measuring body fat show any
difference on average.

The table of aboves and belows says that there were 6 positive
differences and 10 negative ones. This is not far from an even split,
so the lack of significance is entirely what we would expect. 

Extra: this is the same conclusion that we drew the last time we
looked at these data (with a matched-pairs $t$-test). That supports
what I said then, which is that the $t$-test was so far from being
significant, that it could be very wrong without changing the
conclusion. That is what seems to have happened.





