# Logistic regression with ordinal or nominal response


```r
library(MASS)
library(nnet)
library(tidyverse)
```




##  Do you like your mobile phone?


 A phone company commissioned a survey of their customers'
satisfaction with their mobile devices. The responses to the survey
were on a so-called Likert scale of "very unsatisfied",
"unsatisfied", "satisfied", "very satisfied". Also recorded were
each customer's gender and age group (under 18, 18--24, 25--30, 31 or
older). (A survey of this kind does not ask its respondents for their
exact age, only which age group they fall in.) The data, as
frequencies of people falling into each category combination, are in [link](http://www.utsc.utoronto.ca/~butler/d29/mobile.txt).



(a) <a name="part:gather">*</a> Read in the data and take a look at the format. Use a tool
that you know about to arrange the frequencies in *one* column,
with other columns labelling the response categories that the
frequencies belong to. Save the new data frame. (Take a look at it
if you like.)
 
Solution



```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/mobile.txt"
mobile <- read_delim(my_url, " ")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   gender = col_character(),
##   age.group = col_character(),
##   very.unsat = col_double(),
##   unsat = col_double(),
##   sat = col_double(),
##   very.sat = col_double()
## )
```

```r
mobile
```

```
## # A tibble: 8 x 6
##   gender age.group very.unsat unsat   sat very.sat
##   <chr>  <chr>          <dbl> <dbl> <dbl>    <dbl>
## 1 male   0-17               3     9    18       24
## 2 male   18-24              6    13    16       28
## 3 male   25-30              9    13    17       20
## 4 male   31+                5     7    16       16
## 5 female 0-17               4     8    11       25
## 6 female 18-24              8    14    20       18
## 7 female 25-30             10    15    16       12
## 8 female 31+                5    14    12        8
```

 
With multiple columns that are all frequencies, this is a job for
`pivot_longer`:

```r
mobile %>% 
  pivot_longer(very.unsat:very.sat, 
               names_to="satisfied", 
               values_to="frequency") -> mobile.long
mobile.long
```

```
## # A tibble: 32 x 4
##    gender age.group satisfied  frequency
##    <chr>  <chr>     <chr>          <dbl>
##  1 male   0-17      very.unsat         3
##  2 male   0-17      unsat              9
##  3 male   0-17      sat               18
##  4 male   0-17      very.sat          24
##  5 male   18-24     very.unsat         6
##  6 male   18-24     unsat             13
##  7 male   18-24     sat               16
##  8 male   18-24     very.sat          28
##  9 male   25-30     very.unsat         9
## 10 male   25-30     unsat             13
## # … with 22 more rows
```

     

Yep, all good. See how `mobile.long` contains what it should?
(For those keeping track, the original data frame had 8 rows and 4
columns to collect up, and the new one has $8\times 4=32$ rows.)
 


(b) We are going to fit ordered logistic models below. To
do that, we need our response variable to be a factor with its levels
in the right order. By looking at the data frame
you just created, determine what kind
of thing your intended response variable currently is.



Solution


I looked at `mobile.long` in the previous part, but if you
didn't, look at it here:


```r
mobile.long
```

```
## # A tibble: 32 x 4
##    gender age.group satisfied  frequency
##    <chr>  <chr>     <chr>          <dbl>
##  1 male   0-17      very.unsat         3
##  2 male   0-17      unsat              9
##  3 male   0-17      sat               18
##  4 male   0-17      very.sat          24
##  5 male   18-24     very.unsat         6
##  6 male   18-24     unsat             13
##  7 male   18-24     sat               16
##  8 male   18-24     very.sat          28
##  9 male   25-30     very.unsat         9
## 10 male   25-30     unsat             13
## # … with 22 more rows
```

     

My intended response variable is what I called `satisfied`.
This is `chr` or "text", not the `factor` that I
want. 




(c) If your intended response variable is not a factor, create a factor in your data frame with levels in the right order. Hint: look at the order your levels are *in the data*.



Solution


My intended response `satisfied` is text, not a factor, so
I need to do this part.
The hint is to look at the column `satisfied` in
`mobile.long` and note that the satisfaction categories
appear in the data *in the order that we want*. This is good
news, because we can use `fct_inorder` like this:

```r
mobile.long %>%
  mutate(satis = fct_inorder(satisfied)) -> mobile.long
```

     

If you check, by looking at the data frame, `satis` is 
a `factor`, and you can also do this to verify that its levels
are in the right order:


```r
with(mobile.long, levels(satis))
```

```
## [1] "very.unsat" "unsat"      "sat"        "very.sat"
```

 
Success.

Extra: so now you are asking, what if the levels are in the *wrong* order in the data? Well, below is what you used to have to do, and it will work for this as well.
I'll first find what levels of satisfaction I have. This
can be done by counting them, or by finding the distinct ones:

```r
mobile.long %>% count(satisfied)
```

```
## # A tibble: 4 x 2
##   satisfied      n
##   <chr>      <int>
## 1 sat            8
## 2 unsat          8
## 3 very.sat       8
## 4 very.unsat     8
```

     

or


```r
mobile.long %>% distinct(satisfied)
```

```
## # A tibble: 4 x 1
##   satisfied 
##   <chr>     
## 1 very.unsat
## 2 unsat     
## 3 sat       
## 4 very.sat
```

 

If you count them, they come out in alphabetical order. If you ask for
the distinct ones, they come out in the order they were in
`mobile.long`, which is the order the *columns* of those
names were in `mobile`, which is the order we want. 

To actually grab those satisfaction levels as a vector (that we will
need in a minute), use `pluck` to pull the column out of the
data frame as a vector:


```r
v1 <- mobile.long %>%
  distinct(satisfied) %>%
  pluck("satisfied")
v1
```

```
## [1] "very.unsat" "unsat"      "sat"        "very.sat"
```

 

which is in the correct order, or


```r
v2 <- mobile.long %>%
  count(satisfied) %>%
  pluck("satisfied")
v2
```

```
## [1] "sat"        "unsat"      "very.sat"   "very.unsat"
```

 

which is in alphabetical order. The problem with the second one is
that we know the correct order, but there isn't a good way to code
that, so we have to rearrange it ourselves. The correct order from
`v2` is 4, 2, 1, 3, so:


```r
v3 <- c(v2[4], v2[2], v2[1], v2[3])
v3
```

```
## [1] "very.unsat" "unsat"      "sat"        "very.sat"
```

```r
v4 <- v2[c(4, 2, 1, 3)]
v4
```

```
## [1] "very.unsat" "unsat"      "sat"        "very.sat"
```

 

Either of these will work. The first one is more typing, but is
perhaps more obvious. There is a third way, which is to keep things as
a data frame until the end, and use `slice` to pick out the
rows in the right order:


```r
v5 <- mobile.long %>%
  count(satisfied) %>%
  slice(c(4, 2, 1, 3)) %>%
  pluck("satisfied")
v5
```

```
## [1] "very.unsat" "unsat"      "sat"        "very.sat"
```

 

If you don't see how that works, run it yourself, one line at a time.

The other way of doing this is to physically type them into a vector,
but this carries the usual warnings of requiring you to be very
careful and that it won't be reproducible (eg. if you do another
survey with different response categories). 

So now create the proper response
variable thus, using your vector of categories:


```r
mobile.long %>%
  mutate(satis = ordered(satisfied, v1)) -> mobile.long2
mobile.long2
```

```
## # A tibble: 32 x 5
##    gender age.group satisfied  frequency satis     
##    <chr>  <chr>     <chr>          <dbl> <ord>     
##  1 male   0-17      very.unsat         3 very.unsat
##  2 male   0-17      unsat              9 unsat     
##  3 male   0-17      sat               18 sat       
##  4 male   0-17      very.sat          24 very.sat  
##  5 male   18-24     very.unsat         6 very.unsat
##  6 male   18-24     unsat             13 unsat     
##  7 male   18-24     sat               16 sat       
##  8 male   18-24     very.sat          28 very.sat  
##  9 male   25-30     very.unsat         9 very.unsat
## 10 male   25-30     unsat             13 unsat     
## # … with 22 more rows
```

 

`satis` has the same values as `satisfied`, but its
label `ord` means that it is an ordered factor, as we want.



(d) <a name="part:thefit">*</a>
Fit ordered logistic models to predict satisfaction from (i) gender
and age group, (ii) gender only, (iii) age group only. (You don't
need to examine the models.) Don't forget a suitable
`weights`!
 
Solution


(i):


```r
library(MASS)
mobile.1 <- polr(satis ~ gender + age.group, weights = frequency, data = mobile.long)
```

 

For (ii) and (iii), `update` is the thing (it works for any
kind of model):


```r
mobile.2 <- update(mobile.1, . ~ . - age.group)
mobile.3 <- update(mobile.1, . ~ . - gender)
```

 

We're not going to look at these, because the output from
`summary` is not very illuminating. What we do next is to try
to figure out which (if either) of the explanatory variables
`age.group` and `gender` we need.
 


(e) Use `drop1` on your model containing both explanatory
variables to determine whether you can remove either of them. Use
`test="Chisq"` to obtain P-values.



Solution


`drop1` takes a fitted model, and tests each term in
it in turn, and says which (if any) should be removed. Here's how it goes:


```r
drop1(mobile.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## satis ~ gender + age.group
##           Df    AIC     LRT Pr(>Chi)   
## <none>       1101.8                    
## gender     1 1104.2  4.4089 0.035751 * 
## age.group  3 1109.0 13.1641 0.004295 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

The possibilities are to remove `gender`, to remove
`age.group` or to remove nothing. 
The best one is "remove nothing", because it's the one on the output with the smallest
AIC. Both P-values are small, so it would be a mistake to remove
either of the explanatory variables.



(f) Use `anova` to decide whether we are justified in
removing `gender` from a model containing both `gender`
and `age.group`. Compare your P-value with the one from `drop1`.
 
Solution


This is a comparison of the model with both variables
(`mobile.1`) and the model with `gender` removed
(`mobile.3`). Use `anova` for this, smaller
(fewer-$x$) model first:

```r
anova(mobile.3, mobile.1)
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: satis
##                Model Resid. df Resid. Dev   Test    Df LR stat.    Pr(Chi)
## 1          age.group       414   1092.213                                 
## 2 gender + age.group       413   1087.804 1 vs 2     1  4.40892 0.03575146
```

     

The P-value is (just) less than 0.05, so the models are significantly
different. That means that the model with both variables in fits
significantly better than the model with only `age.group`, and
therefore that taking `gender` out is a mistake.

The P-value is identical to the one from `drop1` (because they
are both doing the same test).
 

(g) Use `anova` to see whether we are justified in removing
`age.group` from a model  containing both `gender` and
`age.group`. Compare your P-value with the one from
`drop1` above.
 
Solution


Exactly the same idea as the last part. In my case, I'm comparing
models `mobile.2` and `mobile.1`:

```r
anova(mobile.2, mobile.1)
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: satis
##                Model Resid. df Resid. Dev   Test    Df LR stat.     Pr(Chi)
## 1             gender       416   1100.968                                  
## 2 gender + age.group       413   1087.804 1 vs 2     3 13.16411 0.004294811
```

    

This one is definitely significant, so I need to keep
`age.group` for sure. Again, the P-value is the same as the one
in `drop1`.
 

(h) Which of the models you have fit so far is the most
appropriate one? Explain briefly.
 
Solution


I can't drop either of my variables, so I have to keep them both:
`mobile.1`, with both `age.group` and `gender`.
  

(i) Obtain predicted probabilities of a
customer falling in the various satisfaction categories, as it
depends on gender and age group. To do that, you need to feed
`predict` three things: the fitted model that contains both
age group and gender, the data frame that you read in from the file
back in part (<a href="#part:gather">here</a>) (which contains all the combinations of age group
and gender), and an appropriate `type`.

 
Solution


My model containing both $x$s was `mobile.1`, the data frame
read in from the file was called `mobile`, and I  need
`type="p"` to get probabilities:

```r
probs <- predict(mobile.1, mobile, type = "p")
mobile %>%
  select(gender, age.group) %>%
  cbind(probs)
```

```
##   gender age.group very.unsat     unsat       sat  very.sat
## 1   male      0-17 0.06070852 0.1420302 0.2752896 0.5219716
## 2   male     18-24 0.09212869 0.1932086 0.3044732 0.4101894
## 3   male     25-30 0.13341018 0.2438110 0.3084506 0.3143283
## 4   male       31+ 0.11667551 0.2252966 0.3097920 0.3482359
## 5 female      0-17 0.08590744 0.1840411 0.3011751 0.4288763
## 6 female     18-24 0.12858414 0.2387296 0.3091489 0.3235374
## 7 female     25-30 0.18290971 0.2853880 0.2920053 0.2396970
## 8 female       31+ 0.16112036 0.2692996 0.3008711 0.2687089
```

   

This worked for me, but this might happen to you, with the same commands as above:


```
## Error in MASS::select(., gender, age.group): unused arguments (gender, age.group)
```

 

Oh, this didn't work. Why not? There don't seem to be any errors.

This is the kind of thing that can bother you for *days*. The
resolution (that it took me a long time to discover) is that you might
have the `tidyverse` *and also* `MASS` loaded, in
the wrong order, and `MASS` also has a `select` (that
takes different inputs and does something different). If you look back
at part (<a href="#part:thefit">here</a>), you might have seen a message there when you
loaded `MASS` that `select` was "masked". When you
have two packages that both contain a function with the same name, the
one that you can see (and that will get used) is the one that was
loaded *last*, which is the `MASS` select (not the one we
actually wanted, which is the `tidyverse` select). There are a
couple of ways around this. One is to un-load the package we no longer
need (when we no longer need it). The mechanism for this is shown at
the end of part (<a href="#part:unload">here</a>). The other is to say explicitly
which package you want your function to come from, so that there is no
doubt. The `tidyverse` is actually a collection of
packages. The best way to find out which one our `select` comes
from is to go to the Console window in R Studio and ask for the help
for `select`. With both `tidyverse` and `MASS`
loaded, the help window offers you a choice of both `select`s;
the one we want is "select/rename variables by name", and the actual
package it comes from is `dplyr`.

There is a third choice, which is the one I prefer now: install and load the package `conflicted`. When you run your code and it calls for something like `select` that is in two packages that you have loaded, it gives an error, like this:

```
Error: [conflicted] `select` found in 2 packages.
Either pick the one you want with `::` 
* MASS::select
* dplyr::select
Or declare a preference with `conflict_prefer()`
* conflict_prefer("select", "MASS")
* conflict_prefer("select", "dplyr")
```

Fixing this costs you a bit of time upfront, but once you have fixed it, you know that the right thing is being run. What I do is to copy-paste one of those `conflict_prefer` lines, in this case the second one, and put it *before* the `select` that now causes the error. Right after the `library(conflicted)` is a good place. When you use `conflicted`, you will probably have to run several times to fix up all the conflicts, which will be a bit frustrating, and you will end up with several `conflict_prefer` lines, but once you have them there, you won't have to worry about the right function being called because you have explicitly said which one you want.

This is a non-standard use of `cbind` because I wanted to grab
only the gender and age group columns from `mobile` first, and
then `cbind` *that* to the predicted probabilities. The
missing first input to `cbind` is 
"whatever came out of the previous step", 
that is, the first two columns of `mobile`.

I only included the first two columns of `mobile` in the
`cbind`, because the rest of the columns of `mobile`
were frequencies, which I don't need to see. (Having said that, it
would be interesting to make a *plot* using the observed
proportions and predicted probabilities, but I didn't ask you for that.)

This is an unusual `predict`, because we didn't have to make a
data frame (with my usual name `new`) containing all the
combinations of things to predict for. We were lucky enough to have
those already in the original data frame `mobile`. 

The usual way to do this is something like the trick that we did for
getting the different satisfaction levels:


```r
genders <- mobile.long %>% distinct(gender) %>% pluck("gender")
age.groups <- mobile.long %>%
  distinct(age.group) %>%
  pluck("age.group")
```

 

This is getting perilously close to deserving a function written to do
it (strictly speaking, we should, since this is three times we've
used this idea now).

Then `crossing` to get the combinations, and then
`predict`: 


```r
new <- crossing(gender = genders, age.group = age.groups)
new
```

```
## # A tibble: 8 x 2
##   gender age.group
##   <chr>  <chr>    
## 1 female 0-17     
## 2 female 18-24    
## 3 female 25-30    
## 4 female 31+      
## 5 male   0-17     
## 6 male   18-24    
## 7 male   25-30    
## 8 male   31+
```

```r
pp <- predict(mobile.1, new, type = "p")
cbind(new, pp)
```

```
##   gender age.group very.unsat     unsat       sat  very.sat
## 1 female      0-17 0.08590744 0.1840411 0.3011751 0.4288763
## 2 female     18-24 0.12858414 0.2387296 0.3091489 0.3235374
## 3 female     25-30 0.18290971 0.2853880 0.2920053 0.2396970
## 4 female       31+ 0.16112036 0.2692996 0.3008711 0.2687089
## 5   male      0-17 0.06070852 0.1420302 0.2752896 0.5219716
## 6   male     18-24 0.09212869 0.1932086 0.3044732 0.4101894
## 7   male     25-30 0.13341018 0.2438110 0.3084506 0.3143283
## 8   male       31+ 0.11667551 0.2252966 0.3097920 0.3482359
```

 
This method is fine if you want to do this
question this way; the way I suggested first ought  to be easier, but 
the nice thing about this is its mindlessness: you always do it about
the same way.

 


(j) <a name="part:unload">*</a> 
Describe any patterns you see in the predictions, bearing in mind the
significance or not of the explanatory variables.

 
Solution


I had both explanatory variables being significant, so I would
expect to see both an age-group effect *and* a gender effect.
For both males and females, there seems to be a decrease in
satisfaction as the customers get older, at least until age 30 or
so. I can see this because the predicted prob.\ of "very  satisfied" 
decreases, and the predicted prob.
of "very unsatisfied" increases. The 31+ age group are very
similar to the 25--30 group for both males and females. So that's
the age group effect.
What about a gender effect? Well, for all the age groups, the males
are more likely to be very satisfied than the females of the
corresponding age group, and also less likely to to be very
unsatisfied. So the gender effect is that males are more satisfied
than females overall. (Or, the males are less discerning. Take your pick.)
When we did the tests above, age group was very definitely
significant, and gender less so (P-value around 0.03). This
suggests that the effect of age group ought to be large, and the
effect of gender not so large. This is about what we observed: the
age group effect was pretty clear, and the gender effect was
noticeable but small: the females were less satisfied than the
males, but there wasn't all that much difference.
Now we need to "unload" MASS, because, as we saw, *it* has a
`select` that we don't want to have
interfering with the `dplyr` one:

```r
detach("package:MASS", unload = T)
```

```
## Warning: 'MASS' namespace cannot be unloaded:
##   namespace 'MASS' is imported by 'lme4', 'PMCMRplus' so cannot be unloaded
```

    
 





##  Attitudes towards abortion


 <a name="q:abortion">*</a> Abortion is a divisive issue in the United States,
particularly among Christians, some of whom believe that abortion is
absolutely forbidden by the Bible. Do attitudes towards abortion
differ among Christian denominations? The data in
[link](http://www.utsc.utoronto.ca/~butler/d29/abortion.txt) come from
the American Social Survey for the years  1972--1974. The variables
are:



* `year`: year of survey, 1972, 1973 or 1974

* `religion`: Christian denomination: Southern Protestant,
other Protestant, Catholic.

* `education`: years of education: low (0--8), medium
(8--12), high (more than 12).

* `attitude` towards abortion (response). There were three abortion
questions in the survey, asking whether the respondent thought that
abortion should  be legal in these three circumstances:


* when there is a strong possibility of a birth defect

* when the mother's health is threatened

* when the pregnancy is the result of rape.

A respondent who responded "yes" to all three questions was
recorded as having a Positive attitude towards abortion; someone who
responded "no" to all three was recorded as Negative, and anyone
who gave a mixture of Yes and No responses was recorded as Mixed.

* `frequency` The number of respondents falling into the
given category combination.




(a) Read in and display the data. Do you seem to have the right
things?


Solution


The columns are aligned with each other but not with the headings,
so `read_table2` it has to be:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/abortion.txt"
abortion <- read_table2(my_url)
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   year = col_double(),
##   religion = col_character(),
##   education = col_character(),
##   attitude = col_character(),
##   frequency = col_double()
## )
```

```r
abortion
```

```
## # A tibble: 81 x 5
##     year religion education attitude frequency
##    <dbl> <chr>    <chr>     <chr>        <dbl>
##  1  1972 Prot     Low       Neg              9
##  2  1972 Prot     Low       Mix             12
##  3  1972 Prot     Low       Pos             48
##  4  1972 Prot     Med       Neg             13
##  5  1972 Prot     Med       Mix             43
##  6  1972 Prot     Med       Pos            197
##  7  1972 Prot     High      Neg              4
##  8  1972 Prot     High      Mix              9
##  9  1972 Prot     High      Pos            139
## 10  1972 SProt    Low       Neg              9
## # … with 71 more rows
```

     

This looks good. `religion, education, attitude` are correctly
categorical with apparently the right levels, and `frequency`
is a (whole) number.

The only weirdness is that year got read in as a number, because it
*was* a number. `read_table2` had no way of knowing that
we might have wanted to treat this as categorical. But you don't need to
observe that.



(b) We have three choices for fitting logistic regressions:


* `glm` with `family="binomial"`

* `polr` (from package `MASS`)

* `multinom` (from package `nnet`)

Why should we be using `polr` for this analysis?
Explain briefly.


Solution


It all comes down to what kind of response variable we have. Our
response variable `attitude` has *three* categories that can
be put in order: negative, mixed, positive (or the other way
around). So we have an ordinal response, which calls for
`polr`. You can eliminate the other possibilities, because
`glm` requires a *two-*category response and
`multinom` requires a nominal response whose categories do
*not* have a natural order.
In short, "because we have an ordered (ordinal) response". 



(c) `attitude` is text, and needs to be an ordered factor,
with the values in the right order.  Create a vector, using
`c()` if you wish, that contains the factor levels in the
right order, and then create a new `attitude` factor using
the `ordered` function, feeding it first the variable as read
from the file, and second the new ordered levels that you want it to
have.


Solution


This is actually harder to describe than it is to do.
First thing is to decide on the ordering you want. You can go
low to high or high to low (it doesn't matter).
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">The        results might look different which way you go, but it won't        make any *material* difference.</span> I'm going negative to
positive. Either way, you want `Mix` in the middle:

```r
lev <- c("Neg", "Mix", "Pos")
```

       

Then use the original `attitude` plus this `lev` as
input to `ordered`:


```r
abortion <- abortion %>%
  mutate(attitude.ord = ordered(attitude, lev))
abortion
```

```
## # A tibble: 81 x 6
##     year religion education attitude frequency attitude.ord
##    <dbl> <chr>    <chr>     <chr>        <dbl> <ord>       
##  1  1972 Prot     Low       Neg              9 Neg         
##  2  1972 Prot     Low       Mix             12 Mix         
##  3  1972 Prot     Low       Pos             48 Pos         
##  4  1972 Prot     Med       Neg             13 Neg         
##  5  1972 Prot     Med       Mix             43 Mix         
##  6  1972 Prot     Med       Pos            197 Pos         
##  7  1972 Prot     High      Neg              4 Neg         
##  8  1972 Prot     High      Mix              9 Mix         
##  9  1972 Prot     High      Pos            139 Pos         
## 10  1972 SProt    Low       Neg              9 Neg         
## # … with 71 more rows
```

 

I printed out the result to convince myself that I had the right
thing, but you don't have to. Note that `attitude.ord` has the
same values as `attitude`, but is `ord` (that is, an
ordered factor) rather than text.

This is the easy way. To save yourself some typing, you can get the
`attitude` levels from the data:


```r
lev <- abortion %>% distinct(attitude) %>% pull(attitude)
lev
```

```
## [1] "Neg" "Mix" "Pos"
```

 

or 


```r
lev2 <- abortion %>% count(attitude) %>% pull(attitude)
lev2
```

```
## [1] "Mix" "Neg" "Pos"
```

 

`distinct` arranges the values in the order it found them in
the data, which is a sensible low-to-high here; `count`
arranges the levels in alphabetical order, which is *not*
sensible, so you'd need to rearrange them, like this:


```r
lev3 <- lev2[c(2, 1, 3)]
lev3
```

```
## [1] "Neg" "Mix" "Pos"
```

 

or, if you like working with data frames better:


```r
lev4 <- abortion %>%
  count(attitude) %>%
  slice(c(2, 1, 3)) %>%
  pull(attitude)
lev4
```

```
## [1] "Neg" "Mix" "Pos"
```

 

where you'd have to go as far as `count` the first time to find
what to slice, and then run the whole thing the second time.



(d) Fit a model that will predict the correctly-ordered
attitude towards abortion 
from religious denomination and education. Don't forget that each
row of the data file encodes a lot of people. You don't need to
display the results.


Solution


This is a veiled hint to remember the `weights=`
thing. Don't forget to use your `attitude` in the proper
order that you went to such great pains to make in the last part!

```r
library(MASS)
abortion.1 <- polr(attitude.ord ~ religion + education,
  data = abortion, weights = frequency
)
```

       



(e) Fit two more models, one containing `religion` only,
and the other containing `education` only. Again, no need to
look at the results.


Solution


This is a standard application of `update`. Note that
this carries along the `data=`, and *also* the
`weights=`, so you don't need either of them again; just
make sure you say what *changes*, and everything else
(including the form of the model) will stay the same:


```r
abortion.2 <- update(abortion.1, . ~ . - education)
abortion.3 <- update(abortion.1, . ~ . - religion)
```

 

The syntax means "take everything in the model abortion.1, and then take out education" for the first one.
If you don't like `update`, you can also copy and paste and edit:


```r
abortion.2a <- polr(attitude.ord ~ religion,
  data = abortion, weights = frequency
)
abortion.3a <- polr(attitude.ord ~ education,
  data = abortion, weights = frequency
)
```

       




(f) Investigate whether each of `religion` and `education`
should stay in the model, or whether they can be removed. Do this
two ways, using `drop1` and using `anova`. What do you
conclude? 


Solution


I think `drop1` is easier, so let's do that first:

```r
drop1(abortion.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## attitude.ord ~ religion + education
##           Df    AIC    LRT  Pr(>Chi)    
## <none>       4077.5                     
## religion   2 4139.2 65.635 5.592e-15 ***
## education  2 4152.6 79.104 < 2.2e-16 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

       

Dropping nothing is rather clearly the best thing to do. Note how easy
that is, because you test both variables at once. If one of them had
been removable, you would have removed it, and then done
`drop1` again to see whether the other one could come out as well.

The `anova` way is more complicated, but sometimes that's the
only way that works. The idea is that you compare the fit of the model
containing both variables with the model obtained by dropping one of
the variables, and see whether you really need the bigger model. This
has to be done twice, once for each explanatory variable you're testing.

First, we test `religion`, by comparing the model with it (and
`education`) and the model without it (with just
`education`, but the other way around (since the smaller model
goes first):

```r
anova(abortion.3, abortion.1)
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: attitude.ord
##                  Model Resid. df Resid. Dev   Test    Df LR stat.      Pr(Chi)
## 1            education      3233   4131.176                                   
## 2 religion + education      3231   4065.541 1 vs 2     2 65.63505 5.551115e-15
```

       

This P-value is small, so the bigger model is better:
`religion` should stay. (To be sure that you did the right
thing, look in the `anova` output at the two `Model`
lines: the extra thing in the bigger model needs to be the thing
you're testing for.)

Now, we test `education` by comparing the model with both and
the model without `education` (but with `religion` since
that's important):


```r
anova(abortion.2, abortion.1)
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: attitude.ord
##                  Model Resid. df Resid. Dev   Test    Df LR stat. Pr(Chi)
## 1             religion      3233   4144.645                              
## 2 religion + education      3231   4065.541 1 vs 2     2 79.10415       0
```

       

Same conclusion: `education` has to stay too.
Note that the P-values in `drop1` and in `anova`, and
also the test statistics (`LRT` and `LR stat.`) are the
same, so it literally doesn't matter which way you do it.



(g) Which of your fitted models is the best? Explain briefly.



Solution


We couldn't take either of the explanatory variables out, so the
model with both variables is best, the one I called
`abortion.1`. 



(h) <a name="part:preds">*</a> 
Obtain predicted probabilities for each attitude towards abortion
for each combination of education level and religious
denomination. To do that, (i) obtain those levels of education and
religion, (ii) make a data frame out of all combinations of them,
(iii) feed your best fitted model and that data frame into
`predict` with any necessary options.


Solution


Use either `distinct` or `count` to get the levels of
`education` and `religion`:

```r
educations <- abortion %>% distinct(education) %>% pull(education)
religions <- abortion %>% distinct(religion) %>% pull(religion)
new <- crossing(education = educations, religion = religions)
new
```

```
## # A tibble: 9 x 2
##   education religion
##   <chr>     <chr>   
## 1 High      Cath    
## 2 High      Prot    
## 3 High      SProt   
## 4 Low       Cath    
## 5 Low       Prot    
## 6 Low       SProt   
## 7 Med       Cath    
## 8 Med       Prot    
## 9 Med       SProt
```

```r
pp <- predict(abortion.1, new, type = "p")
cbind(new, pp)
```

```
##   education religion        Neg        Mix       Pos
## 1      High     Cath 0.05681385 0.16191372 0.7812724
## 2      High     Prot 0.02649659 0.08579955 0.8877039
## 3      High    SProt 0.03342471 0.10504280 0.8615325
## 4       Low     Cath 0.15709933 0.30706616 0.5358345
## 5       Low     Prot 0.07767439 0.20363294 0.7186927
## 6       Low    SProt 0.09665550 0.23547512 0.6678694
## 7       Med     Cath 0.08336876 0.21375231 0.7028789
## 8       Med     Prot 0.03947421 0.12089996 0.8396258
## 9       Med    SProt 0.04962265 0.14566284 0.8047145
```

       



(i) Using your predictions from (<a href="#part:preds">here</a>), describe
the effect of education. (This should be the same for all values of `religion`).


Solution


Pick a religious denomination, say `Cath` since that's
the first one. Focus on the three rows with that
`religion`, here rows 1, 4 and 7.  I'd say the striking
thing is that people with `Low` education are most likely
to have a negative attitude towards abortion. Or you could say
that they are *least* likely to have a positive attitude
towards abortion. That's equally good. Or you can turn it around
and say that the `High` education people are *more*
likely to be in favour of abortion (or less likely to be opposed
to it).
This holds true for all religious denominations, as you can check.
This is one of those cases where I don't mind much what you say,
as long as the data (here the predictions) support it.



(j) Using your predictions from (<a href="#part:preds">here</a>), describe
the effect of `religion`. (This should be the same for all
levels of `education`.)


Solution


As in the previous part: pick a level of `education`, and
then judge the effect of `religion`. 

The `Low` level of education appeared to be the most
opposed to abortion before, so the effects of `religion`
might be the most noticeable there. For those, the Catholics are
most likely to be negatively inclined towards abortion, and the
least likely to be postively inclined. There is not much
difference between the two flavours of Protestant.

Some further thoughts:

What actually surprises me is that you hear (in the media) about
Christians being steadfastly opposed to abortion. This is
something that these data do not support at all: an appreciable
fraction of people from each of the denominations, especially
with medium or high levels of education, are actually in favour
of abortion in all three of the circumstances described in the question.

Extra: the models we fitted assume an effect of `religion`
regardless of education, and an effect of `education`
regardless of religion. But it might be that the effect of
education depends on which religious denomination you're looking
at. The way to assess whether that is true is to add an
*interaction*, as you would in analysis of variance. (We
haven't talked about that in this course yet, which is why I
didn't ask you to do it.) In R, `a:b` means 
"the interaction between factors `a` and `b`" and
`a*b` means 
"the main effects of `a` and `b` and their interaction". In our case, therefore, we
should add `education:religion` to our model and test it
for significance:

```r
abortion.4 <- update(abortion.1, . ~ . + education:religion)
anova(abortion.1, abortion.4)
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: attitude.ord
##                                       Model Resid. df Resid. Dev   Test    Df
## 1                      religion + education      3231   4065.541             
## 2 religion + education + religion:education      3227   4047.041 1 vs 2     4
##   LR stat.      Pr(Chi)
## 1                      
## 2 18.49958 0.0009853301
```

       

The interaction *is* significant, so it should stay. What effect
does it have on the predictions? We've done all the setup earlier, so
we just run `predict` again on the new model:


```r
pp <- predict(abortion.4, new, type = "p")
cbind(new, pp)
```

```
##   education religion        Neg        Mix       Pos
## 1      High     Cath 0.07624521 0.20160124 0.7221536
## 2      High     Prot 0.02248256 0.07434749 0.9031699
## 3      High    SProt 0.02363341 0.07775848 0.8986081
## 4       Low     Cath 0.11358676 0.26036670 0.6260465
## 5       Low     Prot 0.08192969 0.21185155 0.7062188
## 6       Low    SProt 0.12342416 0.27283576 0.6037401
## 7       Med     Cath 0.08153700 0.21115988 0.7073031
## 8       Med     Prot 0.04087702 0.12486250 0.8342605
## 9       Med    SProt 0.04858716 0.14369236 0.8077205
```

 

For Southern Protestants and Other Protestants, the effect of
education is as we described it before: the lower the amount of
education, the less favourably inclined towards abortion (that is,
`Neg` is more likely and `Pos` is less likely). This is
still true for Catholics, but the effect of education is less
noticeable: the probabilities of each response, over the levels of
education, vary much less. This, I 
think, is where the interaction comes from: for Catholics, education
has a much smaller effect on attitudes towards abortion than it does
for either of the Protestant denominations. 

I would have liked to have you explore this, but the question was
already too long, so I called a halt where I did.

Again, we should tidy up after ourselves:


```r
detach("package:MASS", unload = T)
```

```
## Warning: 'MASS' namespace cannot be unloaded:
##   namespace 'MASS' is imported by 'lme4', 'PMCMRplus' so cannot be unloaded
```

 






##  Finding non-missing values


 <a name="part:prepare-next">*</a> This is to prepare you for something in the next
question. It's meant to be easy.

In R, the code `NA` stands for "missing value" or
"value not known". In R, `NA` should not have quotes around
it. (It is a special code, not a piece of text.)


(a) Create a vector `v` that contains some numbers and some
missing values, using `c()`. Put those values into a
one-column data frame.
 
Solution


Like this. The arrangement of numbers and missing values doesn't
matter, as long as you have some of each:

```r
v <- c(1, 2, NA, 4, 5, 6, 9, NA, 11)
mydata <- tibble(v)
mydata
```

```
## # A tibble: 9 x 1
##       v
##   <dbl>
## 1     1
## 2     2
## 3    NA
## 4     4
## 5     5
## 6     6
## 7     9
## 8    NA
## 9    11
```

     

This has one column called `v`.
 

(b) Obtain a new column containing `is.na(v)`. When is this true and when is this false?
 
Solution



```r
mydata <- mydata %>% mutate(isna = is.na(v))
mydata
```

```
## # A tibble: 9 x 2
##       v isna 
##   <dbl> <lgl>
## 1     1 FALSE
## 2     2 FALSE
## 3    NA TRUE 
## 4     4 FALSE
## 5     5 FALSE
## 6     6 FALSE
## 7     9 FALSE
## 8    NA TRUE 
## 9    11 FALSE
```

     

This is `TRUE` if the corresponding element of `v` is
missing (in my case, the third value and the second-last one), and
`FALSE` otherwise (when there is an actual value there).
 

(c) The symbol `!` means "not" in R (and other
programming languages). What does `!is.na(v)` do? Create a
new column containing that.
 
Solution


Try it and see. Give it whatever name you like. My name reflects
that I know what it's going to do:

```r
mydata <- mydata %>% mutate(notisna = !is.na(v))
mydata
```

```
## # A tibble: 9 x 3
##       v isna  notisna
##   <dbl> <lgl> <lgl>  
## 1     1 FALSE TRUE   
## 2     2 FALSE TRUE   
## 3    NA TRUE  FALSE  
## 4     4 FALSE TRUE   
## 5     5 FALSE TRUE   
## 6     6 FALSE TRUE   
## 7     9 FALSE TRUE   
## 8    NA TRUE  FALSE  
## 9    11 FALSE TRUE
```

     

This is the logical opposite of `is.na`: it's true if there is
a value, and false if it's missing.
 


(d) Use `filter` to display just the
rows of your data frame that have a non-missing value of `v`.

 
Solution


`filter` takes a column to say which rows to pick, in
which case the column should contain something that either *is*
`TRUE` or `FALSE`, or something that can be
interpreted that way:

```r
mydata %>% filter(notisna)
```

```
## # A tibble: 7 x 3
##       v isna  notisna
##   <dbl> <lgl> <lgl>  
## 1     1 FALSE TRUE   
## 2     2 FALSE TRUE   
## 3     4 FALSE TRUE   
## 4     5 FALSE TRUE   
## 5     6 FALSE TRUE   
## 6     9 FALSE TRUE   
## 7    11 FALSE TRUE
```

   

or you can provide `filter` something that can be calculated
from what's in the data frame, and also returns something that is
either true or false:


```r
mydata %>% filter(!is.na(v))
```

```
## # A tibble: 7 x 3
##       v isna  notisna
##   <dbl> <lgl> <lgl>  
## 1     1 FALSE TRUE   
## 2     2 FALSE TRUE   
## 3     4 FALSE TRUE   
## 4     5 FALSE TRUE   
## 5     6 FALSE TRUE   
## 6     9 FALSE TRUE   
## 7    11 FALSE TRUE
```

 

In either case, I only have non-missing values of `v`.
 





##  European Social Survey and voting


 The European Social Survey is a giant survey carried out
across Europe covering demographic information, attitudes to and
amount of education, politics and so on. In this question, we will
investigate what might make British people vote for a certain
political party.

The information for this question is in a (large) spreadsheet at
[link](http://www.utsc.utoronto.ca/~butler/d29/ess.csv). There is also a
"codebook" at
[link](http://www.utsc.utoronto.ca/~butler/d29/ess-codebook.pdf) that
tells you what all the variables are. The ones we will use are the
last five columns of the spreadsheet, described on pages 11 onwards of
the codebook. (I could have given you more, but I didn't want to make
this any more complicated than it already was.)



(a) Read in the `.csv` file, and verify that you have lots
of rows and columns.
 
Solution


The obvious way. Printing it out will display some of the data
and tell you how many rows and columns you have:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/ess.csv"
ess <- read_csv(my_url)
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   cntry = col_character(),
##   cname = col_character(),
##   cedition = col_double(),
##   cproddat = col_character(),
##   cseqno = col_double(),
##   name = col_character(),
##   essround = col_double(),
##   edition = col_double(),
##   idno = col_double(),
##   dweight = col_double(),
##   pspwght = col_double(),
##   pweight = col_double(),
##   prtvtgb = col_double(),
##   gndr = col_double(),
##   agea = col_double(),
##   eduyrs = col_double(),
##   inwtm = col_double()
## )
```

```r
ess
```

```
## # A tibble: 2,286 x 17
##    cntry cname   cedition cproddat cseqno name   essround edition   idno dweight
##    <chr> <chr>      <dbl> <chr>     <dbl> <chr>     <dbl>   <dbl>  <dbl>   <dbl>
##  1 GB    ESS1-6…        1 26.11.2… 134168 ESS6e…        6     2.1 101014   1.01 
##  2 GB    ESS1-6…        1 26.11.2… 134169 ESS6e…        6     2.1 101048   2.02 
##  3 GB    ESS1-6…        1 26.11.2… 134170 ESS6e…        6     2.1 101055   1.01 
##  4 GB    ESS1-6…        1 26.11.2… 134171 ESS6e…        6     2.1 101089   0.505
##  5 GB    ESS1-6…        1 26.11.2… 134172 ESS6e…        6     2.1 101097   0.505
##  6 GB    ESS1-6…        1 26.11.2… 134173 ESS6e…        6     2.1 101113   1.01 
##  7 GB    ESS1-6…        1 26.11.2… 134174 ESS6e…        6     2.1 101121   0.505
##  8 GB    ESS1-6…        1 26.11.2… 134175 ESS6e…        6     2.1 101139   0.505
##  9 GB    ESS1-6…        1 26.11.2… 134176 ESS6e…        6     2.1 101154   1.01 
## 10 GB    ESS1-6…        1 26.11.2… 134177 ESS6e…        6     2.1 101170   1.01 
## # … with 2,276 more rows, and 7 more variables: pspwght <dbl>, pweight <dbl>,
## #   prtvtgb <dbl>, gndr <dbl>, agea <dbl>, eduyrs <dbl>, inwtm <dbl>
```

     

2286 rows and 17 columns.
 

(b) <a name="part:whatvar">*</a> Use the codebook to find out what the columns
`prtvtgb`, `gndr`, `agea`, `eduyrs` and
`inwtm` are.  What do the values 1 and 2 for `gndr`
mean? (You don't, at this point, have to worry about the values for
the other variables.)
 
Solution


Respectively, political party voted for at last election, gender
(of respondent), age at interview, years of full-time education,
length of interview (in minutes). For `gndr`, male  is 1
and female is 2.
 

(c) The three major political parties in Britain are the
Conservative, Labour and Liberal Democrat. (These, for your
information, correspond roughly to the Canadian Progressive
Conservative, NDP and Liberal parties.) For the variable that
corresponds to "political party voted for at the last election",
which values correspond to these three parties?
 
Solution


1, 2 and 3 respectively. (That was easy!)
 

(d) Normally, I would give you a tidied-up
data set. But I figure you could use some practice tidying this one
up. As the codebook shows, there are some numerical codes for
missing values, and we want to omit those.
We want just the columns `prtvtgb` through `inwtm`
from the right side of the spreadsheet.  Use `dplyr` or
`tidyr` tools to (i) select only these columns, (ii) include
the rows that correspond to people who voted for one of the three
major parties, (iii) include the rows that have an age at interview
less than 999, (iv) include the rows that have less than 40 years of
education, (v) include the rows that are not missing on
`inwtm` (use the idea from Question~<a href="#part:prepare-next">here</a>
for (v)).  The last four of those (the inclusion of rows) can be
done in one go.
 
Solution


This seems to call for a pipeline. The major parties are numbered 1,
2 and 3, so we can select the ones less than 4 (or
`<=3`). The reference back to the last question is a hint
to use `!is.na()`.

```r
ess.major <- ess %>%
  select(prtvtgb:inwtm) %>%
  filter(prtvtgb < 4, agea < 999, eduyrs < 40, !is.na(inwtm))
```

     
You might get a weird error in `select`, something about
"unused argument". If this happens to you, it's *not* because
you used `select` wrong, it's because you used the wrong
`select`! There is one in `MASS`, and you need to make
sure that this package is "detached" so that you use the
`select` you want, namely the one in `dplyr`, loaded
with the `tidyverse`.  Use the instructions at the end of the
mobile phones question or the abortion question to do this.

The other way around this is to say, instead of `select`,
`dplyr::select` with two colons. This means 
"the `select` that lives in `dplyr`, no other", and is what
Wikipedia calls "disambiguation": out of several things with the
same name, you say which one you mean.

If you do the pipeline, you will probably *not* get it right the
first time. (I didn't.) For debugging, try out one step at a time, and
summarize what you have so far, so that you can check it for
correctness. A handy trick for that is to make the last piece of your
pipeline `summary()`, which produces a summary of the columns of
the resulting data frame. For example, I first did this (note that my
`filter` is a lot simpler than the one above):


```r
ess %>%
  select(prtvtgb:inwtm) %>%
  filter(prtvtgb < 4, !is.na(inwtm)) %>%
  summary()
```

```
##     prtvtgb           gndr            agea            eduyrs     
##  Min.   :1.000   Min.   :1.000   Min.   : 18.00   Min.   : 0.00  
##  1st Qu.:1.000   1st Qu.:1.000   1st Qu.: 44.00   1st Qu.:11.00  
##  Median :2.000   Median :2.000   Median : 58.00   Median :13.00  
##  Mean   :1.803   Mean   :1.572   Mean   : 61.74   Mean   :14.23  
##  3rd Qu.:2.000   3rd Qu.:2.000   3rd Qu.: 71.00   3rd Qu.:16.00  
##  Max.   :3.000   Max.   :2.000   Max.   :999.00   Max.   :88.00  
##      inwtm       
##  Min.   :  7.00  
##  1st Qu.: 35.00  
##  Median : 41.00  
##  Mean   : 43.54  
##  3rd Qu.: 50.00  
##  Max.   :160.00
```

 

The mean of a categorical variable like party voted for or gender
doesn't make much sense, but it looks as if all the values are sensible
ones (1 to 3 and 1, 2 respectively). However, the maximum values of
age and years of education look like missing value codes, hence the
other requirements I put in the question.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">If you do not take  out the *NA* values, they are shown separately on the end of  the *summary* for that column.</span>

`Print`ing as the last step of your pipeline also works, but the
advantage of `summary` is that you get to see whether there are
any unusual values, in this case unusually *large* values that
are missing value codes.
 

(e) Why is my response variable nominal rather than  ordinal? How can I tell?
Which R function should I use, therefore, to fit my model?
 
Solution


The response variable is political party voted for. There is no
(obvious) ordering to this (unless you want to try to place the parties
on a left-right spectrum), so this is nominal, and you'll need
`multinom` from package `nnet`.

If I had included the minor parties and you were working on a
left-right spectrum, you would have had to decide where to put the
somewhat libertarian Greens
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">The American Green party is more libertarian than Green parties elsewhere.</span> 
or the parties that exist only in Northern Ireland.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">Northern Ireland's political parties distinguish themselves by politics *and* religion. Northern Ireland has always had political tensions between its Protestants and its Catholics.</span>
 

(f) <a name="part:full">*</a> Take the political party voted for, and turn it into a
factor, by feeding it into `factor`.
Fit an appropriate model to predict political party voted
for at the last election (as a factor) from all the other
variables. Gender is really a categorical variable too, but since
there are only two possible values it can be treated as a number.
 
Solution


This, or something like it. `multinom` lives in package
`nnet`, which you'll have to install first if you haven't already:

```r
library(nnet)
ess.1 <- multinom(factor(prtvtgb) ~ gndr + agea + eduyrs + inwtm, data = ess.major)
```

```
## # weights:  18 (10 variable)
## initial  value 1343.602829 
## iter  10 value 1256.123798
## final  value 1247.110080 
## converged
```

     

Or create a factor version of your response in the data frame first:


```r
ess.major <- ess.major %>% mutate(party = factor(prtvtgb))
```

 

and then:


```r
ess.1a <- multinom(party ~ gndr + agea + eduyrs + inwtm, data = ess.major)
```

```
## # weights:  18 (10 variable)
## initial  value 1343.602829 
## iter  10 value 1256.123798
## final  value 1247.110080 
## converged
```

 

 


(g) We have a lot of explanatory variables. The standard way to
test whether we need all of them is to take one of them out at a time,
and test which ones we can remove. This is a lot of work. We won't do
that. Instead,
the R function `step` does what you want. You feed `step`
two things: a fitted model object, and the option `trace=0`
(otherwise you get a lot of output). The final part of the output from
`step` tells you which explanatory variables you need to keep.
Run `step` on your fitted model. Which explanatory variables
need to stay in the model here?

 
Solution


I tried to give you lots of hints here:

```r
ess.2a <- step(ess.1, trace = 0)
```

```
## trying - gndr 
## trying - agea 
## trying - eduyrs 
## trying - inwtm 
## # weights:  15 (8 variable)
## initial  value 1343.602829 
## iter  10 value 1248.343563
## final  value 1248.253638 
## converged
## trying - agea 
## trying - eduyrs 
## trying - inwtm
```

```r
ess.2a
```

```
## Call:
## multinom(formula = factor(prtvtgb) ~ agea + eduyrs + inwtm, data = ess.major)
## 
## Coefficients:
##   (Intercept)        agea     eduyrs       inwtm
## 2    1.632266 -0.02153694 -0.0593757 0.009615167
## 3   -1.281031 -0.01869263  0.0886487 0.009337084
## 
## Residual Deviance: 2496.507 
## AIC: 2512.507
```

   

If you didn't save your output in a variable, you'll get my last bit
automatically.

The end of the output gives us coefficients for (and thus tells us we
need to keep)  age, years of education and interview length.  

The actual numbers don't mean much; it's the indication that the
variable has stayed in the model that makes a
difference.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">There are three political parties; using the first  as a baseline, there are therefore $3-1=2$ coefficients for each variable.</span>

If you're wondering about the process: first `step` tries to
take out each explanatory variable, one at a time, from the starting
model (the one that contains all the variables). Then it finds the
best model out of those and fits it. (It doesn't tell us which model
this is, but evidently it's the one without gender.) Then it takes
*that* model and tries to remove its explanatory variables one at
a time (there are only three of them left). Having decided it cannot
remove any of them, it stops, and shows us what's left.

Leaving out the `trace=0` shows more output and more detail on
the process, but I figured this was enough (and this way, you don't
have to wade through all of that output). Try values like 1 or 2 for
`trace` and see what you get.

 


(h) Fit the model indicated by `step` (in the last part).

 
Solution

 Copy and paste, and take out the
variables you don't need. Or, better, save the output from
`step` in a variable. This then becomes a fitted model
object and you can look at it any of the ways you can look at a
model fit.  I found that gender needed to be removed, but if yours
is different, follow through with whatever your `step` said
to do.

```r
ess.2 <- multinom(party ~ agea + eduyrs + inwtm, data = ess.major)
```

```
## # weights:  15 (8 variable)
## initial  value 1343.602829 
## iter  10 value 1248.343563
## final  value 1248.253638 
## converged
```

   

If you saved the output from `step`, you'll already have this and you don't need to do it again:


```r
anova(ess.2, ess.2a)
```

```
## Likelihood ratio tests of Multinomial Models
## 
## Response: party
## Response: factor(prtvtgb)
##                   Model Resid. df Resid. Dev   Test    Df LR stat. Pr(Chi)
## 1 agea + eduyrs + inwtm      2438   2496.507                              
## 2 agea + eduyrs + inwtm      2438   2496.507 1 vs 2     0        0       1
```

 

Same model.
 


(i) I didn't think that interview length could possibly be
relevant to which party a person voted for. Test whether interview
length can be removed from your model of the last part. What do you
conclude? (Note that `step` and this test may disagree.)

 
Solution


Fit the model without `inwtm`:

```r
ess.3 <- multinom(party ~ agea + eduyrs, data = ess.major)
```

```
## # weights:  12 (6 variable)
## initial  value 1343.602829 
## iter  10 value 1250.418281
## final  value 1250.417597 
## converged
```

   

and then use `anova` to compare them:


```r
anova(ess.3, ess.2)
```

```
## Likelihood ratio tests of Multinomial Models
## 
## Response: party
##                   Model Resid. df Resid. Dev   Test    Df LR stat.   Pr(Chi)
## 1         agea + eduyrs      2440   2500.835                                
## 2 agea + eduyrs + inwtm      2438   2496.507 1 vs 2     2 4.327917 0.1148695
```

 

The P-value, 0.1149, is not small, which says that the smaller model
is good, ie.\ the one *without* interview length.

I thought `drop1` would also work here, but it appears not to:


```r
drop1(ess.1, test = "Chisq")
```

```
## trying - gndr
```

```
## Error in if (trace) {: argument is not interpretable as logical
```

 

I think that's a bug in `multinom`, since normally if
`step` works, then `drop1` will work too (normally
`step` *uses* `drop1`).

The reason for the disagreement between `step` and
`anova` is that `step` will tend to
keep marginal explanatory variables, that is, ones that are
"potentially interesting" but whose P-values might not be less than
0.05. There is still no substitute for your judgement in figuring out
what to do! `step` uses a thing called AIC to decide what to
do, rather than actually doing a test. If you know about 
"adjusted R-squared" in choosing explanatory variables for a 
regression, it's the same idea: a variable can be not quite
significant but still make the adjusted R-squared go up (typically
only a little).
 

(j) Use your best model to obtain predictions from some
suitably chosen combinations of values of the explanatory variables
that remain. (If you have quantitative explanatory variables left,
you could use their first and third quartiles as values to predict
from. Running `summary` on the data frame will get summaries
of all the variables.)
 
Solution


First make our new data frame of values to predict
from. `crossing` is our friend. You can use
`quantile` or `summary` to find the quartiles. I
only had `agea` and `eduyrs` left, having decided
that interview time really ought to come out:


```r
summary(ess.major)
```

```
##     prtvtgb           gndr            agea           eduyrs     
##  Min.   :1.000   Min.   :1.000   Min.   :18.00   Min.   : 0.00  
##  1st Qu.:1.000   1st Qu.:1.000   1st Qu.:44.00   1st Qu.:11.00  
##  Median :2.000   Median :2.000   Median :58.00   Median :13.00  
##  Mean   :1.803   Mean   :1.574   Mean   :57.19   Mean   :13.45  
##  3rd Qu.:2.000   3rd Qu.:2.000   3rd Qu.:71.00   3rd Qu.:16.00  
##  Max.   :3.000   Max.   :2.000   Max.   :94.00   Max.   :33.00  
##      inwtm       party  
##  Min.   :  7.0   1:484  
##  1st Qu.: 35.0   2:496  
##  Median : 41.0   3:243  
##  Mean   : 43.7          
##  3rd Qu.: 50.0          
##  Max.   :160.0
```

     

Quartiles for age are 44 and 71, and for years of education are 11 and 16:


```r
new <- crossing(agea = c(44, 71), eduyrs = c(11, 16))
new
```

```
## # A tibble: 4 x 2
##    agea eduyrs
##   <dbl>  <dbl>
## 1    44     11
## 2    44     16
## 3    71     11
## 4    71     16
```

     

Now we feed this into `predict`. An annoying feature of this
kind of prediction is that `type` may not be what you
expect. The best model is the one I called `ess.3`:


```r
pp <- predict(ess.3, new, type = "probs")
cbind(new, pp)
```

```
##   agea eduyrs         1         2         3
## 1   44     11 0.3331882 0.5093898 0.1574220
## 2   44     16 0.3471967 0.3955666 0.2572367
## 3   71     11 0.4551429 0.4085120 0.1363451
## 4   71     16 0.4675901 0.3127561 0.2196538
```

 
 

(k) What is the effect of increasing age? What is the effect of
an increase in years of education?
 
Solution


To assess the effect of age, hold years of education
constant. Thus, compare lines 1 and 3 (or 2 and 4):
increasing age tends to increase the chance that a person will
vote Conservative (party 1), and decrease the chance that a person
will vote Labour (party 2). There doesn't seem to be much effect
of age on the chance that a person will vote Liberal Democrat.

To assess education, hold age constant, and thus compare rows 1
and 2 (or rows 3 and 4). This time, there isn't much effect on the
chances of voting Conservative, but as education increases, the
chance of voting Labour goes down, and the chance of voting
Liberal Democrat goes up.

A little history: back 150 or so years ago, Britain had two
political parties, the Tories and the Whigs. The Tories became the
Conservative party (and hence, in Britain and in Canada, the
Conservatives are nicknamed Tories
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">It amuses me that      Toronto's current (2018) mayor is politically a Tory.</span>). The Whigs became Liberals. At
about the same time as 
working people got to vote (not women, yet, but working men) the
Labour Party came into existence. The Labour Party has always been
affiliated with working people and trades unions, like the NDP
here. But power has typically alternated between Conservative and
Labour goverments, with the Liberals as a third party. In the
1980s a new party called the Social Democrats came onto the scene,
but on realizing that they couldn't make much of a dent by
themselves, they merged with the Liberals to form the Liberal
Democrats, which became a slightly stronger third party.

I was curious about what the effect of interview length would
be. Presumably, the effect is small, but I have no idea which way
it would be. To assess this, it's the same idea over again: create
a new data frame with all combinations of `agea`,
`eduyrs` *and* `inwtm`. I need the quartiles of
interview time first:

```r
quantile(ess.major$inwtm)
```

```
##   0%  25%  50%  75% 100% 
##    7   35   41   50  160
```

     

and then


```r
ess.new <- crossing(agea = c(44, 71), eduyrs = c(11, 16), inwtm = c(35, 50))
ess.new
```

```
## # A tibble: 8 x 3
##    agea eduyrs inwtm
##   <dbl>  <dbl> <dbl>
## 1    44     11    35
## 2    44     11    50
## 3    44     16    35
## 4    44     16    50
## 5    71     11    35
## 6    71     11    50
## 7    71     16    35
## 8    71     16    50
```

 

and then predict *using the model that contained interview time*:


```r
pp <- predict(ess.2, ess.new, type = "probs")
cbind(ess.new, pp)
```

```
##   agea eduyrs inwtm         1         2         3
## 1   44     11    35 0.3455998 0.4993563 0.1550439
## 2   44     11    50 0.3139582 0.5240179 0.1620238
## 3   44     16    35 0.3606728 0.3872735 0.2520536
## 4   44     16    50 0.3284883 0.4074380 0.2640737
## 5   71     11    35 0.4810901 0.3886175 0.1302924
## 6   71     11    50 0.4455030 0.4157036 0.1387934
## 7   71     16    35 0.4945171 0.2968551 0.2086277
## 8   71     16    50 0.4589823 0.3182705 0.2227472
```

 

The effects of age and education are as they were before. A longer
interview time is associated with a slightly decreased chance of
voting Conservative and a slightly increased chance of voting
Labour. Compare, for example, lines 1 and 2. But, as we 
suspected, the effect is small and not really worth worrying about.
 




##  Alligator food


 What do alligators most like to eat? 219 alligators were captured
in four Florida lakes. Each alligator's stomach contents were
observed, and the food that the alligator had eaten  was classified
into one of five categories: fish, invertebrates (such as snails or
insects), reptiles (such as turtles), birds, and "other" (such as
amphibians, plants or rocks). The researcher noted for each alligator
what that alligator had most of in its stomach, as well as the gender
of each alligator and whether it was "large" or "small" (greater
or less than 2.3 metres in length). The data can be found in
[link](http://www.utsc.utoronto.ca/~butler/d29/alligator.txt). The
numbers in the data set (apart from the first column) are all
frequencies. (You can ignore that first column "profile".)

Our aim is to predict food type from the other variables.



(a) Read in the data and display the first few lines. Describe
how the data are not "tidy".


Solution


Separated by exactly one space:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/alligator.txt"
gators.orig <- read_delim(my_url, " ")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   profile = col_double(),
##   Gender = col_character(),
##   Size = col_character(),
##   Lake = col_character(),
##   Fish = col_double(),
##   Invertebrate = col_double(),
##   Reptile = col_double(),
##   Bird = col_double(),
##   Other = col_double()
## )
```

```r
gators.orig
```

```
## # A tibble: 16 x 9
##    profile Gender Size  Lake      Fish Invertebrate Reptile  Bird Other
##      <dbl> <chr>  <chr> <chr>    <dbl>        <dbl>   <dbl> <dbl> <dbl>
##  1       1 f      <2.3  george       3            9       1     0     1
##  2       2 m      <2.3  george      13           10       0     2     2
##  3       3 f      >2.3  george       8            1       0     0     1
##  4       4 m      >2.3  george       9            0       0     1     2
##  5       5 f      <2.3  hancock     16            3       2     2     3
##  6       6 m      <2.3  hancock      7            1       0     0     5
##  7       7 f      >2.3  hancock      3            0       1     2     3
##  8       8 m      >2.3  hancock      4            0       0     1     2
##  9       9 f      <2.3  oklawaha     3            9       1     0     2
## 10      10 m      <2.3  oklawaha     2            2       0     0     1
## 11      11 f      >2.3  oklawaha     0            1       0     1     0
## 12      12 m      >2.3  oklawaha    13            7       6     0     0
## 13      13 f      <2.3  trafford     2            4       1     1     4
## 14      14 m      <2.3  trafford     3            7       1     0     1
## 15      15 f      >2.3  trafford     0            1       0     0     0
## 16      16 m      >2.3  trafford     8            6       6     3     5
```

       

The last five columns are all frequencies. Or, one of the variables
(food type) is spread over five columns instead of being contained in
one. Either is good.

My choice of "temporary" name reflects that I'm going to obtain a
"tidy" data frame called `gators` in a moment.



(b) Use `pivot_longer` to arrange the data
suitably for analysis (which will be using
`multinom`). Demonstrate (by looking at the first few rows
of your new data frame) that you now have something tidy.


Solution


I'm creating my "official" data frame here:


```r
gators.orig %>% 
  pivot_longer(Fish:Other, names_to = "Food.type", values_to = "Frequency") -> gators
gators
```

```
## # A tibble: 80 x 6
##    profile Gender Size  Lake   Food.type    Frequency
##      <dbl> <chr>  <chr> <chr>  <chr>            <dbl>
##  1       1 f      <2.3  george Fish                 3
##  2       1 f      <2.3  george Invertebrate         9
##  3       1 f      <2.3  george Reptile              1
##  4       1 f      <2.3  george Bird                 0
##  5       1 f      <2.3  george Other                1
##  6       2 m      <2.3  george Fish                13
##  7       2 m      <2.3  george Invertebrate        10
##  8       2 m      <2.3  george Reptile              0
##  9       2 m      <2.3  george Bird                 2
## 10       2 m      <2.3  george Other                2
## # … with 70 more rows
```


       
I gave my
column names Capital Letters to make them consistent with the others
(and in an attempt to stop infesting my brain with annoying
variable-name errors when I fit models later).

Looking at the first few lines reveals that I now have a column of
food types and one column of frequencies, both of which are what I
wanted. I can check that I have all the different food types by
finding the distinct ones:


```r
gators %>% distinct(Food.type)
```

```
## # A tibble: 5 x 1
##   Food.type   
##   <chr>       
## 1 Fish        
## 2 Invertebrate
## 3 Reptile     
## 4 Bird        
## 5 Other
```

 

(Think about why `count` would be confusing here.)

Note that `Food.type` is text (`chr`) rather than being a
factor. I'll hold my breath and see what happens when I fit a model
where it is supposed to be a factor.



(c) What is different about this problem, compared to
Question <a href="#q:abortion">here</a>, that would make 
`multinom` the right tool to use?


Solution


Look at the response variable `Food.type` (or whatever
you called it): this has multiple categories, but they are
*not ordered* in any logical way. Thus, in short, a nominal
response. 



(d) Fit a suitable multinomial model predicting food type from
gender, size and lake. Does each row represent one alligator or more
than one? If more than one, account for this in your modelling.


Solution


Each row of the tidy `gators` represents as many
alligators as are in the `Frequency` column. That is, if
you look at female small alligators in Lake George that ate
mainly fish, there are three of those.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">When you have variables that are categories, you might have more than one individual with exactly the same categories; on the other hand, if they had measured *Size* as, say, length in centimetres, it would have been very unlikely to get two alligators of exactly the same size.</span>
This to remind you to include the `weights` piece,
otherwise `multinom` will assume that you have *one*
observation per line and not as many as the number in
`Frequency`.

*That* is the
reason that `count` earlier would have been confusing:
it would have told you how many *rows* contained each
food type, rather than how many *alligators*, and these
would have been different:

```r
gators %>% count(Food.type)
```

```
## # A tibble: 5 x 2
##   Food.type        n
##   <chr>        <int>
## 1 Bird            16
## 2 Fish            16
## 3 Invertebrate    16
## 4 Other           16
## 5 Reptile         16
```

```r
gators %>% count(Food.type, wt = Frequency)
```

```
## # A tibble: 5 x 2
##   Food.type        n
##   <chr>        <dbl>
## 1 Bird            13
## 2 Fish            94
## 3 Invertebrate    61
## 4 Other           32
## 5 Reptile         19
```

         

Each food type appears on 16 rows, but is the favoured diet of very
different numbers of *alligators*. Note the use of `wt=`
to specify a frequency variable.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">Discovered by me two minutes  ago.</span>

You ought to understand *why* those are different.

All right, back to modelling:


```r
library(nnet)
gators.1 <- multinom(Food.type ~ Gender + Size + Lake,
  weights = Frequency, data = gators
)
```

```
## # weights:  35 (24 variable)
## initial  value 352.466903 
## iter  10 value 270.228588
## iter  20 value 268.944257
## final  value 268.932741 
## converged
```

       

This worked, even though `Food.type` was actually text. I guess
it got converted to a factor. The ordering of the levels doesn't
matter here anyway, since this is not an ordinal model.

No need to look at it, since the output is kind of confusing anyway: 

```r
summary(gators.1)
```

```
## Call:
## multinom(formula = Food.type ~ Gender + Size + Lake, data = gators, 
##     weights = Frequency)
## 
## Coefficients:
##              (Intercept)     Genderm   Size>2.3 Lakehancock Lakeoklawaha
## Fish           2.4322304  0.60674971 -0.7308535  -0.5751295    0.5513785
## Invertebrate   2.6012531  0.14378459 -2.0671545  -2.3557377    1.4645820
## Other          1.0014505  0.35423803 -1.0214847   0.1914537    0.5775317
## Reptile       -0.9829064 -0.02053375 -0.1741207   0.5534169    3.0807416
##              Laketrafford
## Fish          -1.23681053
## Invertebrate  -0.08096493
## Other          0.32097943
## Reptile        1.82333205
## 
## Std. Errors:
##              (Intercept)   Genderm  Size>2.3 Lakehancock Lakeoklawaha
## Fish           0.7706940 0.6888904 0.6523273   0.7952147     1.210229
## Invertebrate   0.7917210 0.7292510 0.7084028   0.9463640     1.232835
## Other          0.8747773 0.7623738 0.7250455   0.9072182     1.374545
## Reptile        1.2827234 0.9088217 0.8555051   1.3797755     1.591542
##              Laketrafford
## Fish            0.8661187
## Invertebrate    0.8814625
## Other           0.9589807
## Reptile         1.3388017
## 
## Residual Deviance: 537.8655 
## AIC: 585.8655
```

 

You get one coefficient for each variable (along the top) and for each
response group (down the side), using the first group as a baseline
everywhere. These numbers are hard to interpret; doing predictions is
much easier.



(e) Do a test to see whether `Gender` should stay in
the model. (This will entail fitting another model.) What do you conclude?


Solution


The other model to fit is the one *without* the variable
you're testing:

```r
gators.2 <- update(gators.1, . ~ . - Gender)
```

```
## # weights:  30 (20 variable)
## initial  value 352.466903 
## iter  10 value 272.246275
## iter  20 value 270.046891
## final  value 270.040139 
## converged
```

       

I did `update` here to show you that it works, but of course
there's no problem in just writing out the whole model again and
taking out `Gender`, preferably by copying and pasting:


```r
gators.2x <- multinom(Food.type ~ Size + Lake,
  weights = Frequency, data = gators
)
```

```
## # weights:  30 (20 variable)
## initial  value 352.466903 
## iter  10 value 272.246275
## iter  20 value 270.046891
## final  value 270.040139 
## converged
```

 

and then you compare the models with and without `Gender` using `anova`:


```r
anova(gators.2, gators.1)
```

```
## Likelihood ratio tests of Multinomial Models
## 
## Response: Food.type
##                  Model Resid. df Resid. Dev   Test    Df LR stat.   Pr(Chi)
## 1          Size + Lake       300   540.0803                                
## 2 Gender + Size + Lake       296   537.8655 1 vs 2     4 2.214796 0.6963214
```

 

The P-value is not small, so the two models fit equally well, and
therefore we should go with the smaller, simpler one: that is, the one
without `Gender`.

Sometimes `drop1` works here too (and sometimes it doesn't, for
reasons I haven't figured out):


```r
drop1(gators.1, test = "Chisq")
```

```
## trying - Gender
```

```
## Error in if (trace) {: argument is not interpretable as logical
```

 

I don't even know what this error message means, never mind what to do
about it.



(f) Predict the probability that an alligator
prefers each food type, given its size, gender (if necessary) and
the lake it was found 
in, using the more appropriate of the two models that you have
fitted so far.  This means (i) obtaining all the sizes and lake
names, (ii) 
making a data frame for prediction, and (iii) obtaining and
displaying the predicted probabilities.


Solution


To get the different categories, use `distinct` and `pull`:

```r
Lakes <- gators %>% distinct(Lake) %>% pull(Lake)
Lakes
```

```
## [1] "george"   "hancock"  "oklawaha" "trafford"
```

```r
Sizes <- gators %>% distinct(Size) %>% pull(Size)
Sizes
```

```
## [1] "<2.3" ">2.3"
```

    

I didn't need to think about `Genders` because that's not in
the better model. See below for what happens if you include it
anyway. 

I have persisted with the Capital Letters, for consistency.

Next, a data frame for predicting from, using `crossing`,
and called, as per my tradition, `new`:


```r
new <- crossing(Lake = Lakes, Size = Sizes)
new
```

```
## # A tibble: 8 x 2
##   Lake     Size 
##   <chr>    <chr>
## 1 george   <2.3 
## 2 george   >2.3 
## 3 hancock  <2.3 
## 4 hancock  >2.3 
## 5 oklawaha <2.3 
## 6 oklawaha >2.3 
## 7 trafford <2.3 
## 8 trafford >2.3
```

 

and then, obtain the predictions and glue them onto the data frame of
values for which they are predictions. Don't forget to use the second
model, the one without `Gender`. If you do forget, you'll get
an error anyway, because your data frame of values to predict from
doesn't have any `Gender` in it:


```r
pp <- predict(gators.2, new, type = "p")
preds1 <- cbind(new, pp)
preds1
```

```
##       Lake Size        Bird      Fish Invertebrate      Other    Reptile
## 1   george <2.3 0.029671502 0.4521032   0.41285699 0.09380190 0.01156641
## 2   george >2.3 0.081071082 0.6574394   0.13967877 0.09791193 0.02389880
## 3  hancock <2.3 0.070400215 0.5353040   0.09309885 0.25374163 0.04745531
## 4  hancock >2.3 0.140898571 0.5701968   0.02307179 0.19400899 0.07182382
## 5 oklawaha <2.3 0.008818267 0.2581872   0.60189518 0.05387241 0.07722691
## 6 oklawaha >2.3 0.029419560 0.4584368   0.24864408 0.06866206 0.19483754
## 7 trafford <2.3 0.035892547 0.1842997   0.51683770 0.17420330 0.08876673
## 8 trafford >2.3 0.108222209 0.2957526   0.19296148 0.20066241 0.20240133
```

 

Success. You won't get this right the first time. I certainly didn't.
Anyway, these are the correct predictions that I discuss later.

If you thought that the better model was the one with `Gender`
in it, or you otherwise forgot that you didn't need `Gender`
then you needed to do something like this as well:


```r
Genders <- gators %>% distinct(Gender) %>% pull(Gender)
new <- crossing(Lake = Lakes, Size = Sizes, Gender = Genders)
new
```

```
## # A tibble: 16 x 3
##    Lake     Size  Gender
##    <chr>    <chr> <chr> 
##  1 george   <2.3  f     
##  2 george   <2.3  m     
##  3 george   >2.3  f     
##  4 george   >2.3  m     
##  5 hancock  <2.3  f     
##  6 hancock  <2.3  m     
##  7 hancock  >2.3  f     
##  8 hancock  >2.3  m     
##  9 oklawaha <2.3  f     
## 10 oklawaha <2.3  m     
## 11 oklawaha >2.3  f     
## 12 oklawaha >2.3  m     
## 13 trafford <2.3  f     
## 14 trafford <2.3  m     
## 15 trafford >2.3  f     
## 16 trafford >2.3  m
```

 

If you predict this in the model *without* `Gender`, you'll get
the following:


```r
pp <- predict(gators.2, new, type = "p")
cbind(new, pp)
```

```
##        Lake Size Gender        Bird      Fish Invertebrate      Other
## 1    george <2.3      f 0.029671502 0.4521032   0.41285699 0.09380190
## 2    george <2.3      m 0.029671502 0.4521032   0.41285699 0.09380190
## 3    george >2.3      f 0.081071082 0.6574394   0.13967877 0.09791193
## 4    george >2.3      m 0.081071082 0.6574394   0.13967877 0.09791193
## 5   hancock <2.3      f 0.070400215 0.5353040   0.09309885 0.25374163
## 6   hancock <2.3      m 0.070400215 0.5353040   0.09309885 0.25374163
## 7   hancock >2.3      f 0.140898571 0.5701968   0.02307179 0.19400899
## 8   hancock >2.3      m 0.140898571 0.5701968   0.02307179 0.19400899
## 9  oklawaha <2.3      f 0.008818267 0.2581872   0.60189518 0.05387241
## 10 oklawaha <2.3      m 0.008818267 0.2581872   0.60189518 0.05387241
## 11 oklawaha >2.3      f 0.029419560 0.4584368   0.24864408 0.06866206
## 12 oklawaha >2.3      m 0.029419560 0.4584368   0.24864408 0.06866206
## 13 trafford <2.3      f 0.035892547 0.1842997   0.51683770 0.17420330
## 14 trafford <2.3      m 0.035892547 0.1842997   0.51683770 0.17420330
## 15 trafford >2.3      f 0.108222209 0.2957526   0.19296148 0.20066241
## 16 trafford >2.3      m 0.108222209 0.2957526   0.19296148 0.20066241
##       Reptile
## 1  0.01156641
## 2  0.01156641
## 3  0.02389880
## 4  0.02389880
## 5  0.04745531
## 6  0.04745531
## 7  0.07182382
## 8  0.07182382
## 9  0.07722691
## 10 0.07722691
## 11 0.19483754
## 12 0.19483754
## 13 0.08876673
## 14 0.08876673
## 15 0.20240133
## 16 0.20240133
```

 

Here, the predictions for each gender are *exactly the same*,
because not having `Gender` in the model means that we take its
effect to be *exactly zero*.

Alternatively, if you really thought the model with `Gender` was the
better one, then you'd do this:


```r
pp <- predict(gators.1, new, type = "p")
cbind(new, pp)
```

```
##        Lake Size Gender        Bird      Fish Invertebrate      Other
## 1    george <2.3      f 0.034528820 0.3930846   0.46546988 0.09399531
## 2    george <2.3      m 0.023983587 0.5008716   0.37330933 0.09304268
## 3    george >2.3      f 0.105463159 0.5780952   0.17991064 0.10337131
## 4    george >2.3      m 0.067888065 0.6826531   0.13371938 0.09482794
## 5   hancock <2.3      f 0.079170901 0.5071007   0.10120258 0.26099808
## 6   hancock <2.3      m 0.051120681 0.6006664   0.07545143 0.24016625
## 7   hancock >2.3      f 0.167234031 0.5157600   0.02705184 0.19850489
## 8   hancock >2.3      m 0.110233536 0.6236556   0.02058879 0.18646783
## 9  oklawaha <2.3      f 0.010861171 0.2146058   0.63335376 0.05267686
## 10 oklawaha <2.3      m 0.008370118 0.3033923   0.56356778 0.05785201
## 11 oklawaha >2.3      f 0.037755986 0.3592072   0.27861325 0.06593316
## 12 oklawaha >2.3      m 0.027647882 0.4825354   0.23557146 0.06880557
## 13 trafford <2.3      f 0.043846177 0.1449092   0.54510349 0.16453404
## 14 trafford <2.3      m 0.034440739 0.2088069   0.49438416 0.18417900
## 15 trafford >2.3      f 0.133999340 0.2132364   0.21081238 0.18105124
## 16 trafford >2.3      m 0.104507582 0.3050805   0.18983929 0.20122886
##        Reptile
## 1  0.012921439
## 2  0.008792768
## 3  0.033159675
## 4  0.020911502
## 5  0.051527690
## 6  0.032595228
## 7  0.091449234
## 8  0.059054291
## 9  0.088502364
## 10 0.066817794
## 11 0.258490381
## 12 0.185439712
## 13 0.101607074
## 14 0.078189237
## 15 0.260900674
## 16 0.199343761
```

 

and this time there *is* an effect of gender, but it is
smallish, as befits an effect that is not significant.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">There were only 216 alligators total, which is a small sample size for this kind of thing, especially with all those parameters to estimate.</span>
    


(g) What do you think is the most important way in which the
lakes differ? (Hint: look at where the biggest predicted
probabilities are.)


Solution


Here are the predictions again:

```r
preds1
```

```
##       Lake Size        Bird      Fish Invertebrate      Other    Reptile
## 1   george <2.3 0.029671502 0.4521032   0.41285699 0.09380190 0.01156641
## 2   george >2.3 0.081071082 0.6574394   0.13967877 0.09791193 0.02389880
## 3  hancock <2.3 0.070400215 0.5353040   0.09309885 0.25374163 0.04745531
## 4  hancock >2.3 0.140898571 0.5701968   0.02307179 0.19400899 0.07182382
## 5 oklawaha <2.3 0.008818267 0.2581872   0.60189518 0.05387241 0.07722691
## 6 oklawaha >2.3 0.029419560 0.4584368   0.24864408 0.06866206 0.19483754
## 7 trafford <2.3 0.035892547 0.1842997   0.51683770 0.17420330 0.08876673
## 8 trafford >2.3 0.108222209 0.2957526   0.19296148 0.20066241 0.20240133
```

       
Following my own hint: the preferred diet in George and Hancock lakes
is fish, but the preferred diet in Oklawaha and Trafford lakes is (at
least sometimes) invertebrates. That is to say, the preferred diet in
those last two lakes is less likely to be invertebrates than it is in
the first two (comparing for alligators of the same size).  This is
true for both large and small alligators, as it should be, since there
is no interaction in the model.
That will do, though you can also note that reptiles are more
commonly found in the last two lakes, and birds sometimes appear
in the diet in Hancock and Trafford but rarely in the other two
lakes. 

Another way to think about this is to hold size constant and
compare lakes (and then check that it applies to the other size
too). In this case, you'd find the biggest predictions among the
first four rows, and then check that the pattern persists in the
second four rows. (It does.)

I think looking at predicted probabilities like this is the
easiest way to see what the model is telling you. I also think
that having a consistent recipe for doing predictions makes the
process require a good deal less thought: get the values you
want to predict for and store them in vectors with plural names;
create a data frame for prediction using `crossing`,
where the things inside are all "singular=plural"; run
`predict` with model, new data and (if needed) type of
value to predict, glue the predictions onto the new data.

If you somehow mess up the creation of your new data frame (this
typically happens by forgetting a variable that you should have
included, or giving it the wrong name), `predict` will
*silently* use the *original data* to predict
from. Your only warning that this has happened is the size of
the output; it should have as many rows as `new` did
above, and the original data will typically have many
more. (This happened to me just now. I recognized what the
problem was, and how I would be able to fix it.)
    


(h) How would you describe the major difference between the
diets of the small and large alligators?


Solution


Same idea: hold lake constant, and compare small and large, then
check that your conclusion holds for the other lakes as it should.
For example, in George Lake, the large alligators are more
likely to eat fish, and less likely to eat invertebrates,
compared to the small ones. The other food types are not that
much different, though you might also note that birds appear
more in the diets of large alligators than small ones. 
Does that hold in the other lakes? I think so, though there is
less difference for fish in Hancock lake than the others (where
invertebrates are rare for both sizes). Birds don't commonly
appear in any alligator's diets, but where they do, they are
commoner for large alligators than small ones.
    





##  How do you like your steak -- the data


  <a name="q:steak-data">*</a> 
This question takes you through the data preparation for one
of the other questions. You don't have to do *this*
question, but you may find it interesting or useful.

When you order a steak in a restaurant, the server will ask
you how you would like it cooked, or to be precise, *how much*
you would like it cooked: rare (hardly cooked at all), through medium
rare, medium, medium well to well (which means "well done", so that
the meat has only a little red to it). Could you guess how a person
likes their steak cooked, from some other information about them? The
website [link](fivethirtyeight.com) commissioned a survey where they
asked a number of people how they preferred their steak, along with as
many other things as they could think of to ask. (Many of the
variables below are related to risk-taking, which was something the
people designing the survey thought might have something to do with
liking steak rare.) The variables of interest are all factors or true/false:



* `respondent_ID`: a ten-digit number identifying each
person who responded to the survey.

* `lottery_a`: true if the respondent preferred lottery A
with a small chance to win a lot of money, to lottery B, with a
larger chance to win less money.

* `smoke`: true if the respondent is currently a smoker

* `alcohol`: true if the respondent at least occasionally
drinks alcohol.

* `gamble`: true if the respondent likes to gamble (eg.
betting on horse racing or playing the lottery)

* `skydiving`: true if the respondent has ever been
skydiving.

* `speed`: true if the respondent likes to drive fast

* `cheated`: true if the respondent has ever cheated on a
spouse or girlfriend/boyfriend

* `steak`: true if the respondent likes to eat steak

* `steak_prep` (response): how the respondent likes their
steak cooked (factor, as described above, with 5 levels).

* `female`: true if the respondent is female

* `age`: age group, from 18--29 to 60+.

* `hhold_income`: household income group, from \$0--24,999
to \$150,000+.

* `educ`: highest level of education attained, from 
"less  than high school" 
up to "graduate degree"

* `region`: region (of the US)
that the respondent lives in (five values).


The data are in
[link](http://www.utsc.utoronto.ca/~butler/d29/steak.csv). 



(a) Read in the data and display the first few lines.


Solution


The usual:


```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/steak.csv"
steak0 <- read_csv(my_url)
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   respondent_id = col_double(),
##   lottery_a = col_logical(),
##   smoke = col_logical(),
##   alcohol = col_logical(),
##   gamble = col_logical(),
##   skydiving = col_logical(),
##   speed = col_logical(),
##   cheated = col_logical(),
##   steak = col_logical(),
##   steak_prep = col_character(),
##   female = col_logical(),
##   age = col_character(),
##   hhold_income = col_character(),
##   educ = col_character(),
##   region = col_character()
## )
```

```r
steak0
```

```
## # A tibble: 550 x 15
##    respondent_id lottery_a smoke alcohol gamble skydiving speed cheated steak
##            <dbl> <lgl>     <lgl> <lgl>   <lgl>  <lgl>     <lgl> <lgl>   <lgl>
##  1    3237565956 FALSE     NA    NA      NA     NA        NA    NA      NA   
##  2    3234982343 TRUE      FALSE TRUE    FALSE  FALSE     FALSE FALSE   TRUE 
##  3    3234973379 TRUE      FALSE TRUE    TRUE   FALSE     TRUE  TRUE    TRUE 
##  4    3234972383 FALSE     TRUE  TRUE    TRUE   FALSE     TRUE  TRUE    TRUE 
##  5    3234958833 FALSE     FALSE TRUE    FALSE  FALSE     TRUE  TRUE    TRUE 
##  6    3234955240 TRUE      FALSE FALSE   FALSE  FALSE     TRUE  FALSE   TRUE 
##  7    3234955097 TRUE      FALSE TRUE    FALSE  FALSE     TRUE  TRUE    FALSE
##  8    3234955010 TRUE      FALSE TRUE    TRUE   TRUE      TRUE  FALSE   TRUE 
##  9    3234953052 TRUE      TRUE  TRUE    TRUE   FALSE     TRUE  FALSE   TRUE 
## 10    3234951249 FALSE     FALSE TRUE    TRUE   FALSE     FALSE FALSE   TRUE 
## # … with 540 more rows, and 6 more variables: steak_prep <chr>, female <lgl>,
## #   age <chr>, hhold_income <chr>, educ <chr>, region <chr>
```

 

I'm using a temporary name for reasons that will become clear shortly.



(b) What do you immediately notice about your data frame? Run `summary` on the entire data frame. Would you say you have a lot of missing values, or only a few?

Solution


I see missing values, starting in the very first row.
Running the data frame through `summary` gives this, either as `summary(steak0)` or this way:

```r
steak0 %>% summary()
```

```
##  respondent_id       lottery_a         smoke          alcohol       
##  Min.   :3.235e+09   Mode :logical   Mode :logical   Mode :logical  
##  1st Qu.:3.235e+09   FALSE:279       FALSE:453       FALSE:125      
##  Median :3.235e+09   TRUE :267       TRUE :84        TRUE :416      
##  Mean   :3.235e+09   NA's :4         NA's :13        NA's :9        
##  3rd Qu.:3.235e+09                                                  
##  Max.   :3.238e+09                                                  
##    gamble        skydiving         speed          cheated       
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:280       FALSE:502       FALSE:59        FALSE:447      
##  TRUE :257       TRUE :36        TRUE :480       TRUE :92       
##  NA's :13        NA's :12        NA's :11        NA's :11       
##                                                                 
##                                                                 
##    steak          steak_prep          female            age           
##  Mode :logical   Length:550         Mode :logical   Length:550        
##  FALSE:109       Class :character   FALSE:246       Class :character  
##  TRUE :430       Mode  :character   TRUE :268       Mode  :character  
##  NA's :11                           NA's :36                          
##                                                                       
##                                                                       
##  hhold_income           educ              region         
##  Length:550         Length:550         Length:550        
##  Class :character   Class :character   Class :character  
##  Mode  :character   Mode  :character   Mode  :character  
##                                                          
##                                                          
## 
```

     

Make a call about whether you think that's a lot of missing values or only a few. This might not be all of them, because missing text doesn't show here (we see later how to make it show up).


(c) What does the function `drop_na` do when applied to a data frame with missing values? To find out, pass the data frame into `drop_na()`, then into `summary` again. What has happened?

Solution


Let's try it and see.


```r
steak0 %>% drop_na() %>% summary()
```

```
##  respondent_id       lottery_a         smoke          alcohol       
##  Min.   :3.235e+09   Mode :logical   Mode :logical   Mode :logical  
##  1st Qu.:3.235e+09   FALSE:171       FALSE:274       FALSE:65       
##  Median :3.235e+09   TRUE :160       TRUE :57        TRUE :266      
##  Mean   :3.235e+09                                                  
##  3rd Qu.:3.235e+09                                                  
##  Max.   :3.235e+09                                                  
##    gamble        skydiving         speed          cheated         steak        
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode:logical  
##  FALSE:158       FALSE:308       FALSE:28        FALSE:274       TRUE:331      
##  TRUE :173       TRUE :23        TRUE :303       TRUE :57                      
##                                                                                
##                                                                                
##                                                                                
##   steak_prep          female            age            hhold_income      
##  Length:331         Mode :logical   Length:331         Length:331        
##  Class :character   FALSE:174       Class :character   Class :character  
##  Mode  :character   TRUE :157       Mode  :character   Mode  :character  
##                                                                          
##                                                                          
##                                                                          
##      educ              region         
##  Length:331         Length:331        
##  Class :character   Class :character  
##  Mode  :character   Mode  :character  
##                                       
##                                       
## 
```

 

The missing values, the ones we can see anyway, have all gone. Precisely, `drop_na`, as its
name suggests, drops all the rows that have missing values in them
anywhere. This is potentially wasteful, since a row might be missing
only one value, and we drop the entire rest of the row, throwing away
the good data as well. If you check, we started with 550 rows, and we
now have only 311 left. Ouch.

So now we'll save this into our "good" data frame, which means doing it again (now that we know it works):


```r
steak0 %>% drop_na() -> steak
```

 

Extra: another way to handle missing data is called "imputation":
what you do is to *estimate* a value for any missing data, and
then use that later on as if it were the truth. One way of estimating
missing values is to do a regression (of appropriate kind: regular or
logistic) to predict a column with missing values from all the other
columns.

Extra extra: below we see how we used to have to do this, for your information.

First, we run `complete.cases` on the data frame:


```r
complete.cases(steak0)
```

```
##   [1] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE
##  [13]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE  TRUE
##  [25]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE
##  [37]  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE  TRUE
##  [49]  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE
##  [61] FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE
##  [73] FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE
##  [85] FALSE  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE  TRUE
##  [97]  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE
## [109] FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE
## [121]  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE
## [133] FALSE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
## [145]  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
## [157]  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
## [169]  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE
## [181] FALSE  TRUE FALSE FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE
## [193]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE
## [205]  TRUE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE
## [217] FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE
## [229]  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
## [241]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE  TRUE FALSE  TRUE
## [253] FALSE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE
## [265] FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE
## [277]  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
## [289]  TRUE FALSE FALSE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE
## [301] FALSE  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE
## [313]  TRUE FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE
## [325] FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE
## [337]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE
## [349] FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE
## [361] FALSE  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE
## [373] FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE
## [385]  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE
## [397]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE
## [409]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE FALSE
## [421]  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE
## [433]  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE FALSE
## [445]  TRUE  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE  TRUE
## [457]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE
## [469]  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE
## [481] FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE  TRUE FALSE
## [493] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE
## [505]  TRUE FALSE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE
## [517]  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE
## [529] FALSE FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE
## [541] FALSE FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE
```

 

You might be able to guess what this does, in the light of what we
just did, but if not, you can investigate. Let's pick three rows where
`complete.cases` is 
`TRUE` and three where it's
`FALSE`, and see what happens.

I'll pick rows 496, 497, and 498 for the TRUE rows, and 540, 541 and
542 for the FALSE ones. Let's assemble these rows into a vector and
use `slice` to display the rows with these numbers:


```r
rows <- c(496, 497, 498, 540, 541, 542)
rows
```

```
## [1] 496 497 498 540 541 542
```

 

Like this:


```r
steak0 %>% slice(rows)
```

```
## # A tibble: 6 x 15
##   respondent_id lottery_a smoke alcohol gamble skydiving speed cheated steak
##           <dbl> <lgl>     <lgl> <lgl>   <lgl>  <lgl>     <lgl> <lgl>   <lgl>
## 1    3234776895 FALSE     FALSE FALSE   FALSE  FALSE     FALSE FALSE   TRUE 
## 2    3234776815 TRUE      TRUE  TRUE    FALSE  FALSE     TRUE  FALSE   TRUE 
## 3    3234776702 FALSE     FALSE FALSE   FALSE  FALSE     FALSE FALSE   TRUE 
## 4    3234763650 TRUE      FALSE FALSE   FALSE  FALSE     TRUE  FALSE   FALSE
## 5    3234763171 TRUE      FALSE TRUE    TRUE   FALSE     TRUE  FALSE   TRUE 
## 6    3234762715 FALSE     FALSE FALSE   FALSE  FALSE     TRUE  FALSE   FALSE
## # … with 6 more variables: steak_prep <chr>, female <lgl>, age <chr>,
## #   hhold_income <chr>, educ <chr>, region <chr>
```

 

What's the difference? 
The rows where `complete.cases` is FALSE have one (or more)
missing values in them; where `complete.cases` is TRUE the
rows have no missing values. (Depending on the rows you choose,
you may not see the missing value(s), as I didn't.)
Extra (within "extra extra": I hope you are keeping track): this
is a bit tricky to investigate more thoroughly, because the text
variables might have missing values in them, and they won't show
up unless we turn them into a factor first:

```r
steak0 %>%
  mutate_if(is.character, factor) %>%
  summary()
```

```
##  respondent_id       lottery_a         smoke          alcohol       
##  Min.   :3.235e+09   Mode :logical   Mode :logical   Mode :logical  
##  1st Qu.:3.235e+09   FALSE:279       FALSE:453       FALSE:125      
##  Median :3.235e+09   TRUE :267       TRUE :84        TRUE :416      
##  Mean   :3.235e+09   NA's :4         NA's :13        NA's :9        
##  3rd Qu.:3.235e+09                                                  
##  Max.   :3.238e+09                                                  
##                                                                     
##    gamble        skydiving         speed          cheated       
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical  
##  FALSE:280       FALSE:502       FALSE:59        FALSE:447      
##  TRUE :257       TRUE :36        TRUE :480       TRUE :92       
##  NA's :13        NA's :12        NA's :11        NA's :11       
##                                                                 
##                                                                 
##                                                                 
##    steak               steak_prep    female           age     
##  Mode :logical   Medium     :132   Mode :logical   >60  :131  
##  FALSE:109       Medium rare:166   FALSE:246       18-29:110  
##  TRUE :430       Medium Well: 75   TRUE :268       30-44:133  
##  NA's :11        Rare       : 23   NA's :36        45-60:140  
##                  Well       : 36                   NA's : 36  
##                  NA's       :118                              
##                                                               
##               hhold_income                               educ    
##  $0 - $24,999       : 51   Bachelor degree                 :174  
##  $100,000 - $149,999: 76   Graduate degree                 :133  
##  $150,000+          : 54   High school degree              : 39  
##  $25,000 - $49,999  : 77   Less than high school degree    :  2  
##  $50,000 - $99,999  :172   Some college or Associate degree:164  
##  NA's               :120   NA's                            : 38  
##                                                                  
##                 region   
##  Pacific           : 91  
##  South Atlantic    : 88  
##  East North Central: 86  
##  Middle Atlantic   : 72  
##  West North Central: 42  
##  (Other)           :133  
##  NA's              : 38
```

     

There are missing values everywhere. What the `_if` functions
do is to do something for each column where the first thing is true:
here, if the column is text, then replace it by the factor version of
itself. This makes for a better summary, one that shows how many
observations are in each category, and, more important for us, how
many are missing (a lot).

All right, so there are 15 columns, so let's investigate missingness
in our rows by looking at the columns 1 through 8 and then 9 through
15, so they all fit on the screen. Recall that you can `select`
columns by number:


```r
steak0 %>% select(1:8) %>% slice(rows)
```

```
## # A tibble: 6 x 8
##   respondent_id lottery_a smoke alcohol gamble skydiving speed cheated
##           <dbl> <lgl>     <lgl> <lgl>   <lgl>  <lgl>     <lgl> <lgl>  
## 1    3234776895 FALSE     FALSE FALSE   FALSE  FALSE     FALSE FALSE  
## 2    3234776815 TRUE      TRUE  TRUE    FALSE  FALSE     TRUE  FALSE  
## 3    3234776702 FALSE     FALSE FALSE   FALSE  FALSE     FALSE FALSE  
## 4    3234763650 TRUE      FALSE FALSE   FALSE  FALSE     TRUE  FALSE  
## 5    3234763171 TRUE      FALSE TRUE    TRUE   FALSE     TRUE  FALSE  
## 6    3234762715 FALSE     FALSE FALSE   FALSE  FALSE     TRUE  FALSE
```

 

and


```r
steak0 %>% select(9:15) %>% slice(rows)
```

```
## # A tibble: 6 x 7
##   steak steak_prep  female age   hhold_income     educ               region     
##   <lgl> <chr>       <lgl>  <chr> <chr>            <chr>              <chr>      
## 1 TRUE  Medium rare TRUE   45-60 $0 - $24,999     Some college or A… West South…
## 2 TRUE  Medium      TRUE   45-60 $150,000+        Bachelor degree    New England
## 3 TRUE  Medium rare TRUE   >60   $50,000 - $99,9… Graduate degree    Mountain   
## 4 FALSE <NA>        FALSE  45-60 $100,000 - $149… Some college or A… South Atla…
## 5 TRUE  Medium      FALSE  >60   <NA>             Graduate degree    Pacific    
## 6 FALSE <NA>        FALSE  18-29 $50,000 - $99,9… Some college or A… West North…
```

 

In this case, the first three rows have no missing values anywhere,
and the last three rows have exactly one missing value. This
corresponds to what we would expect, with `complete.cases`
identifying rows that have any missing values.

What we now need to do is to obtain a data frame that contains only
the rows with non-missing values. This can be done by saving the
result of `complete.cases` in a variable first; `filter`
can take anything that produces a true or a false for each row, and
will return the rows for which the thing it was fed was true.

```r
cc <- complete.cases(steak0)
steak0 %>% filter(cc) -> steak.complete
```

     

A quick check that we got rid of the missing values:


```r
steak.complete
```

```
## # A tibble: 331 x 15
##    respondent_id lottery_a smoke alcohol gamble skydiving speed cheated steak
##            <dbl> <lgl>     <lgl> <lgl>   <lgl>  <lgl>     <lgl> <lgl>   <lgl>
##  1    3234982343 TRUE      FALSE TRUE    FALSE  FALSE     FALSE FALSE   TRUE 
##  2    3234973379 TRUE      FALSE TRUE    TRUE   FALSE     TRUE  TRUE    TRUE 
##  3    3234972383 FALSE     TRUE  TRUE    TRUE   FALSE     TRUE  TRUE    TRUE 
##  4    3234958833 FALSE     FALSE TRUE    FALSE  FALSE     TRUE  TRUE    TRUE 
##  5    3234955240 TRUE      FALSE FALSE   FALSE  FALSE     TRUE  FALSE   TRUE 
##  6    3234955010 TRUE      FALSE TRUE    TRUE   TRUE      TRUE  FALSE   TRUE 
##  7    3234953052 TRUE      TRUE  TRUE    TRUE   FALSE     TRUE  FALSE   TRUE 
##  8    3234951249 FALSE     FALSE TRUE    TRUE   FALSE     FALSE FALSE   TRUE 
##  9    3234948883 FALSE     FALSE TRUE    FALSE  FALSE     TRUE  FALSE   TRUE 
## 10    3234948197 TRUE      FALSE FALSE   TRUE   FALSE     TRUE  FALSE   TRUE 
## # … with 321 more rows, and 6 more variables: steak_prep <chr>, female <lgl>,
## #   age <chr>, hhold_income <chr>, educ <chr>, region <chr>
```

 

There are no missing values *there*. Of course, this is not a
proof, and there might be some missing values further down, but at
least it suggests that we might be good.

For proof, this is the easiest way I know:


```r
steak.complete %>%
  mutate_if(is.character, factor) %>%
  summary()
```

```
##  respondent_id       lottery_a         smoke          alcohol       
##  Min.   :3.235e+09   Mode :logical   Mode :logical   Mode :logical  
##  1st Qu.:3.235e+09   FALSE:171       FALSE:274       FALSE:65       
##  Median :3.235e+09   TRUE :160       TRUE :57        TRUE :266      
##  Mean   :3.235e+09                                                  
##  3rd Qu.:3.235e+09                                                  
##  Max.   :3.235e+09                                                  
##                                                                     
##    gamble        skydiving         speed          cheated         steak        
##  Mode :logical   Mode :logical   Mode :logical   Mode :logical   Mode:logical  
##  FALSE:158       FALSE:308       FALSE:28        FALSE:274       TRUE:331      
##  TRUE :173       TRUE :23        TRUE :303       TRUE :57                      
##                                                                                
##                                                                                
##                                                                                
##                                                                                
##        steak_prep    female           age                  hhold_income
##  Medium     :109   Mode :logical   >60  :82   $0 - $24,999       : 37  
##  Medium rare:128   FALSE:174       18-29:70   $100,000 - $149,999: 66  
##  Medium Well: 56   TRUE :157       30-44:93   $150,000+          : 39  
##  Rare       : 18                   45-60:86   $25,000 - $49,999  : 55  
##  Well       : 20                              $50,000 - $99,999  :134  
##                                                                        
##                                                                        
##                                educ                    region  
##  Bachelor degree                 :120   South Atlantic    :68  
##  Graduate degree                 : 86   Pacific           :57  
##  High school degree              : 20   East North Central:48  
##  Less than high school degree    :  1   Middle Atlantic   :46  
##  Some college or Associate degree:104   West North Central:29  
##                                         Mountain          :24  
##                                         (Other)           :59
```

 

If there were any missing values, they would be listed on the end of
the counts of observations for each level, or on the bottom of the
five-number sumamries. But there aren't.  So here's your proof.



(d) Write the data into a `.csv` file, with a name like
`steak1.csv`.  Open this file in a spreadsheet and (quickly)
verify that you have the right columns and no missing values.


Solution


This is `write_csv`, using my output from 
`drop_na`:

```r
write_csv(steak, "steak1.csv")
```

     

Open up Excel, or whatever you have, and take a look. You should have
all the right columns, and, scrolling down, no visible missing values.







##  Crimes in San Francisco -- the data


 The data in [link](http://www.utsc.utoronto.ca/~butler/d29/sfcrime.csv) is a huge dataset of crimes committed in San
Francisco between 2003 and 2015. The variables are:



* `Dates`: the date and time of the crime

* `Category`: the category of crime, eg. "larceny" or
"vandalism" (response).

* `Descript`: detailed description of crime.

* `DayOfWeek`: the day of the week of the crime.

* `PdDistrict`: the name of the San Francisco Police
Department district in which the crime took place.

* `Resolution`: how the crime was resolved

* `Address`: approximate street address of crime

* `X`: longitude

* `Y`: latitude


Our aim is to see whether the category of crime depends on the day of
the week and the district in which it occurred. However, there are a
lot of crime categories, so we will focus on the top four
"interesting" ones, which we will have to discover.



(a) Read in the data and verify that you have these columns and a
lot of rows. (The data may take a moment to read in. You will see why.)


Solution



```r
my_url="http://www.utsc.utoronto.ca/~butler/d29/sfcrime.csv"
sfcrime=read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   Dates = col_datetime(format = ""),
##   Category = col_character(),
##   Descript = col_character(),
##   DayOfWeek = col_character(),
##   PdDistrict = col_character(),
##   Resolution = col_character(),
##   Address = col_character(),
##   X = col_double(),
##   Y = col_double()
## )
```

```r
sfcrime
```

```
## # A tibble: 878,049 x 9
##    Dates               Category Descript DayOfWeek PdDistrict Resolution Address
##    <dttm>              <chr>    <chr>    <chr>     <chr>      <chr>      <chr>  
##  1 2015-05-13 23:53:00 WARRANTS WARRANT… Wednesday NORTHERN   ARREST, B… OAK ST…
##  2 2015-05-13 23:53:00 OTHER O… TRAFFIC… Wednesday NORTHERN   ARREST, B… OAK ST…
##  3 2015-05-13 23:33:00 OTHER O… TRAFFIC… Wednesday NORTHERN   ARREST, B… VANNES…
##  4 2015-05-13 23:30:00 LARCENY… GRAND T… Wednesday NORTHERN   NONE       1500 B…
##  5 2015-05-13 23:30:00 LARCENY… GRAND T… Wednesday PARK       NONE       100 Bl…
##  6 2015-05-13 23:30:00 LARCENY… GRAND T… Wednesday INGLESIDE  NONE       0 Bloc…
##  7 2015-05-13 23:30:00 VEHICLE… STOLEN … Wednesday INGLESIDE  NONE       AVALON…
##  8 2015-05-13 23:30:00 VEHICLE… STOLEN … Wednesday BAYVIEW    NONE       KIRKWO…
##  9 2015-05-13 23:00:00 LARCENY… GRAND T… Wednesday RICHMOND   NONE       600 Bl…
## 10 2015-05-13 23:00:00 LARCENY… GRAND T… Wednesday CENTRAL    NONE       JEFFER…
## # … with 878,039 more rows, and 2 more variables: X <dbl>, Y <dbl>
```

     

Those columns indeed, and pushing a million rows! That's why it took
so long!

There are also 39 categories of crime, so we need to cut that down
some. There are only ten districts, however, so we should be able to
use that as is.
    


(b) How is the response variable here different to the one in
the question about steak preferences (and therefore why would
`multinom` from package `nnet` be the method of choice)?


Solution


Steak preferences have a natural order, while crime categories do
not. Since they are unordered, `multinom` is better than
`polr`. 
    


(c) Find out which crime categories there are, and 
arrange them in order of how many crimes there were in each
category. 


Solution


This can be the one you know, a group-by and summarize, followed
by `arrange` to sort:


```r
sfcrime %>% group_by(Category) %>%
summarize(count=n()) %>%
arrange(desc(count))
```

```
## # A tibble: 39 x 2
##    Category        count
##    <chr>           <int>
##  1 LARCENY/THEFT  174900
##  2 OTHER OFFENSES 126182
##  3 NON-CRIMINAL    92304
##  4 ASSAULT         76876
##  5 DRUG/NARCOTIC   53971
##  6 VEHICLE THEFT   53781
##  7 VANDALISM       44725
##  8 WARRANTS        42214
##  9 BURGLARY        36755
## 10 SUSPICIOUS OCC  31414
## # … with 29 more rows
```

 

or this one does the same thing and saves a step:


```r
sfcrime %>% count(Category) %>%
arrange(desc(n))
```

```
## # A tibble: 39 x 2
##    Category            n
##    <chr>           <int>
##  1 LARCENY/THEFT  174900
##  2 OTHER OFFENSES 126182
##  3 NON-CRIMINAL    92304
##  4 ASSAULT         76876
##  5 DRUG/NARCOTIC   53971
##  6 VEHICLE THEFT   53781
##  7 VANDALISM       44725
##  8 WARRANTS        42214
##  9 BURGLARY        36755
## 10 SUSPICIOUS OCC  31414
## # … with 29 more rows
```

 

For this one, do the `count` step first, to see what you
get. It produces a two-column data frame with the column of counts
called `n`. So now you know that the second line has to be
`arrange(desc(n))`, whereas before you tried `count`,
all you knew is that it was arrange-desc-something.

You need to sort in descending order so that the categories you want
to see actually do appear at the top.
    


(d) Which are the four most frequent "interesting" crime
categories, that is to say, not including "other offenses" and
"non-criminal"? Get them into a vector called
`my.crimes`. See if you can find a way of doing this  that
doesn't involve typing them in (for full marks).


Solution


The most frequent interesting ones are, in order, larceny-theft,
assault, drug-narcotic and vehicle theft. 
The fact that "other offenses" is so big indicates that there
are a lot of possible crimes out there, and even 39 categories of
crime isn't enough. "Non-criminal" means, I think, that the
police were called, but on arriving at the scene, they found that
no law had been broken.
I think the easy way to get the "top four" crimes out is to pull
them out of the data frame that `count` produces. They are
rows 1, 4, 5 and 6, so add a `slice` to your pipeline:

```r
my.rows=c(1,4,5,6)
my.crimes = sfcrime %>% count(Category) %>%
arrange(desc(n)) %>%
slice(my.rows) %>% pull(Category)
my.crimes
```

```
## [1] "LARCENY/THEFT" "ASSAULT"       "DRUG/NARCOTIC" "VEHICLE THEFT"
```

     

I just want the `Category` column (as a vector), and
`pull` is the way to get that. (If I don't do `pull`, I
get a data frame.)

If you can't think of anything, just type them into a vector with
`c`, or better, copy-paste them from the console. But that's a
last resort, and would cost you a point. If you do this, they have to
match exactly, UPPERCASE and all.
    


(e) (Digression, but needed for the next part.) The R vector
`letters` contains the lowercase letters from `a` to
`z`. Consider the vector `('a','m',3,'Q')`. Some of
these are found amongst the lowercase letters, and some not. Type
these into a vector `v` and explain briefly why 
`v %in% letters` produces what it does.



Solution


This is the ultimate "try it and see":

```r
v=c('a','m',3,'Q')
v %in% letters
```

```
## [1]  TRUE  TRUE FALSE FALSE
```

   

The first two elements of the answer are `TRUE` because
lowercase-a and lowercase-m can be found in the lowercase letters
somewhere. The other two are false because the number 3 and the
uppercase-Q cannot be found anywhere in the lowercase letters.

The name is `%in%` because it's asking whether each element of
the first vector (one at a time) is *in* the set defined by the
second thing: "is `a` a lowercase letter?" ... 
is "`Q` a lowercase letter?" 
and getting the answers "yes, yes, no, no".
  


(f) We are going to `filter` only the rows of our data frame that
have one of the crimes in `my.crimes` as their
`Category`. Also, `select` only the columns
`Category`, `DayOfWeek` and `PdDistrict`. Save
the resulting data frame and display its structure. (You should have a
lot fewer rows than you did before.)



Solution


The hard part about this is to get the inputs to `%in%` the
right way around. We are testing the things in `Category` one
at a time for membership in the set in `my.crimes`, so this:

```r
sfcrimea = sfcrime %>% filter(Category %in% my.crimes) %>%
select(c(Category,DayOfWeek,PdDistrict)) 
sfcrimea
```

```
## # A tibble: 359,528 x 3
##    Category      DayOfWeek PdDistrict
##    <chr>         <chr>     <chr>     
##  1 LARCENY/THEFT Wednesday NORTHERN  
##  2 LARCENY/THEFT Wednesday PARK      
##  3 LARCENY/THEFT Wednesday INGLESIDE 
##  4 VEHICLE THEFT Wednesday INGLESIDE 
##  5 VEHICLE THEFT Wednesday BAYVIEW   
##  6 LARCENY/THEFT Wednesday RICHMOND  
##  7 LARCENY/THEFT Wednesday CENTRAL   
##  8 LARCENY/THEFT Wednesday CENTRAL   
##  9 LARCENY/THEFT Wednesday NORTHERN  
## 10 ASSAULT       Wednesday INGLESIDE 
## # … with 359,518 more rows
```

   

That didn't work. Remember what this was? This is because `MASS` is still loaded:


```r
search()
```

```
##  [1] ".GlobalEnv"          ".conflicts"          "package:leaps"      
##  [4] "package:conflicted"  "package:PMCMRplus"   "package:rstan"      
##  [7] "package:StanHeaders" "package:bootstrap"   "package:rpart"      
## [10] "package:broom"       "package:ggrepel"     "package:ggbiplot"   
## [13] "package:grid"        "package:scales"      "package:plyr"       
## [16] "package:lme4"        "package:Matrix"      "package:car"        
## [19] "package:carData"     "package:survminer"   "package:ggpubr"     
## [22] "package:survival"    "package:nnet"        "package:smmr"       
## [25] "package:forcats"     "package:stringr"     "package:dplyr"      
## [28] "package:purrr"       "package:readr"       "package:tidyr"      
## [31] "package:tibble"      "package:ggplot2"     "package:tidyverse"  
## [34] "package:stats"       "package:graphics"    "package:grDevices"  
## [37] "package:utils"       "package:datasets"    "package:methods"    
## [40] "Autoloads"           "package:base"
```

 

so we need to get rid of `MASS`:


```r
detach("package:MASS", unload=T)
```

```
## Error in detach("package:MASS", unload = T): invalid 'name' argument
```

 

and try again:


```r
sfcrimea = sfcrime %>% filter(Category %in% my.crimes) %>%
select(c(Category,DayOfWeek,PdDistrict)) 
sfcrimea
```

```
## # A tibble: 359,528 x 3
##    Category      DayOfWeek PdDistrict
##    <chr>         <chr>     <chr>     
##  1 LARCENY/THEFT Wednesday NORTHERN  
##  2 LARCENY/THEFT Wednesday PARK      
##  3 LARCENY/THEFT Wednesday INGLESIDE 
##  4 VEHICLE THEFT Wednesday INGLESIDE 
##  5 VEHICLE THEFT Wednesday BAYVIEW   
##  6 LARCENY/THEFT Wednesday RICHMOND  
##  7 LARCENY/THEFT Wednesday CENTRAL   
##  8 LARCENY/THEFT Wednesday CENTRAL   
##  9 LARCENY/THEFT Wednesday NORTHERN  
## 10 ASSAULT       Wednesday INGLESIDE 
## # … with 359,518 more rows
```

   
I had trouble thinking of a good name for this one, so I put an "a"
on the end. (I would have used a number, but I prefer those for
models.) 

Down to a "mere" 359,000 rows. Don't be stressed that the
`Category` factor still has 39 levels (the original 39 crime
categories); only four of them have any data in them:


```r
sfcrimea %>% count(Category)
```

```
## # A tibble: 4 x 2
##   Category           n
##   <chr>          <int>
## 1 ASSAULT        76876
## 2 DRUG/NARCOTIC  53971
## 3 LARCENY/THEFT 174900
## 4 VEHICLE THEFT  53781
```

 

So all of the crimes that are left are one of the four Categories we
want to look at.
  


(g) Save these data in a file `sfcrime1.csv`.



Solution


This is `write_csv` again:

```r
write_csv(sfcrimea,"sfcrime1.csv")
```

   
  





##  How do you like your steak?


 When you order a steak in a restaurant, the server will ask
you how you would like it cooked, or to be precise, *how much*
you would like it cooked: rare (hardly cooked at all), through medium
rare, medium, medium well to well (which means "well done", so that
the meat has only a little red to it). Could you guess how a person
likes their steak cooked, from some other information about them? The
website [link](fivethirtyeight.com) commissioned a survey where they
asked a number of people how they preferred their steak, along with as
many other things as they could think of to ask. (Many of the
variables below are related to risk-taking, which was something the
people designing the survey thought might have something to do with
liking steak rare.) The variables of interest are all factors or true/false:



* `respondent_ID`: a ten-digit number identifying each
person who responded to the survey.

* `lottery_a`: true if the respondent preferred lottery A
with a small chance to win a lot of money, to lottery B, with a
larger chance to win less money.

* `smoke`: true if the respondent is currently a smoker

* `alcohol`: true if the respondent at least occasionally
drinks alcohol.

* `gamble`: true if the respondent likes to gamble (eg.
betting on horse racing or playing the lottery)

* `skydiving`: true if the respondent has ever been
skydiving.

* `speed`: true if the respondent likes to drive fast

* `cheated`: true if the respondent has ever cheated on a
spouse or girlfriend/boyfriend

* `steak`: true if the respondent likes to eat steak

* `steak_prep` (response): how the respondent likes their
steak cooked (factor, as described above, with 5 levels).

* `female`: true if the respondent is female

* `age`: age group, from 18--29 to 60+.

* `hhold_income`: household income group, from \$0--24,999
to \$150,000+.

* `educ`: highest level of education attained, from 
"less than high school" up to "graduate degree"

* `region`: region (of the US)
that the respondent lives in (five values).


The data are in
[link](http://www.utsc.utoronto.ca/~butler/d29/steak1.csv). This is the
cleaned-up data from a previous question, with the missing values removed.



(a) Read in the data and display the first few lines.


Solution


The usual:


```r
steak <- read_csv("steak1.csv")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   respondent_id = col_double(),
##   lottery_a = col_logical(),
##   smoke = col_logical(),
##   alcohol = col_logical(),
##   gamble = col_logical(),
##   skydiving = col_logical(),
##   speed = col_logical(),
##   cheated = col_logical(),
##   steak = col_logical(),
##   steak_prep = col_character(),
##   female = col_logical(),
##   age = col_character(),
##   hhold_income = col_character(),
##   educ = col_character(),
##   region = col_character()
## )
```

```r
head(steak)
```

```
## # A tibble: 6 x 15
##   respondent_id lottery_a smoke alcohol gamble skydiving speed cheated steak
##           <dbl> <lgl>     <lgl> <lgl>   <lgl>  <lgl>     <lgl> <lgl>   <lgl>
## 1    3234982343 TRUE      FALSE TRUE    FALSE  FALSE     FALSE FALSE   TRUE 
## 2    3234973379 TRUE      FALSE TRUE    TRUE   FALSE     TRUE  TRUE    TRUE 
## 3    3234972383 FALSE     TRUE  TRUE    TRUE   FALSE     TRUE  TRUE    TRUE 
## 4    3234958833 FALSE     FALSE TRUE    FALSE  FALSE     TRUE  TRUE    TRUE 
## 5    3234955240 TRUE      FALSE FALSE   FALSE  FALSE     TRUE  FALSE   TRUE 
## 6    3234955010 TRUE      FALSE TRUE    TRUE   TRUE      TRUE  FALSE   TRUE 
## # … with 6 more variables: steak_prep <chr>, female <lgl>, age <chr>,
## #   hhold_income <chr>, educ <chr>, region <chr>
```

 

We should also (re-)load `MASS`, since we'll be needing it:


```r
library(MASS)
```

 



(b) We are going to predict `steak_prep` from some of
the other variables. Why is the model-fitting function `polr`
from package `MASS` the best choice for these data
(alternatives being `glm` and `multinom` from package
`nnet`)?


Solution


It all depends on the kind of response variable. We have a
response variable with five ordered levels from Rare to
Well. There are more than two levels (it is more than a
"success" and "failure"), which rules out `glm`, and
the levels are ordered, which rules out `multinom`. As we
know, `polr` handles an ordered response, so it is the
right choice.
    


(c) What are the levels of `steak_prep`, 
*in the  order that R thinks they are in?* If they are not in a sensible
order, create an ordered factor where the levels are in a sensible order.


Solution


This is the most direct way to find out:

```r
preps <- steak %>% distinct(steak_prep) %>% pull(steak_prep)
preps
```

```
## [1] "Medium rare" "Rare"        "Medium"      "Medium Well" "Well"
```

     

This is almost the right order (`distinct` uses the order in
the data frame). We just need to switch the first two around, and then
we'll be done:


```r
preps1 <- preps[c(2, 1, 3, 4, 5)]
preps1
```

```
## [1] "Rare"        "Medium rare" "Medium"      "Medium Well" "Well"
```

 

If you used `count`, there's a bit more work to do:


```r
preps2 <- steak %>% count(steak_prep) %>% pull(steak_prep)
preps2
```

```
## [1] "Medium"      "Medium rare" "Medium Well" "Rare"        "Well"
```

 

because `count` puts them in alphabetical order, so:


```r
preps3 <- preps2[c(4, 2, 1, 3, 5)]
preps3
```

```
## [1] "Rare"        "Medium rare" "Medium"      "Medium Well" "Well"
```

 

These use the idea in the
attitudes-to-abortion question: create a vector of the levels in the
*right* order, then create an ordered factor with
`ordered()`. If you like, you can type the levels in the right
order (I won't penalize you for that here), but it's really better to
get the levels without typing or copying-pasting, so that you don't
make any silly errors copying them (which will mess everything up
later).

So now I create my ordered response:


```r
steak <- steak %>% mutate(steak_prep_ord = ordered(steak_prep, preps1))
```

 
or using one of the other `preps` vectors containing the levels
in the correct order.
As far as `polr` is concerned,
it doesn't matter whether I start at `Rare` and go "up", or
start at `Well` and go "down". So if you do it the other way
around, that's fine. As long as you get the levels in a sensible
order, you're good.
    


(d) Fit a model predicting preferred steak preparation in an
ordinal logistic regression from `educ`, `female` and
`lottery_a`. This ought to be easy from your previous work,
but you have to be careful about one thing. No need to print out the
results. 


Solution


The thing you have to be careful about is that you use the
*ordered* factor that you just created as the response:

```r
steak.1 <- polr(steak_prep_ord ~ educ + female + lottery_a, data = steak)
```

     
    


(e) Run `drop1` on your fitted model, with
`test="Chisq"`. Which explanatory variable should be removed
first, if any? Bear in mind that the variable with the
*smallest* AIC should come out first, in case your table
doesn't get printed in order.


Solution


This:


```r
drop1(steak.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## steak_prep_ord ~ educ + female + lottery_a
##           Df    AIC    LRT Pr(>Chi)  
## <none>       910.69                  
## educ       4 912.10 9.4107  0.05162 .
## female     1 908.70 0.0108  0.91715  
## lottery_a  1 909.93 1.2425  0.26498  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

My table is indeed out of order (which is why I warned you about it,
in case that happens to you as well). The smallest AIC goes with
`female`, which also has a very non-significant P-value, so
this one should come out first.
    


(f) Remove the variable that should come out first, using
`update`. (If all the variables should stay, you can skip
this part.)


Solution


You could type or copy-paste the whole model again, but
`update` is quicker:

```r
steak.2 <- update(steak.1, . ~ . - female)
```

     

That's all.

I wanted to get some support for my `drop1` above (since I was
a bit worried about those out-of-order rows). Now that we have fitted
a model with `female` and one without, we can compare them
using `anova`:


```r
anova(steak.2, steak.1, test = "Chisq")
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: steak_prep_ord
##                       Model Resid. df Resid. Dev   Test    Df  LR stat.
## 1          educ + lottery_a       322   890.7028                       
## 2 educ + female + lottery_a       321   890.6920 1 vs 2     1 0.0108221
##     Pr(Chi)
## 1          
## 2 0.9171461
```

 

Don't get taken in by that "LR stat" on the end of the first row of
the output table; the P-value wrapped onto the second line, and is in
fact exactly the same as in the `drop1` output (it is doing
exactly the same test). As non-significant as you could wish for.

I was curious about whether either of the other $x$'s could come out now:


```r
drop1(steak.2, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## steak_prep_ord ~ educ + lottery_a
##           Df    AIC    LRT Pr(>Chi)  
## <none>       908.70                  
## educ       4 910.13 9.4299  0.05121 .
## lottery_a  1 907.96 1.2599  0.26167  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

`lottery_a` should come out, but `educ` is edging
towards significance.
    


(g) Using the best model that you have so far, predict the
probabilities of preferring each different steak preparation (method
of cooking) for each combination of the variables that
remain. (Some of the variables are TRUE and FALSE rather than
factors. Bear this in mind.)
Describe the effects of each variable on the predicted
probabilities, if any. Note that there is exactly one person in the
study whose educational level is "less than high school".


Solution


Again, I'm leaving it to you to follow all the steps. My variables
remaining are `educ` and `lottery_a`. The second of
these is a logical, TRUE and FALSE, so I just filled in the two values:

```r
educs <- steak %>% distinct(educ) %>% pull(educ)
lottery_as <- c(FALSE, TRUE)

steak.new <- crossing(educ = educs, lottery_a = lottery_as)
steak.new
```

```
## # A tibble: 10 x 2
##    educ                             lottery_a
##    <chr>                            <lgl>    
##  1 Bachelor degree                  FALSE    
##  2 Bachelor degree                  TRUE     
##  3 Graduate degree                  FALSE    
##  4 Graduate degree                  TRUE     
##  5 High school degree               FALSE    
##  6 High school degree               TRUE     
##  7 Less than high school degree     FALSE    
##  8 Less than high school degree     TRUE     
##  9 Some college or Associate degree FALSE    
## 10 Some college or Associate degree TRUE
```

     

My best model so far is the one I called `steak.2`, without
`female`, so this. As before, if you forget what `type`
should be, put in *something*, and it will tell you what your
choices are:


```r
p <- predict(steak.2, steak.new, type = "probs")
cbind(steak.new, p)
```

```
##                                educ lottery_a         Rare  Medium rare
## 1                   Bachelor degree     FALSE 5.191314e-02 3.832425e-01
## 2                   Bachelor degree      TRUE 4.181795e-02 3.386213e-01
## 3                   Graduate degree     FALSE 7.954891e-02 4.691799e-01
## 4                   Graduate degree      TRUE 6.444488e-02 4.277303e-01
## 5                High school degree     FALSE 5.280801e-02 3.867857e-01
## 6                High school degree      TRUE 4.254661e-02 3.421527e-01
## 7      Less than high school degree     FALSE 8.507263e-08 1.111878e-06
## 8      Less than high school degree      TRUE 6.780714e-08 8.862222e-07
## 9  Some college or Associate degree     FALSE 5.499694e-02 3.951981e-01
## 10 Some college or Associate degree      TRUE 4.433010e-02 3.505796e-01
##          Medium  Medium Well       Well
## 1  3.347391e-01 1.719854e-01 0.05811984
## 2  3.468434e-01 2.008621e-01 0.07185531
## 3  2.920587e-01 1.215881e-01 0.03762435
## 4  3.158550e-01 1.452132e-01 0.04675658
## 5  3.334805e-01 1.697854e-01 0.05714038
## 6  3.461457e-01 1.984932e-01 0.07066175
## 7  4.001373e-06 1.997966e-05 0.99997482
## 8  3.189298e-06 1.592489e-05 0.99997993
## 9  3.303218e-01 1.646121e-01 0.05487110
## 10 3.442957e-01 1.929005e-01 0.06789415
```

 

I find this hard to read, so I'm going to round off those
predictions. Three or four decimals seems to be sensible:


```r
cbind(steak.new, round(p, 3))
```

```
##                                educ lottery_a  Rare Medium rare Medium
## 1                   Bachelor degree     FALSE 0.052       0.383  0.335
## 2                   Bachelor degree      TRUE 0.042       0.339  0.347
## 3                   Graduate degree     FALSE 0.080       0.469  0.292
## 4                   Graduate degree      TRUE 0.064       0.428  0.316
## 5                High school degree     FALSE 0.053       0.387  0.333
## 6                High school degree      TRUE 0.043       0.342  0.346
## 7      Less than high school degree     FALSE 0.000       0.000  0.000
## 8      Less than high school degree      TRUE 0.000       0.000  0.000
## 9  Some college or Associate degree     FALSE 0.055       0.395  0.330
## 10 Some college or Associate degree      TRUE 0.044       0.351  0.344
##    Medium Well  Well
## 1        0.172 0.058
## 2        0.201 0.072
## 3        0.122 0.038
## 4        0.145 0.047
## 5        0.170 0.057
## 6        0.198 0.071
## 7        0.000 1.000
## 8        0.000 1.000
## 9        0.165 0.055
## 10       0.193 0.068
```

 

Say something about the effect of changing educational level on the
predictions, and say something about the effect of favouring Lottery A
vs.\ not. I don't much mind what: you can say that there is not much
effect (of either variable), or you can say something like "people with a graduate degree are slightly more likely to like their steak rare and less likely to like it well done" (for education level) and
"people who preferred Lottery A are slightly less likely to like their steak rare and slightly more likely to like it well done" (for
effect of Lottery A). You can see these by comparing the first five
rows to assess the effect of education (or the last five rows, if you
prefer), and you can compare eg. rows 1 and 6 to assess the effect of
Lottery A (compare two lines with the *same* educational level
but *different* preferences re Lottery A). 

I would keep away from saying anything about education level 
"less than high school", since this entire level is represented by exactly
one person.
    


(h) Is it reasonable to remove *all* the remaining
explanatory variables from your best model so far? Fit a model with no explanatory variables,
and do a test. (In R, if the right side of the squiggle is a
`1`, that means "just an intercept". Or you can remove
whatever remains using `update`.) What do you conclude?
Explain briefly.


Solution


The fitting part is the challenge, since the testing part is
`anova` again. The direct fit is this:

```r
steak.3 <- polr(steak_prep_ord ~ 1, data = steak)
```

     

and the `update` version is this, about equally long, starting
from `steak.2` since that is the best model so far:


```r
steak.3a <- update(steak.2, . ~ . - educ - lottery_a)
```

 

You can use whichever you like. Either way, the second part is
`anova`, and the two possible answers should be the same:


```r
anova(steak.3, steak.2, test = "Chisq")
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: steak_prep_ord
##              Model Resid. df Resid. Dev   Test    Df LR stat.    Pr(Chi)
## 1                1       327   901.4467                                 
## 2 educ + lottery_a       322   890.7028 1 vs 2     5 10.74387 0.05670146
```

 

or


```r
anova(steak.3a, steak.2, test = "Chisq")
```

```
## Likelihood ratio tests of ordinal regression models
## 
## Response: steak_prep_ord
##              Model Resid. df Resid. Dev   Test    Df LR stat.    Pr(Chi)
## 1                1       327   901.4467                                 
## 2 educ + lottery_a       322   890.7028 1 vs 2     5 10.74387 0.05670146
```

 

At the 0.05 level, removing both of the remaining variables is fine:
that is, nothing (out of these variables) has any impact on the
probability that a diner will prefer their steak cooked a particular
way. 

However, with data like this and a rather exploratory analysis, I
might think about using a larger $\alpha$ like 0.10, and at this
level, taking out both these two variables is a bad idea. You could
say that one or both of them is "potentially useful" or
"provocative" or something like that.

If you think that removing these two variables is questionable, you
might like to go back to that `drop1` output I had above:


```r
drop1(steak.2, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## steak_prep_ord ~ educ + lottery_a
##           Df    AIC    LRT Pr(>Chi)  
## <none>       908.70                  
## educ       4 910.13 9.4299  0.05121 .
## lottery_a  1 907.96 1.2599  0.26167  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

The smallest AIC goes with `lottery_a`, so that comes out (it
is nowhere near significant):


```r
steak.4 <- update(steak.2, . ~ . - lottery_a)
drop1(steak.4, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## steak_prep_ord ~ educ
##        Df    AIC   LRT Pr(>Chi)  
## <none>    907.96                 
## educ    4 909.45 9.484  0.05008 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

and what you see is that educational level is right on the edge of
significance, so that may or may not have any impact. Make a call. But
if anything, it's educational level that makes a difference.
    


(i) In the article for which these data were collected,
[link](https://fivethirtyeight.com/datalab/how-americans-like-their-steak/),
does the author obtain consistent conclusions with yours? Explain
briefly. (It's not a very long article, so it won't take you long to
skim through, and the author's point is pretty clear.)



Solution


The article says that *nothing* has anything to do with steak
preference. Whether you agree or not depends on what you thought
above about dropping those last two variables. So say something
consistent with what you said in the previous part. Two points for
saying that the author said "nothing has any effect", and one
point for how your findings square with that.
Now that you have worked through this great long question, this is
where I tell you that I simplified things a fair bit for you! There
were lots of other variables that might have had an impact on how
people like their steaks, and we didn't even consider those. Why did
I choose what I did here? Well, I wanted to fit a regression predicting
steak preference from everything else, do a big backward
elimination, but:

```r
steak.5 <- polr(steak_prep_ord ~ ., data = steak)
```

```
## Warning: glm.fit: algorithm did not converge
```

```
## Error in polr(steak_prep_ord ~ ., data = steak): attempt to find suitable starting values failed
```

   
The `.` in place of explanatory
variables means "all the other variables", including the nonsensical
personal ID. That saved me having to type them all out. 

Unfortunately, however, it didn't work. The problem is a numerical
one. Regular regression has a well-defined procedure, where the computer follows
through the steps and gets to the answer, every time. Once you go
beyond regression, however, the answer is obtained by a step-by-step
method: the computer makes an initial guess, tries to improve it, then
tries to improve it again, until it can't improve things any more, at
which point it calls it good. The problem here is that `polr`
cannot even get the initial guess! (It apparently is known to suck at
this, in problems as big and complicated as this one.)

I don't normally recommend forward selection, but I wonder whether it
works here:


```r
steak.5 <- polr(steak_prep_ord ~ 1, data = steak)
steak.6 <- step(steak.5,
  scope = . ~ lottery_a + smoke + alcohol + gamble + skydiving +
    speed + cheated + female + age + hhold_income + educ + region,
  direction = "forward", test = "Chisq", trace = 0
)
drop1(steak.6, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## steak_prep_ord ~ educ
##        Df    AIC   LRT Pr(>Chi)  
## <none>    907.96                 
## educ    4 909.45 9.484  0.05008 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

It does, and it says the *only* thing to add out of all the
variables is education level. So, for you, I picked this along with a
couple of other plausible-sounding variables and had you start from there.

Forward selection starts from a model containing nothing and asks
"what can we add?". This is a bit more complicated than backward
elimination, because now you have to say what the candidate things to
add *are*. That's the purpose of that `scope` piece, and
there I had no alternative but to type the names of all the
variables. Backward elimination is easier, because the candidate
variables to remove are the ones in the model, and you don't need a
`scope`. The `trace=0` says "don't give me any output"
(you can change it to a different value if you want to see what that
does), and last, the `drop1` looks at what is actually
*in* the final model (with a view to asking what can be removed,
but we don't care about *that* here). 
  





##  Crimes in San Francisco



The data in
[link](http://www.utsc.utoronto.ca/~butler/d29/sfcrime1.csv) is a subset
of a huge
dataset of crimes committed in San Francisco between 2003 and
2015. The variables are:



* `Dates`: the date and time of the crime

* `Category`: the category of crime, eg. "larceny" or
"vandalism" (response).

* `Descript`: detailed description of crime.

* `DayOfWeek`: the day of the week of the crime.

* `PdDistrict`: the name of the San Francisco Police
Department district in which the crime took place.

* `Resolution`: how the crime was resolved

* `Address`: approximate street address of crime

* `X`: longitude

* `Y`: latitude


Our aim is to see whether the category of crime depends on the day of
the week and the district in which it occurred. However, there are a
lot of crime categories, so we will focus on the top four
"interesting" ones, which are the ones included in this data file.

Some of the model-fitting takes a while (you'll see why below). If
you're using R Markdown, you can wait for the models to fit each time
you re-run your document, or insert `cache=T` in the top line
of your code chunk (the one with `r` in curly brackets in it,
above the actual code). Put a comma and the `cache=T` inside
the curly brackets.  What that does is to re-run that code chunk only
if it changes; if it hasn't changed it will use the saved results from
last time it was run. That can save you a lot of waiting around.



(a) Read in the data and display the dataset (or, at least,
part of it).


Solution


The usual:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/sfcrime1.csv"
sfcrime <- read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   Category = col_character(),
##   DayOfWeek = col_character(),
##   PdDistrict = col_character()
## )
```

```r
sfcrime
```

```
## # A tibble: 359,528 x 3
##    Category      DayOfWeek PdDistrict
##    <chr>         <chr>     <chr>     
##  1 LARCENY/THEFT Wednesday NORTHERN  
##  2 LARCENY/THEFT Wednesday PARK      
##  3 LARCENY/THEFT Wednesday INGLESIDE 
##  4 VEHICLE THEFT Wednesday INGLESIDE 
##  5 VEHICLE THEFT Wednesday BAYVIEW   
##  6 LARCENY/THEFT Wednesday RICHMOND  
##  7 LARCENY/THEFT Wednesday CENTRAL   
##  8 LARCENY/THEFT Wednesday CENTRAL   
##  9 LARCENY/THEFT Wednesday NORTHERN  
## 10 ASSAULT       Wednesday INGLESIDE 
## # … with 359,518 more rows
```

     

This is a tidied-up version of the data, with only the variables we'll
look at, and only the observations from one of the "big four"
crimes, a mere 300,000 of them. This is the data set we created earlier.
    


(b) Fit a multinomial logistic
regression that predicts crime category from day of week and
district. (You don't need to look at it.) The model-fitting produces
some output. Hand that in too. (If you're using R Markdown, that will
come with it.)



Solution


The modelling part is easy enough, as long as you can get the
uppercase letters in the right places:


```r
sfcrime.1 <- multinom(Category~DayOfWeek+PdDistrict,data=sfcrime)
```

```
## # weights:  68 (48 variable)
## initial  value 498411.639069 
## iter  10 value 430758.073422
## iter  20 value 430314.270403
## iter  30 value 423303.587698
## iter  40 value 420883.528523
## iter  50 value 418355.242764
## final  value 418149.979622 
## converged
```

 
  


(c) Fit a model that predicts Category from only the
district. Hand in the output from the fitting process as well. 



Solution


Same idea. Write it out, or use `update`:

```r
sfcrime.2 <- update(sfcrime.1,.~.-DayOfWeek)
```

```
## # weights:  44 (30 variable)
## initial  value 498411.639069 
## iter  10 value 426003.543845
## iter  20 value 425542.806828
## iter  30 value 421715.787609
## final  value 418858.235297 
## converged
```

   
  


(d) Use `anova` to compare the two models you just
obtained. What does the `anova` tell you?



Solution


This:


```r
anova(sfcrime.2,sfcrime.1)
```

```
## Likelihood ratio tests of Multinomial Models
## 
## Response: Category
##                    Model Resid. df Resid. Dev   Test    Df LR stat. Pr(Chi)
## 1             PdDistrict   1078554   837716.5                              
## 2 DayOfWeek + PdDistrict   1078536   836300.0 1 vs 2    18 1416.511       0
```

 

This is a very small P-value. The null hypothesis is that the two
models are equally good, and this is clearly rejected. We need the
bigger model: that is, we need to keep `DayOfWeek` in there,
because the pattern of crimes (in each district) differs over day of
week. 

One reason the P-value came out so small is that we have a ton of
data, so that even a very small difference between days of the week
could come out very strongly significant. The Machine Learning people
(this is a machine learning dataset) don't worry so much about tests
for that reason: they are more concerned with predicting things well,
so they just throw everything into the model and see what comes out.
  


(e) Using your preferred model, obtain predicted probabilities
that a crime will be of each of these four categories for each day of
the week in the `TENDERLOIN` district (the name is ALL
CAPS). This will mean constructing a data frame to predict from,
obtaining the predictions and then displaying them suitably.



Solution


I left this one fairly open, because you've done this kind of thing
before, so what you need to do ought to be fairly clear:
Construct the values to predict for with plural names:
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">You are almost certainly going to get the Capital Letters wrong in *DayOfWeek*, once, somewhere in the process. I did.</span>


```r
DayOfWeeks <- sfcrime %>% distinct(DayOfWeek) %>% pull(DayOfWeek)
DayOfWeeks
```

```
## [1] "Wednesday" "Tuesday"   "Monday"    "Sunday"    "Saturday"  "Friday"   
## [7] "Thursday"
```

```r
PdDistricts <- "TENDERLOIN"
```

 

The days of the week are in the order they came out in the data. I
could fix this up, but the thing that matters for us is that Saturday
and Sunday came out next to each other.

Anyway, it's about right, even though only one of the variables is
actually plural and the other plural came out wrong. 

Then, make data frame of combinations. The nice thing is that if we
had more than one district, we'd just define `PdDistricts`
appropriately above and the rest of it would be the same:


```r
sfcrime.new <- crossing(DayOfWeek=DayOfWeeks,PdDistrict=PdDistricts)
sfcrime.new
```

```
## # A tibble: 7 x 2
##   DayOfWeek PdDistrict
##   <chr>     <chr>     
## 1 Friday    TENDERLOIN
## 2 Monday    TENDERLOIN
## 3 Saturday  TENDERLOIN
## 4 Sunday    TENDERLOIN
## 5 Thursday  TENDERLOIN
## 6 Tuesday   TENDERLOIN
## 7 Wednesday TENDERLOIN
```

 

Then do the predictions:


```r
p <- predict(sfcrime.1,sfcrime.new,type="probs")
```

 

I can never remember the `type` thing for these models, because
they are *all different*. I just make a guess, and if I guess
something that this version of `predict` doesn't know about,
it'll tell me:


```r
p <- predict(sfcrime.1,sfcrime.new,type="bananas")
```

```
## Error in match.arg(type): 'arg' should be one of "class", "probs"
```

 

I can work out from this that `type` should be `probs`,
since the other one makes the best guess at which category of response
you'll get (the one with the highest probability). The predicted
probabilities are more informative, since then you can see how they
change, even if the predicted category stays the same.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">This is something we'll see again in discriminant analysis.</span>

Finally, display the results. I thought `cbind` wouldn't work
here, because some of the variables are factors and some are numbers,
but `cbind`  is smarter than that:


```r
cbind(sfcrime.new,p)
```

```
##   DayOfWeek PdDistrict   ASSAULT DRUG/NARCOTIC LARCENY/THEFT VEHICLE THEFT
## 1    Friday TENDERLOIN 0.2125997     0.4658122     0.2907793    0.03080879
## 2    Monday TENDERLOIN 0.2072430     0.5001466     0.2656069    0.02700348
## 3  Saturday TENDERLOIN 0.2425998     0.4200751     0.3060611    0.03126405
## 4    Sunday TENDERLOIN 0.2548597     0.4287291     0.2868682    0.02954299
## 5  Thursday TENDERLOIN 0.1938754     0.5179500     0.2617658    0.02640888
## 6   Tuesday TENDERLOIN 0.1942447     0.5208668     0.2593331    0.02555535
## 7 Wednesday TENDERLOIN 0.1874867     0.5400287     0.2479498    0.02453490
```

 
  


(f) Describe briefly how the weekend days Saturday and Sunday
differ from the rest.



Solution


The days ended up in some quasi-random order, but Saturday and Sunday are
still together, so we can still easily compare them with the rest.
My take is that the last two columns don't differ much between
weekday and weekend, but the first two columns do: the probability
of a crime being an assault is a bit higher on the weekend, and the
probability of a crime being drug-related is a bit lower.
I will accept anything reasonable supported by the predictions you got.
We said there was a strongly significant day-of-week effect, but the
changes from weekday to weekend are actually pretty small (but the
changes from one weekday to another are even smaller). This supports
what I guessed before, that with this much data even a small effect
(the one shown here) is statistically
significant.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">Statistical significance as an idea grew up in    the days before *big data*.</span>
I want to compare another district. What districts do we have?

```r
sfcrime %>% count(PdDistrict)
```

```
## # A tibble: 10 x 2
##    PdDistrict     n
##    <chr>      <int>
##  1 BAYVIEW    31693
##  2 CENTRAL    38052
##  3 INGLESIDE  30102
##  4 MISSION    45277
##  5 NORTHERN   47750
##  6 PARK       19197
##  7 RICHMOND   18211
##  8 SOUTHERN   67981
##  9 TARAVAL    24981
## 10 TENDERLOIN 36284
```

   

This is the number of our "big four" crimes committed in each
district. Let's look at the lowest-crime district `RICHMOND`. I
copy and paste my code. Since I want to compare two districts, I
include both:



 


```r
DayOfWeeks <- sfcrime %>% distinct(DayOfWeek) %>% pull(DayOfWeek)
PdDistricts <- c("RICHMOND","TENDERLOIN")
sfcrime.new <- crossing(DayOfWeek=DayOfWeeks,PdDistrict=PdDistricts)
sfcrime.new
```

```
## # A tibble: 14 x 2
##    DayOfWeek PdDistrict
##    <chr>     <chr>     
##  1 Friday    RICHMOND  
##  2 Friday    TENDERLOIN
##  3 Monday    RICHMOND  
##  4 Monday    TENDERLOIN
##  5 Saturday  RICHMOND  
##  6 Saturday  TENDERLOIN
##  7 Sunday    RICHMOND  
##  8 Sunday    TENDERLOIN
##  9 Thursday  RICHMOND  
## 10 Thursday  TENDERLOIN
## 11 Tuesday   RICHMOND  
## 12 Tuesday   TENDERLOIN
## 13 Wednesday RICHMOND  
## 14 Wednesday TENDERLOIN
```

```r
p1 <- predict(sfcrime.1,sfcrime.new,type="probs")
d1 <- cbind(sfcrime.new,p1) ; d1
```

```
##    DayOfWeek PdDistrict   ASSAULT DRUG/NARCOTIC LARCENY/THEFT VEHICLE THEFT
## 1     Friday   RICHMOND 0.1666304    0.04944552     0.5466635    0.23726062
## 2     Friday TENDERLOIN 0.2125997    0.46581221     0.2907793    0.03080879
## 3     Monday   RICHMOND 0.1760175    0.05753044     0.5411034    0.22534869
## 4     Monday TENDERLOIN 0.2072430    0.50014661     0.2656069    0.02700348
## 5   Saturday   RICHMOND 0.1809352    0.04243108     0.5475273    0.22910644
## 6   Saturday TENDERLOIN 0.2425998    0.42007509     0.3060611    0.03126405
## 7     Sunday   RICHMOND 0.1973675    0.04496576     0.5328708    0.22479591
## 8     Sunday TENDERLOIN 0.2548597    0.42872910     0.2868682    0.02954299
## 9   Thursday   RICHMOND 0.1683841    0.06092432     0.5453260    0.22536564
## 10  Thursday TENDERLOIN 0.1938754    0.51795000     0.2617658    0.02640888
## 11   Tuesday   RICHMOND 0.1706999    0.06199196     0.5466472    0.22066087
## 12   Tuesday TENDERLOIN 0.1942447    0.52086682     0.2593331    0.02555535
## 13 Wednesday   RICHMOND 0.1709963    0.06670490     0.5424317    0.21986703
## 14 Wednesday TENDERLOIN 0.1874867    0.54002868     0.2479498    0.02453490
```

 

Richmond is obviously not a drug-dealing kind of place; most of its
crimes are theft of one kind or another. But the predicted effect of
weekday vs.\ weekend is the same: Richmond doesn't have many assaults
or drug crimes, but it also has more assaults and fewer drug crimes on
the weekend than during the week. There is not much effect of day of
the week on the other two crime types in either place.

The consistency of *pattern*, even though the prevalence of the
different crime types differs by location, is a feature of the model:
we fitted an additive model, that says there is an effect of weekday,
and *independently* there is an effect of location. The
*pattern* over weekday is the same for each location, implied by
the model. This may or may not be supported by the actual data.

The way to assess this is to fit a model with interaction (we will see
more of this when we revisit ANOVA later), and compare the fit:


```r
sfcrime.3 <- update(sfcrime.1,.~.+DayOfWeek*PdDistrict)
```

```
## # weights:  284 (210 variable)
## initial  value 498411.639069 
## iter  10 value 429631.807781
## iter  20 value 429261.427210
## iter  30 value 428111.625547
## iter  40 value 423807.031450
## iter  50 value 421129.496196
## iter  60 value 420475.833895
## iter  70 value 419523.235916
## iter  80 value 418621.612920
## iter  90 value 418147.629782
## iter 100 value 418036.670485
## final  value 418036.670485 
## stopped after 100 iterations
```

```r
# anova(sfcrime.1,sfcrime.3)
```

 

This one didn't actually complete the fitting process: it got to 100
times around and stopped (since that's the default limit). We can make
it go a bit further thus:


```r
sfcrime.3 <- update(sfcrime.1,.~.+DayOfWeek*PdDistrict,maxit=300)
```

```
## # weights:  284 (210 variable)
## initial  value 498411.639069 
## iter  10 value 429631.807781
## iter  20 value 429261.427210
## iter  30 value 428111.625547
## iter  40 value 423807.031450
## iter  50 value 421129.496196
## iter  60 value 420475.833895
## iter  70 value 419523.235916
## iter  80 value 418621.612920
## iter  90 value 418147.629782
## iter 100 value 418036.670485
## iter 110 value 417957.337016
## iter 120 value 417908.465189
## iter 130 value 417890.580843
## iter 140 value 417874.839492
## iter 150 value 417867.449342
## iter 160 value 417862.626213
## iter 170 value 417858.654628
## final  value 417858.031854 
## converged
```

```r
anova(sfcrime.1,sfcrime.3)
```

```
## Likelihood ratio tests of Multinomial Models
## 
## Response: Category
##                                           Model Resid. df Resid. Dev   Test    Df
## 1                        DayOfWeek + PdDistrict   1078536   836300.0             
## 2 DayOfWeek + PdDistrict + DayOfWeek:PdDistrict   1078374   835716.1 1 vs 2   162
##   LR stat. Pr(Chi)
## 1                 
## 2 583.8955       0
```

 

This time, we got to the end. (The `maxit=300` gets passed on
to `multinom`, and says "go around up to 300 times if needed".) 
As you will see if you try it, this takes a bit of time to
run. 

This `anova` is also strongly significant, but in the light of
the previous discussion, the differential effect of day of week in
different districts might not be very big. We can even assess that; we
have all the machinery for the predictions, and we just have to apply
them to this model:


```r
p3 <- predict(sfcrime.3,sfcrime.new,type="probs")
d3 <- cbind(sfcrime.new,p3) ; d3
```

```
##    DayOfWeek PdDistrict   ASSAULT DRUG/NARCOTIC LARCENY/THEFT VEHICLE THEFT
## 1     Friday   RICHMOND 0.1756062    0.05241934     0.5447797    0.22719474
## 2     Friday TENDERLOIN 0.2163513    0.44958359     0.3006968    0.03336831
## 3     Monday   RICHMOND 0.1668855    0.06038366     0.5537600    0.21897087
## 4     Monday TENDERLOIN 0.2061337    0.51256922     0.2569954    0.02430166
## 5   Saturday   RICHMOND 0.1859514    0.04414673     0.5244262    0.24547574
## 6   Saturday TENDERLOIN 0.2368561    0.41026767     0.3221820    0.03069417
## 7     Sunday   RICHMOND 0.1851406    0.05211970     0.5403967    0.22234300
## 8     Sunday TENDERLOIN 0.2570331    0.40019234     0.3101184    0.03265625
## 9   Thursday   RICHMOND 0.1811185    0.05621201     0.5394484    0.22322107
## 10  Thursday TENDERLOIN 0.1951851    0.52867900     0.2528465    0.02328943
## 11   Tuesday   RICHMOND 0.1758111    0.05587178     0.5471405    0.22117663
## 12   Tuesday TENDERLOIN 0.1907137    0.53955543     0.2419757    0.02775520
## 13 Wednesday   RICHMOND 0.1603796    0.06279956     0.5525565    0.22426437
## 14 Wednesday TENDERLOIN 0.1906309    0.54577677     0.2401585    0.02343381
```

 

It doesn't *look* much different. Maybe the Tenderloin has a
larger weekend increase in assaults than Richmond does. I saved these
predictions in data frames so that I could compare them. Columns 3
through 6 contain the actual predictions;  let's take the difference
between them, and glue it back onto the district and day of week. I
rounded the prediction differences off to 4 decimals to make the
largest ones easier to find:


```r
pdiff <- round(p3-p1, 4)
cbind(sfcrime.new, pdiff)
```

```
##    DayOfWeek PdDistrict ASSAULT DRUG/NARCOTIC LARCENY/THEFT VEHICLE THEFT
## 1     Friday   RICHMOND  0.0090        0.0030       -0.0019       -0.0101
## 2     Friday TENDERLOIN  0.0038       -0.0162        0.0099        0.0026
## 3     Monday   RICHMOND -0.0091        0.0029        0.0127       -0.0064
## 4     Monday TENDERLOIN -0.0011        0.0124       -0.0086       -0.0027
## 5   Saturday   RICHMOND  0.0050        0.0017       -0.0231        0.0164
## 6   Saturday TENDERLOIN -0.0057       -0.0098        0.0161       -0.0006
## 7     Sunday   RICHMOND -0.0122        0.0072        0.0075       -0.0025
## 8     Sunday TENDERLOIN  0.0022       -0.0285        0.0233        0.0031
## 9   Thursday   RICHMOND  0.0127       -0.0047       -0.0059       -0.0021
## 10  Thursday TENDERLOIN  0.0013        0.0107       -0.0089       -0.0031
## 11   Tuesday   RICHMOND  0.0051       -0.0061        0.0005        0.0005
## 12   Tuesday TENDERLOIN -0.0035        0.0187       -0.0174        0.0022
## 13 Wednesday   RICHMOND -0.0106       -0.0039        0.0101        0.0044
## 14 Wednesday TENDERLOIN  0.0031        0.0057       -0.0078       -0.0011
```

 

None of the predicted probabilities differ by more than 0.04, which is
consistent with the size of the interaction effect being small even
though significant. Some of the differences largest in size are
Drugs-Narcotics in Tenderloin, but even they are not big.

The programmer in me wants to find a way to display the largest and
smallest few differences. My idea is to use `pivot_longer` to make
*one* column of differences and sort it, then 
display the top and bottom few values. Note that
I have to put those little "backticks" around `VEHICLE THEFT`
since the variable name has a space in it. My code inefficiently sorts
the differences twice:


```r
cbind(sfcrime.new,pdiff) %>% 
  pivot_longer(ASSAULT:`VEHICLE THEFT`, names_to="crimetype", values_to = "difference") -> d1
d1 %>% arrange(difference) %>% slice(1:6)
```

```
## # A tibble: 6 x 4
##   DayOfWeek PdDistrict crimetype     difference
##   <chr>     <chr>      <chr>              <dbl>
## 1 Sunday    TENDERLOIN DRUG/NARCOTIC    -0.0285
## 2 Saturday  RICHMOND   LARCENY/THEFT    -0.0231
## 3 Tuesday   TENDERLOIN LARCENY/THEFT    -0.0174
## 4 Friday    TENDERLOIN DRUG/NARCOTIC    -0.0162
## 5 Sunday    RICHMOND   ASSAULT          -0.0122
## 6 Wednesday RICHMOND   ASSAULT          -0.0106
```

```r
d1 %>% arrange(desc(difference)) %>% slice(1:6)
```

```
## # A tibble: 6 x 4
##   DayOfWeek PdDistrict crimetype     difference
##   <chr>     <chr>      <chr>              <dbl>
## 1 Sunday    TENDERLOIN LARCENY/THEFT     0.0233
## 2 Tuesday   TENDERLOIN DRUG/NARCOTIC     0.0187
## 3 Saturday  RICHMOND   VEHICLE THEFT     0.0164
## 4 Saturday  TENDERLOIN LARCENY/THEFT     0.0161
## 5 Monday    RICHMOND   LARCENY/THEFT     0.0127
## 6 Thursday  RICHMOND   ASSAULT           0.0127
```

 

I don't know what, if anything, you make of those.

Extra: there is a better way of doing those in one go:


```r
d1 %>% top_n(6, difference)
```

```
## # A tibble: 6 x 4
##   DayOfWeek PdDistrict crimetype     difference
##   <chr>     <chr>      <chr>              <dbl>
## 1 Monday    RICHMOND   LARCENY/THEFT     0.0127
## 2 Saturday  RICHMOND   VEHICLE THEFT     0.0164
## 3 Saturday  TENDERLOIN LARCENY/THEFT     0.0161
## 4 Sunday    TENDERLOIN LARCENY/THEFT     0.0233
## 5 Thursday  RICHMOND   ASSAULT           0.0127
## 6 Tuesday   TENDERLOIN DRUG/NARCOTIC     0.0187
```

```r
d1 %>% top_n(6, -difference)
```

```
## # A tibble: 6 x 4
##   DayOfWeek PdDistrict crimetype     difference
##   <chr>     <chr>      <chr>              <dbl>
## 1 Friday    TENDERLOIN DRUG/NARCOTIC    -0.0162
## 2 Saturday  RICHMOND   LARCENY/THEFT    -0.0231
## 3 Sunday    RICHMOND   ASSAULT          -0.0122
## 4 Sunday    TENDERLOIN DRUG/NARCOTIC    -0.0285
## 5 Tuesday   TENDERLOIN LARCENY/THEFT    -0.0174
## 6 Wednesday RICHMOND   ASSAULT          -0.0106
```

 

that is just slicker. What it
actually does is almost the same as my code, but it saves you worrying about
the details. (It picks out the top 6, but without putting them in
order.) 
  





##  High School and Beyond


 A survey called High School and Beyond was given to a large
number of American high school seniors (grade 12) by the National
Center of Education Statistics. The data set at
[link](http://www.utsc.utoronto.ca/~butler/d29/hsb.csv) is a random
sample of 200 of those students.

The variables collected are:



* `gender`: student's gender, female or male.

* `race`: the student's race (African-American,
Asian,
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">I'm always amused at how Americans put all Asians    into one group.</span>  Hispanic, White).

* `ses`: Socio-economic status of student's family (low,
middle, or high)

* `schtyp`: School type, public or private.

* `prog`: Student's program, general, academic, or
vocational. 

* `read`: Score on standardized reading test.

* `write`: Score on standardized writing test.

* `math`: Score on standardized math test.

* `science`: Score on standardized science test.

* `socst`: Score on standardized social studies test.



Our aim is to see how socio-economic status is related to the other
variables. 



(a) Read in and display (some of) the data.

Solution


This is a `.csv` file (I tried to make it easy for you):

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/hsb.csv"
hsb <- read_csv(my_url)
```

```
## 
## ── Column specification ──────────────────────────────────────────────────────────────────
## cols(
##   id = col_double(),
##   race = col_character(),
##   ses = col_character(),
##   schtyp = col_character(),
##   prog = col_character(),
##   read = col_double(),
##   write = col_double(),
##   math = col_double(),
##   science = col_double(),
##   socst = col_double(),
##   gender = col_character()
## )
```

```r
hsb
```

```
## # A tibble: 200 x 11
##       id race         ses    schtyp prog        read write  math science socst gender
##    <dbl> <chr>        <chr>  <chr>  <chr>      <dbl> <dbl> <dbl>   <dbl> <dbl> <chr> 
##  1    70 white        low    public general       57    52    41      47    57 male  
##  2   121 white        middle public vocational    68    59    53      63    61 female
##  3    86 white        high   public general       44    33    54      58    31 male  
##  4   141 white        high   public vocational    63    44    47      53    56 male  
##  5   172 white        middle public academic      47    52    57      53    61 male  
##  6   113 white        middle public academic      44    52    51      63    61 male  
##  7    50 african-amer middle public general       50    59    42      53    61 male  
##  8    11 hispanic     middle public academic      34    46    45      39    36 male  
##  9    84 white        middle public general       63    57    54      58    51 male  
## 10    48 african-amer middle public academic      57    55    52      50    51 male  
## # … with 190 more rows
```

       


(b) Explain briefly why an ordinal logistic regression is
appropriate for our aims.

Solution


The response variable `ses` is categorical, with
categories that come in order (low less than middle less than
high). 


(c) Fit an ordinal logistic regression predicting
socio-economic status from the scores on the five standardized
tests. (You don't need to display the results.) You will probably
go wrong the first time. What kind of thing does your response
variable have to be? 

Solution


It has to be an `ordered` factor, which you can create in
the data frame (or outside, if you prefer):

```r
hsb <- hsb %>% mutate(ses = ordered(ses, c("low", "middle", "high")))
hsb
```

```
## # A tibble: 200 x 11
##       id race         ses    schtyp prog        read write  math science socst gender
##    <dbl> <chr>        <ord>  <chr>  <chr>      <dbl> <dbl> <dbl>   <dbl> <dbl> <chr> 
##  1    70 white        low    public general       57    52    41      47    57 male  
##  2   121 white        middle public vocational    68    59    53      63    61 female
##  3    86 white        high   public general       44    33    54      58    31 male  
##  4   141 white        high   public vocational    63    44    47      53    56 male  
##  5   172 white        middle public academic      47    52    57      53    61 male  
##  6   113 white        middle public academic      44    52    51      63    61 male  
##  7    50 african-amer middle public general       50    59    42      53    61 male  
##  8    11 hispanic     middle public academic      34    46    45      39    36 male  
##  9    84 white        middle public general       63    57    54      58    51 male  
## 10    48 african-amer middle public academic      57    55    52      50    51 male  
## # … with 190 more rows
```

  

`ses` is now `ord`. Good. Now fit the model:


```r
ses.1 <- polr(ses ~ read + write + math + science + socst, data = hsb)
```

       

No errors is good.


(d) Remove any non-significant explanatory variables one at a
time. Use `drop1` to decide which one to remove next.

Solution



```r
drop1(ses.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## ses ~ read + write + math + science + socst
##         Df    AIC    LRT Pr(>Chi)   
## <none>     404.63                   
## read     1 403.09 0.4620 0.496684   
## write    1 403.81 1.1859 0.276167   
## math     1 403.19 0.5618 0.453517   
## science  1 404.89 2.2630 0.132499   
## socst    1 410.08 7.4484 0.006349 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

       

I would have expected the AIC column to come out in order, but it
doesn't. Never mind. Scan for the largest P-value, which belongs to
`read`. (This also has the lowest AIC.) So, remove `read`:


```r
ses.2 <- update(ses.1, . ~ . - read)
drop1(ses.2, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## ses ~ write + math + science + socst
##         Df    AIC    LRT Pr(>Chi)   
## <none>     403.09                   
## write    1 402.10 1.0124 0.314325   
## math     1 402.04 0.9541 0.328689   
## science  1 404.29 3.1968 0.073782 . 
## socst    1 410.58 9.4856 0.002071 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

Note how the P-value for `science` has come down a long way.

A close call, but `math` goes next.  The `update`
doesn't take long to type:


```r
ses.3 <- update(ses.2, . ~ . - math)
drop1(ses.3, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## ses ~ write + science + socst
##         Df    AIC     LRT  Pr(>Chi)    
## <none>     402.04                      
## write    1 400.60  0.5587 0.4547813    
## science  1 405.41  5.3680 0.0205095 *  
## socst    1 411.07 11.0235 0.0008997 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

`science` has become significant now (probably because it was
strongly correlated with at least one of the variables we removed (at
my guess, `math`). That is, we didn't need both
`science` and `math`, but we *do* need *one* of
them. 

I think we can guess what will happen now: `write` comes out,
and the other two variables will stay, so that'll be where we stop:


```r
ses.4 <- update(ses.3, . ~ . - write)
drop1(ses.4, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## ses ~ science + socst
##         Df    AIC     LRT  Pr(>Chi)    
## <none>     400.60                      
## science  1 403.45  4.8511 0.0276291 *  
## socst    1 409.74 11.1412 0.0008443 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

Indeed so. We need just the science and social studies test scores to
predict socio-economic status.

Using AIC to decide on which variable to remove next will give the
same answer here, but I would like to see the `test=` part in
your `drop1` to give P-values (expect to lose something, but
not too much, if that's not there).

Extras: I talked about correlation among the explanatory variables
earlier, which I can explore:


```r
hsb %>% dplyr::select(read:socst) %>% cor()
```

```
##              read     write      math   science     socst
## read    1.0000000 0.5967765 0.6622801 0.6301579 0.6214843
## write   0.5967765 1.0000000 0.6174493 0.5704416 0.6047932
## math    0.6622801 0.6174493 1.0000000 0.6307332 0.5444803
## science 0.6301579 0.5704416 0.6307332 1.0000000 0.4651060
## socst   0.6214843 0.6047932 0.5444803 0.4651060 1.0000000
```

 

The first time I did this, I forgot that I had `MASS` loaded
(for the `polr`), and so, to get the right `select`, I
needed to say which one I wanted.

Anyway, the correlations are all moderately high. There's nothing that
stands out as being much higher than the others. The lowest two are
between social studies and math, and social studies and science. That
would be part of the reason that social studies needs to stay. The
highest correlation is between math and reading, which surprises me
(they seem to be different skills).

So there was not as much insight there as I expected.

The other thing is that you can use `step` for the
variable-elimination task as well:


```r
ses.5 <- step(ses.1, direction = "backward", test = "Chisq")
```

```
## Start:  AIC=404.63
## ses ~ read + write + math + science + socst
## 
##           Df    AIC    LRT Pr(>Chi)   
## - read     1 403.09 0.4620 0.496684   
## - math     1 403.19 0.5618 0.453517   
## - write    1 403.81 1.1859 0.276167   
## <none>       404.63                   
## - science  1 404.89 2.2630 0.132499   
## - socst    1 410.08 7.4484 0.006349 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Step:  AIC=403.09
## ses ~ write + math + science + socst
## 
##           Df    AIC    LRT Pr(>Chi)   
## - math     1 402.04 0.9541 0.328689   
## - write    1 402.10 1.0124 0.314325   
## <none>       403.09                   
## - science  1 404.29 3.1968 0.073782 . 
## - socst    1 410.58 9.4856 0.002071 **
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Step:  AIC=402.04
## ses ~ write + science + socst
## 
##           Df    AIC     LRT  Pr(>Chi)    
## - write    1 400.60  0.5587 0.4547813    
## <none>       402.04                      
## - science  1 405.41  5.3680 0.0205095 *  
## - socst    1 411.07 11.0235 0.0008997 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Step:  AIC=400.6
## ses ~ science + socst
## 
##           Df    AIC     LRT  Pr(>Chi)    
## <none>       400.60                      
## - science  1 403.45  4.8511 0.0276291 *  
## - socst    1 409.74 11.1412 0.0008443 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

I would accept you doing it this way, again \emph{as long as you have
the `test=` there as well}.



(e) The quartiles of the `science` test score are 44 
and 58. The quartiles of the `socst` test score are 46 and 61. Make
a data frame that has all combinations of those quartiles. If your best
regression had any other explanatory variables in it, also put the
*medians* of those variables into this data frame.


Solution


Thus, most obviously:

```r
sciences <- c(44, 58)
socsts <- c(46, 61)
new <- crossing(science = sciences, socst = socsts)
new
```

```
## # A tibble: 4 x 2
##   science socst
##     <dbl> <dbl>
## 1      44    46
## 2      44    61
## 3      58    46
## 4      58    61
```

  

Since there are only two variables left, this new data frame has only
$2^2=4$ rows.

There is a veiled hint here that these are the two variables that
should have remained in your regression. If that was not what you got,
find the median of any other variables you had, and put that into your
`new`. For example, if you still had `math`, you'd do
this:
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">That is *maths* as the apparently-plural of  *math*, not as the British name for mathematics.</span>


```r
hsb %>% summarize(m = median(math))
```

```
## # A tibble: 1 x 1
##       m
##   <dbl>
## 1    52
```

```r
maths <- 52
new2 <- crossing(science = sciences, socst = socsts, math = maths)
new2
```

```
## # A tibble: 4 x 3
##   science socst  math
##     <dbl> <dbl> <dbl>
## 1      44    46    52
## 2      44    61    52
## 3      58    46    52
## 4      58    61    52
```

 



(f) Use the data frame you created in the previous part, together
with your best model, to obtain predicted probabilities of being in
each `ses` category.


Solution


This is `predict`, and we've done the setup. My best model
was called `ses.4`:

```r
p <- predict(ses.4, new, type = "probs")
cbind(new, p)
```

```
##   science socst       low    middle      high
## 1      44    46 0.3262510 0.5056113 0.1681377
## 2      44    61 0.1885566 0.5150763 0.2963671
## 3      58    46 0.2278105 0.5230783 0.2491112
## 4      58    61 0.1240155 0.4672338 0.4087507
```

   

If you forgot which `type` to use, guess one that's obviously
wrong, and it will tell you what your options are. That ought to be
enough to trigger your memory of the right thing.

If you get the `type` right, but the `predict` still
doesn't work, check the construction  of your `new` data frame
very carefully. That's likely where your problem is.



(g) What is the effect of an increased science score on the
likelihood of a student being in the different socioeconomic groups,
all else equal?  Explain briefly. In your explanation, state clearly
how you are using your answer to the previous part.


Solution


Use your predictions; hold the `socst` score constant (that's
the all else equal part). So compare the first and third rows (or,
if you like, the second and fourth rows) of your predictions and see
what happens as the science score goes from 44 to 58.
What I see is that the probability of being `low` goes
noticeably *down* as the science score increases, the
probability of `middle` stays about the same, and the
probability of `high` goes `up` (by about the same
amount as the probability of `low` went down). 
In other words, an increased science score goes with an increased
chance of `high` (and a decreased chance of `low`).
If your best model doesn't have `science` in it, then you
need to say something like "`science` has no effect on   socio-economic status", 
consistent with what you concluded before: if
you took it out, it's because you thought it had no effect.
Extra: the effect of an increased social studies score is almost
exactly the same as an increased science score (so I didn't ask you
about that). From a social-science  point of view, this makes
perfect sense: the higher the social-economic stratum a student
comes from, the better they are likely to do in school. 
I've been phrasing this as "association", because really the cause
and effect is the other way around: a student's family socioeconomic
status is explanatory, and school performance is response. But this
was the nicest example I could find of an ordinal response data set.






##  What sports do these athletes play?


 The data at
[link](http://www.utsc.utoronto.ca/~butler/c32/ais.txt) are physical
and physiological measurements of 202 male and female Australian elite
athletes. The data values are separated by *tabs*. We are going
to see whether we can predict the sport an athlete plays from their
height and weight.

The sports, if you care, are respectively basketball, 
"field athletics" (eg. shot put, javelin throw, long jump etc.),
gymnastics, netball, rowing, swimming, 400m running, tennis, sprinting
(100m or 200m running), water polo.



(a) Read in the data and display the first few rows.

Solution


The data values are separated by tabs, so `read_tsv` is
the thing:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/c32/ais.txt"
athletes <- read_tsv(my_url)
```

```
## 
## ── Column specification ──────────────────────────────────────────────────────────────────
## cols(
##   Sex = col_character(),
##   Sport = col_character(),
##   RCC = col_double(),
##   WCC = col_double(),
##   Hc = col_double(),
##   Hg = col_double(),
##   Ferr = col_double(),
##   BMI = col_double(),
##   SSF = col_double(),
##   `%Bfat` = col_double(),
##   LBM = col_double(),
##   Ht = col_double(),
##   Wt = col_double()
## )
```

```r
athletes
```

```
## # A tibble: 202 x 13
##    Sex    Sport     RCC   WCC    Hc    Hg  Ferr   BMI   SSF `%Bfat`   LBM    Ht    Wt
##    <chr>  <chr>   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl> <dbl> <dbl> <dbl>
##  1 female Netball  4.56  13.3  42.2  13.6    20  19.2  49      11.3  53.1  177.  59.9
##  2 female Netball  4.15   6    38    12.7    59  21.2 110.     25.3  47.1  173.  63  
##  3 female Netball  4.16   7.6  37.5  12.3    22  21.4  89      19.4  53.4  176   66.3
##  4 female Netball  4.32   6.4  37.7  12.3    30  21.0  98.3    19.6  48.8  170.  60.7
##  5 female Netball  4.06   5.8  38.7  12.8    78  21.8 122.     23.1  56.0  183   72.9
##  6 female Netball  4.12   6.1  36.6  11.8    21  21.4  90.4    16.9  56.4  178.  67.9
##  7 female Netball  4.17   5    37.4  12.7   109  21.5 107.     21.3  53.1  177.  67.5
##  8 female Netball  3.8    6.6  36.5  12.4   102  24.4 157.     26.6  54.4  174.  74.1
##  9 female Netball  3.96   5.5  36.3  12.4    71  22.6 101.     17.9  56.0  174.  68.2
## 10 female Netball  4.44   9.7  41.4  14.1    64  22.8 126.     25.0  51.6  174.  68.8
## # … with 192 more rows
```

     

If you didn't remember that, this also works:


```r
athletes <- read_delim(my_url, "\t")
```

```
## 
## ── Column specification ──────────────────────────────────────────────────────────────────
## cols(
##   Sex = col_character(),
##   Sport = col_character(),
##   RCC = col_double(),
##   WCC = col_double(),
##   Hc = col_double(),
##   Hg = col_double(),
##   Ferr = col_double(),
##   BMI = col_double(),
##   SSF = col_double(),
##   `%Bfat` = col_double(),
##   LBM = col_double(),
##   Ht = col_double(),
##   Wt = col_double()
## )
```

 

(this is the R way of expressing "tab".)


(b) Make a scatterplot of height vs.\ weight, with the points
coloured by what sport the athlete plays. Put height on the $x$-axis
and weight on the $y$-axis.

Solution


I'm doing this to give you a little intuition for later:

```r
ggplot(athletes, aes(x = Ht, y = Wt, colour = Sport)) + geom_point()
```

<img src="16-ordinal-nominal-response_files/figure-html/unnamed-chunk-151-1.png" width="672"  />

     

The reason for giving you the axes to use is (i) neither variable is
really a response, so it doesn't actually matter which one goes on
which axis, and (ii) I wanted to give the grader something consistent
to look at.


(c) Explain briefly why a multinomial model (`multinom`
from `nnet`) would be the best thing to use to predict sport
played from the other variables.

Solution


The categories of `Sport` are not in any kind of order, and
there are more than two of them.
That's really all you needed, for which two marks is kind of
generous. 


(d) Fit a suitable model for predicting sport played from
height and weight. (You don't need to look at the results.) 100
steps isn't quite enough, so set `maxit` equal to a larger
number to allow the estimation to finish.

Solution


120 steps is actually enough, but any number larger than 110 is
fine. It doesn't matter if your guess is way too high. Like this:


```r
library(nnet)
sport.1 <- multinom(Sport ~ Ht + Wt, data = athletes, maxit = 200)
```

```
## # weights:  40 (27 variable)
## initial  value 465.122189 
## iter  10 value 410.089598
## iter  20 value 391.426721
## iter  30 value 365.829150
## iter  40 value 355.326457
## iter  50 value 351.255395
## iter  60 value 350.876479
## iter  70 value 350.729699
## iter  80 value 350.532323
## iter  90 value 350.480130
## iter 100 value 350.349271
## iter 110 value 350.312029
## final  value 350.311949 
## converged
```

 

As long as you see the word `converged` at the end, you're
good. 


(e) Demonstrate using `anova` that `Wt` should
not be removed from this model.

Solution


The idea is to fit a model without `Wt`, and then show that
it fits significantly worse:

```r
sport.2 <- update(sport.1, . ~ . - Wt)
```

```
## # weights:  30 (18 variable)
## initial  value 465.122189 
## iter  10 value 447.375728
## iter  20 value 413.597441
## iter  30 value 396.685596
## iter  40 value 394.121380
## iter  50 value 394.116993
## iter  60 value 394.116434
## final  value 394.116429 
## converged
```

```r
anova(sport.2, sport.1, test = "Chisq")
```

```
## Likelihood ratio tests of Multinomial Models
## 
## Response: Sport
##     Model Resid. df Resid. Dev   Test    Df LR stat.      Pr(Chi)
## 1      Ht      1800   788.2329                                   
## 2 Ht + Wt      1791   700.6239 1 vs 2     9 87.60896 4.884981e-15
```

     

The P-value is very small indeed, so the bigger model `sport.1`
is definitely better (or the smaller model `sport.2` is
significantly worse, however you want to say it). So taking
`Wt` out is definitely a mistake. 

This is what I would have guessed (I actually wrote the question in
anticipation of this being the answer) because weight certainly seems
to help in distinguishing the sports. For example, the field athletes
seem to be heavy for their height compared to the other athletes (look
back at the graph you made). 

`drop1`, the obvious thing, doesn't work here:


```r
drop1(sport.1, test = "Chisq", trace = T)
```

```
## trying - Ht
```

```
## Error in if (trace) {: argument is not interpretable as logical
```

 

I gotta figure out what that error is.
Does `step`?


```r
step(sport.1, direction = "backward", test = "Chisq")
```

```
## Start:  AIC=754.62
## Sport ~ Ht + Wt
## 
## trying - Ht 
## # weights:  30 (18 variable)
## initial  value 465.122189 
## iter  10 value 441.367394
## iter  20 value 381.021649
## iter  30 value 380.326030
## final  value 380.305003 
## converged
## trying - Wt 
## # weights:  30 (18 variable)
## initial  value 465.122189 
## iter  10 value 447.375728
## iter  20 value 413.597441
## iter  30 value 396.685596
## iter  40 value 394.121380
## iter  50 value 394.116993
## iter  60 value 394.116434
## final  value 394.116429 
## converged
##        Df      AIC
## <none> 27 754.6239
## - Ht   18 796.6100
## - Wt   18 824.2329
```

```
## Call:
## multinom(formula = Sport ~ Ht + Wt, data = athletes, maxit = 200)
## 
## Coefficients:
##         (Intercept)         Ht          Wt
## Field      59.98535 -0.4671650  0.31466413
## Gym       112.49889 -0.5027056 -0.57087657
## Netball    47.70209 -0.2947852  0.07992763
## Row        35.90829 -0.2517942  0.14164007
## Swim       36.82832 -0.2444077  0.10544986
## T400m      32.73554 -0.1482589 -0.07830622
## Tennis     41.92855 -0.2278949 -0.01979877
## TSprnt     51.43723 -0.3359534  0.12378285
## WPolo      23.35291 -0.2089807  0.18819526
## 
## Residual Deviance: 700.6239 
## AIC: 754.6239
```

 

Curiously enough, it does. The final model is the same as the initial
one, telling us that neither variable should be removed.


(f) Make a data frame consisting of all combinations of
`Ht` 160, 180 and 200 (cm), and `Wt` 50, 75, and 100
(kg), and use it to obtain predicted probabilities of athletes of
those heights and weights playing each of the sports. Display the
results. You might have to display them smaller, or reduce the
number of decimal places
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">For this, use *round*.</span> 
to fit them on the page.

Solution


This is (again) the easier way: fill vectors with the given
values, use `crossing` to get the combinations, and feed
that into `predict`, thus:

```r
Hts <- c(160, 180, 200)
Wts <- c(50, 75, 100)
new <- crossing(Ht = Hts, Wt = Wts)
new
```

```
## # A tibble: 9 x 2
##      Ht    Wt
##   <dbl> <dbl>
## 1   160    50
## 2   160    75
## 3   160   100
## 4   180    50
## 5   180    75
## 6   180   100
## 7   200    50
## 8   200    75
## 9   200   100
```

  

and then


```r
p <- predict(sport.1, new, type = "probs")
cbind(new, p)
```

```
##    Ht  Wt        BBall        Field          Gym      Netball          Row         Swim
## 1 160  50 2.147109e-03 5.676191e-03 7.269646e-02 0.1997276344 0.0320511810 0.0429354624
## 2 160  75 1.044581e-04 7.203893e-01 2.240720e-09 0.0716686494 0.0537984065 0.0291616004
## 3 160 100 5.541050e-08 9.968725e-01 7.530504e-19 0.0002804029 0.0009845934 0.0002159577
## 4 180  50 9.142760e-02 2.116103e-05 1.331347e-04 0.0233985667 0.0088717680 0.0137765580
## 5 180  75 7.787300e-02 4.701849e-02 7.184344e-11 0.1469948033 0.2607097148 0.1638164831
## 6 180 100 5.379479e-04 8.473139e-01 3.144321e-19 0.0074895973 0.0621366751 0.0157985864
## 7 200  50 6.907544e-01 1.399715e-08 4.326057e-08 0.0004863664 0.0004357120 0.0007843113
## 8 200  75 8.889269e-01 4.698989e-05 3.527126e-14 0.0046164597 0.0193454719 0.0140908812
## 9 200 100 2.738448e-01 3.776290e-02 6.884080e-21 0.0104894025 0.2056152576 0.0606015871
##          T400m       Tennis       TSprnt        WPolo
## 1 3.517558e-01 1.885847e-01 1.033315e-01 1.094045e-03
## 2 2.416185e-03 5.592833e-03 1.109879e-01 5.880674e-03
## 3 1.809594e-07 1.808504e-06 1.299813e-03 3.446523e-04
## 4 7.721547e-01 8.418976e-02 5.313751e-03 7.129763e-04
## 5 9.285706e-02 4.371258e-02 9.992310e-02 6.709478e-02
## 6 9.056685e-05 1.840761e-04 1.523963e-02 5.120898e-02
## 7 3.007396e-01 6.668610e-03 4.848339e-05 8.244005e-05
## 8 5.464293e-02 5.231368e-03 1.377496e-03 1.172154e-02
## 9 2.376695e-03 9.824069e-04 9.368804e-03 3.989581e-01
```

 

I'll take this, but read on for an improvement.

This still spills onto a second line (even printed this small). Let's
round the predicted probabilities to 2 decimals, which, with luck,
will also kill the scientific notation:


```r
cbind(new, round(p, 2))
```

```
##    Ht  Wt BBall Field  Gym Netball  Row Swim T400m Tennis TSprnt WPolo
## 1 160  50  0.00  0.01 0.07    0.20 0.03 0.04  0.35   0.19   0.10  0.00
## 2 160  75  0.00  0.72 0.00    0.07 0.05 0.03  0.00   0.01   0.11  0.01
## 3 160 100  0.00  1.00 0.00    0.00 0.00 0.00  0.00   0.00   0.00  0.00
## 4 180  50  0.09  0.00 0.00    0.02 0.01 0.01  0.77   0.08   0.01  0.00
## 5 180  75  0.08  0.05 0.00    0.15 0.26 0.16  0.09   0.04   0.10  0.07
## 6 180 100  0.00  0.85 0.00    0.01 0.06 0.02  0.00   0.00   0.02  0.05
## 7 200  50  0.69  0.00 0.00    0.00 0.00 0.00  0.30   0.01   0.00  0.00
## 8 200  75  0.89  0.00 0.00    0.00 0.02 0.01  0.05   0.01   0.00  0.01
## 9 200 100  0.27  0.04 0.00    0.01 0.21 0.06  0.00   0.00   0.01  0.40
```

 
Better. Much better.
    

(g) For an athlete who is 180 cm tall and weighs 100 kg, what
 sport would you guess they play? How sure are you that you are
 right? Explain briefly.

Solution


Find this height and weight in your predictions (it's row 6). Look
along the line for the highest probability, which is 0.85 for
`Field` (that is, field athletics). All the other
probabilities are much smaller (the biggest of the others is
0.06). So this means we would guess the athlete to be a field
athlete, and because the predicted probability is so big, we are
very likely to be right.
This kind of thought process is characteristic of discriminant
analysis, which we'll see more of later in the course.
Compare that with the scatterplot you drew earlier: the field
athletes do seem to be distinct from the rest in terms of
height-weight combination. 
Some of the other height-weight combinations are almost equally
obvious: for example, very tall people who are not very heavy are
likely to play basketball. 400m runners are likely to be of
moderate height but light weight. Some of the other sports, or
height-weight combinations, are difficult to judge. Consider also
that we have mixed up males and females in this data set. We might
gain some clarity by including `Sex` in the model, and also
in the predictions. But I wanted to keep this question relatively
simple for you, and I wanted to stop from getting unreasonably
long. (You can decide whether you think it's already too long.)
 



