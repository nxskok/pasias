# Frequency table analysis

Packages for this chapter:


```r
library(tidyverse)
```





##  College plans


 5199 male high school seniors in Wisconsin
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">I don't  know why Wisconsin again, but that's what it is.</span> were classified by
socio-economic status (low, lower-middle, upper-middle, high), by
the degree that their parents encouraged them in their education (low
or high),
and whether or not they had plans to go to college (yes or no). How,
if at all, are these categorical variables related? The data can be
found at
[link](http://www.utsc.utoronto.ca/~butler/d29/college-plans.txt). 



(a) Read in the data and check that you have a column for each
variable and a column of frequencies.

Solution


Delimited by one space:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/college-plans.txt"
wisc <- read_delim(my_url, " ")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   social.stratum = col_character(),
##   encouragement = col_character(),
##   college.plans = col_character(),
##   frequency = col_double()
## )
```

```r
wisc
```

```
## # A tibble: 16 x 4
##    social.stratum encouragement college.plans frequency
##    <chr>          <chr>         <chr>             <dbl>
##  1 lower          low           no                  749
##  2 lower          low           yes                  35
##  3 lower          high          no                  233
##  4 lower          high          yes                 133
##  5 lowermiddle    low           no                  627
##  6 lowermiddle    low           yes                  38
##  7 lowermiddle    high          no                  330
##  8 lowermiddle    low           no                  303
##  9 uppermiddle    low           no                  627
## 10 uppermiddle    low           yes                  38
## 11 uppermiddle    high          no                  374
## 12 uppermiddle    high          yes                 467
## 13 higher         low           no                  153
## 14 higher         low           yes                  26
## 15 higher         high          no                  266
## 16 higher         high          yes                 800
```

     

As promised. We only have 16 observations, because we have all
possible combinations of categorical variable combinations, 4 social
strata, times 2 levels of encouragement, times 2 levels of college
plans. 

Each line of the data file summarizes a number of students, not just
one.  For example, the first line says that 749 students were in the
lower social stratum, received low encouragement and have no college
plans. If we sum up the frequencies, we should get 5199 because there
were that many students altogether:


```r
wisc %>% summarize(tot = sum(frequency))
```

```
## # A tibble: 1 x 1
##     tot
##   <dbl>
## 1  5199
```

 


(b) Fit a log-linear model containing all possible
interactions. You don't need to examine it yet.

Solution



```r
wisc.1 <- glm(frequency ~ social.stratum * encouragement * college.plans,
  data = wisc, family = "poisson"
)
```

   



(c) Find out which terms (interactions) could be removed. Do you
think removing any of them is a good idea?


Solution


This is `drop1`. If you forget the `test=`, you won't
get any P-values:

```r
drop1(wisc.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ social.stratum * encouragement * college.plans
##                                            Df Deviance    AIC   LRT Pr(>Chi)
## <none>                                          115.28 259.52               
## social.stratum:encouragement:college.plans  2   118.98 259.22 3.697   0.1575
```

   

This P-value is not small, so the three-way interaction can be removed.



(d) Remove anything you can, and fit again. Hint: `update`.


Solution


In this kind of modelling, it's easier to describe what changes
should be  made to get from one model to another, rather than
writing out the whole thing from scratch again.
Anyway, the three-way interaction can come out:

```r
wisc.2 <- update(wisc.1, . ~ . - social.stratum:encouragement:college.plans)
```

   



(e) Continue to examine what can be removed, and if reasonable,
remove it, until you need to stop. Which terms are left in your final model?


Solution


Start with `drop1`:

```r
drop1(wisc.2, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ social.stratum + encouragement + college.plans + 
##     social.stratum:encouragement + social.stratum:college.plans + 
##     encouragement:college.plans
##                              Df Deviance     AIC    LRT  Pr(>Chi)    
## <none>                            118.98  259.22                     
## social.stratum:encouragement  3   379.18  513.42 260.20 < 2.2e-16 ***
## social.stratum:college.plans  3   331.86  466.10 212.88 < 2.2e-16 ***
## encouragement:college.plans   1  1024.69 1162.94 905.72 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

   

These are all strongly significant, so they have to stay. There is
nothing else we can remove. All the two-way interactions have to stay
in the model.



(f) Make two-way tables of any remaining two-way interactions, and
describe any relationships that you see.


Solution


We have three two-way tables to make.

My first one is social stratum by parental encouragement. Neither of
these is really a response, but I thought that social stratum would
influence parental encouragement rather than the other way around, hence:


```r
xtabs(frequency ~ social.stratum + encouragement, data = wisc) %>%
  prop.table(margin = 1)
```

```
##               encouragement
## social.stratum      high       low
##    higher      0.8562249 0.1437751
##    lower       0.3182609 0.6817391
##    lowermiddle 0.2542373 0.7457627
##    uppermiddle 0.5584329 0.4415671
```

 

This says that there tends to be more parental encouragement, the
higher the social stratum. 
Next, this:


```r
xtabs(frequency ~ social.stratum + college.plans, data = wisc) %>%
  prop.table(margin = 1)
```

```
##               college.plans
## social.stratum         no        yes
##    higher      0.33654618 0.66345382
##    lower       0.85391304 0.14608696
##    lowermiddle 0.97072419 0.02927581
##    uppermiddle 0.66467463 0.33532537
```

 

In this one (and the next), `college.plans` is the response, in
columns, so we want to have the *rows* adding up to 1. 

The higher the social stratum, the more likely is a male
high school senior to have plans to go to college. (The social stratum
is not in order, so you'll have to jump from the second row to the
third to the fourth to the first to assess this. Lower and lower
middle are not in order, but the others are.)

Finally, this:


```r
xtabs(frequency ~ encouragement + college.plans, data = wisc) %>%
  prop.table(margin = 1)
```

```
##              college.plans
## encouragement        no       yes
##          high 0.4621590 0.5378410
##          low  0.9472265 0.0527735
```

 

And here you see an *enormous* effect of parental encouragement
on college plans: if it is low, the high-school senior is very
unlikely to be considering college.

Nothing, in all honesty, that is very surprising here. But the two-way
interactions are easier to interpret than a three-way one would have
been.

Here, we think of college plans as being a response, and this
analysis has shown that whether or not a student has plans to go to
college depends separately on the socio-economic status and the level
of parental encouragement (rather than on the combination of both, as
would have been the case had the three-way interaction been
significant). 







##  Predicting voting


 1257 British voters were classified according
to their social class, age (categorized), sex and the political party
they voted for (Labour or Conservative). Which, if any, of these
factors influences the party that someone votes for? The data are in
[link](http://www.utsc.utoronto.ca/~butler/d29/voting.txt), one voter
per line.



(a) Read in the data and display (some of) the data frame.

Solution


Space-delimited:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/voting.txt"
vote0 <- read_delim(my_url, " ")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   id = col_double(),
##   class = col_character(),
##   age = col_character(),
##   sex = col_character(),
##   vote = col_character()
## )
```

```r
vote0
```

```
## # A tibble: 1,257 x 5
##       id class        age   sex    vote        
##    <dbl> <chr>        <chr> <chr>  <chr>       
##  1     1 upper middle >75   male   conservative
##  2     2 upper middle >75   male   conservative
##  3     3 upper middle >75   male   conservative
##  4     4 upper middle >75   male   conservative
##  5     5 upper middle >75   female conservative
##  6     6 upper middle >75   female conservative
##  7     7 upper middle >75   female conservative
##  8     8 upper middle >75   female conservative
##  9     9 upper middle >75   female conservative
## 10    10 upper middle >75   female conservative
## # … with 1,247 more rows
```

     

I gave it a "disposable" name, since we make the "real" data set
shortly. 


(b) There is no frequency column here, because each row of the
data frame only represents one voter. Count up the frequencies for
each combo of the categorical variables, and save it (this is the
data frame that we will use for the analysis).
Display the first few rows of the result. Do you now
have something that you need?

Solution


I changed my mind about how to do this from last year. Using
`count` is alarmingly more direct than the method I had before:

```r
votes <- vote0 %>% count(class, age, sex, vote)
votes
```

```
## # A tibble: 58 x 5
##    class        age   sex    vote             n
##    <chr>        <chr> <chr>  <chr>        <int>
##  1 lower middle <26   female conservative    13
##  2 lower middle <26   female labour           7
##  3 lower middle <26   male   conservative     9
##  4 lower middle <26   male   labour           9
##  5 lower middle >75   female conservative     9
##  6 lower middle >75   female labour           2
##  7 lower middle >75   male   conservative     8
##  8 lower middle >75   male   labour           4
##  9 lower middle 26-40 female conservative    17
## 10 lower middle 26-40 female labour          13
## # … with 48 more rows
```

     

Exactly the right thing now: note the new column `n` with
frequencies in it. (Without a column of frequencies we can't fit a
log-linear model.) There are now only 58 combinations of the four
categorical variables, as opposed to 1247 rows in the original data
set (with, inevitably, a lot of repeats).


(c) Fit a log-linear model with the appropriate interaction (as a
starting point).

Solution



```r
vote.1 <- glm(n ~ class * age * sex * vote, data = votes, family = "poisson")
```

     


(d) Refine your model by taking out suitable non-significant
terms, in multiple steps. What model do you finish with?

Solution


Alternating `drop1` and `update` until everything
remaining is significant:

```r
drop1(vote.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## n ~ class * age * sex * vote
##                    Df Deviance    AIC   LRT Pr(>Chi)
## <none>                   0.000 381.49               
## class:age:sex:vote  7    8.086 375.58 8.086   0.3251
```

     

Not anywhere near significant, so out it comes:


```r
vote.2 <- update(vote.1, . ~ . - class:age:sex:vote)
drop1(vote.2, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## n ~ class + age + sex + vote + class:age + class:sex + age:sex + 
##     class:vote + age:vote + sex:vote + class:age:sex + class:age:vote + 
##     class:sex:vote + age:sex:vote
##                Df Deviance    AIC     LRT Pr(>Chi)  
## <none>               8.086 375.58                   
## class:age:sex   8   11.244 362.74  3.1583  0.92404  
## class:age:vote  7   21.962 375.46 13.8759  0.05343 .
## class:sex:vote  2   10.142 373.64  2.0564  0.35765  
## age:sex:vote    4   14.239 373.73  6.1528  0.18802  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

Take out the first one, since it has the highest P-value:


```r
vote.3 <- update(vote.2, . ~ . - class:age:sex)
drop1(vote.3, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## n ~ class + age + sex + vote + class:age + class:sex + age:sex + 
##     class:vote + age:vote + sex:vote + class:age:vote + class:sex:vote + 
##     age:sex:vote
##                Df Deviance    AIC     LRT Pr(>Chi)  
## <none>              11.244 362.74                   
## class:age:vote  7   25.171 362.66 13.9262  0.05251 .
## class:sex:vote  2   12.794 360.29  1.5498  0.46074  
## age:sex:vote    4   19.248 362.74  8.0041  0.09143 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

`class:sex:vote`:


```r
vote.4 <- update(vote.3, . ~ . - class:sex:vote)
drop1(vote.4, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## n ~ class + age + sex + vote + class:age + class:sex + age:sex + 
##     class:vote + age:vote + sex:vote + class:age:vote + age:sex:vote
##                Df Deviance    AIC     LRT Pr(>Chi)  
## <none>              12.794 360.29                   
## class:sex       2   13.477 356.97  0.6830  0.71070  
## class:age:vote  7   26.698 360.19 13.9036  0.05292 .
## age:sex:vote    4   21.211 360.71  8.4172  0.07744 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

`class:sex`:


```r
vote.5 <- update(vote.4, . ~ . - class:sex)
drop1(vote.5, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## n ~ class + age + sex + vote + class:age + age:sex + class:vote + 
##     age:vote + sex:vote + class:age:vote + age:sex:vote
##                Df Deviance    AIC     LRT Pr(>Chi)  
## <none>              13.477 356.97                   
## class:age:vote  7   27.633 357.13 14.1555  0.04848 *
## age:sex:vote    4   22.081 357.57  8.6037  0.07181 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

I don't like having three-way interactions, so I'm going to yank
`age:sex:vote` now, even though its P-value is smallish:


```r
vote.6 <- update(vote.5, . ~ . - age:sex:vote)
drop1(vote.6, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## n ~ class + age + sex + vote + class:age + age:sex + class:vote + 
##     age:vote + sex:vote + class:age:vote
##                Df Deviance    AIC     LRT  Pr(>Chi)    
## <none>              22.081 357.57                      
## age:sex         4   22.918 350.41  0.8372 0.9333914    
## sex:vote        1   33.018 366.51 10.9376 0.0009423 ***
## class:age:vote  7   36.236 357.73 14.1555 0.0484843 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

The age-sex interaction can go, but we must be near the end now:


```r
vote.7 <- update(vote.6, . ~ . - age:sex)
drop1(vote.7, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## n ~ class + age + sex + vote + class:age + class:vote + age:vote + 
##     sex:vote + class:age:vote
##                Df Deviance    AIC    LRT  Pr(>Chi)    
## <none>              22.918 350.41                     
## sex:vote        1   33.808 359.30 10.890 0.0009667 ***
## class:age:vote  7   37.073 350.57 14.155 0.0484843 *  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

And that's it. The age and sex main effects are not included in the
list of droppable things because
both variables are part of higher-order interactions that are still in
the model.

If you want to, you can look at the `summary` of your final model:



 


```r
summary(vote.7)
```

```
## 
## Call:
## glm(formula = n ~ class + age + sex + vote + class:age + class:vote + 
##     age:vote + sex:vote + class:age:vote, family = "poisson", 
##     data = votes)
## 
## Deviance Residuals: 
##      Min        1Q    Median        3Q       Max  
## -1.82417  -0.39708  -0.00015   0.41445   1.41435  
## 
## Coefficients: (1 not defined because of singularities)
##                                       Estimate Std. Error z value Pr(>|z|)    
## (Intercept)                            2.50737    0.21613  11.601  < 2e-16 ***
## classupper middle                     -0.45199    0.34188  -1.322 0.186151    
## classworking                           0.37469    0.27696   1.353 0.176088    
## age>75                                -0.25783    0.32292  -0.798 0.424622    
## age26-40                               0.34294    0.27877   1.230 0.218619    
## age41-50                               0.93431    0.25162   3.713 0.000205 ***
## age51-75                               0.89794    0.25293   3.550 0.000385 ***
## sexmale                               -0.23242    0.08016  -2.900 0.003737 ** 
## votelabour                            -0.50081    0.33324  -1.503 0.132882    
## classupper middle:age>75               0.25783    0.49713   0.519 0.604013    
## classworking:age>75                    0.01097    0.41896   0.026 0.979113    
## classupper middle:age26-40             0.82466    0.41396   1.992 0.046358 *  
## classworking:age26-40                  0.41083    0.35167   1.168 0.242713    
## classupper middle:age41-50             0.37788    0.39239   0.963 0.335542    
## classworking:age41-50                 -0.28917    0.33310  -0.868 0.385327    
## classupper middle:age51-75             0.43329    0.39277   1.103 0.269954    
## classworking:age51-75                  0.10223    0.32668   0.313 0.754325    
## classupper middle:votelabour          -0.12338    0.53898  -0.229 0.818936    
## classworking:votelabour                1.05741    0.39259   2.693 0.007073 ** 
## age>75:votelabour                     -0.72300    0.57745  -1.252 0.210547    
## age26-40:votelabour                    0.21667    0.41944   0.517 0.605452    
## age41-50:votelabour                   -0.93431    0.43395  -2.153 0.031315 *  
## age51-75:votelabour                   -0.62601    0.41724  -1.500 0.133526    
## sexmale:votelabour                     0.37323    0.11334   3.293 0.000992 ***
## classupper middle:age>75:votelabour         NA         NA      NA       NA    
## classworking:age>75:votelabour        -0.29039    0.68720  -0.423 0.672607    
## classupper middle:age26-40:votelabour -0.53698    0.65445  -0.821 0.411931    
## classworking:age26-40:votelabour      -0.28479    0.49429  -0.576 0.564516    
## classupper middle:age41-50:votelabour -0.01015    0.68338  -0.015 0.988147    
## classworking:age41-50:votelabour       1.06121    0.50772   2.090 0.036603 *  
## classupper middle:age51-75:votelabour -0.06924    0.65903  -0.105 0.916328    
## classworking:age51-75:votelabour       0.16608    0.49036   0.339 0.734853    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for poisson family taken to be 1)
## 
##     Null deviance: 797.594  on 57  degrees of freedom
## Residual deviance:  22.918  on 27  degrees of freedom
## AIC: 350.41
## 
## Number of Fisher Scoring iterations: 4
```

 

These tend to be rather unwieldy, and we'll see a better way of
understanding the results below, but you can look for the very
significant results, bearing in mind that the first category is the
baseline, for example, more of the males in the survey voted Labour
(than Conservative).


(e) If we think of the party someone votes for as the final
outcome (that depends on all the other things), what does our final
model say that someone's vote depends on?

Solution


Find out which of the surviving terms are interactions with
`vote`. Here, there are two things, that `vote`
depends on separately:


* `sex`

* The `age`-`class` interaction.



(f) Obtain sub-tables that explain how `vote` depends on
any of the things it's related to.

Solution


This is `xtabs` again. The 3-way interaction is a bit
tricky, so we'll do the simple one first:

```r
xtabs(n ~ vote + sex, data = votes) %>%
  prop.table(margin = 2)
```

```
##               sex
## vote              female      male
##   conservative 0.5474339 0.4543974
##   labour       0.4525661 0.5456026
```

     

The female voters slightly preferred to vote Conservative and the male
voters slightly preferred to vote Labour. This is a small effect, but
I guess the large number of voters made it big enough to be significant.

I took it this way around because `vote` is the outcome, and
therefore I want to address things 
like "if a voter is female, how likely are they to vote Labour", 
rather than conditioning the other
way around (which would 
be "if a voter voted Labour, how likely are they to be female", 
which doesn't make nearly so much sense). 

Then the tricky one:


```r
xt <- xtabs(n ~ vote + age + class, data = votes)
xt
```

```
## , , class = lower middle
## 
##               age
## vote           <26 >75 26-40 41-50 51-75
##   conservative  22  17    31    56    54
##   labour        16   6    28    16    21
## 
## , , class = upper middle
## 
##               age
## vote           <26 >75 26-40 41-50 51-75
##   conservative  14  14    45    52    53
##   labour         9   0    21    13    17
## 
## , , class = working
## 
##               age
## vote           <26 >75 26-40 41-50 51-75
##   conservative  32  25    68    61    87
##   labour        67  19   133   145   115
```

 

Doing it this way has produced different subtables for each
`class`. This is actually OK, because we can 
say "if a voter was of lower middle class" and then talk about the relationship
between age and vote, as if we were looking at a simple effect:



* If a voter was of lower-middle-class, they strongly favour voting
Conservative in all age groups except for `<26` and 26--40.

* If a voter was of upper-middle-class, they even more strongly favour
voting Conservative in all age groups except for "under 26" and
maybe 26--40.

* If a voter was of Working class, they strongly favour voting
Labour, except in the 
"over 75" age group (and maybe 51--75 as well).


If the anomalous age group(s) had been the same one every time, there
would no longer have been an interaction between age and class in
their effect on `vote`. But the anomalous age groups were
different for each class ("different pattern"), and that explains
why there was a `vote:age:class` interaction: " the way someone votes depends on the *combination* of age and social class". 

For `prop.table` in three dimensions, as we have here, we have to be a little
more careful about what to make add up to 1. For example, to make the
social classes each add up to 1, which is the third dimension:


```r
prop.table(xt, 3)
```

```
## , , class = lower middle
## 
##               age
## vote                  <26        >75      26-40      41-50      51-75
##   conservative 0.08239700 0.06367041 0.11610487 0.20973783 0.20224719
##   labour       0.05992509 0.02247191 0.10486891 0.05992509 0.07865169
## 
## , , class = upper middle
## 
##               age
## vote                  <26        >75      26-40      41-50      51-75
##   conservative 0.05882353 0.05882353 0.18907563 0.21848739 0.22268908
##   labour       0.03781513 0.00000000 0.08823529 0.05462185 0.07142857
## 
## , , class = working
## 
##               age
## vote                  <26        >75      26-40      41-50      51-75
##   conservative 0.04255319 0.03324468 0.09042553 0.08111702 0.11569149
##   labour       0.08909574 0.02526596 0.17686170 0.19281915 0.15292553
```

 

What happened here is that each of the three subtables adds up to 1,
so that we have a "joint distribution" in each table. We can put
*two* variables into `prop.table`, and see what happens then:


```r
prop.table(xt, c(2, 3))
```

```
## , , class = lower middle
## 
##               age
## vote                 <26       >75     26-40     41-50     51-75
##   conservative 0.5789474 0.7391304 0.5254237 0.7777778 0.7200000
##   labour       0.4210526 0.2608696 0.4745763 0.2222222 0.2800000
## 
## , , class = upper middle
## 
##               age
## vote                 <26       >75     26-40     41-50     51-75
##   conservative 0.6086957 1.0000000 0.6818182 0.8000000 0.7571429
##   labour       0.3913043 0.0000000 0.3181818 0.2000000 0.2428571
## 
## , , class = working
## 
##               age
## vote                 <26       >75     26-40     41-50     51-75
##   conservative 0.3232323 0.5681818 0.3383085 0.2961165 0.4306931
##   labour       0.6767677 0.4318182 0.6616915 0.7038835 0.5693069
```

 

This is making each `class`-`age` combination add up to
1, so that we can clearly see what fraction of voters voted for each
party in each case.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">The reason I thought of doing this is that these two are all the variables except response.</span>
In the first two subtables, the two youngest
subgroups are clearly different from the others, with a smaller
proportion of people voting Conservative rather than Labour than for
the older subgroups. If that same pattern persisted for the third
subtable, with the two youngest age groups being different from the
three older ones, then we would have an age by vote interaction rather
than the age by class by vote interaction that we actually have. So
the third `class` group should be different. It is: it seems
that the first *three* age groups are different from the other
two, with ages 41--50 being more inclined to vote Labour, like the
younger groups. That's where the interaction came from.

The Labour Party in the UK is like the NDP here, in that it has strong
ties with "working people", trades unions in particular. The
Conservatives are like the Conservatives here (indeed, the nickname
"Tories" comes from the UK; the Conservatives there were officially
known as the Tories many years ago). Many people are lifelong voters
for their party, and would never think of voting for the "other side", 
in the same way that many Americans vote either Democrat or
Republican without thinking about it too much. Our parliamentary
system comes from the UK system (vote for a candidate in a riding, the
leader of the party with the most elected candidates becomes Prime
Minister), and a "landslide" victory often comes from persuading
enough of the voters open to persuasion to switch sides. In the UK, as
here, the parties' share of the popular vote doesn't change all that
much from election to election, even though the number of seats in
Parliament might change quite a lot.



