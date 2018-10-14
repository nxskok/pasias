# Tidying and selecting data


```r
library(tidyverse)
```

```
## ── Attaching packages ──────────────────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.0.0     ✔ purrr   0.2.5
## ✔ tibble  1.4.2     ✔ dplyr   0.7.6
## ✔ tidyr   0.8.1     ✔ stringr 1.3.1
## ✔ readr   1.1.1     ✔ forcats 0.3.0
```

```
## ── Conflicts ─────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```


##  Tidying the Jays data


 This question is about the Blue Jays data set (that I used
in class).



(a) The Blue Jays baseball data set is at
[http://www.utsc.utoronto.ca/~butler/c32/jays15-home.csv](http://www.utsc.utoronto.ca/~butler/c32/jays15-home.csv). Read
it into R. Check that you have 25 rows and a bunch of variables.



Solution


Save the URL into a variable and then read from the URL, using
`read_csv` because it's a `.csv` file:


```r
myurl="http://www.utsc.utoronto.ca/~butler/c32/jays15-home.csv"
jays=read_csv(myurl)
```

```
## Parsed with column specification:
## cols(
##   .default = col_character(),
##   row = col_integer(),
##   game = col_integer(),
##   runs = col_integer(),
##   Oppruns = col_integer(),
##   innings = col_integer(),
##   position = col_integer(),
##   `game time` = col_time(format = ""),
##   attendance = col_integer()
## )
```

```
## See spec(...) for full column specifications.
```

```r
jays
```

```
## # A tibble: 25 x 21
##      row  game date  box   team  venue opp   result  runs Oppruns innings
##    <int> <int> <chr> <chr> <chr> <chr> <chr> <chr>  <int>   <int>   <int>
##  1    82     7 Mond… boxs… TOR   <NA>  TBR   L          1       2      NA
##  2    83     8 Tues… boxs… TOR   <NA>  TBR   L          2       3      NA
##  3    84     9 Wedn… boxs… TOR   <NA>  TBR   W         12       7      NA
##  4    85    10 Thur… boxs… TOR   <NA>  TBR   L          2       4      NA
##  5    86    11 Frid… boxs… TOR   <NA>  ATL   L          7       8      NA
##  6    87    12 Satu… boxs… TOR   <NA>  ATL   W-wo       6       5      10
##  7    88    13 Sund… boxs… TOR   <NA>  ATL   L          2       5      NA
##  8    89    14 Tues… boxs… TOR   <NA>  BAL   W         13       6      NA
##  9    90    15 Wedn… boxs… TOR   <NA>  BAL   W          4       2      NA
## 10    91    16 Thur… boxs… TOR   <NA>  BAL   W          7       6      NA
## # ... with 15 more rows, and 10 more variables: wl <chr>, position <int>,
## #   gb <chr>, winner <chr>, loser <chr>, save <chr>, `game time` <time>,
## #   Daynight <chr>, attendance <int>, streak <chr>
```
If you must, copy and paste the spreadsheet into R Studio, and read it
in with `read_delim` (or possibly `read_tsv`), but
this runs the risk of being defeated by spreadsheet cells that contain
spaces. I don't think there are any here, but you might run into a
pitcher whose name has more than one word, like (Andy) Van Hekken, who
is in the Seattle Mariners farm system.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">I found this by  googling, after I had scrolled past all the pages of articles about  the baseball pitcher who *lives* in a van.</span>

Anyway, 25 rows and 21 columns. As usual, it's a tibble, so you see 10
rows and as many columns as will fit. This is often enough to see
whether we have the right thing (as we appear to have, here). You can
run through all the columns and check that they're the right kind of
thing; most of them are text with a few numbers and one `time`,
which is ``game time``, the length of the game in hours and
minutes, which is turned into an R `time` in hours, minutes and
seconds. 

With all those columns, `read_csv` doesn't tell you what
column specification it inferred for all of them, but you can type


```r
spec(jays)
```

```
## cols(
##   row = col_integer(),
##   game = col_integer(),
##   date = col_character(),
##   box = col_character(),
##   team = col_character(),
##   venue = col_character(),
##   opp = col_character(),
##   result = col_character(),
##   runs = col_integer(),
##   Oppruns = col_integer(),
##   innings = col_integer(),
##   wl = col_character(),
##   position = col_integer(),
##   gb = col_character(),
##   winner = col_character(),
##   loser = col_character(),
##   save = col_character(),
##   `game time` = col_time(format = ""),
##   Daynight = col_character(),
##   attendance = col_integer(),
##   streak = col_character()
## )
```

to find it all out.



(b) Pick out only the games that were against the New York Yankees
(the variable `opp` is equal to `NYY`). Investigate all
the columns.  What do you notice about these games?



Solution


I get to do this:

```r
jays %>% filter(opp=="NYY") %>% print(width=Inf)
```

```
## # A tibble: 3 x 21
##     row  game date             box      team  venue opp   result  runs
##   <int> <int> <chr>            <chr>    <chr> <chr> <chr> <chr>  <int>
## 1    92    27 Monday, May 4    boxscore TOR   <NA>  NYY   W          3
## 2    93    28 Tuesday, May 5   boxscore TOR   <NA>  NYY   L          3
## 3    94    29 Wednesday, May 6 boxscore TOR   <NA>  NYY   W          5
##   Oppruns innings wl    position gb    winner  loser    save   `game time`
##     <int>   <int> <chr>    <int> <chr> <chr>   <chr>    <chr>  <time>     
## 1       1      NA 13-14        4 3.5   Dickey  Martin   Cecil  02:18      
## 2       6      NA 13-15        5 4.5   Pineda  Estrada  Miller 02:54      
## 3       1      NA 14-15        3 3.5   Buehrle Sabathia <NA>   02:30      
##   Daynight attendance streak
##   <chr>         <int> <chr> 
## 1 N             19217 +     
## 2 N             21519 -     
## 3 N             21312 +
```

but you will probably need to click the little right-arrow at the top
to see more columns. 

I forgot the `width` thing and had to look it up. Also, all the
columns come out in one row, so I had to display it tiny so that you
could see it all.

What I notice is that these games are all on consecutive nights
(against the same team). This is quite common, and goes back to the
far-off days when teams travelled by train: teams play several games
on one visit, rather than coming back many times.\endnote{Hockey is
similar: teams go on "road trips", playing several different teams
before returning home. Hockey teams, though, tend to play each team
only once on a road trip: for example, a west coast team like the
Canucks might play a game in each of Toronto, Montreal, Boston and
New York on a road trip.} You might have noticed something else;
that's fine for this. For example, ``each of the games lasted less
than three hours'', or "the attendances were all small" (since we
looked at all the attendances in class). I just want you to notice
something meaningful that seems to be interesting about these games.

You could also print all the columns in two or more goes, using
`select`, for example:


```r
jays %>% filter(opp=="NYY") %>% select(row:innings) %>% print(width=Inf)
```

```
## # A tibble: 3 x 11
##     row  game date             box      team  venue opp   result  runs
##   <int> <int> <chr>            <chr>    <chr> <chr> <chr> <chr>  <int>
## 1    92    27 Monday, May 4    boxscore TOR   <NA>  NYY   W          3
## 2    93    28 Tuesday, May 5   boxscore TOR   <NA>  NYY   L          3
## 3    94    29 Wednesday, May 6 boxscore TOR   <NA>  NYY   W          5
##   Oppruns innings
##     <int>   <int>
## 1       1      NA
## 2       6      NA
## 3       1      NA
```

```r
jays %>% filter(opp=="NYY") %>% select(wl:streak) %>% print(width=Inf)
```

```
## # A tibble: 3 x 10
##   wl    position gb    winner  loser    save   `game time` Daynight
##   <chr>    <int> <chr> <chr>   <chr>    <chr>  <time>      <chr>   
## 1 13-14        4 3.5   Dickey  Martin   Cecil  02:18       N       
## 2 13-15        5 4.5   Pineda  Estrada  Miller 02:54       N       
## 3 14-15        3 3.5   Buehrle Sabathia <NA>   02:30       N       
##   attendance streak
##        <int> <chr> 
## 1      19217 +     
## 2      21519 -     
## 3      21312 +
```




(c) From the whole data frame, pick out only the games where the
attendance was more than 30,000, showing only the columns
`attendance` and `Daynight`. How many of them are there
(just count them)? How many are day games and how many night games
(just count those too)?



Solution



Two steps, since we selecting rows *and* columns:


```r
jays %>% filter(attendance>30000) %>%
select(c(attendance,Daynight))
```

```
## # A tibble: 8 x 2
##   attendance Daynight
##        <int> <chr>   
## 1      48414 N       
## 2      34743 D       
## 3      44794 D       
## 4      30430 N       
## 5      42917 D       
## 6      42419 D       
## 7      33086 D       
## 8      37929 D
```

The column names do not need quotes; this is part of the nice stuff
about `dplyr`. Or this way, since we are selecting
*consecutive* columns:


```r
jays %>% filter(attendance>30000) %>%
select(c(Daynight:attendance))  
```

```
## # A tibble: 8 x 2
##   Daynight attendance
##   <chr>         <int>
## 1 N             48414
## 2 D             34743
## 3 D             44794
## 4 N             30430
## 5 D             42917
## 6 D             42419
## 7 D             33086
## 8 D             37929
```

There are eight games selected (see the eight rows in the
result). Only two of them are night games, while the other six are day
(weekend) games.

If you wanted to, you could automate the counting, like this:


```r
jays %>% filter(attendance>30000) %>%
count(Daynight)
```

```
## # A tibble: 2 x 2
##   Daynight     n
##   <chr>    <int>
## 1 D            6
## 2 N            2
```

Six day games and two night games.




(d) Display the mean and standard deviation of attendances at all
day and night games.



Solution


Two steps: the grouping according to what I want to group by, then
summarizing according to what I want to summarize by. Since I am
summarizing, only the summaries find their way into the final data
frame, so I don't need to "select out" the other variables:


```r
jays %>% group_by(Daynight) %>%
summarize(mean.att=mean(attendance),
sd.att=sd(attendance))
```

```
## # A tibble: 2 x 3
##   Daynight mean.att sd.att
##   <chr>       <dbl>  <dbl>
## 1 D          37885.  5775.
## 2 N          20087.  8084.
```

The mean attendances are about 38 thousand and about 20 thousand. Note
that the night games have much the larger SD, possibly because of the
large outlier night attendance (opening night). Which we can also
investigate. 


```r
jays %>% group_by(Daynight) %>%
summarize(median.att=median(attendance),
iqr.att=IQR(attendance))
```

```
## # A tibble: 2 x 3
##   Daynight median.att iqr.att
##   <chr>         <dbl>   <dbl>
## 1 D            37929    8754.
## 2 N            17928.   6005.
```
This time, the night attendances have a *smaller* spread and a
noticeably smaller median (compared to the mean), so it must have been
the outlier that made the difference. There was another high value
that R marked as an outlier:


```r
ggplot(jays,aes(x=Daynight,y=attendance))+geom_boxplot()
```

<img src="11-tidying-and-selecting-data_files/figure-html/unnamed-chunk-11-1.png" width="672"  />

So when you take away those unusual values, the night game attendances
are indeed less variable.

The right test, as you might have guessed, for comparing the medians
of these non-normal data, is Mood's median test:


```r
library(smmr)
median_test(jays,attendance,Daynight)
```

```
## $table
##      above
## group above below
##     D     7     0
##     N     5    12
## 
## $test
##        what       value
## 1 statistic 9.882352941
## 2        df 1.000000000
## 3   P-value 0.001668714
```

There was one attendance exactly equal to the overall median (as you
would expect: with an odd number of data values, the median is one of
the data values). `smmr` removed it; if you did the test by
hand, what happens to it depends on whether you counted aboves or
belows, and this will have a small effect on the P-value, though not
on the conclusion.

The overall median attendance was 21,000, and *none* of the day
games had attendance less than that. With the small frequencies, the
accuracy of the P-value is a bit questionable, but taking it at face
value, there *is* a significant difference between median
attendances at day and night games.\endnote{If you do this ``by
hand'', you'll get a warning about the chi-squared approximation
being inaccurate. This is because of the small frequencies, and
*not* because of the outliers. Those are not damaging the test
at all.}



(e) Make normal quantile plots of the day attendances and the night
attendances, separately. Do you see any evidence of non-normality?
(You would expect to on the night attendances because of the big
opening-night value.)



Solution


The best way to do this is facetted normal quantile
plots. Remember that the facetting part goes right at the end:

```r
ggplot(jays,aes(sample=attendance))+
stat_qq()+stat_qq_line()+
facet_wrap(~Daynight,ncol=1)
```

<img src="11-tidying-and-selecting-data_files/figure-html/unnamed-chunk-13-1.png" width="672"  />
The day attendances are pretty normal, though it is hard to be sure
with only 7 of them. 

The night attendances are not normal. The lone point top right is the
outlier. On top of that, the lowest attendances are not quite low enough and
the second-highest attendance is a bit too high, so there is a bit of
evidence of right-skewness as well as just the one outlier. 

If you leave out the `ncol=1`, you'll get the two normal
quantile plots side by side (which means that each one is tall and
skinny, and thus hard to read). The `ncol=1` displays all the
facets in *one* column, and though it would be nice to have the
graphs be about square, landscape mode is easier to read than portrait
mode.  

One of the reasons for skewness is often a limit on the values of the
variable. The Rogers Centre has a capacity around 55,000. The day game
attendances don't get especially close to that, which suggests that
everyone who wants to go to the game can get a ticket. In that sort of
situation, you'd expect attendances to vary around a "typical"
value, with a random deviation that depends on things like the weather
and the opposing team, which is the typical situation in which you get
bell-shaped data. (If the Jays often sold out their stadium for day
games, you'd see a lot of attendances close to the capacity, with a
few lower: ie., a left skew.)

As for the night games, well, there seems to be a minimum attendance
that the Blue Jays get, somewhere around 15,000: no matter who they're
playing or what the weather's like, this many people will show up
(season-ticket holders, for example). On special occasions, such as
opening night, the attendance will be much bigger, which points to a
*right* skew.







##  Ethanol and sleep time in rats


 A biologist wished to study the effects of ethanol on sleep
time in rats. A sample of 20 rats (all the same age) was selected, and
each rat was given an injection having a particular concentration (0,
1, 2 or 4 grams per kilogram of body weight) of ethanol. These are
labelled `e0, e1, e2, e4`. The "0"
treatment was a control group. The rapid eye movement (REM) sleep time
was then recorded for each rat. The data are in
[http://www.utsc.utoronto.ca/~butler/c32/ratsleep.txt](http://www.utsc.utoronto.ca/~butler/c32/ratsleep.txt). 



(a) Read the data in from the file. Check that you have four rows
of observations  and five columns of sleep times.


Solution


Separated by single spaces:

```r
sleep1=read_delim("ratsleep.txt"," ")
```

```
## Parsed with column specification:
## cols(
##   treatment = col_character(),
##   obs1 = col_double(),
##   obs2 = col_double(),
##   obs3 = col_double(),
##   obs4 = col_double(),
##   obs5 = col_double()
## )
```

```r
sleep1
```

```
## # A tibble: 4 x 6
##   treatment  obs1  obs2  obs3  obs4  obs5
##   <chr>     <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 e0         88.6  73.2  91.4  68    75.2
## 2 e1         63    53.9  69.2  50.1  71.5
## 3 e2         44.9  59.5  40.2  56.3  38.7
## 4 e4         31    39.6  45.3  25.2  22.7
```

There are six columns, but one of them labels the groups, and there
are correctly five columns of sleep times.

I used a "temporary" name for my data frame, because I'm going to be
doing some processing on it in a minute, and I want to reserve the
name `sleep` for my processed data frame.



(b) Unfortunately, the data are in the wrong format. All the sleep
times for each treatment group are on one row, and we should have
*one* column containing *all* the sleep times, and the
corresponding row should show which treatment group that sleep time
came from. 
If you prefer to skip this part: read in the data from
[http://www.utsc.utoronto.ca/~butler/c32/ratsleep2.txt](http://www.utsc.utoronto.ca/~butler/c32/ratsleep2.txt), and
proceed to the boxplots in (c).
The `tidyr` function `gather` turns wide format (which
we have) into long format (which we want). `gather` needs
four things fed into it: a data frame, what makes the columns
different, what makes them the same, and finally which columns are
to be `gather`ed together (combined into one column), the
first one, a colon, and the last one.  Save the result of
`gather` into a data frame, and look at it. Do you have 20
rows of not-very-many variables?



Solution


What makes the columns `obs1` through `obs5`
different is that they are different observation numbers
("replicates", in the jargon). I'll call that `rep`. What
makes them the same is that they are all sleep times. Columns
`obs1` through `obs5` are the ones we want to
combine, thus. 
Here is where I use the name `sleep`: I save the result of
the `gather` into a data frame `sleep`. Note that I
also used the brackets-around-the-outside to display what I had,
so that I didn't have to do a separate display. This is a handy
way of saving *and* displaying in one shot:

```r
(sleep1 %>% gather(rep,sleeptime,obs1:obs5) -> sleep)
```

```
## # A tibble: 20 x 3
##    treatment rep   sleeptime
##    <chr>     <chr>     <dbl>
##  1 e0        obs1       88.6
##  2 e1        obs1       63  
##  3 e2        obs1       44.9
##  4 e4        obs1       31  
##  5 e0        obs2       73.2
##  6 e1        obs2       53.9
##  7 e2        obs2       59.5
##  8 e4        obs2       39.6
##  9 e0        obs3       91.4
## 10 e1        obs3       69.2
## 11 e2        obs3       40.2
## 12 e4        obs3       45.3
## 13 e0        obs4       68  
## 14 e1        obs4       50.1
## 15 e2        obs4       56.3
## 16 e4        obs4       25.2
## 17 e0        obs5       75.2
## 18 e1        obs5       71.5
## 19 e2        obs5       38.7
## 20 e4        obs5       22.7
```
We have 20 rows of 3 columns. I got all the rows, but you will
probably get an output with ten rows as usual, and will need to click
Next to see the last ten rows. The initial display will say how many
rows (20) and columns (3) you have.

The column `rep` is not very interesting: it just says which
observation each one was within its group.\endnote{Sometimes the
column playing the role of "rep" *is* interesting to us, but
not here.} The interesting things are `treatment` and
`sleeptime`, which are the two variables we'll need for our
analysis of variance.




(c) Using your new data frame, make side-by-side boxplots of sleep
time by treatment group. 



Solution



```r
ggplot(sleep,aes(x=treatment,y=sleeptime))+geom_boxplot()
```

<img src="11-tidying-and-selecting-data_files/figure-html/unnamed-chunk-16-1.png" width="672"  />




(d) In your boxplots, how does the median sleep time appear to
depend on treatment group?



Solution


It appears to *decrease* as the dose of ethanol increases,
and pretty substantially so (in that the differences ought to be
significant, but that's coming up). 




(e) There is an assumption about spread that the analysis of
variance needs in order to be reliable. Do your boxplots indicate that
this assumption is satisfied for these data, bearing in mind that you
have only five observations per group?



Solution


The assumption is that the population SDs of each group are all
equal. Now, the boxplots show IQRs, which are kind of a surrogate
for SD, and because we only have five observations per group to
base the IQRs on, the *sample* IQRs might vary a bit. So we
should look at the heights of the boxes on the boxplot, and see
whether they are grossly unequal. They appear to be to be of very
similar heights, all things considered, so I am happy.
If you want the SDs themselves:


```r
sleep %>% group_by(treatment) %>%
summarize(stddev=sd(sleeptime))
```

```
## # A tibble: 4 x 2
##   treatment stddev
##   <chr>      <dbl>
## 1 e0         10.2 
## 2 e1          9.34
## 3 e2          9.46
## 4 e4          9.56
```

Those are *very* similar, given only 5 observations per group. No
problems here.




(f) Run an analysis of variance to see whether sleep time differs
significantly among treatment groups. What do you conclude?



Solution


I use `aov` here, because I might be following up with
Tukey in a minute:


```r
sleep.1=aov(sleeptime~treatment,data=sleep)  
summary(sleep.1)
```

```
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## treatment    3   5882    1961   21.09 8.32e-06 ***
## Residuals   16   1487      93                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

This is a very small P-value, so my conclusion is that the mean sleep
times are not all the same for the treatment groups. Further than that
I am not entitled to say (yet).

The technique here is to save the output from `aov` in
something, look at that (via `summary`), and then that same
something gets fed into `TukeyHSD` later. 




(g) Would it be a good idea to run Tukey's method here? Explain
briefly why or why not, and if you think it would be a good idea, run
it.



Solution


Tukey's method is useful when (i) we have run an analysis of
variance and got a significant result and (ii) when we want to know
which groups differ significantly from which. Both (i) and (ii) are
true here. So:


```r
TukeyHSD(sleep.1)  
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = sleeptime ~ treatment, data = sleep)
## 
## $treatment
##         diff       lwr         upr     p adj
## e1-e0 -17.74 -35.18636  -0.2936428 0.0455781
## e2-e0 -31.36 -48.80636 -13.9136428 0.0005142
## e4-e0 -46.52 -63.96636 -29.0736428 0.0000056
## e2-e1 -13.62 -31.06636   3.8263572 0.1563545
## e4-e1 -28.78 -46.22636 -11.3336428 0.0011925
## e4-e2 -15.16 -32.60636   2.2863572 0.1005398
```




(h) What do you conclude from Tukey's method? (This is liable to be
a bit complicated.) Is there a treatment that is clearly best, in
terms of the sleep time being largest?



Solution


All the differences are significant except treatment `e2`
vs.\ `e1` and `e4`. All the differences involving
the control group `e0` are significant, and if you look
back at the boxplots in (c), you'll see that the control group `e0`
had the *highest* mean sleep time. So the control group is
best (from this point of view), or another way of saying it is
that *any* dose of ethanol is significantly reducing mean
sleep time.
The other comparisons are a bit confusing, because the 1-4
difference is significant, but neither of the differences
involving 2 are. That is, 1 is better than 4, but 2 is not
significantly worse than 1 nor better than 4. This seems like it
should be a logical impossibility, but the story is that we don't
have enough data to decide where 2 fits relative to 1 or 4.  If we
had 10 or 20 observations per group, we might be able to conclude
that 2 is in between 1 and 4 as the boxplots suggest.







##  Growth of tomatoes


 A biology graduate student exposed each of 32
tomato plants to one of four different colours of light (8 plants to
each colour). The growth rate of each plant, in millimetres per week,
was recorded. The data are in
[http://www.utsc.utoronto.ca/~butler/c32/tomatoes.txt](http://www.utsc.utoronto.ca/~butler/c32/tomatoes.txt). 



(a) Read the data into R and confirm that you have 8 rows and 5
columns of data.


Solution


This kind of thing:

```r
my_url="http://www.utsc.utoronto.ca/~butler/c32/tomatoes.txt"
toms1=read_delim(my_url," ")
```

```
## Parsed with column specification:
## cols(
##   plant = col_integer(),
##   blue = col_double(),
##   red = col_double(),
##   yellow = col_double(),
##   green = col_double()
## )
```

```r
toms1
```

```
## # A tibble: 8 x 5
##   plant  blue   red yellow green
##   <int> <dbl> <dbl>  <dbl> <dbl>
## 1     1  5.34  13.7   4.61  2.72
## 2     2  7.45  13.0   6.63  1.08
## 3     3  7.15  10.2   5.29  3.97
## 4     4  5.53  13.1   5.29  2.66
## 5     5  6.34  11.1   4.76  3.69
## 6     6  7.16  11.4   5.57  1.96
## 7     7  7.77  14.0   6.57  3.38
## 8     8  5.09  13.5   5.25  1.87
```

I do indeed have 8 rows and 5 columns.

With only 8 rows, listing the data like this is good. 



(b) Re-arrange the data so that you have *one* column
containing all the growth rates, and another column saying which
colour light each plant was exposed to. (The aim here is to produce
something suitable for feeding into `aov` later.) 


Solution


This is a job for `gather`:

```r
toms2 = toms1 %>% gather(colour,growthrate,blue:green)
toms2
```

```
## # A tibble: 32 x 3
##    plant colour growthrate
##    <int> <chr>       <dbl>
##  1     1 blue         5.34
##  2     2 blue         7.45
##  3     3 blue         7.15
##  4     4 blue         5.53
##  5     5 blue         6.34
##  6     6 blue         7.16
##  7     7 blue         7.77
##  8     8 blue         5.09
##  9     1 red         13.7 
## 10     2 red         13.0 
## # ... with 22 more rows
```

Reminder: data frame to gather, what makes the columns different
(they're different colours), what makes them the same (they're all
growth rates), which columns to gather together (all the colour ones).

Since the column `plant` was never mentioned, this gets
repeated as necessary, so now it denotes ``plant within colour
group'', which in this case is not very useful. (Where you have
matched pairs, or repeated measures in general, you *do* want to
keep track of which individual is which. But this is not repeated
measures because plant number 1 in the blue group and plant number 1
in the red group  are *different* plants.)

There were 8 rows originally and 4 different colours, so there should
be, and are, $8 \times 4=32$ rows in the gathered-up data set.



(c) Save the data in the new format to a text file. This is
most easily done using `write_csv`, which is the opposite
of `read_csv`. It requires two things: a data frame, and
the name of a file to save in, which should have a `.csv`
extension.  


Solution


The code is easy enough:

```r
write_csv(toms2,"tomatoes2.csv")
```

If no error, it worked. That's all you need.

To verify (for my satisfaction) that it was saved correctly:


```bash
cat tomatoes2.csv 
```

```
## plant,colour,growthrate
## 1,blue,5.34
## 2,blue,7.45
## 3,blue,7.15
## 4,blue,5.53
## 5,blue,6.34
## 6,blue,7.16
## 7,blue,7.77
## 8,blue,5.09
## 1,red,13.67
## 2,red,13.04
## 3,red,10.16
## 4,red,13.12
## 5,red,11.06
## 6,red,11.43
## 7,red,13.98
## 8,red,13.49
## 1,yellow,4.61
## 2,yellow,6.63
## 3,yellow,5.29
## 4,yellow,5.29
## 5,yellow,4.76
## 6,yellow,5.57
## 7,yellow,6.57
## 8,yellow,5.25
## 1,green,2.72
## 2,green,1.08
## 3,green,3.97
## 4,green,2.66
## 5,green,3.69
## 6,green,1.96
## 7,green,3.38
## 8,green,1.87
```

On my system, that will list the contents of the file. Or you can just
open it in R Studio (if you saved it the way I did, it'll be in the
same folder, and you can find it in the Files pane.)



(d) Make a suitable boxplot, and use it to assess the assumptions
for ANOVA. What do you conclude? Explain briefly. 


Solution


Nothing terribly surprising here. My data frame is called
`toms2`, for some reason:

```r
ggplot(toms2,aes(x=colour, y=growthrate))+geom_boxplot()
```

<img src="11-tidying-and-selecting-data_files/figure-html/unnamed-chunk-24-1.png" width="672"  />

There are no outliers, but there is a little skewness (compare the
*whiskers*, not the placement of the median within the box,
because what matters with skewness is the *tails*, not the middle
of the distribution; it's problems in the tails that make the mean
unsuitable as a measure of centre). The Red group looks the most
skewed. Also, the Yellow group has smaller spread than the others (we
assume that the population variances within each group are equal). The
thing to bear in mind here, though, is that there are only eight
observations per group, so the distributions could appear to have
unequal variances or some non-normality by chance. 

My take is that these data, all things considered, are \emph{just
about} OK for ANOVA. Another option would be to do Welch's ANOVA as
well and compare with the regular ANOVA: if they give more or less the
same P-value, that's a sign that I didn't need to worry.

Extra: some people like to run a formal test on the variances to test
them for equality. My favourite (for reasons explained elsewhere) is
the Levene test, if you insist on going this way. It lives in package
`car`, and *does not* take a `data=`, so you need
to do the `with` thing:


```r
library(car)
```

```
## Loading required package: carData
```

```
## 
## Attaching package: 'car'
```

```
## The following object is masked from 'package:dplyr':
## 
##     recode
```

```
## The following object is masked from 'package:purrr':
## 
##     some
```

```r
with(toms2,leveneTest(growthrate,colour))
```

```
## Warning in leveneTest.default(growthrate, colour): colour coerced to
## factor.
```

```
## Levene's Test for Homogeneity of Variance (center = median)
##       Df F value Pr(>F)
## group  3  0.9075 0.4499
##       28
```

The warning is because `colour` was actually text, but the test
did the right thing by turning it into a factor, so that's OK.

There is no way we can reject equal variances in the four groups. The
$F$-statistic is less than 1, in fact, which says that if the four
groups have the same population variances, the sample variances will
be *more* different than the ones we observed on average, and so
there is no way that these sample variances indicate different
population variances. (This is because of 8 observations only per
group; if there had been 80 observations per group, it would have been
a different story.)

With that in mind, I think the regular ANOVA will be perfectly good,
and we would expect that and the Welch ANOVA to give very similar results.

I don't need `car` again, so let's get rid of it:


```r
detach("package:car",unload=T)
```



(e) Run (regular) ANOVA on these data. What do you conclude?
(Optional extra: if you think that some other variant of ANOVA would
be better, run that as well and compare the results.)


Solution


`aov`, bearing in mind that Tukey is likely to follow:


```r
toms.1=aov(growthrate~colour,data=toms2)
summary(toms.1)
```

```
##             Df Sum Sq Mean Sq F value   Pr(>F)    
## colour       3  410.5  136.82   118.2 5.28e-16 ***
## Residuals   28   32.4    1.16                     
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

This is a tiny P-value, so the mean growth rate for the different
colours is definitely *not* the same for all colours. Or, if you
like, one or more of the colours has a different mean growth rate than
the others.

This, remember, is as far as we go right now.

Extra: if you thought that normality was OK but not equal spreads,
then Welch ANOVA is the way to go:


```r
toms.2=oneway.test(growthrate~colour,data=toms2)
toms.2
```

```
## 
## 	One-way analysis of means (not assuming equal variances)
## 
## data:  growthrate and colour
## F = 81.079, num df = 3.000, denom df = 15.227, p-value = 1.377e-09
```

The P-value is not *quite* as small as for the regular ANOVA, but
it is still very small, and the conclusion is the same.

If you had doubts about the normality (that were sufficiently great,
even given the small sample sizes), then go with Mood's median test
for multiple groups:


```r
library(smmr)
median_test(toms2,growthrate,colour)
```

```
## $table
##         above
## group    above below
##   blue       5     3
##   green      0     8
##   red        8     0
##   yellow     3     5
## 
## $test
##        what        value
## 1 statistic 1.700000e+01
## 2        df 3.000000e+00
## 3   P-value 7.067424e-04
```

The P-value is again extremely small (though not quite as small as for
the other two tests, for the usual reason that Mood's median test
doesn't use the data very efficiently: it doesn't use how *far*
above or below the overall median the data values are.)

The story here, as ever, is consistency: whatever you thought was
wrong, looking at the boxplots, needs to guide the test you do. This
should probably be a flow chart, but this way works too:



* if you are not happy with normality, go with
`median_test` from `smmr` (Mood's median test). 

* if you are happy with normality and equal variances, go with
`aov`.

* if you are happy with normality but not equal variances, go with
`oneway.test` (Welch ANOVA).


So the first thing to think about is normality, and if you are OK with
normality, then think about equal spreads. Bear in mind that you need
to be willing to tolerate a certain amount of non-normality and
inequality in the spreads, given that your data are only samples from
their populations. (Don't expect perfection, in short.)



(f) If warranted, run Tukey. (If not warranted, explain briefly
why not.)


Solution


The reason to run Tukey is that you have found some differences
among the groups, and you want to know what they are. Here, we
*have* said that the colours do not all have the same mean
growth rate, so we want to find what the differences
are. (Looking at the boxplots suggests that red is clearly best
and green clearly worst, and it is possible that all the colours
are significantly different from each other.)

```r
TukeyHSD(toms.1)
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = growthrate ~ colour, data = toms2)
## 
## $colour
##                 diff       lwr        upr     p adj
## green-blue   -3.8125 -5.281129 -2.3438706 0.0000006
## red-blue      6.0150  4.546371  7.4836294 0.0000000
## yellow-blue  -0.9825 -2.451129  0.4861294 0.2825002
## red-green     9.8275  8.358871 11.2961294 0.0000000
## yellow-green  2.8300  1.361371  4.2986294 0.0000766
## yellow-red   -6.9975 -8.466129 -5.5288706 0.0000000
```

All of the differences are (strongly) significant, except for yellow
and blue, the two with middling growth rates on the boxplot. Thus we
would have no hesitation in saying that growth rate is biggest in red
light and smallest in green light.






##  Pain relief in migraine headaches (again)


 The data in
[http://www.utsc.utoronto.ca/~butler/c32/migraine.txt](http://www.utsc.utoronto.ca/~butler/c32/migraine.txt) are from a
study of pain relief in migraine headaches. Specifically, 27 subjects
were randomly assigned to receive *one* of three pain relieving
drugs, labelled A, B and C. Each subject reported the number of hours
of pain relief they obtained (that is, the number of hours between
taking the drug and the migraine symptoms returning). A higher value
is therefore better. Can we make some recommendation about which drug
is best for the population of migraine sufferers?



(a) Read in and display the data. Take a look at the data
file first, and see if you can say why `read_table` will
work and `read_delim` will not.


Solution


The key is two things: the data values are \emph{lined up in
columns}, and \emph{there is more than one space between
values}. The second thing is why `read_delim` will not
work. If you look carefully at the data file, you'll see that
the column names are above and aligned with the columns, which
is what `read_table` wants. If the column names had
*not* been aligned with the columns, we would have needed
`read_table2`. 

```r
my_url="http://www.utsc.utoronto.ca/~butler/c32/migraine.txt"
migraine=read_table(my_url)
```

```
## Parsed with column specification:
## cols(
##   DrugA = col_integer(),
##   DrugB = col_integer(),
##   DrugC = col_integer()
## )
```

```r
migraine
```

```
## # A tibble: 9 x 3
##   DrugA DrugB DrugC
##   <int> <int> <int>
## 1     4     6     6
## 2     5     8     7
## 3     4     4     6
## 4     3     5     6
## 5     2     4     7
## 6     4     6     5
## 7     3     5     6
## 8     4    11     5
## 9     4    10     5
```

Success.
 We'll not be reading data like this into SAS in this course, but you
 might like to know how it goes (for future reference). It uses a
 `data` step, like we've been using to create new variables, thus:
 
 \begin{Datastep}
 filename myurl url 'http://www.utsc.utoronto.ca/~butler/c32/migraine.txt';
 data pain;
   infile myurl firstobs=2;
   input druga drugb drugc;
 \end{Datastep}
 
 \begin{Sascode}[store=maqax]
 proc print;  
 \end{Sascode}
 
 \Listing[store=maqax, fontsize=footnotesize]{maqaxx}



(b) What is it about the experimental design that makes a one-way
analysis of variance plausible for data like this?


Solution


Each experimental subject only tested *one* drug, so that
we have 27 independent observations, nine from each drug. This
is exactly the setup that a one-way ANOVA requires. 
Compare that to, for example, a situation where you had only 9
subjects, but they each tested *all* the drugs (so that
each subject produced three measurements). That is like a
three-measurement version of matched pairs, a so-called
**repeated-measures design**, which requires its own kind
of analysis.\endnote{To allow for the fact that measurements on the same
subject are not independent but correlated.} 



(c) What is wrong with the current format of the data as far as
doing a one-way ANOVA analysis is concerned? (This is related to the
idea of whether or not the data are "tidy".)


Solution


For our analysis, we need one column of pain relief time and one
column labelling the drug that the subject in question took. 
Or, if you prefer to think about what would make these data
"tidy": there are 27 subjects, so there ought to be 27 rows,
and all three columns are measurements of pain relief, so they
ought to be in one column.



(d) "Tidy" the data to produce a data frame suitable for your
analysis. 


Solution


`gather` the columns that are all measurements of one
thing.
The syntax of `gather` is: what
makes the columns different, what makes them the same, and which
columns need to be gathered together. Use a pipe to name the
dataframe to work with. I'm going to save my new data frame:

```r
(migraine %>% gather(drug,painrelief,DrugA:DrugC) -> migraine2)
```

```
## # A tibble: 27 x 2
##    drug  painrelief
##    <chr>      <int>
##  1 DrugA          4
##  2 DrugA          5
##  3 DrugA          4
##  4 DrugA          3
##  5 DrugA          2
##  6 DrugA          4
##  7 DrugA          3
##  8 DrugA          4
##  9 DrugA          4
## 10 DrugB          6
## # ... with 17 more rows
```

The brackets around the whole thing print out the result as well as
saving it. If you don't have those, you'll need to type
`migraine2` again to display it.

We do indeed have a new data frame with 27 rows, one per observation,
and 2 columns, one for each variable: the pain relief hours, plus a
column identifying which drug that pain relief time came from. Exactly
what `aov` needs.

You can probably devise a better name for your new data frame.



(e) Go ahead and run your one-way ANOVA (and Tukey if
necessary). Assume for this that the pain relief hours in each group
are sufficiently close to normally distributed with sufficiently
equal spreads.


Solution


My last sentence absolves us from doing the boxplots that we
would normally insist on doing. 

```r
painrelief.1=aov(painrelief~drug,data=migraine2)
summary(painrelief.1)
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)   
## drug         2  41.19   20.59   7.831 0.00241 **
## Residuals   24  63.11    2.63                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

There are (strongly) significant differences among the drugs, so it is
definitely worth firing up Tukey to figure out where the differences are:


```r
TukeyHSD(painrelief.1)  
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = painrelief ~ drug, data = migraine2)
## 
## $drug
##                   diff        lwr      upr     p adj
## DrugB-DrugA  2.8888889  0.9798731 4.797905 0.0025509
## DrugC-DrugA  2.2222222  0.3132065 4.131238 0.0203671
## DrugC-DrugB -0.6666667 -2.5756824 1.242349 0.6626647
```

Both the differences involving drug A are significant, and because a
high value of `painrelief` is better, in both cases drug A is
*worse* than the other drugs. Drugs B and C are not significantly
different from each other.

Extra: we can also use the "pipe" to do this all in one go:


```r
migraine %>%
gather(drug,painrelief,DrugA:DrugC) %>%
aov(painrelief~drug,data=.) %>%
summary()
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)   
## drug         2  41.19   20.59   7.831 0.00241 **
## Residuals   24  63.11    2.63                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

with the same results as before. Notice that I never actually created
a second data frame by name; it was created by `gather` and
then immediately used as input to `aov`.\endnote{And then thrown
away.} I also used the
`data=.` trick to use ``the data frame that came out of the
previous step'' as my input to `aov`.

Read the above like this: ``take `migraine`, and then gather
together the `DrugA` through `DrugC` columns into a
column `painrelief`, labelling each by its drug, and then do an
ANOVA of `painrelief` by `drug`, and then summarize the results.''

What is even more alarming is that I can feed the output from
`aov` straight into `TukeyHSD`:


```r
migraine %>%
gather(drug,painrelief,DrugA:DrugC) %>%
aov(painrelief~drug,data=.) %>%
TukeyHSD()
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = painrelief ~ drug, data = .)
## 
## $drug
##                   diff        lwr      upr     p adj
## DrugB-DrugA  2.8888889  0.9798731 4.797905 0.0025509
## DrugC-DrugA  2.2222222  0.3132065 4.131238 0.0203671
## DrugC-DrugB -0.6666667 -2.5756824 1.242349 0.6626647
```

I wasn't sure whether this would work, since the output from
`aov` is an R `list` rather than a data frame, but the
output from `aov` is sent into `TukeyHSD` whatever
kind of thing it is.

What I am missing here is to display the result of `aov`
*and* use it as input to `TukeyHSD`. Of course, I had to
discover that this could be solved, and indeed it can:


```r
migraine %>%
gather(drug,painrelief,DrugA:DrugC) %>%
aov(painrelief~drug,data=.) %>%
{ print(summary(.)) ; . } %>%
TukeyHSD()
```

```
##             Df Sum Sq Mean Sq F value  Pr(>F)   
## drug         2  41.19   20.59   7.831 0.00241 **
## Residuals   24  63.11    2.63                   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = painrelief ~ drug, data = .)
## 
## $drug
##                   diff        lwr      upr     p adj
## DrugB-DrugA  2.8888889  0.9798731 4.797905 0.0025509
## DrugC-DrugA  2.2222222  0.3132065 4.131238 0.0203671
## DrugC-DrugB -0.6666667 -2.5756824 1.242349 0.6626647
```

The odd-looking second-last line of that uses that `.` trick
for "whatever came out of the previous step". The thing inside the
curly brackets is two commands one after the other; the first is to
display the `summary` of that `aov`\endnote{It needs
`print` around it to display it, as you need `print`
to display something within a loop or a function.} and the second
part after the `;` is to just pass whatever came out of the
previous line, the output from `aov`, on, unchanged, into
`TukeyHSD`. 

In the Unix world this is called `tee`,
where you print something *and* pass it on to the next step. The
name `tee` comes from a (real) pipe that plumbers would use to
split water flow into two, which looks like a letter T.



(f) What recommendation would you make about the best drug or
drugs? Explain briefly.


Solution


Drug A is significantly the worst, so we eliminate that. But
there is no significant difference between drugs B and C, so we
have no reproducible reason for preferring one rather than the
other. Thus, we recommend "either B or C". 
If you weren't sure which way around the drugs actually came
out, then you should work out the mean pain relief score by
drug:


```r
migraine2 %>%
group_by(drug) %>%
summarize(m=mean(painrelief))
```

```
## # A tibble: 3 x 2
##   drug      m
##   <chr> <dbl>
## 1 DrugA  3.67
## 2 DrugB  6.56
## 3 DrugC  5.89
```
These confirm that A is worst, and there is nothing much to choose
between B and C.
You should *not* recommend drug C over drug B on this evidence,
just because its (sample) mean is higher than B's. The point about significant
differences is that they are supposed to stand up to replication: in
another experiment, or in real-life experiences with these drugs, the
mean pain relief score for drug A is expected to be worst, but between
drugs B and C, sometimes the mean of B will come out higher and
sometimes C's mean will be higher, because there is no significant
difference between them.
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">This talks about emph{means</span> rather
than individual observations; in individual cases, sometimes even
drug *A* will come out best. But we're interested in
population means, since we want to do the greatest good for the
greatest number.}\endnote{"Greatest good for the greatest number"
is from Jeremy Bentham, 1748--1832, British
philosopher and advocate of utilitarianism.}
Another way is to draw a boxplot of pain-relief scores:


```r
ggplot(migraine2,aes(x=drug,y=painrelief))+geom_boxplot()
```

<img src="11-tidying-and-selecting-data_files/figure-html/unnamed-chunk-39-1.png" width="672"  />

The medians of drugs B and C are actually exactly the same. Because
the pain relief values are all whole numbers (and there are only 9 in
each group), you get that thing where enough of them are equal that
the median and third quartiles are equal, actually for all three
groups. 

Despite the outlier, I'm willing to call these groups sufficiently
symmetric for the ANOVA to be OK (but I didn't ask you to draw the
boxplot, because I didn't want to confuse the issue with this. The
point of this question was to get the data tidy enough to do an
analysis.) Think about it for a moment: that outlier is a value of 8.
This is really not that much bigger than the value of 7 that is the
highest one on drug C. The 7 for drug C is not an outlier. The only
reason the 8 came out as an outlier was because the IQR was only 1. If
the IQR on drug B had happened to be a bit bigger, the 8 would not
have been an outlier. 

As I said, I didn't want you to have to get into this, but if you are
worried, you know what the remedy is --- Mood's median test. Don't
forget to use the right data frame:


```r
library(smmr)
median_test(migraine2,painrelief,drug)
```

```
## $table
##        above
## group   above below
##   DrugA     0     8
##   DrugB     5     2
##   DrugC     6     0
## 
## $test
##        what        value
## 1 statistic 1.527273e+01
## 2        df 2.000000e+00
## 3   P-value 4.825801e-04
```

Because the pain relief scores are integers, there are probably a lot
of them equal to the overall median. There were 27 observations
altogether, but Mood's median test will discard any that are equal to
this value. There must have been 9 observations in each group to start
with, but if you look at each row of the table, there are only 8
observations listed for drug A, 7 for drug B and 6 for drug C, so
there must have been 1, 2 and 3 (totalling 6) observations equal to
the median that were discarded.

The P-value is a little bigger than came out of the $F$-test, but the
conclusion is still that there are definitely differences among the
drugs in terms of pain relief. The table at the top of the output
again suggests that drug A is worse than the others, but to confirm
that you'd have to do Mood's median test on all three *pairs* of
drugs, and then use Bonferroni to allow for your having done three tests.






##  Location, species and disease in plants


 The table below is a "contingency table", showing
frequencies of diseased and undiseased plants of two different species
in two different locations:


```

Species     Disease present         Disease absent
Location X Location Y  Location X Location Y
A            44         12          38        10
B            28         22          20        18

```


The data were saved as
[http://www.utsc.utoronto.ca/~butler/c32/disease.txt](http://www.utsc.utoronto.ca/~butler/c32/disease.txt). In that
file, the columns are coded by two letters: a `p` or an
`a` to denote presence or absence of disease, and an `x`
or a `y` to denote location X or Y. The data are separated by
multiple spaces and aligned with the variable names. 



(a) Read in and display the data.


Solution


`read_table` again. You know this because, when you looked
at the data file, which of course you did (didn't you?), you saw
that the data values were aligned by columns with multiple spaces
between them:

```r
my_url="http://www.utsc.utoronto.ca/~butler/c32/disease.txt"
tbl=read_table(my_url)
```

```
## Parsed with column specification:
## cols(
##   Species = col_character(),
##   px = col_integer(),
##   py = col_integer(),
##   ax = col_integer(),
##   ay = col_integer()
## )
```

```r
tbl
```

```
## # A tibble: 2 x 5
##   Species    px    py    ax    ay
##   <chr>   <int> <int> <int> <int>
## 1 A          44    12    38    10
## 2 B          28    22    20    18
```

I was thinking ahead, since I'll be wanting to have one of my columns
called `disease`, so I'm *not* calling the data frame
`disease`. 

You'll also have noticed that I simplified the data frame that I had
you read in, because the original contingency table I showed you has
*two* header rows, and we have to have *one* header row. So
I mixed up the information in the two header rows into one.



(b)\label{part:nottidy} Explain briefly how these data are not "tidy".


Solution


The simple answer is that there are 8 frequencies, that each ought
to be in a row by themselves. Or, if you like, there are three
variables, Species, Disease status and Location, and each of
*those* should be in a *column* of its own. 
Either one
of these ideas, or something like it, is good. I need you to
demonstrate that you know something about "tidy data" in this context.



(c) Use a suitable `tidyr` tool to get all the things
that are the same into a single column. (You'll need to make up a
temporary name for the other new column that you create.) Show your
result. 


Solution


`gather` is the tool. All the columns apart from
`Species` contain frequencies, so that's what's ``the
same''. They are frequencies in disease-location combinations, so
I'll call the column of "what's different" `disloc`. Feel
free to call it `temp` for now if you prefer:

```r
(tbl %>% gather(disloc,frequency,px:ay) -> tbl.2)
```

```
## # A tibble: 8 x 3
##   Species disloc frequency
##   <chr>   <chr>      <int>
## 1 A       px            44
## 2 B       px            28
## 3 A       py            12
## 4 B       py            22
## 5 A       ax            38
## 6 B       ax            20
## 7 A       ay            10
## 8 B       ay            18
```

This also works ("gather together everything but `Species`"):


```r
(tbl %>% gather(disloc,frequency,-Species) -> tbl.2)
```

```
## # A tibble: 8 x 3
##   Species disloc frequency
##   <chr>   <chr>      <int>
## 1 A       px            44
## 2 B       px            28
## 3 A       py            12
## 4 B       py            22
## 5 A       ax            38
## 6 B       ax            20
## 7 A       ay            10
## 8 B       ay            18
```



(d) Explain briefly how the data frame you just created is
still not "tidy" yet.


Solution


The column I called `disloc` actually contains *two*
variables, disease and location, which need to be split up. A
check on this is that we 
have two columns (not including the frequencies), but back in
(\ref{part:nottidy}) we found *three* variables, so there
ought to be three non-frequency columns.



(e) Use one more `tidyr` tool to make these data tidy,
and show your result.


Solution


This means splitting up `disloc` into two separate columns,
splitting after the first character, thus:

```r
(tbl.2 %>% separate(disloc,c("disease","location"),1) -> tbl.3)
```

```
## # A tibble: 8 x 4
##   Species disease location frequency
##   <chr>   <chr>   <chr>        <int>
## 1 A       p       x               44
## 2 B       p       x               28
## 3 A       p       y               12
## 4 B       p       y               22
## 5 A       a       x               38
## 6 B       a       x               20
## 7 A       a       y               10
## 8 B       a       y               18
```

This is now tidy: eight frequencies in rows, and three non-frequency
columns. (Go back and look at your answer to part (\ref{part:nottidy})
and note that the issues you found there have all been resolved now.)



(f) Let's see if we can re-construct the original contingency
table (or something equivalent to it). Use the function
`xtabs`. This requires first a model formula with the frequency
variable on the left of the squiggle, and the other variables
separated by plus signs on the right. Second it requires a data
frame, with `data=`. Feed
your data frame from the previous part into `xtabs`. Save the
result in a variable and display the result.


Solution



```r
tbl.4=xtabs(frequency~Species+disease+location,data=tbl.3)
tbl.4
```

```
## , , location = x
## 
##        disease
## Species  a  p
##       A 38 44
##       B 20 28
## 
## , , location = y
## 
##        disease
## Species  a  p
##       A 10 12
##       B 18 22
```

This shows a pair of contingency tables, one each for each of the two
locations (in general, the variable you put last on the right side of
the model formula). You can check that everything corresponds with the
original data layout at the beginning of the question, possibly with
some things rearranged (but with the same frequencies in the same
places). 



(g) Take the output from the last part and feed it into the
function `ftable`. How has the output been changed? Which do
you like better? Explain briefly.


Solution


This:

```r
ftable(tbl.4)  
```

```
##                 location  x  y
## Species disease               
## A       a                38 10
##         p                44 12
## B       a                20 18
##         p                28 22
```

This is the same output, but shown more compactly. (Rather like a
vertical version of the original data, in fact.) I like
`ftable` better because it displays the data in the smallest
amount of space, though I'm fine if you prefer the `xtabs`
output because it spreads things out more. This is a matter of
taste. Pick one and tell me why you prefer it, and I'm good.

That's the end of what you had to do, but I thought I would do some
modelling and try to find out what's associated with disease. The
appropriate modelling with frequencies is called ``log-linear
modelling'', and it assumes that the log of the frequencies has a
linear relationship with the effects of the other variables. This is
not quite as simple as the log transformations we had before, because
bigger frequencies are going to be more variable, so we fit a
generalized linear model with a Poisson-distributed response and log
link. (It's better if you know what that means, but you ought to be
able to follow the logic if you don't.)

First, fit a model predicting frequency from everything, including all
the interactions. (The reason for doing it this way will become clear later):


```r
model.1=glm(frequency~Species*location*disease,data=tbl.3,family="poisson")
drop1(model.1,test="Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species * location * disease
##                          Df Deviance    AIC      LRT Pr(>Chi)
## <none>                      0.000000 55.291                  
## Species:location:disease  1 0.070257 53.362 0.070257    0.791
```

The residuals are all zero because this model fits perfectly. The
problem is that it is very complicated, so it offers no insight. So
what we do is to look at the highest-order interaction
`Species:location:disease` and see whether it is
significant. It is not, so we can remove it. This is reminiscent of
variable selection in regression, where we pull the least significant
thing out of the model in turn until we can go no further. But here,
we have additional things to think about: we have to get rid of all
the three-way interactions before we can tackle the two-way ones, and
all the two-way ones before we can tackle the main effects. There is a
so-called "nested" structure happening here that says you don't look
at, say, `Species`, until you have removed *all* the
higher-order interactions involving `Species`. Not clear yet?
Don't fret. `drop1` allows you to assess what is currently up
for grabs (here, only the three-way interaction, which is not
significant, so out it comes).

Let's get rid of that three-way interaction. This is another use for
`update` that we've seen in connection with multiple regression
(to make small changes to a big model):


```r
model.2=update(model.1,.~.-Species:location:disease)
drop1(model.2,test="Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + disease + Species:location + 
##     Species:disease + location:disease
##                  Df Deviance    AIC     LRT  Pr(>Chi)    
## <none>                0.0703 53.362                      
## Species:location  1  13.0627 64.354 12.9924 0.0003128 ***
## Species:disease   1   0.2696 51.561  0.1993 0.6552865    
## location:disease  1   0.1043 51.396  0.0340 0.8536877    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

Notice how `update` saved us having to write the whole model
out again.

Now the three two-way interactions are up for grabs:
`Species:location`, `Species:disease` and
`location:disease`. The last of these is the least significant,
so out it comes. I did some copying and pasting, but I had to remember
which model I was working with and what I was removing:


```r
model.3=update(model.2,.~.-location:disease)
drop1(model.3,test="Chisq")  
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + disease + Species:location + 
##     Species:disease
##                  Df Deviance    AIC     LRT  Pr(>Chi)    
## <none>                0.1043 51.396                      
## Species:location  1  13.0678 62.359 12.9635 0.0003176 ***
## Species:disease   1   0.2746 49.566  0.1703 0.6798021    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

`Species:disease` comes out, but it looks as if
`Species:location` will have to stay:


```r
model.4=update(model.3,.~.-Species:disease)
drop1(model.4,test="Chisq")  
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + disease + Species:location
##                  Df Deviance    AIC     LRT  Pr(>Chi)    
## <none>                0.2746 49.566                      
## disease           1   2.3617 49.653  2.0871 0.1485461    
## Species:location  1  13.2381 60.530 12.9635 0.0003176 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

`Species:location` indeed stays. That means that anything
"contained in" it also has to stay, regardless of its main
effect. So the only candidate for removal now is `disease`: not
significant, out it comes:


```r
model.5=update(model.4,.~.-disease)
drop1(model.5,test="Chisq")  
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + Species:location
##                  Df Deviance    AIC    LRT  Pr(>Chi)    
## <none>                2.3617 49.653                     
## Species:location  1  15.3252 60.617 12.963 0.0003176 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

And now we have to stop.

What does this final model mean? Well, frequency depends significantly
on the `Species:location` combination, but not on anything
else. To see how, we make a contingency table of species by location
(totalling up over disease status, since that is not significant):


```r
xtabs(frequency~Species+location,data=tbl.3)  
```

```
##        location
## Species  x  y
##       A 82 22
##       B 48 40
```

Most of the species A's are at location X, but the species B's are
about evenly divided between the two locations. Or, if you prefer
(equally good): location X has mostly species A, while location Y has
mostly species B. You can condition on either variable and compare the
conditional distribution of the other one.

Now, this is rather interesting, because this began as a study of
disease, but disease has completely disappeared from our final model!
That means that nothing in our final model has any relationship with
disease. Indeed, if you check the original table, you'll find that
disease is present slightly more than it's absent, for all
combinations of species and location. That is, neither species nor
location has any particular association with (effect on) disease,
since disease prevalence doesn't change appreciably if you change
location, species or the combination of them.

The way an association with disease would show up is if a
`disease:`something interaction had been significant and had
stayed in the model, that something would have been associated with
disease. For example, if the `disease:Species` table had looked
like this:


```r
disease=c("a","a","p","p")
Species=c("A","B","A","B")
frequency=c(10,50,30,30)
xx=data.frame(disease,Species,frequency)
xtabs(frequency~disease+Species)
```

```
##        Species
## disease  A  B
##       a 10 50
##       p 30 30
```

For species A, disease is present 75\% of the time, but for species B
it's present less than 40\% of the time. So in this one there ought to be a
significant association between disease and species:


```r
xx.1=glm(frequency~disease*Species,data=xx,family="poisson")
drop1(xx.1,test="Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ disease * Species
##                 Df Deviance    AIC    LRT  Pr(>Chi)    
## <none>                0.000 28.400                     
## disease:Species  1   15.518 41.918 15.518 8.171e-05 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

And so there is. Nothing can come out of the model. (This is the same
kind of test as a chi-squared test for association, if you know about
that.  The log-linear model is a multi-variable generalization of that.)






##  Ken's cars


 My cars data file can be found at
[http://www.utsc.utoronto.ca/~butler/c32/cars.csv](http://www.utsc.utoronto.ca/~butler/c32/cars.csv). We're doing
this question in R now, but later we'll be doing the exact same thing
in SAS, so you'll be able then to compare your results.  The values in
the data file are separated by commas; the car names are up to 29
characters long.  Display your results for each part after (a). In R,
displaying a `tibble` normally shows its first ten lines, which
is all you need here; there's no need to display all the lines unless
you want to.


(a) Read the data into R and list the values.


Solution


`read_csv` will do it:

```r
my_url="http://www.utsc.utoronto.ca/~butler/c32/cars.csv"
cars=read_csv(my_url)  
```

```
## Parsed with column specification:
## cols(
##   car = col_character(),
##   MPG = col_double(),
##   weight = col_double(),
##   cylinders = col_integer(),
##   hp = col_integer(),
##   country = col_character()
## )
```

```r
cars
```

```
## # A tibble: 38 x 6
##    car                  MPG weight cylinders    hp country
##    <chr>              <dbl>  <dbl>     <int> <int> <chr>  
##  1 Buick Skylark       28.4   2.67         4    90 U.S.   
##  2 Dodge Omni          30.9   2.23         4    75 U.S.   
##  3 Mercury Zephyr      20.8   3.07         6    85 U.S.   
##  4 Fiat Strada         37.3   2.13         4    69 Italy  
##  5 Peugeot 694 SL      16.2   3.41         6   133 France 
##  6 VW Rabbit           31.9   1.92         4    71 Germany
##  7 Plymouth Horizon    34.2   2.2          4    70 U.S.   
##  8 Mazda GLC           34.1   1.98         4    65 Japan  
##  9 Buick Estate Wagon  16.9   4.36         8   155 U.S.   
## 10 Audi 5000           20.3   2.83         5   103 Germany
## # ... with 28 more rows
```
      


(b) Display only the car names and the countries they come from.


Solution




```r
cars %>% select(car,country)
```

```
## # A tibble: 38 x 2
##    car                country
##    <chr>              <chr>  
##  1 Buick Skylark      U.S.   
##  2 Dodge Omni         U.S.   
##  3 Mercury Zephyr     U.S.   
##  4 Fiat Strada        Italy  
##  5 Peugeot 694 SL     France 
##  6 VW Rabbit          Germany
##  7 Plymouth Horizon   U.S.   
##  8 Mazda GLC          Japan  
##  9 Buick Estate Wagon U.S.   
## 10 Audi 5000          Germany
## # ... with 28 more rows
```

This *almost* works, but not quite:


```r
cars %>% select(starts_with("c"))
```

```
## # A tibble: 38 x 3
##    car                cylinders country
##    <chr>                  <int> <chr>  
##  1 Buick Skylark              4 U.S.   
##  2 Dodge Omni                 4 U.S.   
##  3 Mercury Zephyr             6 U.S.   
##  4 Fiat Strada                4 Italy  
##  5 Peugeot 694 SL             6 France 
##  6 VW Rabbit                  4 Germany
##  7 Plymouth Horizon           4 U.S.   
##  8 Mazda GLC                  4 Japan  
##  9 Buick Estate Wagon         8 U.S.   
## 10 Audi 5000                  5 Germany
## # ... with 28 more rows
```

It gets *all* the columns that start with `c`, which
includes `cylinders` as well.
      


(c) Display everything *except* horsepower:


Solution


Naming what you *don't* want is sometimes easier:

```r
cars %>% select(-hp)  
```

```
## # A tibble: 38 x 5
##    car                  MPG weight cylinders country
##    <chr>              <dbl>  <dbl>     <int> <chr>  
##  1 Buick Skylark       28.4   2.67         4 U.S.   
##  2 Dodge Omni          30.9   2.23         4 U.S.   
##  3 Mercury Zephyr      20.8   3.07         6 U.S.   
##  4 Fiat Strada         37.3   2.13         4 Italy  
##  5 Peugeot 694 SL      16.2   3.41         6 France 
##  6 VW Rabbit           31.9   1.92         4 Germany
##  7 Plymouth Horizon    34.2   2.2          4 U.S.   
##  8 Mazda GLC           34.1   1.98         4 Japan  
##  9 Buick Estate Wagon  16.9   4.36         8 U.S.   
## 10 Audi 5000           20.3   2.83         5 Germany
## # ... with 28 more rows
```
      


(d) Display only the cars that have 8-cylinder engines (but
display all the variables for those cars).


Solution


This:

```r
cars %>% filter(cylinders==8)  
```

```
## # A tibble: 8 x 6
##   car                         MPG weight cylinders    hp country
##   <chr>                     <dbl>  <dbl>     <int> <int> <chr>  
## 1 Buick Estate Wagon         16.9   4.36         8   155 U.S.   
## 2 Chevy Malibu Wagon         19.2   3.60         8   125 U.S.   
## 3 Chrysler LeBaron Wagon     18.5   3.94         8   150 U.S.   
## 4 Ford LTD                   17.6   3.72         8   129 U.S.   
## 5 Dodge St Regis             18.2   3.83         8   135 U.S.   
## 6 Ford Country Squire Wagon  15.5   4.05         8   142 U.S.   
## 7 Mercury Grand Marquis      16.5   3.96         8   138 U.S.   
## 8 Chevy Caprice Classic      17     3.84         8   130 U.S.
```
8 of them, all from the US.
      


(e) Display the cylinders and horsepower for the cars that have
horsepower 70 or less.


Solution


This one is selecting some observations and some variables:

```r
cars %>% filter(hp<=70) %>% select(cylinders:hp)
```

```
## # A tibble: 6 x 2
##   cylinders    hp
##       <int> <int>
## 1         4    69
## 2         4    70
## 3         4    65
## 4         4    65
## 5         4    68
## 6         4    68
```

Cylinders and horsepower are consecutive columns, so we can select
them either using the colon `:` or by
`c(cylinders,hp)`. 

You can also do the `filter` and the
`select` the other way around.
This one works because the *rows* you want to
choose are determined by a column you're going to keep. If you wanted
to display the cylinders and horsepower of the cars with `mpg`
over 30, you would have to choose the rows first, because after you've
chosen the columns, there is no `mpg` any more.
      


(f) Find the mean and SD of gas mileage of the cars with 4 cylinders.


Solution




```r
cars %>% filter(cylinders==4) %>% summarize(m=mean(MPG),s=sd(MPG))  
```

```
## # A tibble: 1 x 2
##       m     s
##   <dbl> <dbl>
## 1  30.0  4.18
```

Or you can get the mean and SD of gas mileage for all numbers of
cylinders, and pick out the one you want:


```r
cars %>% group_by(cylinders) %>% summarize(m=mean(MPG),s=sd(MPG))
```

```
## # A tibble: 4 x 3
##   cylinders     m     s
##       <int> <dbl> <dbl>
## 1         4  30.0  4.18
## 2         5  20.3 NA   
## 3         6  21.1  4.08
## 4         8  17.4  1.19
```

Top row is the same as before. And since the output is a data frame,
you can do any of these things with *that*, for example:


```r
cars %>% group_by(cylinders) %>% 
summarize(m=mean(MPG),s=sd(MPG)) %>%
filter(cylinders==4)
```

```
## # A tibble: 1 x 3
##   cylinders     m     s
##       <int> <dbl> <dbl>
## 1         4  30.0  4.18
```

to pick out just the right row.
This is a very easy kind of question to set on an exam. Just so you know.
      




