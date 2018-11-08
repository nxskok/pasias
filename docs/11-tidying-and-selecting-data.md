# Tidying and selecting data


```r
library(tidyverse)
```

```
## -- Attaching packages ---- tidyverse 1.2.1 --
```

```
## v ggplot2 3.0.0     v purrr   0.2.5
## v tibble  1.4.2     v dplyr   0.7.6
## v tidyr   0.8.1     v stringr 1.3.1
## v readr   1.1.1     v forcats 0.3.0
```

```
## -- Conflicts ------- tidyverse_conflicts() --
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```


##  Tidying the Jays data


 This question is about the Blue Jays data set (that I used
in class).



(a) The Blue Jays baseball data set is at
[link](http://www.utsc.utoronto.ca/~butler/c32/jays15-home.csv). Read
it into R. Check that you have 25 rows and a bunch of variables.



Solution


Save the URL into a variable and then read from the URL, using
`read_csv` because it's a `.csv` file:


```r
myurl = "http://www.utsc.utoronto.ca/~butler/c32/jays15-home.csv"
jays = read_csv(myurl)
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
##      row  game date  box   team  venue opp  
##    <int> <int> <chr> <chr> <chr> <chr> <chr>
##  1    82     7 Mond~ boxs~ TOR   <NA>  TBR  
##  2    83     8 Tues~ boxs~ TOR   <NA>  TBR  
##  3    84     9 Wedn~ boxs~ TOR   <NA>  TBR  
##  4    85    10 Thur~ boxs~ TOR   <NA>  TBR  
##  5    86    11 Frid~ boxs~ TOR   <NA>  ATL  
##  6    87    12 Satu~ boxs~ TOR   <NA>  ATL  
##  7    88    13 Sund~ boxs~ TOR   <NA>  ATL  
##  8    89    14 Tues~ boxs~ TOR   <NA>  BAL  
##  9    90    15 Wedn~ boxs~ TOR   <NA>  BAL  
## 10    91    16 Thur~ boxs~ TOR   <NA>  BAL  
## # ... with 15 more rows, and 14 more
## #   variables: result <chr>, runs <int>,
## #   Oppruns <int>, innings <int>, wl <chr>,
## #   position <int>, gb <chr>, winner <chr>,
## #   loser <chr>, save <chr>, `game
## #   time` <time>, Daynight <chr>,
## #   attendance <int>, streak <chr>
```


If you must, copy and paste the spreadsheet into R Studio, and read it
in with `read_delim` (or possibly `read_tsv`), but
this runs the risk of being defeated by spreadsheet cells that contain
spaces. I don't think there are any here, but you might run into a
pitcher whose name has more than one word, like (Andy) Van Hekken, who
is in the Seattle Mariners farm system.
\marginnote{I found this by  googling, after I had scrolled past all the pages of articles about  the baseball pitcher who *lives* in a van.}

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
jays %>% filter(opp == "NYY") %>% print(width = Inf)
```

```
## # A tibble: 3 x 21
##     row  game date             box      team 
##   <int> <int> <chr>            <chr>    <chr>
## 1    92    27 Monday, May 4    boxscore TOR  
## 2    93    28 Tuesday, May 5   boxscore TOR  
## 3    94    29 Wednesday, May 6 boxscore TOR  
##   venue opp   result  runs Oppruns innings
##   <chr> <chr> <chr>  <int>   <int>   <int>
## 1 <NA>  NYY   W          3       1      NA
## 2 <NA>  NYY   L          3       6      NA
## 3 <NA>  NYY   W          5       1      NA
##   wl    position gb    winner  loser   
##   <chr>    <int> <chr> <chr>   <chr>   
## 1 13-14        4 3.5   Dickey  Martin  
## 2 13-15        5 4.5   Pineda  Estrada 
## 3 14-15        3 3.5   Buehrle Sabathia
##   save   `game time` Daynight attendance
##   <chr>  <time>      <chr>         <int>
## 1 Cecil  02:18       N             19217
## 2 Miller 02:54       N             21519
## 3 <NA>   02:30       N             21312
##   streak
##   <chr> 
## 1 +     
## 2 -     
## 3 +
```

 

but you will probably need to click the little right-arrow at the top
to see more columns. 

What I notice is that these games are all on consecutive nights
(against the same team). This is quite common, and goes back to the
far-off days when teams travelled by train: teams play several games
on one visit, rather than coming back many times.
\marginnote{Hockey is  similar: teams go on road trips, playing several different teams  before returning home. Hockey teams, though, tend to play each team  only once on a road trip: for example, a west coast team like the  Canucks might play a game in each of Toronto, Montreal, Boston and  New York on a road trip. Well, maybe three games in the New York  area: one each against the Rangers, Islanders and Devils.} 
You might have noticed something else;
that's fine for this. For example, 
"each of the games lasted less than three hours", 
or "the attendances were all small" (since we
looked at all the attendances in class). I just want you to notice
something meaningful that seems to be interesting about these games.

You could also print all the columns in two or more goes, using
`select`, for example:


```r
jays %>% filter(opp == "NYY") %>% select(row:innings) %>% 
    print(width = Inf)
```

```
## # A tibble: 3 x 11
##     row  game date             box      team 
##   <int> <int> <chr>            <chr>    <chr>
## 1    92    27 Monday, May 4    boxscore TOR  
## 2    93    28 Tuesday, May 5   boxscore TOR  
## 3    94    29 Wednesday, May 6 boxscore TOR  
##   venue opp   result  runs Oppruns innings
##   <chr> <chr> <chr>  <int>   <int>   <int>
## 1 <NA>  NYY   W          3       1      NA
## 2 <NA>  NYY   L          3       6      NA
## 3 <NA>  NYY   W          5       1      NA
```

```r
jays %>% filter(opp == "NYY") %>% select(wl:streak) %>% 
    print(width = Inf)
```

```
## # A tibble: 3 x 10
##   wl    position gb    winner  loser   
##   <chr>    <int> <chr> <chr>   <chr>   
## 1 13-14        4 3.5   Dickey  Martin  
## 2 13-15        5 4.5   Pineda  Estrada 
## 3 14-15        3 3.5   Buehrle Sabathia
##   save   `game time` Daynight attendance
##   <chr>  <time>      <chr>         <int>
## 1 Cecil  02:18       N             19217
## 2 Miller 02:54       N             21519
## 3 <NA>   02:30       N             21312
##   streak
##   <chr> 
## 1 +     
## 2 -     
## 3 +
```

 




(c) From the whole data frame, pick out only the games where the
attendance was more than 30,000, showing only the columns
`attendance` and `Daynight`. How many of them are there
(just count them)? How many are day games and how many night games
(just count those too)?



Solution



Two steps, since we selecting rows *and* columns. 


```r
jays %>% filter(attendance > 30000) %>% select(c(attendance, 
    Daynight))
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

 

Or this way, since we are selecting
*consecutive* columns:


```r
jays %>% filter(attendance > 30000) %>% select(c(Daynight:attendance))
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
jays %>% filter(attendance > 30000) %>% count(Daynight)
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
jays %>% group_by(Daynight) %>% summarize(mean.att = mean(attendance), 
    sd.att = sd(attendance))
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
jays %>% group_by(Daynight) %>% summarize(median.att = median(attendance), 
    iqr.att = IQR(attendance))
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
ggplot(jays, aes(x = Daynight, y = attendance)) + 
    geom_boxplot()
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-11-1} 

 

So when you take away those unusual values, the night game attendances
are indeed less variable.

The right test, as you might have guessed, for comparing the medians
of these non-normal data, is Mood's median test:


```r
library(smmr)
median_test(jays, attendance, Daynight)
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
attendances at day and night games.
\marginnote{If you do this by  hand, you'll get a warning about the chi-squared approximation  being inaccurate. This is because of the small frequencies, and  *not* because of the outliers. Those are not damaging the test  at all.}



(e) Make normal quantile plots of the day attendances and the night
attendances, separately. Do you see any evidence of non-normality?
(You would expect to on the night attendances because of the big
opening-night value.)



Solution


The best way to do this is facetted normal quantile
plots. Remember that the facetting part goes right at the end:

```r
ggplot(jays, aes(sample = attendance)) + stat_qq() + 
    stat_qq_line() + facet_wrap(~Daynight, ncol = 1)
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-13-1} 

     
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







##  Baseball and softball spaghetti


 On a previous assignment, we found that students could throw
a baseball further than they could throw a softball. In this question,
we will make a graph called a "spaghetti plot" to illustrate this
graphically. (The issue previously was that the data were matched
pairs: the same students threw both balls.)

This seems to work most naturally by building a pipe, a line or two at
a time. See if you can do it that way. (If you can't, use lots of
temporary data frames, one to hold the result of each part.)



(a) Read in the data again from
[link](http://www.utsc.utoronto.ca/~butler/c32/throw.txt). The
variables had no names, so supply some, as you did before.


Solution


Literal copy and paste: 

```r
myurl = "http://www.utsc.utoronto.ca/~butler/c32/throw.txt"
throws = read_delim(myurl, " ", col_names = c("student", 
    "baseball", "softball"))
```

```
## Parsed with column specification:
## cols(
##   student = col_integer(),
##   baseball = col_integer(),
##   softball = col_integer()
## )
```

```r
throws
```

```
## # A tibble: 24 x 3
##    student baseball softball
##      <int>    <int>    <int>
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

       



(b) Create a new column that is the students turned into a
`factor`, adding it to your data frame.


Solution


Feed `student` into `factor`, creating a new
column with `mutate`:

```r
throws %>% mutate(fs = factor(student))
```

```
## # A tibble: 24 x 4
##    student baseball softball fs   
##      <int>    <int>    <int> <fct>
##  1       1       65       57 1    
##  2       2       90       58 2    
##  3       3       75       66 3    
##  4       4       73       61 4    
##  5       5       79       65 5    
##  6       6       68       56 6    
##  7       7       58       53 7    
##  8       8       41       41 8    
##  9       9       56       44 9    
## 10      10       70       65 10   
## # ... with 14 more rows
```

       

This doesn't look any different from the original student numbers, but
note the variable type at the top of the column.



(c) Gather together all the throwing distances into one column,
making a second column that says which ball was thrown.


Solution


Literally `gather` (from `tidyr`):

```r
throws %>% mutate(fs = factor(student)) %>% gather(ball, 
    distance, baseball:softball)
```

```
## # A tibble: 48 x 4
##    student fs    ball     distance
##      <int> <fct> <chr>       <int>
##  1       1 1     baseball       65
##  2       2 2     baseball       90
##  3       3 3     baseball       75
##  4       4 4     baseball       73
##  5       5 5     baseball       79
##  6       6 6     baseball       68
##  7       7 7     baseball       58
##  8       8 8     baseball       41
##  9       9 9     baseball       56
## 10      10 10    baseball       70
## # ... with 38 more rows
```

       

Two columns to include, consecutive ones, or two to omit, the first
and last. So I think it's
easier to name the ones you want to include. 

If you want to show off a little, you can use a select-helper, noting
that the columns you want to gather up all end in "ball":


```r
throws %>% mutate(fs = factor(student)) %>% gather(ball, 
    distance, ends_with("ball"))
```

```
## # A tibble: 48 x 4
##    student fs    ball     distance
##      <int> <fct> <chr>       <int>
##  1       1 1     baseball       65
##  2       2 2     baseball       90
##  3       3 3     baseball       75
##  4       4 4     baseball       73
##  5       5 5     baseball       79
##  6       6 6     baseball       68
##  7       7 7     baseball       58
##  8       8 8     baseball       41
##  9       9 9     baseball       56
## 10      10 10    baseball       70
## # ... with 38 more rows
```

       

with the same result. Use whichever you like.



(d) Using your new data frame, make a "scatterplot" of throwing
distance against type of ball.


Solution


The obvious thing:

```r
throws %>% mutate(fs = factor(student)) %>% gather(ball, 
    distance, baseball:softball) %>% ggplot(aes(x = ball, 
    y = distance)) + geom_point()
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-18-1} 

       

What this plot is missing is an indication of which student threw
which ball. As it stands now, it could be an inferior version of a
boxplot of distances thrown for each ball (which would imply that they
are two independent sets of students, something that is not true).



(e) Add two things to your plot: something that will distinguish
the students by colour (this works best if the thing distinguished
by colour is a factor),
\marginnote{You can try it without. See below.}
and something that will join the two points for the same student by
a line.


Solution


A `colour` and a `group` in the `aes`, and
a `geom_line`:

```r
throws %>% mutate(fs = factor(student)) %>% gather(ball, 
    distance, baseball:softball) %>% ggplot(aes(x = ball, 
    y = distance, group = fs, colour = fs)) + 
    geom_point() + geom_line()
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-19-1} 

     

You can see what happens if you use the student as a number:


```r
throws %>% mutate(fs = factor(student)) %>% gather(ball, 
    distance, baseball:softball) %>% ggplot(aes(x = ball, 
    y = distance, group = student, colour = student)) + 
    geom_point() + geom_line()
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-20-1} 

     

Now the student numbers are distinguished as a shade of blue (on an
implied continuous scale: even a nonsensical fractional student number
like 17.5 would be a shade of blue). This is not actually so bad here,
because all we are trying to do is to distinguish the students
sufficiently from each other so that we can see where the spaghetti
strands go. But I like the multi-coloured one better.



(f) The legend is not very informative. Remove it from the plot,
using `guides`.


Solution


You won't have seen this before. Here's what to do: Find what's
at the top of the legend that you want to remove. Here that is
`fs`. Find where `fs` appears in your
`aes`. It actually appears in two places: in
`group` and `colour`. I think the legend we want
to get rid of is actually the `colour` one, so we do this:

```r
throws %>% mutate(fs = factor(student)) %>% gather(ball, 
    distance, baseball:softball) %>% ggplot(aes(x = ball, 
    y = distance, group = fs, colour = fs)) + 
    geom_point() + geom_line() + guides(colour = F)
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-21-1} 

       

That seems to have done it.



(g) What do you see on the final spaghetti plot? What does that tell you
about the relative distances a student can throw a baseball vs.\ a
softball? Explain briefly, blah blah blah.


Solution


Most of the spaghetti strands go downhill from baseball to
softball, or at least very few of them go uphill. That tells us
that most students can throw a baseball further than a softball.
That was the same impression that the matched-pairs $t$-test
gave us. But the spaghetti plot tells us something else. If you
look carefully, you see that most of the big drops are for
students who could throw a baseball a long way. These students
also threw a softball further than the other students, but not
by as much. Most of the spaghetti strands in the bottom half of
the plot go more or less straight across. This indicates that
students who cannot throw a baseball very far will throw a
softball about the same distance as they threw the baseball.
There is an argument you could make here that the difference
between distances thrown is a *proportional* one, something
like "a student typically throws a baseball 20\% further than a softball". 
That could be assessed by comparing not the
distances themselves, but the logs of the distances: in other
words, making a log transformation of all the
distances. (Distances have a lower limit of zero, so you might
expect observed distances to be skewed to the right, which is
another argument for making some kind of transformation.)






##  Ethanol and sleep time in rats


 A biologist wished to study the effects of ethanol on sleep
time in rats. A sample of 20 rats (all the same age) was selected, and
each rat was given an injection having a particular concentration (0,
1, 2 or 4 grams per kilogram of body weight) of ethanol. These are
labelled `e0, e1, e2, e4`. The "0"
treatment was a control group. The rapid eye movement (REM) sleep time
was then recorded for each rat. The data are in
[link](http://www.utsc.utoronto.ca/~butler/c32/ratsleep.txt). 



(a) Read the data in from the file. Check that you have four rows
of observations  and five columns of sleep times.


Solution


Separated by single spaces:

```r
sleep1 = read_delim("ratsleep.txt", " ")
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
[link](http://www.utsc.utoronto.ca/~butler/c32/ratsleep2.txt), and
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
(sleep <- sleep1 %>% gather(rep, sleeptime, obs1:obs5))
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
observation each one was within its group.
\marginnote{Sometimes the  column playing the role of *rep* *is* interesting to us, but  not here.} 
The interesting things are `treatment` and
`sleeptime`, which are the two variables we'll need for our
analysis of variance.




(c) Using your new data frame, make side-by-side boxplots of sleep
time by treatment group. 



Solution



```r
ggplot(sleep, aes(x = treatment, y = sleeptime)) + 
    geom_boxplot()
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-24-1} 

 




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
sleep %>% group_by(treatment) %>% summarize(stddev = sd(sleeptime))
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
sleep.1 = aov(sleeptime ~ treatment, data = sleep)
summary(sleep.1)
```

```
##             Df Sum Sq Mean Sq F value
## treatment    3   5882    1961   21.09
## Residuals   16   1487      93        
##               Pr(>F)    
## treatment   8.32e-06 ***
## Residuals               
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
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
[link](http://www.utsc.utoronto.ca/~butler/c32/tomatoes.txt). 



(a) Read the data into R and confirm that you have 8 rows and 5
columns of data.


Solution


This kind of thing:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/tomatoes.txt"
toms1 = read_delim(my_url, " ")
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
toms2 = toms1 %>% gather(colour, growthrate, blue:green)
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
repeated as necessary, so now it denotes "plant within colour group", 
which in this case is not very useful. (Where you have
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
write_csv(toms2, "tomatoes2.csv")
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
ggplot(toms2, aes(x = colour, y = growthrate)) + 
    geom_boxplot()
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-32-1} 

     

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
with(toms2, leveneTest(growthrate, colour))
```

```
## Warning in leveneTest.default(growthrate,
## colour): colour coerced to factor.
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
a different story.) Decide for yourself whether you're surprised by this.

With that in mind, I think the regular ANOVA will be perfectly good,
and we would expect that and the Welch ANOVA to give very similar results.

I don't need `car` again, so let's get rid of it:


```r
detach("package:car", unload = T)
```

 



(e) Run (regular) ANOVA on these data. What do you conclude?
(Optional extra: if you think that some other variant of ANOVA would
be better, run that as well and compare the results.)


Solution


`aov`, bearing in mind that Tukey is likely to follow:


```r
toms.1 = aov(growthrate ~ colour, data = toms2)
summary(toms.1)
```

```
##             Df Sum Sq Mean Sq F value
## colour       3  410.5  136.82   118.2
## Residuals   28   32.4    1.16        
##               Pr(>F)    
## colour      5.28e-16 ***
## Residuals               
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

This is a tiny P-value, so the mean growth rate for the different
colours is definitely *not* the same for all colours. Or, if you
like, one or more of the colours has a different mean growth rate than
the others.

This, remember, is as far as we go right now.

Extra: if you thought that normality was OK but not equal spreads,
then Welch ANOVA is the way to go:


```r
toms.2 = oneway.test(growthrate ~ colour, data = toms2)
toms.2
```

```
## 
## 	One-way analysis of means (not
## 	assuming equal variances)
## 
## data:  growthrate and colour
## F = 81.079, num df = 3.000, denom df =
## 15.227, p-value = 1.377e-09
```

 

The P-value is not *quite* as small as for the regular ANOVA, but
it is still very small, and the conclusion is the same.

If you had doubts about the normality (that were sufficiently great,
even given the small sample sizes), then go with Mood's median test
for multiple groups:


```r
library(smmr)
median_test(toms2, growthrate, colour)
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



(f) If warranted, run a suitable follow-up. (If not warranted, explain briefly
why not.)


Solution


Whichever flavour of ANOVA you ran (regular ANOVA, Welch ANOVA,
Mood's median test), you got the same conclusion for these data:
that the average growth rates were not all the same for the four
colours. That, as you'll remember, is as far as you go. To find
out which colours differ from which in terms of growth rate, you
need to run some kind of multiple-comparisons follow-up, the
right one for the analysis you did. Looking at the boxplots suggests that red is clearly best
and green clearly worst, and it is possible that all the colours
are significantly different from each other.)
If you did regular ANOVA, Tukey is what you need:

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
##                 diff       lwr        upr
## green-blue   -3.8125 -5.281129 -2.3438706
## red-blue      6.0150  4.546371  7.4836294
## yellow-blue  -0.9825 -2.451129  0.4861294
## red-green     9.8275  8.358871 11.2961294
## yellow-green  2.8300  1.361371  4.2986294
## yellow-red   -6.9975 -8.466129 -5.5288706
##                  p adj
## green-blue   0.0000006
## red-blue     0.0000000
## yellow-blue  0.2825002
## red-green    0.0000000
## yellow-green 0.0000766
## yellow-red   0.0000000
```

       

All of the differences are (strongly) significant, except for yellow
and blue, the two with middling growth rates on the boxplot. Thus we
would have no hesitation in saying that growth rate is biggest in red
light and smallest in green light.

If you did Welch ANOVA, you need Games-Howell, which you have to get
from one of the packages that offers it:


```r
library(PMCMRplus)
gamesHowellTest(growthrate ~ factor(colour), data = toms2)
```

```
## 
## 	Pairwise comparisons using Games-Howell test
```

```
## data: growthrate by factor(colour)
```

```
##        blue    green   red    
## green  1.6e-05 -       -      
## red    1.5e-06 4.8e-09 -      
## yellow 0.18707 0.00011 5.8e-07
```

```
## 
## P value adjustment method: none
```

```
## alternative hypothesis: two.sided
```

 

The conclusions are the same as for the Tukey: all the means are
significantly different except for yellow and blue.
Finally, if you did Mood's median test, you need this one:


```r
pairwise_median_test(toms2, growthrate, colour)
```

```
## # A tibble: 6 x 4
##   g1    g2       p_value adj_p_value
##   <chr> <chr>      <dbl>       <dbl>
## 1 blue  green  0.0000633    0.000380
## 2 blue  red    0.0000633    0.000380
## 3 blue  yellow 0.317        1.90    
## 4 green red    0.0000633    0.000380
## 5 green yellow 0.0000633    0.000380
## 6 red   yellow 0.0000633    0.000380
```

 

Same conclusions again. This is what I would have guessed; the
conclusions from Tukey were so clear-cut that it really didn't matter
which way you went; you'd come to the same conclusion.

That said, what I am looking for from you is a sensible choice of
analysis of variance (ANOVA, Welch's ANOVA or Mood's median test) for
a good reason, followed by the *right* follow-up for the test you
did. Even though the conclusions are all the same no matter what you
do here, I want you to get
used to following the right method, so that you will be able to do the
right thing when it *does* matter.






##  Pain relief in migraine headaches (again)


 The data in
[link](http://www.utsc.utoronto.ca/~butler/c32/migraine.txt) are from a
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


The key is two things: the data values are *lined up in        columns*, and 
*there is more than one space between  values*. 
The second thing is why `read_delim` will not
work. If you look carefully at the data file, you'll see that
the column names are above and aligned with the columns, which
is what `read_table` wants. If the column names had
*not* been aligned with the columns, we would have needed
`read_table2`. 

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/migraine.txt"
migraine = read_table(my_url)
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
of analysis.
\marginnote{To allow for the fact that measurements on the same      subject are not independent but correlated.} 



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
(migraine2 <- migraine %>% gather(drug, painrelief, 
    DrugA:DrugC))
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
painrelief.1 = aov(painrelief ~ drug, data = migraine2)
summary(painrelief.1)
```

```
##             Df Sum Sq Mean Sq F value
## drug         2  41.19   20.59   7.831
## Residuals   24  63.11    2.63        
##              Pr(>F)   
## drug        0.00241 **
## Residuals             
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
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
##                   diff        lwr      upr
## DrugB-DrugA  2.8888889  0.9798731 4.797905
## DrugC-DrugA  2.2222222  0.3132065 4.131238
## DrugC-DrugB -0.6666667 -2.5756824 1.242349
##                 p adj
## DrugB-DrugA 0.0025509
## DrugC-DrugA 0.0203671
## DrugC-DrugB 0.6626647
```

 

Both the differences involving drug A are significant, and because a
high value of `painrelief` is better, in both cases drug A is
*worse* than the other drugs. Drugs B and C are not significantly
different from each other.

Extra: we can also use the "pipe" to do this all in one go:


```r
migraine %>% gather(drug, painrelief, DrugA:DrugC) %>% 
    aov(painrelief ~ drug, data = .) %>% summary()
```

```
##             Df Sum Sq Mean Sq F value
## drug         2  41.19   20.59   7.831
## Residuals   24  63.11    2.63        
##              Pr(>F)   
## drug        0.00241 **
## Residuals             
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

with the same results as before. Notice that I never actually created
a second data frame by name; it was created by `gather` and
then immediately used as input to `aov`.
\marginnote{And then thrown away.} 
I also used the
`data=.` trick to use "the data frame that came out of the previous step" as my input to `aov`.

Read the above like this: "take `migraine`, and then gather together the `DrugA` through `DrugC` columns into a column `painrelief`, labelling each by its drug, and then do an ANOVA of `painrelief` by `drug`, and then summarize the results."

What is even more alarming is that I can feed the output from
`aov` straight into `TukeyHSD`:


```r
migraine %>% gather(drug, painrelief, DrugA:DrugC) %>% 
    aov(painrelief ~ drug, data = .) %>% TukeyHSD()
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = painrelief ~ drug, data = .)
## 
## $drug
##                   diff        lwr      upr
## DrugB-DrugA  2.8888889  0.9798731 4.797905
## DrugC-DrugA  2.2222222  0.3132065 4.131238
## DrugC-DrugB -0.6666667 -2.5756824 1.242349
##                 p adj
## DrugB-DrugA 0.0025509
## DrugC-DrugA 0.0203671
## DrugC-DrugB 0.6626647
```

 

I wasn't sure whether this would work, since the output from
`aov` is an R `list` rather than a data frame, but the
output from `aov` is sent into `TukeyHSD` whatever
kind of thing it is.

What I am missing here is to display the result of `aov`
*and* use it as input to `TukeyHSD`. Of course, I had to
discover that this could be solved, and indeed it can:


```r
migraine %>% gather(drug, painrelief, DrugA:DrugC) %>% 
    aov(painrelief ~ drug, data = .) %>% {
    print(summary(.))
    .
} %>% TukeyHSD()
```

```
##             Df Sum Sq Mean Sq F value
## drug         2  41.19   20.59   7.831
## Residuals   24  63.11    2.63        
##              Pr(>F)   
## drug        0.00241 **
## Residuals             
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

```
##   Tukey multiple comparisons of means
##     95% family-wise confidence level
## 
## Fit: aov(formula = painrelief ~ drug, data = .)
## 
## $drug
##                   diff        lwr      upr
## DrugB-DrugA  2.8888889  0.9798731 4.797905
## DrugC-DrugA  2.2222222  0.3132065 4.131238
## DrugC-DrugB -0.6666667 -2.5756824 1.242349
##                 p adj
## DrugB-DrugA 0.0025509
## DrugC-DrugA 0.0203671
## DrugC-DrugB 0.6626647
```

 

The odd-looking second-last line of that uses that `.` trick
for "whatever came out of the previous step". The thing inside the
curly brackets is two commands one after the other; the first is to
display the `summary` of that `aov`
\marginnote{It needs  *print* around it to display it, as you need *print*  to display something within a loop or a function.} 
and the second
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
migraine2 %>% group_by(drug) %>% summarize(m = mean(painrelief))
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
\marginnote{This talks about *means* rather  than individual observations; in individual cases, sometimes even  drug *A* will come out best. But we're interested in  population means, since we want to do the greatest good for the  greatest number. *Greatest good for the greatest number*  is from Jeremy Bentham, 1748--1832, British    philosopher and advocate of utilitarianism.}
Another way is to draw a boxplot of pain-relief scores:


```r
ggplot(migraine2, aes(x = drug, y = painrelief)) + 
    geom_boxplot()
```


\includegraphics{11-tidying-and-selecting-data_files/figure-latex/unnamed-chunk-49-1} 

 

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
median_test(migraine2, painrelief, drug)
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
drugs, and then use Bonferroni to allow for your having done three tests:


```r
pairwise_median_test(migraine2, painrelief, drug)
```

```
## # A tibble: 3 x 4
##   g1    g2     p_value adj_p_value
##   <chr> <chr>    <dbl>       <dbl>
## 1 DrugA DrugB 0.00721     0.0216  
## 2 DrugA DrugC 0.000183    0.000548
## 3 DrugB DrugC 0.921       2.76
```

 

Drug A gives worse pain relief (fewer hours) than both drugs B and C,
which are not significantly different from each hour. This is exactly
what you would have guessed from the boxplot.

I gotta do something about those adjusted P-values bigger than 1!






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
[link](http://www.utsc.utoronto.ca/~butler/c32/disease.txt). In that
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
my_url = "http://www.utsc.utoronto.ca/~butler/c32/disease.txt"
tbl = read_table(my_url)
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



(b)??part:nottidy?? Explain briefly how these data are not "tidy".


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
`Species` contain frequencies, so that's what's "the same". 
They are frequencies in disease-location combinations, so
I'll call the column of "what's different" `disloc`. Feel
free to call it `temp` for now if you prefer:

```r
(tbl.2 <- tbl %>% gather(disloc, frequency, px:ay))
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
(tbl.2 <- tbl %>% gather(disloc, frequency, -Species))
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
(??part:nottidy??) we found *three* variables, so there
ought to be three non-frequency columns.



(e) Use one more `tidyr` tool to make these data tidy,
and show your result.


Solution


This means splitting up `disloc` into two separate columns,
splitting after the first character, thus:

```r
(tbl.3 <- tbl.2 %>% separate(disloc, c("disease", 
    "location"), 1))
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
columns. (Go back and look at your answer to part (??part:nottidy??)
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
tbl.4 = xtabs(frequency ~ Species + disease + 
    location, data = tbl.3)
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
appropriate modelling with frequencies is called "log-linear modelling", 
and it assumes that the log of the frequencies has a
linear relationship with the effects of the other variables. This is
not quite as simple as the log transformations we had before, because
bigger frequencies are going to be more variable, so we fit a
generalized linear model with a Poisson-distributed response and log
link. (It's better if you know what that means, but you ought to be
able to follow the logic if you don't.)

First, fit a model predicting frequency from everything, including all
the interactions. (The reason for doing it this way will become clear later):


```r
model.1 = glm(frequency ~ Species * location * 
    disease, data = tbl.3, family = "poisson")
drop1(model.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species * location * disease
##                          Df Deviance    AIC
## <none>                      0.000000 55.291
## Species:location:disease  1 0.070257 53.362
##                               LRT Pr(>Chi)
## <none>                                    
## Species:location:disease 0.070257    0.791
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
model.2 = update(model.1, . ~ . - Species:location:disease)
drop1(model.2, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + disease + Species:location + 
##     Species:disease + location:disease
##                  Df Deviance    AIC     LRT
## <none>                0.0703 53.362        
## Species:location  1  13.0627 64.354 12.9924
## Species:disease   1   0.2696 51.561  0.1993
## location:disease  1   0.1043 51.396  0.0340
##                   Pr(>Chi)    
## <none>                        
## Species:location 0.0003128 ***
## Species:disease  0.6552865    
## location:disease 0.8536877    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

Notice how `update` saved us having to write the whole model
out again.

Now the three two-way interactions are up for grabs:
`Species:location`, `Species:disease` and
`location:disease`. The last of these is the least significant,
so out it comes. I did some copying and pasting, but I had to remember
which model I was working with and what I was removing:


```r
model.3 = update(model.2, . ~ . - location:disease)
drop1(model.3, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + disease + Species:location + 
##     Species:disease
##                  Df Deviance    AIC     LRT
## <none>                0.1043 51.396        
## Species:location  1  13.0678 62.359 12.9635
## Species:disease   1   0.2746 49.566  0.1703
##                   Pr(>Chi)    
## <none>                        
## Species:location 0.0003176 ***
## Species:disease  0.6798021    
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

`Species:disease` comes out, but it looks as if
`Species:location` will have to stay:


```r
model.4 = update(model.3, . ~ . - Species:disease)
drop1(model.4, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + disease + Species:location
##                  Df Deviance    AIC     LRT
## <none>                0.2746 49.566        
## disease           1   2.3617 49.653  2.0871
## Species:location  1  13.2381 60.530 12.9635
##                   Pr(>Chi)    
## <none>                        
## disease          0.1485461    
## Species:location 0.0003176 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

`Species:location` indeed stays. That means that anything
"contained in" it also has to stay, regardless of its main
effect. So the only candidate for removal now is `disease`: not
significant, out it comes:


```r
model.5 = update(model.4, . ~ . - disease)
drop1(model.5, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ Species + location + Species:location
##                  Df Deviance    AIC    LRT
## <none>                2.3617 49.653       
## Species:location  1  15.3252 60.617 12.963
##                   Pr(>Chi)    
## <none>                        
## Species:location 0.0003176 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

And now we have to stop.

What does this final model mean? Well, frequency depends significantly
on the `Species:location` combination, but not on anything
else. To see how, we make a contingency table of species by location
(totalling up over disease status, since that is not significant):


```r
xtabs(frequency ~ Species + location, data = tbl.3)
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
disease = c("a", "a", "p", "p")
Species = c("A", "B", "A", "B")
frequency = c(10, 50, 30, 30)
xx = data.frame(disease, Species, frequency)
xtabs(frequency ~ disease + Species)
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
xx.1 = glm(frequency ~ disease * Species, data = xx, 
    family = "poisson")
drop1(xx.1, test = "Chisq")
```

```
## Single term deletions
## 
## Model:
## frequency ~ disease * Species
##                 Df Deviance    AIC    LRT
## <none>                0.000 28.400       
## disease:Species  1   15.518 41.918 15.518
##                  Pr(>Chi)    
## <none>                       
## disease:Species 8.171e-05 ***
## ---
## Signif. codes:  
##   0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1  ' ' 1
```

 

And so there is. Nothing can come out of the model. (This is the same
kind of test as a chi-squared test for association, if you know about
that.  The log-linear model is a multi-variable generalization of that.)






##  Cars


 My cars data file can be found at
[link](http://www.utsc.utoronto.ca/~butler/c32/cars.csv). 
The values in
the data file are separated by commas; the car names are up to 29
characters long.  Display your results for each part after (a). In R,
displaying a `tibble` normally shows its first ten lines, which
is all you need here; there's no need to display all the lines.


(a) Read the data into R and list the values.


Solution


`read_csv` will do it:

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/cars.csv"
cars = read_csv(my_url)
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
##    car    MPG weight cylinders    hp country
##    <ch> <dbl>  <dbl>     <int> <int> <chr>  
##  1 Bui~  28.4   2.67         4    90 U.S.   
##  2 Dod~  30.9   2.23         4    75 U.S.   
##  3 Mer~  20.8   3.07         6    85 U.S.   
##  4 Fia~  37.3   2.13         4    69 Italy  
##  5 Peu~  16.2   3.41         6   133 France 
##  6 VW ~  31.9   1.92         4    71 Germany
##  7 Ply~  34.2   2.2          4    70 U.S.   
##  8 Maz~  34.1   1.98         4    65 Japan  
##  9 Bui~  16.9   4.36         8   155 U.S.   
## 10 Aud~  20.3   2.83         5   103 Germany
## # ... with 28 more rows
```

 
      


(b) Display only the car names and the countries they come from.


Solution




```r
cars %>% select(car, country)
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
##    car          MPG weight cylinders country
##    <chr>      <dbl>  <dbl>     <int> <chr>  
##  1 Buick Sky~  28.4   2.67         4 U.S.   
##  2 Dodge Omni  30.9   2.23         4 U.S.   
##  3 Mercury Z~  20.8   3.07         6 U.S.   
##  4 Fiat Stra~  37.3   2.13         4 Italy  
##  5 Peugeot 6~  16.2   3.41         6 France 
##  6 VW Rabbit   31.9   1.92         4 Germany
##  7 Plymouth ~  34.2   2.2          4 U.S.   
##  8 Mazda GLC   34.1   1.98         4 Japan  
##  9 Buick Est~  16.9   4.36         8 U.S.   
## 10 Audi 5000   20.3   2.83         5 Germany
## # ... with 28 more rows
```

 
      


(d) Display only the cars that have 8-cylinder engines (but
display all the variables for those cars).


Solution


This:

```r
cars %>% filter(cylinders == 8)
```

```
## # A tibble: 8 x 6
##   car     MPG weight cylinders    hp country
##   <chr> <dbl>  <dbl>     <int> <int> <chr>  
## 1 Buic~  16.9   4.36         8   155 U.S.   
## 2 Chev~  19.2   3.60         8   125 U.S.   
## 3 Chry~  18.5   3.94         8   150 U.S.   
## 4 Ford~  17.6   3.72         8   129 U.S.   
## 5 Dodg~  18.2   3.83         8   135 U.S.   
## 6 Ford~  15.5   4.05         8   142 U.S.   
## 7 Merc~  16.5   3.96         8   138 U.S.   
## 8 Chev~  17     3.84         8   130 U.S.
```

 
8 of them, all from the US.
      


(e) Display the cylinders and horsepower for the cars that have
horsepower 70 or less.


Solution


This one is selecting some observations and some variables:

```r
cars %>% filter(hp <= 70) %>% select(cylinders:hp)
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
cars %>% filter(cylinders == 4) %>% summarize(m = mean(MPG), 
    s = sd(MPG))
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
cars %>% group_by(cylinders) %>% summarize(m = mean(MPG), 
    s = sd(MPG))
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
cars %>% group_by(cylinders) %>% summarize(m = mean(MPG), 
    s = sd(MPG)) %>% filter(cylinders == 4)
```

```
## # A tibble: 1 x 3
##   cylinders     m     s
##       <int> <dbl> <dbl>
## 1         4  30.0  4.18
```

 

to pick out just the right row.
This is a very easy kind of question to set on an exam. Just so you know.
      





## Number 1 songs



 The data file
[link](http://stat405.had.co.nz/data/billboard.csv) contains a lot of
information about songs popular in 2000. This dataset is untidy.  Our
ultimate aim is to answer "which song occupied the \#1 position for the largest number of weeks?". To do that, we will build a pipe that
starts from the data frame read in from the URL above, and finishes
with an answer to the question. I will take you through this step by
step. Each part will involve adding something to the pipe you built
previously (possibly after removing a line or two that you used to
display the previous result).



(a) Read the data and display what you have.


Solution



```r
billboard = read_csv("http://stat405.had.co.nz/data/billboard.csv")
```

```
## Parsed with column specification:
## cols(
##   .default = col_integer(),
##   artist.inverted = col_character(),
##   track = col_character(),
##   time = col_time(format = ""),
##   genre = col_character(),
##   date.entered = col_date(format = ""),
##   date.peaked = col_date(format = ""),
##   x66th.week = col_character(),
##   x67th.week = col_character(),
##   x68th.week = col_character(),
##   x69th.week = col_character(),
##   x70th.week = col_character(),
##   x71st.week = col_character(),
##   x72nd.week = col_character(),
##   x73rd.week = col_character(),
##   x74th.week = col_character(),
##   x75th.week = col_character(),
##   x76th.week = col_character()
## )
```

```
## See spec(...) for full column specifications.
```

       

There are a *lot* of columns. What does this look like?


```r
billboard
```

```
## # A tibble: 317 x 83
##     year artist.inverted track time  genre
##    <int> <chr>           <chr> <tim> <chr>
##  1  2000 Destiny's Child Inde~ 03:38 Rock 
##  2  2000 Santana         Mari~ 04:18 Rock 
##  3  2000 Savage Garden   I Kn~ 04:07 Rock 
##  4  2000 Madonna         Music 03:45 Rock 
##  5  2000 Aguilera, Chri~ Come~ 03:38 Rock 
##  6  2000 Janet           Does~ 04:17 Rock 
##  7  2000 Destiny's Child Say ~ 04:31 Rock 
##  8  2000 Iglesias, Enri~ Be W~ 03:36 Latin
##  9  2000 Sisqo           Inco~ 03:52 Rock 
## 10  2000 Lonestar        Amaz~ 04:25 Coun~
## # ... with 307 more rows, and 78 more
## #   variables: date.entered <date>,
## #   date.peaked <date>, x1st.week <int>,
## #   x2nd.week <int>, x3rd.week <int>,
## #   x4th.week <int>, x5th.week <int>,
## #   x6th.week <int>, x7th.week <int>,
## #   x8th.week <int>, x9th.week <int>,
## #   x10th.week <int>, x11th.week <int>,
## #   x12th.week <int>, x13th.week <int>,
## #   x14th.week <int>, x15th.week <int>,
## #   x16th.week <int>, x17th.week <int>,
## #   x18th.week <int>, x19th.week <int>,
## #   x20th.week <int>, x21st.week <int>,
## #   x22nd.week <int>, x23rd.week <int>,
## #   x24th.week <int>, x25th.week <int>,
## #   x26th.week <int>, x27th.week <int>,
## #   x28th.week <int>, x29th.week <int>,
## #   x30th.week <int>, x31st.week <int>,
## #   x32nd.week <int>, x33rd.week <int>,
## #   x34th.week <int>, x35th.week <int>,
## #   x36th.week <int>, x37th.week <int>,
## #   x38th.week <int>, x39th.week <int>,
## #   x40th.week <int>, x41st.week <int>,
## #   x42nd.week <int>, x43rd.week <int>,
## #   x44th.week <int>, x45th.week <int>,
## #   x46th.week <int>, x47th.week <int>,
## #   x48th.week <int>, x49th.week <int>,
## #   x50th.week <int>, x51st.week <int>,
## #   x52nd.week <int>, x53rd.week <int>,
## #   x54th.week <int>, x55th.week <int>,
## #   x56th.week <int>, x57th.week <int>,
## #   x58th.week <int>, x59th.week <int>,
## #   x60th.week <int>, x61st.week <int>,
## #   x62nd.week <int>, x63rd.week <int>,
## #   x64th.week <int>, x65th.week <int>,
## #   x66th.week <chr>, x67th.week <chr>,
## #   x68th.week <chr>, x69th.week <chr>,
## #   x70th.week <chr>, x71st.week <chr>,
## #   x72nd.week <chr>, x73rd.week <chr>,
## #   x74th.week <chr>, x75th.week <chr>,
## #   x76th.week <chr>
```

 

On yours, you will definitely see a little arrow top right saying
"there are more columns", and you will have to click on it several
times to see them all.

 

(b) The columns `x1st.week` through
`x76th.week` contain the rank of each song in the Billboard
chart in that week, with week 1 being the first week that the song
appeared in the chart.  Convert all these columns into two: an
indication of week, called `week`, and of rank, called
`rank`. Most songs appeared in the Billboard chart for a
lot less than 76 weeks, so there are missing values, which you
want to remove.  (I say "indication of week" since this will
probably be text at the moment). Display your new data frame. Do
you have fewer columns?  Why do you have a lot more rows? Explain
briefly.


Solution


This is `gather`ing up all those columns, with
`na.rm=T` to get rid of the missings:

```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T)
```

```
## # A tibble: 5,307 x 9
##     year artist.inverted track time  genre
##  * <int> <chr>           <chr> <tim> <chr>
##  1  2000 Destiny's Child Inde~ 03:38 Rock 
##  2  2000 Santana         Mari~ 04:18 Rock 
##  3  2000 Savage Garden   I Kn~ 04:07 Rock 
##  4  2000 Madonna         Music 03:45 Rock 
##  5  2000 Aguilera, Chri~ Come~ 03:38 Rock 
##  6  2000 Janet           Does~ 04:17 Rock 
##  7  2000 Destiny's Child Say ~ 04:31 Rock 
##  8  2000 Iglesias, Enri~ Be W~ 03:36 Latin
##  9  2000 Sisqo           Inco~ 03:52 Rock 
## 10  2000 Lonestar        Amaz~ 04:25 Coun~
## # ... with 5,297 more rows, and 4 more
## #   variables: date.entered <date>,
## #   date.peaked <date>, week <chr>,
## #   rank <chr>
```

         

Another way to do this is with a select-helper: all those column names
end with `week`, so we can select them all thus:


```r
billboard %>% gather(week, rank, ends_with("week"), 
    na.rm = T)
```

```
## # A tibble: 5,307 x 9
##     year artist.inverted track time  genre
##  * <int> <chr>           <chr> <tim> <chr>
##  1  2000 Destiny's Child Inde~ 03:38 Rock 
##  2  2000 Santana         Mari~ 04:18 Rock 
##  3  2000 Savage Garden   I Kn~ 04:07 Rock 
##  4  2000 Madonna         Music 03:45 Rock 
##  5  2000 Aguilera, Chri~ Come~ 03:38 Rock 
##  6  2000 Janet           Does~ 04:17 Rock 
##  7  2000 Destiny's Child Say ~ 04:31 Rock 
##  8  2000 Iglesias, Enri~ Be W~ 03:36 Latin
##  9  2000 Sisqo           Inco~ 03:52 Rock 
## 10  2000 Lonestar        Amaz~ 04:25 Coun~
## # ... with 5,297 more rows, and 4 more
## #   variables: date.entered <date>,
## #   date.peaked <date>, week <chr>,
## #   rank <chr>
```

 

There are now only 9 columns, a lot fewer than we started with. This
is (I didn't need you to say) because we have collected together all
those `week` columns into one (a column called `rank`
with an indication of which `week` it came from). The logic of
the `gather` is that all those columns contain ranks (which is
what make them the same), but they are ranks from different weeks
(which is what makes them different).

What has actually happened is that we have turned "wide" format into
"long" format. This is not very insightful, so I would like you to
go a bit further in your explanation. The original data frame encodes
the rank of each song in each week, and what the `gather` has
done is to make that explicit: in the new data frame, each song's rank
in each week appears in *one* row, so that there are as many rows
as there are song-week combinations. The original data frame had 317
songs over 76 weeks, so this many:


```r
317 * 76
```

```
## [1] 24092
```

 

song-week combinations.

Not every song appeared in the Billboard chart for 76 weeks, so our tidy
data frame has a lot fewer rows than this.

You need to say that the original data frame had each song appearing
once (on one line), but now each song appears on multiple rows, one
for each week that the song was in the chart. Or something equivalent
to that.

 

(c) Display just your two new columns (for the first few
rows). Add something appropriate onto the end of your pipe to do this.


Solution


A `select` is the thing:

```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% select(week, rank)
```

```
## # A tibble: 5,307 x 2
##    week      rank 
##  * <chr>     <chr>
##  1 x1st.week 78   
##  2 x1st.week 15   
##  3 x1st.week 71   
##  4 x1st.week 41   
##  5 x1st.week 57   
##  6 x1st.week 59   
##  7 x1st.week 83   
##  8 x1st.week 63   
##  9 x1st.week 77   
## 10 x1st.week 81   
## # ... with 5,297 more rows
```

         



(d) Both your `week` and `rank` columns are
(probably) text. Create new columns that contain just the numeric
values, and display just your new columns, again adding onto the
end of your pipe. (In the previous part, you probably had some
code that picked out a few columns to display them. Get rid of
that.) 
 

Solution


`parse_number` is the easiest. Create new columns,
with `mutate`, that are the `parse_number`-ed
versions of the old ones.

```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% select(ends_with("number"))
```

```
## # A tibble: 5,307 x 2
##    week_number rank_number
##          <dbl>       <dbl>
##  1           1          78
##  2           1          15
##  3           1          71
##  4           1          41
##  5           1          57
##  6           1          59
##  7           1          83
##  8           1          63
##  9           1          77
## 10           1          81
## # ... with 5,297 more rows
```

         
You see that these are indeed numbers. (I gave my new columns names
that ended with `number`, which meant that I could select them
with the select-helper `ends_with`. I'm not insisting that you
do this, but it's a handy trick.)

Since `rank` already looks like a number, but happens to be
text, you can also convert it with `as.numeric` (or
`as.integer`, since it is actually text that looks like a whole
number). For converting `rank`, these are also good, but for
converting `week`, you need something that will pull out the
number. (`str_extract` from `stringr` will also do it,
but that's beyond our scope now. It's on page 212 of the R book if
you wish to investigate it. But `parse_number` is a lot
easier.) 

 

(e) The meaning of your week-number column is that it refers
to the number of weeks *after* the song first appeared in the
Billboard chart. That is, if a song's first appearance (in
`date.entered)` is July 24, then week 1 is July 24, week 2
is July 31, week 3 is August 7, and so on. Create a column
`current` by adding the appropriate number of *days*,
based on your week number, to `date.entered`. Display
`date.entered`, your week number, and `current` to
show that you have calculated the right thing. Note that you can
add a number of days onto a date and you will get another date.


Solution


There is a (small) gotcha here: if you read carefully, you'll
see that "week 1" is actually "week 0"  in terms of the
number of days to add on to `date.entered`. So you have
to subtract one from the number of weeks before you multiply
it by seven to get a number of days.
After that thinking, this:

```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% mutate(current = date.entered + 
    (week_number - 1) * 7) %>% select(date.entered, 
    week_number, current)
```

```
## # A tibble: 5,307 x 3
##    date.entered week_number current   
##    <date>             <dbl> <date>    
##  1 2000-09-23             1 2000-09-23
##  2 2000-02-12             1 2000-02-12
##  3 1999-10-23             1 1999-10-23
##  4 2000-08-12             1 2000-08-12
##  5 2000-08-05             1 2000-08-05
##  6 2000-06-17             1 2000-06-17
##  7 1999-12-25             1 1999-12-25
##  8 2000-04-01             1 2000-04-01
##  9 2000-06-24             1 2000-06-24
## 10 1999-06-05             1 1999-06-05
## # ... with 5,297 more rows
```

         

Don't forget to use your `week`-turned-into-number, or else it
won't work! (This bit me too, so you don't need to feel bad.)

You can also combine the three column-definition statements into one
mutate. It doesn't matter; as soon as you have defined a column, you
can use it in defining another column, even within the same
`mutate`. 

Anyway, the rows displayed are all `week_number` 1, so the
`current` date should be the same as `date.entered`, and
is. (These are all the first week that a song is in the Billboard
chart). 

You might be thinking that this is not much of a check, and you would
be right. A handy trick is to display a random sample of 10 (say) out
of the 5,000-odd rows of the data frame. To do that, add the line
`sample_n(10)` on the end, like this:



 


```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% mutate(current = date.entered + 
    (week_number - 1) * 7) %>% select(date.entered, 
    week_number, current) %>% sample_n(10)
```

```
## # A tibble: 10 x 3
##    date.entered week_number current   
##    <date>             <dbl> <date>    
##  1 2000-03-18            27 2000-09-16
##  2 2000-08-12             3 2000-08-26
##  3 2000-09-23             4 2000-10-14
##  4 1999-12-04            11 2000-02-12
##  5 2000-01-22             8 2000-03-11
##  6 2000-05-27            16 2000-09-09
##  7 2000-04-29             5 2000-05-27
##  8 2000-06-10             4 2000-07-01
##  9 2000-04-15            12 2000-07-01
## 10 2000-08-26            18 2000-12-23
```

 

This gives a variety of rows to check. The first `current`
should be $27-1=26$ weeks, or about 6 months, after the date the song
entered the chart, and so it is; the second one should be $3-1=2$
weeks after entry, and it is. The third one should be 3 weeks after
September 23; this is (as I figure it) September $23+21=44$, and
September has 30 days, so this is really October 14. Check.

Your random selection of rows is likely to be different from mine, but
the same kind of thinking will enable you to check whether it makes
sense. 

 

(f) Reaching the \#1 rank on the Billboard chart is one of
the highest accolades in the popular music world. List all the
songs that reached `rank` 1. For these songs, list the
artist (as given in the data set), the song title, and the date(s)
for which the song was ranked number 1. Arrange the songs in date
order of being ranked \#1. Display all the songs (I found 55 of them).


Solution


To the previous pipe, add the last lines below. You can use
either `rank` (text) or what I called
`rank_number` (a number). It doesn't matter here,
since we are only checking for equal-to, not something like
"less than":

```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% mutate(current = date.entered + 
    (week_number - 1) * 7) %>% filter(rank == 
    1) %>% arrange(current) %>% select(artist.inverted, 
    track, current)
```

```
## # A tibble: 55 x 3
##    artist.inverted   track        current   
##    <chr>             <chr>        <date>    
##  1 Aguilera, Christ~ What A Girl~ 2000-01-15
##  2 Aguilera, Christ~ What A Girl~ 2000-01-22
##  3 Savage Garden     I Knew I Lo~ 2000-01-29
##  4 Savage Garden     I Knew I Lo~ 2000-02-05
##  5 Savage Garden     I Knew I Lo~ 2000-02-12
##  6 Carey, Mariah     Thank God I~ 2000-02-19
##  7 Savage Garden     I Knew I Lo~ 2000-02-26
##  8 Lonestar          Amazed       2000-03-04
##  9 Lonestar          Amazed       2000-03-11
## 10 Destiny's Child   Say My Name  2000-03-18
## # ... with 45 more rows
```

         

You'll see the first ten rows, as here, but with clickable buttons to
see the next 10 (and the previous 10 if you have moved beyond 1--10). 
The "artist" column is called `artist.inverted` because, if
the artist is a single person rather than a group, their last name is
listed first. The song title appears in the column `track`. 

The song by Destiny's Child spills into 2001 because it entered the
chart in 2000, and the data set keeps a record of all such songs until
they drop out of the chart. I'm not sure what happened to the song
that was \#1 on January 8, 2000; maybe it entered the chart in
1999
\marginnote{Which was the title of a song by Prince.} and so is not
listed here.

 

(g) Use R to find out which song held the \#1 rank for the
largest number of weeks. For this, you can assume that the song
titles are all unique (if it's the same song title, it's the same
song), but the artists might not be (for example, Madonna might
have had two different songs reach the \#1 rank). The information
you need is in the output you obtained for the previous part, so
it's a matter of adding some code to the end of that.
The last mark was for displaying *only* the song that was
ranked \#1 for the largest number of weeks, or for otherwise
making it easy to see which song it was.


Solution


This is a question of using `count`, but on the
`track` title:

```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% mutate(current = date.entered + 
    (week_number - 1) * 7) %>% filter(rank == 
    1) %>% arrange(current) %>% select(artist.inverted, 
    track, current) %>% count(track)
```

```
## # A tibble: 17 x 2
##    track                                   n
##    <chr>                               <int>
##  1 Amazed                                  2
##  2 Bent                                    1
##  3 Be With You                             3
##  4 Come On Over Baby (All I Want Is Y~     4
##  5 Doesn't Really Matter                   3
##  6 Everything You Want                     1
##  7 I Knew I Loved You                      4
##  8 Incomplete                              2
##  9 Independent Women Part I               11
## 10 It's Gonna Be Me                        2
## 11 Maria, Maria                           10
## 12 Music                                   4
## 13 Say My Name                             3
## 14 Thank God I Found You                   1
## 15 Try Again                               1
## 16 What A Girl Wants                       2
## 17 With Arms Wide Open                     1
```

         

Then you can scan down the `n` column, find that the
biggest number is 11, and say: it's the song "Independent Women Part I" by Destiny's Child. This is 3 points (out of 4, when the question
was to be handed in).

But, this is a data frame, so anything we can do to a data frame we
can do to this, like listing out only the row(s) where `n` is
equal to its maximum value:


```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% mutate(current = date.entered + 
    (week_number - 1) * 7) %>% filter(rank == 
    1) %>% arrange(current) %>% select(artist.inverted, 
    track, current) %>% count(track) %>% filter(n == 
    max(n))
```

```
## # A tibble: 1 x 2
##   track                        n
##   <chr>                    <int>
## 1 Independent Women Part I    11
```

 

or arranging them in (most logically, descending) order by `n`
to make it easier to pick out the top one:


```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% mutate(current = date.entered + 
    (week_number - 1) * 7) %>% filter(rank == 
    1) %>% arrange(current) %>% select(artist.inverted, 
    track, current) %>% count(track) %>% arrange(desc(n))
```

```
## # A tibble: 17 x 2
##    track                                   n
##    <chr>                               <int>
##  1 Independent Women Part I               11
##  2 Maria, Maria                           10
##  3 Come On Over Baby (All I Want Is Y~     4
##  4 I Knew I Loved You                      4
##  5 Music                                   4
##  6 Be With You                             3
##  7 Doesn't Really Matter                   3
##  8 Say My Name                             3
##  9 Amazed                                  2
## 10 Incomplete                              2
## 11 It's Gonna Be Me                        2
## 12 What A Girl Wants                       2
## 13 Bent                                    1
## 14 Everything You Want                     1
## 15 Thank God I Found You                   1
## 16 Try Again                               1
## 17 With Arms Wide Open                     1
```

 

Either of those will net you the 4th point.

If you want to be a little bit more careful, you can make an
artist-track combination as below. This would catch occasions where
the same song by two different artists made it to \#1, or two
different songs that happened to have the same title did. It's not
very likely that the same artist would record two *different*
songs with the same title, though it is possible that the same song by
the same artist could appear in the Billboard chart on two different
occasions.
\marginnote{As, for example, when Prince died.}

I think I want to create an artist-song combo fairly early in my pipe,
and then display *that* later, something like this. This means
replacing `track` by my `combo` later in the pipe,
wherever it appears:


```r
billboard %>% gather(week, rank, x1st.week:x76th.week, 
    na.rm = T) %>% mutate(week_number = parse_number(week), 
    rank_number = parse_number(rank)) %>% mutate(combo = paste(track, 
    artist.inverted, sep = " by ")) %>% mutate(current = date.entered + 
    (week_number - 1) * 7) %>% filter(rank == 
    1) %>% arrange(current) %>% select(combo, 
    current) %>% count(combo) %>% arrange(desc(n))
```

```
## # A tibble: 17 x 2
##    combo                                   n
##    <chr>                               <int>
##  1 Independent Women Part I by Destin~    11
##  2 Maria, Maria by Santana                10
##  3 Come On Over Baby (All I Want Is Y~     4
##  4 I Knew I Loved You by Savage Garden     4
##  5 Music by Madonna                        4
##  6 Be With You by Iglesias, Enrique        3
##  7 Doesn't Really Matter by Janet          3
##  8 Say My Name by Destiny's Child          3
##  9 Amazed by Lonestar                      2
## 10 Incomplete by Sisqo                     2
## 11 It's Gonna Be Me by N'Sync              2
## 12 What A Girl Wants by Aguilera, Chr~     2
## 13 Bent by matchbox twenty                 1
## 14 Everything You Want by Vertical Ho~     1
## 15 Thank God I Found You by Carey, Ma~     1
## 16 Try Again by Aaliyah                    1
## 17 With Arms Wide Open by Creed            1
```

 

I don't think it makes any difference here, but it might in other
years, or if you look over several years where you might get cover
versions of the same song performed by different artists.

Zero-point bonus: how many of these artists have you heard of? How
many have your parents heard of? (I followed popular music quite
closely much earlier than this, in the early 1980s in the UK. I
remember both Madonna and U2 when they *first* became
famous. U2's first single was called "Fire" and it just scraped into
the UK top 40. Things changed after that.)

 




##  Bikes on College


 The City of Toronto collects all kinds of data on aspects of
life in the city. See
[link](http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=1a66e03bb8d1e310VgnVCM10000071d60f89RCRD). One
collection of data is records of the number of cyclists on certain
downtown streets. The data in
[link](http://www.utsc.utoronto.ca/~butler/c32/bikes.csv) are a record
of the cyclists on College Street on the block west from Huron to
Spadina on September 24, 2010. In the spreadsheet, each row relates to
one cyclist. The first column is the time the cyclist was observed (to
the nearest 15 minutes). After that, there are four pairs of
columns. The observer filled in (exactly) one X in each pair of
columns, according to whether (i) the cyclist was male or female, (ii)
was or was not wearing a helmet, (iii) was or was not carrying a
passenger on the bike, (iv) was or was not riding on the sidewalk. We
want to create a tidy data frame that has the time in each row, and
has columns containing appropriate values, often `TRUE` or
`FALSE`, for each of the four variables measured.

I will lead you through the process, which will involve developing a
(long) pipe, one step at a time.



(a) Take a look at the spreadsheet (using Excel or similar:
this may open when you click the link). Are there any obvious
header rows? Is there any extra material before the data start?
Explain briefly.


Solution


This is what I see (you should see something that looks like this):

![](bikes-ss.png)

There are really *two* rows of headers (the rows
highlighted in yellow). The actual information that says what
the column pair is about is in the first of those two rows, and
the second row indicates which category of the information above
this column refers to.
This is not the usual way that the column headers encode what
the columns are about: we are used to having *one* column
`gender` that would take the values `female` or
`male`, or a column `helmet` containing the values
`yes` or `no`. (You might be sensing
`gather` here, which may be one way of tackling this, but
I lead you into another idea below.)
There are also six lines above the highlighted ones that contain
background information about this study. (This is where I got
the information about the date of the study and which block of
which street it is about.)
I am looking for two things: the apparent header line is
actually two lines (the ones in yellow), and there are extra
lines above that which are not data.



(b)??part:firstpart?? Read the data into an R data
frame. Read *without* headers, and instruct R how many lines
to skip over using `skip=` and a suitable number.
When this is working, display the first few lines of your data
frame.  Note that your columns have names `X1` through
`X9`.


Solution


The actual data start on line 9, so we need to skip 8
lines. `col_names=F` is the way to say that we have no
column names (not ones that we want to use, anyway). Just
typing the name of the data frame will display "a few" (that
is, 10) lines of it, so that you can check it for
plausibleness: 

```r
my_url = "http://www.utsc.utoronto.ca/~butler/c32/bikes.csv"
bikes = read_csv(my_url, skip = 8, col_names = F)
```

```
## Parsed with column specification:
## cols(
##   X1 = col_time(format = ""),
##   X2 = col_character(),
##   X3 = col_character(),
##   X4 = col_character(),
##   X5 = col_character(),
##   X6 = col_character(),
##   X7 = col_character(),
##   X8 = col_character(),
##   X9 = col_character()
## )
```

```r
bikes
```

```
## # A tibble: 1,958 x 9
##    X1     X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2    NA  X     <NA>  <NA>  X     <NA>  X    
##  3    NA  X     <NA>  <NA>  X     <NA>  X    
##  4    NA  X     <NA>  <NA>  X     <NA>  X    
##  5    NA  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7    NA  <NA>  X     X     <NA>  <NA>  X    
##  8    NA  X     <NA>  X     <NA>  <NA>  X    
##  9    NA  <NA>  X     X     <NA>  <NA>  X    
## 10    NA  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 2 more
## #   variables: X8 <chr>, X9 <chr>
```

         

This seems to have worked: a column with times in it, and four pairs
of columns, with exactly one of each pair having an X in it. The
variable names `X1` through `X9` were generated by
`read_csv`, as it does when you read in data with
`col_names=F`. The times are correctly `time`s, and the
other columns are all text. The blank cells in the spreadsheet have
appeared in our data frame as "missing" (`NA`). The notation
`<NA>` means "missing text" (as opposed to a missing number,
say). 

The first line in our data frame contains the first 7:00 (am) cyclist,
so it looks as if we skipped the right number of lines.



(c) What do you notice about the times in your first
column? What do you think those "missing" times should be?

Solution


There are some times and some missing values. It seems a
reasonable guess that the person recording the data only
recorded a time when a new period of 15 minutes had begun, so
that the missing times should be the same as the previous
non-missing one: For
example, the first five rows are cyclists observed at 7:00 am
(or, at least, between 7:00 and 7:15). So they should be
recorded as 7:00, and the ones in rows 7--10 should be
recorded as 7:15, and so on.


(d) Find something from the `tidyverse` that will
fill
\marginnote{Oh, what a giveaway.}
in those missing values with the right thing.
Start a pipe from the data frame you read in, that updates the
appropriate column with the filled-in times.


Solution


`fill` from `tidyr` fills
in the missing times with the previous non-missing
value. (This will mean finding the help for `fill` in R
Studio or online.)
I told you it was a giveaway.
If you look in the help for `fill` via `?fill`
(or if you Google `tidyr::fill`, which is the full
name for "the `fill` that lives in          `tidyr`"), 
you'll see that it requires up to two
things (not including the data frame): a column to fill, and
a direction to fill it (the default of "down" is exactly
what we want). Thus:

```r
bikes %>% fill(X1)
```

```
## # A tibble: 1,958 x 9
##    X1     X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 2 more
## #   variables: X8 <chr>, X9 <chr>
```

           

Success!

We will probably want to rename `X1` to something like
`time`, so let's do that now before we forget. There is a
`rename` that does about what you'd expect:


```r
bikes %>% fill(X1) %>% rename(Time = X1)
```

```
## # A tibble: 1,958 x 9
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 2 more
## #   variables: X8 <chr>, X9 <chr>
```

 

The only thing I keep forgetting is that the syntax of `rename`
is "new name equals old name". Sometimes I think it's the other way
around, and then I wonder why it doesn't work.

I gave it a capital T so as not to confuse it with other things in R
called `time`.



(e) R's `ifelse` function works like `=IF` in
Excel. You use it to create values for a new variable, for
example in a `mutate`.  The first input to it is a
logical condition (something that is either true or false); the
second is the value your new variable should take if the
condition is true, and the third is the value of your new
variable if the condition is false.  Create a new column
`gender` in your data frame that is "male" or
"female" depending on the value of your `X2` column,
using `mutate`. (You can assume that exactly one of the
second and third columns has an `X` in it.) Add your code
to the end of your pipe and display (the first 10 rows of) the
result.


Solution


Under the assumption we are making, we only have to look
at column `X2` and we ignore `X3` totally:

```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = ifelse(X2 == 
    "X", "male", "female"))
```

```
## # A tibble: 1,958 x 10
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 3 more
## #   variables: X8 <chr>, X9 <chr>,
## #   gender <chr>
```

            

Oh, that didn't work. The gender column is either `male` or
missing; the two missing ones here should say `female`. What
happened? Let's just look at our logical condition this time:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(isX = (X2 == 
    "X"))
```

```
## # A tibble: 1,958 x 10
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 3 more
## #   variables: X8 <chr>, X9 <chr>, isX <lgl>
```

 

This is not true and false, it is true and missing. The idea is that
if `X2` is missing, we don't (in general) know what its value
is: it might even be `X`! So if `X2` is missing, any
comparison of it with another value ought to be missing as well.

That's in general. Here, we know where those missing values came from:
they were blank cells in the spreadsheet, so we actually have more
information. 

Perhaps a better way to go is to test whether `X2` is missing (in which
case, it's a female cyclist). R has a function `is.na` which is
`TRUE` if the thing inside it is missing and `FALSE` if
the thing inside it has some non-missing value. In our case, it
goes like this:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = ifelse(is.na(X2), 
    "female", "male"))
```

```
## # A tibble: 1,958 x 10
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 3 more
## #   variables: X8 <chr>, X9 <chr>,
## #   gender <chr>
```

            

Or you can test `X3` for missingness: if missing, it's male,
otherwise it's female. That also works.

This made an assumption that the person recording the X's actually
*did* mark an X in exactly one of the columns. For example, the
columns could *both* be missing, or *both* have an X in
them. This gives us more things to check, at least
three. `ifelse` is good for something with only two
alternatives, but when you have more, `case_when` is much
better.
\marginnote{In some languages it is called *switch*. Python  appears not to have it. What you do there instead is to use a Python  dictionary to pick out the value you want.} 
Here's how that goes. Our strategy is to
check for three things: (i) `X2` has an `X` and
`X3` is missing; (ii) `X2` is missing and `X3`
has an `X`; (iii) anything else, which is an error:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = case_when(X2 == 
    "X" & is.na(X3) ~ "Male", is.na(X2) & X3 == 
    "X" ~ "Female", TRUE ~ "Error!"))
```

```
## # A tibble: 1,958 x 10
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 3 more
## #   variables: X8 <chr>, X9 <chr>,
## #   gender <chr>
```

            

It seems nicest to format it like that, with the squiggles lining up,
so you can see what possible values `gender` might take.

The structure of the `case_when` is that the thing you're
checking for goes on the left of the squiggle, and the value you want
your new variable to take goes on the right. What it does is to go
down the list of conditions that you are checking for, and as soon as
it finds one that is true, it grabs the value on the right of the
squiggle and moves on to the next row. The usual way to write these is
to have a catch-all condition at the end that is always true, serving
to make sure that your new variable always gets *some*
value. `TRUE` is, um, always true. If you want an English word
for the last condition of your `case_when`, "otherwise" is a
nice one.

I wanted to check that the observer did check exactly one of
`V2` and `V3` as I asserted, which can be done by
gluing this onto the end:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = case_when(X2 == 
    "X" & is.na(X3) ~ "Male", is.na(X2) & X3 == 
    "X" ~ "Female", TRUE ~ "Error!")) %>% count(gender)
```

```
## # A tibble: 2 x 2
##   gender     n
##   <chr>  <int>
## 1 Female   861
## 2 Male    1097
```

            

There are only Males and Females, so the observer really did mark
exactly one X. (As a bonus, you see that there were slightly more male
cyclists than female ones.)

Extra: I was wondering how `gather` would play out here. The
way to do it seems to be to rename the columns first:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% rename(male = X2, 
    female = X3)
```

```
## # A tibble: 1,958 x 9
##    Time male  female X4    X5    X6    X7   
##    <ti> <chr> <chr>  <chr> <chr> <chr> <chr>
##  1 07:~ X     <NA>   <NA>  X     <NA>  X    
##  2 07:~ X     <NA>   <NA>  X     <NA>  X    
##  3 07:~ X     <NA>   <NA>  X     <NA>  X    
##  4 07:~ X     <NA>   <NA>  X     <NA>  X    
##  5 07:~ X     <NA>   <NA>  X     <NA>  X    
##  6 07:~ X     <NA>   X     <NA>  <NA>  X    
##  7 07:~ <NA>  X      X     <NA>  <NA>  X    
##  8 07:~ X     <NA>   X     <NA>  <NA>  X    
##  9 07:~ <NA>  X      X     <NA>  <NA>  X    
## 10 07:~ X     <NA>   X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 2 more
## #   variables: X8 <chr>, X9 <chr>
```

 

and then gather them up:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% rename(male = X2, 
    female = X3) %>% gather(gender, what, male:female)
```

```
## # A tibble: 3,916 x 9
##    Time   X4    X5    X6    X7    X8    X9   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  <NA>  X     <NA>  X     <NA>  X    
##  2 07:00  <NA>  X     <NA>  X     <NA>  X    
##  3 07:00  <NA>  X     <NA>  X     <NA>  X    
##  4 07:00  <NA>  X     <NA>  X     <NA>  X    
##  5 07:00  <NA>  X     <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  <NA>  X     <NA>  X    
##  7 07:15  X     <NA>  <NA>  X     <NA>  X    
##  8 07:15  X     <NA>  <NA>  X     <NA>  X    
##  9 07:15  X     <NA>  <NA>  X     X     <NA> 
## 10 07:15  X     <NA>  <NA>  X     <NA>  X    
## # ... with 3,906 more rows, and 2 more
## #   variables: gender <chr>, what <chr>
```

 

I wasn't quite sure what to call "what makes them the same", at
least not until I had seen how it came out. This is where the
`X` or missing goes, so we want the lines where `what`
is equal to `X`:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% rename(male = X2, 
    female = X3) %>% gather(gender, what, male:female) %>% 
    filter(what == "X")
```

```
## # A tibble: 1,958 x 9
##    Time   X4    X5    X6    X7    X8    X9   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  <NA>  X     <NA>  X     <NA>  X    
##  2 07:00  <NA>  X     <NA>  X     <NA>  X    
##  3 07:00  <NA>  X     <NA>  X     <NA>  X    
##  4 07:00  <NA>  X     <NA>  X     <NA>  X    
##  5 07:00  <NA>  X     <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  <NA>  X     <NA>  X    
##  7 07:15  X     <NA>  <NA>  X     <NA>  X    
##  8 07:15  X     <NA>  <NA>  X     <NA>  X    
##  9 07:15  X     <NA>  <NA>  X     <NA>  X    
## 10 07:15  X     <NA>  <NA>  X     <NA>  X    
## # ... with 1,948 more rows, and 2 more
## #   variables: gender <chr>, what <chr>
```

 

Another way to do this is to remove the missings in the `gather`:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% rename(male = X2, 
    female = X3) %>% gather(gender, what, male:female, 
    na.rm = T)
```

```
## # A tibble: 1,958 x 9
##    Time   X4    X5    X6    X7    X8    X9   
##  * <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  <NA>  X     <NA>  X     <NA>  X    
##  2 07:00  <NA>  X     <NA>  X     <NA>  X    
##  3 07:00  <NA>  X     <NA>  X     <NA>  X    
##  4 07:00  <NA>  X     <NA>  X     <NA>  X    
##  5 07:00  <NA>  X     <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  <NA>  X     <NA>  X    
##  7 07:15  X     <NA>  <NA>  X     <NA>  X    
##  8 07:15  X     <NA>  <NA>  X     <NA>  X    
##  9 07:15  X     <NA>  <NA>  X     <NA>  X    
## 10 07:15  X     <NA>  <NA>  X     <NA>  X    
## # ... with 1,948 more rows, and 2 more
## #   variables: gender <chr>, what <chr>
```

 

In case you are wondering where the females went, all the males are
listed first this way, and then all the females. To verify this, we
can count the males and females obtained this way, and we should get
the same thing we got before:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% rename(male = X2, 
    female = X3) %>% gather(gender, what, male:female, 
    na.rm = T) %>% count(gender)
```

```
## # A tibble: 2 x 2
##   gender     n
##   <chr>  <int>
## 1 female   861
## 2 male    1097
```

 

And this is what we had before.



(f) Create variables `helmet`, `passenger` and
`sidewalk` in your data frame that are `TRUE` if
the "Yes" column contains `X` and `FALSE`
otherwise. This will use `mutate` again, but you don't
need `ifelse`: just set the variable equal to the
appropriate logical condition. As before, the best way to
create these variables is to test the appropriate things for
missingness.  Note that you can create as many new variables
as you like in one `mutate`. Show the first few lines
of your new data frame. (Add your code onto the end of the
pipe you made above.)


Solution


On the face of it, the way to do this is to go looking
for `X`'s:

```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = ifelse(is.na(X2), 
    "female", "male")) %>% mutate(helmet = (X4 == 
    "X"), passenger = (X6 == "X"), sidewalk = (X8 == 
    "X"))
```

```
## # A tibble: 1,958 x 13
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 6 more
## #   variables: X8 <chr>, X9 <chr>,
## #   gender <chr>, helmet <lgl>,
## #   passenger <lgl>, sidewalk <lgl>
```

    

But, we run into the same problem that we did with `gender`:
the new variables are either `TRUE` or missing, never `FALSE`.

The solution is the same: look for the things that are *missing*
if the cyclist is wearing a helmet, carrying a passenger or riding on
the sidewalk. These are `X5, X7, X9` respectively:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = ifelse(is.na(X2), 
    "female", "male")) %>% mutate(helmet = is.na(X5), 
    passenger = is.na(X7), sidewalk = is.na(X9))
```

```
## # A tibble: 1,958 x 13
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 6 more
## #   variables: X8 <chr>, X9 <chr>,
## #   gender <chr>, helmet <lgl>,
## #   passenger <lgl>, sidewalk <lgl>
```

    
Again, you can do the `mutate` all on one line if you want to,
or all four variable assignments in one `mutate`,
but I used newlines and indentation to make the structure
clear. 

It is less elegant, though equally good for the purposes of the
assignment, to use `ifelse` for these as well, which would go
like this, for example:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = ifelse(X2 == 
    "X", "male", "female")) %>% mutate(helmet = ifelse(is.na(X5), 
    T, F))
```

```
## # A tibble: 1,958 x 11
##    Time   X2    X3    X4    X5    X6    X7   
##    <time> <chr> <chr> <chr> <chr> <chr> <chr>
##  1 07:00  X     <NA>  <NA>  X     <NA>  X    
##  2 07:00  X     <NA>  <NA>  X     <NA>  X    
##  3 07:00  X     <NA>  <NA>  X     <NA>  X    
##  4 07:00  X     <NA>  <NA>  X     <NA>  X    
##  5 07:00  X     <NA>  <NA>  X     <NA>  X    
##  6 07:15  X     <NA>  X     <NA>  <NA>  X    
##  7 07:15  <NA>  X     X     <NA>  <NA>  X    
##  8 07:15  X     <NA>  X     <NA>  <NA>  X    
##  9 07:15  <NA>  X     X     <NA>  <NA>  X    
## 10 07:15  X     <NA>  X     <NA>  <NA>  X    
## # ... with 1,948 more rows, and 4 more
## #   variables: X8 <chr>, X9 <chr>,
## #   gender <chr>, helmet <lgl>
```

 

and the same for `passenger` and `sidewalk`. The warning
is, whenever you see a `T` and an `F` in an
`ifelse`, that you could probably get rid of the
`ifelse` and use the logical condition directly.
\marginnote{If I  was helping you, and you were struggling with *ifelse* but  finally mastered it, it seemed easier to suggest that you used it  again for the others.}  For texttt{gender}, though, you need the
`ifelse` (or a `case_when`) because the values you want
it to take are `male` and `female`, something other than
`TRUE` and `FALSE`.

I like to put brackets around logical conditions when I am assigning
them to a variable. If I don't, I get something like


```r
helmet = V4 == "X"
```

 

which actually works, but is very hard to read. Well, I *think* it
works. Let's check:


```r
exes = c("X", "", "X", "", "X")
y = exes == "X"
y
```

```
## [1]  TRUE FALSE  TRUE FALSE  TRUE
```



Yes it does. But I would never recommend writing it this way, because
unless you are paying attention, you won't notice which `=` is
saving in a variable, and which one is "logically equal".

It works because of a thing called "operator precedence": the
logical-equals is evaluated first, and the result of that is saved in
the variable. But unless you or your readers remember that, it's
better to write


```r
y = (exes == "X")
```

 

to draw attention to the order of calculation. This is the same reason that


```r
4 + 5 * 6
```

```
## [1] 34
```

 

evaluates this way rather than doing the addition first and getting
54. BODMAS and all that.

The `gather` approach works for these too. Rename the columns
as `yes` and `no`, and then give the "what makes them the same" column a name like `helmet`.
Give the "what makes them different" column a name like
`what2`, to make it easier to remove later. And then do the
same with the others, one `gather` at a time.



(g)??part:lastpart?? Finally 
(for the data manipulation), get rid of
all the original columns, keeping only the new ones that
you created. Save the results in a data frame and display
its first few rows.
 

Solution


This is a breath of fresh air after all the thinking
needed above: this is just `select`, added to
the end:

```r
mybikes = bikes %>% fill(X1) %>% rename(Time = X1) %>% 
    mutate(gender = ifelse(is.na(X2), "female", 
        "male")) %>% mutate(helmet = is.na(X5), 
    passenger = is.na(X7), sidewalk = is.na(X9)) %>% 
    select(-(X2:X9))
mybikes
```

```
## # A tibble: 1,958 x 5
##    Time   gender helmet passenger sidewalk
##    <time> <chr>  <lgl>  <lgl>     <lgl>   
##  1 07:00  male   FALSE  FALSE     FALSE   
##  2 07:00  male   FALSE  FALSE     FALSE   
##  3 07:00  male   FALSE  FALSE     FALSE   
##  4 07:00  male   FALSE  FALSE     FALSE   
##  5 07:00  male   FALSE  FALSE     FALSE   
##  6 07:15  male   TRUE   FALSE     FALSE   
##  7 07:15  female TRUE   FALSE     FALSE   
##  8 07:15  male   TRUE   FALSE     FALSE   
##  9 07:15  female TRUE   FALSE     TRUE    
## 10 07:15  male   TRUE   FALSE     FALSE   
## # ... with 1,948 more rows
```

           

You might not have renamed your `X1`, in which case, you still
have it, but need to keep it (because it holds the times).

Another way to do this is to use a "select-helper", thus:


```r
bikes %>% fill(X1) %>% rename(Time = X1) %>% mutate(gender = ifelse(is.na(X2), 
    "female", "male")) %>% mutate(helmet = is.na(X5), 
    passenger = is.na(X7), sidewalk = is.na(X9)) %>% 
    select(-num_range("X", 2:9))
```

```
## # A tibble: 1,958 x 5
##    Time   gender helmet passenger sidewalk
##    <time> <chr>  <lgl>  <lgl>     <lgl>   
##  1 07:00  male   FALSE  FALSE     FALSE   
##  2 07:00  male   FALSE  FALSE     FALSE   
##  3 07:00  male   FALSE  FALSE     FALSE   
##  4 07:00  male   FALSE  FALSE     FALSE   
##  5 07:00  male   FALSE  FALSE     FALSE   
##  6 07:15  male   TRUE   FALSE     FALSE   
##  7 07:15  female TRUE   FALSE     FALSE   
##  8 07:15  male   TRUE   FALSE     FALSE   
##  9 07:15  female TRUE   FALSE     TRUE    
## 10 07:15  male   TRUE   FALSE     FALSE   
## # ... with 1,948 more rows
```

           

This means "get rid of all the columns whose names are *X* followed by a number 2 through 9". 

The pipe looks long and forbidding, but you built it (and tested it) a
little at a time. Which is how you do it.



(h) The next few parts are a quick-fire analysis of
the data set. They can all be solved using `count`.
How many male and how many female cyclists were observed
in total?


Solution


I already got this one when I was checking for
observer-notation errors earlier:

```r
mybikes %>% count(gender)
```

```
## # A tibble: 2 x 2
##   gender     n
##   <chr>  <int>
## 1 female   861
## 2 male    1097
```

                   

861 females and 1097 males.



(i) How many male and female cyclists were not
wearing helmets?


Solution


You can count two variables at once, in which case
you get counts of all combinations of them:

```r
mybikes %>% count(gender, helmet)
```

```
## # A tibble: 4 x 3
##   gender helmet     n
##   <chr>  <lgl>  <int>
## 1 female FALSE    403
## 2 female TRUE     458
## 3 male   FALSE    604
## 4 male   TRUE     493
```

                   

403 females and 604 males were not wearing helmets, picking out what
we need.

The real question of interest here is "what *proportion* of male and female cyclists were not wearing helmets?"
\marginnote{But I didn't want to complicate this question any farther.} 
This has a rather elegant
solution that I will have to explain. First, let's go back to the
`group_by` and `summarize` version of the
`count` here:


```r
mybikes %>% group_by(gender, helmet) %>% summarize(the_ount = n())
```

```
## # A tibble: 4 x 3
## # Groups:   gender [?]
##   gender helmet the_ount
##   <chr>  <lgl>     <int>
## 1 female FALSE       403
## 2 female TRUE        458
## 3 male   FALSE       604
## 4 male   TRUE        493
```

 

That's the same table we got just now. Now, let's calculate a
proportion and see what happens:


```r
mybikes %>% group_by(gender, helmet) %>% summarize(the_count = n()) %>% 
    mutate(prop = the_count/sum(the_count))
```

```
## # A tibble: 4 x 4
## # Groups:   gender [2]
##   gender helmet the_count  prop
##   <chr>  <lgl>      <int> <dbl>
## 1 female FALSE        403 0.468
## 2 female TRUE         458 0.532
## 3 male   FALSE        604 0.551
## 4 male   TRUE         493 0.449
```

 

We seem to have the proportions of males and females who were and were
not wearing a helmet, and you can check that this is indeed the case,
for example:


```r
403/(403 + 458)
```

```
## [1] 0.4680604
```

 
47\% of females were not wearing helmets, while 55\% of males were
helmetless. (You can tell from the original frequencies that a small
majority of females wore helmets and a small majority of males did not.)

Now, we have to ask ourselves: how on earth did that work?

When you calculate a summary (like our `sum(count)` above), it
figures that you can't want the sum by gender-helmet combination,
since you already have those in `count`. You must want the sum
*over* something. What? What happens is that it goes back to the
`group_by` and "peels off" the last thing there, which in
this case is `helmet`, leaving only `gender`. It then
sums the counts for each gender, giving us what we wanted.

It just blows my mind that someone (ie., Hadley Wickham) could (i) think
that this would be a nice syntax to have (instead of just being an
error), (ii) find a way to implement it and (iii) find a nice logical
explanation ("peeling off") to explain how it worked.

What happens if we switch the order of the things in the `group_by`?


```r
mybikes %>% group_by(helmet, gender) %>% summarize(the_count = n()) %>% 
    mutate(prop = the_count/sum(the_count))
```

```
## # A tibble: 4 x 4
## # Groups:   helmet [2]
##   helmet gender the_count  prop
##   <lgl>  <chr>      <int> <dbl>
## 1 FALSE  female       403 0.400
## 2 FALSE  male         604 0.600
## 3 TRUE   female       458 0.482
## 4 TRUE   male         493 0.518
```

 

Now we get the proportion of helmeted riders of each gender, which is
not the same as what we had before. Before, we had "out of males"
and "out of females"; now we have "out of helmeted riders" and
"out of helmetless riders". (The riders with helmets are almost
50--50 males and females, but the riders without helmets are about
60\% male.)

This is row and column proportions in a contingency table, B22 style.

Now, I have to see whether the `count` variant of this works:

```r
mybikes %>% count(gender, helmet) %>% mutate(prop = n/sum(n))
```

```
## # A tibble: 4 x 4
##   gender helmet     n  prop
##   <chr>  <lgl>  <int> <dbl>
## 1 female FALSE    403 0.206
## 2 female TRUE     458 0.234
## 3 male   FALSE    604 0.308
## 4 male   TRUE     493 0.252
```

 

It doesn't. Well, it kind of does, but it divided by the sum of all of
them rather than "peeling off", so these are overall proportions
rather than row or column proportions.

So I think you have to do this the `group_by` and
`summarize` way.



(j) How many cyclists were riding on the sidewalk
*and* carrying a passenger?


Solution


Not too many, I'd hope. Again:

```r
mybikes %>% count(passenger, sidewalk)
```

```
## # A tibble: 3 x 3
##   passenger sidewalk     n
##   <lgl>     <lgl>    <int>
## 1 FALSE     FALSE     1880
## 2 FALSE     TRUE        73
## 3 TRUE      FALSE        5
```

                   

We're looking for the "true", "true" entry of that table, which
seems to have vanished. That means the count is *zero*:
none at all. 
(There were
only 5 passenger-carrying riders, and they were all on the road.)



(k) What was the busiest 15-minute period of the
day, and how many cyclists were there then?


Solution


The obvious way is to list every 15-minute period
and eyeball the largest frequency. There are quite a
few 15-minute periods, so be prepared to hit Next a
few times (or use `View`):


```r
mybikes %>% count(Time) %>% print(n = Inf)
```

```
## # A tibble: 48 x 2
##    Time       n
##    <time> <int>
##  1 07:00      5
##  2 07:15      8
##  3 07:30      9
##  4 07:45      5
##  5 08:00     18
##  6 08:15     14
##  7 08:30     12
##  8 08:45     22
##  9 09:00     17
## 10 09:15     15
## 11 09:30     16
## 12 09:45     12
## 13 10:00      8
## 14 10:15     21
## 15 10:30     22
## 16 10:45     19
## 17 11:00     30
## 18 11:15     14
## 19 11:30     27
## 20 11:45     28
## 21 12:00     22
## 22 12:15     35
## 23 12:30     40
## 24 12:45     33
## 25 13:00     44
## 26 13:15     46
## 27 13:30     29
## 28 13:45     41
## 29 14:00     36
## 30 14:15     45
## 31 14:30     33
## 32 14:45     50
## 33 15:00     49
## 34 15:15     51
## 35 15:30     61
## 36 15:45     79
## 37 16:00    101
## 38 16:15     56
## 39 16:30     51
## 40 16:45     75
## 41 17:00    104
## 42 17:15    128
## 43 17:30     80
## 44 17:45     73
## 45 18:00     75
## 46 18:15     78
## 47 18:30     63
## 48 18:45     58
```

                   

17:15, or 5:15 pm, with 128 cyclists. 

But, computers are meant to save us that kind of effort. How?  Note
that the output from `count` is itself a data frame, so
anything you can do to a data frame, you can do to *it*: for
example, display only the rows where the frequency equals the maximum
frequency:


```r
mybikes %>% count(Time) %>% filter(n == max(n))
```

```
## # A tibble: 1 x 2
##   Time       n
##   <time> <int>
## 1 17:15    128
```

                   

That will actually display *all* the times where the cyclist
count equals the maximum, of which there might be more than one.




