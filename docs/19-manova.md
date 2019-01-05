# Multivariate analysis of variance

Packages for this chapter:


```r
library(car)
```

```
## Loading required package: carData
```

```r
library(tidyverse)
```

```
## ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.1.0     ✔ purrr   0.2.5
## ✔ tibble  1.4.2     ✔ dplyr   0.7.8
## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
## ✔ readr   1.1.1     ✔ forcats 0.3.0
```

```
## ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
## ✖ dplyr::recode() masks car::recode()
## ✖ purrr::some()   masks car::some()
```




 The data in
[link](http://www.utsc.utoronto.ca/~butler/d29/simple-manova.txt)
(probably made up) are measurements of two 
variables `y1` and `y2` on three groups, labelled
`a`, `b` and `c`. We want to see whether
`y1` or `y2` or some combination of them differ among
the groups.



(a) Read in the data and check that you have 12 observations on
2 numeric variables from 3 different groups.


Solution



```r
my_url="http://www.utsc.utoronto.ca/~butler/d29/simple-manova.txt"
simple=read_delim(my_url," ")
```

```
## Parsed with column specification:
## cols(
##   group = col_character(),
##   y1 = col_integer(),
##   y2 = col_integer()
## )
```

```r
simple
```

```
## # A tibble: 12 x 3
##    group    y1    y2
##    <chr> <int> <int>
##  1 a         2     3
##  2 a         3     4
##  3 a         5     4
##  4 a         2     5
##  5 b         4     8
##  6 b         5     6
##  7 b         5     7
##  8 c         7     6
##  9 c         8     7
## 10 c        10     8
## 11 c         9     5
## 12 c         7     6
```

   

As promised: 12 observations, 2 numeric variables `y1` and
`y2`, and one categorical variable (as text) containing three
groups `a,b,c`.
    


(b) Run a one-way ANOVA predicting `y1` from
`group`. Are there any significant differences in `y1`
among the groups? If necessary, run Tukey. What do you conclude?


Solution



```r
simple.1=aov(y1~group,data=simple)
summary(simple.1)
```

```
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## group        2  63.45   31.72    21.2 0.000393 ***
## Residuals    9  13.47    1.50                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
TukeyHSD(simple.1)
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = y1 ~ group, data = simple)
## 
## $group
##         diff        lwr      upr     p adj
## b-a 1.666667 -0.9417891 4.275122 0.2289181
## c-a 5.200000  2.9089670 7.491033 0.0003548
## c-b 3.533333  1.0391725 6.027494 0.0083999
```

     

The $F$-test said that there were differences among the groups, so I
ran Tukey and found that group `c` is significantly bigger on
`y1` than the other two groups.



(c) Repeat all the previous part for `y2`.


Solution



```r
simple.2=aov(y2~group,data=simple)
summary(simple.2)
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)   
## group        2  19.05   9.525   9.318 0.00642 **
## Residuals    9   9.20   1.022                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```r
TukeyHSD(simple.2)
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = y2 ~ group, data = simple)
## 
## $group
##     diff        lwr      upr     p adj
## b-a  3.0  0.8440070 5.155993 0.0093251
## c-a  2.4  0.5063697 4.293630 0.0157279
## c-b -0.6 -2.6615236 1.461524 0.7050026
```

     

Same idea: there is a difference, and Tukey reveals that this time
group `a` is significantly *smaller* than the other groups
on `y2`. 
    


(d) Make a plot of `y1` against `y2`, with the
points distinguished by which group they are from.


Solution


`y1` and `y2` can be either way around, since
they are both response variables (!):


```r
ggplot(simple,aes(x=y1,y=y2,colour=group))+geom_point()
```

<img src="19-manova_files/figure-html/unnamed-chunk-5-1.png" width="672"  />
$ 

(e) How is it that group `b` is not distinguishable on
either `y1` or `y2` individually (from the ANOVAs),
but *is* distinguishable on your graph? Explain briefly.


Solution


Group `b` has the same kind of `y1` values as group
`a` and the same kind of `y2` values as group
`c`. This means looking at either variable singly is not
enough to distinguish group `b`. But group `b`
stands out on the graph as being "top left" of the picture. That
means that `y1` has to be low *and* `y2` has to
be high, both together, to pick out group `b`. 
That seems like a lot of work for two marks, but the important point
that I want you to raise is that the points in group `b`
are distinguished by a particular *combination* of values of
`y1` and `y2`.
    


(f) Run a one-way multivariate analysis of variance, obtaining
a P-value. Note the very small P-value.


Solution


This is just like the seed weight and yield example in class
(deliberately so):

```r
response=with(simple,cbind(y1,y2))
simple.3=manova(response~group,data=simple)
summary(simple.3)
```

```
##           Df Pillai approx F num Df den Df    Pr(>F)    
## group      2 1.3534   9.4196      4     18 0.0002735 ***
## Residuals  9                                            
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

     

The P-value here, 0.00027, is smaller than either of the P-values for
the one-variable ANOVAs. This expresses the idea that the group
difference is essentially multivariate (it depends on the
*combination* of `y1` and `y2` values). I only
wanted you to note that it is smaller than either of the other
ANOVAs; you don't need to say anything about why.

We were in the fortunate position of being able to draw a picture,
because we had only two response variables, and we could plot them
against each other with the groups labelled. (If we had three response
variables, like the peanuts example, we wouldn't be able to do this,
barring some kind of 3D-plotting procedure.)
    







 A study was made of the characteristics of urine of young
men. The men were classified into four groups based on their degree of
obesity. (The groups are labelled `a, b, c, d`.) Four variables
were measured, `x` (which you can ignore), pigment creatinine,
chloride and chlorine. The data are in
[link](http://www.utsc.utoronto.ca/~butler/d29/urine.csv) as a
`.csv` file. There are 45 men altogether.



(a) Read in the data and check that you have the right number
of observations and the right variables.
 
Solution


`read_csv`:

```r
my_url="http://www.utsc.utoronto.ca/~butler/d29/urine.csv"
urine=read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   obesity = col_character(),
##   x = col_integer(),
##   creatinine = col_double(),
##   chloride = col_double(),
##   chlorine = col_double()
## )
```

```r
urine
```

```
## # A tibble: 45 x 5
##    obesity     x creatinine chloride chlorine
##    <chr>   <int>      <dbl>    <dbl>    <dbl>
##  1 a          24       17.6     5.15      7.5
##  2 a          32       13.4     5.75      7.1
##  3 a          17       20.3     4.35      2.3
##  4 a          30       22.3     7.55      4  
##  5 a          30       20.5     8.5       2  
##  6 a          27       18.5    10.2       2  
##  7 a          25       12.1     5.95     16.8
##  8 a          30       12       6.3      14.5
##  9 a          28       10.1     5.45      0.9
## 10 a          24       14.7     3.75      2  
## # ... with 35 more rows
```

     

The variables are as promised, and we do indeed have 45 rows. 
 

(b) Make boxplots of each of the three variables of interest
against obesity group. 
 
Solution


Just churn through it:

```r
ggplot(urine,aes(x=obesity,y=creatinine))+geom_boxplot()
```

<img src="19-manova_files/figure-html/peppercorn-1.png" width="672"  />

```r
ggplot(urine,aes(x=obesity,y=chlorine))+geom_boxplot()
```

<img src="19-manova_files/figure-html/peppercorn-2.png" width="672"  />

```r
ggplot(urine,aes(x=obesity,y=chloride))+geom_boxplot()
```

<img src="19-manova_files/figure-html/peppercorn-3.png" width="672"  />

     

This also works with facets, though it is different from the other
ones we've done, in that we have to collect together the $y$-variables
first rather than the $x$s:


```r
urine %>% gather(yname,y,creatinine:chlorine) %>%
ggplot(aes(x=obesity,y=y))+geom_boxplot()+
facet_wrap(~yname,scales="free",ncol=2)
```

<img src="19-manova_files/figure-html/unnamed-chunk-8-1.png" width="672"  />

 

I decided to throw a couple of things in here: first, the
`scales="free"` thing since the $y$-variables (this time) are
on different scales, and second, the `ncol=2` to arrange the
facets in (3 cells of) a $2\times 2$ grid, rather than having them
come out tall and skinny.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">Like one of those crazy drinks at  Starbucks.</span> It's unusual to have faceted boxplots, but this is one
of those cases where it makes sense. (The key is different $y$'s but
the same $x$, I think.)

The conclusions about the boxplots are, of course, the same. I think
it makes it easier to have the three boxplots side by side, but it's
up to you whether you think that gain is worth the extra coding.
 

(c) How, if at all, do the groups differ on the variables of interest?
 
Solution


Any sensible comment here is good. You can take the approach that
group D is lowest on creatinine and chloride, but there is not
much to choose (given the amount of variability) on chlorine. Or
you can say that groups B and C are generally highest, except for
chloride where A is higher. Anything of this general kind is fine.
The point here is that some of the groups appear to be different
on some of the variables, which would make a multivariate analysis
of variance (in a moment) come out significant.
 

(d) Run a multivariate analysis of variance, using the three
variables of interest as response variables, and the obesity group
as explanatory. (This is a so-called one-way MANOVA.)
 
Solution


Create the response variable and run `manova`:

```r
response=with(urine,cbind(creatinine,chlorine,chloride))
urine.1=manova(response~obesity,data=urine)
summary(urine.1)
```

```
##           Df  Pillai approx F num Df den Df  Pr(>F)  
## obesity    3 0.43144   2.2956      9    123 0.02034 *
## Residuals 41                                         
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

     
 

(e) What do you conclude? Is this in line with what your
boxplots said? Explain briefly.
 
Solution


The null hypothesis (that each of the variables have the same mean
for each of the groups) is rejected: that is, not all of the
groups have the same mean on all of the variables.
Based on the idea that there seemed to be differences between the
groups in the boxplots, this makes sense. (That's what I saw,
anyway. There was a lot of variability within the groups, which is
why the P-value didn't come out smaller.)
The other way of doing this is the following, using
`Manova` from `car`:

```r
response.1=lm(response~obesity,data=urine)
Manova(response.1)
```

```
## 
## Type II MANOVA Tests: Pillai test statistic
##         Df test stat approx F num Df den Df  Pr(>F)  
## obesity  3   0.43144   2.2956      9    123 0.02034 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

     

The result is the same. You don't need do this one here (though you
can as an alternative), but when you come to repeated measures you
*will* need to be able to use `Manova`.

To understand the differences in the variables due to the groups, we
need to run a discriminant analysis (coming up later).

 




```{ r athletes-manova, child="athletes-manova.Rnw"}
```

