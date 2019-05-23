# Bayesian Statistics with `rstan`

Packages for this chapter:


```r
library(tidyverse)
library(rstan)
```






##  Estimating proportion in favour from a survey
You are probably familiar with the kind of surveys where you are given a statement, like "I am the kind of person that finishes a task they start", 
and you have to express your agreement or disagreement with it. 
Usually, you are given a five-point or seven-point scale on which you express your level of agreement (from "strongly agree" 
through "neither agree nor disagree" to 
"strongly disagree", for example). Here, we will simplify things a little and only allow respondents to agree or disagree. 
So the kind of data you would have is a number of people that took part, and the number of these that said "agree".

Common assumptions that are made in this kind of analysis are:
(i) the responses are independent of each other, and (ii) each respondent has the same unknown probability of agreeing. 
You might quibble about (ii), but the assumption we are making here is that we know *nothing* about the respondents apart from whether they agreed or disagreed. 
(In practice, we'd collect all kinds of demograhic information about each respondent, and this might give us a clue about how they'll respond, but here we're keeping it simple.)
Under our assumptions, the number of respondents that agree has a binomial distribution with $n$ being our sample size, and $p$ being the probability we are trying to estimate. Let's estimate $p$ using Stan: that is to say, let's obtain the posterior distribution of $p$.

Note: I'm not sure how Stan goes in R Studio Cloud at the moment. This works better in R on your own computer.



(a) In R Studio, open a new Stan file (with File, New File, Stan File). 
You'll see a template file of Stan code. 
Edit the `model` section to reflect that you have observed a number of successes `x` that we are modelling to have a binomial distribution with number of trials `n` and success probability `p`.

Solution


This is quicker to do than to ask for. Make a guess at this:


```

model {
// likelihood
x ~ binomial(n, p);

```


and then check the manual [link](https://mc-stan.org/docs/2_18/functions-reference/binomial-distribution.html), looking for Sampling Statement, to make sure that this is what is expected. It is.
(I got to this page by googling "Stan binomial distribution".)

The "likelihood" line with the two slashes is a comment, C++ style. 
It is optional, but I like to have it to keep things straight.


(b) In the line of Stan code you wrote, there should be three variables.
Which of these are parameters and which are data? Explain briefly.

Solution


The way to think about this is to ask yourself which of `x`, `n`, and `p` are being given to the Stan code as data, and which you are trying to estimate.
The only thing we are estimating here is `p`, so that is a parameter. 
The number of trials `n` and the number of successes `x` are data that you will observe (treated as "given" or "fixed" in the Bayesian framework). 


(c) I hope you found that there is only one parameter, `p`, in this problem. We know that $0 \le p \le 1$, and we need a prior distribution for it. A common choice is a beta distribution. 
Look at the Stan manual, [link](https://mc-stan.org/docs/2_18/functions-reference/beta-distribution.html). 
The density function is given in 19.1.1. 
It has two parameters $\alpha>0$ and $\beta>0$. $B(\alpha, \beta)$ given there is a constant. 
Add to your `model` section to express that `p` has a prior distribution with parameters `alpha` and `beta`. 
(`alpha` and `beta` will be input data when we run this code.)

Solution


Your `model` section should now look like this:


```

model {
// prior
p ~ beta(alpha, beta);
// likelihood
x ~ binomial(n, p);
}

```



(d) Above your `model` section, complete a `parameters` section that says what kind of variable `p` is.
If `p` has upper or lower limits, put these in as well.
You can edit the `parameters` section that is in the template.

Solution


`p` is a real variable taking values between 0 and 1, so this:


```

parameters {
real<lower=0, upper=1> p;
}

```



(e) Everything else is `data`. Complete a `data` section (edit the one in the template) to say what type of thing everything else is, including limits if it has any. 
Don't forget the parameters in the prior distribution!

Solution


We said before that `n` and `x` were (genuine) data. These are positive integers; also `x` cannot be bigger than `n` (why not?). 
In the data section also go the parameters `alpha` and `beta` of the prior distribution. These are real numbers bigger than zero.
These two together give us this:


```

data {
int<lower=0> n;
int<lower=0, upper=n> x;
real<lower=0> alpha;
real<lower=0> beta;
}

```


Putting in lower and upper limits, if you have them, will help because if you happen to enter data that does not respect the limits, you'll get an error right there, and you won't waste time sampling. 

It is more important to put in limits in the `parameters` section, because that is telling the sampler not to go there (eg. a value of $p$ outside $[0,1]$). 



(f) Save your code, if you haven't already. I used the filename `binomial.stan`. 
In your Stan code window, at the top right, you'll see a button marked Check. This checks whether your code is syntactically correct. Click it.


Solution


This appeared in my console:

```

> rstan:::rstudio_stanc("binomial.stan")
binomial.stan is syntactically correct.

```

If you don't see this, there is some kind of code error. 
You'll then see some output that points you to a line of your code. The error is either there or at the end of the previous line (eg. you forgot a semicolon). 
Here is a typical one:

```

> rstan:::rstudio_stanc("binomial.stan")
SYNTAX ERROR, MESSAGE(S) FROM PARSER:
error in 'model377242ac03ef_binomial' at line 24, column 0
-------------------------------------------------
22: parameters {
23:   real<lower=0, upper=1> p
24: }
^
25: 
-------------------------------------------------

PARSER EXPECTED: ";"
Error in stanc(filename, allow_undefined = TRUE) : 
failed to parse Stan model 'binomial' due to the above error.

```

The compiler (or at least the code checker) was expecting a semicolon, and when it got to the close-curly-bracket on line 24, that was where it knew that the semicolon was missing (and thus it objected there and not earlier).
If you get an error, fix it and check again. Repeat until your code is "syntactically correct". 
(That means that it will compile, but not that it will necessarily do what you want.)
This process is an integral part of coding, so get used to it. 
It doesn't matter how many errors you make; what matters is that you find and correct them all. 



(g) Compile your model. (This may take a minute or so, depending on how fast `rstudio.cloud` or your computer is.)


Solution


Go down to the console and type something like

```r
binomial_code <- stan_model("binomial.stan")
```

   

If it doesn't work, make sure you installed and loaded `rstan` first, with `install.packages("rstan")` and `library(rstan)` respectively.

If it sits there and does nothing for a while, this is actually a good sign. If it finds an error, it will tell you. If you get your command prompt `>` back without it saying anything, that means it worked. (This is a Unix thing: no comment means no error.)



(h) In most surveys, the probability to be estimated is fairly close to 0.5. 
A beta prior with $\alpha=\beta=2$ expresses the idea that any value of `p` is possible, but values near 0.5 are more likely.

A survey of 277 randomly selected adult female shoppers was taken. 69 of them agreed that when an advertised item is not available at the local supermarket, they request a raincheck.

Using the above information, set up a data `list` suitable for input to a run of `stan`.


Solution


Look in your `data` section, and see what you need to provide values for. 
The order doesn't matter; make a list with the named pieces and their values, in some order. You need values for these four things:

```r
binomial_data <- list(n = 277, x = 69, alpha = 2, beta = 2)
```

   

Extra: in case you are wondering where the parameters for the prior came from: in this case, I looked on the Wikipedia page for the beta distribution and saw that $\alpha=\beta=2$ is a good shape, so I used that. 
In practice, getting a reasonable prior is a more difficult problem, called "elicitation". 
What you have to do is ask a subject matter expert what they think `p` might be, giving you a range of values such as a guessed-at 95% confidence interval, like "I think `p` is almost certainly between 0.1 and 0.6". 
Then *you* as a statistician have to choose values for `alpha` and `beta` that match this, probably by trial and error. 
The `beta` distribution is part of R, so this is doable, for example like this:


```r
crossing(alpha = 1:10, beta = 1:10) %>%
  mutate(
    lower = qbeta(0.025, alpha, beta),
    upper = qbeta(0.975, alpha, beta)
  ) %>%
  mutate(sse = (lower - 0.1)^2 + (upper - 0.6)^2) %>%
  arrange(sse)
```

```
## # A tibble: 100 x 5
##    alpha  beta  lower upper      sse
##    <int> <int>  <dbl> <dbl>    <dbl>
##  1     4     8 0.109  0.610 0.000181
##  2     3     7 0.0749 0.600 0.000632
##  3     4     9 0.0992 0.572 0.000793
##  4     5    10 0.128  0.581 0.00112 
##  5     5     9 0.139  0.614 0.00169 
##  6     3     6 0.0852 0.651 0.00280 
##  7     3     8 0.0667 0.556 0.00303 
##  8     4     7 0.122  0.652 0.00322 
##  9     4    10 0.0909 0.538 0.00391 
## 10     6    10 0.163  0.616 0.00428 
## # … with 90 more rows
```

 

This says that $\alpha=4, \beta=8$ is a pretty good choice.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">Alpha and beta don't have to be integers; you could use *seq* to create sequences of values for alpha and beta that include decimal numbers.</span>

My process:


* Pick some values of `alpha` and `beta` to try, and make all possible combinations of them.

* Find the 2.5 and 97.5 percentiles of the beta distribution for each of those values. 
The "inverse CDF" (the value $x$ that has this much of the probability below it) is what we want here; this is obtained in R by putting `q` in front of the name of the distribution.
Try `qnorm(-1.96` and see if you recognize the answer. Also, `qbeta` is "vectorized", so the `alpha` and `beta` can be entire columns rather than just numbers, and it will work. If you want to, you can use `map2` to do it for each `alpha` and `beta`, something like \texttt{mutate(lower=map2(alpha, beta, ~qbeta(0.025, .x, .y). 

* We want the lower limit to be close to 0.1 and the upper limit to be close to 0.6. Working out the sum of squared errors for each `alpha`-`beta` combo is a way to do this; if `sse` is small, that combination of `alpha` and `beta` gave lower and upper limits close to 0.1 and 0.6.

* Arrange the `sse` values smallest to largest. The top rows are the best choices of `alpha` and `beta`.




(i) Sample from the posterior distribution of `p` with these data, and display your results.


Solution



```r
binomial_code <- readRDS("binomial_code.rds")
binomial_code
```

```
## S4 class stanmodel 'binomial' coded as follows:
## //
## // This Stan program defines a simple model, with a
## // vector of values 'y' modeled as normally distributed
## // with mean 'mu' and standard deviation 'sigma'.
## //
## // Learn more about model development with Stan at:
## //
## //    http://mc-stan.org/users/interfaces/rstan.html
## //    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
## //
## 
## // The input data is a vector 'y' of length 'N'.
## data {
##   int<lower=0> n;
##   int<lower=0, upper=n> x;
##   real<lower=0> alpha;
##   real<lower=0> beta;
## }
## 
## // The parameters accepted by the model. Our model
## // accepts two parameters 'mu' and 'sigma'.
## parameters {
##   real<lower=0, upper=1> p;
## }
## 
## // The model to be estimated. We model the output
## // 'y' to be normally distributed with mean 'mu'
## // and standard deviation 'sigma'.
## model {
##   // prior
##   p ~ beta(alpha, beta);
##   // likelihood
##   x ~ binomial(n, p);
## }
## 
```

   
This is what I got:

```r
binomial.1 <- sampling(binomial_code, binomial_data)
```

```
## 
## SAMPLING FOR MODEL 'binomial' NOW (CHAIN 1).
## Chain 1: 
## Chain 1: Gradient evaluation took 7e-06 seconds
## Chain 1: 1000 transitions using 10 leapfrog steps per transition would take 0.07 seconds.
## Chain 1: Adjust your expectations accordingly!
## Chain 1: 
## Chain 1: 
## Chain 1: Iteration:    1 / 2000 [  0%]  (Warmup)
## Chain 1: Iteration:  200 / 2000 [ 10%]  (Warmup)
## Chain 1: Iteration:  400 / 2000 [ 20%]  (Warmup)
## Chain 1: Iteration:  600 / 2000 [ 30%]  (Warmup)
## Chain 1: Iteration:  800 / 2000 [ 40%]  (Warmup)
## Chain 1: Iteration: 1000 / 2000 [ 50%]  (Warmup)
## Chain 1: Iteration: 1001 / 2000 [ 50%]  (Sampling)
## Chain 1: Iteration: 1200 / 2000 [ 60%]  (Sampling)
## Chain 1: Iteration: 1400 / 2000 [ 70%]  (Sampling)
## Chain 1: Iteration: 1600 / 2000 [ 80%]  (Sampling)
## Chain 1: Iteration: 1800 / 2000 [ 90%]  (Sampling)
## Chain 1: Iteration: 2000 / 2000 [100%]  (Sampling)
## Chain 1: 
## Chain 1:  Elapsed Time: 0.008147 seconds (Warm-up)
## Chain 1:                0.008053 seconds (Sampling)
## Chain 1:                0.0162 seconds (Total)
## Chain 1: 
## 
## SAMPLING FOR MODEL 'binomial' NOW (CHAIN 2).
## Chain 2: 
## Chain 2: Gradient evaluation took 5e-06 seconds
## Chain 2: 1000 transitions using 10 leapfrog steps per transition would take 0.05 seconds.
## Chain 2: Adjust your expectations accordingly!
## Chain 2: 
## Chain 2: 
## Chain 2: Iteration:    1 / 2000 [  0%]  (Warmup)
## Chain 2: Iteration:  200 / 2000 [ 10%]  (Warmup)
## Chain 2: Iteration:  400 / 2000 [ 20%]  (Warmup)
## Chain 2: Iteration:  600 / 2000 [ 30%]  (Warmup)
## Chain 2: Iteration:  800 / 2000 [ 40%]  (Warmup)
## Chain 2: Iteration: 1000 / 2000 [ 50%]  (Warmup)
## Chain 2: Iteration: 1001 / 2000 [ 50%]  (Sampling)
## Chain 2: Iteration: 1200 / 2000 [ 60%]  (Sampling)
## Chain 2: Iteration: 1400 / 2000 [ 70%]  (Sampling)
## Chain 2: Iteration: 1600 / 2000 [ 80%]  (Sampling)
## Chain 2: Iteration: 1800 / 2000 [ 90%]  (Sampling)
## Chain 2: Iteration: 2000 / 2000 [100%]  (Sampling)
## Chain 2: 
## Chain 2:  Elapsed Time: 0.008504 seconds (Warm-up)
## Chain 2:                0.00783 seconds (Sampling)
## Chain 2:                0.016334 seconds (Total)
## Chain 2: 
## 
## SAMPLING FOR MODEL 'binomial' NOW (CHAIN 3).
## Chain 3: 
## Chain 3: Gradient evaluation took 5e-06 seconds
## Chain 3: 1000 transitions using 10 leapfrog steps per transition would take 0.05 seconds.
## Chain 3: Adjust your expectations accordingly!
## Chain 3: 
## Chain 3: 
## Chain 3: Iteration:    1 / 2000 [  0%]  (Warmup)
## Chain 3: Iteration:  200 / 2000 [ 10%]  (Warmup)
## Chain 3: Iteration:  400 / 2000 [ 20%]  (Warmup)
## Chain 3: Iteration:  600 / 2000 [ 30%]  (Warmup)
## Chain 3: Iteration:  800 / 2000 [ 40%]  (Warmup)
## Chain 3: Iteration: 1000 / 2000 [ 50%]  (Warmup)
## Chain 3: Iteration: 1001 / 2000 [ 50%]  (Sampling)
## Chain 3: Iteration: 1200 / 2000 [ 60%]  (Sampling)
## Chain 3: Iteration: 1400 / 2000 [ 70%]  (Sampling)
## Chain 3: Iteration: 1600 / 2000 [ 80%]  (Sampling)
## Chain 3: Iteration: 1800 / 2000 [ 90%]  (Sampling)
## Chain 3: Iteration: 2000 / 2000 [100%]  (Sampling)
## Chain 3: 
## Chain 3:  Elapsed Time: 0.008067 seconds (Warm-up)
## Chain 3:                0.007549 seconds (Sampling)
## Chain 3:                0.015616 seconds (Total)
## Chain 3: 
## 
## SAMPLING FOR MODEL 'binomial' NOW (CHAIN 4).
## Chain 4: 
## Chain 4: Gradient evaluation took 4e-06 seconds
## Chain 4: 1000 transitions using 10 leapfrog steps per transition would take 0.04 seconds.
## Chain 4: Adjust your expectations accordingly!
## Chain 4: 
## Chain 4: 
## Chain 4: Iteration:    1 / 2000 [  0%]  (Warmup)
## Chain 4: Iteration:  200 / 2000 [ 10%]  (Warmup)
## Chain 4: Iteration:  400 / 2000 [ 20%]  (Warmup)
## Chain 4: Iteration:  600 / 2000 [ 30%]  (Warmup)
## Chain 4: Iteration:  800 / 2000 [ 40%]  (Warmup)
## Chain 4: Iteration: 1000 / 2000 [ 50%]  (Warmup)
## Chain 4: Iteration: 1001 / 2000 [ 50%]  (Sampling)
## Chain 4: Iteration: 1200 / 2000 [ 60%]  (Sampling)
## Chain 4: Iteration: 1400 / 2000 [ 70%]  (Sampling)
## Chain 4: Iteration: 1600 / 2000 [ 80%]  (Sampling)
## Chain 4: Iteration: 1800 / 2000 [ 90%]  (Sampling)
## Chain 4: Iteration: 2000 / 2000 [100%]  (Sampling)
## Chain 4: 
## Chain 4:  Elapsed Time: 0.008123 seconds (Warm-up)
## Chain 4:                0.007127 seconds (Sampling)
## Chain 4:                0.01525 seconds (Total)
## Chain 4:
```

```r
binomial.1
```

```
## Inference for Stan model: binomial.
## 4 chains, each with iter=2000; warmup=1000; thin=1; 
## post-warmup draws per chain=1000, total post-warmup draws=4000.
## 
##         mean se_mean   sd    2.5%     25%     50%     75%   97.5% n_eff
## p       0.25    0.00 0.03    0.20    0.24    0.25    0.27    0.31  1529
## lp__ -159.34    0.02 0.71 -161.35 -159.51 -159.07 -158.89 -158.84  1964
##      Rhat
## p       1
## lp__    1
## 
## Samples were drawn using NUTS(diag_e) at Thu May 23 14:53:32 2019.
## For each parameter, n_eff is a crude measure of effective sample size,
## and Rhat is the potential scale reduction factor on split chains (at 
## convergence, Rhat=1).
```

   

Your results should be similar, though probably not identical, to mine. (There is a lot of randomness involved here.)



(j) Obtain a 95\% posterior interval for the probability that a randomly chosen adult female shopper will request a raincheck.


Solution


Read off the 2.5 and 97.5 values for `p`. Mine are xxx and xxx.



(k) Obtain a 95\% (frequentist) confidence interval for `p`, and compare the results. (Hint: `prop.test`.) Comment briefly.


Solution


If you remember this well enough, you can do it by hand, but there's no need:

```r
prop.test(69, 277)
```

```
## 
## 	1-sample proportions test with continuity correction
## 
## data:  69 out of 277, null probability 0.5
## X-squared = 68.751, df = 1, p-value < 2.2e-16
## alternative hypothesis: true p is not equal to 0.5
## 95 percent confidence interval:
##  0.2001721 0.3051278
## sample estimates:
##         p 
## 0.2490975
```

   

My 95\% intervals are almost identical.

Numerically, this is because the only (material) difference between them is the presence of the prior in the Bayesian approach. We have quite a lot of data, though, so the choice of prior is actually not that important ("the data overwhelm the prior"). I could have used `alpha=8, beta=4` that I obtained in the Extra above, and it wouldn't have made any noticeable difference.

Conceptually, though, the interpretations of these intervals are very different: the Bayesian posterior interval really does say "the probability of $p$ being between xxx and xxx is 0.95", while for the confidence interval you have to talk about repeated sampling: "the procedure producing the 95\% confidence interval will contain the true value of $p$ in 95\% of all possible samples". 
This might seem clunky in comparison; a Bayesian would tell you that the interpretation of the posterior interval is what you want the interpretation of the confidence interval to be, but is not!



(l) (optional) This is one of those problems where you can obtain the answer analytically. What is the posterior distribution of $p$, using a prior $beta(\alpha, \beta)$ distribution for $p$ and observing $x$ successes out of $n$ trials?


Solution


With this stuff, you can throw away any constants.
The likelihood is (proportional to) $$ p^x (1-p)^{n-x}.$$ There is a binomial coefficient that I threw away.
Look up the form of the beta density if you don't know it (or look above): the prior for $p$ is proportional to
$$ p^{\alpha-1} (1-p)^{\beta-1}.$$
Posterior is proportional to likelihood times prior:
$$ p^{x + \alpha - 1} (1-p)^{n-x +\beta - 1}$$
which is recognized as a beta distribution with parameters $x+\alpha$, $n-x+\beta$. 
Typically (unless you are very sure about $p$ a priori (that is, before collecting any data)), $x$ and $n-x$ will be much larger than $\alpha$ and $beta$, so this will look a lot like a binomial likelihood, which is why the confidence interval and posterior interval in our example came out very similar.




