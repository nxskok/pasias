# Cluster analysis

Packages for this chapter:


```r
library(MASS)
library(ggbiplot)
library(tidyverse)
```



```
## Warning: package 'ggplot2' was built under R
## version 3.5.3
```

```
## Warning: package 'tibble' was built under R
## version 3.5.3
```

```
## Warning: package 'tidyr' was built under R
## version 3.5.3
```

```
## Warning: package 'readr' was built under R
## version 3.5.2
```

```
## Warning: package 'purrr' was built under R
## version 3.5.3
```

```
## Warning: package 'dplyr' was built under R
## version 3.5.2
```

```
## Warning: package 'stringr' was built under R
## version 3.5.2
```

```
## Warning: package 'forcats' was built under R
## version 3.5.1
```

```
## Warning: package 'survminer' was built under
## R version 3.5.1
```

```
## Warning: package 'ggpubr' was built under R
## version 3.5.1
```

```
## Warning: package 'magrittr' was built under R
## version 3.5.1
```

```
## Warning: package 'car' was built under R
## version 3.5.1
```

```
## Warning: package 'carData' was built under R
## version 3.5.1
```

```
## Warning: package 'ggbiplot' was built under R
## version 3.5.1
```

```
## Warning: package 'plyr' was built under R
## version 3.5.1
```

```
## Warning: package 'scales' was built under R
## version 3.5.1
```

```
## Warning: package 'ggrepel' was built under R
## version 3.5.1
```

```
## Warning: package 'broom' was built under R
## version 3.5.2
```

```
## Warning: package 'rstan' was built under R
## version 3.5.3
```

```
## Warning: package 'StanHeaders' was built
## under R version 3.5.1
```



##  Sites on the sea bed


 Biologists investigate the prevalence of
species of organism by sampling sites where the organisms might be,
taking a "grab" from the site, and sending the grabs to a laboratory
for analysis. The data in this question come from the sea bed. There
were 30 sites, labelled `s1` through `s30`. At each
site, five species of organism, labelled `a` through
`e`, were of interest; the data shown in those columns of the
data set were the number of organisms of that species identified in
the grab from that site. There are some other columns in the
(original) data set that will not concern us. Our interest is in
seeing which sites are similar to which other sites, so that a cluster
analysis will be suitable.

When the data are counts of different species, as they are here,
biologists often measure the dissimilarity in species prevalence
profiles between two sites using something called the Bray-Curtis
dissimilarity. It is not important to understand this for this
question (though I explain it in my solutions). I calculated the
Bray-Curtis dissimilarity between each pair of sites and stored the
results in [link](http://www.utsc.utoronto.ca/~butler/d29/seabed1.csv). 



(a) Read in the dissimilarity data and check that you have 30
rows and 30 columns of dissimilarities.


Solution



```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/seabed1.csv"
seabed <- read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   .default = col_double()
## )
```

```
## See spec(...) for full column specifications.
```

```r
seabed
```

```
## # A tibble: 30 x 30
##       s1    s2    s3    s4    s5    s6    s7
##    <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
##  1 0     0.457 0.296 0.467 0.477 0.522 0.455
##  2 0.457 0     0.481 0.556 0.348 0.229 0.415
##  3 0.296 0.481 0     0.467 0.508 0.522 0.491
##  4 0.467 0.556 0.467 0     0.786 0.692 0.870
##  5 0.477 0.348 0.508 0.786 0     0.419 0.212
##  6 0.522 0.229 0.522 0.692 0.419 0     0.509
##  7 0.455 0.415 0.491 0.870 0.212 0.509 0    
##  8 0.933 0.930 1     1     0.854 0.933 0.806
##  9 0.333 0.222 0.407 0.639 0.196 0.243 0.317
## 10 0.403 0.447 0.343 0.379 0.564 0.571 0.588
## # ... with 20 more rows, and 23 more
## #   variables: s8 <dbl>, s9 <dbl>,
## #   s10 <dbl>, s11 <dbl>, s12 <dbl>,
## #   s13 <dbl>, s14 <dbl>, s15 <dbl>,
## #   s16 <dbl>, s17 <dbl>, s18 <dbl>,
## #   s19 <dbl>, s20 <dbl>, s21 <dbl>,
## #   s22 <dbl>, s23 <dbl>, s24 <dbl>,
## #   s25 <dbl>, s26 <dbl>, s27 <dbl>,
## #   s28 <dbl>, s29 <dbl>, s30 <dbl>
```

     

Check. The columns are labelled with
the site names. (As I originally set this question, the data file was
read in with `read.csv` instead, and the site names were read
in as row names as well: see discussion elsewhere about row names. But
in the `tidyverse` we don't have row names.)
    


(b) Create a distance object out of your dissimilarities,
bearing in mind that the values are distances (well,
dissimilarities) already.


Solution


This one needs `as.dist` to convert already-distances into
a `dist` object. (`dist` would have
*calculated* distances from things that were not
distances/dissimilarities yet.)

```r
d <- as.dist(seabed)
```

     

If you check, you'll see that the site names are being used to label
rows *and* columns of the dissimilarity matrix as displayed. The
lack of row names is not hurting us.
    


(c) Fit a cluster analysis using single-linkage, and display a
dendrogram of the results.


Solution


This:

```r
d.1 <- hclust(d, method = "single")
plot(d.1)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-6-1} 

     

This is a base-graphics plot, it not having any of the nice
`ggplot` things. But it does the job.

Single-linkage tends to produce "stringy" clusters, since the
individual being added to a cluster only needs to be close to one
thing in the cluster. Here, that manifests itself in sites getting
added to clusters one at a time: for example, sites 25 and 26 get
joined together into a cluster, and then in sequence sites 6, 16, 27,
30 and 22 get joined on to it (rather than any of those sites being
formed into clusters first). 

You might
\marginnote{Conceivably.} be wondering what else is in that
`hclust` object, and what it's good for. Let's take a look:


```r
glimpse(d.1)
```

```
## List of 7
##  $ merge      : int [1:29, 1:2] -3 -25 -6 -9 -28 -16 -27 -1 -30 -24 ...
##  $ height     : num [1:29] 0.1 0.137 0.152 0.159 0.159 ...
##  $ order      : int [1:30] 21 14 29 23 15 1 19 18 2 7 ...
##  $ labels     : chr [1:30] "s1" "s2" "s3" "s4" ...
##  $ method     : chr "single"
##  $ call       : language hclust(d = d, method = "single")
##  $ dist.method: NULL
##  - attr(*, "class")= chr "hclust"
```

 

You might guess that `labels` contains the names of the sites,
and you'd be correct. Of the other things, the most interesting are
`merge` and `height`. Let's display them side by side:


```r
with(d.1, cbind(height, merge))
```

```
##          height        
##  [1,] 0.1000000  -3 -20
##  [2,] 0.1369863 -25 -26
##  [3,] 0.1523179  -6   2
##  [4,] 0.1588785  -9 -12
##  [5,] 0.1588785 -28   4
##  [6,] 0.1617647 -16   3
##  [7,] 0.1633987 -27   6
##  [8,] 0.1692308  -1 -19
##  [9,] 0.1807229 -30   7
## [10,] 0.1818182 -24   5
## [11,] 0.1956522  -5  10
## [12,] 0.2075472 -15   8
## [13,] 0.2083333 -14 -29
## [14,] 0.2121212  -7  11
## [15,] 0.2142857 -11   1
## [16,] 0.2149533  -2  14
## [17,] 0.2191781 -18  16
## [18,] 0.2205882 -22   9
## [19,] 0.2285714  17  18
## [20,] 0.2307692  12  19
## [21,] 0.2328767 -10  15
## [22,] 0.2558140  20  21
## [23,] 0.2658228 -23  22
## [24,] 0.2666667  13  23
## [25,] 0.3023256  -4 -13
## [26,] 0.3333333  24  25
## [27,] 0.3571429 -21  26
## [28,] 0.4285714  -8 -17
## [29,] 0.6363636  27  28
```

 

`height` is the vertical scale of the dendrogram. The first
height is 0.1, and if you look at the bottom of the dendrogram, the
first sites to be joined together are sites 3 and 20 at height 0.1
(the horizontal bar joining sites 3 and 20 is what you are looking
for). In the last two columns, which came from `merge`, you see
what got joined together, with negative numbers meaning individuals
(individual sites), and positive numbers meaning clusters formed
earlier. So, if you look at the third line, at height 0.152, site 6
gets joined to the cluster formed on line 2, which (looking back) we
see consists of sites 25 and 26. Go back now to the dendrogram; about
${3\over 4}$ of the way across, you'll see sites 25 and 26 joined
together into a cluster, and a little higher up the page, site 6 joins
that cluster.

I said that single linkage produces stringy clusters, and the way that
shows up in `merge` is that you often get an individual site
(negative number) joined onto a previously-formed cluster (positive
number). This is in contrast to Ward's method, below.
    


(d) Now fit a cluster analysis using Ward's method, and display
a dendrogram of the results.


Solution


Same thing, with small changes. The hard part is getting the name 
of the `method` right:

```r
d.2 <- hclust(d, method = "ward.D")
plot(d.2, cex = 0.7)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-9-1} 

     
The site numbers were a bit close together, so I printed them out
smaller than usual size (which is what the `cex` and a number
less than 1 is doing: 70\% of normal size).
\marginnote{This is base-graphics code, which I learned a long time ago. There are a lot of options with weird names that are hard to remember, and that are sometimes inconsistent with each other. There is a package *ggdendro* that makes nice *ggplot* dendrograms, and another called *dendextend* that does all kinds of stuff with dendrograms. I decided that it wasn't worth the trouble of teaching you (and therefore me) *ggdendro*, since the dendrograms look much the same.}
This time, there is a greater tendency for sites to be joined into
small clusters first, then these small clusters are joined
together. It's not perfect, but there is a greater tendency for it to
happen here.

This shows up in `merge` too:


```r
d.2$merge
```

```
##       [,1] [,2]
##  [1,]   -3  -20
##  [2,]  -25  -26
##  [3,]   -9  -12
##  [4,]  -28    3
##  [5,]   -1  -19
##  [6,]   -6    2
##  [7,]  -14  -29
##  [8,]   -5   -7
##  [9,]  -18  -24
## [10,]  -27    6
## [11,]  -16  -22
## [12,]   -2    4
## [13,]  -30   10
## [14,]  -15    5
## [15,]  -23    8
## [16,]   -4  -13
## [17,]  -11    1
## [18,]    9   12
## [19,]  -10   17
## [20,]   -8  -17
## [21,]   11   13
## [22,]  -21   15
## [23,]    7   22
## [24,]   14   19
## [25,]   16   24
## [26,]   18   21
## [27,]   20   23
## [28,]   26   27
## [29,]   25   28
```

 

There are relatively few instances of a site being joined to a cluster
of sites. Usually, individual sites get joined together (negative with
a negative, mainly at the top of the list), or clusters get joined to
clusters (positive with positive, mainly lower down the list).
    


(e) <a name="part:prefclust">*</a> On the Ward's method clustering, how many clusters would you
choose to divide the sites into? Draw rectangles around those clusters.



Solution


You may need to draw the plot again. In any case, a second line of
code draws the rectangles. I think three clusters is good, but you
can have a few more than that if you like:

```r
plot(d.2, cex = 0.7)
rect.hclust(d.2, 3)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-11-1} 

   

What I want to see is a not-unreasonable choice of number of clusters
(I think you could go up to about six), and then a depiction of that
number of clusters on the plot. This is six clusters:


```r
plot(d.2, cex = 0.7)
rect.hclust(d.2, 6)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-12-1} 

   

In all your plots, the `cex` is optional, but you can compare
the plots with it and without it and see which you prefer.

Looking at this, even seven clusters might work, but I doubt you'd
want to go beyond that. The choice of the number of clusters is mainly
an aesthetic
\marginnote{This, I think, is the British spelling, with the  North American one being *esthetic*. My spelling is where the  *aes* in a *ggplot* comes from.} decision. 

  


(f) <a name="part:original">*</a> The original data is in
[link](http://www.utsc.utoronto.ca/~butler/d29/seabed.csv). Read in the
original data and verify that you again have 30 sites, variables
called `a` through `e` and some others.



Solution


This is really a very cheap two points:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/seabed.csv"
seabed.z <- read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   site = col_character(),
##   a = col_double(),
##   b = col_double(),
##   c = col_double(),
##   d = col_double(),
##   e = col_double(),
##   depth = col_double(),
##   pollution = col_double(),
##   temp = col_double(),
##   sediment = col_character()
## )
```

```r
seabed.z
```

```
## # A tibble: 30 x 10
##    site      a     b     c     d     e depth
##    <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
##  1 s1        0     2     9    14     2    72
##  2 s2       26     4    13    11     0    75
##  3 s3        0    10     9     8     0    59
##  4 s4        0     0    15     3     0    64
##  5 s5       13     5     3    10     7    61
##  6 s6       31    21    13    16     5    94
##  7 s7        9     6     0    11     2    53
##  8 s8        2     0     0     0     1    61
##  9 s9       17     7    10    14     6    68
## 10 s10       0     5    26     9     0    69
## # ... with 20 more rows, and 3 more
## #   variables: pollution <dbl>, temp <dbl>,
## #   sediment <chr>
```

   

30 observations of 10 variables, including `a` through
`e`. Check.

I gave this a weird name so that it didn't overwrite my original
`seabed`, the one I turned into a distance object, though I
don't think I really needed to worry.

These data came from
[link](http://www.fbbva.es/TLFU/dat/DE_2013_multivariate.pdf),
\marginnote{If  you are a soccer fan, you might recognize BBVA as a former sponsor  of the top Spanish soccer league, *La Liga BBVA* (as it was). BBVA  is a Spanish bank that also has a Foundation that published this  book.} from which I also got the definition of the Bray-Curtis
dissimilarity that I calculated for you. The data are in Exhibit 1.1
of that book.

  


(g) Go back to your Ward method dendrogram with the red
rectangles and find two sites in the same cluster. Display the
original data for your two sites and see if you can explain why they
are in the same cluster. It doesn't matter which two sites you choose;
the grader will merely check that your results look reasonable.



Solution


I want my two sites to be very similar, so I'm looking at two sites
that were joined into a cluster very early on, sites `s3` and
`s20`. As I said, I don't mind which ones you pick, but being
in the same cluster will be easiest to justify if you pick sites
that were joined together early.
Then you need to display just those rows of the original data (that
you just read in), which is a `filter` with an "or" in it:

```r
seabed.z %>% filter(site == "s3" | site == "s20")
```

```
## # A tibble: 2 x 10
##   site      a     b     c     d     e depth
##   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 s3        0    10     9     8     0    59
## 2 s20       0    10    14     9     0    73
## # ... with 3 more variables:
## #   pollution <dbl>, temp <dbl>,
## #   sediment <chr>
```

   

I think this odd-looking thing also works:


```r
seabed.z %>% filter(site %in% c("s3", "s20"))
```

```
## # A tibble: 2 x 10
##   site      a     b     c     d     e depth
##   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 s3        0    10     9     8     0    59
## 2 s20       0    10    14     9     0    73
## # ... with 3 more variables:
## #   pollution <dbl>, temp <dbl>,
## #   sediment <chr>
```

 

I'll also take displaying the lines one at a time, though it is easier
to compare them if they are next to each other.

Why are they in the same cluster? To be similar (that is, have a low
dissimilarity), the values of `a` through `e` should be
close together. Here, they certainly are: `a` and `e`
are both zero for both sites, and `b`, `c` and
`d` are around 10 for both sites. So I'd call that similar. 

You will probably pick a different pair of sites, and thus your
detailed discussion will differ from mine, but the general point of it
should be the same: pick a pair of sites in the same cluster (1 mark),
display those two rows of the original data (1 mark), some sensible
discussion of how the sites are similar (1 mark). As long as you pick
two sites in the same one of your clusters, I don't mind which ones
you pick. The grader will check that your two sites were indeed in the
same one of your clusters, then will check that you do indeed display
those two sites from the original data.

What happens if you pick sites from different clusters? Let's pick two
very dissimilar ones, sites 4 and 7 from opposite ends of my dendrogram:


```r
seabed.z %>% filter(site == "s4" | site == "s7")
```

```
## # A tibble: 2 x 10
##   site      a     b     c     d     e depth
##   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 s4        0     0    15     3     0    64
## 2 s7        9     6     0    11     2    53
## # ... with 3 more variables:
## #   pollution <dbl>, temp <dbl>,
## #   sediment <chr>
```

 

Site `s4` has no `a` or `b` at all, and site
`s7` has quite a few; site `s7` has no `c` at
all, while site `s4` has a lot. These are very different sites.

Extra: now that you've seen what the original data look like, I should
explain how I got the Bray-Curtis dissimilarities. As I said, only the
counts of species `a` through `e` enter into the
calculation; the other variables have nothing to do with it.

Let's simplify matters by pretending that we have only two species (we
can call them A and B), and a vector like this:


```r
v1 <- c(10, 3)
```

 

which says that we have 10 organisms of species A and 3 of species B
at a site. This is rather similar to this site:


```r
v2 <- c(8, 4)
```

 

but very different from this site:


```r
v3 <- c(0, 7)
```

 

The way you calculate the Bray-Curtis dissimilarity is to take the
absolute difference of counts of organisms of each species:


```r
abs(v1 - v2)
```

```
## [1] 2 1
```

 

and add those up:


```r
sum(abs(v1 - v2))
```

```
## [1] 3
```

 

and then divide by the total of all the frequencies:


```r
sum(abs(v1 - v2))/sum(v1 + v2)
```

```
## [1] 0.12
```

 

The smaller this number is, the more similar the sites are. So you
might imagine that `v1` and `v3` would be more dissimilar:


```r
sum(abs(v1 - v3))/sum(v1 + v3)
```

```
## [1] 0.7
```

 

and so it is. The scaling of the Bray-Curtis dissimilarity is that the
smallest it can be is 0, if the frequencies of each of the species are
exactly the same at the two sites, and the largest it can be is 1, if
one site has only species A and the other has only species B. (I'll
demonstrate that in a moment.)
You might imagine that we'll be doing this calculation a lot, and so
we should define a function to automate it. Hadley Wickham 
(in "R for Data Science") says that you should copy and paste some code (as
I did above) no more than twice; if you need to do it again, you
should write a function instead. The thinking behind this is if you
copy and paste and change something (like a variable name), you'll
need to make the change *everywhere*, and it's so easy to miss
one. 
So, my function is (copying and pasting my code from above into the
body of the function, which is Wickham-approved since it's only my
second time):


```r
braycurtis <- function(v1, v2) {
    sum(abs(v1 - v2))/sum(v1 + v2)
}
```

 

Let's test it on my made-up sites, making up one more:


```r
braycurtis(v1, v2)
```

```
## [1] 0.12
```

```r
braycurtis(v1, v3)
```

```
## [1] 0.7
```

```r
braycurtis(v2, v2)
```

```
## [1] 0
```

```r
v4 <- c(4, 0)
braycurtis(v3, v4)
```

```
## [1] 1
```

 

These all check out. The first two are repeats of the ones we did
before. The third one says that if you calculate Bray-Curtis for two
sites with the exact same frequencies all the way along, you get the
minimum value of 0; the fourth one says that when site `v3`
only has species B and site `v4` only has species A, you get
the maximum value of 1.

But note this:


```r
v2
```

```
## [1] 8 4
```

```r
2 * v2
```

```
## [1] 16  8
```

```r
braycurtis(v2, 2 * v2)
```

```
## [1] 0.3333333
```

 

You might say that `v2` and `2*v2` are the same
distribution, and so they are, proportionately. But Bray-Curtis is
assessing whether the frequencies are *the same* (as opposed to
something like a chi-squared test that is assessing
proportionality).
\marginnote{You could make a table out of the sites and  species, and use the test statistic from a chi-squared test as a  measure of dissimilarity: the smallest it can be is zero, if the  species counts are exactly proportional at the two sites. It doesn't have an upper limit.}

So far so good. Now we have to do this for the actual data. The first
issue
\marginnote{There are more issues.}  is that the data is some of the
row of the original data frame; specifically, it's columns 2 through
6. For example, sites `s3` and `s20` of the original
data frame look like this:


```r
seabed.z %>% filter(site == "s3" | site == "s20")
```

```
## # A tibble: 2 x 10
##   site      a     b     c     d     e depth
##   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 s3        0    10     9     8     0    59
## 2 s20       0    10    14     9     0    73
## # ... with 3 more variables:
## #   pollution <dbl>, temp <dbl>,
## #   sediment <chr>
```

 

and we don't want to feed the whole of those into `braycurtis`,
just the second through sixth elements of them. So let's write another
function that extracts the columns `a` through `e` of its
inputs for given rows, and passes those on to the `braycurtis`
that we wrote before. This is a little fiddly, but bear with me. The
input to the function is the data frame, then the two sites that we want:
First, though, what happens if `filter` site `s3`?


```r
seabed.z %>% filter(site == "s3")
```

```
## # A tibble: 1 x 10
##   site      a     b     c     d     e depth
##   <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1 s3        0    10     9     8     0    59
## # ... with 3 more variables:
## #   pollution <dbl>, temp <dbl>,
## #   sediment <chr>
```

 
This is a one-row data frame, not a vector as our function expects. 
Do we need to worry about it? First, grab the right columns, so that we will know what our function has to do:

```r
seabed.z %>% filter(site == "s3") %>% select(a:e)
```

```
## # A tibble: 1 x 5
##       a     b     c     d     e
##   <dbl> <dbl> <dbl> <dbl> <dbl>
## 1     0    10     9     8     0
```

 

That leads us to this function, which is a bit repetitious, but for
two repeats I can handle it. I haven't done anything about the fact
that `x` and `y` below are actually data frames:

```r
braycurtis.spec <- function(d, i, j) {
    x <- d %>% filter(site == i) %>% select(a:e)
    y <- d %>% filter(site == j) %>% select(a:e)
    braycurtis(x, y)
}
```

 
The first time I did this, I had the `filter` and the
`select` in the opposite order, so I was neatly *removing*
the column I wanted to `filter` by *before* I did the
`filter`!

The first two lines pull out columns `a` through `e` of
(respectively) sites `i` and `j`.

If I were going to create more than two things like `x` and
`y`, I would have hived that off
into a separate function as well, but I didn't.

Sites 3 and 20 were the two sites I chose before as being similar ones (in the
same cluster). So the dissimilarity should be small:


```r
braycurtis.spec(seabed.z, "s3", "s20")
```

```
## [1] 0.1
```

 

and so it is. Is it about right? The `c` differ by 5, the
`d` differ by one, and the total frequency in both rows is
about 60, so the dissimilarity should be about $6/60=0.1$, as it is
(exactly, in fact). 

This, you will note, works. I think R has taken the attitude that it
can treat these one-row data frames as if they were vectors.
This is the cleaned-up version of my function. When I first wrote it,
I `print`ed out `x` and `y`, so that I could
check that they were what I was expecting (they were).
\marginnote{I am a  paid-up member of the *print all the things* school of  debugging. You probably know how to do this better.}
We have almost all the machinery we need. Now what we have to do is to
compare every site with every other site and compute the dissimilarity
between them. If you're used to Python or another similar language,
you'll recognize this as two loops, one inside the other. This can be done in R (and I'll show you how), but I'd rather show you the Tidyverse way first.

The starting point is to make a vector containing all the sites, which
is easier than you would guess:


```r
sites <- str_c("s", 1:30)
sites
```

```
##  [1] "s1"  "s2"  "s3"  "s4"  "s5"  "s6" 
##  [7] "s7"  "s8"  "s9"  "s10" "s11" "s12"
## [13] "s13" "s14" "s15" "s16" "s17" "s18"
## [19] "s19" "s20" "s21" "s22" "s23" "s24"
## [25] "s25" "s26" "s27" "s28" "s29" "s30"
```

 

Next, we need to make all possible *pairs* of sites, which we
also know how to do:


```r
site_pairs <- crossing(site1 = sites, site2 = sites)
site_pairs
```

```
## # A tibble: 900 x 2
##    site1 site2
##    <chr> <chr>
##  1 s1    s1   
##  2 s1    s10  
##  3 s1    s11  
##  4 s1    s12  
##  5 s1    s13  
##  6 s1    s14  
##  7 s1    s15  
##  8 s1    s16  
##  9 s1    s17  
## 10 s1    s18  
## # ... with 890 more rows
```

 
Now, think about what to do in English first: "for each of the sites in `site1`, and for each of the sites in `site2`, taken in parallel, work out the Bray-Curtis distance."  This is, I hope,
making you think of `map`. Two details: the Bray-Curtis
distance is a (decimal) number, and we're for-eaching over two things in
parallel, so `map2_dbl`:

```r
bc <- site_pairs %>% mutate(bray_curtis = map2_dbl(site1, 
    site2, ~braycurtis.spec(seabed.z, .x, .y)))
bc
```

```
## # A tibble: 900 x 3
##    site1 site2 bray_curtis
##    <chr> <chr>       <dbl>
##  1 s1    s1          0    
##  2 s1    s10         0.403
##  3 s1    s11         0.357
##  4 s1    s12         0.375
##  5 s1    s13         0.577
##  6 s1    s14         0.633
##  7 s1    s15         0.208
##  8 s1    s16         0.857
##  9 s1    s17         1    
## 10 s1    s18         0.569
## # ... with 890 more rows
```

 

Remember that we have two "it"s to iterate over, so they get called
`.x` and `.y` rather than just `.`, so you can
tell them apart.

This is a "long" data frame, but for the cluster analysis, we need a wide one with sites in rows and columns, so let's create that:


```r
(bc2 <- bc %>% spread(site2, bray_curtis))
```

```
## # A tibble: 30 x 31
##    site1    s1   s10   s11   s12   s13   s14
##    <chr> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
##  1 s1    0     0.403 0.357 0.375 0.577 0.633
##  2 s10   0.403 0     0.449 0.419 0.415 0.710
##  3 s11   0.357 0.449 0     0.463 0.481 0.765
##  4 s12   0.375 0.419 0.463 0     0.667 0.413
##  5 s13   0.577 0.415 0.481 0.667 0     1    
##  6 s14   0.633 0.710 0.765 0.413 1     0    
##  7 s15   0.208 0.424 0.491 0.342 0.608 0.458
##  8 s16   0.857 0.856 0.66  0.548 0.875 0.656
##  9 s17   1     1     1     0.860 1     0.692
## 10 s18   0.569 0.380 0.627 0.254 0.667 0.604
## # ... with 20 more rows, and 24 more
## #   variables: s15 <dbl>, s16 <dbl>,
## #   s17 <dbl>, s18 <dbl>, s19 <dbl>,
## #   s2 <dbl>, s20 <dbl>, s21 <dbl>,
## #   s22 <dbl>, s23 <dbl>, s24 <dbl>,
## #   s25 <dbl>, s26 <dbl>, s27 <dbl>,
## #   s28 <dbl>, s29 <dbl>, s3 <dbl>,
## #   s30 <dbl>, s4 <dbl>, s5 <dbl>, s6 <dbl>,
## #   s7 <dbl>, s8 <dbl>, s9 <dbl>
```

 

That's the data frame I shared with you.

The more Python-like way of doing it is a loop inside a loop. This
works in R, but it has more housekeeping and a few possibly unfamiliar
ideas. We are going to work with a `matrix`, and we access
elements of a matrix with two numbers inside square brackets, a row
number and a column number. We also have to initialize our matrix that
we're going to fill with Bray-Curtis distances; I'll fill it with $-1$
values, so that if any are left at the end, I'll know I missed
something.

```r
m <- matrix(-1, 30, 30)
for (i in 1:30) {
    for (j in 1:30) {
        m[i, j] <- braycurtis.spec(seabed.z, sites[i], 
            sites[j])
    }
}
rownames(m) <- sites
colnames(m) <- sites
head(m)
```

```
##           s1        s2        s3        s4
## s1 0.0000000 0.4567901 0.2962963 0.4666667
## s2 0.4567901 0.0000000 0.4814815 0.5555556
## s3 0.2962963 0.4814815 0.0000000 0.4666667
## s4 0.4666667 0.5555556 0.4666667 0.0000000
## s5 0.4769231 0.3478261 0.5076923 0.7857143
## s6 0.5221239 0.2285714 0.5221239 0.6923077
##           s5        s6        s7        s8
## s1 0.4769231 0.5221239 0.4545455 0.9333333
## s2 0.3478261 0.2285714 0.4146341 0.9298246
## s3 0.5076923 0.5221239 0.4909091 1.0000000
## s4 0.7857143 0.6923077 0.8695652 1.0000000
## s5 0.0000000 0.4193548 0.2121212 0.8536585
## s6 0.4193548 0.0000000 0.5087719 0.9325843
##           s9       s10       s11       s12
## s1 0.3333333 0.4029851 0.3571429 0.3750000
## s2 0.2222222 0.4468085 0.5662651 0.2149533
## s3 0.4074074 0.3432836 0.2142857 0.3250000
## s4 0.6388889 0.3793103 0.5319149 0.5492958
## s5 0.1956522 0.5641026 0.3731343 0.3186813
## s6 0.2428571 0.5714286 0.5304348 0.2374101
##          s13       s14       s15       s16
## s1 0.5769231 0.6326531 0.2075472 0.8571429
## s2 0.6708861 0.4210526 0.3750000 0.4720000
## s3 0.6538462 0.6734694 0.3584906 0.7346939
## s4 0.3023256 0.8500000 0.4090909 0.9325843
## s5 0.7142857 0.2666667 0.4687500 0.5045872
## s6 0.6756757 0.5925926 0.5357143 0.2484076
##          s17       s18       s19       s20
## s1 1.0000000 0.5689655 0.1692308 0.3333333
## s2 0.8620690 0.3146853 0.3695652 0.4022989
## s3 1.0000000 0.5344828 0.3230769 0.1000000
## s4 1.0000000 0.6635514 0.4642857 0.3333333
## s5 0.8095238 0.5118110 0.3947368 0.5211268
## s6 0.9111111 0.2571429 0.3870968 0.4621849
##          s21       s22       s23       s24
## s1 0.7333333 0.7346939 0.4411765 0.5714286
## s2 0.6666667 0.3760000 0.5368421 0.2432432
## s3 0.8222222 0.6326531 0.5294118 0.3809524
## s4 0.8333333 0.9325843 0.8644068 0.5200000
## s5 0.3571429 0.3761468 0.2658228 0.4105263
## s6 0.6730769 0.2993631 0.4488189 0.3006993
##          s25       s26       s27       s28
## s1 0.7037037 0.6956522 0.6363636 0.3250000
## s2 0.3925926 0.3277311 0.3809524 0.2149533
## s3 0.6666667 0.6086957 0.6363636 0.5000000
## s4 0.9393939 0.9277108 0.9333333 0.5774648
## s5 0.5294118 0.4174757 0.3818182 0.3186813
## s6 0.1856287 0.1523179 0.2151899 0.2949640
##          s29       s30
## s1 0.4339623 0.6071429
## s2 0.3500000 0.3669065
## s3 0.4339623 0.5892857
## s4 0.5454545 0.8446602
## s5 0.3125000 0.4796748
## s6 0.5357143 0.2163743
```

 

Because my loops work with site *numbers* and my function works
with site *names*, I have to remember to refer to the site names
when I call my function. I also have to supply row and column names
(the site names).

That looks all right. Are all my Bray-Curtis distances between 0 and 1? I can smoosh my matrix into a vector and summarize it:


```r
summary(as.vector(m))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu. 
##  0.0000  0.3571  0.5023  0.5235  0.6731 
##    Max. 
##  1.0000
```

 
All the
dissimilarities are correctly between 0 and 1. We can also check the
one we did before:


```r
bc2 %>% filter(site1 == "s3") %>% select(s20)
```

```
## # A tibble: 1 x 1
##     s20
##   <dbl>
## 1   0.1
```

 

or


```r
m[3, 20]
```

```
## [1] 0.1
```

 

Check.
  


(h) Obtain the cluster memberships for each site, for your
preferred number of clusters from part (<a href="#part:prefclust">here</a>). Add a
column to the original data that you read in, in part
(<a href="#part:original">here</a>), containing those cluster memberships, \emph{as a
factor}.  Obtain a plot that will enable you to assess the
relationship between those clusters and `pollution`. (Once you
have the cluster memberships, you can add them to the data frame and
make the graph using a pipe.)  What do you see?



Solution


Start by getting the clusters with `cutree`. I'm going with 3
clusters, though you can use the number of clusters you chose
before. (This is again making the grader's life a misery, but her
instructions from me are to check that you have done something
reasonable, with the actual answer being less important.) 


```r
cluster <- cutree(d.2, 3)
cluster
```

```
##  s1  s2  s3  s4  s5  s6  s7  s8  s9 s10 s11 
##   1   2   1   1   3   2   3   3   2   1   1 
## s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 
##   2   1   3   1   2   3   2   1   1   3   2 
## s23 s24 s25 s26 s27 s28 s29 s30 
##   3   2   2   2   2   2   3   2
```

 

Now, we add that to the original data, the data frame I called
`seabed.z`, and make a plot. The best one is a boxplot:


```r
seabed.z %>% mutate(cluster = factor(cluster)) %>% 
    ggplot(aes(x = cluster, y = pollution)) + 
    geom_boxplot()
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-41-1} 

 

The clusters differ substantially in terms of the amount of pollution,
with my cluster 1 being highest and my cluster 2 being
lowest. (Cluster 3 has a low outlier.)

Any sensible plot will do here. I think boxplots are the best, but you
could also do something like vertically-faceted histograms:


```r
seabed.z %>% mutate(cluster = factor(cluster)) %>% 
    ggplot(aes(x = pollution)) + geom_histogram(bins = 8) + 
    facet_grid(cluster ~ .)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-42-1} 

 

which to my mind doesn't show the differences as dramatically. (The bins are
determined from all the data together, so that each facet actually has
fewer than 8 bins. You can see where the bins would be if they had any
data in them.)

Here's how 5 clusters looks:


```r
cluster <- cutree(d.2, 5)
cluster
```

```
##  s1  s2  s3  s4  s5  s6  s7  s8  s9 s10 s11 
##   1   2   1   1   3   4   3   5   2   1   1 
## s12 s13 s14 s15 s16 s17 s18 s19 s20 s21 s22 
##   2   1   3   1   4   5   2   1   1   3   4 
## s23 s24 s25 s26 s27 s28 s29 s30 
##   3   2   4   4   4   2   3   4
```

```r
seabed.z %>% mutate(cluster = factor(cluster)) %>% 
    ggplot(aes(x = cluster, y = pollution)) + 
    geom_boxplot()
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-43-1} 

 

This time, the picture isn't quite so clear-cut, but clusters 1 and 5
are the highest in terms of pollution and cluster 4 is the lowest. I'm
guessing that whatever number of clusters you choose, you'll see some
differences in terms of pollution.
What is interesting is that `pollution` had *nothing* to
do with the original formation of the clusters: that was based only on
which species were found at each site. So, what we have shown here is that
the amount of pollution has some association with what species are found at a
site. 

A way to go on with this is to use the clusters as "known groups"
and predict the cluster membership from `depth`,
`pollution` and `temp` using a discriminant
analysis. Then you could plot the sites, colour-coded by what cluster
they were in, and even though you had three variables, you could plot
it in two dimensions (or maybe even one dimension, depending how many
LD's were important). 

  








##  Dissimilarities between fruits


 Consider the fruits apple, orange, banana, pear,
strawberry, blueberry. We are going to work with these four
properties of fruits:


* has a round shape

* Is sweet

* Is crunchy

* Is a berry



(a)  Make a table with fruits as columns, and with
rows "round shape", "sweet", "crunchy", "berry". In each cell
of the table, put a 1 if the fruit has the property named in the
row, and a 0 if it does not. (This is your opinion, and may not
agree with mine. That doesn't matter, as long as you follow through
with whatever your choices were.)
 
Solution


Something akin to this:


```

Fruit        Apple Orange Banana Pear Strawberry Blueberry
Round shape    1      1      0     0       0         1
Sweet          1      1      0     0       1         0
Crunchy        1      0      0     1       0         0
Berry          0      0      0     0       1         1

```

You'll have to make a choice about "crunchy". I usually eat
pears before they're fully ripe, so to me, they're crunchy.
 

(b) We'll define the dissimilarity between two fruits to be the
number of qualities they *disagree* on. Thus, for example, the
dissimilarity between Apple and Orange is 1 (an apple is crunchy and
an orange is not, but they agree on everything else). Calculate the
dissimilarity between each pair of fruits, and make a square table
that summarizes the results. (To save yourself some work, note that
the dissimilarity between a fruit and itself must be zero, and the
dissimilarity between fruits A and B is the same as that between B
and A.) Save your table of dissimilarities into a file for the next part.
 
Solution


I got this, by counting them:

```
 
Fruit         Apple  Orange   Banana   Pear  Strawberry  Blueberry
Apple           0       1       3       2        3          3
Orange          1       0       2       3        2          2
Banana          3       2       0       1        2          2
Pear            2       3       1       0        3          3
Strawberry      3       2       2       3        0          2
Blueberry       3       2       2       3        2          0

```

I copied this into a file `fruits.txt`. Note that (i) I
have aligned my columns, so that I will be able to use
`read_table` later, and (ii) I have given the first column
a name, since `read_table` wants the same number of column
names as columns.

Extra: yes, you can do this in R too. We've seen some of the tricks
before. 

Let's start by reading in my table of fruits and properties, which
I saved in
[link](http://www.utsc.utoronto.ca/~butler/d29/fruit1.txt):

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/fruit1.txt"
fruit1 <- read_table(my_url)
```

```
## Parsed with column specification:
## cols(
##   Property = col_character(),
##   Apple = col_double(),
##   Orange = col_double(),
##   Banana = col_double(),
##   Pear = col_double(),
##   Strawberry = col_double(),
##   Blueberry = col_double()
## )
```

```r
fruit1
```

```
## # A tibble: 4 x 7
##   Property Apple Orange Banana  Pear
##   <chr>    <dbl>  <dbl>  <dbl> <dbl>
## 1 Round.s~     1      1      0     0
## 2 Sweet        1      1      0     0
## 3 Crunchy      1      0      0     1
## 4 Berry        0      0      0     0
## # ... with 2 more variables:
## #   Strawberry <dbl>, Blueberry <dbl>
```

     

We don't need the first column, so we'll get rid of it:


```r
fruit2 <- fruit1 %>% select(-Property)
fruit2
```

```
## # A tibble: 4 x 6
##   Apple Orange Banana  Pear Strawberry
##   <dbl>  <dbl>  <dbl> <dbl>      <dbl>
## 1     1      1      0     0          0
## 2     1      1      0     0          1
## 3     1      0      0     1          0
## 4     0      0      0     0          1
## # ... with 1 more variable: Blueberry <dbl>
```

 

The loop way is the most direct. We're going to be looking at
combinations of fruits and other fruits, so we'll need two loops one
inside the other. It's easier for this to work with column numbers,
which here are 1 through 6, and we'll make a matrix `m` with
the dissimilarities in it, which we have to initialize first. I'll
initialize it to a $6\times 6$ matrix of `-1`, since the final
dissimilarities are 0 or bigger, and this way I'll know if I forgot
anything.

Here's where we are at so far:


```r
fruit_m <- matrix(-1, 6, 6)
for (i in 1:6) {
    for (j in 1:6) {
        fruit_m[i, j] <- 3  # dissim between fruit i and fruit j
    }
}
```

 

This, of course, doesn't run yet. The sticking point is how to
calculate the dissimilarity between two columns. I think that is a
separate thought process that should be in a function of its own. The
inputs are the two column numbers, and a data frame to get those
columns from:


```r
dissim <- function(i, j, d) {
    x <- d %>% select(i)
    y <- d %>% select(j)
    sum(x != y)
}
dissim(1, 2, fruit2)
```

```
## [1] 1
```

 

Apple and orange differ by one (not being crunchy). The process is:
grab the $i$-th column and call it `x`, grab the $j$-th column
and call it `y`. These are two one-column data frames with four
rows each (the four properties). `x!=y` goes down the rows, and
for each one gives a `TRUE` if they're different and a
`FALSE` if they're the same. So `x!=y` is a collection
of four T-or-F values. This seems backwards, but I was thinking of
what we want to do: we want to count the number of different
ones. Numerically, `TRUE` counts as 1 and `FALSE` as 0,
so we should make the thing we're counting (the different ones) come
out as `TRUE`. To count the number of `TRUE`s (1s), add
them up. 

That was a complicated thought process, so it was probably wise to
write a function to do it. Now, in our loop, we only have to call the
function (having put some thought into getting it right):


```r
fruit_m <- matrix(-1, 6, 6)
for (i in 1:6) {
    for (j in 1:6) {
        fruit_m[i, j] <- dissim(i, j, fruit2)
    }
}
fruit_m
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6]
## [1,]    0    1    3    2    3    3
## [2,]    1    0    2    3    2    2
## [3,]    3    2    0    1    2    2
## [4,]    2    3    1    0    3    3
## [5,]    3    2    2    3    0    2
## [6,]    3    2    2    3    2    0
```

 

The last step is re-associate the fruit names with this matrix. This
is a `matrix` so it has a `rownames` and a
`colnames`. We set both of those, but first we have to get the
fruit names from `fruit2`:


```r
fruit_names <- names(fruit2)
rownames(fruit_m) <- fruit_names
colnames(fruit_m) <- fruit_names
fruit_m
```

```
##            Apple Orange Banana Pear
## Apple          0      1      3    2
## Orange         1      0      2    3
## Banana         3      2      0    1
## Pear           2      3      1    0
## Strawberry     3      2      2    3
## Blueberry      3      2      2    3
##            Strawberry Blueberry
## Apple               3         3
## Orange              2         2
## Banana              2         2
## Pear                3         3
## Strawberry          0         2
## Blueberry           2         0
```

 

This is good to go into the cluster analysis (happening later).

There is a `tidyverse` way to do this also. It's actually a lot
like the loop way in its conception, but the coding looks
different. We start by making all combinations of the fruit names with
each other, which is `crossing`:


```r
combos <- crossing(fruit = fruit_names, other = fruit_names)
combos
```

```
## # A tibble: 36 x 2
##    fruit  other     
##    <chr>  <chr>     
##  1 Apple  Apple     
##  2 Apple  Banana    
##  3 Apple  Blueberry 
##  4 Apple  Orange    
##  5 Apple  Pear      
##  6 Apple  Strawberry
##  7 Banana Apple     
##  8 Banana Banana    
##  9 Banana Blueberry 
## 10 Banana Orange    
## # ... with 26 more rows
```

 

Now, we want a function that, given any two fruit *names*, works
out the dissimilarity between them. A happy coincidence is that we can
use the function we had before, *unmodified*! How? Take a look: 


```r
dissim <- function(i, j, d) {
    x <- d %>% select(i)
    y <- d %>% select(j)
    sum(x != y)
}
dissim("Apple", "Orange", fruit2)
```

```
## [1] 1
```

 

`select` can take a column number *or a column name*, so
that running it with column names gives the right answer.

Now, we want to run this function for each of the pairs in
`combos`. The "for each" is `fruit` and `other`
in parallel, so it's `map2` rather than `map`. Also, the
dissimilarity is a whole number each time, so we need
`map2_int`. So we can do this:


```r
combos %>% mutate(dissim = map2_int(fruit, other, 
    dissim, fruit2))
```

```
## # A tibble: 36 x 3
##    fruit  other      dissim
##    <chr>  <chr>       <int>
##  1 Apple  Apple           0
##  2 Apple  Banana          3
##  3 Apple  Blueberry       3
##  4 Apple  Orange          1
##  5 Apple  Pear            2
##  6 Apple  Strawberry      3
##  7 Banana Apple           3
##  8 Banana Banana          0
##  9 Banana Blueberry       2
## 10 Banana Orange          2
## # ... with 26 more rows
```

 

This would work just as well using `fruit1` rather than
`fruit`, since we are picking out the columns by name rather
than number.

To make this into something we can turn into a `dist` object
later, we need to `spread` the column `other` to make a
square array:


```r
fruit_spread <- combos %>% mutate(dissim = map2_int(fruit, 
    other, dissim, fruit2)) %>% spread(other, 
    dissim)
fruit_spread
```

```
## # A tibble: 6 x 7
##   fruit Apple Banana Blueberry Orange  Pear
##   <chr> <int>  <int>     <int>  <int> <int>
## 1 Apple     0      3         3      1     2
## 2 Bana~     3      0         2      2     1
## 3 Blue~     3      2         0      2     3
## 4 Oran~     1      2         2      0     3
## 5 Pear      2      1         3      3     0
## 6 Stra~     3      2         2      2     3
## # ... with 1 more variable: Strawberry <int>
```

 

Done!
 

(c) Do a hierarchical cluster analysis using complete
linkage. Display your dendrogram.
 
Solution


First, we need to take one of our matrices of dissimilarities
and turn it into a `dist` object. Since I asked you to
save yours into a file, let's start from there. Mine is aligned
columns: 

```r
dissims <- read_table("fruits.txt")
```

```
## Parsed with column specification:
## cols(
##   fruit = col_character(),
##   Apple = col_double(),
##   Orange = col_double(),
##   Banana = col_double(),
##   Pear = col_double(),
##   Strawberry = col_double(),
##   Blueberry = col_double()
## )
```

```r
dissims
```

```
## # A tibble: 6 x 7
##   fruit Apple Orange Banana  Pear Strawberry
##   <chr> <dbl>  <dbl>  <dbl> <dbl>      <dbl>
## 1 Apple     0      1      3     2          3
## 2 Oran~     1      0      2     3          2
## 3 Bana~     3      2      0     1          2
## 4 Pear      2      3      1     0          3
## 5 Stra~     3      2      2     3          0
## 6 Blue~     3      2      2     3          2
## # ... with 1 more variable: Blueberry <dbl>
```

      

Then turn it into a `dist` object. The first step is to take
off the first column, since `as.dist` can get the names from
the columns:


```r
d <- dissims %>% select(-fruit) %>% as.dist()
d
```

```
##            Apple Orange Banana Pear
## Orange         1                   
## Banana         3      2            
## Pear           2      3      1     
## Strawberry     3      2      2    3
## Blueberry      3      2      2    3
##            Strawberry
## Orange               
## Banana               
## Pear                 
## Strawberry           
## Blueberry           2
```



If you forget to take off the first column, this happens:


```r
as.dist(dissims)
```

```
## Warning in storage.mode(m) <- "numeric": NAs
## introduced by coercion
```

```
## Warning in as.dist.default(dissims): non-
## square matrix
```

```
## Error in dimnames(df) <- if (is.null(labels)) list(seq_len(size), seq_len(size)) else list(labels, : length of 'dimnames' [1] not equal to array extent
```

 

The key thing here is "non-square matrix": you have one more column
than you have rows, since you have a column of fruit names.

This one is `as.dist` since you already have dissimilarities
and you want to arrange them into the right type of
thing. `dist` is for *calculating* dissimilarities, which
we did before, so we don't want to do that now.

Now, after all that work, the actual cluster analysis and dendrogram:

```r
fruits.1 <- hclust(d, method = "complete")
plot(fruits.1)
```


\includegraphics{22-thingy_files/figure-latex/hkadh-1} 

     
 

(d) How many clusters, of what fruits, do you seem to have?
Explain briefly.
 
Solution


I reckon I have three clusters: strawberry and blueberry in one,
apple and orange in the second, and banana and pear in the
third. (If your dissimilarities were different from mine, your
dendrogram will be different also.)
 

(e) Pick a pair of clusters (with at least 2 fruits in each)
from your dendrogram. Verify that 
the complete-linkage distance on your dendrogram is correct.
 
Solution


I'll pick strawberry-blueberry and and apple-orange. I'll arrange
the dissimilarities like this:

```

apple   orange
strawberry    3       2
blueberry     3       2

```

The largest of those is 3, so that's the complete-linkage
distance. That's also what the dendrogram says.
(Likewise, the smallest of those is 2, so 2 is the
single-linkage distance.) That is to say, the largest distance or
dissimilarity 
from anything in one cluster to anything in the other is 3, and
the smallest is 2.
I don't mind which pair of clusters you take, as long as you spell
out the dissimilarity (distance) between each fruit in each
cluster, and take the maximum of those. Besides, if your
dissimilarities are different from mine, your complete-linkage
distance could be different from mine also. The grader will have
to use her judgement!
\marginnote{That's two cups of coffee I owe the      grader now.}  
The important point is that you assess the dissimilarities between
fruits in one cluster and fruits in the other. The dissimilarities
between fruits in the same cluster don't enter into it xxx.
\marginnote{I      now have a mental image of John Cleese saying *it don't enter      into it* in the infamous Dead Parrot sketch, https://www.youtube.com/watch?v=vnciwwsvNcc. Not to      mention       *How to defend yourself against an assailant armed with fresh      fruit*, https://www.youtube.com/watch?v=4JgbOkLdRaE.    }
As it happens, all my complete-linkage distances between clusters
(of at least 2 fruits) are 3. The single-linkage ones are
different, though:

```r
fruits.2 <- hclust(d, method = "single")
plot(fruits.2)
```


\includegraphics{22-thingy_files/figure-latex/lhsdjhad-1} 

     

All the single-linkage cluster distances are 2. (OK, so this wasn't a
very interesting example, but I wanted to give you one where you could
calculate what was going on.)
 




##  Similarity of species 


 Two scientists assessed the dissimilarity
between a number 
of species by recording the number of positions in the protein
molecule cytochrome-$c$ where the two species being compared have
different amino acids. The dissimilarities that they recorded are in
[link](http://www.utsc.utoronto.ca/~butler/d29/species.txt).



(a) Read the data into a data frame and take a look at it.


Solution


Nothing much new here:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/species.txt"
species <- read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   what = col_character(),
##   Man = col_double(),
##   Monkey = col_double(),
##   Horse = col_double(),
##   Pig = col_double(),
##   Pigeon = col_double(),
##   Tuna = col_double(),
##   Mould = col_double(),
##   Fungus = col_double()
## )
```

```r
species
```

```
## # A tibble: 8 x 9
##   what    Man Monkey Horse   Pig Pigeon  Tuna
##   <chr> <dbl>  <dbl> <dbl> <dbl>  <dbl> <dbl>
## 1 Man       0      1    17    13     16    31
## 2 Monk~     1      0    16    12     15    32
## 3 Horse    17     16     0     5     16    27
## 4 Pig      13     12     5     0     13    25
## 5 Pige~    16     15    16    13      0    27
## 6 Tuna     31     32    27    25     27     0
## 7 Mould    63     62    64    64     59    72
## 8 Fung~    66     65    68    67     66    69
## # ... with 2 more variables: Mould <dbl>,
## #   Fungus <dbl>
```

     

This is a square array of dissimilarities between the eight species.

The data set came from the 1960s, hence the use of "Man" rather than
"human". It probably also came from the UK, judging by the spelling
of `Mould`.

(I gave the first column the name `what` so that you could
safely use `species` for the whole data frame.)
    


(b) Bearing in mind that the values you read in are
*already* dissimilarities, convert them into a `dist`
object suitable for running a cluster analysis on, and display the
results. (Note that you need to get rid of any columns that don't
contain numbers.)


Solution


The point here is that the values you have are *already*
dissimilarities, so no conversion of the numbers is required. Thus
this is a job for `as.dist`, which merely changes how it
looks. Use a pipeline to get rid of the first column first:

```r
d <- species %>% select(-what) %>% as.dist()
d
```

```
##        Man Monkey Horse Pig Pigeon Tuna
## Monkey   1                             
## Horse   17     16                      
## Pig     13     12     5                
## Pigeon  16     15    16  13            
## Tuna    31     32    27  25     27     
## Mould   63     62    64  64     59   72
## Fungus  66     65    68  67     66   69
##        Mould
## Monkey      
## Horse       
## Pig         
## Pigeon      
## Tuna        
## Mould       
## Fungus    61
```



This doesn't display anything that it doesn't need to: we know that the
dissimilarity between a species and itself is zero (no need to show
that), and that the dissimilarity between B and A is the same as
between A and B, so no need to show everything twice. It might look as
if you are missing a row and a column, but one of the species (Fungus)
appears only in a row and one of them (Man) only in a column.

This also works, to select only the numerical columns:


```r
species %>% select_if(is.numeric) %>% as.dist()
```

```
##        Man Monkey Horse Pig Pigeon Tuna
## Monkey   1                             
## Horse   17     16                      
## Pig     13     12     5                
## Pigeon  16     15    16  13            
## Tuna    31     32    27  25     27     
## Mould   63     62    64  64     59   72
## Fungus  66     65    68  67     66   69
##        Mould
## Monkey      
## Horse       
## Pig         
## Pigeon      
## Tuna        
## Mould       
## Fungus    61
```

 

Extra: data frames officially have an attribute called "row names",
that is displayed where the row numbers display, but which isn't
actually a column of the data frame. In the past, when we used
`read.table` with a dot, the first column of data read in from
the file could be nameless (that is, you could have one more column of
data than you had column names) and the first column would be treated
as row names. People used row names for things like identifier
variables. But row names have this sort of half-existence, and when
Hadley Wickham designed the `tidyverse`, he decided not to use
row names, taking the attitude that if it's part of the data, it
should be in the data frame as a genuine column. This means that when
you use a `read_` function, you have to have exactly as many
column names as columns. 

For these data, I previously had the column here called
`what` as row names, and `as.dist` automatically got rid
of the row names when formatting the distances. Now, it's a
genuine column, so I have to get rid of it before running
`as.dist`. This is more work, but it's also more honest, and
doesn't involve thinking about row names at all. So, on balance, I
think it's a win.
  


(c) Run a cluster analysis using single-linkage and obtain a dendrogram.


Solution


Something like this:

```r
species.1 <- hclust(d, method = "single")
plot(species.1)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-60-1} 

     
    


(d) Run a cluster analysis using Ward's method and obtain a dendrogram.


Solution


Not much changes  here in the code, but the result is noticeably
different:

```r
species.2 <- hclust(d, method = "ward.D")
plot(species.2)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-61-1} 

  

Fewer points this time since you're doing much of the same stuff over again.

Don't forget to take care with the `method`: it has to be
`ward` in lowercase (even though it's someone's name) followed
by a D in uppercase.

    


(e) Describe how the two dendrograms from the last two parts
look different.


Solution


This is (as ever with this kind of thing) a judgement call. Your
job is to come up with something reasonable.
For myself, I was thinking about how single-linkage tends to
produce "stringy" clusters that join single objects (species)
onto already-formed clusters. Is that happening here? Apart from
the first two clusters, man and monkey, horse and pig,
*everything* that gets joined on is a single species joined
on to a bigger cluster, including mould and fungus right at the
end. Contrast that with the output from Ward's method, where, for
the most part, groups are formed first and then joined onto other
groups. For example, in Ward's method, mould and fungus are joined
earlier, and also the man-monkey group is joined to the
pigeon-horse-pig group.
\marginnote{Tuna is an exception, but usually Ward    tends to join fairly dissimilar things that are nonetheless more    similar to each other than to anything else. This is like    Hungarian and Finnish in the example in class: they are very    dissimilar languages, but they are more similar to each other than    to anything else.}
You might prefer to look at the specifics of what gets joined. I
think the principal difference from this angle is that mould and
fungus get joined together (much) earlier in Ward. Also, pigeon
gets joined to horse and pig first under Ward, but *after*
those have been joined to man and monkey under
single-linkage. This is also a reasonable kind of observation.
    


(f) Looking at your clustering for Ward's method, what seems to
be a sensible number of clusters? Draw boxes around those clusters.


Solution


Pretty much any number of clusters bigger than 1 and smaller than
8 is ok here, but I would prefer to see something between 2 and
5, because a number of clusters of that sort offers (i) some
insight ("these things are like these other things") and (ii) a
number of clusters of that sort is supported by the data.
To draw those clusters, you need `rect.hclust`, and
before that you'll need to plot the cluster object again. For 2
clusters, that would look like this:

```r
plot(species.2)
rect.hclust(species.2, 2)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-62-1} 

 

This one is "mould and fungus vs.\ everything else". (My red boxes
seem to have gone off the side, sorry.)

Or we could go to the other end of the scale:


```r
plot(species.2)
rect.hclust(species.2, 5)
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-63-1} 

 

Five is not really an insightful number of clusters with 8 species,
but it seems to correspond (for me at least) with a reasonable
division of these species into "kinds of living things". That is, I
am bringing some outside knowledge into my number-of-clusters division.
    


(g) List which cluster each species is in, for your preferred
number of clusters (from Ward's method).


Solution


This is `cutree`. For 2 clusters it would be this:

```r
cutree(species.2, 2)
```

```
##    Man Monkey  Horse    Pig Pigeon   Tuna 
##      1      1      1      1      1      1 
##  Mould Fungus 
##      2      2
```

     

For 5 it would be this:


```r
cutree(species.2, 5)
```

```
##    Man Monkey  Horse    Pig Pigeon   Tuna 
##      1      1      2      2      2      3 
##  Mould Fungus 
##      4      5
```

 

and anything in between is in between. 

These ones came out sorted, so there is no need to sort them (so you
don't need the methods of the next question).
    






##  Rating beer


 Thirty-two students each rated 10 brands of beer:


* Anchor Steam

* Bass

* Beck's

* Corona

* Gordon Biersch

* Guinness

* Heineken

* Pete's Wicked Ale

* Sam Adams

* Sierra Nevada

The ratings are on a scale of 1 to 9, with a higher
rating being better.
The data are in
[link](http://www.utsc.utoronto.ca/~butler/d29/beer.txt).  I
abbreviated the beer names for the data file. I hope you can figure
out which is which.


(a) Read in the data, and look at the first few rows.
 
Solution


Data values are aligned in columns, but the column headers are
not aligned with them, so `read_table2`:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/beer.txt"
beer <- read_table2(my_url)
```

```
## Parsed with column specification:
## cols(
##   student = col_character(),
##   AnchorS = col_double(),
##   Bass = col_double(),
##   Becks = col_double(),
##   Corona = col_double(),
##   GordonB = col_double(),
##   Guinness = col_double(),
##   Heineken = col_double(),
##   PetesW = col_double(),
##   SamAdams = col_double(),
##   SierraN = col_double()
## )
```

```r
beer
```

```
## # A tibble: 32 x 11
##    student AnchorS  Bass Becks Corona GordonB
##    <chr>     <dbl> <dbl> <dbl>  <dbl>   <dbl>
##  1 S001          5     9     7      1       7
##  2 S008          7     5     6      8       8
##  3 S015          7     7     5      6       6
##  4 S022          7     7     5      2       5
##  5 S029          9     7     3      1       6
##  6 S036          7     6     4      3       7
##  7 S043          5     5     5      6       6
##  8 S050          5     3     1      5       5
##  9 S057          9     3     2      6       4
## 10 S064          2     6     6      5       6
## # ... with 22 more rows, and 5 more
## #   variables: Guinness <dbl>,
## #   Heineken <dbl>, PetesW <dbl>,
## #   SamAdams <dbl>, SierraN <dbl>
```

       
32 rows (students), 11 columns (10 beers, plus a column of student
IDs).  All seems to be kosher. If beer can be kosher.
\marginnote{I  investigated. It can; in fact, I found a long list of kosher beers  that included Anchor Steam.}
 

(b) The researcher who collected the data wants to see which
beers are rated similarly to which other beers. Try to create a
distance matrix from these data and explain why it didn't do what
you wanted. (Remember to get rid of the `student` column
first.) 
 
Solution


The obvious thing is to feed these ratings into `dist`
(we are *creating* distances rather than re-formatting
things that are already distances). We need to skip the first
column, since those are student identifiers:

```r
d <- beer %>% select(-student) %>% dist()
glimpse(d)
```

```
##  'dist' num [1:496] 9.8 8.49 6.56 8.89 8.19 ...
##  - attr(*, "Size")= int 32
##  - attr(*, "Diag")= logi FALSE
##  - attr(*, "Upper")= logi FALSE
##  - attr(*, "method")= chr "euclidean"
##  - attr(*, "call")= language dist(x = .)
```

   

The 496 distances are:


```r
32 * 31/2
```

```
## [1] 496
```

 

the number of ways of choosing 2 objects out of 32, when order does
not matter.
Feel free to be offended by my choice of the letter `d` to
denote both data frames (that I didn't want to give a better name to)
and dissimilarities in `dist` objects.

You can look at the whole thing if you like, though it is rather
large. A `dist` object is stored internally as a long vector
(here of 496 values); it's displayed as a nice triangle. The clue here
is the thing called `Size`, which indicates that we have a
$32\times 32$ matrix of distances *between the 32 students*, so
that if we were to go on and do a cluster analysis based on this
`d`, we'd get a clustering of the *students* rather than
of the *beers*, as we want. (If you just print out `d`,
you'll see that is of distances between 32 (unlabelled) objects, which
by inference must be the 32 students.)

It might be interesting to do a cluster analysis of the 32 students
(it would tell you which of the students have similar taste in beer),
but that's not what we have in mind here.
 

(c) The R function `t()` *transposes* a matrix: that
is, it interchanges rows and columns. Feed the transpose of your
read-in beer ratings into `dist`. Does this now give
distances between beers?
 
Solution


Again, omit the first column. The pipeline code looks a bit weird:

```r
d <- beer %>% select(-student) %>% t() %>% dist()
```

   

so you should feel free to do it in a couple of steps. This way shows
that you can also refer to columns by number:


```r
beer2 <- beer %>% select(-1)
d <- dist(t(beer2))
```

 

Either way gets you to the same place:


```r
d
```

```
##           AnchorS     Bass    Becks   Corona
## Bass     15.19868                           
## Becks    16.09348 13.63818                  
## Corona   20.02498 17.83255 17.54993         
## GordonB  13.96424 11.57584 14.42221 13.34166
## Guinness 14.93318 13.49074 16.85230 20.59126
## Heineken 20.66398 15.09967 13.78405 14.89966
## PetesW   11.78983 14.00000 16.37071 17.72005
## SamAdams 14.62874 11.61895 14.73092 14.93318
## SierraN  12.60952 15.09967 17.94436 16.97056
##           GordonB Guinness Heineken   PetesW
## Bass                                        
## Becks                                       
## Corona                                      
## GordonB                                     
## Guinness 14.76482                           
## Heineken 14.07125 18.54724                  
## PetesW   11.57584 14.28286 19.49359         
## SamAdams 10.90871 15.90597 14.52584 14.45683
## SierraN  11.74734 13.34166 19.07878 13.41641
##          SamAdams
## Bass             
## Becks            
## Corona           
## GordonB          
## Guinness         
## Heineken         
## PetesW           
## SamAdams         
## SierraN  12.12436
```

 

There are 10 beers with these names, so this is good.
 

(d) Try to explain briefly why I used `as.dist` in the
class example (the languages one) but `dist` here. (Think
about the form of the input to each function.)
 
Solution


`as.dist` is used if you *already* have
dissimilarities (and you just want to format them right), but
`dist` is used if you have 
*data on variables* and you want to *calculate*
dissimilarities. 
 

(e) <a name="part:beer-dendro">*</a> Obtain a clustering of the beers, using Ward's method. Show
the dendrogram.
 
Solution


This:

```r
beer.1 <- hclust(d, method = "ward.D")
plot(beer.1)
```


\includegraphics{22-thingy_files/figure-latex/khas-1} 

       
 

(f) What seems to be a sensible number of clusters? Which
beers are in which cluster?
 
Solution


This is a judgement call. Almost anything sensible is
reasonable. I personally think that two clusters is good, beers
Anchor Steam, Pete's Wicked Ale, Guinness and Sierra Nevada in
the first, and Bass, Gordon Biersch, Sam Adams, Corona, Beck's,
and Heineken in the second.
You could make a case for three clusters, splitting off
Corona, Beck's and Heineken  into their own cluster, or even
about 5 clusters as 
Anchor Steam, Pete's Wicked Ale; Guinness, Sierra Nevada; Bass,
Gordon Biersch, Sam Adams; Corona; Beck's, Heineken.

The idea is to have a number of clusters sensibly smaller than
the 10 observations, so that you are getting some actual
insight. Having 8 clusters for 10 beers wouldn't be very
informative! (This is where you use your own knowledge about
beer to help you rationalize your choice of number of clusters.) 

Extra: as to why the clusters split up like this, I think the four
beers on the left of my dendrogram are "dark" and the six on
the right are "light" (in colour), and I would expect the
students to tend to like all the beers of one type and not so
much all the beers of the other type.

You knew I would have to investigate this, didn't you? Let's aim
for a scatterplot of all the ratings for the dark  beers,
against the ones for the light beers. 

Start with the data frame read in from the file:


```r
beer
```

```
## # A tibble: 32 x 11
##    student AnchorS  Bass Becks Corona GordonB
##    <chr>     <dbl> <dbl> <dbl>  <dbl>   <dbl>
##  1 S001          5     9     7      1       7
##  2 S008          7     5     6      8       8
##  3 S015          7     7     5      6       6
##  4 S022          7     7     5      2       5
##  5 S029          9     7     3      1       6
##  6 S036          7     6     4      3       7
##  7 S043          5     5     5      6       6
##  8 S050          5     3     1      5       5
##  9 S057          9     3     2      6       4
## 10 S064          2     6     6      5       6
## # ... with 22 more rows, and 5 more
## #   variables: Guinness <dbl>,
## #   Heineken <dbl>, PetesW <dbl>,
## #   SamAdams <dbl>, SierraN <dbl>
```

       

The aim is to find the average rating for a dark beer and a light beer
for each student, and then plot them against each other. Does a
student who likes dark beer tend not to like light beer, and vice versa?

Let's think about what to do first.

We need to: `gather` all the rating columns into one, labelled
by `name` of beer. Then create a variable that is `dark`
if we're looking at one of the dark beers and `light`
otherwise. `ifelse` works like "if" in a spreadsheet: a
logical thing that is either true or false, followed by a value if
true and a value if false. There is a nice R command `%in%`
which is `TRUE` if the thing in the first variable is to be
found somewhere in the list of things given next (here, one of the
apparently dark beers). (Another way to do this, which will appeal to
you more if you like databases, is to create a second data frame with
two columns, the first being the beer names, and the second being
`dark` or `light` as appropriate for that beer. Then you
use a "left join" to look up beer type from beer name.)

Next, group by beer type within student. Giving two things to
`group_by` does it this way: the second thing within 
(or "for each of") the first. 

Then calculate the mean
rating within each group. This gives one column of students, one
column of beer types, 
and one column of rating means. 

Then we need to `spread` beer type
into two columns so that we can make a scatterplot of the mean ratings
for light and dark against
each other. 

Finally, we make a scatterplot. 

You'll see the final version of this that worked, but rest assured
that there were many intervening versions of this that didn't!

I urge you to examine the chain one line at a time and see what each
line does. That was how I debugged it.

Off we go:


```r
beer %>% gather(name, rating, AnchorS:SierraN) %>% 
    mutate(beer.type = ifelse(name %in% c("AnchorS", 
        "PetesW", "Guinness", "SierraN"), "dark", 
        "light")) %>% group_by(student, beer.type) %>% 
    summarize(mean.rat = mean(rating)) %>% spread(beer.type, 
    mean.rat) %>% ggplot(aes(x = dark, y = light)) + 
    geom_point()
```


\includegraphics{22-thingy_files/figure-latex/iyrpoydf-1} 

 

After all that work, not really. There are some students who like
light beer but not dark beer (top left), there is a sort of vague
straggle down to the bottom right, where some students like dark beer
but not light beer, but there are definitely students at the top
right, who just like beer! 

The only really empty part of this plot is
the bottom left, which says that these students don't hate both kinds
of beer; they like either dark beer, or light beer, or both.

The reason a `ggplot` fits into this "workflow" is that the
first thing you feed into `ggplot` is a data frame, the one
created by the chain here. Because it's in a pipeline, 
you don't have the
first thing on `ggplot`, so you can concentrate on the
`aes` ("what to plot") and then the "how to plot it". 
Now back to your regularly-scheduled programming.
 

(g) Re-draw your dendrogram with your clusters indicated.
 
Solution


`rect.hclust`, with your chosen number  of clusters:

```r
plot(beer.1)
rect.hclust(beer.1, 2)
```


\includegraphics{22-thingy_files/figure-latex/sdkjdh-1} 

       

Or if you prefer 5 clusters, like this:


```r
plot(beer.1)
rect.hclust(beer.1, 5)
```


\includegraphics{22-thingy_files/figure-latex/ljashkjsdah-1} 

 

Same idea with any other number of clusters. If you follow through
with your preferred number of clusters from the previous part, I'm good.
 

(h) Obtain a K-means
clustering with 2 clusters.
\marginnote{If you haven't gotten to K-means clustering yet, leave this and save it for later.}
Note that you will need to use the (transposed) 
*original  data*, not the distances. Use a suitably large value of
`nstart`. (The data are ratings all on the same scale, so
there is no need for `scale` here. In case you were
wondering.) 
 
Solution




       
I used 20 for `nstart`. This is the pipe way:

```r
beer.2 <- beer %>% select(-1) %>% t() %>% kmeans(2, 
    nstart = 20)
```

       

Not everyone (probably) will get the same answer, because of the
random nature of the procedure, but the above code should be good
whatever output it produces.
 

(i) How many beers are in each cluster?
 
Solution


On mine:

```r
beer.2$size
```

```
## [1] 4 6
```

       

You might get the same numbers the other way around.
 

(j) *Which* beers are in each cluster? You can do this
simply by obtaining the cluster memberships and using
`sort` as in the last question, or you can do it as I did
in class by obtaining the 
names of the things to be clustered and picking out the ones of
them that are in cluster 1, 2, 3, \ldots .)
 
Solution


The cluster numbers of each beer are these:


```r
beer.2$cluster
```

```
##  AnchorS     Bass    Becks   Corona  GordonB 
##        1        2        2        2        2 
## Guinness Heineken   PetesW SamAdams  SierraN 
##        1        2        1        2        1
```

  

This is what is known in the business as a "named vector": it has values (the cluster numbers) and each value has a name attached to it (the name of a beer).

Named vectors are handily turned into a data frame with `enframe`:


```r
enframe(beer.2$cluster)
```

```
## # A tibble: 10 x 2
##    name     value
##    <chr>    <int>
##  1 AnchorS      1
##  2 Bass         2
##  3 Becks        2
##  4 Corona       2
##  5 GordonB      2
##  6 Guinness     1
##  7 Heineken     2
##  8 PetesW       1
##  9 SamAdams     2
## 10 SierraN      1
```

 

or, give the columns better names and arrange them by cluster:


```r
enframe(beer.2$cluster, name = "beer", value = "cluster") %>% 
    arrange(cluster)
```

```
## # A tibble: 10 x 2
##    beer     cluster
##    <chr>      <int>
##  1 AnchorS        1
##  2 Guinness       1
##  3 PetesW         1
##  4 SierraN        1
##  5 Bass           2
##  6 Becks          2
##  7 Corona         2
##  8 GordonB        2
##  9 Heineken       2
## 10 SamAdams       2
```

 

These happen to be the same clusters as in my 2-cluster solution using
Ward's method.
 






##  Clustering the Swiss bills


 This question is about the Swiss bank counterfeit bills
again. This time we're going to ignore whether each bill is
counterfeit or not, and see what groups they break into. Then, at
the end, we'll see whether cluster analysis was able to pick out the
counterfeit ones or not.


(a) Read the data in again (just like last time), and look at
the first few rows. This is just the same as before.
 
Solution


The data file was aligned in columns, so:

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/swiss1.txt"
swiss <- read_table(my_url)
```

```
## Parsed with column specification:
## cols(
##   length = col_double(),
##   left = col_double(),
##   right = col_double(),
##   bottom = col_double(),
##   top = col_double(),
##   diag = col_double(),
##   status = col_character()
## )
```

```r
swiss
```

```
## # A tibble: 200 x 7
##    length  left right bottom   top  diag
##     <dbl> <dbl> <dbl>  <dbl> <dbl> <dbl>
##  1   215.  131   131.    9     9.7  141 
##  2   215.  130.  130.    8.1   9.5  142.
##  3   215.  130.  130.    8.7   9.6  142.
##  4   215.  130.  130.    7.5  10.4  142 
##  5   215   130.  130.   10.4   7.7  142.
##  6   216.  131.  130.    9    10.1  141.
##  7   216.  130.  130.    7.9   9.6  142.
##  8   214.  130.  129.    7.2  10.7  142.
##  9   215.  129.  130.    8.2  11    142.
## 10   215.  130.  130.    9.2  10    141.
## # ... with 190 more rows, and 1 more
## #   variable: status <chr>
```

       
 

(b) The variables in this data frame are on different
scales. Standardize them so that they all have mean 0 and standard
deviation 1. (Don't try to standardize the `status` column!)
 
Solution



```r
swiss.s <- swiss %>% select(-status) %>% scale()
```

    

What kind of thing do we have?


```r
class(swiss.s)
```

```
## [1] "matrix"
```

 

so something like this is needed to display some of it (rather than
all of it):


```r
head(swiss.s)
```

```
##          length      left      right
## [1,] -0.2549435  2.433346  2.8299417
## [2,] -0.7860757 -1.167507 -0.6347880
## [3,] -0.2549435 -1.167507 -0.6347880
## [4,] -0.2549435 -1.167507 -0.8822687
## [5,]  0.2761888 -1.444496 -0.6347880
## [6,]  2.1351516  1.879368  1.3450576
##          bottom        top      diag
## [1,] -0.2890067 -1.1837648 0.4482473
## [2,] -0.9120152 -1.4328473 1.0557460
## [3,] -0.4966762 -1.3083061 1.4896737
## [4,] -1.3273542 -0.3119759 1.3161027
## [5,]  0.6801176 -3.6745902 1.1425316
## [6,] -0.2890067 -0.6855997 0.7953894
```

 
 

(c) We are going to make a scree plot. First, calculate the total
within-cluster SS for each number of clusters from 2 to 10.
 
Solution

 
When I first made this problem,
I thought the obvious answer was a loop, but now that I've been
steeped in the Tidyverse a while, I think `map` is much
clearer, so I'll do that first.
Start by making a `tibble` that has one column called `clusters` containing the numbers 2 through 10:


```r
tibble(clusters = 2:10)
```

```
## # A tibble: 9 x 1
##   clusters
##      <int>
## 1        2
## 2        3
## 3        4
## 4        5
## 5        6
## 6        7
## 7        8
## 8        9
## 9       10
```

 
Now, for each of these numbers of clusters (think `map`), calculate the total within-cluster sum of squares for *it* (that number of clusters). To do that, think about how you'd do it for something like three clusters:


```r
kmeans(swiss.s, 3, nstart = 20)$tot.withinss
```

```
## [1] 576.466
```

 

and then use that within your `map`, replacing the 3 with a dot:

```r
wssq <- tibble(clusters = 2:10) %>% mutate(wss = map_dbl(clusters, 
    ~kmeans(swiss.s, ., nstart = 20)$tot.withinss))
wssq
```

```
## # A tibble: 9 x 2
##   clusters   wss
##      <int> <dbl>
## 1        2  701.
## 2        3  576.
## 3        4  492.
## 4        5  449.
## 5        6  413.
## 6        7  383.
## 7        8  355.
## 8        9  334.
## 9       10  313.
```

 

Another way is to save *all* the output from the `kmeans` and then *extract* the thing you want, thus:

```r
wssq.2 <- tibble(clusters = 2:10) %>% mutate(km = map(clusters, 
    ~kmeans(swiss.s, ., nstart = 20))) %>% mutate(wss = map_dbl(km, 
    "tot.withinss"))
wssq.2
```

```
## # A tibble: 9 x 3
##   clusters km             wss
##      <int> <list>       <dbl>
## 1        2 <S3: kmeans>  701.
## 2        3 <S3: kmeans>  576.
## 3        4 <S3: kmeans>  492.
## 4        5 <S3: kmeans>  449.
## 5        6 <S3: kmeans>  413.
## 6        7 <S3: kmeans>  382.
## 7        8 <S3: kmeans>  355.
## 8        9 <S3: kmeans>  334.
## 9       10 <S3: kmeans>  313.
```

 
The first one here is a `map` since it gets the *whole*
`kmeans` output; the second one is a `map_dbl` since it
pulls just one number out of that output. (I somehow got this the
wrong way around the first time. I think I copied and pasted and
didn't check that I had changed what I needed to change.)

We now have an extra list-column containing everything from each
K-means fit, which means we can extract the output from here for the number of
clusters we eventually choose, rather than running `kmeans` again.
If you prefer, do it as a loop, like this:        

```r
clus <- 2:10
wss.1 <- numeric(0)
for (i in clus) {
    wss.1[i] <- kmeans(swiss.s, i, nstart = 20)$tot.withinss
}
wss.1
```

```
##  [1]       NA 701.2054 576.4660 491.7085
##  [5] 449.3900 412.9139 381.3926 355.3168
##  [9] 333.5024 313.2374
```

       

Note that there are 10 `wss` values, but the first one is
missing, since we didn't do one cluster.
\marginnote{R vectors start from  1, unlike C arrays or Python lists, which start from 0.}

The `numeric(0)` says "`wss` has nothing in it, but if it had anything, it would be numbers". Or, you can initialize
`wss` to however long it's going to be (here 10), which is
actually more efficient (R doesn't have to keep making it 
"a bit longer"). If you initialize it to length 10, the 10 values will have
`NA`s in them when you start.
It doesn't matter what `nstart` is: Ideally, big enough to have a decent
chance of finding the best clustering, but small enough that it
doesn't take too long to run.
Whichever way you create your total within-cluster sums of squares, you can use it to make a scree plot (next part). 

 

(d) <a name="part:howmany">*</a> Make a scree plot (creating a data frame
first if you need). How many clusters do you think you
should use?
 
Solution


The easiest is to use the output from the `map_dbl`,
which I called `wssq`:

```r
ggplot(wssq, aes(x = clusters, y = wss)) + geom_point() + 
    geom_line()
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-88-1} 

       
If you did it the loop way, you'll have to make a data frame
first, which you can then pipe into `ggplot`:


```r
tibble(clusters = 1:10, wss = wss.1) %>% ggplot(aes(x = clusters, 
    y = wss)) + geom_point() + geom_line()
```

```
## Warning: Removed 1 rows containing missing values
## (geom_point).
```

```
## Warning: Removed 1 rows containing missing
## values (geom_path).
```


\includegraphics{22-thingy_files/figure-latex/sasjhgajs-1} 

       
If you started at 2 clusters, your `wss` will start at 2
clusters also, and you'll need to be careful to have something like
`clusters=2:10` (not `1:10`) in the definition of your
data frame. 

Interpretation: I see a small elbow at 4 clusters, so that's how many I think we
should use. Any place you can reasonably see an elbow is good.

The warning is about the missing within-cluster total sum of squares
for one cluster, since the loop way didn't supply a total
within-cluster sum of squares for one cluster.
 

(e) Run K-means with the number of clusters that you found in
(<a href="#part:howmany">here</a>). How many bills are in each cluster?
 
Solution



I'm going to start by setting the random number seed (so that
my results don't change every time I run this). You don't need
to do that, though you might want to in something like R
Markdown code (for example, in an R Notebook):

```r
set.seed(457299)
```



Now, down to business:

```r
swiss.7 <- kmeans(swiss.s, 4, nstart = 20)
swiss.7$size
```

```
## [1] 50 32 68 50
```

       
This many. Note that my clusters 1 and 4 (and also 2 and 3) add up to
100 bills. There were 100 genuine and 100 counterfeit bills in the
original data set.
I don't know why "7". I just felt like it.
Extra: you might remember that back before I actually *ran*
K-means on each of the numbers of clusters from 2 to 10. How can we
extract that output? Something like this. Here's where the output was:


```r
wssq.2
```

```
## # A tibble: 9 x 3
##   clusters km             wss
##      <int> <list>       <dbl>
## 1        2 <S3: kmeans>  701.
## 2        3 <S3: kmeans>  576.
## 3        4 <S3: kmeans>  492.
## 4        5 <S3: kmeans>  449.
## 5        6 <S3: kmeans>  413.
## 6        7 <S3: kmeans>  382.
## 7        8 <S3: kmeans>  355.
## 8        9 <S3: kmeans>  334.
## 9       10 <S3: kmeans>  313.
```

 

Now we need to pull out the 4th row and the `km` column. We need the output as an actual thing, not a data frame, so:


```r
swiss.7a <- wssq.2 %>% filter(clusters == 4) %>% 
    pull(km)
```

 

Is that the right thing?


```r
swiss.7a
```

```
## [[1]]
## K-means clustering with 4 clusters of sizes 50, 50, 68, 32
## 
## Cluster means:
##       length       left      right
## 1 -0.5683115  0.2617543  0.3254371
## 2  0.1062264  0.6993965  0.8352473
## 3 -0.2002681 -1.0290130 -0.9878119
## 4  1.1475776  0.6848546  0.2855308
##       bottom         top       diag
## 1  1.3197396  0.04670298 -0.8483286
## 2  0.1927865  1.18251937 -0.9316427
## 3 -0.8397381 -0.71307204  0.9434354
## 4 -0.5788787 -0.40538184  0.7764051
## 
## Clustering vector:
##   [1] 4 3 3 3 3 4 3 3 3 4 4 3 4 3 3 3 3 3 3 3
##  [21] 3 4 4 4 3 4 4 4 4 3 4 3 3 4 4 4 4 3 4 3
##  [41] 3 3 3 4 3 3 3 3 3 3 3 4 3 4 3 3 4 3 4 3
##  [61] 3 3 3 3 3 4 3 3 3 2 3 3 3 3 3 3 3 3 4 3
##  [81] 3 3 3 4 4 3 3 3 4 3 3 4 3 3 3 4 4 3 3 3
## [101] 2 2 2 2 1 1 2 2 2 2 2 2 2 1 1 2 1 1 1 2
## [121] 2 1 2 2 1 2 2 2 2 2 1 1 2 2 1 1 1 2 1 1
## [141] 2 1 1 2 1 1 1 2 1 2 1 1 1 1 1 1 1 1 1 2
## [161] 2 1 1 1 1 2 4 2 2 1 2 1 1 1 1 1 1 2 2 2
## [181] 1 2 2 2 1 1 2 1 2 1 2 2 1 2 1 2 2 2 2 1
## 
## Within cluster sum of squares by cluster:
## [1]  95.51948 137.68573 166.12573  92.37757
##  (between_SS / total_SS =  58.8 %)
## 
## Available components:
## 
## [1] "cluster"      "centers"     
## [3] "totss"        "withinss"    
## [5] "tot.withinss" "betweenss"   
## [7] "size"         "iter"        
## [9] "ifault"
```

 

Looks like it. But I should check:


```r
swiss.7a$centers
```

```
## NULL
```

 

Ah. `swiss.7a` is actually a `list`, as evidenced by the `[[1]]` at the top of the output, so I get things from it thus:


```r
swiss.7a[[1]]$centers
```

```
##       length       left      right
## 1 -0.5683115  0.2617543  0.3254371
## 2  0.1062264  0.6993965  0.8352473
## 3 -0.2002681 -1.0290130 -0.9878119
## 4  1.1475776  0.6848546  0.2855308
##       bottom         top       diag
## 1  1.3197396  0.04670298 -0.8483286
## 2  0.1927865  1.18251937 -0.9316427
## 3 -0.8397381 -0.71307204  0.9434354
## 4 -0.5788787 -0.40538184  0.7764051
```

 

This would be because it came from a list-column; using `pull` removed the data-frameness from `swiss.7a`, but not its listness.
 

(f) Make a table showing cluster membership against actual
status (counterfeit or genuine). Are the counterfeit bills mostly
in certain clusters?
 
Solution


`table`. `swiss.7$cluster` shows the actual
cluster numbers:

```r
table(swiss$status, swiss.7$cluster)
```

```
##              
##                1  2  3  4
##   counterfeit 50  1  0 49
##   genuine      0 31 68  1
```

       

Or, if you prefer,


```r
tibble(obs = swiss$status, pred = swiss.7$cluster) %>% 
    count(obs, pred)
```

```
## # A tibble: 6 x 3
##   obs          pred     n
##   <chr>       <int> <int>
## 1 counterfeit     1    50
## 2 counterfeit     2     1
## 3 counterfeit     4    49
## 4 genuine         2    31
## 5 genuine         3    68
## 6 genuine         4     1
```

 

or even


```r
tibble(obs = swiss$status, pred = swiss.7$cluster) %>% 
    count(obs, pred) %>% spread(pred, n, fill = 0)
```

```
## # A tibble: 2 x 5
##   obs           `1`   `2`   `3`   `4`
##   <chr>       <dbl> <dbl> <dbl> <dbl>
## 1 counterfeit    50     1     0    49
## 2 genuine         0    31    68     1
```

 

In my case (yours might be different), 99 of the 100 counterfeit bills
are in clusters 1 and 4, and 99 of the 100 genuine bills are in
clusters 2 and 3.
\marginnote{This is again where *set.seed* is  valuable: write this text once and it never needs to change.} So the
clustering has done a very good job of distinguishing the genuine
bills from the counterfeit ones. (You could imagine, if you were an
employee at the bank, saying that a bill in cluster 1 or 4 is
counterfeit, and being right 99\% of the time.) This is kind of a
by-product of the clustering, though: we weren't *trying* to
distinguish counterfeit bills (that would have been the discriminant
analysis that we did before); we were just trying to divide them into
groups of different ones, and part of what made them different was
that some of them were genuine bills and some of them were
counterfeit.
 




##  Grouping similar cars


 The file
[link](http://www.utsc.utoronto.ca/~butler/d29/car-cluster.csv) contains
information on seven variables 
for 32 different cars. The variables are:



* `Carname`: name of the car (duh!)

* `mpg`: gas consumption in miles per US gallon (higher means the car uses less gas)

* `disp`: engine displacement (total volume of cylinders in engine): higher is more powerful

* `hp`: engine horsepower (higher means a more powerful engine)

* `drat`: rear axle ratio (higher means more powerful but worse gas mileage)

* `wt`: car weight in US tons

* `qsec`: time needed for the car to cover a quarter mile (lower means faster)




(a) Read in the data and display its structure. Do you have the
right number of cars and variables?

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/car-cluster.csv"
cars <- read_csv(my_url)
```

```
## Parsed with column specification:
## cols(
##   Carname = col_character(),
##   mpg = col_double(),
##   disp = col_double(),
##   hp = col_double(),
##   drat = col_double(),
##   wt = col_double(),
##   qsec = col_double()
## )
```

```r
cars
```

```
## # A tibble: 32 x 7
##    Carname   mpg  disp    hp  drat    wt
##    <chr>   <dbl> <dbl> <dbl> <dbl> <dbl>
##  1 Mazda ~  21    160    110  3.9   2.62
##  2 Mazda ~  21    160    110  3.9   2.88
##  3 Datsun~  22.8  108     93  3.85  2.32
##  4 Hornet~  21.4  258    110  3.08  3.22
##  5 Hornet~  18.7  360    175  3.15  3.44
##  6 Valiant  18.1  225    105  2.76  3.46
##  7 Duster~  14.3  360    245  3.21  3.57
##  8 Merc 2~  24.4  147.    62  3.69  3.19
##  9 Merc 2~  22.8  141.    95  3.92  3.15
## 10 Merc 2~  19.2  168.   123  3.92  3.44
## # ... with 22 more rows, and 1 more
## #   variable: qsec <dbl>
```

   

Check, both on number of cars and number of variables.


(b) The variables are all measured on different scales. Use
`scale` to produce a matrix of standardized ($z$-score) values
for the columns of your data that are numbers.



Solution


All but the first column needs to be scaled, so:

```r
cars.s <- cars %>% select(-Carname) %>% scale()
```

   

This is a `matrix`, as we've seen before.

Another way is like this:


```r
h <- cars %>% select_if(is.numeric) %>% scale()
```

 
I would prefer to have a look at my result, so that I can see that it
has sane things in it:


```r
head(cars.s)
```

```
##             mpg        disp         hp
## [1,]  0.1508848 -0.57061982 -0.5350928
## [2,]  0.1508848 -0.57061982 -0.5350928
## [3,]  0.4495434 -0.99018209 -0.7830405
## [4,]  0.2172534  0.22009369 -0.5350928
## [5,] -0.2307345  1.04308123  0.4129422
## [6,] -0.3302874 -0.04616698 -0.6080186
##            drat           wt       qsec
## [1,]  0.5675137 -0.610399567 -0.7771651
## [2,]  0.5675137 -0.349785269 -0.4637808
## [3,]  0.4739996 -0.917004624  0.4260068
## [4,] -0.9661175 -0.002299538  0.8904872
## [5,] -0.8351978  0.227654255 -0.4637808
## [6,] -1.5646078  0.248094592  1.3269868
```

 

or, 


```r
head(h)
```

```
##             mpg        disp         hp
## [1,]  0.1508848 -0.57061982 -0.5350928
## [2,]  0.1508848 -0.57061982 -0.5350928
## [3,]  0.4495434 -0.99018209 -0.7830405
## [4,]  0.2172534  0.22009369 -0.5350928
## [5,] -0.2307345  1.04308123  0.4129422
## [6,] -0.3302874 -0.04616698 -0.6080186
##            drat           wt       qsec
## [1,]  0.5675137 -0.610399567 -0.7771651
## [2,]  0.5675137 -0.349785269 -0.4637808
## [3,]  0.4739996 -0.917004624  0.4260068
## [4,] -0.9661175 -0.002299538  0.8904872
## [5,] -0.8351978  0.227654255 -0.4637808
## [6,] -1.5646078  0.248094592  1.3269868
```

 

These look right. Or, perhaps better, this:


```r
summary(cars.s)
```

```
##       mpg               disp        
##  Min.   :-1.6079   Min.   :-1.2879  
##  1st Qu.:-0.7741   1st Qu.:-0.8867  
##  Median :-0.1478   Median :-0.2777  
##  Mean   : 0.0000   Mean   : 0.0000  
##  3rd Qu.: 0.4495   3rd Qu.: 0.7688  
##  Max.   : 2.2913   Max.   : 1.9468  
##        hp               drat        
##  Min.   :-1.3810   Min.   :-1.5646  
##  1st Qu.:-0.7320   1st Qu.:-0.9661  
##  Median :-0.3455   Median : 0.1841  
##  Mean   : 0.0000   Mean   : 0.0000  
##  3rd Qu.: 0.4859   3rd Qu.: 0.6049  
##  Max.   : 2.7466   Max.   : 2.4939  
##        wt               qsec         
##  Min.   :-1.7418   Min.   :-1.87401  
##  1st Qu.:-0.6500   1st Qu.:-0.53513  
##  Median : 0.1101   Median :-0.07765  
##  Mean   : 0.0000   Mean   : 0.00000  
##  3rd Qu.: 0.4014   3rd Qu.: 0.58830  
##  Max.   : 2.2553   Max.   : 2.82675
```

 
The mean is exactly zero, for all variables, which is as it should
be. Also, the standardized values look about as they should; even the
extreme ones don't go beyond $\pm 3$. 

This doesn't show the standard deviation of each variable, though,
which should be exactly 1 (since that's what "standardizing"
means). To get *that*, *this*:


```r
as_tibble(cars.s) %>% summarize_all(~sd(.))
```

```
## # A tibble: 1 x 6
##     mpg  disp    hp  drat    wt  qsec
##   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
## 1     1    1.     1     1     1     1
```

 

The idea here is "take the matrix `cars.s`, turn it into a data frame, and for each *column*, calculate the SD of it".
\marginnote{The *scale* function can take  a data frame, as here, but always produces a matrix. That's why we  had to turn it back into a data frame.}

As you realize now, the same idea will get the mean of each column too:


```r
as_tibble(cars.s) %>% summarize_all(~mean(.))
```

```
## # A tibble: 1 x 6
##        mpg      disp       hp      drat
##      <dbl>     <dbl>    <dbl>     <dbl>
## 1 7.11e-17 -9.08e-17 1.04e-17 -2.92e-16
## # ... with 2 more variables: wt <dbl>,
## #   qsec <dbl>
```

 

and we see that the means are all zero, to about 15 decimals, anyway.
  


(c) Run a K-means cluster analysis for these data, obtaining 3
clusters, and display the results. Take whatever action you need to
obtain the best (random) result from a number of runs.



Solution


The hint at the end says "use `nstart`", so something like this:

```r
set.seed(457299)
cars.1 <- kmeans(cars.s, 3, nstart = 20)
cars.1
```

```
## K-means clustering with 3 clusters of sizes 6, 14, 12
## 
## Cluster means:
##          mpg       disp         hp
## 1  1.6552394 -1.1624447 -1.0382807
## 2 -0.8280518  0.9874085  0.9119628
## 3  0.1384407 -0.5707543 -0.5448163
##         drat         wt       qsec
## 1  1.2252295 -1.3738462  0.3075550
## 2 -0.6869112  0.7991807 -0.6024854
## 3  0.1887816 -0.2454544  0.5491221
## 
## Clustering vector:
##  [1] 3 3 3 3 2 3 2 3 3 3 3 2 2 2 2 2 2 1 1 1
## [21] 3 2 2 2 2 1 1 1 2 3 2 3
## 
## Within cluster sum of squares by cluster:
## [1]  7.76019 33.37849 24.95528
##  (between_SS / total_SS =  64.5 %)
## 
## Available components:
## 
## [1] "cluster"      "centers"     
## [3] "totss"        "withinss"    
## [5] "tot.withinss" "betweenss"   
## [7] "size"         "iter"        
## [9] "ifault"
```

   

You don't need the `set.seed`, but if you run again, you'll get
a different answer. With the `nstart`, you'll probably get the
same clustering every time you run, but the clusters might have
different numbers, so that when you talk about "cluster 1" and then
re-run, what you were talking about might have moved to cluster 3, say.

If you are using R Markdown, for this reason, having a
`set.seed` before anything involving random number generation
is a smart move.
\marginnote{I forgot this, and then realized that I would have to rewrite a whole paragraph. In case you think I remember everything the first time.}
  


(d) Display the car names together with which cluster they are
in. If you display them all at once, sort by cluster so that it's
easier to see which clusters contain which cars. (You may have to make
a data frame first.)



Solution


As below. The car names are in the `Carname` column of the
original `cars` data frame, and the cluster numbers are in
the `cluster` part of the output from `kmeans`. You'll
need to take some action to display everything (there are only 32
cars, so it's perfectly all right to display all of them):

```r
tibble(car = cars$Carname, cluster = cars.1$cluster) %>% 
    arrange(cluster) %>% print(n = Inf)
```

```
## # A tibble: 32 x 2
##    car                 cluster
##    <chr>                 <int>
##  1 Fiat 128                  1
##  2 Honda Civic               1
##  3 Toyota Corolla            1
##  4 Fiat X1-9                 1
##  5 Porsche 914-2             1
##  6 Lotus Europa              1
##  7 Hornet Sportabout         2
##  8 Duster 360                2
##  9 Merc 450SE                2
## 10 Merc 450SL                2
## 11 Merc 450SLC               2
## 12 Cadillac Fleetwood        2
## 13 Lincoln Continental       2
## 14 Chrysler Imperial         2
## 15 Dodge Challenger          2
## 16 AMC Javelin               2
## 17 Camaro Z28                2
## 18 Pontiac Firebird          2
## 19 Ford Pantera L            2
## 20 Maserati Bora             2
## 21 Mazda RX4                 3
## 22 Mazda RX4 Wag             3
## 23 Datsun 710                3
## 24 Hornet 4 Drive            3
## 25 Valiant                   3
## 26 Merc 240D                 3
## 27 Merc 230                  3
## 28 Merc 280                  3
## 29 Merc 280C                 3
## 30 Toyota Corona             3
## 31 Ferrari Dino              3
## 32 Volvo 142E                3
```

   

Or start from the original data frame as read in from the file and
grab only what you want:


```r
cars %>% select(Carname) %>% mutate(cluster = cars.1$cluster) %>% 
    arrange(cluster) %>% print(n = Inf)
```

```
## # A tibble: 32 x 2
##    Carname             cluster
##    <chr>                 <int>
##  1 Fiat 128                  1
##  2 Honda Civic               1
##  3 Toyota Corolla            1
##  4 Fiat X1-9                 1
##  5 Porsche 914-2             1
##  6 Lotus Europa              1
##  7 Hornet Sportabout         2
##  8 Duster 360                2
##  9 Merc 450SE                2
## 10 Merc 450SL                2
## 11 Merc 450SLC               2
## 12 Cadillac Fleetwood        2
## 13 Lincoln Continental       2
## 14 Chrysler Imperial         2
## 15 Dodge Challenger          2
## 16 AMC Javelin               2
## 17 Camaro Z28                2
## 18 Pontiac Firebird          2
## 19 Ford Pantera L            2
## 20 Maserati Bora             2
## 21 Mazda RX4                 3
## 22 Mazda RX4 Wag             3
## 23 Datsun 710                3
## 24 Hornet 4 Drive            3
## 25 Valiant                   3
## 26 Merc 240D                 3
## 27 Merc 230                  3
## 28 Merc 280                  3
## 29 Merc 280C                 3
## 30 Toyota Corona             3
## 31 Ferrari Dino              3
## 32 Volvo 142E                3
```

 

This time we want to *keep* the car names and throw away
everything else.
  


(e) I have no idea whether 3 is a sensible number of clusters. To
find out, we will draw a scree plot (in a moment). Write a function
that accepts the number of clusters and the (scaled) data,
and returns the total within-cluster sum of squares.



Solution


I failed to guess (in conversation with students, back when this was
a question to be handed in) what you might
do. There are two equally good ways to tackle this part and the next:


* Write a function to calculate the total within-cluster  sum
of squares (in this part) and somehow use it in the next part,
eg. via `map_dbl` or a loop, to get the total
within-cluster sum of squares for *each* number of clusters.

* Skip the function-writing part and go directly to a loop in
the next part.

I'm good with either approach: as long as you obtain, somehow, the
total within-cluster sum of squares for each number of clusters, and
use them for making a scree plot, I think you should get the 
points for this part and the next.
I'll talk about the function way here and the loop way in the next part.

The function way is just like the one in the previous question:


```r
wss <- function(howmany, data, nstart = 20) {
    kmeans(data, howmany, nstart = 20)$tot.withinss
}
```

 

The data and number of clusters can have any names, as long as you use
whatever input names you chose within the function.

I should probably check that this works, at least on 3
clusters. Before we had


```r
cars.1$tot.withinss
```

```
## [1] 66.09396
```

 

and the function gives


```r
wss(3, cars.s)
```

```
## [1] 66.09396
```

 

Check.
I need to make sure that I used my scaled `cars` data, but I
don't need to say anything about `nstart`, since that defaults
to the perfectly suitable 20.
  


(f) Calculate the total within-group sum of squares for each
number of clusters from 2 to 10, using the function you just wrote.



Solution


The loop way. I like to define my possible numbers of clusters into
a vector first:

```r
w <- numeric(0)
nclus <- 2:10
for (i in nclus) {
    w[i] <- wss(i, cars.s)
}
w
```

```
##  [1]       NA 87.29448 66.09396 50.94273
##  [5] 38.22004 29.28816 24.23138 20.76061
##  [9] 17.58753 15.19850
```


Now that I look at this again, it occurs to me that there is no great
need to write a function to do this: you can just do what you need to
do within the loop, like this:


```r
w <- numeric(0)
nclus <- 2:10
for (i in nclus) {
    w[i] <- kmeans(cars.s, i, nstart = 20)$tot.withinss
}
w
```

```
##  [1]       NA 87.29448 66.09396 50.94273
##  [5] 38.22004 29.28816 24.23138 20.76061
##  [9] 18.22591 15.51232
```

 

You ought to have an `nstart` somewhere to make sure that
`kmeans` gets run a number of times and the best result taken. 

If you initialize your `w` with `numeric(10)` rather
than `numeric(0)`, it apparently gets filled with zeroes rather
than `NA` values. This means, later, when you come to plot your
`w`-values, the within-cluster total sum of squares will appear
to be zero, a legitimate value, for one cluster, even though it is
definitely not. (Or, I suppose, you could start your loop at 1
cluster, and get a legitimate, though very big, value for it.)
In both of the above cases, the curly brackets are optional because
there is only one line within the loop.
\marginnote{I am m accustomed to  using the curly brackets all the time, partly because my single-line loops have a habit of expanding to more than one line as I embellish what they do, and partly because I'm used to the programming language Perl where the curly brackets are obligatory even with only one line. Curly brackets in Perl serve the same purpose as indentation serves in Python: figuring out what is inside a loop or an *if* and what is outside.}

What is *actually* happening here is an implicit
loop-within-a-loop. There is a loop over `i` that goes over all
clusters, and then there is a loop over another variable, `j`
say, that loops over the `nstart` runs that we're doing for
`i` clusters, where we find the `tot.withinss` for
`i` clusters on the `j`th run, and if it's the best one
so far for `i` clusters, we save it. Or, at least,
`kmeans` saves it.

Or, using `map_dbl`, which I like better (perhaps because I
have mastered how it works):


```r
wwx <- tibble(clusters = 2:10) %>% mutate(wss = map_dbl(clusters, 
    wss, cars.s))
wwx
```

```
## # A tibble: 9 x 2
##   clusters   wss
##      <int> <dbl>
## 1        2  87.3
## 2        3  66.1
## 3        4  50.9
## 4        5  38.2
## 5        6  29.3
## 6        7  24.9
## 7        8  20.8
## 8        9  17.3
## 9       10  15.2
```

 

Note that `w` starts at 1, but `wwx` starts at 2. For
this way, you *have* to define a function first to calculate the
total within-cluster sum of squares for a given number of clusters. If
you must, you can define the function within the `map_dbl`,
but I find that very confusing to read, so I'd rather define the
function first, and then use it later. 

This one is just about simple enough to define the function within the `map_dbl`:


```r
wwx <- tibble(clusters = 2:10) %>% mutate(wss = map_dbl(clusters, 
    ~kmeans(cars.s, ., nstart = 20)$tot.withinss))
wwx
```

```
## # A tibble: 9 x 2
##   clusters   wss
##      <int> <dbl>
## 1        2  87.3
## 2        3  66.1
## 3        4  50.9
## 4        5  38.2
## 5        6  29.3
## 6        7  24.2
## 7        8  20.8
## 8        9  17.3
## 9       10  15.2
```



Instead of having a function name as the second thing in the
`map_dbl`, I have a so-called "one-sided model formula" that
begins with a squiggle, and then the definition of what I want. The
for-each part finds its way into here as a dot (the number of
clusters, here); this is the equivalent of the `i` in the loop.

The upshot of all of this is that if you had obtained a total
within-cluster sum of squares for each number of clusters,
*somehow*, and it's correct, you should have gotten the
points
\marginnote{When this was a question to hand in, which it is not any  more.} for this part and the last part. This is a common principle
of mine, and works on exams as well as assignments; it goes back to
the idea of "get the job done" that you first saw in C32.

  


(g) Make a scree plot, using the total within-cluster sums of
squares values that you calculated in the previous part. 



Solution


If you did this the loop way, it's tempting to leap into this:

```r
d <- data.frame(clusters = nclus, wss = w)
```

```
## Error in data.frame(clusters = nclus, wss = w): arguments imply differing number of rows: 9, 10
```

   

and then wonder why it doesn't work. The problem is that `w`
has 10 things in it, including an `NA` at the front (as a
placeholder for 1 cluster):


```r
w
```

```
##  [1]       NA 87.29448 66.09396 50.94273
##  [5] 38.22004 29.28816 24.23138 20.76061
##  [9] 18.22591 15.51232
```

```r
nclus
```

```
## [1]  2  3  4  5  6  7  8  9 10
```



while `nclus` only has 9. So do something like this instead:


```r
tibble(clusters = 1:10, wss = w) %>% ggplot(aes(x = clusters, 
    y = wss)) + geom_point() + geom_line()
```

```
## Warning: Removed 1 rows containing missing values
## (geom_point).
```

```
## Warning: Removed 1 rows containing missing
## values (geom_path).
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-119-1} 

 

This gives a warning because there is no 1-cluster `w`-value,
but the point is properly omitted from the plot, so the plot you get
is fine.

Or plot the output from `map_dbl`, which is easier since it's
already a data frame:


```r
wwx %>% ggplot(aes(x = clusters, y = wss)) + geom_point() + 
    geom_line()
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-120-1} 

 

  


(h) What is a suitable number of clusters for K-means, based on
your scree plot?



Solution


That seems to me to have a clear elbow at 6, suggesting six
clusters.
\marginnote{We do something similar on scree plots for principal components later, but then, for reasons that will become clear then, we take elbow *minus 1*.} Look for where the plot 
"turns the corner" from going down to going out, or the point that is the 
"last  one on the mountain and the first one on the scree". This
mountainside goes down to 6, and from there it seems to turn the
corner and go out after that. 

This is a judgement call, but this particular one is about as clear as
you can expect to see.

I wanted a picture of some real scree. This one shows what I mean:


![](scree.png)


Note the rock face and
the loose rock below, which is the scree. Imagine looking at the rock
face and scree from side-on. This is in north Wales, the
other end of Wales from Llanederyn/Llanedeyrn and Caldicot.

The above photo is from [link](http://www.geograph.org.uk/photo/159935).
  


(i) Run a K-means analysis using the number of clusters suggested
by your scree plot, and list the car names together with the clusters
they belong to, *sorted by cluster*.



Solution


This is the same idea as above. The `arrange` idea from above
seems to be the cleanest way to arrange the output:
The K-means analysis is thus:

```r
cars.2 <- kmeans(cars.s, 6, nstart = 20)
```

  

or use whatever number of clusters you thought was good from your
scree plot.

Then display them:


```r
cars %>% select(Carname) %>% mutate(cluster = cars.2$cluster) %>% 
    arrange(cluster) %>% print(n = Inf)
```

```
## # A tibble: 32 x 2
##    Carname             cluster
##    <chr>                 <int>
##  1 Fiat 128                  1
##  2 Honda Civic               1
##  3 Toyota Corolla            1
##  4 Fiat X1-9                 1
##  5 Porsche 914-2             1
##  6 Lotus Europa              1
##  7 Hornet 4 Drive            2
##  8 Valiant                   2
##  9 Merc 240D                 2
## 10 Merc 230                  2
## 11 Toyota Corona             2
## 12 Cadillac Fleetwood        3
## 13 Lincoln Continental       3
## 14 Chrysler Imperial         3
## 15 Hornet Sportabout         4
## 16 Merc 450SE                4
## 17 Merc 450SL                4
## 18 Merc 450SLC               4
## 19 Dodge Challenger          4
## 20 AMC Javelin               4
## 21 Pontiac Firebird          4
## 22 Duster 360                5
## 23 Camaro Z28                5
## 24 Ford Pantera L            5
## 25 Maserati Bora             5
## 26 Mazda RX4                 6
## 27 Mazda RX4 Wag             6
## 28 Datsun 710                6
## 29 Merc 280                  6
## 30 Merc 280C                 6
## 31 Ferrari Dino              6
## 32 Volvo 142E                6
```

 

The logic to this is the same as above.
I don't have a good feeling for what the cars within a cluster have in
common, by eyeballing the names, except for possibly a couple of
things: my cluster 1 seems to be mostly family cars, and my cluster 3
appears to contain "boats" (large cars that consume a lot of
gas). Your clusters ought to be about the same in terms of membership,
but might be numbered differently.

To understand these clusters further, we can use them as input to a
discriminant analysis. There isn't any real need to run a MANOVA
first, since we kind of know that these groups will be different
(that's why we ran a cluster analysis).

So, first we'll make a data frame with the whole original data set
plus the clusters that came out of the K-means. We are adding the
clusters to `cars`, so it makes sense to use the same ideas as I used
above (without the `arrange`, that being only for looking at,
and without the `select`, since this time I want all the
variables that were in `cars`):


```r
carsx <- cars %>% mutate(cluster = cars.2$cluster)
```

 
Now we fire away:


```r
carsx.1 <- lda(cluster ~ mpg + disp + hp + drat + 
    wt + qsec, data = carsx)
carsx.1
```

```
## Call:
## lda(cluster ~ mpg + disp + hp + drat + wt + qsec, data = carsx)
## 
## Prior probabilities of groups:
##       1       2       3       4       5 
## 0.18750 0.15625 0.09375 0.21875 0.12500 
##       6 
## 0.21875 
## 
## Group means:
##        mpg     disp       hp     drat
## 1 30.06667  86.6500  75.5000 4.251667
## 2 21.64000 178.1200  93.8000 3.430000
## 3 11.83333 457.3333 216.6667 3.053333
## 4 16.78571 315.6286 170.0000 3.050000
## 5 14.60000 340.5000 272.2500 3.675000
## 6 20.41429 147.0286 120.4286 3.888571
##         wt     qsec
## 1 1.873000 18.39833
## 2 3.096000 20.51400
## 3 5.339667 17.74000
## 4 3.688571 17.32000
## 5 3.537500 15.08750
## 6 2.892143 17.62714
## 
## Coefficients of linear discriminants:
##              LD1           LD2         LD3
## mpg  -0.19737944 -0.0155769096 -0.27978549
## disp  0.01950855 -0.0001094137 -0.02090998
## hp    0.02804348  0.0251253160 -0.01727355
## drat  0.94348424  1.8928372037  0.56645563
## wt    0.39068831 -1.3973097325  1.84808828
## qsec  0.33992344 -0.3010056176 -0.66690927
##               LD4          LD5
## mpg   0.353766928  0.035582922
## disp  0.001034719  0.001680201
## hp   -0.015955928 -0.017220548
## drat  1.264185553 -2.015644662
## wt    2.963377419 -0.300573153
## qsec -0.755053279 -0.738889640
## 
## Proportion of trace:
##    LD1    LD2    LD3    LD4    LD5 
## 0.7977 0.1234 0.0368 0.0299 0.0122
```

 

At the bottom (in `trace`) you see that `LD1` is clearly
the most important thing for splitting into groups, `LD2` might
be slightly relevant, and the other `LD`s are basically
meaningless. So a plot of the first two `LD`s should tell the story.

Before we get to that, however, we can take a look at the Coefficients
of Linear Discriminants, for `LD1` and `LD2`
anyway. `LD1` depends principally on `drat`, `wt`
and `qsec` (positively) and maybe negatively on
`mpg`. That means `LD1` will be large if the car is
powerful, heavy, *slow* (since a larger `qsec` means the
car takes longer to go a quarter mile) and consumes a lot of gas. I
think I can summarize this as "powerful". 

`LD2` also depends on `drat` and `wt`,
but note the signs: it is contrasting `drat` (displacement
ratio) with `wt` (weight), so that a car with a large
displacement ratio relative to its weight would be large (plus) on
`LD2`. That is, `LD2` is "powerful for its weight".

All right, now for a plot, with the points colour-coded by
cluster. There are two ways to do this; the easy one is
`ggbiplot`. The only weirdness here is that the
`cluster`s are numbered, so you have to turn that into a factor
first (unless you like shades of blue). I didn't load the package
first, so I call it here with the package name and the two colons:


```r
ggbiplot::ggbiplot(carsx.1, groups = factor(carsx$cluster))
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-125-1} 

 
Or you can do the predictions, then plot `LD1` against
`LD2`, coloured by cluster:


```r
p <- predict(carsx.1)
data.frame(p$x, cluster = factor(carsx$cluster)) %>% 
    ggplot(aes(x = LD1, y = LD2, colour = cluster)) + 
    geom_point() + coord_fixed()
```


\includegraphics{22-thingy_files/figure-latex/unnamed-chunk-126-1} 

 

The pattern of coloured points is the same. The advantage to the
biplot is that you see which original variables contribute to the
`LD` scores and thus distinguish the clusters; on the second
plot, you have to figure out for yourself which original variables
contribute, and how, to the `LD` scores.

You should include `coord_fixed` to make the axis scales the
same, since allowing them to be different will distort the picture
(the picture should come out square). You do the same thing in
multidimensional scaling.

As you see, `LD1` is doing the best job of separating the
clusters, but `LD2` is also doing something: separating
clusters 1 and 5, and also 2 and 4 (though 4 is a bit bigger than 2 on
`LD1` also). 

I suggested above that `LD1` seems to be "powerful"
(on the right) vs.\ not (on the left). The displacement ratio is a
measure of the power of an engine, so a car
that is large on `LD2` is powerful for  its weight.

Let's find the clusters I mentioned before. Cluster 3 was the
"boats": big engines and heavy cars, but not fast. So they
should be large `LD1` and small (negative)
`LD2`. Cluster 1 I called "family cars": they are not
powerful, but have moderate-to-good power for their weight.

With that in mind, we can have a crack at the other clusters. Cluster
2 is neither powerful nor powerful-for-weight  (I don't know these
cars, so can't 
comment further) while cluster 5 is powerful and also powerful for
their weight, so these
might be sports cars. Clusters 6 and 4 are less and more
powerful, both averagely powerful for their size.
  





##  Running, jumping, and throwing


 The decathlon is a men's
\marginnote{Women  compete in a similar competition called the *heptathlon* with seven  events.} track-and-field competition in which competitors complete 10
events over two days as follows, requiring the skills shown:


\begin{tabular}{ll}
Event & Skills \\
\hline
100m & Running, speed\\
Long jump & Jumping, speed \\
Shot put & Throwing, strength\\
High jump & Jumping, agility\\ 
400m & Running, speed\\
110m hurdles & Running, jumping, speed\\
Discus & Throwing, agility (and maybe strength)\\
Pole vault & Jumping, agility\\
Javelin & Throwing, agility\\
1500m & Running, endurance\\
\hline
\end{tabular}


These are a mixture of running, jumping and throwing disciplines. The
performance (time, distance or height) achieved in each event is
converted to a number of points using standard tables,
\marginnote{How I  understand it works is that  a *good* performance in an event is  worth 1000 points, and then, according to the event, each second or  centimetre better or worse than this is worth a certain number of  points up or down from 1000. At this level, the winner of the whole  decathlon will get somewhere near 10,000 points. A look at the  Wikipedia article reveals that it is not quite as simple as this,  but this is the idea.} and the winner of the entire decathlon is the
competitor with the largest total of points. (A good decathlete has to
be at least reasonably good at all the disciplines.)

For the decathlon competition at the 2013 Track and Field World
Championship, a record was kept of each competitor's performance in
each event (for the competitors that competed in all ten
events). These values are in
[link](http://www.utsc.utoronto.ca/~butler/d29/dec2013.txt). 



(a) Read in the data and verify that you have the right number
of variables. 


Solution


Checking the file, this is delimited by single spaces. You might
be concerned by the quotes; we'll read them in and see what
happens to them.

```r
my_url <- "http://www.utsc.utoronto.ca/~butler/d29/dec2013.txt"
decathlon0 <- read_delim(my_url, " ")
```

```
## Parsed with column specification:
## cols(
##   name = col_character(),
##   x100m = col_double(),
##   long.jump = col_double(),
##   shot.put = col_double(),
##   high.jump = col_double(),
##   x400m = col_double(),
##   x110mh = col_double(),
##   discus = col_double(),
##   pole.vault = col_double(),
##   javelin = col_double(),
##   x1500m = col_double()
## )
```

```r
decathlon0
```

```
## # A tibble: 24 x 11
##    name  x100m long.jump shot.put high.jump
##    <chr> <dbl>     <dbl>    <dbl>     <dbl>
##  1 Asht~  10.4      7.73     14.4      1.93
##  2 Dami~  10.4      7.39     14.2      2.05
##  3 Rico~  10.6      7.22     14.8      1.99
##  4 Miha~  10.7      7.51     13.4      1.96
##  5 Mich~  10.7      7.85     14.6      1.99
##  6 Carl~  10.8      7.54     14.5      1.96
##  7 Gunn~  10.8      7.8      14.7      2.14
##  8 Eelc~  10.8      7.65     14.1      2.02
##  9 Pasc~  11.0      7.19     15.9      1.99
## 10 Will~  11.0      7.44     13.9      2.05
## # ... with 14 more rows, and 6 more
## #   variables: x400m <dbl>, x110mh <dbl>,
## #   discus <dbl>, pole.vault <dbl>,
## #   javelin <dbl>, x1500m <dbl>
```

     

The names got shortened for display, but the quotes seem to have
properly disappeared.

Note that the columns that would otherwise start with digits have
`x` on the front of their names, so as to guarantee that the
column names are legal variable names (and thus won't require any
special treatment later).
    


(b) Some of the performances are times in seconds, and some of
them are distances (or heights) in metres. Also, some of the columns
are more variable than others. Produce a matrix of standardized
performances in each event, making sure not to try to standardize
the names!


Solution


`scale` is what I am trying to hint towards. Leave off the
first column. I would rather specify this by name than by
number. (People have an annoying habit of changing the order of
columns, but the column *name* is more work to change and
thus it is less likely that it will change.)


     

```r
decathlon <- decathlon0 %>% select(-name) %>% scale()
round(decathlon, 2)
```

```
##       x100m long.jump shot.put high.jump x400m x110mh discus pole.vault javelin x1500m
##  [1,] -2.21      1.24     0.29     -0.95 -2.43  -1.77   0.27       1.10    0.55  -0.49
##  [2,] -1.92      0.16     0.03      0.74 -0.46  -1.23  -0.06      -0.39    0.52  -0.46
##  [3,] -1.33     -0.38     0.96     -0.11 -0.75  -1.37   1.71      -0.02   -1.17   0.63
##  [4,] -1.08      0.54    -1.24     -0.53 -1.02   0.17  -0.09      -0.02   -0.60  -0.93
##  [5,] -0.87      1.62     0.57     -0.11 -1.08  -0.50   0.82       0.36    0.72  -1.10
##  [6,] -0.69      0.64     0.46     -0.53 -0.13  -1.03   0.59       0.73   -0.42   0.37
##  [7,] -0.48      1.46     0.77      2.01 -0.33   0.13  -0.73      -1.14   -0.82   0.35
##  [8,] -0.45      0.99    -0.21      0.32 -0.59  -0.74  -1.95       1.48   -1.06  -1.20
##  [9,] -0.10     -0.47     2.68     -0.11 -0.46  -0.12   0.53      -0.76    1.00   0.54
## [10,] -0.10      0.32    -0.54      0.74 -0.53  -0.47  -0.40      -1.51    1.45  -1.21
## [11,] -0.02      0.03    -0.54      0.74 -0.47  -0.39  -0.09       1.85   -0.52   0.50
## [12,] -0.02      0.26    -0.10     -0.53 -0.13   0.69   1.42      -1.14   -2.26   0.06
## [13,]  0.01     -0.12    -0.02     -1.37  1.80   1.60   0.37      -1.51    1.46   1.82
## [14,]  0.33     -0.03    -0.02     -1.37 -0.62   0.24   0.81      -0.02    1.30  -1.31
## [15,]  0.40      0.95    -1.04      0.74  0.03   0.33  -1.20       0.73    0.65   0.64
## [16,]  0.47     -0.79     0.36     -0.11  0.04  -0.68  -0.09       0.36   -0.05  -0.05
## [17,]  0.57     -0.19    -0.60      0.32  1.07   1.51  -0.69      -1.51   -0.95   0.72
## [18,]  0.61     -2.09    -1.63     -1.37 -0.24  -0.32  -2.39       0.73    0.46   0.36
## [19,]  0.75      0.16     1.03      1.59  0.57  -0.16   0.70       0.73   -0.42   0.88
## [20,]  0.82     -0.25    -0.86      1.59  1.36   1.74  -0.94      -0.02   -0.49   2.07
## [21,]  0.89      0.51    -0.73      0.74  0.47  -0.68   0.41       1.10    0.80  -1.14
## [22,]  1.24     -0.69     1.07     -0.11  0.73   0.06   1.26       0.36    0.16  -0.02
## [23,]  1.56     -2.28     0.98     -1.80  1.32   1.18  -0.69      -1.51   -1.44  -1.83
## [24,]  1.63     -1.58    -1.69     -0.53  1.85   1.80   0.39      -0.02    1.11   0.78
## attr(,"scaled:center")
##      x100m  long.jump   shot.put  high.jump      x400m     x110mh     discus pole.vault 
##  10.977083   7.339167  14.209583   1.997500  48.960000  14.512500  44.288333   4.904167 
##    javelin     x1500m 
##  62.069583 273.306667 
## attr(,"scaled:scale")
##      x100m  long.jump   shot.put  high.jump      x400m     x110mh     discus pole.vault 
## 0.28433720 0.31549708 0.61480629 0.07091023 1.20878667 0.44795429 2.60828224 0.26780779 
##    javelin     x1500m 
## 5.01529875 7.22352899
```

     
I think the matrix of standardized values is small enough to look at
all  of, particularly if I round off the values to a small number of
decimals. (Note that the means and SDs
appear at the bottom as "attributes".)
    



   

(c) We are going to make a scree plot to decide on the number
of clusters our K-means clustering should use. Using a loop, or
otherwise,
\marginnote{I grew up in the UK, and when I saw that in an    exam, it was code for *the way they say is obvious but long, and    the otherwise-way is clever but short*. I think this is one of    those.} obtain the total within-cluster sum of squares for these
data for each number of clusters for 2 up to 20.


Solution


Having kind of given the game away in the footnote, I guess I now
have to keep up my end of the deal and show you the obvious way
and the clever way.
The obvious way is to do a Python-style loop, thus:

```r
maxclust
```

```
## [1] 20
```

```r
w <- numeric(0)
for (i in 2:maxclust) {
    sol <- kmeans(decathlon, i, nstart = 20)
    w[i] <- sol$tot.withinss
}
w
```

```
##  [1]        NA 175.03246 151.08750 131.30247 113.59681 102.61744  89.64931  78.89089
##  [9]  68.99662  60.77665  54.29991  47.64227  41.40352  35.39181  29.52008  25.05344
## [17]  21.02841  17.28444  13.80627  10.44197
```


I defined `maxclust` earlier, surreptitiously. (Actually, what
happened was that I changed my mind about how many clusters I wanted
you to go up to, so that instead of hard-coding the maximum number of
clusters, I decided to put it in a variable so that I only had to
change it once if I changed my mind again.)

I decided to split the stuff within the loop into two lines, first
getting the $i$-cluster solution, and then pulling out the total
within-cluster sum of squares from it and saving it in the right place
in `w`. You can do it in one step or two; I don't mind.

The first value in `w` is missing, because we didn't calculate
a value for 1 cluster (so that this `w` has 20 values, one of
which is missing).

Not that there's anything wrong with this,
\marginnote{I have to sneak a  Seinfeld quote in there somewhere.} and if it works, it's good, but the
True R Way
\marginnote{Like Buddhism. I keep feeling that R should have  something called the Eight Noble Truths or similar. See the Extra at the end of this part.} is not to use a
loop, but get the whole thing in one shot. 
The first stage is to figure out what you want to do for some number of clusters. In this case, it's something like this:

```r
kmeans(decathlon, 3, nstart = 20)$tot.withinss
```

```
## [1] 151.0875
```

 

There's nothing special about 3; any number will do. 

The second stage is to run this for each desired number of
clusters, without using a loop. 
This uses a family of functions whose
names start with `map`. To figure out which one to
use, take a look at your line of code above: ours returns a single number, a
`double` in the jargon (decimal number), so the `map`
function we need is called `map_dbl`, and it goes like
this. You can do it inside or outside a data frame, but I prefer to do
it inside with a `mutate`:


```r
ww <- tibble(clusters = 2:maxclust) %>% mutate(wss = map_dbl(clusters, ~kmeans(decathlon, ., 
    nstart = 20)$tot.withinss))
ww
```

```
## # A tibble: 19 x 2
##    clusters   wss
##       <int> <dbl>
##  1        2 175. 
##  2        3 151. 
##  3        4 131. 
##  4        5 114. 
##  5        6 100. 
##  6        7  89.5
##  7        8  78.8
##  8        9  69.0
##  9       10  60.8
## 10       11  54.3
## 11       12  48.1
## 12       13  41.4
## 13       14  35.4
## 14       15  29.5
## 15       16  25.1
## 16       17  21.0
## 17       18  17.3
## 18       19  13.8
## 19       20  10.4
```

 

I have to say that I got this right the first time, but I think I
benefitted greatly in that regard by writing out that explanation for
you first. `wss` in `ww` has the same values as
`w`, but without the missing one.

There was (still is) also a function `sapply` that does the
same thing, but the `map` functions work more uniformly. I
learned `sapply` and friends a long time ago, and now, with the
arrival of purrr, I think I need to unlearn them.

If the thing in the "for each" slot of a `map` is a data
frame (or if you pipe a data frame into it), then the function is
applied to every column of that data frame, so that if I go back to
`decathlon0`, which was a data frame, and do this:



 


```r
decathlon.tmp <- decathlon0 %>% select(-name)
decathlon.tmp %>% map_dbl(~mean(.))
```

```
##      x100m  long.jump   shot.put  high.jump      x400m     x110mh 
##  10.977083   7.339167  14.209583   1.997500  48.960000  14.512500 
##     discus pole.vault    javelin     x1500m 
##  44.288333   4.904167  62.069583 273.306667
```

 

then what I get is the mean of each (numeric) column. I first get rid
of the name column, and save the result in a new temporary data frame
`decathlon.tmp`;
the `name` column would be a
pretty silly thing to take the mean of.

I wrote this out a couple of years ago, and realize that I no longer
like doing things this way; what I prefer is `summarize_at` or
`summarize_if` or 
`summarize_all`. These work in much
the same way as a `map`, dot and all. The last one is easiest:


```r
decathlon0 %>% select(-name) %>% summarize_all(~mean(.))
```

```
## # A tibble: 1 x 10
##   x100m long.jump shot.put high.jump x400m x110mh discus pole.vault
##   <dbl>     <dbl>    <dbl>     <dbl> <dbl>  <dbl>  <dbl>      <dbl>
## 1  11.0      7.34     14.2      2.00  49.0   14.5   44.3       4.90
## # ... with 2 more variables: javelin <dbl>, x1500m <dbl>
```

 

That is, "for each column, find the mean of it". 

The `_if` variant uses only those columns that have a property
like being numeric (so that these are the only columns for which
finding the mean makes sense):


```r
decathlon0 %>% summarize_if(is.numeric, ~mean(.))
```

```
## # A tibble: 1 x 10
##   x100m long.jump shot.put high.jump x400m x110mh discus pole.vault
##   <dbl>     <dbl>    <dbl>     <dbl> <dbl>  <dbl>  <dbl>      <dbl>
## 1  11.0      7.34     14.2      2.00  49.0   14.5   44.3       4.90
## # ... with 2 more variables: javelin <dbl>, x1500m <dbl>
```

 

In words, "for each column that is numeric, find the mean of it". 
This way, we no longer have to explicitly remove the names.

The `_at` variant only uses the columns whose *names*
satisfy some property, like beginning with `x`:


```r
decathlon0 %>% summarize_at(vars(starts_with("x")), ~mean(.))
```

```
## # A tibble: 1 x 4
##   x100m x400m x110mh x1500m
##   <dbl> <dbl>  <dbl>  <dbl>
## 1  11.0  49.0   14.5   273.
```

 

In words, "for each variable whose name starts with `x`, find the mean of it."
Now, what happens, I hear you asking, if the function returns more than one
thing, like for example `quantile`, which returns a vector
containing the five-number summary? Well, then you use `map_df`
and you get this:

```r
decathlon.tmp %>% map_df(~quantile(.))
```

```
## # A tibble: 5 x 10
##   x100m long.jump shot.put high.jump x400m x110mh discus pole.vault
##   <dbl>     <dbl>    <dbl>     <dbl> <dbl>  <dbl>  <dbl>      <dbl>
## 1  10.4      6.62     13.2      1.87  46.0   13.7   38.1       4.5 
## 2  10.8      7.21     13.8      1.96  48.3   14.2   42.5       4.68
## 3  11.0      7.37     14.2      1.99  48.7   14.4   44.6       4.9 
## 4  11.2      7.52     14.6      2.05  49.7   14.7   45.9       5.1 
## 5  11.4      7.85     15.9      2.14  51.2   15.3   48.7       5.4 
## # ... with 2 more variables: javelin <dbl>, x1500m <dbl>
```

 

The idea is that `quantile` returns something that can be
treated as a one-column data frame, and `map_df` says
"`quantile` returns a data frame rather than just a number."
The only downside is that `quantile` actually (for each
variable) returns a vector with a name attribute (the names of the
five percentiles that were calculated), and the `tidyverse`
treats those like row names and discards them.

Another way that might work (and might keep the quantiles) is


```r
decathlon.tmp %>% map_df(~enframe(quantile(.)))
```

```
## # A tibble: 50 x 2
##    name  value
##    <chr> <dbl>
##  1 0%    10.4 
##  2 25%   10.8 
##  3 50%   11.0 
##  4 75%   11.2 
##  5 100%  11.4 
##  6 0%     6.62
##  7 25%    7.21
##  8 50%    7.37
##  9 75%    7.52
## 10 100%   7.85
## # ... with 40 more rows
```

 
This keeps the quantiles, but loses the variable names!

All right, let's make the data frame long before taking quantiles,
since the Tidyverse likes that kind of thing better anyway. This is
the same kind of idea that you might have seen for plotting the
residuals against *all* the $x$-variables in a multiple regression:


```r
quantiles.long <- decathlon.tmp %>% gather(event, performance, everything()) %>% 
    nest(-event) %>% mutate(quantile = map(data, ~enframe(quantile(.$performance), 
    name = "quantile", value = "perf"))) %>% unnest(quantile)
quantiles.long
```

```
## # A tibble: 50 x 3
##    event     quantile  perf
##    <chr>     <chr>    <dbl>
##  1 x100m     0%       10.4 
##  2 x100m     25%      10.8 
##  3 x100m     50%      11.0 
##  4 x100m     75%      11.2 
##  5 x100m     100%     11.4 
##  6 long.jump 0%        6.62
##  7 long.jump 25%       7.21
##  8 long.jump 50%       7.37
##  9 long.jump 75%       7.52
## 10 long.jump 100%      7.85
## # ... with 40 more rows
```

 

To follow this, run it one line at a time. The `nest(-event)`
line creates a two-column data frame that contains a column called
`event` and a second column `data` that contains
everything else (just `performance` in this case). Then the big `mutate` line says "for each data frame in `data`, calculate the quantiles of the performance column in it, giving names to the columns of the output". 
This produces a second list-column called `quantile`, which I
then `unnest` to display all the quantiles for each event.

Almost there. Now we have both the events and the quantiles, but it would be nice to put the quantiles in columns. Which seems to be `spread`:


```r
quantiles.long %>% spread(quantile, perf)
```

```
## # A tibble: 10 x 6
##    event        `0%` `100%`  `25%`  `50%`  `75%`
##    <chr>       <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
##  1 discus      38.1   48.7   42.5   44.6   45.9 
##  2 high.jump    1.87   2.14   1.96   1.99   2.05
##  3 javelin     50.7   69.4   58.8   62.4   65.8 
##  4 long.jump    6.62   7.85   7.21   7.37   7.52
##  5 pole.vault   4.5    5.4    4.68   4.9    5.1 
##  6 shot.put    13.2   15.9   13.8   14.2   14.6 
##  7 x100m       10.4   11.4   10.8   11.0   11.2 
##  8 x110mh      13.7   15.3   14.2   14.4   14.7 
##  9 x1500m     260.   288.   266.   275.   278.  
## 10 x400m       46.0   51.2   48.3   48.7   49.7
```

 

except that now the quantiles are in the wrong order! Because they are
text, they are sorted into alphabetical order by `spread`. So
we need to turn them into numbers first. I overwrite the quantiles
with the numeric versions of themselves (see what happens if you
don't):


```r
quantiles.long %>% mutate(quantile = parse_number(quantile)) %>% spread(quantile, 
    perf)
```

```
## # A tibble: 10 x 6
##    event         `0`   `25`   `50`   `75`  `100`
##    <chr>       <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
##  1 discus      38.1   42.5   44.6   45.9   48.7 
##  2 high.jump    1.87   1.96   1.99   2.05   2.14
##  3 javelin     50.7   58.8   62.4   65.8   69.4 
##  4 long.jump    6.62   7.21   7.37   7.52   7.85
##  5 pole.vault   4.5    4.68   4.9    5.1    5.4 
##  6 shot.put    13.2   13.8   14.2   14.6   15.9 
##  7 x100m       10.4   10.8   11.0   11.2   11.4 
##  8 x110mh      13.7   14.2   14.4   14.7   15.3 
##  9 x1500m     260.   266.   275.   278.   288.  
## 10 x400m       46.0   48.3   48.7   49.7   51.2
```

 

and that looks nice.
Extra: I made a post on Twitter, [link](https://twitter.com/KenButler12/status/1100133496637542401). 
To which Malcolm Barrett replied with this: [link](https://twitter.com/malco_barrett/status/1100141130186780672) 
and this: [link](https://twitter.com/malco_barrett/status/1100140736945647616). 
So now you know all about the Four Noble R Truths.

    


(d) Using what you calculated in the previous part, draw a scree
plot. (You may have to create a data frame first.) How does your
scree plot tell you that 5 is a possible number of clusters? Explain
briefly.



Solution


This requires a teeny bit of care. If you went the loop way, what I
called `w` has a missing value first (unless you were
especially careful), so you have to plot it against *1* through 20:

```r
tibble(clusters = 1:maxclust, wss = w) %>% ggplot(aes(x = clusters, y = wss)) + 
    geom_point() + geom_line()
```

```
## Warning: Removed 1 rows containing missing values (geom_point).
```

```
## Warning: Removed 1 rows containing missing values (geom_path).
```


\includegraphics{22-thingy_files/figure-latex/freddo-1} 

   

The warning message is to say that you don't have a total
within-cluster sum of squares for 1 cluster, which you knew already.

Or you can save the data frame first and then feed it into
`ggplot`. 

If you went the `map` way, you will have the `wss`
values for 2 through 20 clusters already in a data
frame, so it is a fair bit simpler:


```r
ww %>% ggplot(aes(x = clusters, y = wss)) + geom_point() + geom_line()
```


\includegraphics{22-thingy_files/figure-latex/bilharzia-1} 

 

There is, I suppose, the tiniest elbow at 5 clusters. It's not very
clear, though. I would have liked it to be clearer.
  


(e) Run K-means with 5 clusters. Produce an output that shows
which competitors are in which cluster.



Solution


If you're using R Markdown, you might like to start with this:

```r
set.seed(457299)
```

 

or some other random number seed of your choice. Using
`nstart=20` or similar will give you the same *clustering*,
but which cluster is cluster 1 might vary between runs. So if you talk
about cluster 1 (below), and re-knit the document, you might otherwise
find that cluster 1 has changed identity since the last time you
knitted it. (I just remembered that for these solutions.)

Running the `kmeans` itself is a piece of cake, since you have
done it a bunch of times already (in your loop or `map`):

```r
decathlon.1 <- kmeans(decathlon, 5, nstart = 20)
decathlon.1
```

```
## K-means clustering with 5 clusters of sizes 6, 5, 8, 1, 4
## 
## Cluster means:
##         x100m   long.jump   shot.put     high.jump      x400m
## 1 -0.97448850  0.64184430 -0.1484207 -2.467909e-01 -1.0216857
## 2  0.28457995  0.07871177 -0.8288519  2.326886e-01 -0.1588370
## 3 -0.02051555  0.02245134  0.9034011  2.644188e-01 -0.0589434
## 4  1.55771620 -2.27947172  0.9765949 -1.798048e+00  1.3236413
## 5  0.75760985 -0.53619092 -0.7922550 -1.554312e-15  1.5180512
##       x110mh     discus  pole.vault     javelin     x1500m
## 1 -0.5934385  0.2274805 -0.07779211  0.65707285 -0.9136808
## 2 -0.3582955 -1.0406594  1.17932839  0.06548297 -0.1670467
## 3 -0.3097414  0.6739749 -0.10890895 -0.49565010  0.3441300
## 4  1.1775755 -0.6894704 -1.50916693 -1.43751822 -1.8269002
## 5  1.6631161 -0.2159787 -0.76236268  0.28321676  1.3477946
## 
## Clustering vector:
##  [1] 1 1 3 1 1 3 3 2 3 1 2 3 5 1 2 3 5 2 3 5 2 3 4 5
## 
## Within cluster sum of squares by cluster:
## [1] 27.08131 26.24500 41.40072  0.00000 18.86978
##  (between_SS / total_SS =  50.6 %)
## 
## Available components:
## 
## [1] "cluster"      "centers"      "totss"        "withinss"    
## [5] "tot.withinss" "betweenss"    "size"         "iter"        
## [9] "ifault"
```

   

I displayed the result, so that I would know which of the things I
needed later. The `Available components` at the bottom is a big
hint with this.

To display who is in which cluster, it's easiest to
make a data frame of names and clusters and sort it:


```r
tibble(name = decathlon0$name, cluster = decathlon.1$cluster) %>% arrange(cluster) %>% 
    print(n = Inf)
```

```
## # A tibble: 24 x 2
##    name                    cluster
##    <chr>                     <int>
##  1 Ashton Eaton                  1
##  2 Damian Warner                 1
##  3 Mihail Dudas                  1
##  4 Michael Schrader              1
##  5 Willem Coertzen               1
##  6 Leonel Suarez                 1
##  7 Eelco Sintnicolaas            2
##  8 Ilya Shkurenyov               2
##  9 Thomas van der Plaetsen       2
## 10 Pelle Rietveld                2
## 11 Kevin Mayer                   2
## 12 Rico Freimuth                 3
## 13 Carlos Chinin                 3
## 14 Gunnar Nixon                  3
## 15 Pascal Behrenbruch            3
## 16 Eduard Mikhan                 3
## 17 Artem Lukyanenko              3
## 18 Andrei Krauchanka             3
## 19 Mikk Pahapill                 3
## 20 Marcus Nilsson                4
## 21 Sergey Sviridov               5
## 22 Brent Newdick                 5
## 23 Maicel Uibo                   5
## 24 Keisuke Ushiro                5
```

 
  


(f) Display the cluster means for all of the events. (This has
already been calculated; you just have to display it.) Find the
cluster mean, looking at all of the events, that is farthest from
zero, and see if you can describe the strengths and weaknesses of the
athletes in that cluster (look at all the events for the cluster that
has that extreme mean). Bear in mind (i) that these are the original
performances standardized, and (ii) for a running event, a
*smaller* value is better.



Solution


This is the thing called `centers`:
\marginnote{We are no longer    in the *tidyverse*, so you no longer have the option of    using British or American spelling.}

```r
decathlon.1$centers
```

```
##         x100m   long.jump   shot.put     high.jump      x400m
## 1 -0.97448850  0.64184430 -0.1484207 -2.467909e-01 -1.0216857
## 2  0.28457995  0.07871177 -0.8288519  2.326886e-01 -0.1588370
## 3 -0.02051555  0.02245134  0.9034011  2.644188e-01 -0.0589434
## 4  1.55771620 -2.27947172  0.9765949 -1.798048e+00  1.3236413
## 5  0.75760985 -0.53619092 -0.7922550 -1.554312e-15  1.5180512
##       x110mh     discus  pole.vault     javelin     x1500m
## 1 -0.5934385  0.2274805 -0.07779211  0.65707285 -0.9136808
## 2 -0.3582955 -1.0406594  1.17932839  0.06548297 -0.1670467
## 3 -0.3097414  0.6739749 -0.10890895 -0.49565010  0.3441300
## 4  1.1775755 -0.6894704 -1.50916693 -1.43751822 -1.8269002
## 5  1.6631161 -0.2159787 -0.76236268  0.28321676  1.3477946
```

   

My most extreme value is the $-2.28$ in the long jump column, cluster
4. Yours may well be different, since the formation of clusters is
random: it will probably not be the same number cluster, and it might
not even be the same value. Use whatever you have. (I asked you to
find the most extreme one so that the other events in the same cluster
are likely to be extreme as well and you have something to say.)

So I have to look along my cluster 4 row. I see:



* 100m run high (bad)

* long jump low (bad)

* shot put high (good)

* high jump low (bad)

* 400m run high (bad)

* 110m hurdles run high (bad)

* discus lowish (bad)

* pole vault low (bad)

* javelin low (bad)

* 1500m low (good)


The only two good events here are shot put (throwing a heavy ball) and
1500m (a long run). So what these athletes have in common is good strength
and endurance, and bad speed and agility. (You can use my 
"skills required" in the table at the top of the question as a guide.)

I said "these athletes". I actually meant "this athlete", since
this is the cluster with just Marcus Nilsson in it. I ought to have
checked that we were looking at a cluster with several athletes in it,
and then this question would have made more sense, but the thought
process is the same, so it doesn't matter so much.

Your cluster may well be different; I'm looking for some sensible
discussion based on the values you have. I'm hoping that the athletes
in your cluster will tend to be good at something and bad at something
else, and the things they are good at (or bad at) will have something
in common.

What would have made more sense would have been to take the
*biggest* cluster:


```r
decathlon.1$size
```

```
## [1] 6 5 8 1 4
```

 

which in this case is cluster 3, and then


```r
decathlon.1$centers
```

```
##         x100m   long.jump   shot.put     high.jump      x400m
## 1 -0.97448850  0.64184430 -0.1484207 -2.467909e-01 -1.0216857
## 2  0.28457995  0.07871177 -0.8288519  2.326886e-01 -0.1588370
## 3 -0.02051555  0.02245134  0.9034011  2.644188e-01 -0.0589434
## 4  1.55771620 -2.27947172  0.9765949 -1.798048e+00  1.3236413
## 5  0.75760985 -0.53619092 -0.7922550 -1.554312e-15  1.5180512
##       x110mh     discus  pole.vault     javelin     x1500m
## 1 -0.5934385  0.2274805 -0.07779211  0.65707285 -0.9136808
## 2 -0.3582955 -1.0406594  1.17932839  0.06548297 -0.1670467
## 3 -0.3097414  0.6739749 -0.10890895 -0.49565010  0.3441300
## 4  1.1775755 -0.6894704 -1.50916693 -1.43751822 -1.8269002
## 5  1.6631161 -0.2159787 -0.76236268  0.28321676  1.3477946
```

 

which says that the eight athletes in cluster 3 are a bit above
average for shot put and discus, and below average for javelin, and,
taking a decision, about average for everything else. This is kind of
odd, since these are all throwing events, but the javelin is propelled
a long way by running fast, and the other two are propelled mainly
using strength rather than speed, so it makes some kind of sense
(after the fact, at least).

My guess is that someone good at javelin is likely to be good at
sprint running and possibly also the long jump, since that depends
primarily on speed, once you have enough technique. Well, one way to
figure out whether I was right:


```r
cor(decathlon)
```

```
##                  x100m   long.jump    shot.put   high.jump
## x100m       1.00000000 -0.61351932 -0.17373396 -0.03703619
## long.jump  -0.61351932  1.00000000  0.08369570  0.46379852
## shot.put   -0.17373396  0.08369570  1.00000000  0.02012049
## high.jump  -0.03703619  0.46379852  0.02012049  1.00000000
## x400m       0.78909124 -0.54819716 -0.17251605  0.01521720
## x110mh      0.67372152 -0.39484085 -0.28310469 -0.08356323
## discus     -0.14989960  0.12891051  0.46449586 -0.11770266
## pole.vault -0.12087966  0.21976890 -0.19328449  0.13565269
## javelin     0.02363715  0.01969302 -0.11313467 -0.12454417
## x1500m      0.14913949 -0.11672283 -0.06156793  0.27779220
##                   x400m      x110mh      discus  pole.vault
## x100m       0.789091241  0.67372152 -0.14989960 -0.12087966
## long.jump  -0.548197160 -0.39484085  0.12891051  0.21976890
## shot.put   -0.172516054 -0.28310469  0.46449586 -0.19328449
## high.jump   0.015217204 -0.08356323 -0.11770266  0.13565269
## x400m       1.000000000  0.80285420 -0.06877820 -0.36182359
## x110mh      0.802854203  1.00000000 -0.13777771 -0.51871733
## discus     -0.068778203 -0.13777771  1.00000000 -0.10045072
## pole.vault -0.361823592 -0.51871733 -0.10045072  1.00000000
## javelin    -0.005823468 -0.05246857  0.02097743  0.05237715
## x1500m      0.446949386  0.39800522  0.01989086 -0.05988836
##                 javelin       x1500m
## x100m       0.023637150  0.149139491
## long.jump   0.019693022 -0.116722829
## shot.put   -0.113134672 -0.061567926
## high.jump  -0.124544175  0.277792195
## x400m      -0.005823468  0.446949386
## x110mh     -0.052468568  0.398005215
## discus      0.020977427  0.019890861
## pole.vault  0.052377148 -0.059888360
## javelin     1.000000000 -0.008858031
## x1500m     -0.008858031  1.000000000
```

 

or, for this, maybe better:


```r
cor(decathlon) %>% as.data.frame() %>% rownames_to_column("event") %>% 
    gather(event2, corr, -event) %>% filter(event < event2) %>% arrange(desc(abs(corr)))
```

```
##         event     event2         corr
## 1      x110mh      x400m  0.802854203
## 2       x100m      x400m  0.789091241
## 3       x100m     x110mh  0.673721520
## 4   long.jump      x100m -0.613519318
## 5   long.jump      x400m -0.548197160
## 6  pole.vault     x110mh -0.518717326
## 7      discus   shot.put  0.464495863
## 8   high.jump  long.jump  0.463798523
## 9      x1500m      x400m  0.446949386
## 10     x110mh     x1500m  0.398005215
## 11  long.jump     x110mh -0.394840852
## 12 pole.vault      x400m -0.361823592
## 13   shot.put     x110mh -0.283104686
## 14  high.jump     x1500m  0.277792195
## 15  long.jump pole.vault  0.219768900
## 16 pole.vault   shot.put -0.193284491
## 17   shot.put      x100m -0.173733960
## 18   shot.put      x400m -0.172516054
## 19     discus      x100m -0.149899598
## 20      x100m     x1500m  0.149139491
## 21     discus     x110mh -0.137777706
## 22  high.jump pole.vault  0.135652689
## 23     discus  long.jump  0.128910512
## 24  high.jump    javelin -0.124544175
## 25 pole.vault      x100m -0.120879657
## 26     discus  high.jump -0.117702658
## 27  long.jump     x1500m -0.116722829
## 28    javelin   shot.put -0.113134672
## 29     discus pole.vault -0.100450719
## 30  long.jump   shot.put  0.083695699
## 31  high.jump     x110mh -0.083563233
## 32     discus      x400m -0.068778203
## 33   shot.put     x1500m -0.061567926
## 34 pole.vault     x1500m -0.059888360
## 35    javelin     x110mh -0.052468568
## 36    javelin pole.vault  0.052377148
## 37  high.jump      x100m -0.037036192
## 38    javelin      x100m  0.023637150
## 39     discus    javelin  0.020977427
## 40  high.jump   shot.put  0.020120488
## 41     discus     x1500m  0.019890861
## 42    javelin  long.jump  0.019693022
## 43  high.jump      x400m  0.015217204
## 44    javelin     x1500m -0.008858031
## 45    javelin      x400m -0.005823468
```

 

I should probably talk about the code:



* I want to grab the event names from the row names of the
matrix. This is a bit awkward, because I want to turn the matrix
into a data frame, but if I turn it into a `tibble`, the row
names will disappear.

* Thus, I turn it into an old-fashioned `data.frame`, and
then it has row names, which I can grab and put into a column called
`event`.

* Then I make the data frame long, creating a column
`event2` which is the second thing that each correlation will
be between.

* The correlations between an event and itself will be 1, and
between events B and A will be the same as between A and B. So I
take only the rows where the first event is alphabetically less than
the second one.

* Then I arrange them in descending order of *absolute*
correlation, since a large negative correlation is also interesting.


There are actually only a few high correlations:



* 100m with long jump, 400m and 110m hurdles

* long jump with 100m, high jump and 400m

* shot put with discus

* high jump with long jump

* 400m with all the other running events plus long jump

* 110m hurdles with the other running events plus pole vault

* discus with shot put

* pole vault with 110m hurdles and maybe 400m

* javelin with *nothing*

* 1500m with 400m


Some of the correlations are negative as expected, since they are
between a running event and a jumping/throwing event.

I was wrong about javelin. It seems to be a unique skill in the
decathlon, which is presumably why it's there: you want 10 events that
are as disparate as possible, rather than things that are highly
correlated. 
  







