# Power and sample size


```r
library(tidyverse)
```






##  Simulating power


 This question investigates power by
simulation.


(a) Use `rnorm` to generate 10 random values from a
normal distribution with mean 20 and SD 2. Do your values look
reasonable? Explain briefly. (You don't need to draw a graph.)


Solution


`rnorm` with the number of values first, then the mean,
then the SD:



```r
x = rnorm(10, 20, 2)
x
```

```
##  [1] 21.59476 18.64044 21.83231 18.76556 18.64861 21.81889 21.62614 20.18249
##  [9] 16.91266 20.63490
```

95\% of the sampled values should be within 2 SDs of the mean, that
is, between 16 and 24 (or 99.7\% should be within 3 SDs of the mean,
between 14 and 26). None of my values are even outside the interval 16
to 24, though yours may be different.

I saved mine in a variable and then displayed them, which you don't
need to do. I did because there's another way of assessing them for
reasonableness: turn the sample into $z$-scores and see whether the
values you get look like $z$-scores (that is, most of them are between
$-2$ and 2, for example):


```r
(x - 20)/2
```

```
##  [1]  0.79738130 -0.67977910  0.91615386 -0.61722168 -0.67569291  0.90944266
##  [7]  0.81307163  0.09124563 -1.54367207  0.31744905
```

These ones look very much like $z$-scores. This, if you think about
it, is really the flip-side of 68--95--99.7, so it's another way of
implementing the same idea.

You might also think of finding the *sample* mean and SD, and
demonstrating that they are close to the right answers. Mine are:


```r
mean(x)
```

```
## [1] 20.06568
```

```r
sd(x)
```

```
## [1] 1.731305
```

The sample SD is more variable than the sample mean, so it can get
further away from the population SD than the sample mean does from the
population mean. 

The downside to this idea is that it doesn't get at
assessing the normality, which looking at $z$-scores or equivalent
does. Maybe coupling the above with a boxplot would have helped, had I
not said "no graphs", since then you'd (hopefully) see no outliers
and a roughly symmetric shape.

This is old-fashioned "base R" technology; you could do it with a
data frame like this:


```r
d = tibble(x = rnorm(10, 20, 2))
d
```

```
## # A tibble: 10 x 1
##        x
##    <dbl>
##  1  20.6
##  2  19.3
##  3  20.2
##  4  18.7
##  5  21.3
##  6  17.8
##  7  19.8
##  8  20.9
##  9  21.7
## 10  20.6
```

```r
d %>% summarize(m = mean(x), s = sd(x))
```

```
## # A tibble: 1 x 2
##       m     s
##   <dbl> <dbl>
## 1  20.1  1.21
```

These are different random numbers, but are about equally what you'd
expect. (These ones are a bit less variable than you'd expect, but
with only ten values, don't expect perfection.)

Some discussion about the kind of values you should get, and whether
or not you get them, is what is called for here. I want you to say
something convincing about how the values you get come from a normal
distribution with mean 20 *and* SD 2.  "Close to 20" is not the
whole answer here, because that doesn't get at "how close to 20?":
that is, it talks about the mean but not about the SD.



(b) Estimate by simulation the power of a $t$-test to reject a
null hypothesis of 20 when the true mean is also 20, the
population SD is 2, and the sample size is 10, against a (default)
two-sided alternative. Remember the
steps: (i) generate a lot of random samples from the true
distribution, (ii) run the $t$-test with the required null mean, (iii) pull out the P-values, (iv) count how many of them are 0.05
or less.


Solution


Once you get the hang of these, they all look almost the
same. This one is easier than some because we don't have to do
anything special to get a two-sided alternative hypothesis:

```r
pvals <- rerun(1000, rnorm(10, 20, 2)) %>% map(~t.test(., mu = 20)) %>% map_dbl("p.value")
tibble(pvals) %>% count(pvals <= 0.05)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE             958
## 2 TRUE               42
```

The power is about 4.2\%. This seems depressingly small, but see the
next part.



(c) In the simulation you just did, was the null hypothesis true
or false? Do you want to reject the null hypothesis or not?
Explain briefly why the simulation results you got were (or were
not) about what you would expect.


Solution


The null mean and the true  mean were both 20: that is, the
null hypothesis was correct, and rejecting it would be a
mistake, to be precise a type I error. We were doing the test
at $\alpha=0.05$ (by comparing our collection of simulated
P-values with 0.05), so we should be making a type I error 5\%
of the time. This is entirely in line with the 4.2\% of
(wrong) rejections that I had.
Your estimation is likely to be different from mine, but you
should be rejecting about 5\% of the time. If your result is
very different from 5\%, that's an invitation to go back and
check your code. On the other hand, if it *is* about 5\%,
that ought to give you confidence to go on and use the same
ideas for the next part.



(d) By copying, pasting and editing your code from the previous
part, estimate the power of the test of $H_0: \mu=20$ (against a
two-sided alternative) when the true population mean is 22 (rather
than 20).


Solution


Here's the code we just used:


```r
pvals <- rerun(1000, rnorm(10, 20, 2)) %>% map(~t.test(., mu = 20)) %>% map_dbl("p.value")
tibble(pvals) %>% count(pvals <= 0.05)
```

One of those 20s needs to become 22. Not the one in the
`t.test`, since the hypotheses have not changed.  So we need to
change the 20 in the `rnorm` line to 22, since that's where
we're generating data from the true distribution. The rest of it stays
the same:


```r
pvals <- rerun(1000, rnorm(10, 22, 2)) %>% map(~t.test(., mu = 20)) %>% map_dbl("p.value")
tibble(pvals) %>% count(pvals <= 0.05)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE             202
## 2 TRUE              798
```

This time, we *want* to reject, since the null hypothesis is
false. So look at the `TRUE` count of 798: the power is about
$798/1000 \simeq 80\%$. We are very likely to correctly reject a null
of 20 when the mean is actually 22.

Another way to reason that the power should be fairly large is to
think about what kind of sample you are likely to get from the true
distribution: one with a mean around 22 and an SD around 2. Thus the
$t$-statistic should be somewhere around this (we have a sample size
of 10):


```r
t_stat = (22 - 20)/(2/sqrt(10))
t_stat
```

```
## [1] 3.162278
```

and the two-sided P-value should be about


```r
2 * (1 - pt(t_stat, 10 - 1))
```

```
## [1] 0.01150799
```

Of course, with your actual data, you will sometimes be less lucky
than this (a sample mean nearer 20 or a larger sample SD), but
sometimes you will be luckier. But the suggestion is that most of the
time, the P-value will be pretty small and you will end up correctly
rejecting. 

The quantity `t_stat` above, 3.16, is known to some
people as an "effect size", and summarizes how far apart the null
and true means are, relative to the amount of variability present (in
the sampling distribution of the sample mean). As effect sizes go,
this one is pretty large.



(e) Use R to calculate this power exactly (without
simulation). Compare the exact result with your simulation.


Solution


This is `power.t.test`. The quantity `delta` is
the difference between true and null means:

```r
power.t.test(n = 10, delta = 22 - 20, sd = 2, type = "one.sample", alternative = "two.sided")
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 10
##           delta = 2
##              sd = 2
##       sig.level = 0.05
##           power = 0.8030962
##     alternative = two.sided
```

This, 0.803, is very close to the 0.798 I got from my
simulation. Which makes me think I did them both right. This is not a watertight proof, though: for example, I might have made a mistake and gotten lucky somewhere. But it does at least give me confidence.
Extra: when you estimate power by simulation, what you are doing is
rejecting or not with a certain probability (which is the same for all
simulations). So the number of times you actually *do* reject has
a binomial distribution with $n$ equal to the number of simulated
P-values you got (1000 in my case; you could do more) and a $p$ that
the simulation is trying to estimate. This is inference for a
proportion, exactly what `prop.test` does.

Recall that `prop.test` has as input:


* a number of "successes" (rejections of the null in our case)

* the number of trials (simulated tests)

* the null-hypothesis value of `p` (optional if you only
want a CI)

* (optional) a confidence level `conf.level`.


In part (b), we knew that the probability of
(incorrectly) rejecting should have been 0.05 and we rejected 42 times
out of 1000:


```r
prop.test(42, 1000, 0.05)
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  42 out of 1000, null probability 0.05
## X-squared = 1.1842, df = 1, p-value = 0.2765
## alternative hypothesis: true p is not equal to 0.05
## 95 percent confidence interval:
##  0.03079269 0.05685194
## sample estimates:
##     p 
## 0.042
```

Looking at the P-value, we definitely fail to reject that the
probability of (incorrectly) rejecting is the 0.05 that it should
be. Ouch. That's true, but unnecessarily confusing. Look at the
confidence interval instead, 0.031 to 0.057. The right answer is 0.05,
which is inside that interval, so good.

In part (c), we didn't know what the power was going
to be (not until we calculated it with `power.t.test`, anyway),
so we go straight for a confidence interval; the default 95\% confidence
level is fine. We (correctly) rejected 798 times out of 1000:


```r
prop.test(798, 1000)
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  798 out of 1000, null probability 0.5
## X-squared = 354.02, df = 1, p-value < 2.2e-16
## alternative hypothesis: true p is not equal to 0.5
## 95 percent confidence interval:
##  0.7714759 0.8221976
## sample estimates:
##     p 
## 0.798
```

I left out the 3rd input since we're not doing a test, and ignore the
P-value that comes out. (The default null proportion is 0.5, which
often makes sense, but not here.)

According to the confidence interval, the estimated power is between
0.771 and 0.822. This interval definitely includes what we now know is
the right answer of 0.803.

This might be an accurate enough assessment of the power for you, but
if not, you can do more simulations, say 10,000:


```r
pvals <- rerun(10000, rnorm(10, 22, 2)) %>% map(~t.test(., mu = 20)) %>% map_dbl("p.value")
tibble(pvals) %>% count(pvals <= 0.05)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE            2004
## 2 TRUE             7996
```

I copied and pasted my code again, which means that I'm dangerously
close to turning it into a function, but anyway.

The confidence interval for the power is then


```r
prop.test(7996, 10000)
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  7996 out of 10000, null probability 0.5
## X-squared = 3589.2, df = 1, p-value < 2.2e-16
## alternative hypothesis: true p is not equal to 0.5
## 95 percent confidence interval:
##  0.7915892 0.8073793
## sample estimates:
##      p 
## 0.7996
```

that is, from 0.792 to 0.807, which once again includes the right
answer of 0.803. The first interval, based on 1,000 simulations, has
length 0.051, while this interval has length 0.015.  The first
interval is more than three times as long as the second, which is
about what you'd expect since the first one is based on 10 times fewer
simulations, and thus ought to be a factor of $\sqrt{10}\simeq 3.16$
times longer.

This means that you can estimate power as accurately as you like by
doing a large enough number of simulations. Provided, that is, that
you are prepared to wait a possibly long time for it to finish working!






##  Calculating power and sample size for estimating mean


 We are planning a study to estimate a population mean. The
population standard deviation is believed to be 20, and the population
distribution is believed to be approximately normal. We will be
testing the null hypothesis that the population mean is 100. Suppose
the population mean is actually 110, and we want to determine how
likely we are to (correctly) reject the null hypothesis in this case,
using a two-sided (but one-sample) test with $\alpha=0.05$.



(a) We will take a sample of size $n=30$. Calculate the power of
this test.


Solution


`power.t.test`. Fill in: sample size `n`, difference
in means `delta` ($10=110-100$), population SD `sd`,
type of test `type` (`one.sample`) and kind of
alternative hypothesis `alternative`
(`two.sided`). Leave out `power` since that's what
we want:


```r
power.t.test(n = 30, delta = 10, sd = 20, type = "one.sample", alternative = "two.sided")
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 30
##           delta = 10
##              sd = 20
##       sig.level = 0.05
##           power = 0.7539627
##     alternative = two.sided
```

I meant "calculate" exactly rather than "estimate" (by
simulation). Though if you want to, you can do that as well, thus:


```r
pvals <- rerun(1000, rnorm(30, 110, 20)) %>% map(~t.test(., mu = 100)) %>% map_dbl("p.value")
tibble(pvals) %>% count(pvals <= 0.05)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE             257
## 2 TRUE              743
```

That came out alarmingly close to the exact answer. 



(b) Find the sample size necessary to obtain a power
of at least 0.80 under these conditions. What sample size do you
need? Explain briefly how your answer is
consistent with (a).


Solution


Again, the implication is "by calculation".
This time, in `power.t.test`, put in 0.80 for
`power` and leave out `n`. The order of things
doesn't matter (since I have named everything that's going into
`power.t.test`): 


```r
power.t.test(delta = 10, power = 0.8, sd = 20, type = "one.sample", alternative = "two.sided")
```

```
## 
##      One-sample t test power calculation 
## 
##               n = 33.3672
##           delta = 10
##              sd = 20
##       sig.level = 0.05
##           power = 0.8
##     alternative = two.sided
```

To get sample size for power at least 0.80, we have to round 33.36
*up* to the next whole number, ie.\ $n=34$ is needed. (A sample
of size 33 wouldn't quite have enough power.)

This answer is consistent with (a) because a sample size of 30 gave a
power a bit less than 0.80, and so to increase the power by a little
(0.75 to 0.80),
we had to increase the sample size by a little (30 to 34).

Estimating sample sizes by simulation is tricky, because the sample size
has to be input to the simulation. That means your only strategy is to
try different sample sizes until you find one that gives the right power.

In this case, we know that a sample of size 30 doesn't give quite
enough power, so we have to up the sample size a bit. How about we try
40? I copied and pasted my code from above and changed 30 to 40:


```r
pvals <- rerun(1000, rnorm(40, 110, 20)) %>% map(~t.test(., mu = 100)) %>% map_dbl("p.value")
tibble(pvals) %>% count(pvals <= 0.05)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE             130
## 2 TRUE              870
```

Now the power is a bit too big, so we don't need a sample size quite
as big as 40. So probably our next guess would be 35. But before we
copy and paste again, we should be thinking about making a function of
it first, with the sample size as input. Copy-paste once more and edit:


```r
sim_power = function(n) {
    pvals <- rerun(1000, rnorm(30, 110, 20)) %>% map(~t.test(., mu = 100)) %>% map_dbl("p.value")
    tibble(pvals) %>% count(pvals <= 0.05)
}
```

In the grand scheme of things, we might want to have the null and true
means, population SD and $\alpha$ be inputs to the function as well,
so that we have a more general tool, but this will do for now.

Let's run it with a sample size of 35:


```r
sim_power(35)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE             238
## 2 TRUE              762
```

and I'm going to call that good. (Because there is randomness in the
estimation of the power, don't expect to get *too* close to the
right answer. This one came out a fair bit less than the right answer;
the power for $n=35$ should be a bit *more* than 0.80.)

Now that you have the software to do it, you can see that figuring out
a sample size like this, at least roughly, won't take very long: each
one of these simulations takes maybe seconds to run, and all you have
to do is copy and paste the previous one, and edit it to contain the
new sample size before running it again. You're making the computer
work hard while you lazily sip your coffee, but there's no harm in
that: programmer's brain cells are more valuable than computer CPU
cycles, and you might as well save your brain cells for when you
really need them.






##  Simulating power for proportions


 In opinion surveys (and other places), we are testing for a
proportion $p$ (for example, the proportion of people agreeing with
some statement). Often, we want to know whether the proportion is
"really" greater than 0.5.
\marginnote{That would mean assessing whether  an observed proportion could be greater than 0.5 just by chance, or  whether it is bigger enough than 0.5 to reject chance as a  plausible explanation.}  
That would entail testing a null
$H_0: p=0.5$ against an alternative $H_a: p>0.5$. This is usually done
by calculating the test statistic
$$ z = { \hat{p} - 0.5 \over \sqrt{0.25/n}},$$
where $\hat{p}$ is the observed proportion in the sample,
and getting a P-value from the upper tail of a standard normal
distribution. (The 0.25 is $p(1-p)$ where $p=0.5$.) This is what
`prop.test` does, as we investigate shortly.



(a) Use `rbinom` to generate a random value from a
binomial distribution with $n=100$ and $p=0.6$. There are three
inputs to `rbinom`: the first one should be the number 1, and
the second and third are the $n$ and $p$ of the binomial distribution.


Solution


I am doing some preparatory work that you don't need to do:


```r
set.seed(457299)
```

 

By setting the "seed" for the random number generator, I guarantee
that I will get the same answers every time I run my code below (and
therefore I can talk about my answers without worrying that they will
change). Up to you whether you do this. You can "seed" the random
number generator with any number you like. A lot of people use
`1`. Mahinda seems to like `123`. Mine is an old phone
number. 

And so to work:

```r
rbinom(1, 100, 0.6)
```

```
## [1] 60
```



I got exactly 60\% successes this time. You probably won't get exactly
60, but you should get somewhere close. (If you use my random number
seed and use the random number generator exactly the same way I did,
you should get the same values I did.)

For fun, you can see what happens if you change the 1:


```r
rbinom(3, 100, 0.6)
```

```
## [1] 58 57 55
```

 

Three random binomials, that happened to come out just below 60. We're
going to leave the first input as 1, though, and let `rerun`
handle "lots of sampled values" later.
    
 

(b) Using the random binomial that you generated just above, use
`prop.test` to test whether it could reasonably have come
from a binomial population with $n=100$ and $p=0.5$, or whether $p$
is actually bigger than 0.5. (Of course,
you know it actually did not come from a population with $p=0.5$.)
`prop.test` has, for us, four inputs, thus:


* the observed number of successes

* the `n` of the binomial distribution

* the null-hypothesis `p` of the binomial distribution

* the alternative hypothesis, here "greater"



Solution


I got exactly 60 successes, so I do this:

```r
prop.test(60, 100, 0.5, alternative = "greater")
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  60 out of 100, null probability 0.5
## X-squared = 3.61, df = 1, p-value = 0.02872
## alternative hypothesis: true p is greater than 0.5
## 95 percent confidence interval:
##  0.5127842 1.0000000
## sample estimates:
##   p 
## 0.6
```

     

The P-value should at least be fairly small, since 60 is a bit bigger
than 50. (Think about tossing a coin 100 times; would 60 heads make
you doubt the coin's fairness? The above says it should.)
    


(c) Run `prop.test` again, just as you did before, but this
time save the result, and extract the piece of it called
`p.value`. Is that the P-value from your test?


Solution


Copying and pasting:


```r
p_test <- prop.test(60, 100, 0.5, alternative = "greater")
p_test$p.value
```

```
## [1] 0.02871656
```

 

Yep, the same.



(d) Use `rerun` to estimate the power of a test of
$H_0: p=0.5$ against $H_a: p>0.5$ when $n=500$ and $p=0.56$, using
$\alpha=0.05$. There are three steps:


* use `rerun` to generate random samples from binomial
distributions with $n=500$ and $p=0.56$, repeated "many" times
(something like 1000 or 10,000 is good)

* use `map` to run `prop.test` on each of those
random samples

* use `map_dbl` to extract the P-value for each test and
save the results (in a vector called, perhaps, `pvals`).

So I lied: the fourth and final step is to count how many of
those P-values are 0.05 or less.


Solution


The previous parts, using `rbinom` and `prop.test`,
were meant to provide you with the ingredients for this part.
The first step is to use `rbinom`. The first input is 1 since
we only want one random binomial each time (the `rerun` will
handle the fact that you actually want lots of them). The second step
runs `prop.test`; the first input to that is each one of the
numbers of successes from the first step. (This is an implied
for-each, with each of the simulated binomials playing the role of
"it", in turn.). The last part is to pull out all the P-values and
make a table of them, just like the example in class.

```r
pvals <- rerun(10000, rbinom(1, 500, 0.56)) %>% map(~prop.test(., 500, 0.5, alternative = "greater")) %>% 
    map_dbl("p.value")
tibble(pvals) %>% count(pvals <= 0.05)
```

```
## # A tibble: 2 x 2
##   `pvals <= 0.05`     n
##   <lgl>           <int>
## 1 FALSE            1491
## 2 TRUE             8509
```

 

The estimated power is about 85\%. That is, if $p$ is actually 0.56
and we have a sample of size 500, we have a good chance of (correctly)
rejecting that $p=0.5$. 

Extra: It turns out that SAS can work out this power by calculation
(using `proc power`). 
SAS says our power is also about 85\%, as our simulation
said. I was actually pleased that my simulation came
out so close to the right answer.

In contrast to `power.t.test`, SAS's `proc power`
handles power analyses for a lot of things, including analysis of
variance, correlation and (multiple) regression. What these have in
common is some normal-based theory that allows you (under assumptions
of sufficiently normal-shaped populations) to calculate the exact
answer (that is, the distribution of the test statistic when the
*alternative* hypothesis is true). The case we looked at is one
of those because of the normal approximation to the binomial: once $n$
gets big, particularly if $p$ is somewhere near 0.5, the binomial is
very well approximated by a normal with the right mean and SD.

The moral of this story is that when you have a decently large sample,
$n=500$ in this case, $p$ doesn't have to get very far away from 0.5
before you can correctly reject 0.5.  Bear in mind that sample sizes
for estimating proportions need to be larger than those for estimating
means, so $n=500$ is large without being huge.  The practical upshot
is that if you design a survey and give it to 500 (or more) randomly
chosen people, the proportion of people in favour doesn't have to be
much above 50\% for you to correctly infer that it *is* above
50\%, most of the time.

    





