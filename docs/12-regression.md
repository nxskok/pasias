# Regression


```r
library(tidyverse)
```

```
## -- Attaching packages ---- tidyverse 1.2.1 --
```

```
## v ggplot2 3.1.0     v purrr   0.2.5
## v tibble  1.4.2     v dplyr   0.7.8
## v tidyr   0.8.1     v stringr 1.3.1
## v readr   1.1.1     v forcats 0.3.0
```

```
## -- Conflicts ------- tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```
These problems are about simple regression (just one $x$-variable):




##  Rainfall in California


 The data in
[link](http://www.utsc.utoronto.ca/~butler/c32/calirain.txt) are
rainfall and other measurements for 30 weather stations in
California. Our aim is to understand how well the annual rainfall at
these stations (measured in inches) can be predicted from the other
measurements, which are the altitude (in feet above sea level), the
latitude (degrees north of the equator) and the distance from the
coast (in miles).



(a) Read the data into R. You'll have to be careful here, since the
values are space-delimited, but sometimes by more than one space, to
make the columns line up.  `read_table2`, with filename or
url, will read it in.
One of the variables
is called `rainfall`, so as long as you *do not* call
the data frame that, you should be safe.


Solution


I used `rains` as the name of my data frame: 

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/calirain.txt"
rains = read_table2(my_url)
```

```
## Parsed with column specification:
## cols(
##   station = col_character(),
##   rainfall = col_double(),
##   altitude = col_integer(),
##   latitude = col_double(),
##   fromcoast = col_integer()
## )
```

 

I have the right number of rows and columns.

There is also `read_table`, but that requires *all* the
columns, including the header row, to be lined up. You can try that
here and see how it fails.

I don't need you to investigate the data yet (that happens in the next
part), but this is interesting (to me):


```r
rains
```

```
## # A tibble: 30 x 5
##    station rainfall altitude latitude
##    <chr>      <dbl>    <int>    <dbl>
##  1 Eureka      39.6       43     40.8
##  2 RedBlu~     23.3      341     40.2
##  3 Thermal     18.2     4152     33.8
##  4 FortBr~     37.5       74     39.4
##  5 SodaSp~     49.3     6752     39.3
##  6 SanFra~     21.8       52     37.8
##  7 Sacram~     18.1       25     38.5
##  8 SanJose     14.2       95     37.4
##  9 GiantF~     42.6     6360     36.6
## 10 Salinas     13.8       74     36.7
## # ... with 20 more rows, and 1 more
## #   variable: fromcoast <int>
```

 

Some of the station names are two words, but they have been smooshed
into one word, so that `read_table2` will recognize them as a
single thing. Someone had already done that for us, so I didn't even
have to do it myself. 

If the station names had been two genuine words, a `.csv` would
probably have been the best choice (the actual data values being
separated by commas then, and not spaces).



(b) Make a boxplot of the rainfall figures, and explain why the
values are reasonable. (A rainfall cannot be negative, and it is
unusual for a annual rainfall to exceed 60 inches.) A
`ggplot` boxplot needs *something* on the $x$-axis: the
number 1 will do.


Solution




```r
ggplot(rains, aes(y = rainfall, x = 1)) + geom_boxplot()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-4-1} 

     
There is only one rainfall over 60 inches, and the smallest one is
close to zero but positive, so that is good.

Another possible plot here is a histogram, since there is only one quantitative variable:


```r
ggplot(rains, aes(x = rainfall)) + geom_histogram(bins = 7)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-5-1} 



This clearly shows the rainfall value above 60 inches, but some other things are less clear: are those two rainfall values around 50 inches above or below 50, and are those six rainfall values near zero actually above zero? 
Extra: What stations have those extreme values? Should you wish to find out:

```r
rains %>% filter(rainfall > 60)
```

```
## # A tibble: 1 x 5
##   station rainfall altitude latitude
##   <chr>      <dbl>    <int>    <dbl>
## 1 Cresce~     74.9       35     41.7
## # ... with 1 more variable: fromcoast <int>
```

 
This is a place right on the Pacific coast, almost up into Oregon (it's almost
the northernmost of all the stations). So it makes sense that it would
have a high rainfall, if anywhere does. (If you know anything about
rainy places, you'll probably think of Vancouver and Seattle, in the
Pacific Northwest.) Here it is:
[link](https://www.google.ca/maps/place/Crescent+City,+CA,+USA/@41.7552589,-123.9652917,8.42z/data=!4m5!3m4!1s0x54d066375c6288db:0x76e89ab07375e62e!8m2!3d41.7557501!4d-124.2025913). 
Which station has less than 2 inches of annual rainfall?

```r
rains %>% filter(rainfall < 2)
```

```
## # A tibble: 1 x 5
##   station rainfall altitude latitude
##   <chr>      <dbl>    <int>    <dbl>
## 1 DeathV~     1.66     -178     36.5
## # ... with 1 more variable: fromcoast <int>
```

 
The name of the station is a clue: this one is in the desert. So you'd
expect very little rain. Its altitude is *negative*, so it's
actually *below* sea level. This is correct. Here is where it is:
[link](https://www.google.ca/maps/place/Death+Valley,+CA,+USA/@36.6341288,-118.2252974,7.75z/data=!4m5!3m4!1s0x80c739a21e8fffb1:0x1c897383d723dd25!8m2!3d36.5322649!4d-116.9325408).



(c) Plot `rainfall` against each of the other quantitative
variables (that is, not `station`). 


Solution


That is, `altitude`, `latitude` and
`fromcoast`. The obvious way to do this (perfectly
acceptable) is one plot at a time:

```r
ggplot(rains, aes(y = rainfall, x = altitude)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-8-1} 

     


```r
ggplot(rains, aes(y = rainfall, x = latitude)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-9-1} 

 

and finally 


```r
ggplot(rains, aes(y = rainfall, x = fromcoast)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-10-1} 

 

You can add a smooth trend to these if you want. Up to you. Just the
points is fine with me.

Here is a funky way to get all three plots in one shot:


```r
rains %>% gather(xname, x, altitude:fromcoast) %>% 
    ggplot(aes(x = x, y = rainfall)) + geom_point() + 
    facet_wrap(~xname, scales = "free")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-11-1} 

 

This always seems extraordinarily strange if you haven't run into it
before. The strategy is to put *all* the $x$-variables you want
to plot into *one* column and then plot your $y$ against the
$x$-column. A nice side-effect of the way `gather` works is
that what makes the $x$-columns different is that they are
$x$-variables with different *names*, which is exactly what you
want later for the facets. Thus: make a column of all the $x$'s glued
together, labelled by which $x$ they are, then plot $y$ against $x$
but make a different sub-plot or "facet" for each different
$x$-name. The last thing is that each $x$ is measured on a different
scale, and unless we take steps, all the sub-plots will have the
*same* scale on each axis, which we don't want.

I'm not sure I like how it came out, with three very tall
plots. `facet_wrap` can also take an `nrow` or an
`ncol`, which tells it how many rows or columns to use for the
display. Here, for example, two columns because I thought three was
too many:


```r
rains %>% gather(xname, x, altitude:fromcoast) %>% 
    ggplot(aes(x = x, y = rainfall)) + geom_point() + 
    facet_wrap(~xname, scales = "free", ncol = 2)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-12-1} 

 

Now, the three plots have come out about square, which I like a lot better.



(d) Look at the relationship of each other variable with
`rainfall`. 
Justify the assertion that `latitude` seems most strongly
related with `rainfall`. Is that relationship positive or negative? linear? Explain
briefly. 


Solution


Let's look at the three variables in turn:


* `altitude`: not much of anything. The stations near
sea level have rainfall all over the place, though the three
highest-altitude stations have the three highest rainfalls apart
from Crescent City.

* `latitude`: there is a definite upward trend here, in
that stations further north (higher latitude) are likely to have
a higher rainfall. I'd call this trend linear (or, not obviously
curved), though the two most northerly stations have one higher
and one much lower rainfall than you'd expect.

* `fromcoast`: this is a weak downward trend, though
the trend is spoiled by those three stations about 150 miles
from the coast that have more than 40 inches of rainfall.

Out of those, only `latitude` seems to have any meaningful
relationship with `rainfall`.



(e) Fit a regression with `rainfall` as the response
variable, and `latitude` as your explanatory variable. What
are the intercept, slope and R-squared values? Is there a 
*significant* relationship between `rainfall` and your
explanatory variable? What does that mean?


Solution


Save your `lm` into a
variable, since it will get used again later:

```r
rainfall.1 = lm(rainfall ~ latitude, data = rains)
summary(rainfall.1)
```

```
## 
## Call:
## lm(formula = rainfall ~ latitude, data = rains)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -27.297  -7.956  -2.103   6.082  38.262 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) -113.3028    35.7210  -3.172
## latitude       3.5950     0.9623   3.736
##             Pr(>|t|)    
## (Intercept)  0.00366 ** 
## latitude     0.00085 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 13.82 on 28 degrees of freedom
## Multiple R-squared:  0.3326,	Adjusted R-squared:  0.3088 
## F-statistic: 13.96 on 1 and 28 DF,  p-value: 0.0008495
```

 

My intercept is $-113.3$, slope is $3.6$ and R-squared is $0.33$ or
33\%. (I want you to pull these numbers out of the output and round
them off to something sensible.) The slope is significantly nonzero,
its P-value being 0.00085: rainfall really does depend on latitude, although
not strongly so.

Extra: Of course, I can easily do the others as well, though you don't have to:


```r
rainfall.2 = lm(rainfall ~ fromcoast, data = rains)
summary(rainfall.2)
```

```
## 
## Call:
## lm(formula = rainfall ~ fromcoast, data = rains)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -15.240  -9.431  -6.603   2.871  51.147 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 23.77306    4.61296   5.154
## fromcoast   -0.05039    0.04431  -1.137
##             Pr(>|t|)    
## (Intercept) 1.82e-05 ***
## fromcoast      0.265    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 16.54 on 28 degrees of freedom
## Multiple R-squared:  0.04414,	Adjusted R-squared:   0.01 
## F-statistic: 1.293 on 1 and 28 DF,  p-value: 0.2651
```

 

Here, the intercept is 23.8, the slope is $-0.05$ and R-squared is a
dismal 0.04 (4\%).  This is a way of seeing that this relationship is
really weak, and it doesn't even have a curve to the trend or anything
that would compensate for this. I looked at the scatterplot again and
saw that if it were not for the point bottom right which is furthest
from the coast and has almost no rainfall, there would be almost no
trend at all. The slope here is not significantly different from zero,
with a P-value of 0.265.

Finally:


```r
rainfall.3 = lm(rainfall ~ altitude, data = rains)
summary(rainfall.3)
```

```
## 
## Call:
## lm(formula = rainfall ~ altitude, data = rains)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -20.620  -8.479  -2.729   4.555  58.271 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) 16.514799   3.539141   4.666
## altitude     0.002394   0.001428   1.676
##             Pr(>|t|)    
## (Intercept)  6.9e-05 ***
## altitude       0.105    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 16.13 on 28 degrees of freedom
## Multiple R-squared:  0.09121,	Adjusted R-squared:  0.05875 
## F-statistic:  2.81 on 1 and 28 DF,  p-value: 0.1048
```

 

The intercept is 16.5, the slope is 0.002 and the R-squared is 0.09 or
9\%, also terrible. The P-value is 0.105, which is not small enough to
be significant. 

So it looks as if it's only `latitude` that
has any impact at all. This is the only explanatory variable with a
significantly nonzero slope. On its own, at least.



(f) Fit a multiple regression predicting `rainfall` from
all three of the other (quantitative) variables. Display the
results. Comment is coming up later.


Solution


This, then:

```r
rainfall.4 = lm(rainfall ~ latitude + altitude + 
    fromcoast, data = rains)
summary(rainfall.4)
```

```
## 
## Call:
## lm(formula = rainfall ~ latitude + altitude + fromcoast, data = rains)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -28.722  -5.603  -0.531   3.510  33.317 
## 
## Coefficients:
##               Estimate Std. Error t value
## (Intercept) -1.024e+02  2.921e+01  -3.505
## latitude     3.451e+00  7.949e-01   4.342
## altitude     4.091e-03  1.218e-03   3.358
## fromcoast   -1.429e-01  3.634e-02  -3.931
##             Pr(>|t|)    
## (Intercept) 0.001676 ** 
## latitude    0.000191 ***
## altitude    0.002431 ** 
## fromcoast   0.000559 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 11.1 on 26 degrees of freedom
## Multiple R-squared:  0.6003,	Adjusted R-squared:  0.5542 
## F-statistic: 13.02 on 3 and 26 DF,  p-value: 2.205e-05
```

 



(g) What is the R-squared for the regression of the last part?
How does that compare with the R-squared of your regression in part (e)?


Solution


The R-squared is 0.60 (60\%), which is quite a bit bigger than the
R-squared of 0.33 (33\%) we got back in (e). 



(h) What do you conclude about the importance of the variables
that you did *not* include in your model in
(e)? Explain briefly.


Solution


Both variables `altitude` and `fromcoast` are
significant in this regression, so they have *something to add* over and above `latitude` when it comes to
predicting rainfall, even though (and this seems odd) they have no
apparent relationship with `rainfall` on their own. 
Another way to say this is that the three variables work together
as a team to predict rainfall, and together they do much better
than any one of them can do by themselves.  
This also goes to show that the scatterplots we began
with don't get to the heart of multi-variable relationships,
because they are only looking at the variables two at a time.



(i) Make a suitable hypothesis test that the variables
`altitude` and `fromcoast` significantly improve the
prediction of `rainfall` over the use of `latitude`
alone. What do you conclude?


Solution


This calls for `anova`. Feed this two fitted models,
smaller (fewer explanatory variables) first. The null hypothesis
is that the two models are equally good (so we should go with the
smaller); the alternative is that the larger model is better, so
that the extra complication is worth it:

```r
anova(rainfall.1, rainfall.4)
```

```
## Analysis of Variance Table
## 
## Model 1: rainfall ~ latitude
## Model 2: rainfall ~ latitude + altitude + fromcoast
##   Res.Df    RSS Df Sum of Sq      F   Pr(>F)
## 1     28 5346.8                             
## 2     26 3202.3  2    2144.5 8.7057 0.001276
##     
## 1   
## 2 **
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

The P-value is small, so we reject the null in favour of the
alternative: the regression with all three explanatory variables fits
better than the one with just `latitude`, so the bigger model
is the one we should go with.

If you have studied these things: this one is a 
"multiple-partial $F$-test", for testing the combined significance of more than one $x$
but less than all the $x$'s.
\marginnote{If you had just one $x$, you'd  use a $t$-test for its slope, and if you were testing all the $x$'s, you'd use the global $F$-test that appears in the regression output.}







##  Carbon monoxide in cigarettes


 The (US) Federal Trade Commission assesses cigarettes
according to their tar, nicotine and carbon monoxide contents. In a
particular year, 25 brands were assessed. For each brand, the tar,
nicotine and carbon monoxide (all in milligrams) were measured, along
with the weight in grams. Our aim is to predict carbon monoxide from
any or all of the other variables. The data are in
[link](http://www.utsc.utoronto.ca/~butler/c32/ftccigar.txt). These are
aligned by column (except for the variable names), with more than one
space between each column of data.


(a) Read the data into R, and check that you have 25 observations
and 4 variables.


Solution


This specification calls for `read_table2`:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/ftccigar.txt"
cigs = read_table2(my_url)
```

```
## Parsed with column specification:
## cols(
##   tar = col_double(),
##   nicotine = col_double(),
##   weight = col_double(),
##   co = col_double()
## )
```

```r
cigs
```

```
## # A tibble: 25 x 4
##      tar nicotine weight    co
##    <dbl>    <dbl>  <dbl> <dbl>
##  1  14.1     0.86  0.985  13.6
##  2  16       1.06  1.09   16.6
##  3  29.8     2.03  1.16   23.5
##  4   8       0.67  0.928  10.2
##  5   4.1     0.4   0.946   5.4
##  6  15       1.04  0.888  15  
##  7   8.8     0.76  1.03    9  
##  8  12.4     0.95  0.922  12.3
##  9  16.6     1.12  0.937  16.3
## 10  14.9     1.02  0.886  15.4
## # ... with 15 more rows
```

 
Yes, I have 25 observations on 4 variables indeed.

`read_delim` won't work (try it and see what happens), because
that would require the values to be separated by *exactly one* space.




(b) Run a regression to predict carbon monoxide from the other
variables, and obtain a summary of the output.


Solution


The word "summary" is meant to be a big clue that
`summary` is what you need:

```r
cigs.1 = lm(co ~ tar + nicotine + weight, data = cigs)
summary(cigs.1)
```

```
## 
## Call:
## lm(formula = co ~ tar + nicotine + weight, data = cigs)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -2.89261 -0.78269  0.00428  0.92891  2.45082 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)   3.2022     3.4618   0.925
## tar           0.9626     0.2422   3.974
## nicotine     -2.6317     3.9006  -0.675
## weight       -0.1305     3.8853  -0.034
##             Pr(>|t|)    
## (Intercept) 0.365464    
## tar         0.000692 ***
## nicotine    0.507234    
## weight      0.973527    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 1.446 on 21 degrees of freedom
## Multiple R-squared:  0.9186,	Adjusted R-squared:  0.907 
## F-statistic: 78.98 on 3 and 21 DF,  p-value: 1.329e-11
```

 



(c) Which one of your explanatory variables would you
remove from this regression? Explain (very) briefly. Go ahead and
fit the regression  without it, and describe how the change in
R-squared from the regression in (b) was entirely predictable.


Solution


First, the $x$-variable to remove. The obvious candidate is
`weight`, since it has easily the highest, and clearly
non-significant, P-value. So, out it comes:

```r
cigs.2 = lm(co ~ tar + nicotine, data = cigs)
summary(cigs.2)
```

```
## 
## Call:
## lm(formula = co ~ tar + nicotine, data = cigs)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -2.89941 -0.78470 -0.00144  0.91585  2.43064 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)   3.0896     0.8438   3.662
## tar           0.9625     0.2367   4.067
## nicotine     -2.6463     3.7872  -0.699
##             Pr(>|t|)    
## (Intercept) 0.001371 ** 
## tar         0.000512 ***
## nicotine    0.492035    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 1.413 on 22 degrees of freedom
## Multiple R-squared:  0.9186,	Adjusted R-squared:  0.9112 
## F-statistic: 124.1 on 2 and 22 DF,  p-value: 1.042e-12
```

 

R-squared has dropped from 0.9186 to \ldots 0.9186! That is, taking
out `weight` has not just had a minimal effect on R-squared;
it's not changed R-squared at all. This is because `weight` was
so far from being significant: it literally had *nothing* to add.

Another way of achieving the same thing is via the function
`update`, which takes a fitted model object and describes the
*change* that you want to make:


```r
cigs.2a = update(cigs.1, . ~ . - weight)
summary(cigs.2a)
```

```
## 
## Call:
## lm(formula = co ~ tar + nicotine, data = cigs)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -2.89941 -0.78470 -0.00144  0.91585  2.43064 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)   3.0896     0.8438   3.662
## tar           0.9625     0.2367   4.067
## nicotine     -2.6463     3.7872  -0.699
##             Pr(>|t|)    
## (Intercept) 0.001371 ** 
## tar         0.000512 ***
## nicotine    0.492035    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 1.413 on 22 degrees of freedom
## Multiple R-squared:  0.9186,	Adjusted R-squared:  0.9112 
## F-statistic: 124.1 on 2 and 22 DF,  p-value: 1.042e-12
```

 

This can be shorter than describing the whole model again, as you do
with the `cigs.2` version of `lm`. The syntax is that
you first specify a "base"  fitted model object that you're going to
update. Because the model `cigs.1` contains all the information
about the kind of model it is, and which data frame the data come
from, R already knows that this is a linear 
multiple regression and which $x$'s it contains. The second thing to describe is the change from
the "base". In this case, we want to use the same response variable
and all the same explanatory variables that we had before, except for
`weight`. This is specified by a special kind of model formula
where `.` means "whatever was there before": in English,
"same response and same explanatories except take out `weight`". 



(d) Fit a regression predicting carbon monoxide from
`nicotine` *only*, and display the summary.


Solution


As you would guess:

```r
cigs.3 = lm(co ~ nicotine, data = cigs)
summary(cigs.3)
```

```
## 
## Call:
## lm(formula = co ~ nicotine, data = cigs)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.3273 -1.2228  0.2304  1.2700  3.9357 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)   1.6647     0.9936   1.675
## nicotine     12.3954     1.0542  11.759
##             Pr(>|t|)    
## (Intercept)    0.107    
## nicotine    3.31e-11 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 1.828 on 23 degrees of freedom
## Multiple R-squared:  0.8574,	Adjusted R-squared:  0.8512 
## F-statistic: 138.3 on 1 and 23 DF,  p-value: 3.312e-11
```

 



(e) `nicotine` was far from being significant in the model
of (c), and yet in the model of
(d), it was *strongly* significant, and the
R-squared value of (d) was almost as high as that
of (c). What does this say about the importance of
`nicotine` as an explanatory variable? Explain, as briefly as
you can manage.


Solution


What this says is that you *cannot* say anything about the
"importance" of `nicotine` without also describing the
context that you're talking about.  *By itself*,
`nicotine` is important, but \emph{when you have
`tar` in the model}, `nicotine` is not
important: precisely, it now has nothing to add over and above
the predictive value that `tar` has. You might guess that
this is because `tar` and `nicotine` are 
"saying  the same thing" in some fashion. 
We'll explore that in a moment.



(f) Make a "pairs plot": that is, scatter plots between all
pairs of variables. This can be done by feeding the whole data frame
into `plot`.
\marginnote{This is a base graphics graph rather    than a ggplot one, but it will do for our purposes.}
Do you see any strong relationships that do
*not* include `co`? Does that shed any light on the last
part? Explain briefly (or "at length" if that's how it comes
out). 


Solution


Plot the entire data frame:

```r
plot(cigs)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-23-1} 

 

We're supposed to ignore `co`, but I comment that strong
relationships between `co` and *both* of `tar` and
`nicotine` show up here, along with `weight` being
at most weakly related to anything else.

That leaves the relationship of `tar` and `nicotine`
with each other. That also looks like a strong linear trend. When you
have correlations between explanatory variables, it is called
"multicollinearity". 

I mentioned a while back (in class) that having correlated $x$'s was
trouble. Here is where we find out why. The problem is that when
`co` is large, `nicotine` is large, and a large value of
`tar` will come along with it. So we don't know whether a large
value of `co` is caused by a large value of `tar` or a
large value of `nicotine`: there is no way to separate out
their effects because in effect they are "glued together". 

You might know of this effect (in an experimental design context) as
"confounding": the effect of `tar` on `co` is
confounded with the effect of `nicotine` on `co`, and
you can't tell which one deserves the credit for predicting `co`.

If you were able to design an experiment here, you could (in
principle) manufacture a bunch of cigarettes with high tar; some of
them would have high  nicotine and some would have low. Likewise for
low tar. Then the
correlation between `nicotine` and `tar` would go away,
their effects on `co` would no longer be confounded, and you
could see unambiguously which one of the variables deserves credit for
predicting `co`. Or maybe it depends on both, genuinely, but at
least then you'd know.

We, however, have an observational study, so we have to make do with
the data we have. Confounding is one of the risks we take when we work
with observational data.

This was a "base graphics" plot. There is a way of doing a
`ggplot`-style "pairs plot", as this is called, thus:


```r
library(GGally)
```

```
## 
## Attaching package: 'GGally'
```

```
## The following object is masked from 'package:dplyr':
## 
##     nasa
```

```r
cigs %>% ggpairs()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-24-1} 

 

As ever, `install.packages` first, in the likely event that you
don't have this package installed yet. Once you do, though, I think
this is a nicer way to get a pairs plot.

This plot is a bit more sophisticated: instead of just having the
scatterplots of the pairs of variables in the row and column, it uses
the diagonal to show a "kernel density" (a smoothed-out histogram),
and upper-right it shows the correlation between each pair of
variables. The three correlations between `co`, `tar`
and `nicotine` are clearly the highest.

If you want only some of the columns to appear in your pairs plot,
`select` them first, and then pass that data frame into
`ggpairs`. Here, we found that `weight` was not
correlated with anything much, so we can take it out and then make a
pairs plot of the other variables:


```r
cigs %>% select(-weight) %>% ggpairs()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-25-1} 

 

The three correlations that remain are all very high, which is
entirely consistent with the strong linear relationships that you see
bottom left.







##  Maximal oxygen uptake in young boys


 A physiologist wanted to understand the relationship between
physical characteristics of pre-adolescent boys and their maximal
oxygen uptake (millilitres of oxygen per kilogram of body weight). The
data are in
[link](http://www.utsc.utoronto.ca/~butler/c32/youngboys.txt) for a
random sample of 10 pre-adolescent boys. The variables are (with
units):



* `uptake`: Oxygen uptake (millitres of oxygen per kilogram
of body weight)

* `age`: boy's age (years)

* `height`: boy's height (cm)

* `weight`: boy's weight (kg)

* `chest`: chest depth (cm).




(a) Read the data into R and confirm that you do indeed have
10 observations.


Solution



```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/youngboys.txt"
boys = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   uptake = col_double(),
##   age = col_double(),
##   height = col_double(),
##   weight = col_double(),
##   chest = col_double()
## )
```

```r
boys
```

```
## # A tibble: 10 x 5
##    uptake   age height weight chest
##     <dbl> <dbl>  <dbl>  <dbl> <dbl>
##  1   1.54   8.4   132    29.1  14.4
##  2   1.74   8.7   136.   29.7  14.5
##  3   1.32   8.9   128.   28.4  14  
##  4   1.5    9.9   131.   28.8  14.2
##  5   1.46   9     130    25.9  13.6
##  6   1.35   7.7   128.   27.6  13.9
##  7   1.53   7.3   130.   29    14  
##  8   1.71   9.9   138.   33.6  14.6
##  9   1.27   9.3   127.   27.7  13.9
## 10   1.5    8.1   132.   30.8  14.5
```

         

10 boys (rows) indeed.



(b) Fit a regression predicting oxygen uptake from all the
other variables, and display the results.


Solution


Fitting four explanatory variables with only ten observations is likely to be pretty shaky, but we 
press ahead regardless:

```r
boys.1 = lm(uptake ~ age + height + weight + chest, 
    data = boys)
summary(boys.1)
```

```
## 
## Call:
## lm(formula = uptake ~ age + height + weight + chest, data = boys)
## 
## Residuals:
##         1         2         3         4 
## -0.020697  0.019741 -0.003649  0.038470 
##         5         6         7         8 
## -0.023639 -0.026026  0.050459 -0.014380 
##         9        10 
##  0.004294 -0.024573 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) -4.774739   0.862818  -5.534
## age         -0.035214   0.015386  -2.289
## height       0.051637   0.006215   8.308
## weight      -0.023417   0.013428  -1.744
## chest        0.034489   0.085239   0.405
##             Pr(>|t|)    
## (Intercept) 0.002643 ** 
## age         0.070769 .  
## height      0.000413 ***
## weight      0.141640    
## chest       0.702490    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.03721 on 5 degrees of freedom
## Multiple R-squared:  0.9675,	Adjusted R-squared:  0.9415 
## F-statistic:  37.2 on 4 and 5 DF,  p-value: 0.0006513
```

         



(c) (A one-mark question.) Would you say, on the evidence so
far, that the regression fits well or badly?  Explain (very)
briefly.


Solution


R-squared of 0.97 (97\%) is very high, so I'd say this
regression fits very well. That's all.
I said "on the evidence so far" to dissuade you from
overthinking this, or thinking that you needed to produce
some more evidence. That, plus the fact that this was only
one mark.



(d) It seems reasonable that an older boy should have a
greater oxygen uptake, all else being equal. Is this supported
by your output?  Explain briefly.


Solution


If an older boy has greater oxygen uptake (the "all else   equal" was a hint), 
the slope of `age` should be
positive. It is not: it is $-0.035$, so it is suggesting
(all else equal) that a greater age goes with a
*smaller* oxygen uptake.
The reason why this happens (which you didn't need, but
you can include it if you like) is that `age` has a
non-small P-value of 0.07, so that the `age` slope
is not significantly different from zero. With all the
other variables, `age` has nothing to *add*
over and above them, and we could therefore remove it.



(e) It seems reasonable that a boy with larger weight
should have larger lungs and thus a \emph{statistically
significantly} larger oxygen uptake. Is that what happens
here? Explain briefly.


Solution


Look at the P-value for `weight`. This is 0.14,
not small, and so a boy with larger weight does not have
a significantly larger oxygen uptake, all else
equal. (The slope for `weight` is not
significantly different from zero either.)
I emphasized "statistically significant" to remind you
that this means to do a test and get a P-value.



(f) Fit a model that contains only the significant
explanatory variables from your first regression. How do
the R-squared values from the two regressions compare?
(The last sentence asks for more or less the same thing as
the next part. Answer it either here or there. Either
place is good.)


Solution


Only `height` is significant, so that's the
only explanatory variable we need to keep. I would
just do the regression straight rather than using
`update` here:

```r
boys.2 = lm(uptake ~ height, data = boys)
summary(boys.2)
```

```
## 
## Call:
## lm(formula = uptake ~ height, data = boys)
## 
## Residuals:
##       Min        1Q    Median        3Q 
## -0.069879 -0.033144  0.001407  0.009581 
##       Max 
##  0.084012 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) -3.843326   0.609198  -6.309
## height       0.040718   0.004648   8.761
##             Pr(>|t|)    
## (Intercept) 0.000231 ***
## height      2.26e-05 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.05013 on 8 degrees of freedom
## Multiple R-squared:  0.9056,	Adjusted R-squared:  0.8938 
## F-statistic: 76.75 on 1 and 8 DF,  p-value: 2.258e-05
```

        

If you want, you can use `update` here, which looks like this:


```r
boys.2a = update(boys.1, . ~ . - age - weight - 
    chest)
summary(boys.2a)
```

```
## 
## Call:
## lm(formula = uptake ~ height, data = boys)
## 
## Residuals:
##       Min        1Q    Median        3Q 
## -0.069879 -0.033144  0.001407  0.009581 
##       Max 
##  0.084012 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) -3.843326   0.609198  -6.309
## height       0.040718   0.004648   8.761
##             Pr(>|t|)    
## (Intercept) 0.000231 ***
## height      2.26e-05 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.05013 on 8 degrees of freedom
## Multiple R-squared:  0.9056,	Adjusted R-squared:  0.8938 
## F-statistic: 76.75 on 1 and 8 DF,  p-value: 2.258e-05
```

 

This doesn't go quite so smoothly here because there are three
variables being removed, and it's a bit of work to type them all. 



(g) How has R-squared changed between your two
regressions? Describe what you see in a few words.


Solution


R-squared has dropped by a bit, from 97\% to 91\%. (Make your own
call: pull out the two R-squared numbers, and say a word or two about
how they compare. I don't much mind what you say: 
"R-squared has decreased (noticeably)", "R-squared has hardly changed". But say
something.)

 

(h) Carry out a test comparing the fit of your
two regression models. What do you conclude, and
therefore what recommendation would you make about the
regression that would be preferred?


Solution


The word "test" again implies something that  produces a P-value with a
null hypothesis that you might reject. In this case, the test that
compares two models differing by more than one $x$ uses
`anova`, testing the null hypothesis that the two regressions
are equally good, against the alternative that the bigger (first) one
is better. Feed `anova` two fitted model objects, smaller first:


```r
anova(boys.2, boys.1)
```

```
## Analysis of Variance Table
## 
## Model 1: uptake ~ height
## Model 2: uptake ~ age + height + weight + chest
##   Res.Df       RSS Df Sum of Sq      F
## 1      8 0.0201016                    
## 2      5 0.0069226  3  0.013179 3.1729
##   Pr(>F)
## 1       
## 2  0.123
```

 

This P-value of 0.123 is not small, so we do not reject the null
hypothesis. There is not a significant difference in fit between the
two models. Therefore, we should go with the smaller model
`boys.2` because it is simpler. 

That drop in R-squared from 97\% to 91\% was, it turns out, *not*
significant: the three extra variables
could have produced a change in R-squared like that, 
*even if  they were worthless*.
\marginnote{Recall that adding $x$'s to a regression will always make R-squared go up, even if they are just random noise.}

If you have learned about "adjusted R-squared", you might recall
that this is supposed to go down *only* if the variables you took
out should not have been taken out. But adjusted R-squared goes down
here as well, from 94\% to 89\% (not quite as much, therefore). What
happens is that adjusted R-squared is rather more relaxed about
keeping variables than the `anova` $F$-test is; if we had used
an $\alpha$ of something like 0.10, the decision between the two
models would have been a lot closer, and this is reflected in the
adjusted R-squared values.



(i) Obtain a table of correlations between all
the variables in the data frame. Do this by feeding
the whole data frame into `cor`. 
We found that a regression predicting oxygen uptake
from just `height` was acceptably good. What
does your table of correlations say about why that
is? (Hint: look for all the correlations that are
*large*.) 


Solution


Correlations first:


```r
cor(boys)
```

```
##           uptake       age    height
## uptake 1.0000000 0.1361907 0.9516347
## age    0.1361907 1.0000000 0.3274830
## height 0.9516347 0.3274830 1.0000000
## weight 0.6576883 0.2307403 0.7898252
## chest  0.7182659 0.1657523 0.7909452
##           weight     chest
## uptake 0.6576883 0.7182659
## age    0.2307403 0.1657523
## height 0.7898252 0.7909452
## weight 1.0000000 0.8809605
## chest  0.8809605 1.0000000
```

 
The correlations with `age` are all on the low side, but all
the other correlations are high, not just between `uptake` and the
other variables, but between the explanatory variables as well.

Why is this helpful in understanding what's going on? Well, imagine a
boy with large height (a tall one). The regression `boys.2`
says that this alone is enough to predict that such a boy's oxygen
uptake is likely to be large, since the slope is positive. But the
correlations tell you more: a boy with large height is also (somewhat)
likely to be older (have large age), heavier (large weight) and to have
larger `chest` cavity. So oxygen uptake does depend on those other
variables as well, but once you know `height` you can make a
good guess at their values; you don't need to know them.

Further remarks: `age` has a low correlation with
`uptake`, so its non-significance earlier appears to be
"real": it really does have nothing extra to say, because the other
variables have a stronger link with `uptake` than
`age`. Height, however, seems to be the best way of relating
oxygen uptake to any of the other variables. I think the suppositions
from earlier about relating oxygen uptake to "bigness"
\marginnote{This  is not, I don't think, a real word, but I mean size emphasizing  how big a boy is generally, rather than how small.} in some sense
are actually sound, but age and weight and `chest` capture
"bigness" worse than height does. Later, when you learn about
Principal Components, you will see that the first principal component,
the one that best captures how the variables vary together, is often
"bigness" in some sense.

Another way to think about these things is via pairwise
scatterplots. The nicest way to produce these is via `ggpairs`
from package `GGally`:


```r
boys %>% ggpairs()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-32-1} 

 

A final remark: with five variables, we really ought to have more than
ten observations (something like 50 would be better). But with more
observations and the same correlation structure, the same issues would
come up again, so the question would not be materially changed.


 





## Facebook friends and grey matter



 Is there a relationship between the number
of Facebook friends a person has, and the density of grey matter in
the areas of the brain associated with social perception and
associative memory? To find out, a 2012 study measured both of these
variables for a sample of 40 students at City University in London
(England). The data are at
[link](http://www.utsc.utoronto.ca/~butler/c32/facebook.txt). The grey
matter density is on a $z$-score standardized scale. The values are
separated by *tabs*.

The aim of this question is to produce an R Markdown report that
contains your answers to the questions below. 

You should aim to make your report flow smoothly, so that it would be
pleasant for a grader to read, and can stand on its own as an analysis
(rather than just being the answer to a question that I set you).
Some suggestions: give your report a title and arrange it into
sections with an Introduction; add a small amount of additional text
here and there explaining what you are doing and why. I don't expect
you to spend a large amount of time on this, but I *do* hope
you will make some effort. (My report came out to 4 Word pages.)


(a) Read in the data and make a scatterplot for predicting the
number of Facebook friends from the grey matter density. On your
scatterplot, add a smooth trend.


Solution


Begin your document with a code chunk containing
`library(tidyverse)`. The data values are
separated by tabs, which you will need to take into account:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/facebook.txt"
fb = read_tsv(my_url)
```

```
## Parsed with column specification:
## cols(
##   GMdensity = col_double(),
##   FBfriends = col_integer()
## )
```

```r
fb
```

```
## # A tibble: 40 x 2
##    GMdensity FBfriends
##        <dbl>     <int>
##  1      -1.8        23
##  2       0.1        35
##  3      -1.2        80
##  4      -0.4       110
##  5      -0.9       120
##  6      -2.1       140
##  7      -1.5       168
##  8       0.5       132
##  9       0.6       154
## 10      -0.5       241
## # ... with 30 more rows
```

```r
ggplot(fb, aes(x = GMdensity, y = FBfriends)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-33-1} 

       



(b) Describe what you see on your scatterplot: is there a
trend, and if so, what kind of trend is it? (Don't get too taken in
by the exact shape of your smooth trend.) Think "form, direction,  strength". 


Solution


I'd say there seems to be a weak, upward, apparently linear
trend. The points are not especially close to the trend, so I
don't think there's any justification for calling this other
than "weak". (If you think the trend is, let's say,
"moderate", you ought to say what makes you think that: for
example, that the people with a lot of Facebook friends also
tend to have a higher grey matter density. I can live with a
reasonably-justified "moderate".)
The reason I said not to get taken in by the shape of the smooth
trend is that this has a "wiggle" in it: it goes down again
briefly in the middle. But this is likely a quirk of the data,
and the trend, if there is any, seems to be an upward one.



(c) Fit a regression predicting the number of Facebook friends
from the grey matter density, and display the output.


Solution


That looks like this. You can call the "fitted model object"
whatever you like, but you'll need to get the capitalization of
the  variable names correct:

```r
fb.1 = lm(FBfriends ~ GMdensity, data = fb)
summary(fb.1)
```

```
## 
## Call:
## lm(formula = FBfriends ~ GMdensity, data = fb)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -339.89 -110.01   -5.12   99.80  303.64 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)   366.64      26.35  13.916
## GMdensity      82.45      27.58   2.989
##             Pr(>|t|)    
## (Intercept)  < 2e-16 ***
## GMdensity    0.00488 ** 
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 165.7 on 38 degrees of freedom
## Multiple R-squared:  0.1904,	Adjusted R-squared:  0.1691 
## F-statistic: 8.936 on 1 and 38 DF,  p-value: 0.004882
```

       

I observe, though I didn't ask you to, that the R-squared is pretty
awful, going with a correlation of 

```r
sqrt(0.1904)
```

```
## [1] 0.4363485
```

 

which *would* look
like as weak of a trend as we saw.
\marginnote{Correlations have to go up beyond 0.50 before they start looking at all interesting.}



(d) Is the slope of your regression line significantly
different from zero? What does that mean, in the context of the
data?


Solution


The P-value of the slope is 0.005, which is less than
0.05. Therefore the slope *is* significantly different from
zero. That means that the number of Facebook friends really does
depend on the grey matter density, for the whole population of
interest and not just the 40 students observed here (that were a
sample from that population). I don't mind so much what you
think the population is, but it needs to be clear that the
relationship applies to a population. 
Another way to approach this is to say that you would expect
this relationship to show up again in another similar
experiment. That also works, because it gets at the idea of
reproducibility. 



(e) Are you surprised by the results of
parts (b) and (d)? Explain briefly.


Solution


I *am* surprised, because I thought the trend on the
scatterplot was so weak that there would not be a significant
slope. I guess there was enough of an upward trend to be
significant, and with $n=40$ observations we were able to get a
significant slope out of that scatterplot. With this many
observations, even a weak correlation can be significantly
nonzero. 
You can be surprised or not, but you need to have some kind of
consideration of the strength of the trend on the scatterplot as
against the significance of the slope. For example, if you
decided that the trend was "moderate" in strength, you would
be justified in being less surprised than I was. 
Here, there is the usual issue that we have proved that the
slope is not zero (that the relationship is not flat), but we
may not have a very clear idea of what the slope actually
*is*. There are a couple of ways to get a confidence
interval. The obvious one is to use R as a calculator and go up
and down twice its standard error (to get a rough idea):

```r
82.45 + 2 * 27.58 * c(-1, 1)
```

```
## [1]  27.29 137.61
```

       
The `c()` thing is to get both confidence limits at once. The
smoother way is this:


```r
confint(fb.1)
```

```
##                 2.5 %   97.5 %
## (Intercept) 313.30872 419.9810
## GMdensity    26.61391 138.2836
```

 

Feed `confint` a "fitted model object" and it'll give you
confidence intervals (by default 95\%) for all the parameters in it. 

The confidence interval for the slope goes from about 27 to about
138. That is to say, a one-unit increase in grey matter density goes
with an increase in Facebook friends of this much. This is not
especially insightful: it's bigger than zero (the test was
significant), but other than that, it could be almost
anything. *This* is where the weakness of the trend comes back to
bite us. With this much scatter in our data, we need a *much*
larger sample size to estimate accurately how big an effect grey
matter density has.



(f) Obtain a scatterplot with the regression line on it.


Solution


Just a modification
of (a):

```r
ggplot(fb, aes(x = GMdensity, y = FBfriends)) + 
    geom_point() + geom_smooth(method = "lm")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-38-1} 

       



(g) Obtain a plot of the residuals from the regression against
the fitted values, and comment briefly on it.


Solution


This is, to my mind, the easiest way:

```r
ggplot(fb.1, aes(x = .fitted, y = .resid)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-39-1} 

       

There is some "magic" here, since the fitted model object is not
actually a data frame, but it works this way.
That looks to me like a completely random scatter of
points. Thus, I am completely happy with the straight-line regression
that we fitted, and I see no need to improve it.

(You should make two points here: one, describe what you see, and two,
what it implies about whether or not your regression is satisfactory.)

Compare that residual plot with this one:


```r
ggplot(fb.1, aes(x = .fitted, y = .resid)) + geom_point() + 
    geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-40-1} 

       
Now, why did I try adding a smooth trend, and why is it not
necessarily a good idea? The idea of a residual plot is that there
should be no trend, and so the smooth trend curve ought to go straight
across. The problem is that it will tend to wiggle, just by chance, as
here: it looks as if it goes up and down before flattening out. But if
you look at the points, *they* are all over the place, not close
to the smooth trend at all. So the smooth trend is rather
deceiving. Or, to put it another way, to indicate a real problem, the
smooth trend would have to be a *lot* farther from flat than this
one is. I'd call this one basically flat.






##  Endogenous nitrogen excretion in carp


 A paper in Fisheries Science reported on variables that
affect "endogenous nitrogen excretion" or ENE in carp raised in
Japan. A number of carp were divided into groups based on body weight,
and each group was placed in a different tank. The mean body weight of
the carp placed in each tank was recorded. The carp were then fed a
protein-free diet three times daily for a period of 20 days. At the
end of the experiment, the amount of ENE in each tank was measured, in
milligrams of total fish body weight per day. (Thus it should not
matter that some of the tanks had more fish than others, because the
scaling is done properly.)

For this question, write a report in R Markdown that answers the
questions below and contains some narrative that describes your
analysis. Create an HTML document from your R Markdown.



(a) Read the data in from
[link](http://www.utsc.utoronto.ca/~butler/c32/carp.txt). There are 10
tanks. 


Solution


Just this. Listing the data is up to you, but doing so and
commenting that the values appear to be correct will improve your report.

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/carp.txt"
carp = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   tank = col_integer(),
##   bodyweight = col_double(),
##   ENE = col_double()
## )
```

```r
carp
```

```
## # A tibble: 10 x 3
##     tank bodyweight   ENE
##    <int>      <dbl> <dbl>
##  1     1       11.7  15.3
##  2     2       25.3   9.3
##  3     3       90.2   6.5
##  4     4      213     6  
##  5     5       10.2  15.7
##  6     6       17.6  10  
##  7     7       32.6   8.6
##  8     8       81.3   6.4
##  9     9      142.    5.6
## 10    10      286.    6
```

 



(b) Create a scatterplot of ENE (response) against bodyweight
(explanatory). Add a smooth trend to your plot.


Solution



```r
ggplot(carp, aes(x = bodyweight, y = ENE)) + geom_point() + 
    geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-42-1} 

 

This part is just about getting the plot. Comments are coming in a
minute. Note that `ENE` is capital letters, so that
`ene` will not work.



(c) Is there an upward or downward trend (or neither)? Is the
relationship a line or a curve? Explain briefly.


Solution


The trend is downward: as bodyweight increases, ENE
decreases. However, the decrease is rapid at first and then levels
off, so the relationship is nonlinear. I want some kind of
support for an assertion of non-linearity: anything that says that
the slope or rate of decrease is not constant is good.



(d) Fit a straight line to the data, and obtain the R-squared
for the regression.


Solution


`lm`. The first stage is to fit the straight line, saving
the result in a  variable, and the second stage is to look at the
"fitted model object", here via `summary`:

```r
carp.1 = lm(ENE ~ bodyweight, data = carp)
summary(carp.1)
```

```
## 
## Call:
## lm(formula = ENE ~ bodyweight, data = carp)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -2.800 -1.957 -1.173  1.847  4.572 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 11.40393    1.31464   8.675
## bodyweight  -0.02710    0.01027  -2.640
##             Pr(>|t|)    
## (Intercept) 2.43e-05 ***
## bodyweight    0.0297 *  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.928 on 8 degrees of freedom
## Multiple R-squared:  0.4656,	Adjusted R-squared:  0.3988 
## F-statistic: 6.971 on 1 and 8 DF,  p-value: 0.0297
```

 
Finally, you need to give me a (suitably rounded) value for
R-squared: 46.6\% or 47\% or the equivalents as a decimal. I just
need the value at this point.
This kind of R-squared is actually pretty good for natural data, but
the issue is whether we can improve it by fitting a non-linear
model.
\marginnote{The suspicion being that we can, since the    scatterplot suggested serious non-linearity.}



(e) Obtain a residual plot (residuals against fitted values)
for this regression. Do you see any problems? If so, what does that
tell you about the relationship in the data?


Solution



This is the easiest way: feed the output of the regression
straight into `ggplot`:


```r
ggplot(carp.1, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-44-1} 

 



(f) Fit a parabola to the data (that is, including an
$x$-squared term). Compare the R-squared values for the models in
this part and part (d). Does that suggest that the parabola
model is an improvement here over the linear model?


Solution


Add bodyweight-squared to
the regression. Don't forget the `I()`:

```r
carp.2 = lm(ENE ~ bodyweight + I(bodyweight^2), 
    data = carp)
summary(carp.2)
```

```
## 
## Call:
## lm(formula = ENE ~ bodyweight + I(bodyweight^2), data = carp)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -2.0834 -1.7388 -0.5464  1.3841  2.9976 
## 
## Coefficients:
##                   Estimate Std. Error
## (Intercept)     13.7127373  1.3062494
## bodyweight      -0.1018390  0.0288109
## I(bodyweight^2)  0.0002735  0.0001016
##                 t value Pr(>|t|)    
## (Intercept)      10.498 1.55e-05 ***
## bodyweight       -3.535  0.00954 ** 
## I(bodyweight^2)   2.692  0.03101 *  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.194 on 7 degrees of freedom
## Multiple R-squared:  0.7374,	Adjusted R-squared:  0.6624 
## F-statistic: 9.829 on 2 and 7 DF,  p-value: 0.009277
```

 

R-squared has gone up from 47\% to 74\%, a substantial
improvement. This suggests to me that the parabola model is a
substantial improvement.
\marginnote{Again, not a surprise, given our  initial scatterplot.} 

I try to avoid using the word "significant" in this context, since
we haven't actually done a test of significance.

The reason for the `I()` is that the up-arrow has a special
meaning in `lm`, relating to interactions between factors (as
in ANOVA), that we don't want here. Putting `I()` around it
means "use as is", that is, raise bodyweight to power 2, rather than
using the special meaning of the up-arrow in `lm`.

Because it's the up-arrow that is the problem, this applies whenever
you're raising an explanatory variable to a power (or taking a
reciprocal or a square root, say).



(g) Is the test for the slope coefficient for the squared term
significant? What does this mean?


Solution


Look along the `bodyweight`-squared line to get a P-value
of 0.031. This is less than the default 0.05, so it *is*
significant.
This means, in short, that the quadratic model is a significant
*improvement* over the linear one.
\marginnote{Now we can use that word   *significant*.} 
Said longer: the null hypothesis being tested is that the slope
coefficient of the squared term is zero (that is, that the squared
term has nothing to add over the linear model). This is rejected,
so the squared term has *something* to add in terms of
quality of prediction.



(h) Make the scatterplot of part (b), but add
the fitted curve. Describe any way in which the curve fails to fit well.


Solution


This is a bit slippery, because the points to plot and the
fitted curve are from different data frames. What you do in this
case is to put a `data=` in one of the `geom`s,
which says "don't use the data frame that was in the  `ggplot`, but use this one instead". 
I would think about
starting with the regression object `carp.2` as my base
data frame, since we want (or I want) to do two things with
that: plot the fitted values and join them with lines. Then I
want to add the original data, just the points:

```r
ggplot(carp.2, aes(x = carp$bodyweight, y = .fitted), 
    colour = "blue") + geom_line(colour = "blue") + 
    geom_point(data = carp, aes(x = bodyweight, 
        y = ENE))
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-46-1} 

       

This works, but is not very aesthetic, because the bodyweight that is
plotted against the fitted values is in the wrong data frame, and so
we have to use the dollar-sign thing to get it from the right one.

A better way around this is "augment" the data with output from the regression object. 
This is done using `augment` from 
package `broom`:

```r
library(broom)
carp.2a = augment(carp.2, carp)
carp.2a
```

```
## # A tibble: 10 x 10
##     tank bodyweight   ENE .fitted .se.fit
##  * <int>      <dbl> <dbl>   <dbl>   <dbl>
##  1     1       11.7  15.3   12.6    1.07 
##  2     2       25.3   9.3   11.3    0.886
##  3     3       90.2   6.5    6.75   1.07 
##  4     4      213     6      4.43   1.25 
##  5     5       10.2  15.7   12.7    1.10 
##  6     6       17.6  10     12.0    0.980
##  7     7       32.6   8.6   10.7    0.828
##  8     8       81.3   6.4    7.24   1.01 
##  9     9      142.    5.6    4.78   1.31 
## 10    10      286.    6      6.94   2.05 
## # ... with 5 more variables: .resid <dbl>,
## #   .hat <dbl>, .sigma <dbl>, .cooksd <dbl>,
## #   .std.resid <dbl>
```

 

so now you see what `carp.2a` has in it, and then:


```r
g = ggplot(carp.2a, aes(x = bodyweight, y = .fitted)) + 
    geom_line(colour = "blue") + geom_point(aes(y = ENE))
```

 

This is easier coding: there are only two non-standard things. The
first is that the fitted-value lines should be a distinct colour like
blue so that you can tell them from the data points. The second thing
is that for the second `geom_point`, the one that plots the data,
the $x$ coordinate `bodyweight` is correct so that we don't
have to change that; we only have to change the $y$-coordinate, which
is `ENE`. The plot is this:


```r
g
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-48-1} 

 

Concerning interpretation, you have a number of possibilities
here. The simplest is that the points in the middle are above the
curve, and the points at the ends are below. (That is, negative
residuals at the ends, and positive ones in the middle, which gives
you a hint for the next part.) Another is that the parabola curve
fails to capture the *shape* of the relationship; for example, I
see nothing much in the data suggesting that the relationship should go
back up, and even given that, the fitted curve doesn't go especially
near any of the points.

I was thinking that the data should be fit better by something like
the left half of an upward-opening parabola, but I guess the curvature
on the left half of the plot suggests that it needs most of the left
half of the parabola just to cover the left half of the plot.

The moral of the story, as we see in the next part, is that the
parabola is the wrong curve for the job.



(i) Obtain a residual plot for the parabola model. Do you see
any problems with it? (If you do, I'm not asking you to do anything
about them in this question, but I will.)


Solution


The same idea as before for the other residual plot.  Use the
fitted model object `carp.2` as your data frame for the
`ggplot`:

```r
ggplot(carp.2, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-49-1} 

 

I think this is *still* a curve (or, it goes down and then
sharply up at the end). Either way, there is still a pattern. 

That was all I needed, but as to what this means: our parabola was a
curve all right, but it appears not to be the right *kind* of
curve. I think the original data looks more like a hyperbola (a curve
like $y=1/x$) than a parabola, in that it seems to decrease fast and
then gradually to a limit, and *that* suggests, as in the class
example, that we should try an asymptote model. Note how I specify it,
with the `I()` thing again, since `/` has a special meaning 
to `lm` in the same way that 
`^` does:

```r
carp.3 = lm(ENE ~ I(1/bodyweight), data = carp)
summary(carp.3)
```

```
## 
## Call:
## lm(formula = ENE ~ I(1/bodyweight), data = carp)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -1.29801 -0.12830  0.04029  0.26702  0.91707 
## 
## Coefficients:
##                 Estimate Std. Error t value
## (Intercept)       5.1804     0.2823   18.35
## I(1/bodyweight) 107.6690     5.8860   18.29
##                 Pr(>|t|)    
## (Intercept)     8.01e-08 ***
## I(1/bodyweight) 8.21e-08 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.6121 on 8 degrees of freedom
## Multiple R-squared:  0.9766,	Adjusted R-squared:  0.9737 
## F-statistic: 334.6 on 1 and 8 DF,  p-value: 8.205e-08
```

 

That fits *extraordinarily* well, with an R-squared up near
98\%. The intercept is the asymptote, which suggests a (lower) limit
of about 5.2 for `ENE` (in the limit for large bodyweight). We
would have to ask the fisheries scientist whether this kind of thing
is a reasonable biological mechanism. It says that a carp always has
some ENE, no matter how big it gets, but a smaller carp will have a
lot more.

Does the fitted value plot look reasonable now? This is `augment` again since the fitted values and observed data come from different data frames:

```r
library(broom)
augment(carp.3, carp) %>% ggplot(aes(x = bodyweight, 
    y = .fitted)) + geom_line(colour = "blue") + 
    geom_point(aes(y = ENE))
```


\includegraphics{12-regression_files/figure-latex/augment2-1} 

 

I'd say that does a really nice job of fitting the data. But it would
be nice to have a few more tanks with large-bodyweight fish, to
convince us that we have the shape of the trend right.

And, as ever, the residual plot. That's a lot easier than the plot we
just did:


```r
ggplot(carp.3, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-51-1} 

 

All in all, that looks pretty good (and certainly a vast improvement
over the ones you got before).

When you write up your report, you can make it flow better by writing
it in a way that suggests that each thing was the obvious thing to do
next: that is, that *you* would have thought to do it next,
rather than me telling you what to do.

My report (as an R Markdown file) is at
[link](http://www.utsc.utoronto.ca/~butler/c32/carp.Rmd). Download it,
knit it, play with it.






##  Sparrowhawks


 One of nature's patterns is the relationship
between the percentage of adult birds in a colony that return from the
previous year, and the number of new adults that join the colony. Data
for 13 colonies of sparrowhawks can be found at
[link](http://www.utsc.utoronto.ca/~butler/c32/sparrowhawk.txt). The
columns are the percentage of adults returning from the previous year,
and the number of new adults that join the colony.



(a) Create a new R Markdown report, give it a suitable title, and
ask for HTML output. Answer the questions that follow in your
report. At any stage, you can Knit HTML
to see how the report looks so far.


Solution


In R Studio, select File, New File, R Markdown. Fill in the Title,
Author and leave the Default Output Format at HTML. You'll see a
template report with the document info at the top. This is my document info:

![](sh0.png)
 
This is known in the jargon as a "YAML block".
\marginnote{YAML      stands for *Yet Another Markup Language*, but we're not using      it in this course, other than as the top bit of an R Markdown document.}
Below that is the template R Markdown document, which you can delete now or later.



(b) Read in the data and display the  first few values.  Add some text saying how many rows of data
there are.


Solution


Read the data into a data frame. In your
report, add some text like "we read in the data", perhaps
after a section heading like "The data". Then add a *code chunk* 
by selecting Chunks and Insert Chunk, or by pressing
control-alt-I. So far you have something like this. 

![](sh1.png)

Inside the code chunk, that is, in the bit between the
backtick characters, put R code, just as you would type it at
the Console or put in an  R notebook. In this case, that would be
the following code, minus the message that comes out of
`read_delim`: 

```r
library(tidyverse)
my_url = "http://www.utsc.utoronto.ca/~butler/c32/sparrowhawk.txt"
sparrowhawks = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   returning = col_integer(),
##   newadults = col_integer()
## )
```

```r
sparrowhawks
```

     
For you, it looks like this:


![](sh2.png)


We don't know how many rows of data there are yet, so I've left a
"placeholder" for it, when we figure it out.
The file is annoyingly called `sparrowhawk.txt`,
singular. Sorry about that. 
If you knit this (click on "Knit HTML" next to the ball of wool,
or press control-shift-K), it should run, and you'll see a viewer
pop up with the HTML output. Now you can see how many rows there
are, and you can go back and edit the R Markdown and put in 13 in
place of `xxx`, and knit again.
You might be worried about how hard R is working with all this
knitting. Don't worry about that. R can take it.
Mine looked like this:

![](waluj.png)

There is a better way of adding values that come from the output,
which I mention here in case you are interested (if you are not,
feel free to skip this). What you do is to make what is called an
"inline code chunk". Where you want a number to appear in the
text, you have some R Markdown that looks like this:

![](sh3.png)

The piece inside the backticks is the letter `r`, a space,
and then one line of R code. The one line of code will be run, and
all of the stuff within the backticks will be replaced in the
output by the result of running the R code, in this case the
number 13. Typically, you are extracting a number from the data,
like the number of rows or a mean of something. If it's a decimal
number, it will come out with a lot of decimal places unless you
explicitly `round` it.
OK, let me try it: the data frame has 13
rows altogether. I didn't type that number; it was calculated from
the data frame. Woo hoo!



(c) Create a new section entitled "Exploratory analysis", and
create a scatterplot for predicting number of new adults from the
percentage of returning adults.  Describe what you see, adding some
suitable text to your report.


Solution


The R code you add should look like this, with the results shown
(when you knit the report again):

```r
library(tidyverse)
ggplot(sparrowhawks, aes(x = returning, y = newadults)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-53-1} 

 

<br>

The piece of report that I added looks like this:


![](sh4.png)


Note (i) that you have to do nothing special to get the plot to
appear, and (ii) that I put "smaller" in italics, and you see
how. 



(d) Obtain the correlation between the two variables. Is this
consistent with the scatterplot? Explain briefly. (The R function
you need is `cor`. You can feed it a data frame.)


Solution


The appropriate R code  is this, in another code chunk:

```r
with(sparrowhawks, cor(newadults, returning))
```

```
## [1] -0.7484673
```

 

Or you can ask for the correlations of the whole data frame:


```r
cor(sparrowhawks)
```

```
##            returning  newadults
## returning  1.0000000 -0.7484673
## newadults -0.7484673  1.0000000
```

 

This latter is a "correlation matrix" with a correlation between each
column and each other column. Obviously the correlation between a
column and itself is 1, and that is *not* the one we want.

I added this to the report (still in the Exploratory Analysis
section, since it seems to belong there):

![](sh5.png)




(e) Obtain the regression line for predicting the number of new
adults from the percentage of returning adults.


Solution


This R code, in another code chunk:

```r
newadults.1 = lm(newadults ~ returning, data = sparrowhawks)
summary(newadults.1)
```

```
## 
## Call:
## lm(formula = newadults ~ returning, data = sparrowhawks)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -5.8687 -1.2532  0.0508  2.0508  5.3071 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 31.93426    4.83762   6.601
## returning   -0.30402    0.08122  -3.743
##             Pr(>|t|)    
## (Intercept) 3.86e-05 ***
## returning    0.00325 ** 
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 3.667 on 11 degrees of freedom
## Multiple R-squared:  0.5602,	Adjusted R-squared:  0.5202 
## F-statistic: 14.01 on 1 and 11 DF,  p-value: 0.003248
```

 



(f) What are the intercept and slope of your regression line? Is
the slope significant? What does that mean, in the context of the data?


Solution


See the output in the previous part. That's what we need to talk about.
I added this to the report. I thought we deserved a new section here:

![](sh6.png)
 



(g) Create a scatterplot of the data with the regression line on it.


Solution


This code. Using `geom_smooth` with 
`method="lm"`
will add the regression line to the plot:


```r
ggplot(sparrowhawks, aes(x = returning, y = newadults)) + 
    geom_point() + geom_smooth(method = "lm")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-57-1} 

 

I added a bit of text to the report, which I will show in a moment.



(h) For short-lived birds, the association between these two
variables is positive: changes in weather and food supply cause the
populations of new and returning birds to increase together. For
long-lived territorial birds, however, the association is negative
because returning birds claim their territories in the colony and do
not leave room for new recruits. Which type of species is the
sparrowhawk? Add a short Conclusions section to your report with
discussion of this issue.


Solution


My addition to the report looks like this:


![](sh7.png)


I think that rounds off the report nicely.







##  Salaries of social workers


 Another salary-prediction question: does the number of years
of work experience that a social worker has help to predict their 
salary? Data for 50 social workers are in
[link](http://www.utsc.utoronto.ca/~butler/c32/socwork.txt). 



(a) Read the data into R. Check that you have 50 observations on
two variables. Also do something to check that the years of
experience and annual salary figures look reasonable overall.


Solution



```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/socwork.txt"
soc = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   experience = col_integer(),
##   salary = col_integer()
## )
```

```r
soc
```

```
## # A tibble: 50 x 2
##    experience salary
##         <int>  <int>
##  1          7  26075
##  2         28  79370
##  3         23  65726
##  4         18  41983
##  5         19  62308
##  6         15  41154
##  7         24  53610
##  8         13  33697
##  9          2  22444
## 10          8  32562
## # ... with 40 more rows
```

 

That checks that we have the right *number* of observations; to
check that we have sensible *values*, something like
`summary` is called for:


```r
summary(soc)
```

```
##    experience        salary     
##  Min.   : 1.00   Min.   :16105  
##  1st Qu.:13.50   1st Qu.:36990  
##  Median :20.00   Median :50948  
##  Mean   :18.12   Mean   :50171  
##  3rd Qu.:24.75   3rd Qu.:65204  
##  Max.   :28.00   Max.   :99139
```

 

A person working in any field cannot have a negative number of years
of experience, and cannot have more than about 40 years of experience
(or else they would have retired). Our experience numbers fit
that. Salaries had better be five or six figures, and salaries for
social workers are not generally all that high, so these figures look
reasonable. 

A rather more `tidyverse` way is this:


```r
soc %>% summarize_all(c("min", "max"))
```

```
## # A tibble: 1 x 4
##   experience_min salary_min experience_max
##            <dbl>      <dbl>          <dbl>
## 1              1      16105             28
## # ... with 1 more variable: salary_max <dbl>
```

 

This gets the minimum and maximum of all the variables. I would have
liked them arranged in a nice rectangle (`min` and `max`
as rows, the variables as columns), but that's not how this comes out.

Here is another:


```r
soc %>% map_df(~quantile(.))
```

```
## # A tibble: 5 x 2
##   experience salary
##        <dbl>  <dbl>
## 1        1   16105 
## 2       13.5 36990.
## 3       20   50948.
## 4       24.8 65204.
## 5       28   99139
```

 

These are the five-number summaries of each variable. Normally, they
come with percentiles attached:


```r
quantile(soc$experience)
```

```
##    0%   25%   50%   75%  100% 
##  1.00 13.50 20.00 24.75 28.00
```

 

but the percentiles get lost in the transition to a `tibble`, and I
haven't found out how to get them back.

This almost works:


```r
soc %>% map_df(~enframe(quantile(.)))
```

```
## # A tibble: 10 x 2
##    name    value
##    <chr>   <dbl>
##  1 0%        1  
##  2 25%      13.5
##  3 50%      20  
##  4 75%      24.8
##  5 100%     28  
##  6 0%    16105  
##  7 25%   36990. 
##  8 50%   50948. 
##  9 75%   65204. 
## 10 100%  99139
```



but, though we now have the percentiles, we've lost the names of the variables, so it isn't much better.

In this context, `map` says 
"do whatever is in the brackets for each column of the data frame". 
(That's the implied "for each".) The output from `quantile` 
is a vector that we would like to have display as a data frame, so `map_df` 
instead of any other form of `map`.

As you know, the `map` family is 
actually very flexible: they run a function "for each" anything and
glue the results together, like this:


```r
soc %>% map_dbl(median)
```

```
## experience     salary 
##       20.0    50947.5
```

 

which gets the median for each variable. That's the same thing as this:


```r
soc %>% summarize_all("median")
```

```
## # A tibble: 1 x 2
##   experience salary
##        <dbl>  <dbl>
## 1         20 50948.
```

 



(b) Make a scatterplot showing how salary depends on
experience. Does the nature of the trend make sense?


Solution


The usual:

```r
ggplot(soc, aes(x = experience, y = salary)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-66-1} 

 

As experience goes up, salary also goes up, as you would expect. Also,
the trend seems more or less straight.



(c) Fit a regression predicting salary from experience, and
display the results. Is the slope positive or negative? Does that
make sense?


Solution



```r
soc.1 = lm(salary ~ experience, data = soc)
summary(soc.1)
```

```
## 
## Call:
## lm(formula = salary ~ experience, data = soc)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -17666.3  -5498.2   -726.7   4667.7  27811.6 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)  11368.7     3160.3   3.597
## experience    2141.4      160.8  13.314
##             Pr(>|t|)    
## (Intercept) 0.000758 ***
## experience   < 2e-16 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 8642 on 48 degrees of freedom
## Multiple R-squared:  0.7869,	Adjusted R-squared:  0.7825 
## F-statistic: 177.3 on 1 and 48 DF,  p-value: < 2.2e-16
```

 

The slope is (significantly) positive, which squares with our guess
(more experience goes with greater salary), and also the upward trend
on the scatterplot. The value of the slope is about 2,000; this means
that one more year of experience goes with about a \$2,000 increase in
salary. 



(d) Obtain and plot the residuals against the fitted values. What
problem do you see?


Solution


The easiest way to do this with `ggplot` is to plot the
*regression object* (even though it is not actually a data
frame), and plot the `.fitted` and `.resid`
columns in it, not forgetting the initial dots:

```r
ggplot(soc.1, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-68-1} 

       
I see a "fanning-out": the residuals are getting bigger *in size* 
(further away from zero) as the fitted values get bigger. That
is, when the (estimated) salary gets larger, it also gets more
variable. 

Fanning-out is sometimes hard to see. What you can do if you suspect
that it might have happened is to plot the *absolute value* of
the residuals against the fitted values. The absolute value is the
residual without its plus or minus sign, so if the residuals are
getting bigger in size, their absolute values are getting bigger. That
would look like this:


```r
ggplot(soc.1, aes(x = .fitted, y = abs(.resid))) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-69-1} 

 

I added a smooth trend to this to help us judge whether the
absolute-value-residuals are getting bigger as the fitted values get
bigger. It looks to me as if the overall trend is an increasing one,
apart from those few small fitted values that have larger-sized
residuals. Don't get thrown off by the kinks in the smooth trend. Here
is a smoother version:


```r
ggplot(soc.1, aes(x = .fitted, y = abs(.resid))) + 
    geom_point() + geom_smooth(span = 2)
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-70-1} 

 

The larger fitted values, according to this, have residuals larger in size.

The thing that controls the smoothness of the smooth trend is the
value of `span` in `geom_smooth`. The default is
0.75. The larger the value you use, the smoother the trend; the
smaller, the more wiggly. I'm inclined to think that the default value
is a bit too small. Possibly this value is too big, but it shows you
the idea.



(e) The problem you unearthed in the previous part is often helped
by a transformation. Run Box-Cox on your data to find a suitable
transformation. What transformation is suggested?


Solution


You'll need to call in (and install if necessary) the package
`MASS` that contains `boxcox`:

```r
library(MASS)
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

 

I explain that "masked" thing below.


```r
boxcox(salary ~ experience, data = soc)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-72-1} 

 

That one looks like $\lambda=0$ or log. You could probably also
justify fourth root (power 0.25), but log is a very common
transformation, which people won't need much persuasion to accept.

There's one annoyance with `MASS`: it has a `select`
(which I have never used), and if you load `tidyverse` first
and `MASS` second, as I have done here, when you mean to run
the column-selection `select`, it will actually run the
`select` that comes from `MASS`, and give you an error
that you will have a terrible time debugging. That's what that
"masked" message was when you loaded `MASS`.

So I'm going to be tidy and get rid of `MASS`, now that I'm
finished with it. Let's first see which packages are loaded, rather a
lot in my case:
\marginnote{The packages before *tidyverse* other than *MASS* are all loaded by the *tidyverse*, which  is why there are so many.}


```r
search()
```

```
##  [1] ".GlobalEnv"        "package:MASS"     
##  [3] "package:broom"     "package:GGally"   
##  [5] "package:bindrcpp"  "package:forcats"  
##  [7] "package:stringr"   "package:dplyr"    
##  [9] "package:purrr"     "package:readr"    
## [11] "package:tidyr"     "package:tibble"   
## [13] "package:ggplot2"   "package:tidyverse"
## [15] "package:stats"     "package:graphics" 
## [17] "package:grDevices" "package:utils"    
## [19] "package:datasets"  "package:methods"  
## [21] "Autoloads"         "package:base"
```

 

then get rid of `MASS`:


```r
detach("package:MASS", unload = T)
```

 
Now check that it has gone:


```r
search()
```

```
##  [1] ".GlobalEnv"        "package:broom"    
##  [3] "package:GGally"    "package:bindrcpp" 
##  [5] "package:forcats"   "package:stringr"  
##  [7] "package:dplyr"     "package:purrr"    
##  [9] "package:readr"     "package:tidyr"    
## [11] "package:tibble"    "package:ggplot2"  
## [13] "package:tidyverse" "package:stats"    
## [15] "package:graphics"  "package:grDevices"
## [17] "package:utils"     "package:datasets" 
## [19] "package:methods"   "Autoloads"        
## [21] "package:base"
```

 
It has. Now any calls to `select` will use the right one. We hope.

The output of `search` is called the **search list**, and
it tells you where R will go looking for things. The first one
`.GlobalEnv` is where all
\marginnote{All the ones that are part of  this project, anyway.} 
your
variables, data frames etc.\ get stored, and that is what gets
searched first.
\marginnote{That means that if you write a function with  the same name as one that is built into R or a package, yours is the  one that will get called. This is probably a bad idea, since you  won't be able to get at R's function by that name.} 
Then R will go
looking in each thing in turn until it finds what it is looking
for. When you load a package with `library()`, it gets added to
the list *in second place*, behind `.GlobalEnv`. So, when
we had `MASS` loaded (the first `search()`), if we
called `select`, then it would find the one in `MASS`
first.

If you want to insist on something like "the `select` that lives in `dplyr`", 
you can do that by saying
`dplyr::select`. But this is kind of cumbersome if you don't
need to do it, which is why I got rid of `MASS` here.



(f) Calculate a new variable as suggested by your
transformation. Use your transformed response in a regression,
showing the summary.


Solution


The best way is to add the new variable to the data frame using
`mutate`, and save that new data frame. That goes like this:

```r
soc.2 = soc %>% mutate(log_salary = log(salary))
```

       

and then


```r
soc.3 = lm(log_salary ~ experience, data = soc.2)
summary(soc.3)
```

```
## 
## Call:
## lm(formula = log_salary ~ experience, data = soc.2)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.35435 -0.09046 -0.01725  0.09739  0.26355 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 9.841315   0.056356  174.63
## experience  0.049979   0.002868   17.43
##             Pr(>|t|)    
## (Intercept)   <2e-16 ***
## experience    <2e-16 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.1541 on 48 degrees of freedom
## Multiple R-squared:  0.8635,	Adjusted R-squared:  0.8607 
## F-statistic: 303.7 on 1 and 48 DF,  p-value: < 2.2e-16
```

 

I think it's best to save the data frame with `log_salary` in
it, since we'll be doing a couple of things with it, and it's best to
be able to start from `soc.2`. But you can also do this:


```r
soc %>% mutate(log_salary = log(salary)) %>% lm(log_salary ~ 
    experience, data = .) %>% summary()
```

```
## 
## Call:
## lm(formula = log_salary ~ experience, data = .)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.35435 -0.09046 -0.01725  0.09739  0.26355 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 9.841315   0.056356  174.63
## experience  0.049979   0.002868   17.43
##             Pr(>|t|)    
## (Intercept)   <2e-16 ***
## experience    <2e-16 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.1541 on 48 degrees of freedom
## Multiple R-squared:  0.8635,	Adjusted R-squared:  0.8607 
## F-statistic: 303.7 on 1 and 48 DF,  p-value: < 2.2e-16
```

 

The second line is where the fun starts: `lm` wants the data
frame as a `data=` at the end. So, to specify a data frame in
something like `lm`, we have to use the special symbol
`.`, which is another way to say 
"the data frame that came out of the previous step".

Got that? All right. The last line is a piece of cake in
comparison. Normally `summary` would require a data frame or a
fitted model object, but the second line produces one (a fitted model
object) as output, which goes into `summary` as the first
(and only) thing, so all is good and we get the regression output.

What we lose by doing this is that if we need something later from this
fitted model object, we are out of luck since we didn't save
it. That's why I created `soc.2` and `soc.3` above.

You can also put functions of things directly into `lm`:


```r
soc.1a = lm(log(salary) ~ experience, data = soc)
summary(soc.1a)
```

```
## 
## Call:
## lm(formula = log(salary) ~ experience, data = soc)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.35435 -0.09046 -0.01725  0.09739  0.26355 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 9.841315   0.056356  174.63
## experience  0.049979   0.002868   17.43
##             Pr(>|t|)    
## (Intercept)   <2e-16 ***
## experience    <2e-16 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.1541 on 48 degrees of freedom
## Multiple R-squared:  0.8635,	Adjusted R-squared:  0.8607 
## F-statistic: 303.7 on 1 and 48 DF,  p-value: < 2.2e-16
```

 



(g) Obtain and plot the residuals against the fitted values for
this regression. Do you seem to have solved the problem with the
previous residual plot?


Solution


As we did before, treating the regression object as if it were a
data frame:

```r
ggplot(soc.3, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-80-1} 

       

That, to my mind, is a horizontal band of points, so I would say yes,
I have solved the fanning out.

One concern I have about the residuals is that there seem to be a
couple of very negative values: that is, are the residuals normally
distributed as they should be? Well, that's easy enough to check:


```r
ggplot(soc.3, aes(sample = .resid)) + stat_qq() + 
    stat_qq_line()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-81-1} 

 

The issues here are that those bottom two values are a bit too low,
and the top few values are a bit bunched up (that curve at the top).
It is really not bad, though, so I am making the call that I don't
think I needed to worry.
Note that the transformation we found here is the same as the
log-salary used by the management consultants in the
backward-elimination question, and with the same effect: an extra year
of experience goes with a *percent* increase in salary.

What increase? Well, the slope is about 0.05, so adding a year of
experience is predicted to increase log-salary by 0.05, or to
multiply actual salary by 


```r
exp(0.05)
```

```
## [1] 1.051271
```

 

or to increase salary by about 5\%.
\marginnote{Mathematically,  $e^x$ is approximately $1+x$ for small $x$, which winds up meaning that the  slope in a model like this, if it is small, indicates about the  percent increase in the response associated with a 1-unit change in  the explanatory variable. Note that this only works with $e^x$ and  natural logs, not base 10 logs or anything like that.}






##  Predicting volume of wood in pine trees


 In forestry, the financial value of a tree
is the volume of wood that it contains. This is difficult to estimate
while the tree is still standing, but the diameter is easy to measure
with a tape measure (to measure the circumference) and a calculation
involving $\pi$, assuming that the cross-section of the tree is at
least approximately circular.  The standard measurement is
"diameter at breast height" 
(that is, at the height of a human breast or
chest), defined as being 4.5 feet above the ground.

Several pine trees had their diameter measured shortly before being
cut down, and for each tree, the volume of wood was recorded. The data
are in
[link](http://www.utsc.utoronto.ca/~butler/c32/pinetrees.txt). The
diameter is in inches and the volume is in cubic inches.  Is it
possible to predict the volume of wood from the diameter?



(a) Read the data into R and display the values (there are not
very many).


Solution


Observe that the data values are separated by spaces, and therefore
that `read_delim` will do it:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/pinetrees.txt"
trees = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   diameter = col_integer(),
##   volume = col_integer()
## )
```

```r
trees
```

```
## # A tibble: 10 x 2
##    diameter volume
##       <int>  <int>
##  1       32    185
##  2       29    109
##  3       24     95
##  4       45    300
##  5       20     30
##  6       30    125
##  7       26     55
##  8       40    246
##  9       24     60
## 10       18     15
```

    

That looks like the data file.



(b) Make a suitable plot.


Solution


No clues this time. You need to recognize that you have two
quantitative variables, so that a scatterplot is called
for. Also, the volume is the response, so that should go on the $y$-axis:

```r
ggplot(trees, aes(x = diameter, y = volume)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-84-1} 

       

You can put a smooth trend on it if you like, which would
look like this:


```r
ggplot(trees, aes(x = diameter, y = volume)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-85-1} 

       

I'll take either of those for this part, though I think the smooth
trend actually obscures the issue here (because there is not so much
data). 

 

(c) Describe what you learn from your plot about the
relationship between diameter and volume, if anything.


Solution


The word "relationship" offers a clue that a scatterplot would
have been a good idea, if you hadn't realized by now. 
I am guided by "form, direction, strength" in looking at a scatterplot:


* Form: it is an apparently linear relationship.

* Direction: it is an upward trend: that is, a tree with a larger diameter also has a larger volume of wood. (This is not very surprising.)

* Strength:  I'd call this a strong (or moderate-to-strong) relationship. (We'll see in a minute what the R-squared is.)

You don't need to be as formal as this, but you *do* need
to get at the idea that it is an upward trend, apparently
linear, and at least fairly strong.
\marginnote{When this was graded, it was 3 marks, to clue you in that there are three things to say.}



(d) Fit a (linear) regression, predicting volume from diameter,
and obtain the `summary`. How would you describe the R-squared?


Solution


My naming convention is (usually) to call the fitted model
object by the name of the response variable and a number. (I
have always used dots, but in the spirit of the
`tidyverse` I suppose I should use underscores.)

```r
volume.1 = lm(volume ~ diameter, data = trees)
summary(volume.1)
```

```
## 
## Call:
## lm(formula = volume ~ diameter, data = trees)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -36.497  -9.982   1.751   8.959  28.139 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) -191.749     23.954  -8.005
## diameter      10.894      0.801  13.600
##             Pr(>|t|)    
## (Intercept) 4.35e-05 ***
## diameter    8.22e-07 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 20.38 on 8 degrees of freedom
## Multiple R-squared:  0.9585,	Adjusted R-squared:  0.9534 
## F-statistic:   185 on 1 and 8 DF,  p-value: 8.217e-07
```

       

R-squared is nearly 96\%, so the relationship is definitely a strong one.

I also wanted to mention the `broom` package, which was
installed with the `tidyverse` but which you need to load
separately. It provides two handy ways to summarize a fitted model
(regression, analysis of variance or whatever):


```r
library(broom)
glance(volume.1)
```

```
## # A tibble: 1 x 11
##   r.squared adj.r.squared sigma statistic
## *     <dbl>         <dbl> <dbl>     <dbl>
## 1     0.959         0.953  20.4      185.
## # ... with 7 more variables: p.value <dbl>,
## #   df <int>, logLik <dbl>, AIC <dbl>,
## #   BIC <dbl>, deviance <dbl>,
## #   df.residual <int>
```

 

This gives a one-line summary of a model, including things like
R-squared. This is handy if you're fitting more than one model,
because you can collect the one-line summaries together into a data
frame and eyeball them.

The other summary is this one:


```r
tidy(volume.1)
```

```
## # A tibble: 2 x 5
##   term  estimate std.error statistic p.value
##   <chr>    <dbl>     <dbl>     <dbl>   <dbl>
## 1 (Int~   -192.     24.0       -8.01 4.35e-5
## 2 diam~     10.9     0.801     13.6  8.22e-7
```

 

This gives a table of intercepts, slopes and their P-values, but the
value to this one is that it is a *data frame*, so if you want to
pull anything out of it, you know how to do that:
\marginnote{The  *summary* output is more designed for looking at than for  extracting things from.}

```r
tidy(volume.1) %>% filter(term == "diameter")
```

```
## # A tibble: 1 x 5
##   term  estimate std.error statistic p.value
##   <chr>    <dbl>     <dbl>     <dbl>   <dbl>
## 1 diam~     10.9     0.801      13.6 8.22e-7
```

 

This gets the estimated slope and its P-value, without worrying about
the corresponding things for the intercept, which are usually of less
interest anyway.



(e) Draw a graph that will help you decide whether you trust
the linearity of this regression. What do you conclude? Explain briefly.


Solution


The thing I'm fishing for is a residual plot (of the residuals
against the fitted values), and on it you are looking for a
random mess of nothingness:

```r
ggplot(volume.1, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-90-1} 

       

Make a call. You could say that there's no discernible pattern,
especially with such a small data set, and
therefore that the regression is fine. Or you could say that there is
fanning-in: the two points on the right have residuals close to 0
while the points on the left have residuals larger in size. Say
something. 

I don't think you can justify a curve or a trend, because
the residuals on the left are both positive and negative.

My feeling is that the residuals on the right are close to 0 because
these points have noticeably larger diameter than the others, and they
are *influential* points in the regression that will pull the
line closer to themselves. This is why their residuals are close to
zero. But I am happy with either of the points made in the paragraph
under the plot.



(f) What would you guess would be the volume of a tree of
diameter zero? Is that what the regression predicts? Explain briefly.


Solution


Logically, a tree that has diameter zero is a non-existent tree,
so its volume should be zero as well. 
In the regression, the quantity that says what volume is when
diameter is zero is the *intercept*. Here the intercept is
$-192$, which is definitely not zero. In fact, if you look at
the P-value, the intercept is significantly *less* than
zero. Thus, the model makes no logical sense for trees of small
diameter. The smallest tree in the data set has diameter 18,
which is not really small, I suppose, but it is a little
disconcerting to have a model that makes no logical sense.

 

(g) A simple way of modelling a tree's shape is to pretend it is a
cone, like this, but probably taller and skinnier:


![](/home/ken/Pictures/conebnw.png)
        

with its base on the ground. What is the relationship between the
*diameter* (at the base) and volume of a cone? (If you don't
remember, look it up. You'll probably get a formula in terms of the
radius, which you'll have to convert.
Cite the website you used.)


Solution


According to
[link](http://www.web-formulas.com/Math_Formulas/Geometry_Volume_of_Cone.aspx),
the volume of a cone is $V=\pi r^2h/3$, where $V$ is the volume,
$r$ is the radius (at the bottom of the cone) and $h$ is the
height. The diameter is twice the radius, so replace $r$ by
$d/2$, $d$ being the diameter. A little algebra gives 
$$ V = \pi d^2 h / 12.$$

 

(h) Fit a regression model that predicts volume from diameter
according to the formula you obtained in the previous part. You can
assume that the trees in this data set are of similar heights, so
that the height can be treated as a constant.  
Display the
results.


Solution


According to my formula, the volume depends on the diameter
squared, which I include in the model thus:

```r
volume.2 = lm(volume ~ I(diameter^2), data = trees)
summary(volume.2)
```

```
## 
## Call:
## lm(formula = volume ~ I(diameter^2), data = trees)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -29.708  -9.065  -5.722   3.032  40.816 
## 
## Coefficients:
##                Estimate Std. Error t value
## (Intercept)   -30.82634   13.82243   -2.23
## I(diameter^2)   0.17091    0.01342   12.74
##               Pr(>|t|)    
## (Intercept)     0.0563 .  
## I(diameter^2) 1.36e-06 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 21.7 on 8 degrees of freedom
## Multiple R-squared:  0.953,	Adjusted R-squared:  0.9471 
## F-statistic: 162.2 on 1 and 8 DF,  p-value: 1.359e-06
```

       

This adds an intercept as well, which is fine (there are technical
difficulties around removing the intercept).

That's as far as I wanted you to go, but (of course) I have a few
comments.

The intercept here is still negative, but not significantly different
from zero, which is a step forward. The R-squared for this regression
is very similar to that from our linear model (the one for which the
intercept made no sense). So, from that point of view, either model
predicts the data well. I should look at the residuals from this one:


```r
ggplot(volume.2, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-92-1} 

 

I really don't think there are any problems there.

Now, I said to assume that the trees are all of similar height. This
seems entirely questionable, since the trees vary quite a bit in
diameter, and you would guess that trees with bigger diameter would
also be taller. It seems more plausible that the same kind of trees
(pine trees in this case) would have the same "shape", so that if
you knew the diameter you could *predict* the height, with
larger-diameter trees being taller. Except that we don't have the
heights here, so we can't build a model for that.

So I went looking in the literature. I found this paper:
[link](https://pdfs.semanticscholar.org/5497/3d02d63428e3dfed6645acfdba874ad80822.pdf). This
gives several models for relationships between volume, diameter and height. In
the formulas below, there is an implied "plus error" on the right,
and the $\alpha_i$ are parameters to be estimated.

For predicting height from diameter (equation 1 in paper):

$$  h = \exp(\alpha_1+\alpha_2 d^{\alpha_3}) $$

For predicting volume from height and diameter (equation 6):

$$  V = \alpha_1 d^{\alpha_2} h^{\alpha_3} $$

This is a take-off on our assumption that the trees were cone-shaped,
with cone-shaped trees having $\alpha_1=\pi/12$, $\alpha_2=2$ and
$\alpha_3=1$. The paper uses different units, so $\alpha_1$ is not
comparable, but $\alpha_2$ and $\alpha_3$ are (as estimated from the
data in the paper, which were for longleaf pine) quite close to 2 and
1.

Last, the actual relationship that helps us: predicting volume from
just diameter (equation 5):

$$  V = \alpha_1 d^{\alpha_2}$$

This is a power law type of relationship. For example, if you were
willing to pretend that a tree was a cone with height proportional to
diameter (one way of getting at the idea of a bigger tree typically
being taller, instead of assuming constant height as we did), that
would imply $\alpha_2=3$ here.

This is non-linear as it stands, but we can bash it into shape by taking
logs:

$$
\ln V = \ln \alpha_1 + \alpha_2 \ln d
$$

so that log-volume has a linear relationship with log-diameter and we
can go ahead and estimate it:


```r
volume.3 = lm(log(volume) ~ log(diameter), data = trees)
summary(volume.3)
```

```
## 
## Call:
## lm(formula = log(volume) ~ log(diameter), data = trees)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.40989 -0.22341  0.01504  0.10459  0.53596 
## 
## Coefficients:
##               Estimate Std. Error t value
## (Intercept)    -5.9243     1.1759  -5.038
## log(diameter)   3.1284     0.3527   8.870
##               Pr(>|t|)    
## (Intercept)      0.001 ** 
## log(diameter) 2.06e-05 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.3027 on 8 degrees of freedom
## Multiple R-squared:  0.9077,	Adjusted R-squared:  0.8962 
## F-statistic: 78.68 on 1 and 8 DF,  p-value: 2.061e-05
```

 

The parameter that I called $\alpha_2$ above is the slope of this
model, 3.13. This is a bit different from the figure in the paper,
which was 2.19. I think these are comparable even though the other
parameter is not (again, measurements in different units, plus, this
time we need to take the log of it). I think the "slopes" are
comparable because we haven't estimated our slope all that accurately:


```r
confint(volume.3)
```

```
##                   2.5 %    97.5 %
## (Intercept)   -8.635791 -3.212752
## log(diameter)  2.315115  3.941665
```

 

From 2.3 to 3.9. It is definitely not zero, but we are rather less
sure about what it is, and 2.19 is not completely implausible.

The R-squared here, though it is less than the other ones we
got, is still high. The residuals are these:


```r
ggplot(volume.3, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-95-1} 

 

which again seem to show no problems. The residuals are smaller in
size now because of the log transformation: the actual and predicted
log-volumes are smaller numbers than the actual and predicted volumes,
so the residuals are now closer to zero.

Does this model behave itself at zero? Well, roughly at least: if the
diameter is very small, its log is very negative, and the predicted
log-volume is also very negative (the slope is positive). So the
predicted actual volume will be close to zero. If you want to make
that mathematically rigorous, you can take limits, but that's the
intuition. We can also do some predictions: set up a data frame that has a column called `diameter` with some diameters to predict for:


```r
d = tibble(diameter = c(1, 2, seq(5, 50, 5)))
d
```

```
## # A tibble: 12 x 1
##    diameter
##       <dbl>
##  1        1
##  2        2
##  3        5
##  4       10
##  5       15
##  6       20
##  7       25
##  8       30
##  9       35
## 10       40
## 11       45
## 12       50
```



and then feed that into `predict`:


```r
p = predict(volume.3, d)
d %>% mutate(pred = p)
```

```
## # A tibble: 12 x 2
##    diameter   pred
##       <dbl>  <dbl>
##  1        1 -5.92 
##  2        2 -3.76 
##  3        5 -0.889
##  4       10  1.28 
##  5       15  2.55 
##  6       20  3.45 
##  7       25  4.15 
##  8       30  4.72 
##  9       35  5.20 
## 10       40  5.62 
## 11       45  5.98 
## 12       50  6.31
```



These are predicted log-volumes, so we'd better anti-log them. `log` in R is natural logs, so this is inverted using `exp`: 


```r
d %>% mutate(pred = exp(p))
```

```
## # A tibble: 12 x 2
##    diameter      pred
##       <dbl>     <dbl>
##  1        1   0.00267
##  2        2   0.0234 
##  3        5   0.411  
##  4       10   3.59   
##  5       15  12.8    
##  6       20  31.4    
##  7       25  63.2    
##  8       30 112.     
##  9       35 181.     
## 10       40 275.     
## 11       45 397.     
## 12       50 552.
```



For a diameter near zero, the predicted volume appears to be near zero as well.

<br>

I mentioned `broom` earlier. We can make a data frame out of
the one-line summaries of our three models:


```r
bind_rows(glance(volume.1), glance(volume.2), 
    glance(volume.3))
```

```
## # A tibble: 3 x 11
##   r.squared adj.r.squared  sigma statistic
##       <dbl>         <dbl>  <dbl>     <dbl>
## 1     0.959         0.953 20.4       185. 
## 2     0.953         0.947 21.7       162. 
## 3     0.908         0.896  0.303      78.7
## # ... with 7 more variables: p.value <dbl>,
## #   df <int>, logLik <dbl>, AIC <dbl>,
## #   BIC <dbl>, deviance <dbl>,
## #   df.residual <int>
```

 

(I mistakenly put `glimpse` instead of `glance` there
the first time. The former is for a quick look at a *data frame*,
while the latter is for a quick look at a *model*.)

The three R-squareds are all high, with the one from the third model
being a bit lower as we saw before. 

My code is rather repetitious. There has to be a way to streamline
it. I was determined to find out how. My solution involves putting the
three models in a `list`, and then using `map` to
get the `glance` output for each one, and `bind_rows`
to glue the results together into one data frame. I was inspired to
try this by remembering that `map_df` will work for a function
like `glance` that outputs a data frame:


```r
model_list = list(volume.1, volume.2, volume.3)
map_df(model_list, ~glance(.))
```

```
## # A tibble: 3 x 11
##   r.squared adj.r.squared  sigma statistic
##       <dbl>         <dbl>  <dbl>     <dbl>
## 1     0.959         0.953 20.4       185. 
## 2     0.953         0.947 21.7       162. 
## 3     0.908         0.896  0.303      78.7
## # ... with 7 more variables: p.value <dbl>,
## #   df <int>, logLik <dbl>, AIC <dbl>,
## #   BIC <dbl>, deviance <dbl>,
## #   df.residual <int>
```

 

It works. You see the three R-squared values in the first column. The
third model is otherwise a lot different from the others because it
has a different response variable.

Other thoughts:

How might you measure or estimate the height of a
tree (other than by climbing it and dropping a tape measure down)? One
way, that works if the tree is fairly isolated, is to walk away from
its base. Periodically, you point at the top of the tree, and when the
angle between your arm and the ground reaches 45 degrees, you stop
walking. (If it's greater than 45 degrees, you walk further away, and
if it's less, you walk back towards the tree.) The distance between
you and the base of the tree is then equal to the height of the tree,
and if you have a long enough tape measure you can measure it.

The above works because the tangent of 45 degrees is 1. If you have a
device that will measure the actual angle,
\marginnote{These days, there  are apps that will let you do this with your phone. I found one called Clinometer. See also [link](https://gabrielhemery.com/how-to-calculate-tree-height-using-a-smartphone/).} 
you
can be any distance away from the tree, point the device at the top,
record the angle, and do some trigonometry to estimate the height of
the tree (to which you add the height of your eyes).


 




##  Tortoise shells and eggs


 A biologist measured the length of the carapace (shell) of
female tortoises, and then x-rayed the tortoises to count how many
eggs they were carrying. The length is measured in millimetres. The
data are in
[link](http://www.utsc.utoronto.ca/~butler/d29/tortoise-eggs.txt). The
biologist is wondering what kind of relationship, if any, there is
between the carapace length (as an explanatory variable) and the
number of eggs (as a response variable).



(a) Read in the data, and check that your values look
reasonable. 
 
Solution


Look at the data first. The columns are aligned and separated by
more than one space, so it's `read_table`:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/d29/tortoise-eggs.txt"
tortoises = read_table(my_url)
```

```
## Parsed with column specification:
## cols(
##   length = col_integer(),
##   eggs = col_integer()
## )
```

```r
tortoises
```

```
## # A tibble: 18 x 2
##    length  eggs
##     <int> <int>
##  1    284     3
##  2    290     2
##  3    290     7
##  4    290     7
##  5    298    11
##  6    299    12
##  7    302    10
##  8    306     8
##  9    306     8
## 10    309     9
## 11    310    10
## 12    311    13
## 13    317     7
## 14    317     9
## 15    320     6
## 16    323    13
## 17    334     2
## 18    334     8
```

     

Those look the same as the values in the data file. (*Some*
comment is needed here. I don't much mind what, but something that
suggests that you have eyeballed the data and there are no obvious
problems: that is what I am looking for.)
 


(b) Obtain a scatterplot, with a smooth trend, of the data.

 
Solution


Something like this:

```r
ggplot(tortoises, aes(x = length, y = eggs)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/looe-1} 

   
 


(c) The biologist expected that a larger tortoise would be able
to carry more eggs. Is that what the scatterplot is suggesting?
Explain briefly why or why not.

 
Solution


The biologist's expectation is of an upward trend. But it looks as
if the trend on the scatterplot is up, then down, ie.\ a curve
rather than a straight line. So this is not what the biologist was
expecting. 
 


(d) Fit a straight-line relationship and display the summary.

 
Solution



```r
tortoises.1 = lm(eggs ~ length, data = tortoises)
summary(tortoises.1)
```

```
## 
## Call:
## lm(formula = eggs ~ length, data = tortoises)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -6.7790 -1.1772 -0.0065  2.0487  4.8556 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) -0.43532   17.34992  -0.025
## length       0.02759    0.05631   0.490
##             Pr(>|t|)
## (Intercept)    0.980
## length         0.631
## 
## Residual standard error: 3.411 on 16 degrees of freedom
## Multiple R-squared:  0.01478,	Adjusted R-squared:  -0.0468 
## F-statistic:  0.24 on 1 and 16 DF,  p-value: 0.6308
```

   

I didn't ask for a comment, but feel free to observe that this
regression is truly awful, with an R-squared of less than 2\% and a
non-significant effect of `length`.
 


(e) Add a squared term to your regression, fit that and display
the  summary.

 
Solution


The `I()` is needed because the raise-to-a-power symbol has
a special meaning in a model formula, and we want to *not*
use that special meaning:

```r
tortoises.2 = lm(eggs ~ length + I(length^2), 
    data = tortoises)
summary(tortoises.2)
```

```
## 
## Call:
## lm(formula = eggs ~ length + I(length^2), data = tortoises)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.0091 -1.8480 -0.1896  2.0989  4.3605 
## 
## Coefficients:
##               Estimate Std. Error t value
## (Intercept) -8.999e+02  2.703e+02  -3.329
## length       5.857e+00  1.750e+00   3.347
## I(length^2) -9.425e-03  2.829e-03  -3.332
##             Pr(>|t|)   
## (Intercept)  0.00457 **
## length       0.00441 **
## I(length^2)  0.00455 **
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.671 on 15 degrees of freedom
## Multiple R-squared:  0.4338,	Adjusted R-squared:  0.3583 
## F-statistic: 5.747 on 2 and 15 DF,  p-value: 0.01403
```

 

Another way is to use `update`:


```r
tortoises.2a = update(tortoises.1, . ~ . + I(length^2))
summary(tortoises.2a)
```

```
## 
## Call:
## lm(formula = eggs ~ length + I(length^2), data = tortoises)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.0091 -1.8480 -0.1896  2.0989  4.3605 
## 
## Coefficients:
##               Estimate Std. Error t value
## (Intercept) -8.999e+02  2.703e+02  -3.329
## length       5.857e+00  1.750e+00   3.347
## I(length^2) -9.425e-03  2.829e-03  -3.332
##             Pr(>|t|)   
## (Intercept)  0.00457 **
## length       0.00441 **
## I(length^2)  0.00455 **
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.671 on 15 degrees of freedom
## Multiple R-squared:  0.4338,	Adjusted R-squared:  0.3583 
## F-statistic: 5.747 on 2 and 15 DF,  p-value: 0.01403
```

 
 


(f) Is a curve better than a line for these data? Justify your
answer in two ways: by comparing a measure of fit, and  by doing a
suitable test of significance.

 
Solution


An appropriate measure of fit is R-squared. For the straight line,
this is about 0.01, and for the regression with the squared term it
is about 0.43. This tells us that  a straight line fits appallingly
badly, and that a curve fits a *lot* better. 
This doesn't do a test, though. For that, look at the slope of the
length-squared term in the second regression; in particular,
look at its P-value. This is 0.0045, which is small: the squared
term is necessary, and taking it out would be a mistake. The
relationship really is curved, and trying to describe it with a
straight line would be a big mistake.
 


(g) Make a residual plot for the straight line model: that is, plot
the residuals against the fitted values.
 Does this echo
your conclusions of the previous part? In what way? Explain briefly.

 
Solution


Plot the things called `.fitted` and `.resid` from the
regression object, which is not a data frame but you can treat it as
if it is for this:


```r
ggplot(tortoises.1, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-105-1} 

 

Up to you whether you put a smooth trend on it or not:


```r
ggplot(tortoises.1, aes(x = .fitted, y = .resid)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-106-1} 

 
Looking at the plot, you see a curve, up and down. The most
negative residuals go with small or large fitted values; when the
fitted value is in the middle, the residual is usually positive. A
curve on the residual plot indicates a curve in the actual
relationship. We just found above that a curve does fit a lot
better, so this is all consistent.

Aside: the grey "envelope" is wide, so there is a lot of scatter on the
residual plot. The grey envelope almost contains zero all the way
across, so the evidence for a curve (or any other kind of trend) is
not all that strong, based on this plot. This is in great contrast to
the regression with length-squared, where the length-squared term is
*definitely* necessary. 

That was all I wanted, but you can certainly look at other
plots. Normal quantile plot of the residuals:


```r
ggplot(tortoises.1, aes(sample = .resid)) + stat_qq() + 
    stat_qq_line()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-107-1} 

 

This is not the best: the low values are a bit too low, so that the
whole picture is (a little) skewed to the left.
\marginnote{The very   negative residuals are at the left and right of the residual plot;  they are there because the relationship is a curve. If you were to  look at the residuals from the model with length-squared, you  probably wouldn't see this.}

Another plot you can make is to assess fan-out: you plot the
*absolute value*
\marginnote{The value, but throw away the minus sign if it has one.} of the residuals against the fitted values. The idea
is that if there is fan-out, the absolute value of the residuals will
get bigger:


```r
ggplot(tortoises.1, aes(x = .fitted, y = abs(.resid))) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-108-1} 

 

I put the smooth curve on as a kind of warning: it looks as if the
size of the residuals goes down and then up again as the fitted values
increase. But the width of the grey "envelope" and the general
scatter of the points suggests that there is really not much happening
here at all. On a plot of residuals, the grey envelope is really more
informative than the blue smooth trend. On this one, there is no
evidence of any fan-out (or fan-in). 

 





##  Crickets revisited


 This is a continuation of the crickets problem that you
may have seen before (minus the data tidying).

Male tree crickets produce "mating songs" by rubbing their wings
together to produce a chirping sound. It is hypothesized that female
tree crickets identify males of the correct species by how fast (in
chirps per second) the male's mating song is. This is called the
"pulse rate".  Some data for two species of crickets are in
[link](http://www.utsc.utoronto.ca/~butler/c32/crickets2.csv) as a CSV
file. The columns are species (text), temperature, and pulse
rate (numbers). This is the tidied version of the data set that the
previous version of this question had you create.
The research question is whether males
of the different species have different average pulse rates. It is
also of interest to see whether temperature has an effect, and if
so, what.


(a) Read the data into R and display what you have.


Solution


Nothing terribly surprising here:


```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/crickets2.csv"
crickets = read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   species = col_character(),
##   temperature = col_double(),
##   pulse_rate = col_double()
## )
```

```r
crickets
```

```
## # A tibble: 31 x 3
##    species       temperature pulse_rate
##    <chr>               <dbl>      <dbl>
##  1 exclamationis        20.8       67.9
##  2 exclamationis        20.8       65.1
##  3 exclamationis        24         77.3
##  4 exclamationis        24         78.7
##  5 exclamationis        24         79.4
##  6 exclamationis        24         80.4
##  7 exclamationis        26.2       85.8
##  8 exclamationis        26.2       86.6
##  9 exclamationis        26.2       87.5
## 10 exclamationis        26.2       89.1
## # ... with 21 more rows
```

 

31 crickets, which is what I remember. What species are there?


```r
crickets %>% count(species)
```

```
## # A tibble: 2 x 2
##   species           n
##   <chr>         <int>
## 1 exclamationis    14
## 2 niveus           17
```

 

That looks good. We proceed.



(b) Do a two-sample $t$-test to see whether the mean pulse rates
differ between species. What do you conclude?


Solution


Drag your mind way back to this:

```r
t.test(pulse_rate ~ species, data = crickets)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  pulse_rate by species
## t = 5.2236, df = 28.719, p-value =
## 1.401e-05
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  14.08583 32.22677
## sample estimates:
## mean in group exclamationis 
##                    85.58571 
##        mean in group niveus 
##                    62.42941
```

 

There is strong evidence of a difference in means (a P-value around
0.00001), and the confidence interval says that the mean chirp rate is
higher for *exclamationis*. That is, not just for the crickets
that were observed here, but for *all* crickets of these two
species. 
      


(c) Can you do that two-sample $t$-test as a regression?


Solution


Hang onto the "pulse rate depends on species" idea and try
that in `lm`:

```r
pulse.0 = lm(pulse_rate ~ species, data = crickets)
summary(pulse.0)
```

```
## 
## Call:
## lm(formula = pulse_rate ~ species, data = crickets)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -20.486  -9.458  -1.729  13.342  22.271 
## 
## Coefficients:
##               Estimate Std. Error t value
## (Intercept)     85.586      3.316  25.807
## speciesniveus  -23.156      4.478  -5.171
##               Pr(>|t|)    
## (Intercept)    < 2e-16 ***
## speciesniveus 1.58e-05 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 12.41 on 29 degrees of freedom
## Multiple R-squared:  0.4797,	Adjusted R-squared:  0.4617 
## F-statistic: 26.74 on 1 and 29 DF,  p-value: 1.579e-05
```

         

I had to use "model 0" for this since I already have a
`pulse.1` below and I didn't want to go down and renumber
everything. 

Look along the `speciesniveus` line. Ignoring the fact that it
is negative, the $t$-statistic is almost the same as before (5.17 vs.\
5.22) and so is the P-value ($1.4 \times 10^{-5}$ vs.\ $1.6 \times
10^{-5}$). 

Why aren't they exactly the same? Regression is assuming equal
variances everywhere (that is, within the two `species`), and
before, we did the Welch-Satterthwaite test that does not assume equal
variances. What if we do the pooled $t$-test instead?


```r
t.test(pulse_rate ~ species, data = crickets, 
    var.equal = T)
```

```
## 
## 	Two Sample t-test
## 
## data:  pulse_rate by species
## t = 5.1706, df = 29, p-value =
## 1.579e-05
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  13.99690 32.31571
## sample estimates:
## mean in group exclamationis 
##                    85.58571 
##        mean in group niveus 
##                    62.42941
```

 

Now the regression and the $t$-test *do* give exactly the same
answers. We'll think about that equal-spreads assumption again later.



(d) The analysis in the last part did not use temperature,
however. Is it possible that temperature also has an effect? To
assess this, draw a scatterplot of pulse rate against temperature,
with the points distinguished, somehow, by the species they are
from.
\marginnote{This was the actual reason I thought of this      question originally:    I wanted you to do this.}


Solution


One of the wonderful things about `ggplot` is that doing
the obvious thing works:

```r
ggplot(crickets, aes(x = temperature, y = pulse_rate, 
    colour = species)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-114-1} 

       
    


(e) What does the plot tell you that the $t$-test doesn't? How
would you describe differences in pulse rates between species now?


Solution


The plot tells you that (for both species) as temperature goes
up, pulse rate goes up as well. *Allowing for that*, the
difference in pulse rates between the two species is even
clearer than it was before. To see an example, pick a
temperature, and note that the mean pulse rate at that
temperature seems to be at least 10 higher for
*exclamationis*, with a high degree of consistency.
The $t$-test mixed up all the pulse rates at all the different
temperatures. Even though the conclusion was clear enough, it
could be clearer if we incorporated temperature into the analysis.
There was also a potential source of unfairness in that the
*exclamationis* crickets tended to be observed at higher
temperatures than *niveus* crickets; since pulse rates
increase with temperature, the apparent difference in pulse
rates between the species might have been explainable by one
species being observed mainly in higher temperatures. This was
*utterly invisible* to us when we did the $t$-test, but it
shows the importance of accounting for all the relevant
variables when you do your analysis.
\marginnote{And it shows the        value of looking at relevant plots.} If the species had been
observed at opposite temperatures, we might have
concluded
\marginnote{Mistakenly.} 
that *niveus* have the
higher pulse rates on average. I come back to this later when I
discuss the confidence interval for species difference that
comes out of the regression model with temperature.
      


(f) Fit a regression predicting pulse rate from species and
temperature. Compare the P-value for species in this regression to
the one from the $t$-test. What does that tell you?


Solution


This is actually a so-called "analysis of covariance model",
which properly belongs in D29, but it's really just a regression:

```r
pulse.1 = lm(pulse_rate ~ species + temperature, 
    data = crickets)
summary(pulse.1)
```

```
## 
## Call:
## lm(formula = pulse_rate ~ species + temperature, data = crickets)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.0128 -1.1296 -0.3912  0.9650  3.7800 
## 
## Coefficients:
##                Estimate Std. Error t value
## (Intercept)    -7.21091    2.55094  -2.827
## speciesniveus -10.06529    0.73526 -13.689
## temperature     3.60275    0.09729  37.032
##               Pr(>|t|)    
## (Intercept)    0.00858 ** 
## speciesniveus 6.27e-14 ***
## temperature    < 2e-16 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 1.786 on 28 degrees of freedom
## Multiple R-squared:  0.9896,	Adjusted R-squared:  0.9888 
## F-statistic:  1331 on 2 and 28 DF,  p-value: < 2.2e-16
```

 

The P-value for species is now $6.27\times 10^{-14}$ or
0.00000000000006, which is even less than the P-value of 0.00001 that
came out of the $t$-test. That is to say, when you know temperature,
you can be even more sure of your conclusion that there is a
difference between the species.

The R-squared for this regression is almost 99\%, which says that if
you know both temperature and species, you can predict the pulse rate
almost exactly.

In the regression output, the slope for species is about $-10$. It is
labelled `speciesniveus`. Since species is categorical,
`lm` uses the first category, *exclamationis*, as the
baseline and expresses each other species relative to that. Since the
slope is about $-10$, it says that at any given temperature, the mean
pulse rate for *niveus* is about 10 less than for
*exclamationis*. This is pretty much what the scatterplot told
us.

We can go a little further here:


```r
confint(pulse.1)
```

```
##                    2.5 %    97.5 %
## (Intercept)   -12.436265 -1.985547
## speciesniveus -11.571408 -8.559175
## temperature     3.403467  3.802038
```

 

The second line says that the pulse rate for *niveus* is
between about 8.5 and 11.5 less than for *exclamationis*, at
any given temperature (comparing the two species at the same
temperature as each other, but that temperature could be
anything). This is a lot shorter than the CI that came out of the
$t$-test, that went from 14 to 32. This is because we are now
accounting for temperature, which also makes a difference. (In the
$t$-test, the temperatures were all mixed up). What we also see is
that the $t$-interval is shifted up compared to the one from the
regression. This is because the $t$-interval conflates
\marginnote{Mixes up.} 
two things: the *exclamationis* crickets do have a
higher pulse rate, but they were also observed at higher temperatures,
which makes it look as if their pulse rates are more
higher
\marginnote{This is actually grammatically correct.} than they
really are, when you account for temperature.

This particular model constrains the slope with temperature to be the
same for both species (just the intercepts differ). If you want to
allow the slopes to differ between species, you add an interaction
between temperature and species:


```r
pulse.2 = lm(pulse_rate ~ species * temperature, 
    data = crickets)
summary(pulse.2)
```

```
## 
## Call:
## lm(formula = pulse_rate ~ species * temperature, data = crickets)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.7031 -1.3417 -0.1235  0.8100  3.6330 
## 
## Coefficients:
##                           Estimate
## (Intercept)               -11.0408
## speciesniveus              -4.3484
## temperature                 3.7514
## speciesniveus:temperature  -0.2340
##                           Std. Error t value
## (Intercept)                   4.1515  -2.659
## speciesniveus                 4.9617  -0.876
## temperature                   0.1601  23.429
## speciesniveus:temperature     0.2009  -1.165
##                           Pr(>|t|)    
## (Intercept)                  0.013 *  
## speciesniveus                0.389    
## temperature                 <2e-16 ***
## speciesniveus:temperature    0.254    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 1.775 on 27 degrees of freedom
## Multiple R-squared:  0.9901,	Adjusted R-squared:  0.989 
## F-statistic: 898.9 on 3 and 27 DF,  p-value: < 2.2e-16
```

 

To see whether adding the interaction term added anything to the
prediction,
\marginnote{Though it's hard to imagine being able to improve on an R-squared of 99%.} 
compare the model with and without using `anova`:


```r
anova(pulse.1, pulse.2)
```

```
## Analysis of Variance Table
## 
## Model 1: pulse_rate ~ species + temperature
## Model 2: pulse_rate ~ species * temperature
##   Res.Df    RSS Df Sum of Sq     F Pr(>F)
## 1     28 89.350                          
## 2     27 85.074  1    4.2758 1.357 0.2542
```

 

There's no significant improvement by adding the interaction, so
there's no evidence that having different slopes for each species is
necessary. This is the same interpretation as any `anova` for
comparing two regressions: the two models are not significantly
different in fit, so go with the simpler one, that is, the one without
the interaction.

Note that `anova` gave the same P-value as did the
$t$-test for the slope coefficient for the interaction in
`summary`, 0.254 in both cases. This is because there were only
two species and therefore only one slope coefficient was required to
distinguish them. If there had been three species, we would have had
to look at the `anova` output to hunt for a difference among
species, since there would have been two slope coefficients, each with
its own P-value.
\marginnote{This wouldn't have told us about the overall  effect of species.} 

If you haven't seen interactions before, don't worry about this. The
idea behind it is that we are testing whether we needed lines with
different slopes and we concluded that we don't. Don't worry so much
about the mechanism behind `pulse.2`; just worry about how it
somehow provides a way of modelling two different slopes, one for each
species, which we can then test to see whether it helps.

The upshot is that we do not need different slopes; the model
`pulse.1` with the same slope for each species describes what
is going on.

`ggplot` makes it almost laughably easy to add regression lines
for each species to our plot, thus:


```r
ggplot(crickets, aes(x = temperature, y = pulse_rate, 
    colour = species)) + geom_point() + geom_smooth(method = "lm", 
    se = F)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-119-1} 

 

The lines are almost exactly parallel, so having the same slope for
each species makes perfect sense.
      


(g) Make suitable residual plots for the regression
`pulse.1`. 


Solution


First, the plot of residuals against fitted values (after all,
it *is* a regression):

```r
ggplot(pulse.1, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-120-1} 

         

This looks nice and random.

Now, we plot the residuals against the explanatory variables. There
are two, temperature and species, but the latter is categorical. We'll
have some extra issues around species, but before we get to that, we
have to remember that the data and the output from the regression are
in different places when we plot them. There are different ways to get
around that. Perhaps the simplest is to use `pulse.1` as our
"default" data frame and then get `temperature` from the
right place:


```r
ggplot(pulse.1, aes(x = crickets$temperature, 
    y = .resid)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-121-1} 

 

I don't see anything untoward there.

Species. We want to compare the residuals for the two species, which
is categorical. Since the residuals are quantitative, this suggests a
boxplot. Remembering to get species from the right place again, that
goes like this:


```r
ggplot(pulse.1, aes(x = crickets$species, y = .resid)) + 
    geom_boxplot()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-122-1} 

 

For the residuals, the median should be zero within each group, and
the two groups should be approximately normal with mean 0 and about
the same spread. Same spread looks OK, since the boxes are almost
exactly the same height, but the normality is not quite there, since
both distributions are a little bit skewed to the right. That would
also explain why the median residual in each group is a little bit
less than zero, because the mathematics requires the overall
*mean* residual to be zero, and the right-skewness would make the
mean higher than the median.

Is that non-normality really problematic? Well, I could look at the
normal quantile plot of all the residuals together:


```r
ggplot(pulse.1, aes(sample = .resid)) + stat_qq() + 
    stat_qq_line()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-123-1} 

 

There's a little weirdness at the top, and a tiny indication of a
curve (that would suggest a little right-skewedness), but not really
much to worry about. If that third-highest residual were a bit
lower (say, 3 rather than 3.5) and maybe if the lowest residual was a
bit lower, I don't think we'd have anything to complain about at all.

So, I'm not worried.






##  Roller coasters


 A poll on the Discovery Channel asked people to nominate the
best roller-coasters in the United States. We will examine the 10
roller-coasters that received the most votes. Two features of a
roller-coaster that are of interest are the distance it drops from
start to finish, measured here in feet
\marginnote{Roller-coasters work by   gravity, so there must be some drop.} and the duration of the ride,
measured in seconds. Is it true that roller-coasters with a bigger
drop also tend to have a longer ride? The data are at
[link](http://www.utsc.utoronto.ca/~butler/c32/coasters.csv).
\marginnote{These are not to be confused with what your mom insists that you place between your coffee mug and the table.}



(a) Read the data into R and verify that you have a sensible
number of rows and columns.


Solution


A `.csv`, so the usual for that:


```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/coasters.csv"
coasters = read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   coaster_name = col_character(),
##   state = col_character(),
##   drop = col_integer(),
##   duration = col_integer()
## )
```

```r
coasters
```

```
## # A tibble: 10 x 4
##    coaster_name    state       drop duration
##    <chr>           <chr>      <int>    <int>
##  1 Incredible Hulk Florida      105      135
##  2 Millennium For~ Ohio         300      105
##  3 Goliath         California   255      180
##  4 Nitro           New Jersey   215      240
##  5 Magnum XL-2000  Ohio         195      120
##  6 The Beast       Ohio         141       65
##  7 Son of Beast    Ohio         214      140
##  8 Thunderbolt     Pennsylva~    95       90
##  9 Ghost Rider     California   108      160
## 10 Raven           Indiana       86       90
```

 

The number of marks for this kind of thing has been decreasing through
the course, since by now you ought to have figured out how to do it
without looking it up.

There are 10 rows for the promised 10 roller-coasters, and there are
several columns: the drop for each roller-coaster and the duration of
its ride, as promised, as well as the name of each roller-coaster and the state
that it is in. (A lot of them seem to be in Ohio, for some reason that
I don't know.) So this all looks good.



(b) Make a scatterplot of duration (response) against drop
(explanatory), labelling each roller-coaster with its name in such a
way that the labels do not overlap. Add a regression line to your plot.


Solution


The last part, about the labels not overlapping, is an
invitation to use `ggrepel`, which is the way I'd
recommend doing this. (If not, you have to do potentially lots
of work organizing where the labels sit relative to the points,
which is time you probably don't want to spend.) Thus:

```r
library(ggrepel)
ggplot(coasters, aes(x = drop, y = duration, label = coaster_name)) + 
    geom_point() + geom_text_repel() + geom_smooth(method = "lm", 
    se = F)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-125-1} 

       

The `se=F` at the end is optional; if you omit it, you get that
"envelope" around the line, which is fine here.

Note that with the labelling done this way, you can easily identify
which roller-coaster is which.



(c) Would you say that roller-coasters with a larger drop tend
to have a longer ride? Explain briefly.


Solution


I think there are two good answers here: "yes" and "kind of".
Supporting "yes" is the fact that the regression line does go
uphill, so that overall, or on average, roller-coasters with a
larger drop do tend to have a longer duration of ride as well.
Supporting "kind of" is the fact that, though the regression
line goes uphill, there are a lot of roller-coasters that are
some way off the trend, far from the regression line.
I am happy to go with either of those. I could also go with
"not really" and the same discussion that I attached to 
"kind of". 



(d) Find a roller-coaster that is unusual compared to the
others. What about its combination of `drop` and
`duration` is unusual?


Solution


This is an invitation to find a point that is a long way off the
line. I think the obvious choice is my first one below, but I
would take either of the others as well:


* "Nitro" is a long way above the line. That means it has
a long duration, relative to its drop. There are two other
roller-coasters that have a larger drop but not as long a
duration. In other words, this roller-coaster drops slowly,
presumably by doing a lot of twisting, loop-the-loop and so on.

* "The Beast" is a long way below the line, so it has a
short duration relative to its drop. It is actually the
shortest ride of all, but is only a bit below average in terms
of drop. This suggests that The Beast is one of those rides
that drops a long way quickly.

* "Millennium Force" has the biggest drop of all, but a
shorter-than-average duration. This looks like another ride
with a big drop in it.

A roller-coaster that is "unusual" will have a residual that
is large in size (either positive, like Nitro, or negative, like
the other two). I didn't ask you to find the residuals, but if
you want to, `augment` from `broom` is the
smoothest way to go:

```r
library(broom)
duration.1 = lm(duration ~ drop, data = coasters)
augment(duration.1, coasters) %>% select(coaster_name, 
    duration, drop, .resid) %>% arrange(desc(abs(.resid)))
```

```
## # A tibble: 10 x 4
##    coaster_name     duration  drop .resid
##    <chr>               <int> <int>  <dbl>
##  1 Nitro                 240   215  97.0 
##  2 The Beast              65   141 -60.1 
##  3 Millennium Force      105   300 -58.6 
##  4 Ghost Rider           160   108  42.8 
##  5 Goliath               180   255  27.3 
##  6 Thunderbolt            90    95 -24.0 
##  7 Raven                  90    86 -21.8 
##  8 Incredible Hulk       135   105  18.6 
##  9 Magnum XL-2000        120   195 -18.2 
## 10 Son of Beast          140   214  -2.81
```

       

`augment` produces a data frame (of the original data frame
with some new columns that come from the regression), so I can feed it
into a pipe to do things with it, like only displaying the columns I
want, and arranging them in order by absolute value of residual, so
that the roller-coasters further from the line come out first. This
identifies the three that we found above. The fourth one, "Ghost Rider", 
is like Nitro in that it takes a (relatively) long time to
fall not very far.
You can also put `augment` in the *middle* of a pipe. What
you may have to do then is supply the *original* data frame name
to `augment` so that you have everything:


```r
coasters %>% lm(duration ~ drop, data = .) %>% 
    augment(coasters) %>% arrange(desc(abs(.resid)))
```

```
## # A tibble: 10 x 11
##    coaster_name state  drop duration .fitted
##    <chr>        <chr> <int>    <int>   <dbl>
##  1 Nitro        New ~   215      240    143.
##  2 The Beast    Ohio    141       65    125.
##  3 Millennium ~ Ohio    300      105    164.
##  4 Ghost Rider  Cali~   108      160    117.
##  5 Goliath      Cali~   255      180    153.
##  6 Thunderbolt  Penn~    95       90    114.
##  7 Raven        Indi~    86       90    112.
##  8 Incredible ~ Flor~   105      135    116.
##  9 Magnum XL-2~ Ohio    195      120    138.
## 10 Son of Beast Ohio    214      140    143.
## # ... with 6 more variables: .se.fit <dbl>,
## #   .resid <dbl>, .hat <dbl>, .sigma <dbl>,
## #   .cooksd <dbl>, .std.resid <dbl>
```

 

I wanted to hang on to the roller-coaster names, so I added the data
frame name to `augment`. If you don't (that is, you just put
`augment()` in the middle of a pipe), then `augment`
"attempts to reconstruct the data from the model".
\marginnote{A quote  from the package vignette.} That means you wouldn't get
*everything* from the original data frame; you would just get the
things that were in the regression. In this case, that means you would lose
the coaster names.

A technicality (but one that you should probably care about):
`augment` takes up to *two* inputs: a fitted model object
like my `duration.1`, and an optional data frame to include
other things from, like the coaster names. I had only one input to it
in the pipe because the implied first input was the output from the
`lm`, which doesn't have a name; the input `coasters` in
the pipe was what would normally be the *second* input to
`augment`.






##  Running and blood sugar


 A diabetic wants to know how aerobic exercise affects his
blood sugar. When his blood sugar reaches 170 (mg/dl), he goes out for
a run at a pace of 10 minutes per mile. He runs different distances on
different days. Each time he runs, he measures his blood sugar after
the run. (The preferred blood sugar level is between 80 and 120 on
this scale.) The data are in the file
[link](http://www.utsc.utoronto.ca/~butler/d29/runner.txt).  Our aim is
to predict blood sugar from distance.



(a) Read in the data and display the data frame that you read
in.
 
Solution


From the URL is easiest. These are delimited by one space, as
you can tell by looking at the file:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/d29/runner.txt"
runs = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   distance = col_double(),
##   blood_sugar = col_integer()
## )
```

```r
runs
```

```
## # A tibble: 12 x 2
##    distance blood_sugar
##       <dbl>       <int>
##  1      2           136
##  2      2           146
##  3      2.5         131
##  4      2.5         125
##  5      3           120
##  6      3           116
##  7      3.5         104
##  8      3.5          95
##  9      4            85
## 10      4            94
## 11      4.5          83
## 12      4.5          75
```

     

That looks like my data file.
 

(b) Make a scatterplot and add a smooth trend to it.
 
Solution



```r
ggplot(runs, aes(x = distance, y = blood_sugar)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/plymouth-1} 

     

`blood_sugar` should be on the vertical axis, since this is
what we are trying to predict. Getting the `x` and the
`y` right is easy on these, because they are the $x$ and $y$
for your plot.
 

(c) Would you say that the relationship between blood sugar and
running distance is approximately linear, or not? It is therefore
reasonable to use a regression of blood sugar on distance? Explain briefly.
 
Solution


I'd say that this is about as linear as you could ever wish
for. Neither the pattern of points nor the smooth trend have any
kind of noticeable bend in them. (Observing a lack of curvature in
either the points or the smooth trend is enough.) The trend
is a linear one, so using a regression will be just fine. (If it
weren't, the rest of the question would be kind of dumb.)
 

(d) Fit a suitable regression, and obtain the regression output.
 
Solution


Two steps: `lm` and then `summary`:

```r
runs.1 = lm(blood_sugar ~ distance, data = runs)
summary(runs.1)
```

```
## 
## Call:
## lm(formula = blood_sugar ~ distance, data = runs)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -7.8238 -3.6167  0.8333  4.0190  5.5476 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)  191.624      5.439   35.23
## distance     -25.371      1.618  -15.68
##             Pr(>|t|)    
## (Intercept) 8.05e-12 ***
## distance    2.29e-08 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 4.788 on 10 degrees of freedom
## Multiple R-squared:  0.9609,	Adjusted R-squared:  0.957 
## F-statistic: 245.7 on 1 and 10 DF,  p-value: 2.287e-08
```

     
 

(e) How would you *interpret* the slope? That is, what is
the slope, and what does that mean about blood sugar and running distance?
 
Solution


The slope is $-25.37$. This means that for each additional mile run,
the runner's blood sugar will decrease on average by about 25 units.

You can check this from the scatterplot. For example, from 2 to 3
miles, average blood sugar decreases from about 140 to about 115, a
drop of 25.
 

(f) Is there a (statistically) significant relationship between
running distance and blood sugar? How do you know? Do you find this
surprising, given what you have seen so far? Explain briefly.
 
Solution


Look at the P-value either on the `distance` line (for its
$t$-test) or for the $F$-statistic on the bottom line. These are
the same: 0.000000023. (They will be the same any time there is
one $x$-variable.) This P-value is *way* smaller than 0.05,
so there *is* a significant relationship between running distance
and blood sugar. This does not surprise me in the slightest,
because the trend on the scatterplot is *so* clear, there's
no way it could have happened by chance if in fact there were no
relationship between running distance and blood sugar.
 

(g) This diabetic is planning to go for a 3-mile run tomorrow
and a 5-mile run the day after. Obtain suitable 95\% intervals that
say what his blood sugar might be after each of these runs. 
 
Solution


This is a prediction interval, in each case, since we are talking about
*individual* runs of 3 miles and 5 miles (not the mean blood
sugar after *all* runs of 3 miles, which is what a confidence
interval for the mean response would be).
The procedure is to set up a data frame with the two
`distance` values in it, and then feed that and the
regression object into `predict`, coming up in a moment.

```r
dists = c(3, 5)
dist.new = tibble(distance = dists)
dist.new
```

```
## # A tibble: 2 x 1
##   distance
##      <dbl>
## 1        3
## 2        5
```

     
The important thing is that the name of the column of the new data
frame must be *exactly* the same as the name of the explanatory
variable in the regression. If they don't match, `predict`
won't work. At least, it won't work properly.
\marginnote{It won't give you an error, but it will go back to the *original* data frame to get distances to predict from, and you will get very confused.}

Then, `predict`:


```r
pp = predict(runs.1, dist.new, interval = "p")
pp
```

```
##         fit       lwr       upr
## 1 115.50952 104.37000 126.64905
## 2  64.76667  51.99545  77.53788
```

 

and display this with the distances by the side:


```r
cbind(dist.new, pp)
```

```
##   distance       fit       lwr       upr
## 1        3 115.50952 104.37000 126.64905
## 2        5  64.76667  51.99545  77.53788
```

 

or


```r
data.frame(dist.new, pp)
```

```
##   distance       fit       lwr       upr
## 1        3 115.50952 104.37000 126.64905
## 2        5  64.76667  51.99545  77.53788
```

 
Blood sugar after a 3-mile run is predicted to be between 104 and 127;
after a 5-mile run it is predicted to be between 52 and 77.5.

Extra: both `cbind` and `data.frame` are "base R" ways of
combining a data frame with something else to make a new data
frame. They are not from the `tidyverse`. The
`tidyverse` way is via `tibble` or `bind_cols`,
but they are a bit more particular about what they will take:
`tibble` takes vectors (single variables) and
`bind_cols` takes vectors or data frames. The problem here is
that `pp` is not either of those:


```r
class(pp)
```

```
## [1] "matrix"
```

 

so that we have to use `as_tibble` first to turn it into a
data frame, and thus:


```r
pp %>% as_tibble() %>% bind_cols(dist.new)
```

```
## # A tibble: 2 x 4
##     fit   lwr   upr distance
##   <dbl> <dbl> <dbl>    <dbl>
## 1 116.  104.  127.         3
## 2  64.8  52.0  77.5        5
```

 

which puts things backwards, unless you do it like this:


```r
dist.new %>% bind_cols(as_tibble(pp))
```

```
## # A tibble: 2 x 4
##   distance   fit   lwr   upr
##      <dbl> <dbl> <dbl> <dbl>
## 1        3 116.  104.  127. 
## 2        5  64.8  52.0  77.5
```

 

which is a pretty result from very ugly code. 

I also remembered that if you finish with a `select`, you get the columns in the order they were in the `select`:


```r
pp %>% as_tibble() %>% bind_cols(dist.new) %>% 
    select(c(distance, everything()))
```

```
## # A tibble: 2 x 4
##   distance   fit   lwr   upr
##      <dbl> <dbl> <dbl> <dbl>
## 1        3 116.  104.  127. 
## 2        5  64.8  52.0  77.5
```

 

`everything` is a so-called "select helper". It means 
"everything except any columns you already named", so this whole thing has the effect of listing the columns 
with `distance` first and all the other columns afterwards, in the order that they were in before.
 

(h) Which of your two intervals is longer? Does this make
sense? Explain briefly.
 
Solution


The intervals are about 22.25 and 25.5 units long. The one for a
5-mile run is a bit longer. I think this makes sense because 3
miles is close to the average run distance, so there is a lot of
"nearby" data. 5 miles is actually longer than any of the runs
that were actually done (and therefore we are actually
extrapolating), but the important point for the prediction
interval is that there is less nearby data: those 2-mile runs
don't help so much in predicting blood sugar after a 5-mile
run. (They help *some*, because the trend is so linear. This
is why the 5-mile interval is not *so* much longer. If the
trend were less clear, the 5-mile interval would be more
noticeably worse.)
 




##  Calories and fat in pizza


 
The file at
[link](http://www.utsc.utoronto.ca/~butler/d29/Pizza.csv) 
came from a spreadsheet of information about 24 brands
of pizza: specifically, per 5-ounce serving, the number of calories,
the grams of fat, and the cost (in US dollars). The names of the pizza
brands are quite long. This file may open in a spreadsheet when you
browse to the link, depending on your computer's setup.



(a) Read in the data and display at least some of the data
frame. Are the variables of the right types? (In particular, why is
the number of calories labelled one way and the cost labelled a
different way?)

Solution


`read_csv` is the thing this time:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/d29/Pizza.csv"
pizza = read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   Type = col_character(),
##   Calories = col_integer(),
##   Fat = col_double(),
##   Cost = col_double()
## )
```

```r
pizza
```

```
## # A tibble: 24 x 4
##    Type                 Calories   Fat  Cost
##    <chr>                   <int> <dbl> <dbl>
##  1 Domino's Deep Dish ~      385  19.5  1.87
##  2 Pizza Hut's Stuffed~      370  15    1.83
##  3 Pizza Hut's Pan Piz~      280  14    1.83
##  4 Domino's Hand-Tosse~      305  12    1.67
##  5 Pizza Hut's Hand-To~      230   9    1.63
##  6 Little Caesars' Dee~      350  14.2  1.06
##  7 Little Caesars' Ori~      230   8    0.81
##  8 Freschetta Bakes & ~      364  15    0.98
##  9 Freschetta Bakes & ~      334  11    1.23
## 10 DiGiorno Rising Cru~      332  12    0.94
## # ... with 14 more rows
```

    

The four variables are: the brand of pizza, which got read in as text,
the number of calories (an integer), and the fat and cost, which are
both decimal numbers so they get labelled `dbl`, which is short for 
"double-precision floating point number". 

Anyway, these are apparently the right thing. 

Extra: I wanted to mention something else that I discovered
yesterday.
\marginnote{R is like that: sometimes it seems as if it has  infinite depth.} 
There is a package called `rio` that will
read (and write) data in a whole bunch of different formats in a
unified way.
\marginnote{It does this by figuring what kind of thing you have, from the extension to its filename, and then calling an appropriate function to read in or write out the data. This is an excellent example of *standing on the shoulders of giants* to make our lives easier. The software does the hard work of figuring out what kind of thing you have and how to read it in; all we do is say *import*.} Anyway, the usual installation thing, done once:


```r
install.packages("rio")
```

 

which takes a moment since it probably has to install some other
packages too, and then you read in a file like this:


```r
library(rio)
pizza3 = import(my_url)
head(pizza3)
```

```
##                                       Type
## 1        Domino's Deep Dish with Pepperoni
## 2 Pizza Hut's Stuffed Crust with Pepperoni
## 3     Pizza Hut's Pan Pizza with Pepperoni
## 4      Domino's Hand-Tossed with Pepperoni
## 5   Pizza Hut's Hand-Tossed with Pepperoni
## 6 Little Caesars' Deep Dish with Pepperoni
##   Calories  Fat Cost
## 1      385 19.5 1.87
## 2      370 15.0 1.83
## 3      280 14.0 1.83
## 4      305 12.0 1.67
## 5      230  9.0 1.63
## 6      350 14.2 1.06
```

 

`import` figures that you have a `.csv` file, so it
calls up `read_csv` or similar.

Technical note: `rio` does not use the `read_`
functions, so what it gives you is actually a `data.frame`
rather than a `tibble`, so that when you display it, you get
the whole thing even if it is long. Hence the `head` here and
below to display the first six lines.

I originally had the data as an Excel spreadsheet, but `import`
will gobble up that pizza too:


```r
my_other_url = "http://www.utsc.utoronto.ca/~butler/d29/Pizza_E29.xls"
pizza4 = import(my_other_url)
head(pizza4)
```

```
##                                       Type
## 1        Domino's Deep Dish with Pepperoni
## 2 Pizza Hut's Stuffed Crust with Pepperoni
## 3     Pizza Hut's Pan Pizza with Pepperoni
## 4      Domino's Hand-Tossed with Pepperoni
## 5   Pizza Hut's Hand-Tossed with Pepperoni
## 6 Little Caesars' Deep Dish with Pepperoni
##   Calories Fat (g) Cost ($)
## 1      385    19.5     1.87
## 2      370    15.0     1.83
## 3      280    14.0     1.83
## 4      305    12.0     1.67
## 5      230     9.0     1.63
## 6      350    14.2     1.06
```

 

The corresponding function for writing a data frame to a file in the
right format is, predictably enough, called `export`.


(b) Make a scatterplot for predicting calories from the number
of grams of fat. Add a smooth trend. What kind of relationship do
you see, if any?

Solution


All the variable names start with Capital Letters:

```r
ggplot(pizza, aes(x = Fat, y = Calories)) + geom_point() + 
    geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/alskhslafkhlksfhsasvvvv-1} 

       

There is definitely an upward trend: the more fat, the more
calories. The trend is more or less linear (or, a little bit curved:
say what you like, as long as it's not obviously crazy). *I*
think, with this much scatter, there's no real justification for
fitting a curve.
 

(c) Fit a straight-line relationship, and display the intercept,
slope, R-squared, etc. Is there a real relationship between the two
variables, or is any apparent trend just chance?

Solution


`lm`, with `summary`:

```r
pizza.1 = lm(Calories ~ Fat, data = pizza)
summary(pizza.1)
```

```
## 
## Call:
## lm(formula = Calories ~ Fat, data = pizza)
## 
## Residuals:
##    Min     1Q Median     3Q    Max 
## -55.44 -11.67   6.18  17.87  41.61 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)  194.747     21.605   9.014
## Fat           10.050      1.558   6.449
##             Pr(>|t|)    
## (Intercept) 7.71e-09 ***
## Fat         1.73e-06 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 25.79 on 22 degrees of freedom
## Multiple R-squared:  0.654,	Adjusted R-squared:  0.6383 
## F-statistic: 41.59 on 1 and 22 DF,  p-value: 1.731e-06
```

       

To assess whether this trend is real or just chance, look at the
P-value on the end of the `Fat` line, or on the bottom line
where the $F$-statistic is (they are the same value of $1.73\times
10^{-6}$ or 0.0000017, so you can pick either). This P-value is
really small, so the slope is definitely *not* zero, and
therefore there really is a relationship between the two variables.
 

(d) Obtain a plot of the residuals against the fitted values
for this regression. Does this indicate that there are any problems
with this regression, or not? Explain briefly.

Solution


Use the regression object `pizza.1`:


```r
ggplot(pizza.1, aes(x = .fitted, y = .resid)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-143-1} 

 

On my residual plot, I see a slight curve in the smooth trend,
but I am not worried about that because the residuals on the plot are
all over the place in a seemingly random pattern (the grey envelope is
wide and that is pretty close to going straight across). So I think a
straight line model is satisfactory. 

That's all you needed, but it is also worth looking at a normal
quantile plot of the residuals:


```r
ggplot(pizza.1, aes(sample = .resid)) + stat_qq() + 
    stat_qq_line()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-144-1} 

 

A bit skewed to the left (the low ones are too low).

Also a plot of the absolute residuals, for assessing fan-out:


```r
ggplot(pizza.1, aes(x = .fitted, y = abs(.resid))) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-145-1} 

 

A tiny bit of fan-in (residuals getting *smaller* in size as the
fitted value gets bigger), but nothing much, I think.

Another way of assessing curvedness is to fit a squared term anyway,
and see whether it is significant:


```r
pizza.2 = update(pizza.1, . ~ . + I(Fat^2))
summary(pizza.2)
```

```
## 
## Call:
## lm(formula = Calories ~ Fat + I(Fat^2), data = pizza)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -62.103 -14.280   5.513  15.423  35.474 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)  90.2544    77.8156   1.160
## Fat          25.9717    11.5121   2.256
## I(Fat^2)     -0.5702     0.4086  -1.395
##             Pr(>|t|)  
## (Intercept)   0.2591  
## Fat           0.0349 *
## I(Fat^2)      0.1775  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 25.25 on 21 degrees of freedom
## Multiple R-squared:  0.6834,	Adjusted R-squared:  0.6532 
## F-statistic: 22.66 on 2 and 21 DF,  p-value: 5.698e-06
```

 

The fat-squared term is not significant, so that curve on the smooth trend
in the (first) residual plot was indeed nothing to get excited about.
 

(e) The research assistant in this study returns with two
new brands of pizza (ones that were not in the original data). The
fat content of a 5-ounce serving was 12 grams for the first brand
and 20 grams for the second brand. For each of these brands of
pizza, obtain a suitable 95\% interval for the number of calories
contained in a 5-ounce serving.

Solution


The suitable interval here is a prediction interval, because we
are interested in each case in the calorie content of the
*particular* pizza brands that the research assistant
returned with (and not, for example, in the mean calorie content
for *all* brands of pizza that have 12 grams of fat per
serving). Thus:

```r
newfat = c(12, 20)
new = tibble(Fat = newfat)
new
```

```
## # A tibble: 2 x 1
##     Fat
##   <dbl>
## 1    12
## 2    20
```

```r
preds = predict(pizza.1, new, interval = "p")
cbind(new, preds)
```

```
##   Fat      fit      lwr      upr
## 1  12 315.3447 260.5524 370.1369
## 2  20 395.7431 337.1850 454.3011
```

       

Or, if you like:


```r
as_tibble(preds) %>% bind_cols(new) %>% select(Fat, 
    everything())
```

```
## # A tibble: 2 x 4
##     Fat   fit   lwr   upr
##   <dbl> <dbl> <dbl> <dbl>
## 1    12  315.  261.  370.
## 2    20  396.  337.  454.
```

 

For the pizza with 12 grams of fat, the predicted calories are between
261 and 370 with 95\% confidence, and for the pizza with 20 grams of
fat, the calories are predicted to be between 337 and 454. (You should
write down what these intervals are, and not leave the reader to find
them in the output.)

(Remember the steps: create a new data frame containing the values to
predict for, and then feed that into `predict` along with the
model that you want to use to predict with. The variable in the data
frame has to be called *precisely* `Fat` with a capital F,
otherwise it won't work.)

These intervals are both pretty awful: you get a very weak picture of
how many calories per serving the pizza brands in question might
contain. This is for two reasons: (i) there was a fair bit of scatter
in the original relationship, R-squared being around 65\%, and (ii)
even if we knew perfectly where the line went (which we don't),
there's no guarantee that individual brands of pizza would be on it
anyway. (Prediction intervals are always hit by this double whammy, in
that individual observations suffer from variability in where the line
goes *and* variability around whatever the line is.)

I was expecting, when I put together this question, that the
20-grams-of-fat interval would  be noticeably worse, because 20 is
farther away from the mean fat content of all the brands. But there
isn't much to choose. For the confidence intervals for the mean
calories of *all* brands with these fat contents, the picture is clearer:


```r
preds = predict(pizza.1, new, interval = "c")
cbind(new, preds)
```

```
##   Fat      fit      lwr      upr
## 1  12 315.3447 303.4683 327.2211
## 2  20 395.7431 371.9122 419.5739
```

 

or, as before:


```r
as_tibble(preds) %>% bind_cols(new) %>% select(Fat, 
    everything())
```

```
## # A tibble: 2 x 4
##     Fat   fit   lwr   upr
##   <dbl> <dbl> <dbl> <dbl>
## 1    12  315.  303.  327.
## 2    20  396.  372.  420.
```

 

This time the fat-20 interval is noticeably longer than the fat-12
one. And these are much shorter than the prediction intervals, as we
would guess.

This question is a fair bit of work for 3 points, so I'm not insisting that you explain
your choice of a prediction interval over a confidence interval, but I
think it is still a smart thing to do, even purely from a marks point
of view, because if you get it wrong for a semi-plausible reason, you
might pick up some partial credit. Not pulling out your prediction
intervals from your output is a sure way to lose a point, however.
 




##  Where should the fire stations be?


 In city planning, one major issue is where to locate fire
stations. If a city has too many fire stations, it will spend too much
on running them, but if it has too few, there may be unnecessary fire
damage because the fire trucks take too long to get to the fire.

The first part of a study of this kind of issue is to understand the
relationship between the distance from the fire station (measured in
miles in our data set) and the amount of fire damage caused (measured
in thousands of dollars). A city recorded the fire damage and distance
from fire station for 15 residential fires (which you can take as a
sample of "all possible residential fires in that city"). The data
are in [link](http://www.utsc.utoronto.ca/~butler/d29/fire_damage.txt). 



(a) Read in and display the data, verifying that you have the
right number of rows and the right columns.


Solution


A quick check of the data reveals that the data values are
separated by exactly  one space, so:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/d29/fire_damage.txt"
fire = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   distance = col_double(),
##   damage = col_double()
## )
```

```r
fire
```

```
## # A tibble: 15 x 2
##    distance damage
##       <dbl>  <dbl>
##  1      3.4   26.2
##  2      1.8   17.8
##  3      4.6   31.3
##  4      2.3   23.1
##  5      3.1   27.5
##  6      5.5   36  
##  7      0.7   14.1
##  8      3     22.3
##  9      2.6   19.6
## 10      4.3   31.3
## 11      2.1   24  
## 12      1.1   17.3
## 13      6.1   43.2
## 14      4.8   36.4
## 15      3.8   26.1
```

   

15 observations (rows), and promised, and a column each of distances
and amounts of fire damage, also as promised.

One mark for reading in the data, and one for saying something
convincing about how you have the right thing.
    


(b) <a name="part:ttest">*</a> Obtain a 95\% confidence interval for the
mean fire damage. (There is nothing here from STAD29, and your
answer should have nothing to do with distance.)


Solution


I wanted to dissuade you  from thinking too hard here. It's just
an ordinary one-sample $t$-test, extracting the interval from it:

```r
t.test(fire$damage)
```

```
## 
## 	One Sample t-test
## 
## data:  fire$damage
## t = 12.678, df = 14, p-value =
## 4.605e-09
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  21.94488 30.88178
## sample estimates:
## mean of x 
##  26.41333
```

     

Or


```r
with(fire, t.test(damage))
```

```
## 
## 	One Sample t-test
## 
## data:  damage
## t = 12.678, df = 14, p-value =
## 4.605e-09
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  21.94488 30.88178
## sample estimates:
## mean of x 
##  26.41333
```

 

Ignore the P-value (it's testing that the mean is the default
*zero*, which makes no sense). The confidence interval either way
goes from 21.9 to 30.9 (thousand dollars).
    


(c) Draw a scatterplot for predicting the amount of fire damage
from the distance from the fire station. Add a smooth trend to your
plot. 


Solution


We are predicting fire damage, so that goes on the $y$-axis:

```r
ggplot(fire, aes(x = distance, y = damage)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-154-1} 

     



(d) <a name="part:howgood">*</a> Is there a relationship between distance from fire station
and fire damage? Is it linear or definitely curved? How strong is
it? Explain briefly.


Solution


When the distance is larger, the fire damage is definitely larger,
so there is clearly a relationship. I would call this one
approximately linear: it wiggles a bit, but it is not to my mind
obviously curved. I would also call it a strong relationship,
since the points are close to the smooth trend.
    


(e) Fit a regression predicting fire damage from distance. How
is the R-squared consistent (or inconsistent) with your answer from
part~(<a href="#part:howgood">here</a>)?


Solution


The regression is an ordinary `lm`:

```r
damage.1 = lm(damage ~ distance, data = fire)
summary(damage.1)
```

```
## 
## Call:
## lm(formula = damage ~ distance, data = fire)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.4682 -1.4705 -0.1311  1.7915  3.3915 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)  10.2779     1.4203   7.237
## distance      4.9193     0.3927  12.525
##             Pr(>|t|)    
## (Intercept) 6.59e-06 ***
## distance    1.25e-08 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.316 on 13 degrees of freedom
## Multiple R-squared:  0.9235,	Adjusted R-squared:  0.9176 
## F-statistic: 156.9 on 1 and 13 DF,  p-value: 1.248e-08
```

     

We need to display the results, since we need to see the R-squared in
order to say something about it.

R-squared is about 92\%, high, indicating a strong and linear
relationship. Back in part~(<a href="#part:howgood">here</a>), I said that the
relationship is linear and strong, which is entirely consistent with
such an R-squared. (If you said something different previously, say
how it does or doesn't square with this kind of R-squared value.)

Points: one for fitting the regression, one for displaying it, and two
(at the grader's discretion) for saying what the R-squared is and how
it's consistent (or not) with part~(<a href="#part:howgood">here</a>).

Extra: if you thought the trend was "definitely curved", you would
find that a parabola (or some other kind of curve) was definitely
better than a straight line. Here's the parabola:


```r
damage.2 = lm(damage ~ distance + I(distance^2), 
    data = fire)
summary(damage.2)
```

```
## 
## Call:
## lm(formula = damage ~ distance + I(distance^2), data = fire)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -2.8856 -1.6915 -0.0179  1.5490  3.6278 
## 
## Coefficients:
##               Estimate Std. Error t value
## (Intercept)    13.3395     2.5303   5.272
## distance        2.6400     1.6302   1.619
## I(distance^2)   0.3376     0.2349   1.437
##               Pr(>|t|)    
## (Intercept)   0.000197 ***
## distance      0.131327    
## I(distance^2) 0.176215    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.227 on 12 degrees of freedom
## Multiple R-squared:  0.9347,	Adjusted R-squared:  0.9238 
## F-statistic: 85.91 on 2 and 12 DF,  p-value: 7.742e-08
```

 

There's no evidence here that a quadratic is better.

Or you might even have thought from the wiggles that it was more like cubic:


```r
damage.3 = update(damage.2, . ~ . + I(distance^3))
summary(damage.3)
```

```
## 
## Call:
## lm(formula = damage ~ distance + I(distance^2) + I(distance^3), 
##     data = fire)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.2325 -1.8377  0.0322  1.1512  3.1806 
## 
## Coefficients:
##               Estimate Std. Error t value
## (Intercept)    10.8466     4.3618   2.487
## distance        5.9555     4.9610   1.200
## I(distance^2)  -0.8141     1.6409  -0.496
## I(distance^3)   0.1141     0.1608   0.709
##               Pr(>|t|)  
## (Intercept)     0.0302 *
## distance        0.2552  
## I(distance^2)   0.6296  
## I(distance^3)   0.4928  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.274 on 11 degrees of freedom
## Multiple R-squared:  0.9376,	Adjusted R-squared:  0.9205 
## F-statistic: 55.07 on 3 and 11 DF,  p-value: 6.507e-07
```



No evidence that a cubic is better; that increase in R-squared up to
about 94\% is just chance (bearing in mind that adding *any* $x$,
even a useless one, will increase R-squared).

How bendy is the cubic?


```r
ggplot(fire, aes(x = distance, y = damage)) + 
    geom_point() + geom_smooth(method = "lm") + 
    geom_line(data = damage.3, aes(y = .fitted), 
        colour = "red")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-158-1} 

 

The cubic, in red, does bend a little, but it doesn't do an obvious
job of going through the points better than the straight line does. It
seems to be mostly swayed by that one observation with damage over 40,
and choosing a relationship by how well it fits one point is flimsy at
the best of times.  So, by Occam's Razor, we go with the line rather
than the cubic because it (i) fits equally well, (ii) is simpler.
    


(f) <a name="part:cim">*</a> Obtain a 95\% confidence interval for the mean fire damage
\emph{for a residence that is 4 miles from the nearest fire
station}. (Note the contrast with part~(<a href="#part:ttest">here</a>).)


Solution


This is a confidence interval for a mean response at a given value
of the explanatory variable. This is as opposed to
part~(<a href="#part:ttest">here</a>), which is averaged over *all* distances.
So, follow the steps. Make a tiny data frame with this one value
of `distance`:

```r
new = tibble(distance = 4)
```

     

and then feed it into `predict`:


```r
pp = predict(damage.1, new, interval = "c")
```

 

and then put it side-by-side with the value it's a prediction for:


```r
cbind(new, pp)
```

```
##   distance      fit      lwr      upr
## 1        4 29.95525 28.52604 31.38446
```

 

28.5 to 31.4 (thousand dollars).



(g) Compare the confidence intervals of parts
(<a href="#part:ttest">here</a>) and (<a href="#part:cim">here</a>). Specifically, compare their
centres and their lengths, and explain briefly why the results
make sense.


Solution


Let me just put them side by side for ease of comparison:
part~(<a href="#part:ttest">here</a>) is:

```r
t.test(fire$damage)
```

```
## 
## 	One Sample t-test
## 
## data:  fire$damage
## t = 12.678, df = 14, p-value =
## 4.605e-09
## alternative hypothesis: true mean is not equal to 0
## 95 percent confidence interval:
##  21.94488 30.88178
## sample estimates:
## mean of x 
##  26.41333
```

       

and part~(<a href="#part:cim">here</a>)'s is


```r
pp
```

```
##        fit      lwr      upr
## 1 29.95525 28.52604 31.38446
```

 

I printed them out like this since these give the centres of the
intervals as well as the lower and upper limits.

The centre of the interval is higher for the mean damage when the
distance is 4. This is because the mean distance is a bit less than 4:


```r
fire %>% summarize(m = mean(distance))
```

```
## # A tibble: 1 x 1
##       m
##   <dbl>
## 1  3.28
```

 

We know it's an upward trend, so our best guess at the mean damage is
higher if the mean distance is higher (in (<a href="#part:cim">here</a>), the
distance is *always* 4: we're looking at the mean fire damage for
*all* residences that are 4 miles from a fire station.)

What about the lengths of the intervals? The one in (<a href="#part:ttest">here</a>)
is about $30.9-21.9=9$ (thousand dollars) long, but the one in
(<a href="#part:cim">here</a>) is only $31.4-28.5=2.9$ long, much shorter. This
makes sense because the relationship is a strong one: knowing the
distance from the fire station is very useful, because the bigger it
is, the bigger the damage going to be, with near certainty. Said
differently, if you know the distance, you can estimate the damage
accurately.  If you don't know the distance (as is the case in
(<a href="#part:ttest">here</a>)), you're averaging over a lot of different
distances and thus there is a lot of uncertainty in the amount of fire
damage also.

If you have some reasonable discussion of the reason why the centres
and lengths of the intervals differ, I'm happy. It doesn't have to be
the same as mine.
      






These problems are about multiple regression (more than one $x$-variable):



##  Being satisfied with hospital


 A hospital administrator collects data to study the
effect, if any, of a patient's age, the severity of their
illness, and their anxiety level, on the patient's satisfaction with
their hospital experience. The data, in the file
[link](http://www.utsc.utoronto.ca/~butler/d29/satisfaction.txt), are
for 46 patients in a survey. The columns are: patient's satisfaction
score `satis`, on a scale of 0 to 100; the patient's `age` (in
years), the `severity` of the patient's illness (also on a
0--100 scale), and the patient's `anxiety` score on a standard
anxiety test (scale of 0--5). Higher scores mean greater satisfaction,
increased severity of illness and more anxiety.



(a) Read in the data and check that you have four columns in
your data frame, one for each of your variables.   
 
Solution

 This one requires a little thought
first. The data values are aligned in columns, and so are the
column headers. Thus, `read_table` is what we need:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/d29/satisfaction.txt"
satisf = read_table(my_url)
```

```
## Parsed with column specification:
## cols(
##   satis = col_integer(),
##   age = col_integer(),
##   severity = col_integer(),
##   anxiety = col_double()
## )
```

```r
satisf
```

```
## # A tibble: 46 x 4
##    satis   age severity anxiety
##    <int> <int>    <int>   <dbl>
##  1    48    50       51     2.3
##  2    57    36       46     2.3
##  3    66    40       48     2.2
##  4    70    41       44     1.8
##  5    89    28       43     1.8
##  6    36    49       54     2.9
##  7    46    42       50     2.2
##  8    54    45       48     2.4
##  9    26    52       62     2.9
## 10    77    29       50     2.1
## # ... with 36 more rows
```

     

46 rows and 4 columns: satisfaction score (response), age, severity
and anxiety (explanatory).

There is a small question about what to call the data
frame. Basically, anything other than `satis` will do, since
there will be confusion if your data frame has the same name as one of
its columns.
 

(b) <a name="part:scatmat">*</a> Obtain scatterplots of the response variable
`satis` against each of the other variables.
 
Solution


The obvious way is to do these one after the other:

```r
ggplot(satisf, aes(x = age, y = satis)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-166-1} 

```r
ggplot(satisf, aes(x = severity, y = satis)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-166-2} 

```r
ggplot(satisf, aes(x = anxiety, y = satis)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-166-3} 

       

This is fine, but there is also a way of getting all three plots with
*one* `ggplot`. This uses the `facet_wrap` trick,
but to set *that* up, we have to have all the $x$-variables in
*one* column, with an extra column labelling which $x$-variable
that value was. This uses `gather`. The right way to do this is
in a pipeline:


```r
satisf %>% gather(xname, x, age:anxiety) %>% ggplot(aes(x = x, 
    y = satis)) + geom_point() + facet_wrap(~xname, 
    scales = "free", ncol = 2)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-167-1} 

 

Steps: gather together the columns age through anxiety into one column
called `x`, with a label in `xname`, then plot this new
`x` against satisfaction score, with a separate facet for each
different $x$ (in `xname`). 

I showed you `facet_grid` in class. What's the difference
between that and `facet_wrap`? The difference is that with
`facet_wrap`, we are letting `ggplot` arrange the
facets how it wants to. In this case, we didn't care which explanatory
variable went on which facet, just as long as we saw all of them
somewhere. Inside `facet_wrap` there are *no dots*: a
squiggle, followed by the name(s) of the variable(s) that
distinguish(es) the facets.
\marginnote{If there are more than one, they  should be separated by plus signs as in lm. Each facet then  has as many labels as variables. I haven't actually done this  myself, but from looking at examples, I think this is the way it  works.} 
The only "design" decision I made here was that the facets
should be arranged somehow in two columns, but I didn't care which
ones should be where.

In `facet_grid`, you have a variable that you want to be
displayed in rows or in columns (not just in "different facets"). 
I'll show you how that works here. Since I am going to draw
two plots, I should save the long data frame first and re-use it,
rather than calculating it twice (so that I ought now to go back and
do the other one using the saved data frame, really):


```r
satisf.long = satisf %>% gather(xname, x, age:anxiety)
```

 

If, at this or any stage, you get confused, the way to un-confuse
yourself is to *fire up R Studio and do this yourself*. You have
all the data and code you need. If you do it yourself, you can run
pipes one line at a time, inspect things, and so on.

First, making a *row* of plots, so that `xname` is the $x$
of the facets:


```r
ggplot(satisf.long, aes(x = x, y = satis)) + geom_point() + 
    facet_grid(. ~ xname, scales = "free")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-169-1} 

 

I find these too tall and skinny to see the trends, as on the first
`facet_wrap` plot.

And now, making a *column* of plots, with `xname` as $y$:


```r
ggplot(satisf.long, aes(x = x, y = satis)) + geom_point() + 
    facet_grid(xname ~ ., scales = "free")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-170-1} 

 

This one looks weird because the three $x$-variables are on different
scales. The effect of the `scales="free"` is to allow the
`satis` scale to vary, but the `x` scale cannot because
the facets are all in a line. Compare this:


```r
ggplot(satisf.long, aes(x = x, y = satis)) + geom_point() + 
    facet_wrap(~xname, ncol = 1, scales = "free")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-171-1} 

 

This time, the $x$ scales came out different (and suitable), but I
still like squarer plots better for judging relationships.
 

(c) In your scatterplots of (<a href="#part:scatmat">here</a>), which
relationship appears to be the strongest one?
 
Solution


All the trends appear to be downward ones, but
I think `satis` and `age` is the strongest
trend. The other ones look more scattered to me. 
 

(d) <a name="part:corrmat">*</a> Create a correlation matrix for all four 
variables. Does your strongest trend of the previous part have the
strongest correlation?
 
Solution


This is a matter of running the whole data frame through `cor`:

```r
cor(satisf)
```

```
##               satis        age   severity
## satis     1.0000000 -0.7867555 -0.6029417
## age      -0.7867555  1.0000000  0.5679505
## severity -0.6029417  0.5679505  1.0000000
## anxiety  -0.6445910  0.5696775  0.6705287
##             anxiety
## satis    -0.6445910
## age       0.5696775
## severity  0.6705287
## anxiety   1.0000000
```

     

Ignoring the correlations of variables with themselves, the
correlation of `satisf` with `age`, the one I picked
out, is the strongest (the most negative trend). If you picked one of
the other trends as the strongest, you need to note how close it is to
the maximum correlation: for example, if you picked `satis`
and `severity`, that's the second highest correlation (in
size).
 

(e) Run a regression predicting satisfaction from the other
three variables, and display the output.
 
Solution



```r
satisf.1 = lm(satis ~ age + severity + anxiety, 
    data = satisf)
summary(satisf.1)
```

```
## 
## Call:
## lm(formula = satis ~ age + severity + anxiety, data = satisf)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -18.3524  -6.4230   0.5196   8.3715  17.1601 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 158.4913    18.1259   8.744
## age          -1.1416     0.2148  -5.315
## severity     -0.4420     0.4920  -0.898
## anxiety     -13.4702     7.0997  -1.897
##             Pr(>|t|)    
## (Intercept) 5.26e-11 ***
## age         3.81e-06 ***
## severity      0.3741    
## anxiety       0.0647 .  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 10.06 on 42 degrees of freedom
## Multiple R-squared:  0.6822,	Adjusted R-squared:  0.6595 
## F-statistic: 30.05 on 3 and 42 DF,  p-value: 1.542e-10
```

     
 

(f) Does the regression fit well overall? How can you tell?
 
Solution


For this, look at R-squared, which is 0.682 (68.2\%). This is one
of those things to have an opinion about. I'd say this is good but
not great. I would not call it "poor", since there definitely
*is* a relationship, even if it's not a stupendously good one.
 

(g) Test the null hypothesis that none of your explanatory
variables help, against the alternative that one or more of them
do. (You'll need an appropriate P-value. Which one is it?) What do
you conclude?
 
Solution


This one is the (global) $F$-test, whose P-value is at the
bottom. It translates to 0.000000000154, so this is
*definitely* small, and we reject the null. Thus, one or more
of `age`, `severity` and `anxiety` helps to
predict satisfaction. (I would like to see this last sentence,
rather than just "reject the null".)
 

(h) The correlation between `severity` and
`satis` is not small, but in my regression I found that
`severity` was nowhere near significant. Why is this? Explain briefly.
\clearpage
 
Solution


The key thing to observe is that the $t$-test in the regression
says how important a variable is \emph{given the others that are
already in the regression}, or, if you prefer, how much that
variable *adds* to the regression, on top of the ones that
are already there. So here, we are saying
that `severity` has nothing to add, given that the
regression already includes the others. (That is, high correlation
and strong significance don't always go together.)
For a little more insight, look at the correlation matrix of
(<a href="#part:corrmat">here</a>) again. The strongest trend with
`satis` is with `age`, and indeed `age` is
the one obviously significant  variable in the regression. The
trend of `severity` with `satis` is somewhat
downward, and you might otherwise have guessed that this is strong
enough to be significant. But see that `severity`
*also* has a clear relationship with `age`. A patient
with low severity of disease is probably also younger, and we know
that younger patients are likely to be more satisfied. Thus
severity has nothing (much) to add.
The multiple regression is actually doing something clever
here. Just looking at the correlations, it appears that all three
variables are helpful, but the regression is saying that once you
have looked at `age` ("controlled for age"),
severity of illness does not have an impact: the correlation of
`severity` with `satis` is as big as it is almost
entirely because of `age`. 
This gets into the      domain of "partial correlation". If you like videos, you can 
see [link](https://www.youtube.com/watch?v=LF0WAVBIhNA) for
this. I prefer regression, myself, since I find it clearer.
`anxiety`
tells a different story: this is close to significant (or
*is* significant at the $\alpha=0.10$ level), so the
regression is saying that `anxiety` *does* appear to
have something to say about `satis` over and above
`age`. This is rather odd, to my mind, since
`anxiety` has only a slightly stronger correlation with
`satis` and about the same with `age` as
`severity` does. But the regression is telling the story to
believe, because it handles all the inter-correlations, not just
the ones between pairs of variables.
I thought it would be rather interesting to do some predictions
here. Let's predict satisfaction for all combinations of high and
low age, severity and anxiety. I'll use the quartiles for high and
low. There is a straightforward but ugly way:

```r
quartiles = satisf %>% summarize(age_q1 = quantile(age, 
    0.25), age_q3 = quantile(age, 0.75), severity_q1 = quantile(severity, 
    0.25), severity_q3 = quantile(severity, 0.75), 
    anxiety_q1 = quantile(anxiety, 0.25), anxiety_q3 = quantile(anxiety, 
        0.75))
```

     

This is ugly because of all the repetition (same quantiles of
different variables), and the programmer in you should be offended by
the ugliness. Anyway, it gives what we want:


```r
quartiles
```

```
## # A tibble: 1 x 6
##   age_q1 age_q3 severity_q1 severity_q3
##    <dbl>  <dbl>       <dbl>       <dbl>
## 1   31.2   44.8          48          53
## # ... with 2 more variables:
## #   anxiety_q1 <dbl>, anxiety_q3 <dbl>
```

 
You can copy the numbers from here to below, or you can do some
cleverness to get them in the right places:

```r
quartiles %>% gather(var_q, quartile, everything()) %>% 
    separate(var_q, c("var_name", "quartile_name")) %>% 
    spread(var_name, quartile)
```

```
## Warning: attributes are not identical across measure variables;
## they will be dropped
```

```
## # A tibble: 2 x 4
##   quartile_name   age anxiety severity
##   <chr>         <dbl>   <dbl>    <dbl>
## 1 q1             31.2    2.1        48
## 2 q3             44.8    2.48       53
```

 



     

This is what we want for below. Let's test it line by line to see exactly
what it did:

```r
quartiles %>% gather(var_q, quartile, everything())
```

```
## Warning: attributes are not identical across measure variables;
## they will be dropped
```

```
## # A tibble: 6 x 2
##   var_q       quartile
##   <chr>          <dbl>
## 1 age_q1         31.2 
## 2 age_q3         44.8 
## 3 severity_q1    48   
## 4 severity_q3    53   
## 5 anxiety_q1      2.1 
## 6 anxiety_q3      2.48
```

 

Making long format. `everything()` is a select-helper saying
"gather up *all* the columns". This is where the (ignorable)
warning comes from.


```r
quartiles %>% gather(var_q, quartile, everything()) %>% 
    separate(var_q, c("var_name", "quartile_name"))
```

```
## Warning: attributes are not identical across measure variables;
## they will be dropped
```

```
## # A tibble: 6 x 3
##   var_name quartile_name quartile
##   <chr>    <chr>            <dbl>
## 1 age      q1               31.2 
## 2 age      q3               44.8 
## 3 severity q1               48   
## 4 severity q3               53   
## 5 anxiety  q1                2.1 
## 6 anxiety  q3                2.48
```

 

The column `var_q` above encodes a variable *and* a
quartile, so split them up. By default, `separate` splits at an
underscore, which is why the things in `quartiles` were named
with underscores.
\marginnote{I'd like to claim that I was clever enough  to think of this in advance, but I wasn't; originally the variable  name and the quartile name were separated by dots, which made the separate more complicated, so I went back and changed it.}


```r
qq = quartiles %>% gather(var_q, quartile, everything()) %>% 
    separate(var_q, c("var_name", "quartile_name")) %>% 
    spread(var_name, quartile)
```

```
## Warning: attributes are not identical across measure variables;
## they will be dropped
```

```r
qq
```

```
## # A tibble: 2 x 4
##   quartile_name   age anxiety severity
##   <chr>         <dbl>   <dbl>    <dbl>
## 1 q1             31.2    2.1        48
## 2 q3             44.8    2.48       53
```

 
Last, I want the original variables in columns, so I un-gather to get
them there. I spread `var_name`, carrying along the values in
`quartile` (which means that the rows will get matched up by
`quartile_name`). 

Now, let's think about why we were doing that. We want to do
predictions of all possible combinations of those values of age and
anxiety and severity.
Doing "all possible combinations" calls for `crossing`,
which looks like this:


```r
satisf.new = with(qq, crossing(age, anxiety, severity))
satisf.new
```

```
## # A tibble: 8 x 3
##     age anxiety severity
##   <dbl>   <dbl>    <dbl>
## 1  31.2    2.1        48
## 2  31.2    2.1        53
## 3  31.2    2.48       48
## 4  31.2    2.48       53
## 5  44.8    2.1        48
## 6  44.8    2.1        53
## 7  44.8    2.48       48
## 8  44.8    2.48       53
```

 

There are two possibilities for each variable, so there are $2^3=8$
"all possible combinations". You can check that `crossing` got
them all.

This is a data frame containing all the values we want to predict for,
with columns having names that are the same as the variables in the
regression, so it's ready to go into `predict`. I'll do
prediction intervals, just because:


```r
pp = predict(satisf.1, satisf.new, interval = "p")
cbind(satisf.new, pp)
```

```
##     age anxiety severity      fit      lwr
## 1 31.25   2.100       48 73.31233 52.64296
## 2 31.25   2.100       53 71.10231 49.86836
## 3 31.25   2.475       48 68.26102 47.02617
## 4 31.25   2.475       53 66.05100 44.90355
## 5 44.75   2.100       48 57.90057 36.83964
## 6 44.75   2.100       53 55.69055 34.48912
## 7 44.75   2.475       48 52.84926 31.68774
## 8 44.75   2.475       53 50.63924 29.99014
##        upr
## 1 93.98170
## 2 92.33627
## 3 89.49587
## 4 87.19845
## 5 78.96151
## 6 76.89198
## 7 74.01079
## 8 71.28835
```

 

Looking at the predictions themselves (in `fit`), you can see
that `age` has a huge effect. If you compare the 1st and 5nd
lines (or the 2nd and 6th, 3rd and 7th, \ldots) you see that
increasing age by 13.5 years, while leaving the other variables the
same, decreases the satisfaction score by over 15 on
average. Changing `severity`, while leaving everything else the
same, has in comparison a tiny effect, just over 2 points. (Compare
eg. 1st and 2nd lines.) Anxiety has an in-between effect: increasing
anxiety from 2.1 to 2.475, leaving everything else fixed, decreases
satisfaction by about 5 points on average.

I chose the quartiles on purpose: to demonstrate the change in average
satisfaction by changing the explanatory variable by an appreciable
fraction of its range of values. That is, I changed `severity`
by "a fair bit", and still the effect on satisfaction scores was small.

Are any of these prediction intervals longer or shorter? We can calculate how
long they are. Look at the predictions:


```r
pp
```

```
##        fit      lwr      upr
## 1 73.31233 52.64296 93.98170
## 2 71.10231 49.86836 92.33627
## 3 68.26102 47.02617 89.49587
## 4 66.05100 44.90355 87.19845
## 5 57.90057 36.83964 78.96151
## 6 55.69055 34.48912 76.89198
## 7 52.84926 31.68774 74.01079
## 8 50.63924 29.99014 71.28835
```

 

This is unfortunately not a data frame:


```r
class(pp)
```

```
## [1] "matrix"
```

 

so we make it one before calculating the lengths.
We want `upr` minus `lwr`:


```r
pp %>% as_tibble() %>% transmute(pi.length = upr - 
    lwr)
```

```
## # A tibble: 8 x 1
##   pi.length
##       <dbl>
## 1      41.3
## 2      42.5
## 3      42.5
## 4      42.3
## 5      42.1
## 6      42.4
## 7      42.3
## 8      41.3
```

 

Now, I don't want to keep the other stuff from `pp`, so I used
`transmute` instead of `mutate`; `transmute`
keeps *only* the new variable(s) that I calculate and throws away
the others.
\marginnote{Usually you want to keep the other variables around as  well, which is why you don't see transmute very often.}

Then I put that side by side with the values being predicted for:


```r
pp %>% as_tibble() %>% transmute(pi.length = upr - 
    lwr) %>% bind_cols(satisf.new)
```

```
## # A tibble: 8 x 4
##   pi.length   age anxiety severity
##       <dbl> <dbl>   <dbl>    <dbl>
## 1      41.3  31.2    2.1        48
## 2      42.5  31.2    2.1        53
## 3      42.5  31.2    2.48       48
## 4      42.3  31.2    2.48       53
## 5      42.1  44.8    2.1        48
## 6      42.4  44.8    2.1        53
## 7      42.3  44.8    2.48       48
## 8      41.3  44.8    2.48       53
```

 

Two of these are noticeably shorter than the others: the first one and
the last one. These are low-everything and high-everything. If you
look back at the scatterplot matrix of (<a href="#part:scatmat">here</a>), you'll
see that the explanatory variables have positive correlations with
each other. This means that when one of them is low, the other ones
will tend to be low as well (and correspondingly high with high). That
is, most of the data is at or near the low-low-low end or the
high-high-high end, and so those values will be easiest to predict for.

I was actually expecting more of an effect, but what I expected is
actually there.

In the backward elimination part (coming up), I found that only
`age` and `anxiety` had a significant impact on
satisfaction, so I can plot these two explanatory variables against
each other to see where most of the values are:


```r
ggplot(satisf, aes(x = age, y = anxiety)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-187-1} 

 

There is basically *no* data with low age and high anxiety, or
with high age and low anxiety, so these combinations will be difficult
to predict satisfaction for (and thus their prediction intervals will
be longer).
 


(i) Carry out a backward elimination to determine which of
`age`, `severity` and `anxiety` are needed to
predict satisfaction. What do you get?



Solution


This means starting with the regression containing all the explanatory
variables, which is the one I called `satisf.1`:


```r
summary(satisf.1)
```

```
## 
## Call:
## lm(formula = satis ~ age + severity + anxiety, data = satisf)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -18.3524  -6.4230   0.5196   8.3715  17.1601 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 158.4913    18.1259   8.744
## age          -1.1416     0.2148  -5.315
## severity     -0.4420     0.4920  -0.898
## anxiety     -13.4702     7.0997  -1.897
##             Pr(>|t|)    
## (Intercept) 5.26e-11 ***
## age         3.81e-06 ***
## severity      0.3741    
## anxiety       0.0647 .  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 10.06 on 42 degrees of freedom
## Multiple R-squared:  0.6822,	Adjusted R-squared:  0.6595 
## F-statistic: 30.05 on 3 and 42 DF,  p-value: 1.542e-10
```

 

Pull out the least-significant (highest P-value) variable, which here
is `severity`. We already decided that this had nothing to add:


```r
satisf.2 = update(satisf.1, . ~ . - severity)
summary(satisf.2)
```

```
## 
## Call:
## lm(formula = satis ~ age + anxiety, data = satisf)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -19.4453  -7.3285   0.6733   8.5126  18.0534 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 145.9412    11.5251  12.663
## age          -1.2005     0.2041  -5.882
## anxiety     -16.7421     6.0808  -2.753
##             Pr(>|t|)    
## (Intercept) 4.21e-16 ***
## age         5.43e-07 ***
## anxiety      0.00861 ** 
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 10.04 on 43 degrees of freedom
## Multiple R-squared:  0.6761,	Adjusted R-squared:  0.661 
## F-statistic: 44.88 on 2 and 43 DF,  p-value: 2.98e-11
```

 

If you like, copy and paste the first `lm`, edit it to get rid
of `severity`, and run it again. But when I have a 
"small change" to make to a model, I like to use `update`.

Having taken `severity` out, `anxiety` has become
strongly significant. Since all of the explanatory variables are now
significant, this is where we stop. If we're predicting satisfaction,
we need to know both a patient's age and their anxiety score: being
older or more anxious is associated with a *decrease* in satisfaction.

There is also a function `step` that will do this for you:


```r
step(satisf.1, direction = "backward", test = "F")
```

```
## Start:  AIC=216.18
## satis ~ age + severity + anxiety
## 
##            Df Sum of Sq    RSS    AIC
## - severity  1     81.66 4330.5 215.06
## <none>                  4248.8 216.19
## - anxiety   1    364.16 4613.0 217.97
## - age       1   2857.55 7106.4 237.84
##            F value   Pr(>F)    
## - severity  0.8072  0.37407    
## <none>                         
## - anxiety   3.5997  0.06468 .  
## - age      28.2471 3.81e-06 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Step:  AIC=215.06
## satis ~ age + anxiety
## 
##           Df Sum of Sq    RSS    AIC F value
## <none>                 4330.5 215.06        
## - anxiety  1     763.4 5093.9 220.53  7.5804
## - age      1    3483.9 7814.4 240.21 34.5935
##              Pr(>F)    
## <none>                 
## - anxiety   0.00861 ** 
## - age     5.434e-07 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

```
## 
## Call:
## lm(formula = satis ~ age + anxiety, data = satisf)
## 
## Coefficients:
## (Intercept)          age      anxiety  
##      145.94        -1.20       -16.74
```

 

with the same result. This function doesn't actually use P-values;
instead it uses a thing called AIC. At each step, the variable with
the lowest AIC comes out, and when `<none>` bubbles up to the
top, that's when you stop. The `test="F"` means 
"include an $F$-test", but the procedure still uses AIC (it just shows you an
$F$-test each time as well).  In this case, the other variables were
in the same order throughout, but they don't have to be (in the same
way that removing one variable from a multiple regression can
dramatically change the P-values of the ones that remain). Here, at
the first step, `<none>` and `anxiety` were pretty
close, but when `severity` came out, taking out nothing was a
*lot* better than taking out `anxiety`.

The `test="F"` on the end gets you the P-values. Using the
$F$-test is right for regressions; for things like logistic regression
that we see later, `test="Chisq"` is the right one to 
use.
\marginnote{This is F in quotes, meaning F-test, not F without quotes, meaning FALSE.}







##  Handling shipments of chemicals


 The data in
[link](http://statweb.lsu.edu/EXSTWeb/StatLab/DataSets/NKNWData/CH06PR09.txt)
are on shipments of chemicals in drums that arrive at a warehouse. In
order, the variables are:


* the number of minutes required to handle the shipment

* the number of drums in the shipment

* the total weight of the shipment, in hundreds of pounds.




(a) The data set has two features: *no* column names, and
data aligned in columns (that is, more than one space between data
values). Read the data in, giving the columns suitable names. To do
this, you may have to consult an appropriate help file, or do some
searching, perhaps of one of the other questions on this assignment.


Solution


The alignment of columns means that we need to use
`read_table`. Once you've figured *that* out, you can
search for help by typing `?read_table` in the Console
window (the help will appear bottom right), or you can put the
same thing into an R Notebook code chunk, and when you run the
chunk, the help will be displayed. (Press control-shift-1 to go
back to the notebook.)
Or you can Google it, of course.
The key observation is that you need to supply some column names
in `col_names`, like this:

```r
my_url = "http://statweb.lsu.edu/EXSTWeb/StatLab/DataSets/NKNWData/CH06PR09.txt"
cols = c("minutes", "drums", "weight")
chemicals = read_table(my_url, col_names = cols)
```

```
## Parsed with column specification:
## cols(
##   minutes = col_double(),
##   drums = col_double(),
##   weight = col_double()
## )
```

```r
chemicals
```

```
## # A tibble: 20 x 3
##    minutes drums weight
##      <dbl> <dbl>  <dbl>
##  1      58     7   5.11
##  2     152    18  16.7 
##  3      41     5   3.2 
##  4      93    14   7.03
##  5     101    11  11.0 
##  6      38     5   4.04
##  7     203    23  22.1 
##  8      78     9   7.03
##  9     117    16  10.6 
## 10      44     5   4.76
## 11     121    17  11.0 
## 12     112    12   9.51
## 13      50     6   3.79
## 14      82    12   6.45
## 15      48     8   4.6 
## 16     127    15  13.9 
## 17     140    17  13.0 
## 18     155    21  15.2 
## 19      39     6   3.64
## 20      90    11   9.57
```

     

I like to define my URL and column names up front. You can define
either of them in the `read_table`, but it makes that line
longer. Up to you.

There is no `skip` here, because the data file starts right
away with the data and we want to use all the values: we are
*adding* names to what's in the data file. If you used
`skip`, you will be one observation short all the way through,
and your output will be slightly different from mine all the way
through.

Use any names you like, but they should resemble what the columns
actually represent.
    


(b) Fit a regression predicting the number of minutes required
to handle a shipment from the other two variables. Display the results.


Solution



```r
minutes.1 = lm(minutes ~ drums + weight, data = chemicals)
summary(minutes.1)
```

```
## 
## Call:
## lm(formula = minutes ~ drums + weight, data = chemicals)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -8.8353 -3.5591 -0.0533  2.4018 15.1515 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)   3.3243     3.1108   1.069
## drums         3.7681     0.6142   6.135
## weight        5.0796     0.6655   7.632
##             Pr(>|t|)    
## (Intercept)      0.3    
## drums       1.10e-05 ***
## weight      6.89e-07 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 5.618 on 17 degrees of freedom
## Multiple R-squared:  0.9869,	Adjusted R-squared:  0.9854 
## F-statistic: 641.6 on 2 and 17 DF,  p-value: < 2.2e-16
```

     
    


(c) Explain carefully but briefly what the slope coefficients
for the two explanatory variables represent. Do their signs
(positive or negative) make practical sense in the context of
handling shipments of chemicals?


Solution


The slope coefficient for `drums` is 3.77; this means that
a shipment with one extra drum (but the same total weight) would
take on average 3.77 minutes longer to handle. Likewise, the slope
coefficient for `weight` is 5.08, so a shipment that
weighs 1 hundred more pounds but has the same number of drums
will take 5.08 more minutes to handle.
Or "each additional drum, all else equal, will take 3.77 more minutes to handle", or similar wording. You have to get at two
things: a one-unit increase in the explanatory variable going with
a certain increase in the response, and *also* the "all else    equal" part. How you say it is up to you, but you need to say it.
That was two marks. The third one comes from noting that both
slope coefficients are positive, so making a shipment either
contain more drums or weigh more makes the handling time longer as
well. This makes perfect sense, since either kind of increase
would make the shipment more difficult to handle, and thus take
longer. 
I was *not* asking about P-values. There isn't really much to
say about those: they're both significant, so the handling time
depends on both the total weight and the number of drums. Removing
either from the regression would be a mistake.
    


(d) Obtain plots of residuals against fitted values, residuals
against explanatory variables, and a normal quantile plot of the residuals.


Solution


These are the standard plots from a multiple regression. The
second one requires care, but the first and last should be straightforward.
Residuals against fitted values:

```r
ggplot(minutes.1, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-193-1} 

     

The tricky part about the second one is that the $x$-values and the
residuals come from different data frames, which has to get expressed
in the `ggplot`. The obvious way is to do the two plots (one
for each explanatory variable) one at a time:


```r
ggplot(minutes.1, aes(x = chemicals$drums, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-194-1} 

 

and 


```r
ggplot(minutes.1, aes(x = chemicals$weight, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-195-1} 
$ %$

What would also work is to make a data frame first with the things to plot:


```r
dd = tibble(weight = chemicals$weight, drums = chemicals$drums, 
    res = resid(minutes.1))
```

 

and then:


```r
ggplot(dd, aes(x = weight, y = res)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-197-1} 

 

and similarly for `drums`. The `resid` with the model
name in brackets seems to be necessary.

Another way to approach this is `augment` from
`broom`. That does this:


```r
library(broom)
d = minutes.1 %>% augment(chemicals)
as_tibble(d)
```

```
## # A tibble: 20 x 10
##    minutes drums weight .fitted .se.fit
##  *   <dbl> <dbl>  <dbl>   <dbl>   <dbl>
##  1      58     7   5.11    55.7    1.70
##  2     152    18  16.7    156.     2.47
##  3      41     5   3.2     38.4    2.03
##  4      93    14   7.03    91.8    2.91
##  5     101    11  11.0    101.     2.17
##  6      38     5   4.04    42.7    2.11
##  7     203    23  22.1    202.     3.68
##  8      78     9   7.03    72.9    1.45
##  9     117    16  10.6    118.     2.06
## 10      44     5   4.76    46.3    2.28
## 11     121    17  11.0    123.     2.37
## 12     112    12   9.51    96.8    1.27
## 13      50     6   3.79    45.2    1.87
## 14      82    12   6.45    81.3    2.22
## 15      48     8   4.6     56.8    1.73
## 16     127    15  13.9    130.     2.01
## 17     140    17  13.0    134.     1.75
## 18     155    21  15.2    160.     2.70
## 19      39     6   3.64    44.4    1.88
## 20      90    11   9.57    93.4    1.51
## # ... with 5 more variables: .resid <dbl>,
## #   .hat <dbl>, .sigma <dbl>, .cooksd <dbl>,
## #   .std.resid <dbl>
```

 

and then you can use `d` as the "base" data frame from which
everything comes:


```r
ggplot(d, aes(x = drums, y = .resid)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-199-1} 

 

and


```r
ggplot(d, aes(x = weight, y = .resid)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-200-1} 

 

or you can even do that trick to put the two plots on facets:


```r
d %>% gather(xname, x, drums:weight) %>% ggplot(aes(x = x, 
    y = .resid)) + geom_point() + facet_wrap(~xname)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-201-1} 

 

Last, the normal quantile plot:


```r
ggplot(minutes.1, aes(sample = .resid)) + stat_qq() + 
    stat_qq_line()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-202-1} 

 

As a check for the grader, there should be four plots, obtained
somehow: residuals against fitted values, normal quantile plot of
residuals, residuals against `drums`, residuals against  
`weight`.



(e) Do you have any concerns, looking at the residual plots?
Explain briefly.


Solution


The (only) concern I have, looking at those four plots, is the one very
positive residual, the one around 15. Take that away, and I think
all of the plots are then acceptable. 
Alternatively, I will take something like "I have no concerns    about the form of the relationship", saying that the *kind*
of model being fitted here is OK (no evidence of non-linearity,
fanning out, that kind of stuff). It's up to you to decide whether
you think "concerns" extends to outliers, high-influence points,
etc. 
The normal quantile plot reveals that the most negative residual,
the one around $-9$, is in fact almost exactly as negative as you
would expect the most negative residual to be, so it is not an
outlier at all. The residuals are almost exactly normally
distributed, *except* for the most positive one.
I don't think you can justify fanning-in, since the evidence for
that is mostly from the single point on the right. The other
points do not really have residuals closer to zero as you move
left to right.

Do *not* be tempted to pick out everything you can think of wrong
with these plots. The grader can, and will, take away points if you
start naming things that are not concerns.

Extra: what else can I find out about that large-positive-residual
point? This is where having the "augmented" data frame is a plus:


```r
d %>% filter(.resid > 10)
```

```
## # A tibble: 1 x 10
##   minutes drums weight .fitted .se.fit .resid
##     <dbl> <dbl>  <dbl>   <dbl>   <dbl>  <dbl>
## 1     112    12   9.51    96.8    1.27   15.2
## # ... with 4 more variables: .hat <dbl>,
## #   .sigma <dbl>, .cooksd <dbl>,
## #   .std.resid <dbl>
```

 

As shown. The predicted number of minutes is 96.8, but the actual
number of minutes it took is 112. Hence the residual of 15.2. 
Can we find "similar" numbers of `drums` and
`weight` and compare the `minutes`? Try this:


```r
chemicals %>% filter(between(weight, 8, 11), between(drums, 
    10, 14))
```

```
## # A tibble: 3 x 3
##   minutes drums weight
##     <dbl> <dbl>  <dbl>
## 1     101    11  11.0 
## 2     112    12   9.51
## 3      90    11   9.57
```

 

You might not have seen `between` before, but it works the way
you'd expect.
\marginnote{weight between 8 and 11, for example,  returning TRUE or FALSE.} Two other shipments with similar numbers of drums and
total weight took around 90--100 minutes to handle, so the 112 does
look about 15 minutes too long. This was actually an average-sized shipment:


```r
library(ggrepel)
d %>% mutate(my_label = ifelse(.resid > 10, "residual +", 
    "")) %>% ggplot(aes(x = drums, y = weight, 
    colour = minutes, label = my_label)) + geom_point() + 
    geom_text_repel()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-205-1} 

 

so it's a bit of a mystery why it took so long to handle. 

I had some fun with the graph: if you set `colour` equal to a
continuous variable (as `minutes` is here), you get a
continuous colour scale, by default from dark blue (small) to light
blue (large). The number of minutes tends to get larger (lighter) as
you go up and to the right with bigger shipments. The point labelled
"residual +" is the one with the large residual; it is a
noticeably lighter blue than the points around it, meaning that it
took longer to handle than those points. I used the trick from C32 to
label "some" (here one) of the points: create a new label variable
with a `mutate` and an `ifelse`, leaving all of the
other labels blank so you don't see them.

The blue colour scheme is a little hard to judge values on. Here's
another way to do that:


```r
d %>% mutate(my_label = ifelse(.resid > 10, "residual +", 
    "")) %>% ggplot(aes(x = drums, y = weight, 
    colour = minutes, label = my_label)) + geom_point() + 
    geom_text_repel() + scale_colour_gradient(low = "red", 
    high = "blue")
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-206-1} 

 

The labelled point is a little more blue (purplish) than the more
clearly red points near it.

The other thing to see is that there is also a positive correlation
between the number of drums and the total weight, which is what you'd
expect. Unlike with some of our other examples, this wasn't strong
enough to cause problems; the separate effects of `drums` and
`weight` on `minutes` were distinguishable enough to
allow both explanatory variables to have a strongly significant effect
on `minutes`.

Post scriptum: the "drums" here are not concert-band-type drums, but
something like this:



![](Chemical-Drums-200x200.png)
  

    






##  Salaries of mathematicians


 A researcher in a scientific
foundation wanted to evaluate the relationship between annual salaries
of mathematicians and three explanatory variables:


* an index of work quality

* number of years of experience

* an index of publication success.


The data can be found at
[link](http://www.utsc.utoronto.ca/~butler/d29/mathsal.txt). Data from
only a relatively small number of mathematicians were available.



(a) Read in the data and check that you have a sensible number
of rows and the right number of columns. (What does "a sensible  number of rows" mean here?)

Solution


This is a tricky one. There are aligned columns, but *the column headers are not aligned with them*. 
Thus `read_table2` is what you need.

```r
my_url = "http://www.utsc.utoronto.ca/~butler/d29/mathsal.txt"
salaries = read_table2(my_url)
```

```
## Parsed with column specification:
## cols(
##   salary = col_double(),
##   workqual = col_double(),
##   experience = col_double(),
##   pubsucc = col_double()
## )
```

```r
salaries
```

```
## # A tibble: 24 x 4
##    salary workqual experience pubsucc
##     <dbl>    <dbl>      <dbl>   <dbl>
##  1   33.2      3.5          9     6.1
##  2   40.3      5.3         20     6.4
##  3   38.7      5.1         18     7.4
##  4   46.8      5.8         33     6.7
##  5   41.4      4.2         31     7.5
##  6   37.5      6           13     5.9
##  7   39        6.8         25     6  
##  8   40.7      5.5         30     4  
##  9   30.1      3.1          5     5.8
## 10   52.9      7.2         47     8.3
## # ... with 14 more rows
```

        

24 observations ("only a relatively small number") and 4 columns,
one for the response and one each for the explanatory variables.

Or, if you like,


```r
dim(salaries)
```

```
## [1] 24  4
```

 

for the second part: 24 rows and 4 columns again.
I note, with only 24 observations, that we don't really have enough
data to investigate the effects of three explanatory variables, but
we'll do the best we can. If the pattern, whatever it is, is clear
enough, we should be OK.
 

(b) Make scatterplots of `salary` against each of the three explanatory variables. If you can, do this with *one* `ggplot`.

Solution


The obvious way to do this is as three separate scatterplots,
and that will definitely work. But you can do it in one go if
you think about facets, and about having all the $x$-values in
one column (and the names of the $x$-variables in another
column):

```r
salaries %>% gather(xname, x, -salary) %>% ggplot(aes(x = x, 
    y = salary)) + geom_point() + facet_wrap(~xname, 
    ncol = 2, scales = "free")
```


\includegraphics{12-regression_files/figure-latex/ivybridge-1} 

       

If you don't see how that works, run it yourself, one line at a time. 

I was thinking ahead a bit while I was coding that: I wanted the three
plots to come out about square, and I wanted the plots to have their
own scales. The last thing in the `facet_wrap` does the latter,
and arranging the plots in two columns (thinking of the plots as a set
of four with one missing) gets them more or less square.

If you don't think of those, try it without, and then fix up what you
don't like.
 

(c) Comment briefly on the direction and strength of each
relationship with `salary`.

Solution


To my mind, all of the three relationships are going uphill (that's the "direction" part). `experience` is the
strongest, and `pubsucc` looks the weakest (that's the
"strength" part). If you want to say there is no relationship
with `pubsucc`, that's fine too. This is a judgement
call. 
Note that all the relationships are more or less linear (no
obvious curves here). We could also investigate the relationships
among the explanatory variables:

```r
cor(salaries)
```

```
##               salary  workqual experience
## salary     1.0000000 0.6670958  0.8585582
## workqual   0.6670958 1.0000000  0.4669511
## experience 0.8585582 0.4669511  1.0000000
## pubsucc    0.5581960 0.3227612  0.2537530
##              pubsucc
## salary     0.5581960
## workqual   0.3227612
## experience 0.2537530
## pubsucc    1.0000000
```

       
Mentally cut off the first row and column (`salary` is the
response). None of the remaining correlations are all that high, so we
ought not to have any multicollinearity problems.
 

(d) <a name="regone">*</a> Fit a regression predicting salary from the other three
variables, and obtain a `summary` of the results.

Solution



```r
salaries.1 = lm(salary ~ workqual + experience + 
    pubsucc, data = salaries)
summary(salaries.1)
```

```
## 
## Call:
## lm(formula = salary ~ workqual + experience + pubsucc, data = salaries)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -3.2463 -0.9593  0.0377  1.1995  3.3089 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 17.84693    2.00188   8.915
## workqual     1.10313    0.32957   3.347
## experience   0.32152    0.03711   8.664
## pubsucc      1.28894    0.29848   4.318
##             Pr(>|t|)    
## (Intercept) 2.10e-08 ***
## workqual    0.003209 ** 
## experience  3.33e-08 ***
## pubsucc     0.000334 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 1.753 on 20 degrees of freedom
## Multiple R-squared:  0.9109,	Adjusted R-squared:  0.8975 
## F-statistic: 68.12 on 3 and 20 DF,  p-value: 1.124e-10
```

   
 

(e) How can we justify the statement 
"one or more of the explanatory variables helps to predict salary"? How is this
consistent with the value of R-squared?

Solution


"One or more of the explanatory variables helps" is an
invitation to consider the (global) $F$-test for the whole
regression. This has the very small P-value of $1.124\times
10^{-10}$ (from the bottom line of the output): very small, so
one or more of the explanatory variables *does* help, and
the statement is correct.
The idea that something helps to predict salary suggests
(especially with such a small number of observations) that we
should have a high R-squared. In this case, R-squared is 0.9109,
which is indeed high.
 

(f) Would you consider removing any of the variables from this
regression? Why, or why not?

Solution


Look at the P-values attached to each variable. These are all
very small: 0.003, 0.00000003 and 0.0003, way smaller than
0.05. So it would be a mistake to 
take any, even one, of the variables out: doing so would make the
regression much worse.
If you need convincing of that, see what happens when we take
the variable with the highest P-value out --- this is `workqual`:

```r
salaries.2 = lm(salary ~ experience + pubsucc, 
    data = salaries)
summary(salaries.2)
```

```
## 
## Call:
## lm(formula = salary ~ experience + pubsucc, data = salaries)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -5.2723 -0.7865 -0.3983  1.7277  3.2060 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept) 21.02546    2.14819   9.788
## experience   0.37376    0.04104   9.107
## pubsucc      1.52753    0.35331   4.324
##             Pr(>|t|)    
## (Intercept) 2.82e-09 ***
## experience  9.70e-09 ***
## pubsucc        3e-04 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 2.137 on 21 degrees of freedom
## Multiple R-squared:  0.8609,	Adjusted R-squared:  0.8477 
## F-statistic:    65 on 2 and 21 DF,  p-value: 1.01e-09
```

       

R-squared has gone down from 91\% to 86\%: maybe not so much in the
grand scheme of things, but it is noticeably less. Perhaps better,
since we are comparing models with different numbers of explanatory
variables, is to compare the *adjusted* R-squared: this has gone
down from 90\% to 85\%. The fact that this has gone down *at all*
is enough to say that taking out `workqual` was a
mistake.
\marginnote{Adjusted R-squareds are easier to compare in this  context, since you don't have to make a judgement about whether it has changed substantially, whatever you think substantially means.}

Another way of seeing whether a variable has anything to add in a
regression containing the others is a **partial regression  plot**. 
We take the residuals from `salaries.2` above and plot
them against the variable we removed, namely
`workqual`.
\marginnote{The residuals have to be the ones from a  regression *not* including the $x$-variable you're testing.} If
`workqual` has nothing to add, there will be no pattern; if it
*does* have something to add, there will be a trend. Like
this. I use `augment` from `broom`:


```r
library(broom)
salaries.2 %>% augment(salaries) %>% ggplot(aes(x = workqual, 
    y = .resid)) + geom_point()
```


\includegraphics{12-regression_files/figure-latex/dartington-1} 

 

This is a mostly straight upward trend. So we
need to add a linear term in `workqual` to the
regression.
\marginnote{Or not take it out in the first place.}
 

(g) Do you think it would be a mistake to take *both* of
`workqual` and `pubsucc` out of the regression? Do a
suitable test. Was your guess right?

Solution


I think it would be a big mistake. Taking even one of these
variables out of the regression is a bad idea (from the
$t$-tests), so taking out more than one would be a *really* bad idea.
To perform a test, fit the model without these two explanatory variables:

```r
salaries.3 = lm(salary ~ experience, data = salaries)
```

     

and then use `anova` to compare the two regressions, smaller
model first:


```r
anova(salaries.3, salaries.1)
```

```
## Analysis of Variance Table
## 
## Model 1: salary ~ experience
## Model 2: salary ~ workqual + experience + pubsucc
##   Res.Df     RSS Df Sum of Sq      F
## 1     22 181.191                    
## 2     20  61.443  2    119.75 19.489
##      Pr(>F)    
## 1              
## 2 2.011e-05 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

The P-value is extremely small, so the bigger model is definitely
better than the smaller one: we really do need all three
variables. Which is what we guessed.


(h) Back in part (<a href="#regone">here</a>), you fitted a regression with all
three explanatory variables. By making suitable plots, assess
whether there is any evidence that (i) that the linear model should
be a curve, (ii) that the residuals are not normally 
distributed, (iii) that there is "fan-out", where the residuals are getting
bigger *in size* as the fitted values get bigger? Explain
briefly how you came to your conclusions in each case.

Solution


I intended that (i) should just be a matter of looking at residuals
vs.\ fitted values:

```r
ggplot(salaries.1, aes(x = .fitted, y = .resid)) + 
    geom_point()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-214-1} 

    

There is no appreciable pattern on here, so no evidence of a curve (or
apparently of any other problems).

Extra: you might read this that we should check residuals against the
$x$-variables as well, which is a similar trick to the above one for
plotting response against each of the explanatories. There is one step
first, though: use `augment` from `broom` first to get a
dataframe with the original $x$-variables *and* the residuals in
it. The following thus looks rather complicated, and if it confuses
you, run the code a piece at a time to see what it's doing:


```r
salaries.1 %>% augment(salaries) %>% gather(xname, 
    x, workqual:pubsucc) %>% ggplot(aes(x = x, 
    y = .resid)) + geom_point() + facet_wrap(~xname, 
    scales = "free", ncol = 2)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-215-1} 

 

These three residual plots are also pretty much textbook random, so no problems here either.

For (ii), look at a normal quantile plot of the residuals, which is not as difficult as the plot I just did:


```r
ggplot(salaries.1, aes(sample = .resid)) + stat_qq() + 
    stat_qq_line()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-216-1} 

 

That is really pretty good. Maybe the *second* smallest point is
a bit far off the line, but otherwise there's nothing to worry about. A
quick place to look for problems is the extreme observations, and the
largest and smallest residuals are almost exactly the size we'd expect
them to be.

Our graph for assessing fan-in or fan-out is to plot the *absolute* values of the residuals against the fitted values. The plot from (i) suggests that we won't have any problems here, but to investigate:


```r
ggplot(salaries.1, aes(x = .fitted, y = abs(.resid))) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-217-1} 

 

This is pretty nearly straight across. You might think it increases a
bit at the beginning, but most of the evidence for that comes from the
one observation with fitted value near 30 that happens to have a
residual near zero. Conclusions based on one observation are not to be
trusted!
In summary, I'm happy with this linear multiple regression, and I
don't see any need to do anything more with it. I am, however, willing
to have some sympathy with opinions that differ from mine, if they are
supported by those graphs above.
 





##  Predicting GPA of computer science students


 The file
[link](http://www.utsc.utoronto.ca/~butler/d29/gpa.txt) contains some
measurements of academic achievement for a number of university
students studying computer science:



* High school grade point average

* Math SAT score

* Verbal SAT score

* Computer Science grade point average

* Overall university grade point average.




(a) Read in the data and display it (or at least the first ten lines).


Solution


The usual:


```r
my_url = "http://www.utsc.utoronto.ca/~butler/d29/gpa.txt"
gpa = read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   high_GPA = col_double(),
##   math_SAT = col_integer(),
##   verb_SAT = col_integer(),
##   comp_GPA = col_double(),
##   univ_GPA = col_double()
## )
```

```r
gpa
```

```
## # A tibble: 105 x 5
##    high_GPA math_SAT verb_SAT comp_GPA
##       <dbl>    <int>    <int>    <dbl>
##  1     3.45      643      589     3.76
##  2     2.78      558      512     2.87
##  3     2.52      583      503     2.54
##  4     3.67      685      602     3.83
##  5     3.24      592      538     3.29
##  6     2.1       562      486     2.64
##  7     2.82      573      548     2.86
##  8     2.36      559      536     2.03
##  9     2.42      552      583     2.81
## 10     3.51      617      591     3.41
## # ... with 95 more rows, and 1 more
## #   variable: univ_GPA <dbl>
```

 

Two SAT scores and three GPAs, as promised.



(b) <a name="part:hsu-scatter">*</a> Make a scatterplot of high school GPA against university
GPA. Which variable should be the response and which
explanatory? Explain briefly. Add a smooth trend to your plot.


Solution


High school comes before university, so high school should be
explanatory and university should be the response. (High school
grades are used as an admission criterion to university, so we
would hope they would have some predictive value.)

```r
ggplot(gpa, aes(x = high_GPA, y = univ_GPA)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-219-1} 

   
    


(c) Describe any relationship on your scatterplot: its direction, its
strength and its shape. Justify your description briefly.


Solution


Taking these points one at a time:


* direction: upward (a higher high-school GPA generally goes
with a higher university GPA as well. Or you can say that the
lowest high-school GPAs go with the lowest university GPAs,
and high with high, at least most of the time).

* strength: something like moderately strong, since while
the trend is upward, there is quite a lot of scatter. (This is
a judgement call: something that indicates that you are basing
your description on something reasonable is fine.)

* shape: I'd call this "approximately linear" since there
is no clear curve here. The smooth trend wiggles a bit, but
not enough to make me doubt a straight line.

Looking ahead, I also notice that when high-school GPA is high,
university GPA is also consistently high, but when high-school
GPA is low, the university GPA is sometimes low and sometimes
high, a lot more variable. (This suggests problems with fan-in
later.) In a practical sense, what this seems to show is that
people who do well at university usually did well in high-school
as well, but sometimes their high-school grades were not
that good. This is especially true for people with university
GPAs around 3.25.
      


(d) <a name="part:highonly">*</a> Fit a linear regression for predicting university GPA
from high-school GPA and display the results.


Solution


Just this, therefore:

```r
gpa.1 = lm(univ_GPA ~ high_GPA, data = gpa)
summary(gpa.1)
```

```
## 
## Call:
## lm(formula = univ_GPA ~ high_GPA, data = gpa)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.69040 -0.11922  0.03274  0.17397  0.91278 
## 
## Coefficients:
##             Estimate Std. Error t value
## (Intercept)  1.09682    0.16663   6.583
## high_GPA     0.67483    0.05342  12.632
##             Pr(>|t|)    
## (Intercept) 1.98e-09 ***
## high_GPA     < 2e-16 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.2814 on 103 degrees of freedom
## Multiple R-squared:  0.6077,	Adjusted R-squared:  0.6039 
## F-statistic: 159.6 on 1 and 103 DF,  p-value: < 2.2e-16
```

    

Extra: this question goes on too long, so I didn't ask you to look at the
residuals from this model, but my comments earlier suggested that we
might have had some problems with fanning-in (the variability of
predictions getting less as the high-school GPA increases). In case
you are interested, I'll look at this here. First, residuals against
fitted values:


```r
ggplot(gpa.1, aes(x = .fitted, y = .resid)) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-221-1} 

 

Is that evidence of a trend in the residuals? Dunno. I'm inclined to
call this an "inconsequential wiggle" and say it's OK. Note that the
grey envelope includes zero all the way across.

Normal quantile plot of residuals:


```r
ggplot(gpa.1, aes(sample = .resid)) + stat_qq() + 
    stat_qq_line()
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-222-1} 

 

A somewhat long-tailed distribution: compared to a normal
distribution, the residuals are a bit too big in size, both on the
positive and negative end.

The problem I was really worried about was the potential of
fanning-in, which we can assess by looking at the absolute residuals:


```r
ggplot(gpa.1, aes(x = .fitted, y = abs(.resid))) + 
    geom_point() + geom_smooth()
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-223-1} 

 

That is definitely a downward trend in the size of the residuals, and
I think I was right to be worried before. The residuals should be of
similar size all the way across.

The usual problem of this kind is fanning-*out*, where the
residuals get *bigger* in size as the fitted values increase. The
bigger values equals more spread is the kind of thing that a
transformation like taking logs will handle: the bigger values are all
brought downwards, so they will be both smaller and less variable than
they were. This one, though, goes the other way, so the only kind of
transformation that might help is one at the other end of the scale
(think of the Box-Cox lambda scale), something like maybe reciprocal,
$\lambda=-1$ maybe.

The other thought I had was that there is this kind of break around a
high-school GPA of 3 (go back to the scatterplot of (<a href="#part:hsu-scatter">here</a>)): when the
high-school GPA is higher than 3, the university GPA is very
consistent (and shows a clear upward trend), but when the high-school
GPA is less than 3, the university GPA is very variable and there
doesn't seem to be any trend at all. So maybe two separate analyses
would be the way to go.

All right, how does Box-Cox work out here, if at all?


```r
library(MASS)
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
boxcox(univ_GPA ~ high_GPA, data = gpa)
```


\includegraphics{12-regression_files/figure-latex/unnamed-chunk-224-1} 

 

It doesn't. All right, that answers *that* question. 

When I loaded `MASS`, I also loaded its `select`
function,
\marginnote{That is what that masked message above was  about.} and I might want to use the 
`tidyverse` `select`
function later, and things could get confused. So let's "unload"
`MASS` now:


```r
detach("package:MASS", unload = T)
```

 
        


(e) Two students have been admitted to university. One has
a high school GPA of 3.0 and the other a high school GPA of   
3.5. Obtain suitable intervals that summarize the GPAs that each of these
two students might obtain in university.


Solution


Since we are talking about individual students, rather than
the  mean of *all* students with these GPAs, prediction
intervals are called for. The first step is to make a data
frame to predict from. This has to contain columns for all the
explanatory variables, just `high_GPA` in this case:

```r
gpa.new = tibble(high_GPA = c(3, 3.5))
gpa.new
```

```
## # A tibble: 2 x 1
##   high_GPA
##      <dbl>
## 1      3  
## 2      3.5
```

      

and then feed that into `predict`:


```r
preds = predict(gpa.1, gpa.new, interval = "p")
preds
```

```
##        fit      lwr      upr
## 1 3.121313 2.560424 3.682202
## 2 3.458728 2.896105 4.021351
```

 

and display that side by side with the values it was predicted from:


```r
cbind(gpa.new, preds)
```

```
##   high_GPA      fit      lwr      upr
## 1      3.0 3.121313 2.560424 3.682202
## 2      3.5 3.458728 2.896105 4.021351
```

 

or this way, if you like it better:


```r
as_tibble(preds) %>% bind_cols(gpa.new) %>% select(high_GPA, 
    everything())
```

```
## # A tibble: 2 x 4
##   high_GPA   fit   lwr   upr
##      <dbl> <dbl> <dbl> <dbl>
## 1      3    3.12  2.56  3.68
## 2      3.5  3.46  2.90  4.02
```

 

Thus the predicted university GPA for the student with high school GPA
3.0 is between 2.6 and 3.7, and for the student with high school GPA
3.5 is between 2.9 and 4.0. (I think this is a good number of decimals
to give, but in any case, you should actually *say* what the
intervals are.)

I observe that these intervals are almost exactly the same
length. This surprises me a bit, since I would have said that 3.0 is
close to the average high-school GPA and 3.5 is noticeably higher. If
that's the case, the prediction interval for 3.5 should be longer
(since there is less "nearby data"). Was I right about that?


```r
gpa %>% summarize(mean = mean(high_GPA), med = median(high_GPA), 
    q1 = quantile(high_GPA, 0.25), q3 = quantile(high_GPA, 
        0.75))
```

```
## # A tibble: 1 x 4
##    mean   med    q1    q3
##   <dbl> <dbl> <dbl> <dbl>
## 1  3.08  3.17  2.67  3.48
```

 

More or less: the mean is close to 3, and 3.5 is close to the third
quartile. So the thing about the length of the prediction interval is
a bit of a mystery. Maybe it works better for the confidence interval
for the mean:


```r
preds = predict(gpa.1, gpa.new, interval = "c")
cbind(gpa.new, preds)
```

```
##   high_GPA      fit      lwr      upr
## 1      3.0 3.121313 3.066243 3.176383
## 2      3.5 3.458728 3.388147 3.529309
```

 

These intervals are a lot shorter, since we are talking about
*all* students with the high-school GPAs in question, and we
therefore no longer have to worry about variation from student to
student (which is considerable). But my supposition about length is
now correct: the interval for 3.5, which is further from the mean, is
a little longer than the interval for 3.0. Thinking about it, it seems
that the individual-to-individual variation, which is large, is
dominating things for our prediction interval above.
        


(f) <a name="part:all">*</a> Now obtain a regression predicting university GPA from
high-school GPA as well as the two SAT scores. Display your results.


Solution


Create a new regression with all the explanatory variables you want in it:


```r
gpa.2 = lm(univ_GPA ~ high_GPA + math_SAT + verb_SAT, 
    data = gpa)
summary(gpa.2)
```

```
## 
## Call:
## lm(formula = univ_GPA ~ high_GPA + math_SAT + verb_SAT, data = gpa)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.68186 -0.13189  0.01289  0.16186  0.93994 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) 0.5793478  0.3422627   1.693
## high_GPA    0.5454213  0.0850265   6.415
## math_SAT    0.0004893  0.0010215   0.479
## verb_SAT    0.0010202  0.0008123   1.256
##             Pr(>|t|)    
## (Intercept)   0.0936 .  
## high_GPA     4.6e-09 ***
## math_SAT      0.6330    
## verb_SAT      0.2120    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.2784 on 101 degrees of freedom
## Multiple R-squared:  0.6236,	Adjusted R-squared:  0.6124 
## F-statistic: 55.77 on 3 and 101 DF,  p-value: < 2.2e-16
```

 
        


(g) Test whether adding the two SAT scores has improved the
prediction of university GPA. What do you conclude?



Solution


Since we added *two* explanatory variables, the $t$-tests in
`gpa.2` don't apply (they tell us whether we can take out
*one* $x$-variable). We might have some suspicions, but that's
all they are.  So we have to do `anova`:

```r
anova(gpa.1, gpa.2)
```

```
## Analysis of Variance Table
## 
## Model 1: univ_GPA ~ high_GPA
## Model 2: univ_GPA ~ high_GPA + math_SAT + verb_SAT
##   Res.Df    RSS Df Sum of Sq      F Pr(>F)
## 1    103 8.1587                           
## 2    101 7.8288  2   0.32988 2.1279 0.1244
```

   

If you put the models the other way around, you'll get a negative
$F$-statistic and degrees of freedom, which doesn't make
much sense (although the test will still work).

The null hypothesis here is that the two models fit equally
well. Since the P-value is not small, we do not reject that null
hypothesis, and therefore we conclude that the two models *do*
fit equally well, and therefore we prefer the smaller one, the one
that predicts university GPA from just high-school GPA. (Or,
equivalently, we conclude that those two SAT scores don't add anything
to the prediction of how well a student will do at university, once
you know their high-school GPA.)

This might surprise you, given what the SATs are supposed to be
*for*. But that's what the data say.
  


(h) Carry out a backward elimination starting out from your
model in part (<a href="#part:all">here</a>). Which model do you end up with?
Is it the same model as you fit in (<a href="#part:highonly">here</a>)?


Solution


In the model of (<a href="#part:all">here</a>), `math_SAT` was the
least significant, so that comes out first. (I use
`update` but I'm not insisting that you do:)

```r
gpa.3 = update(gpa.2, . ~ . - math_SAT)
summary(gpa.3)
```

```
## 
## Call:
## lm(formula = univ_GPA ~ high_GPA + verb_SAT, data = gpa)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.68430 -0.11268  0.01802  0.14901  0.95239 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) 0.6838723  0.2626724   2.604
## high_GPA    0.5628331  0.0765729   7.350
## verb_SAT    0.0012654  0.0006283   2.014
##             Pr(>|t|)    
## (Intercept)   0.0106 *  
## high_GPA    5.07e-11 ***
## verb_SAT      0.0466 *  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.2774 on 102 degrees of freedom
## Multiple R-squared:  0.6227,	Adjusted R-squared:  0.6153 
## F-statistic: 84.18 on 2 and 102 DF,  p-value: < 2.2e-16
```

 
Here is where we have to stop, since both high-school GPA and
verbal SAT score are significant, and so taking either of them
out would be a bad idea. 
This is a *different* model than the one of
(<a href="#part:highonly">here</a>). This is the case, even though the model
with high-school GPA only was not significantly worse than the
model containing everything. (This goes to show that
model-building doesn't always have nice clear answers.)
In the model I called `gpa.2`, neither of the SAT
scores were anywhere near significant (considered singly), but
as soon as we took out one of the SAT scores (my model
`gpa.3`), the other one became significant. This goes
to show that you shouldn't take out more than one explanatory
variable based on the results of the $t$-tests, and even if
you test to see whether you should have taken out both of the SAT,
you won't necessarily get consistent
results. Admittedly, it's a close decision whether to
keep or remove `verb_SAT`, since its P-value is
close to 0.05.
The other way of tackling this one is via `step`, which
does the backward elimination for you (not that it was much
work here):

```r
step(gpa.2, direction = "backward", test = "F")
```

```
## Start:  AIC=-264.6
## univ_GPA ~ high_GPA + math_SAT + verb_SAT
## 
##            Df Sum of Sq     RSS     AIC
## - math_SAT  1    0.0178  7.8466 -266.36
## - verb_SAT  1    0.1223  7.9511 -264.97
## <none>                   7.8288 -264.60
## - high_GPA  1    3.1896 11.0184 -230.71
##            F value    Pr(>F)    
## - math_SAT  0.2294     0.633    
## - verb_SAT  1.5777     0.212    
## <none>                          
## - high_GPA 41.1486 4.601e-09 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Step:  AIC=-266.36
## univ_GPA ~ high_GPA + verb_SAT
## 
##            Df Sum of Sq     RSS     AIC
## <none>                   7.8466 -266.36
## - verb_SAT  1    0.3121  8.1587 -264.26
## - high_GPA  1    4.1562 12.0028 -223.73
##            F value    Pr(>F)    
## <none>                          
## - verb_SAT  4.0571   0.04662 *  
## - high_GPA 54.0268 5.067e-11 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

```
## 
## Call:
## lm(formula = univ_GPA ~ high_GPA + verb_SAT, data = gpa)
## 
## Coefficients:
## (Intercept)     high_GPA     verb_SAT  
##    0.683872     0.562833     0.001265
```

         

This gives the same result as we did from our backward
elimination. The tables with AIC in them are each step of
the elimination, and the variable at the top is the one that comes out
next. (When `<none>` gets to the top, that's when you stop.)
What happened is that the two SAT scores started off highest, but once
we removed `math_SAT`, `verb_SAT` jumped below
`<none>` and so the verbal SAT score had to stay.

Both the P-value and the AIC say that the decision about keeping or
removing `verb_SAT` is very close.
        


(i) These students were studying computer science at
university. Do you find your backward-elimination result
sensible or surprising, given this? Explain briefly.


Solution


I would expect computer science students to be strong students
generally, good at math and possibly not so good with
words. So it is not surprising that high-school GPA figures
into the prediction, but I would expect math SAT score to have
an impact also, and it does not. It is also rather surprising
that verbal SAT score predicts success at university for these
computer science students; you wouldn't think that having
better skills with words would be helpful. So I'm surprised.
Here, I'm looking for some kind of discussion about what's in
the final backward-elimination model, and what you would
expect to be true of computer science students. 
Let's look at the final model from the backward elimination again:

```r
summary(gpa.3)
```

```
## 
## Call:
## lm(formula = univ_GPA ~ high_GPA + verb_SAT, data = gpa)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.68430 -0.11268  0.01802  0.14901  0.95239 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) 0.6838723  0.2626724   2.604
## high_GPA    0.5628331  0.0765729   7.350
## verb_SAT    0.0012654  0.0006283   2.014
##             Pr(>|t|)    
## (Intercept)   0.0106 *  
## high_GPA    5.07e-11 ***
## verb_SAT      0.0466 *  
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.2774 on 102 degrees of freedom
## Multiple R-squared:  0.6227,	Adjusted R-squared:  0.6153 
## F-statistic: 84.18 on 2 and 102 DF,  p-value: < 2.2e-16
```

         

The two slope estimates are both positive, meaning that, all else
equal, a higher value for each explanatory variable goes with a higher
university GPA. This indicates that a higher verbal SAT score goes
with a higher university GPA: this is across all the university
courses that a student takes, which you would expect to be math and
computer science courses for a Comp Sci student, but might include
a few electives or writing courses. Maybe what is happening is that
the math SAT score is telling the same story as the high-school GPA
for these students, and the verbal SAT score is saying something
different. (For example, prospective computer science students are
mostly likely to have high math SAT scores, so there's not much
information there.)

I think I need to look at the correlations:


```r
cor(gpa)
```

```
##           high_GPA  math_SAT  verb_SAT
## high_GPA 1.0000000 0.7681423 0.7261478
## math_SAT 0.7681423 1.0000000 0.8352272
## verb_SAT 0.7261478 0.8352272 1.0000000
## comp_GPA 0.7914721 0.6877209 0.6387512
## univ_GPA 0.7795631 0.6627837 0.6503012
##           comp_GPA  univ_GPA
## high_GPA 0.7914721 0.7795631
## math_SAT 0.6877209 0.6627837
## verb_SAT 0.6387512 0.6503012
## comp_GPA 1.0000000 0.9390459
## univ_GPA 0.9390459 1.0000000
```

 

We'll ignore `comp_GPA` (i) because we haven't been thinking
about it and (ii) because it's highly correlated with the university
GPA anyway. (There isn't a sense that one of the two university GPAs
is explanatory and the other is a response, since students are taking
the courses that contribute to them at the same time.)

The highest correlation with university GPA of what remains is
high-school GPA, so it's not at all surprising that this features in
all our regressions. The correlations between university GPA and the
two SAT scores are about equal, so there appears to be no reason to
favour one of the SAT scores over the other. But, the two SAT scores
are highly correlated with *each other* (0.835), which suggests
that if you have one, you don't need the other, because they are
telling more or less the same story. 

That makes me wonder how a regression with the SAT math score and
*not* the SAT verbal score would look:


```r
gpa.4 = lm(univ_GPA ~ high_GPA + math_SAT, data = gpa)
summary(gpa.4)
```

```
## 
## Call:
## lm(formula = univ_GPA ~ high_GPA + math_SAT, data = gpa)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.68079 -0.12264  0.00741  0.16579  0.90010 
## 
## Coefficients:
##              Estimate Std. Error t value
## (Intercept) 0.6072916  0.3425047   1.773
## high_GPA    0.5710745  0.0827705   6.899
## math_SAT    0.0012980  0.0007954   1.632
##             Pr(>|t|)    
## (Intercept)   0.0792 .  
## high_GPA     4.5e-10 ***
## math_SAT      0.1058    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
## 
## Residual standard error: 0.2792 on 102 degrees of freedom
## Multiple R-squared:  0.6177,	Adjusted R-squared:  0.6102 
## F-statistic:  82.4 on 2 and 102 DF,  p-value: < 2.2e-16
```

 

Math SAT does not quite significantly add anything to the prediction,
which confirms that we do better to use the verbal SAT score
(surprising though it seems). Though, the two regressions with the
single SAT scores, `gpa.3` and `gpa.4`, have almost the
same R-squared values. It's not clear-cut at all. In the end, you have
to make a call and stand by it.
        




