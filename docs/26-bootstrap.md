# The Bootstrap

Packages for this chapter:


```r
library(tidyverse)
library(bootstrap)
```





##  Air conditioning failures


 Back in 1963, there was a report on failures in
air-conditioning equipment in
\href{https://en.wikipedia.org/wiki/Boeing_720}{Boeing 720}
aircraft. For one aircraft, the air-conditioning equipment failed 12
times, and the number of hours it ran before failing each time was
recorded. The data are in
[link](https://raw.githubusercontent.com/nxskok/pasias/master/air_conditioning.csv). Boeing
was interested in the mean failure time, because the company wanted to
plan for engineers to fix the failures (and thus needed to estimate a
failure *rate*).

There is randomization here. Your answers will differ slightly from
mine, unless you throw in this before you start (or at least before
you generate your first random numbers).


```r
set.seed(457299)
```

 



(a) Read in the data, and observe that you have the correct number
of rows. (Note that the failure times are in ascending order).

Solution


This is a `.csv` so `read_csv` is the thing:

```r
my_url <- "https://raw.githubusercontent.com/nxskok/pasias/master/air_conditioning.csv"
aircon <- read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   failure = col_double(),
##   hours = col_double()
## )
```

```r
aircon
```

```
## # A tibble: 12 x 2
##    failure hours
##      <dbl> <dbl>
##  1       1     3
##  2       2     5
##  3       3     7
##  4       4    18
##  5       5    43
##  6       6    85
##  7       7    91
##  8       8    98
##  9       9   100
## 10      10   130
## 11      11   230
## 12      12   487
```

     

Twelve rows (12 failure times).


(b) What do you notice about the *shape* of the distribution of failure times? Explain briefly.

Solution


Make a suitable graph. The obvious one is a histogram:


```r
ggplot(aircon, aes(x = hours)) + geom_histogram(bins = 7)
```

<img src="26-bootstrap_files/figure-html/unnamed-chunk-6-1.png" width="672"  />

 

You'll have to play with the number of bins (there are only 12 observations). I got 7 from the Freedman-Diaconis rule:


```r
nclass.FD(aircon$hours)
```

```
## [1] 7
```

 

I was a little suspicious that the data would not be much like normal (I have run into failure times before), so I kept away from the Sturges rule.

Another possibility is a one-group boxplot:


```r
ggplot(aircon, aes(y = hours, x = 1)) + geom_boxplot()
```

<img src="26-bootstrap_files/figure-html/unnamed-chunk-8-1.png" width="672"  />

 

If you like, you can do a normal quantile plot. I rank that third here, because there is nothing immediately implying a comparison with the *normal* distribution, but I would accept it:


```r
ggplot(aircon, aes(sample = hours)) + stat_qq() + stat_qq_line()
```

<img src="26-bootstrap_files/figure-html/unnamed-chunk-9-1.png" width="672"  />

 
Pick a visual and defend it.

All three of these graphs are showing a strong skewness to the right. 

Extra: this is probably not a surprise, because a time until failure
cannot be less than zero, and distributions with a limit tend to be
skewed away from that limit. (If you look back at the data, there are
some very small failure times, but there are also some very big
ones. The very small ones are saying that the lower limit matters.) If
you were modelling these times until failure, you might use a
distribution like the exponential or gamma or Weibull.


(c) Obtain the means of 1000 bootstrap samples (that is, samples from the data with replacement). Save them.

Solution


Something like this, therefore:


```r
rerun(1000, sample(aircon$hours, replace = T)) %>%
  map_dbl(~ mean(.)) -> means
```



I often start with `rerun(1000)`, closing the bracket, and then wonder
why it doesn't work. In the `rerun`, you have to say two things: how
many times to rerun, and *what* to rerun. So don't close the bracket
on the `rerun` until you've done that.


(d) Make a normal quantile plot of your bootstrap distribution. What do you see? Explain briefly.

Solution


This:


```r
ggplot(tibble(means), aes(sample = means)) + stat_qq() + stat_qq_line()
```

<img src="26-bootstrap_files/figure-html/unnamed-chunk-11-1.png" width="672"  />

 

This is still skewed to the right (it has a curved shape, or, the low values and the high values are both too high compared to the normal). 

Extra: this is less skewed than the original data was, because, with a
sample size of 12, we have a *little* help from the Central Limit
Theorem, but not much. This picture is the one that has to be normal
enough for $t$ procedures to work, and it is not. This comes back into
the picture when we compare our confidence intervals later.

Also, it makes sense to see how *normal* a sampling distribution of a
mean is, so a normal quantile plot would be my first choice for this.


(e) Obtain the 95\% bootstrap percentile confidence interval for the mean.

Solution


This is the 2.5 and 97.5 percentiles of the bootstrapped sampling distribution of the mean:


```r
quantile(means, c(0.025, 0.975))
```

```
##      2.5%     97.5% 
##  47.05625 187.93333
```

 


(f) Obtain the 95\% bootstrap-$t$ confidence interval for
the mean, and compare your two intervals.

Solution


The key is to remember that the original sample (and thus each bootstrap sample) had $n=12$, so there are $12-1=11$ df. (The fact that there were 1000 bootstrap samples is neither here nor there). This is how I like to do it:


```r
t_star <- qt(0.975, 11)
t_star
```

```
## [1] 2.200985
```

```r
mean(means) + c(-1, 1) * t_star * sd(means)
```

```
## [1]  25.33401 186.81249
```

 

The `c(-1, 1)` thing is the calculation version of the $\pm$,
and gets both limits at once. Pull the above apart to see how it works. If
you don't like that, you might prefer something like this:


```r
mean <- mean(means)
sd <- sd(means)
margin <- t_star * sd
mean - margin
```

```
## [1] 25.33401
```

```r
mean + margin
```

```
## [1] 186.8125
```

 

I apologize for the crazy first line of that!
As for comparison: the bootstrap-$t$ interval goes down a lot further,
though the upper limits are quite similar (on this scale). Both
intervals are very long and don't tell us much about the population
mean time to failure, which is not very surprising given the small
sample size ($n=12$) and the large variability in the data.

Extra: the non-normality of the bootstrap (sampling) distribution says that we should definitely not trust the bootstrap-$t$, and probably not the bootstrap percentile interval either. Which brings us to the next part.


(g) Obtain the BCa 95\% confidence interval for the mean.

Solution


This means (possibly) installing and (certainly) loading the `bootstrap` package, and then:


```r
theta <- function(x) {
  mean(x)
}
bca_all <- with(aircon, bcanon(hours, 1000, theta))
bca <- bca_all$confpoints
bca
```

```
##      alpha bca point
## [1,] 0.025  55.58333
## [2,] 0.050  61.25000
## [3,] 0.100  70.66667
## [4,] 0.160  78.50000
## [5,] 0.840 160.66667
## [6,] 0.900 178.50000
## [7,] 0.950 204.25000
## [8,] 0.975 228.75000
```

 

Pull out the ones from this that you need: the top one and the bottom one, to get an interval of 55.6 
to 228.8. 

I seem to need to define the function `theta` first and pass it into `bcanon` as the third input. You may have more luck with `bcanon(hours, 1000, mean)` than I did. Try it.

Or, if you feel like some extra coding: turn this matrix into a data frame, grab the rows you want, and then the column you want:


```r
bca %>%
  as_tibble() %>%
  filter(alpha %in% c(0.025, 0.975)) %>%
  pull(`bca point`)
```

```
## [1]  55.58333 228.75000
```

 


(h) Compare the BCa confidence interval with the other ones. Which one would you recommend? Explain briefly.

Solution


In this example, the bootstrap-$t$ and percentile intervals are very different, so we should use neither of them, and prefer the BCa interval. 

Extra: as usual in this kind of case, the BCa contains values for the mean pulled out into the long tail, but that's a proper adjustment for the sampling distribution being skewed.





##  Air conditioning failures: bootstrapping the median


 With a skewed data distribution such as the air-conditioning
failure times, we might be interested in inference for the median. One
way to get a confidence interval for the median is to invert the sign
test, as in `smmr`, but another way is to obtain a bootstrap
sampling distribution for the median. How do these approaches compare
for the air-conditioning data? We explore this here.



(a) Read in the air-conditioning data again (if you don't already
have it lying around). The link is in the previous question.

Solution



```r
my_url <- "https://raw.githubusercontent.com/nxskok/pasias/master/air_conditioning.csv"
aircon <- read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   failure = col_double(),
##   hours = col_double()
## )
```

```r
aircon
```

```
## # A tibble: 12 x 2
##    failure hours
##      <dbl> <dbl>
##  1       1     3
##  2       2     5
##  3       3     7
##  4       4    18
##  5       5    43
##  6       6    85
##  7       7    91
##  8       8    98
##  9       9   100
## 10      10   130
## 11      11   230
## 12      12   487
```

     


(b) Use `smmr` to get a confidence interval for the median (based on the sign test).

Solution


Input to `ci_median` is data frame and column:

```r
ci_median(aircon, hours)
```

```
## [1]   7.002319 129.998291
```

     


(c) Obtain the bootstrap distribution of the sample median. Make a normal quantile plot of it. What do you notice? Explain briefly.

Solution


The usual do-it-yourself bootstrap:


```r
rerun(1000, sample(aircon$hours, replace = T)) %>%
  map_dbl(~ median(.)) -> medians
```

 

I actually copied and pasted my code from the previous problem, changing `mean` to `median`.

As for a plot, well, this:


```r
ggplot(tibble(medians), aes(sample = medians)) + stat_qq() + stat_qq_line()
```

<img src="26-bootstrap_files/figure-html/unnamed-chunk-20-1.png" width="672"  />

 

Not only does this not look very normal, but also there are those
curious horizontal patches of points (that, you might recall, are
characteristic of a discrete distribution). This has happened because
there are only a few possible medians: the median has to be either a
data value or halfway between two data values, so there are only
something like $2(12)-1=23$ different possible medians, with the ones
in the middle being more likely.

This also shows up on a histogram, but only if you have enough
bins. (If you don't have enough bins, some of the neighbouring
possible values end up in the same bin; here, the aim is to have
enough bins to show the discreteness, rather than the usual thing of
having few enough bins to show the shape.)


```r
ggplot(tibble(medians), aes(x = medians)) + geom_histogram(bins = 30)
```

<img src="26-bootstrap_files/figure-html/unnamed-chunk-21-1.png" width="672"  />

 


(d) Obtain a 95\% bootstrap percentile confidence interval for the median. How does it compare with the one you obtained earlier?

Solution


Also, the usual:


```r
quantile(medians, c(0.025, 0.975))
```

```
##  2.5% 97.5% 
##  12.5 115.0
```

 

This goes down and up not quite so far as the interval from `smmr`. That might be because the `smmr` interval is too wide (based on a not-very-powerful test), or because the bootstrap quantile interval is too narrow (as it usually is). It's hard to tell which it is.


(e) Obtain a 95\% BCa interval. Compare it with the two other intervals you found.

Solution


Yet more copying and pasting (from the previous question):

```r
theta <- function(x) {
  median(x)
}
bca_all <- with(aircon, bcanon(hours, 1000, theta))
bca <- bca_all$confpoints
bca
```

```
##      alpha bca point
## [1,] 0.025      12.5
## [2,] 0.050      12.5
## [3,] 0.100      18.0
## [4,] 0.160      30.5
## [5,] 0.840      94.5
## [6,] 0.900      98.0
## [7,] 0.950     100.0
## [8,] 0.975     115.0
```

     

Again, I seem to need to define the tiny function, while you can probably call `bcanon(hours, 1000, median)`. Try it and see.

My BCa interval is a little longer than the bootstrap percentile
interval and a little shorter than the one that came from the sign
test. I would guess that the BCa interval is the most trustworthy of
the three, though there is here not that much difference between
them. All the intervals are again very long, a reflection of the small
sample size and large variability.



