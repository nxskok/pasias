# Logistic regression redux


```r
library(tidyverse)
```







##  The brain of a cat


 A large number (315) of psychology students were asked to
imagine that they were serving on a university ethics committee
hearing a complaint against animal research being done by a member of
the faculty. The students were told that the surgery consisted of
implanting a device called a cannula in each cat's brain, through
which chemicals were introduced into the brain and the cats were then
given psychological tests. At the end of the study, the cats' brains
were subjected to histological analysis. The complaint asked that the
researcher's authorization to carry out the study should be withdrawn,
and the cats should be handed over to the animal rights group that
filed the complaint. It was suggested that the research could just as
well be done with computer simulations.

All of the psychology students in the survey were told all of this. In
addition, they read a statement by the researcher that no animal felt
much pain at any time, and that computer simulation was *not* an
adequate substitute for animal research. Each student was also given
*one* of the following scenarios that explained the benefit of
the research:



* "cosmetic": testing the toxicity of chemicals to be used in
new lines of hair care products.

* "theory": evaluating two competing theories about the function
of a particular nucleus in the brain.

* "meat": testing a synthetic growth hormone said to potentially
increase meat production.

* "veterinary": attempting to find a cure for a brain disease
that is killing domesticated cats and endangered species of wild cats.

* "medical": evaluating a potential cure for a debilitating
disease that afflicts many young adult humans.


Finally, each student completed two questionnaires: one that would assess their
"relativism": whether or not they believe in universal moral
principles (low score) or whether they believed that the appropriate
action depends on the person and situation (high score). The second
questionnaire assessed "idealism": a high score reflects a belief
that ethical behaviour will always lead to good consequences (and thus
that  if a behaviour leads to any bad consequences at all, it is
unethical).
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">I get confused about the difference between morals  and ethics. This is a very short description of that difference:  http://smallbusiness.chron.com/differences-between-ethical-issues-moral-issues-business-48134.html. The basic idea is that morals are part of who you are, derived from religion, philosophy etc. Ethics are how you act in a particular situation: that is, your morals, what you believe, inform your ethics, what you do. That's why the students had to play the role of an  ethics committee, rather than a morals committee; presumably the researcher had good morals, but an ethics committee had to evaluate what he was planning to do, rather than his character as a person.</span>

After being exposed to all of that, each student stated their decision
about whether the research should continue or stop.

I should perhaps stress at this point that no actual cats were harmed
in the collection of these data (which can be found as a `.csv`
file at
[link](https://raw.githubusercontent.com/nxskok/datafiles/master/decision.csv)). The
variables in the data set are these:



* `decision`: whether the research should continue or stop (response)

* `idealism`: score on idealism questionnaire

* `relativism`: score on relativism questionnaire

* `gender` of student

* `scenario` of research benefits that the student read.


A more detailed discussion
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">If you can believe it.</span> of this
study is at
[link](http://core.ecu.edu/psyc/wuenschk/MV/Multreg/Logistic-SPSS.PDF). 


(a) Read in the data and check by looking at the structure of
your data frame that you have something sensible. *Do not* call
your data frame `decision`, since that's the name of one of
the variables in it.


Solution


So, like this, using the name `decide` in my case:

```r
my_url <- "https://raw.githubusercontent.com/nxskok/datafiles/master/decision.csv"
decide <- read_csv(my_url)
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   decision = col_character(),
##   idealism = col_double(),
##   relativism = col_double(),
##   gender = col_character(),
##   scenario = col_character()
## )
```

```r
decide
```

```
## # A tibble: 315 x 5
##    decision idealism relativism gender scenario
##    <chr>       <dbl>      <dbl> <chr>  <chr>   
##  1 stop          8.2        5.1 Female cosmetic
##  2 continue      6.8        5.3 Male   cosmetic
##  3 continue      8.2        6   Female cosmetic
##  4 stop          7.4        6.2 Female cosmetic
##  5 continue      1.7        3.1 Female cosmetic
##  6 continue      5.6        7.7 Male   cosmetic
##  7 stop          7.2        6.7 Female cosmetic
##  8 stop          7.8        4   Male   cosmetic
##  9 stop          7.8        4.7 Female cosmetic
## 10 stop          8          7.6 Female cosmetic
## # … with 305 more rows
```

       

The variables are all the right things and of the right types: the
decision, gender and the scenario are all text (representing
categorical variables), and idealism and relativism, which were scores
on a test, are quantitative (numerical). There are, as promised, 315
observations.
  


(b) Fit a logistic regression predicting
`decision` from `gender`. Is there an effect of gender?


Solution


Turn the response into a `factor` somehow, either by
creating a new variable in the data frame or like this:

```r
decide.1 <- glm(factor(decision) ~ gender, data = decide, family = "binomial")
summary(decide.1)
```

```
## 
## Call:
## glm(formula = factor(decision) ~ gender, family = "binomial", 
##     data = decide)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -1.5518  -1.0251   0.8446   0.8446   1.3377  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)   0.8473     0.1543   5.491 3.99e-08 ***
## genderMale   -1.2167     0.2445  -4.976 6.50e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 425.57  on 314  degrees of freedom
## Residual deviance: 399.91  on 313  degrees of freedom
## AIC: 403.91
## 
## Number of Fisher Scoring iterations: 4
```

       

The P-value for gender is $6.5 \times 10^{-7}$, which is very
small, so there is definitely an effect of gender. It's not
immediately clear what kind of effect it is: that's the reason for
the next part, and we'll revisit this slope coefficient in a moment.
Categorical *explanatory* variables are perfectly all right
as text.
Should I have used `drop1` to assess the significance? Maybe:

```r
drop1(decide.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## factor(decision) ~ gender
##        Df Deviance    AIC    LRT  Pr(>Chi)    
## <none>      399.91 403.91                     
## gender  1   425.57 427.57 25.653 4.086e-07 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

     

The thing is, this gives us a P-value but not a slope, which we might
have wanted to try to interpret. Also, the P-value in `summary`
is so small that it is likely to be still significant in
`drop1` as well.
    


(c) To investigate the effect (or non-effect) of
`gender`, create a contingency table by feeding
`decision` and `gender` into `table`. What does
this tell you?


Solution



```r
with(decide, table(decision, gender))
```

```
##           gender
## decision   Female Male
##   continue     60   68
##   stop        140   47
```

       

Females are more likely to say that the study should stop (a clear
majority), while males are more evenly split, with a small majority in
favour of the study continuing.

If you want the column percents as well, you can use
`prop.table`. Two steps: save the table from above into a
variable, then feed *that* into `prop.table`, calling for
column percentages rather than row percentages:


```r
tab <- with(decide, table(decision, gender))
prop.table(tab, 2)
```

```
##           gender
## decision      Female      Male
##   continue 0.3000000 0.5913043
##   stop     0.7000000 0.4086957
```

 

Why column percentages? Well, thinking back to STAB22 or some such
place, when one of your variables is acting like a response or outcome
(`decision` here), make the percentages out of the *other*
one. Given that a student is a female, how likely are they to call for
the research to stop? The other way around makes less sense: given
that a person wanted the research to stop, how likely are they to be
female? 

About 70\% of females and 40\% of males want the research to
stop. That's a giant-sized difference. No wonder it was significant.

The other way of making the table is to use `xtabs`, with the
same result:


```r
xtabs(~ decision + gender, data = decide)
```

```
##           gender
## decision   Female Male
##   continue     60   68
##   stop        140   47
```

 

In this one, the frequency variable goes on the left side of the
squiggle. We don't have one here (each row of the data frame
represents one student), so we leave the left side blank. I tried
putting a `.` there, but that doesn't work since there is no
"whatever was there before" as there is, for example, in
`update`. 
    


(d) <a name="part:whichprob">*</a> Is your slope for `gender` in the previous logistic
regression positive or negative? Is it applying to males or to females?
Looking at the conclusions from your 
contingency table, what probability does that mean your logistic
regression is actually modelling?


Solution


My slope is $-1.2167$, negative, and it is attached to males (note
that the slope is called `gendermale`: because "female"
is before "male" alphabetically, females are used as the
baseline and this slope says how males compare to them). 
This negative male coefficient means that the probability of
whatever is being modelled is *less* for males than it is for
females. Looking at the contingency table for the last part, the
probability of "stop" should be less for males, so the logistic
regression is actually modelling the probability of
"stop". Another way to reason that this must be the right answer
is that the two values of `decision` are `continue`
and `stop`; `continue` is first alphabetically, so
it's the baseline, and the *other* one, `stop`, is the
one whose probability is being modelled.
That's why I made you do that contingency table. Another way to
think about
this is to do a prediction, which would go like this:

```r
genders <- c("Female", "Male")
new <- tibble(gender = genders)
p <- predict(decide.1, new, type = "response")
cbind(new, p)
```

```
##   gender         p
## 1 Female 0.7000000
## 2   Male 0.4086957
```

 

The probability of whatever-it-is is exactly 70\% for females and
about 40\% for males. A quick look at the contingency table shows
that exactly 70\% ($140/200$) of the females think the research should
stop, and a bit less than 50\% of the males think the same thing. So
the model is predicting the probability of "stop".

There's a logic to this: it's not just this way "because it is". 
It's the same idea of the first category, now of the response
factor, being a "baseline", and what actually gets modelled is the
*second* category, relative to the baseline.
  


(e) Add the two variables `idealism` and
`relativism` to your logistic regression. Do either or both of them add
significantly to your model? Explain briefly.

 
Solution


The obvious way of doing this is to type out the entire model,
with the two new variables on the end. You have to remember to
turn `decision` into a `factor` again:

```r
decide.2 <- glm(factor(decision) ~ gender + idealism + relativism,
  data = decide, family = "binomial"
)
summary(decide.2)
```

```
## 
## Call:
## glm(formula = factor(decision) ~ gender + idealism + relativism, 
##     family = "binomial", data = decide)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.2226  -0.9891   0.4798   0.8748   2.0442  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -1.4876     0.9787  -1.520  0.12849    
## genderMale   -1.1710     0.2679  -4.372 1.23e-05 ***
## idealism      0.6893     0.1115   6.180 6.41e-10 ***
## relativism   -0.3432     0.1245  -2.757  0.00584 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 425.57  on 314  degrees of freedom
## Residual deviance: 346.50  on 311  degrees of freedom
## AIC: 354.5
## 
## Number of Fisher Scoring iterations: 4
```

     

This is not so bad, copying and pasting. But
the way I like better, when you're making a smallish change to a
longish model, is to use `update`:


```r
decide.2 <- update(decide.1, . ~ . + idealism + relativism)
summary(decide.2)
```

```
## 
## Call:
## glm(formula = factor(decision) ~ gender + idealism + relativism, 
##     family = "binomial", data = decide)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.2226  -0.9891   0.4798   0.8748   2.0442  
## 
## Coefficients:
##             Estimate Std. Error z value Pr(>|z|)    
## (Intercept)  -1.4876     0.9787  -1.520  0.12849    
## genderMale   -1.1710     0.2679  -4.372 1.23e-05 ***
## idealism      0.6893     0.1115   6.180 6.41e-10 ***
## relativism   -0.3432     0.1245  -2.757  0.00584 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 425.57  on 314  degrees of freedom
## Residual deviance: 346.50  on 311  degrees of freedom
## AIC: 354.5
## 
## Number of Fisher Scoring iterations: 4
```

 

Either way is good. The conclusion you need to draw is that they both
have something to add, because their P-values are both less than 0.05.

Or (and perhaps better) you can look at `drop1` of either of these:


```r
drop1(decide.2, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## factor(decision) ~ gender + idealism + relativism
##            Df Deviance    AIC    LRT  Pr(>Chi)    
## <none>          346.50 354.50                     
## gender      1   366.27 372.27 19.770 8.734e-06 ***
## idealism    1   393.22 399.22 46.720 8.188e-12 ***
## relativism  1   354.46 360.46  7.956  0.004792 ** 
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 
  


(f) Add the variable `scenario` to your model. That is,
fit a new model with that variable plus all the others.


Solution


To my mind, `update` wins hands down here:

```r
decide.3 <- update(decide.2, . ~ . + scenario)
```

     

You can display the summary here if you like, but we're not going to
look at it yet. 
  


(g) Use `anova` to compare the models with and without
`scenario`. You'll have to add a `test="Chisq"` to your
`anova`, to make sure that the test gets done.
Does `scenario` make a difference or not, at $\alpha=0.10$?
Explain briefly.
(The reason we have to do it this way is that
`scenario` is a factor with five levels, so it has four slope
coefficients. To test them all at once, which is what we need to make
an overall test for `scenario`, this is the way it has to be
done.) 


Solution


These are the models that you fit in the last two parts:

```r
anova(decide.2, decide.3, test = "Chisq")
```

```
## Analysis of Deviance Table
## 
## Model 1: factor(decision) ~ gender + idealism + relativism
## Model 2: factor(decision) ~ gender + idealism + relativism + scenario
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)  
## 1       311     346.50                       
## 2       307     338.06  4   8.4431  0.07663 .
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

     

The P-value is not less than 0.05, but it *is* less than 0.10,
which is what I implied to assess it with, so the scenario does make some
kind of difference.

Extra: another way to do this, which I like better (but the
`anova` way was what I asked in the original question), is to
look at `decide.3` and ask "what can I get rid of", in such a
way that categorical variables stay or go as a whole.  This is done
using `drop1`. It's a little different from the corresponding
thing in regression because the right way to do the test is not an F
test, but now a chi-squared test (this is true for all generalized
linear models of which logistic regression is one):


```r
drop1(decide.3, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## factor(decision) ~ gender + idealism + relativism + scenario
##            Df Deviance    AIC    LRT  Pr(>Chi)    
## <none>          338.06 354.06                     
## gender      1   359.61 373.61 21.546 3.454e-06 ***
## idealism    1   384.40 398.40 46.340 9.943e-12 ***
## relativism  1   344.97 358.97  6.911  0.008567 ** 
## scenario    4   346.50 354.50  8.443  0.076630 .  
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

 

The test for `scenario` has four degrees of freedom (since
there are five scenarios), and is in fact exactly the same test as in
`anova`, significant at $\alpha=0.10$.
   


(h) Look at the `summary` of your model that contained
`scenario`. Bearing in mind that the slope coefficient for
`scenariocosmetic` is zero (since this is the first scenario
alphabetically), which scenarios have the most positive and most
negative slope coefficients? What does that tell you about those
scenarios' effects?

 
Solution


All right. This is the model I called `decide.3`:

```r
summary(decide.3)
```

```
## 
## Call:
## glm(formula = factor(decision) ~ gender + idealism + relativism + 
##     scenario, family = "binomial", data = decide)
## 
## Deviance Residuals: 
##     Min       1Q   Median       3Q      Max  
## -2.3350  -0.9402   0.4645   0.8266   2.1564  
## 
## Coefficients:
##                    Estimate Std. Error z value Pr(>|z|)    
## (Intercept)         -1.5694     1.0426  -1.505   0.1322    
## genderMale          -1.2551     0.2766  -4.537 5.70e-06 ***
## idealism             0.7012     0.1139   6.156 7.48e-10 ***
## relativism          -0.3264     0.1267  -2.576   0.0100 *  
## scenariomeat         0.1565     0.4283   0.365   0.7149    
## scenariomedical     -0.7095     0.4202  -1.688   0.0914 .  
## scenariotheory       0.4501     0.4271   1.054   0.2919    
## scenarioveterinary  -0.1672     0.4159  -0.402   0.6878    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## (Dispersion parameter for binomial family taken to be 1)
## 
##     Null deviance: 425.57  on 314  degrees of freedom
## Residual deviance: 338.06  on 307  degrees of freedom
## AIC: 354.06
## 
## Number of Fisher Scoring iterations: 4
```

     

The most positive coefficient is for `theory` and the most
negative one is for `medical`. (The zero coefficient is in the
middle.) Since we are modelling the probability of saying that the
research should *stop* (part (<a href="#part:whichprob">here</a>)), this means that:



* the "theory" scenario (evaluating theories about brain function)
is most likely to lead to someone saying that the research should stop
(other things being equal)

* the "medical" scenario (finding a
cure for a human disease) is most likely to lead to someone saying
that the research should continue (or least likely to say that it
should stop), again, other things being equal.


These make some kind of sense because being exposed to a scenario
where there are tangible benefits later ought to be most favourable to
the research continuing, and people are not going to be impressed by
something that is "only theoretical" without any clear benefits.
This also lends itself to a `predict` solution, but it's a
little fiddly. I need some "average" values for the other variables,
and I don't know what they are yet:


```r
decide %>% summarize(across(where(is.numeric), ~median(.)))
```

```
## # A tibble: 1 x 2
##   idealism relativism
##      <dbl>      <dbl>
## 1      6.5        6.1
```

 

("if the variable is numeric, get me its  median".)

The other thing we need is a list of all the scenarios. Here's a cute
way to do that:


```r
scenarios <- decide %>% count(scenario) %>% pull(scenario)
scenarios
```

```
## [1] "cosmetic"   "meat"       "medical"    "theory"     "veterinary"
```

 

I didn't really need to know how many observations there were for each
scenario, but it was a handy way to find out which scenarios there
were without listing them all (and then having to pick out the unique
ones). 

So now let's make a data frame to predict from that has all
scenarios for, let's say, females. (We don't have an interaction, so
according to the model, the pattern is the same for males and
females. So I could just as well have looked at males.)


```r
new <- crossing(idealism = 6.5, relativism = 6.1, gender = "Female", scenario = scenarios)
new
```

```
## # A tibble: 5 x 4
##   idealism relativism gender scenario  
##      <dbl>      <dbl> <chr>  <chr>     
## 1      6.5        6.1 Female cosmetic  
## 2      6.5        6.1 Female meat      
## 3      6.5        6.1 Female medical   
## 4      6.5        6.1 Female theory    
## 5      6.5        6.1 Female veterinary
```

```r
p <- predict(decide.3, new, type = "response")
cbind(new, p)
```

```
##   idealism relativism gender   scenario         p
## 1      6.5        6.1 Female   cosmetic 0.7304565
## 2      6.5        6.1 Female       meat 0.7601305
## 3      6.5        6.1 Female    medical 0.5713725
## 4      6.5        6.1 Female     theory 0.8095480
## 5      6.5        6.1 Female veterinary 0.6963099
```

 

This echoes what we found before: the probability of saying that the
research should stop is highest for "theory" and the lowest for "medical".

I assumed in my model that the effect of the scenarios was the same for males and
females. If I wanted to test that, I'd have to add an interaction and
test that. This works most nicely using `update` and then
`anova`, to fit the model with interaction and compare it with
the model without:


```r
decide.4 <- update(decide.3, . ~ . + gender * scenario)
anova(decide.3, decide.4, test = "Chisq")
```

```
## Analysis of Deviance Table
## 
## Model 1: factor(decision) ~ gender + idealism + relativism + scenario
## Model 2: factor(decision) ~ gender + idealism + relativism + scenario + 
##     gender:scenario
##   Resid. Df Resid. Dev Df Deviance Pr(>Chi)
## 1       307     338.06                     
## 2       303     337.05  4   1.0122   0.9079
```

 

No evidence at all that the scenarios have different effects for the
different genders. The appropriate `predict` should show that too:


```r
genders <- decide %>% count(gender) %>% pull(gender)
new <- crossing(idealism = 6.5, relativism = 6.1, gender = genders, scenario = scenarios)
new
```

```
## # A tibble: 10 x 4
##    idealism relativism gender scenario  
##       <dbl>      <dbl> <chr>  <chr>     
##  1      6.5        6.1 Female cosmetic  
##  2      6.5        6.1 Female meat      
##  3      6.5        6.1 Female medical   
##  4      6.5        6.1 Female theory    
##  5      6.5        6.1 Female veterinary
##  6      6.5        6.1 Male   cosmetic  
##  7      6.5        6.1 Male   meat      
##  8      6.5        6.1 Male   medical   
##  9      6.5        6.1 Male   theory    
## 10      6.5        6.1 Male   veterinary
```

```r
p <- predict(decide.4, new, type = "response")
cbind(new, p)
```

```
##    idealism relativism gender   scenario         p
## 1       6.5        6.1 Female   cosmetic 0.7670133
## 2       6.5        6.1 Female       meat 0.7290272
## 3       6.5        6.1 Female    medical 0.5666034
## 4       6.5        6.1 Female     theory 0.8251472
## 5       6.5        6.1 Female veterinary 0.6908189
## 6       6.5        6.1   Male   cosmetic 0.3928582
## 7       6.5        6.1   Male       meat 0.5438679
## 8       6.5        6.1   Male    medical 0.2860504
## 9       6.5        6.1   Male     theory 0.5237310
## 10      6.5        6.1   Male veterinary 0.4087458
```

 
The probability of "stop" is a lot higher for females than for males
(that is the strong `gender` effect we found earlier), but the
*pattern* is about the same for males and females: the difference in
probabilities
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">Strictly, we should look at the difference in log-odds.</span>
is about the same, and also both genders have almost the highest predicted
probability for `theory` (the highest male one is actually for
`meat` but there's not much in it)
and the lowest one for
`medical`, as we found before. The pattern is not
*exactly* the same because these predictions came from the model
with interaction. If you use the model without interaction, you get this:


```r
p <- predict(decide.3, new, type = "response")
cbind(new, p)
```

```
##    idealism relativism gender   scenario         p
## 1       6.5        6.1 Female   cosmetic 0.7304565
## 2       6.5        6.1 Female       meat 0.7601305
## 3       6.5        6.1 Female    medical 0.5713725
## 4       6.5        6.1 Female     theory 0.8095480
## 5       6.5        6.1 Female veterinary 0.6963099
## 6       6.5        6.1   Male   cosmetic 0.4358199
## 7       6.5        6.1   Male       meat 0.4745996
## 8       6.5        6.1   Male    medical 0.2753530
## 9       6.5        6.1   Male     theory 0.5478510
## 10      6.5        6.1   Male veterinary 0.3952499
```

 

and the scenarios are ranked in *exactly* the same order by males
and females. The probabilities from the two models are very close
(compare them), so there is no value in adding the interaction, as we
found before.

So fitting an interaction was a
waste of time, but it was worth checking whether it was.
   


(i) Describe the effects that having (i) a higher idealism score
and (ii) a higher relativity score have on a person's probability of
saying that the research should stop. Do each of these increase or decrease
that probability? Explain briefly.


Solution


Look back at the summary for the model that I called
`decide.3`. (Or `decide.2`: the slope coefficients
are very similar.) The one for `idealism` is positive, so
that a higher idealism score goes with a greater likelihood of
saying that the research should stop. The slope coefficient for
`relativity` is negative, so it's the other way around: a
higher relativity score goes with a *lower* chance of saying
that the research should stop.
That's all I needed, but as an extra, we can look back at the
description of these scales in the question.
The `relativism` one was that a person believed that the
most moral action depends on the situation (as opposed to a person
having something like religious faith that asserts universal moral
principles that are always true. That would be a low score on the
relativism scale). Somebody with a low score on this scale might
believe something like 
"it is always wrong to experiment on animals", whereas somebody with a high relativism score  might
say that it was sometimes justified. Thus, other things being
equal, a low relativism score would go with "stop" and a high
relativism score would (or  might) go with "continue". This
would mean a *negative* slope coefficient for
`relativism`, which is what we observed. (Are you still
with me? There was some careful thinking there.)

What about `idealism`? This is a belief that ethical behaviour
will always lead to good consequences, and thus, if the
consequences are bad, the behaviour must not have been ethical. A
person who scores high on idealism is likely to look at the
consequences (experimentation on animals), see that as a bad
thing, and thus conclude that the research should be stopped. The
`idealism` slope coefficient, by that argument, should be
positive, and is.

This will also lead to a `predict`. We need "low" and
"high" scores on the idealism and relativism tests. Let's use
the quartiles:


```r
decide %>% summarize(
  i_q1 = quantile(idealism, 0.25),
  i_q3 = quantile(idealism, 0.75),
  r_q1 = quantile(relativism, 0.25),
  r_q3 = quantile(relativism, 0.75)
)
```

```
## # A tibble: 1 x 4
##    i_q1  i_q3  r_q1  r_q3
##   <dbl> <dbl> <dbl> <dbl>
## 1   5.6   7.5   5.4   6.8
```

     

There is a more elegant way, but this works.
Let's use the scenario `cosmetic` that was middling in its
effects, and think about females:

```r
new <- crossing(
  idealism = c(5.6, 7.5), relativism = c(5.4, 6.8),
  gender = "Female", scenario = "cosmetic"
)
new
```

```
## # A tibble: 4 x 4
##   idealism relativism gender scenario
##      <dbl>      <dbl> <chr>  <chr>   
## 1      5.6        5.4 Female cosmetic
## 2      5.6        6.8 Female cosmetic
## 3      7.5        5.4 Female cosmetic
## 4      7.5        6.8 Female cosmetic
```

```r
p <- predict(decide.3, new, type = "response")
cbind(new, p)
```

```
##   idealism relativism gender scenario         p
## 1      5.6        5.4 Female cosmetic 0.6443730
## 2      5.6        6.8 Female cosmetic 0.5342955
## 3      7.5        5.4 Female cosmetic 0.8728724
## 4      7.5        6.8 Female cosmetic 0.8129966
```

     

For both of the idealism scores, the higher relativism score went with
a lower probability of "stop" (the "negative" effect), and for
both of the relativism scores, the higher idealism score went with a
*higher* probability of "stop" (the positive effect).

That's quite enough discussion of the question, except that the data
didn't come to me in the form that you see them, so I figured I would
like to share the story of the data processing as well. I think this
is important because in your future work you are likely to spend a lot
of your time getting data from how you receive it to something
suitable for analysis.

These data came from a psychology study (with, probably, the students
in a class serving as experimental subjects). Social scientists like
to use SPSS software, so the data came to me as an SPSS `.sav`
file.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">If you took STAB23, you'll have used PSPP, which is  a free version of SPSS.</span> The least-fuss way of handling this that I
could think of was to use `import` from the `rio`
package, which I think I mentioned before:


```r
library(rio)
x <- import("/home/ken/Downloads/Logistic.sav")
str(x)
```

```
## 'data.frame':	315 obs. of  11 variables:
##  $ decision   : num  0 1 1 0 1 1 0 0 0 0 ...
##   ..- attr(*, "format.spss")= chr "F1.0"
##   ..- attr(*, "labels")= Named num [1:2] 0 1
##   .. ..- attr(*, "names")= chr [1:2] "stop" "continue"
##  $ idealism   : num  8.2 6.8 8.2 7.4 1.7 5.6 7.2 7.8 7.8 8 ...
##   ..- attr(*, "format.spss")= chr "F12.4"
##  $ relatvsm   : num  5.1 5.3 6 6.2 3.1 7.7 6.7 4 4.7 7.6 ...
##   ..- attr(*, "format.spss")= chr "F12.4"
##  $ gender     : num  0 1 0 0 0 1 0 1 0 0 ...
##   ..- attr(*, "format.spss")= chr "F1.0"
##   ..- attr(*, "labels")= Named num [1:2] 0 1
##   .. ..- attr(*, "names")= chr [1:2] "Female" "Male"
##  $ cosmetic   : num  1 1 1 1 1 1 1 1 1 1 ...
##   ..- attr(*, "format.spss")= chr "F1.0"
##  $ theory     : num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "format.spss")= chr "F1.0"
##  $ meat       : num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "format.spss")= chr "F1.0"
##  $ veterin    : num  0 0 0 0 0 0 0 0 0 0 ...
##   ..- attr(*, "format.spss")= chr "F1.0"
##  $ idealism_LN: num  2.104 1.917 2.104 2.001 0.531 ...
##   ..- attr(*, "format.spss")= chr "F8.2"
##   ..- attr(*, "display_width")= int 13
##  $ relatvsm_LN: num  1.63 1.67 1.79 1.82 1.13 ...
##   ..- attr(*, "format.spss")= chr "F8.2"
##   ..- attr(*, "display_width")= int 13
##  $ scenario   : num  1 1 1 1 1 1 1 1 1 1 ...
##   ..- attr(*, "format.spss")= chr "F8.2"
##   ..- attr(*, "display_width")= int 10
```

   

The last line `str` displays the "structure" of the data
frame that was obtained. Normally a data frame read into R has a much
simpler structure than this, but this is R trying to interpret how
SPSS does things. Here, each column (listed on the lines beginning
with a dollar sign) has some values, listed after `num`; they
are all numeric, even the categorical ones. What happened to the
categorical variables is that they got turned into numbers, and they
have a `names` "attribute" further down that says what those
numbers actually represent.
Thus, on
the `gender` line, the subjects are a female (0), then a male
(1), then three females, then a male, and so on. Variables like
`gender` are thus so far neither really factors nor text
variables, and so we'll have to do a bit of processing before we can
use them: we want to replace the numerical values by the appropriate
"level".

To turn a numeric variable into text depending on the value, we can
use `ifelse`, but this gets unwieldy if there are more than two
values to translate. For that kind of job, I think `case_when`
is a lot easier to read. It also lets us have a catch-all for catching
errors --- "impossible" values occur distressingly often in real data:


```r
xx <- x %>%
  mutate(
    decision = case_when(
      decision == 0 ~ "stop",
      decision == 1 ~ "continue",
      TRUE ~ "error"
    ),
    gender = case_when(
      gender == 0 ~ "Female",
      gender == 1 ~ "Male",
      TRUE ~ "error"
    ),
    scenario = case_when(
      scenario == 1 ~ "cosmetic",
      scenario == 2 ~ "theory",
      scenario == 3 ~ "meat",
      scenario == 4 ~ "veterinary",
      scenario == 5 ~ "medical",
      TRUE ~ "error"
    )
  )
xx %>% as_tibble() %>% select(-(cosmetic:veterin))
```

```
## # A tibble: 315 x 7
##    decision idealism relatvsm gender idealism_LN relatvsm_LN scenario
##    <chr>       <dbl>    <dbl> <chr>        <dbl>       <dbl> <chr>   
##  1 stop          8.2      5.1 Female       2.10         1.63 cosmetic
##  2 continue      6.8      5.3 Male         1.92         1.67 cosmetic
##  3 continue      8.2      6   Female       2.10         1.79 cosmetic
##  4 stop          7.4      6.2 Female       2.00         1.82 cosmetic
##  5 continue      1.7      3.1 Female       0.531        1.13 cosmetic
##  6 continue      5.6      7.7 Male         1.72         2.04 cosmetic
##  7 stop          7.2      6.7 Female       1.97         1.90 cosmetic
##  8 stop          7.8      4   Male         2.05         1.39 cosmetic
##  9 stop          7.8      4.7 Female       2.05         1.55 cosmetic
## 10 stop          8        7.6 Female       2.08         2.03 cosmetic
## # … with 305 more rows
```

 

`xx` is a "real" `data.frame` (that's what
`rio` reads in), and has some extra columns that we don't want
to see right now.

I have three new variables being created in one `mutate`. Each
is being created using a `case_when`. The thing on the left of
each squiggle is a logical condition being tested; the first of these
logical conditions to come out `TRUE` provides the value for
the new variable on the right of the squiggle. Thus, if the (old)
`scenario` is 2, the new `scenario` will be
`theory`. The `TRUE` lines in each case provide
something that is guaranteed to be true, even if all the other lines
are false (eg. if `scenario` is actually recorded as 7, which
would be an error). 

I overwrote the old variable values with the new ones, which is a bit
risky, but then I'd have more things to get rid of later.

My next step is to check that I don't actually have any errors:


```r
xx %>% count(scenario, gender, decision)
```

```
##      scenario gender decision  n
## 1    cosmetic Female continue  8
## 2    cosmetic Female     stop 26
## 3    cosmetic   Male continue 17
## 4    cosmetic   Male     stop 11
## 5        meat Female continue 11
## 6        meat Female     stop 31
## 7        meat   Male continue 12
## 8        meat   Male     stop  9
## 9     medical Female continue 19
## 10    medical Female     stop 24
## 11    medical   Male continue 15
## 12    medical   Male     stop  5
## 13     theory Female continue  8
## 14     theory Female     stop 30
## 15     theory   Male continue 12
## 16     theory   Male     stop 14
## 17 veterinary Female continue 14
## 18 veterinary Female     stop 29
## 19 veterinary   Male continue 12
## 20 veterinary   Male     stop  8
```

 

Don't see any errors there.

So now let's write what we have to a file. I think a `.csv`
would be smart:


```r
xx %>%
  select(decision, idealism, relatvsm, gender, scenario) %>%
  write_csv("decision.csv")
```

 

There is one more tiny detail: in SPSS, variable names can  have a
maximum of eight letters. "Relativism" has 10. So the original data
file had the name "relativism" minus the two "i"s. I changed that
so you would be dealing with a proper English word. (That change is
not shown here.)

There is actually a *town* called Catbrain. It's in England,
near Bristol, and seems to be home to a street of car dealerships.
Just to show that you can do *anything* in R:



```r
library(leaflet)
library(tmaptools)
```

First we need to find the latitude and longitude of Catbrain:


```r
catbrain <- tibble(place = "Catbrain UK")
catbrain %>% mutate(ll = list(geocode_OSM(place))) %>% 
  unnest_wider(ll) %>% 
  unnest_wider(coords) -> catbrain
catbrain
```

```
## # A tibble: 1 x 5
##   place       query           x     y bbox      
##   <chr>       <chr>       <dbl> <dbl> <list>    
## 1 Catbrain UK Catbrain UK -2.61  51.5 <bbox [4]>
```

All right, and then make a map of it:


```r
leaflet(data = catbrain) %>% 
  addTiles() %>% 
  addCircleMarkers(lng = ~x, lat = ~y) -> catbrain_map
catbrain_map
```

```{=html}
<div id="htmlwidget-c00e7bf2473d2dc955b0" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-c00e7bf2473d2dc955b0">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircleMarkers","args":[51.5228823,-2.6124662,10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[51.5228823,51.5228823],"lng":[-2.6124662,-2.6124662]}},"evals":[],"jsHooks":[]}</script>
```


 
 
The car dealerships are along Lysander Road. Zoom in
to see them. 


The name, according to
[link](http://www.bristolpost.co.uk/news/history/name-catbrain-hill-came-825247),
means "rough stony soil", from Middle English, and has nothing to do
with cats or their brains at all.


I was actually surprised that this worked at all, because with only one point, how does it know what scale to draw the map? Also, unless your UK geography is really good, you won't have any clue about exactly where this is. So let's add some other places, some of which you might have heard of:



```r
catbrain2 <- tribble(
  ~where,
  "Catbrain UK",
  "Bristol UK",
  "Taunton UK",
  "Newport UK",
  "Gloucester UK",
  "Cardiff UK",
  "Birmingham UK",
  "London UK",
  "Caldicot UK"
)
catbrain2 %>%
  rowwise() %>% 
  mutate(ll = list(geocode_OSM(where))) %>% 
  unnest_wider(ll) %>% 
  unnest_wider(coords) -> catbrain2
catbrain2
```

```
## # A tibble: 9 x 5
##   where         query              x     y bbox      
##   <chr>         <chr>          <dbl> <dbl> <list>    
## 1 Catbrain UK   Catbrain UK   -2.61   51.5 <bbox [4]>
## 2 Bristol UK    Bristol UK    -2.60   51.5 <bbox [4]>
## 3 Taunton UK    Taunton UK    -3.10   51.0 <bbox [4]>
## 4 Newport UK    Newport UK    -3.00   51.6 <bbox [4]>
## 5 Gloucester UK Gloucester UK -2.25   51.9 <bbox [4]>
## 6 Cardiff UK    Cardiff UK    -3.18   51.5 <bbox [4]>
## 7 Birmingham UK Birmingham UK -1.90   52.5 <bbox [4]>
## 8 London UK     London UK     -0.128  51.5 <bbox [4]>
## 9 Caldicot UK   Caldicot UK   -2.75   51.6 <bbox [4]>
```

The first time I did this, I forgot the `rowwise`, which we didn't need the first time (there was only one place), but here, it causes odd problems if you omit it. 

A map, then:


```r
leaflet(data = catbrain2) %>% 
  addTiles() %>% 
  addCircleMarkers(lng = ~x, lat = ~y)
```

```{=html}
<div id="htmlwidget-22865cceb8901f10f1cd" style="width:672px;height:480px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-22865cceb8901f10f1cd">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircleMarkers","args":[[51.5228823,51.4538022,51.0147895,51.5882332,51.8653705,51.4816546,52.4796992,51.5073219,51.5912466],[-2.6124662,-2.5972985,-3.1029086,-2.9974967,-2.2458192,-3.1791934,-1.9026911,-0.1276474,-2.7517629],10,null,null,{"interactive":true,"className":"","stroke":true,"color":"#03F","weight":5,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]}],"limits":{"lat":[51.0147895,52.4796992],"lng":[-3.1791934,-0.1276474]}},"evals":[],"jsHooks":[]}</script>
```

 

Now, if you have any sense of the geography of the UK, you know where
you are. The places on the left and top of the map are in Wales, including
Caldicot (see question about pottery). The big river (the Severn) is
the border between England and Wales.



More irrelevant extra: the M5 is one of the English "motorways" (like 400-series highways
or US Interstates). The M5 goes from Birmingham to Exeter. You can
tell that this is England because of the huge number of traffic
circles, known there as "roundabouts". One of the first things they
teach you in British driving schools is how to handle roundabouts:
which lane to approach them in, which (stick-shift) gear to be in, and
when you're supposed to signal where you're going. I hope I still
remember all that for when I next drive in England!
    




