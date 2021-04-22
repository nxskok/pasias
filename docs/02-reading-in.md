
# Reading in data


```r
library(tidyverse)
```






##  Orange juice


 The quality of orange juice produced by a manufacturer
(identity unknown) is constantly being monitored. The manufacturer has
developed a "sweetness index" for its orange juice, for which a
higher value means sweeter juice. Is the sweetness index related to a
chemical measure such as the amount of water-soluble pectin (parts per
million) in the
orange juice? Data were obtained from 24 production runs, and the
sweetness and pectin content were measured for each run. The data are
in [link](http://www.utsc.utoronto.ca/~butler/c32/ojuice.txt). Open that
link up now. You can click on that link just above to open the file.



(a) The data values are separated by a space. Use the appropriate
Tidyverse function to read the data directly from the course website
into a "tibble".


Solution


Start with this (almost always):


```r
library(tidyverse)
```

 

The appropriate function, the data values being separated by a space,
will be `read_delim`. Put the URL as the first thing in
`read_delim`, or (better) define it into a variable
first:
<label for="tufte-mn-" class="margin-toggle">&#8853;</label><input type="checkbox" id="tufte-mn-" class="margin-toggle"><span class="marginnote">I say *better* because otherwise the read line gets rather long. This way you read it as *the URL is some long thing that I don't care about especially, and I what I need to do is to read the data from that URL, separated by spaces.*</span>


```r
url <- "http://www.utsc.utoronto.ca/~butler/c32/ojuice.txt"
juice <- read_delim(url, " ")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   run = col_double(),
##   sweetness = col_double(),
##   pectin = col_double()
## )
```

 

`read_delim` (or `read_csv` or any of the others) tell
you what variables were read in, and also tell you about any "parsing errors" 
where it couldn't work out what was what. Here, we have three
variables, which is entirely consistent with the three columns of data
values in the file.

`read_delim` can handle data values separated by *any*
character, not just spaces, but the separating character, known as a
"delimiter", does *not* have a default, so you have to say what
it is, every time.




(b) Take a look at what got read in. Do you
have data for all 24 runs? 


Solution


Type the name of the data frame in a code chunk (a new one, or
add it to the end of the previous one). Because this is actually
a "tibble", which is what `read_delim` reads in,
you'll only actually see the first 10 lines, but it will tell
you how many lines there are altogether, and you can click on
the appropriate thing to see the rest of it.

```r
juice
```

```
## # A tibble: 24 x 3
##      run sweetness pectin
##    <dbl>     <dbl>  <dbl>
##  1     1       5.2    220
##  2     2       5.5    227
##  3     3       6      259
##  4     4       5.9    210
##  5     5       5.8    224
##  6     6       6      215
##  7     7       5.8    231
##  8     8       5.6    268
##  9     9       5.6    239
## 10    10       5.9    212
## # … with 14 more rows
```

 

I appear to have all the data. If you want further convincing, click
Next a couple of times (on yours) to be sure that the runs go down to
number 24.



(c) In your data frame, where did the column (variable) names
come from? How did R know where to get them from?


Solution


They came from the top line of the data file, so we didn't 
have to specify them. This is the default behaviour of all the
`read_` functions, so we don't have to ask for it
specially. 

Extra: in fact, if the top line of your data file is
*not* variable names, *that's* when you have to say
something special. The `read_` functions have an
option `col_names` which can either be `TRUE`
(the default), which means "read them in from the top line",
`FALSE` ("they are not there, so make some up") or a
list of column names to use. You might use the last
alternative when the column names that are in the file are
*not* the ones you want to use; in that case, you would
also say `skip=1` to skip the first line. For example,
with file `a.txt` thus:

```
a b
1 2
3 4
5 6
```
        
you could read the same data but call the columns `x` and
`y` thus:


```r
read_delim("a.txt", " ", col_names = c("x", "y"), skip = 1)
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   x = col_double(),
##   y = col_double()
## )
```

```
## # A tibble: 3 x 2
##       x     y
##   <dbl> <dbl>
## 1     1     2
## 2     3     4
## 3     5     6
```

         





##  Making soap


 A company operates two production lines in a factory for
making soap bars. The production lines are
labelled A and B. A production line that moves faster may produce more
soap, but may possibly also produce more "scrap" (that is, bits of
soap that 
can no longer be made into soap bars and will have to be thrown away).  

The data are in [link](http://www.utsc.utoronto.ca/~butler/c32/soap.txt).



(a) Read the data into R.  Display the data. 


Solution


Read directly from the URL, most easily:

```r
url <- "http://www.utsc.utoronto.ca/~butler/c32/soap.txt"
soap <- read_delim(url, " ")
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   case = col_double(),
##   scrap = col_double(),
##   speed = col_double(),
##   line = col_character()
## )
```

```r
soap
```

```
## # A tibble: 27 x 4
##     case scrap speed line 
##    <dbl> <dbl> <dbl> <chr>
##  1     1   218   100 a    
##  2     2   248   125 a    
##  3     3   360   220 a    
##  4     4   351   205 a    
##  5     5   470   300 a    
##  6     6   394   255 a    
##  7     7   332   225 a    
##  8     8   321   175 a    
##  9     9   410   270 a    
## 10    10   260   170 a    
## # … with 17 more rows
```

    


(b) There should be 27
rows. Are there? What columns are there?

Solution

There are indeed 27 rows, one per observation. The column called `case` identifies  each particular run of a production line (scroll down to see that it gets to 27 as well). Though it is a number, it is an identifier variable and so should not be treated quantitatively. The other columns (variables) are `scrap` and `speed` (quantitative) and `line` (categorical). These indicate which production line was used for each run, the speed it was run at, and the amount of scrap produced.

This seems like an odd place to end this question, but later we'll be using these data to draw some graphs. 


##  Handling shipments


 A company called Global Electronics from
time to time imports shipments of a certain large part used as a
component in several of its products. The size of the shipment varies
each time. Each shipment is sent to one of two warehouses (labelled A
and B) for handling. The data in
[link](http://www.utsc.utoronto.ca/~butler/c32/global.csv) show the
`size` of each shipment (in thousands of parts) and the direct
`cost` of handling it, in thousands of dollars. Also shown is
the `warehouse` (A or B) that handled each shipment.



(a) Read the data into R and display your data frame. 


Solution


If you open the data file in your web browser, it will probably
open as a spreadsheet, which is not really very helpful, since
then it is not clear what to do with it. You could, I suppose,
save it and upload it to R Studio Cloud, but it requires much less
brainpower to open it directly from the URL:


```r
url <- "http://www.utsc.utoronto.ca/~butler/c32/global.csv"
shipments <- read_csv(url)
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   warehouse = col_character(),
##   size = col_double(),
##   cost = col_double()
## )
```

     

If you display your data frame and it looks like this, you are good
(you can give the data frame any name):


```r
shipments
```

```
## # A tibble: 10 x 3
##    warehouse  size  cost
##    <chr>     <dbl> <dbl>
##  1 A           225 12.0 
##  2 B           350 14.1 
##  3 A           150  8.93
##  4 A           200 11.0 
##  5 A           175 10.0 
##  6 A           180 10.1 
##  7 B           325 13.8 
##  8 B           290 13.3 
##  9 B           400 15   
## 10 A           125  7.97
```

 
(b) Describe how many rows and columns your data frame has, and what they contain. 

It has 10 rows and 3 columns. *You need to say this.*

That is, there were 10 shipments recorded, and for each of them, 3
variables were noted: the size and cost of the shipment, and the
warehouse it was handled at.
    
We will also be making some graphs of these data later.


