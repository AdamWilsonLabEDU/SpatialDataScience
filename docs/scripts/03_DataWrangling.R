#' ---
#' title       : "Data Wrangling 1 "
#' ---
#' 
#' 
#' <div>
#' <object data="presentations/03_DataWrangling.pdf" type="application/pdf" width="100%" height="600px"> 
#'   <p>It appears you don't have a PDF plugin for this browser.
#'    No biggie... you can <a href="presentations/03_DataWrangling.pdf">click here to
#'   download the PDF file.</a></p>  
#'  </object>
#'  </div>
#'  <p><a href="presentations/03_DataWrangling.pdf">Download the PDF of the presentation</a></p>  
#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
#' 
#' # RStudio Shortcuts
#' 
#' ## Running code
#' * `ctrl-R` (or `command-R`) to run current line
#' * Highlight `code` in script and run `ctrl-R` (or `command-R`) to run selection
#' * Buttons: <img src="03_assets/Source.png" style="width: 25%"/>
#' 
#' ## Switching windows
#' * `ctrl-1`: script window
#' * `ctrl-2`: console window
#' 
#' > Try to run today's script without using your mouse/trackpad
#' 
#' # Data wrangling
#' 
#' ## Useful packages: [`tidyverse`](https://www.tidyverse.org/packages/)
#' 
#' [Cheat sheets on website](https://www.rstudio.com/resources/cheatsheets/) for [Data Wrangling](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
#' 
## ----results='hide', message=FALSE, warning=F----------------------------
library(tidyverse)

#' Remember use `install.packages("tidyverse")` to install a new package.
#' 
#' ###  Example operations from [here](https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html)
#' 
#' ## New York City Flights
#' Data from [US Bureau of Transportation Statistics](http://www.transtats.bts.gov/DatabaseInfo.asp?DB_ID=120&Link=0) (see `?nycflights13`)
## ----results='hide', warning=F-------------------------------------------
library(nycflights13)

#' Check out the `flights` object
## ------------------------------------------------------------------------
head(flights)

#' 
#' ### Object _Structure_
#' Check out data _structure_ with `glimpse()`
## ------------------------------------------------------------------------
glimpse(flights)

#' 
#' # `dplyr` "verbs"
#' 
#' * `select()` and `rename()`: Extract existing variables
#' * `filter()` and `slice()`: Extract existing observations
#' * `arrange()`
#' * `distinct()`
#' * `mutate()` and `transmute()`: Derive new variables
#' * `summarise()`: Change the unit of analysis
#' * `sample_n()` and `sample_frac()`
#' 
#' ## Useful select functions
#' 
#' * "`-`"  Select everything but
#' * "`:`"  Select range
#' * `contains()` Select columns whose name contains a character string
#' * `ends_with()` Select columns whose name ends with a string
#' * `everything()` Select every column
#' * `matches()` Select columns whose name matches a regular expression
#' * `num_range()` Select columns named x1, x2, x3, x4, x5
#' * `one_of()` Select columns whose names are in a group of names
#' * `starts_with()` Select columns whose name starts with a character string
#' 
#' ### `select()` examples
#' Select only the `year`, `month`, and `day` columns:
## ------------------------------------------------------------------------
select(flights,year, month, day)

#' 
#' ### `select()` examples
#' 
#' Select everything _except_ the `tailnum`:
## ------------------------------------------------------------------------
select(flights,-tailnum)

#' 
#' Select all columns containing the string `"time"`:
## ------------------------------------------------------------------------
select(flights,contains("time"))

#' 
#' You can also rename columns with `select()`
## ------------------------------------------------------------------------
select(flights,year,carrier,destination=dest)

#' 
#' ## `filter()` observations
#' 
#' Filter all flights that departed on on January 1st:
#' 
## ------------------------------------------------------------------------
filter(flights, month == 1, day == 1)

#' 
#' 
#' ## _Base_ R method
#' This is equivalent to the more verbose code in base R:
#' 
## ------------------------------------------------------------------------
flights[flights$month == 1 & flights$day == 1, ]

#' 
#' Compare with `dplyr` method: 
## ----eval=F--------------------------------------------------------------
## filter(flights, month == 1, day == 1)

#' 
#' 
#' <div class="well">
#' Filter the `flights` data set to keep only evening flights (`dep_time` after 1600) in June.
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' 
#' 
#' ## Other _boolean_ expressions
#' `filter()` is similar to `subset()` except it handles any number of filtering conditions joined together with `&`. 
#' 
#' You can also use other boolean operators, such as _OR_ ("|"):
## ------------------------------------------------------------------------
filter(flights, month == 1 | month == 2)

#' 
#' <div class="well">
#' Filter the `flights` data set to keep only flights where the `distance` is greater than 1000 OR the `air_time` is more than 100
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
#' <div id="demo2" class="collapse"> <br>
#' 
#' </div>
#' </div>
#' 
#' 
#' 
#' ## Select rows with `slice()`:
## ------------------------------------------------------------------------
slice(flights, 1:10)

#' 
#' ## `arrange()` rows
#' 
#' `arrange()` is similar to `filter()` except it reorders instead of filtering.  
#' 
## ------------------------------------------------------------------------
arrange(flights, year, month, day)

#' 
#' _Base_ R method:
## ----eval=F--------------------------------------------------------------
## flights[order(flights$year, flights$month, flights$day), ]

#' 
#' 
#' ## Descending order: `desc()`
#' 
## ------------------------------------------------------------------------
arrange(flights, desc(arr_delay))

#' 
#' _Base_ R method:
## ----eval=F--------------------------------------------------------------
## flights[order(desc(flights$arr_delay)), ]

#' 
#' 
#' 
#' ## Distinct: Find distinct rows
#' 
## ------------------------------------------------------------------------
distinct(
  select(flights,carrier)
)

#' 
#' 
#' 
#' ## Mutate: Derive new variables
#' 
#' Adds columns with calculations based on other columns.
#' 
#' 
#' Average air speed (miles/hour):
## ------------------------------------------------------------------------
mutate(flights,ave_speed=distance/(air_time/60))%>%
  select(distance, air_time,ave_speed)

#' 
#' 
#' 
#' ## Chaining Operations
#' Learn to performing multiple operations sequentially with a _pipe_ character (`%>%`)
#' 
#' 1. Group by a variable
#' 2. Select some columns
#' 3. Summarize observations
#' 4. Filter by results
#' 
#' 
#' With temporary objects:
## ------------------------------------------------------------------------
a1 <- group_by(flights, year, month, day)
a2 <- select(a1, arr_delay, dep_delay)
a3 <- summarise(a2,
                arr = mean(arr_delay, na.rm = TRUE),
                dep = mean(dep_delay, na.rm = TRUE))
a4 <- filter(a3, arr > 30 | dep > 30)
head(a4)

#' 
#' If you don’t want to save the intermediate results: wrap the function calls inside each other:
#' 
## ------------------------------------------------------------------------
filter(
  summarise(
    select(
      group_by(flights, year, month, day),
      arr_delay, dep_delay
    ),
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ),
  arr > 30 | dep > 30
)

#' 
#' Arguments are distant from function -> difficult to read!  
#' 
#' 
#' ## Chaining Operations
#' 
#' `%>%` (from the dplyr package) allows you to _pipe_ together various commands.  
#' 
#' `x %>% f(y)` turns into `f(x, y)`
#' 
#' 
#' So you can use it to rewrite multiple operations that you can read left-to-right, top-to-bottom:
## ------------------------------------------------------------------------
flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ) %>%
  filter(arr > 30 | dep > 30)

#' 
#' 
#' ## Analyze by group with `group_by()`
#' Perform operations by _group_: mean departure delay by airport (`origin`)
#' 
## ------------------------------------------------------------------------
flights %>%
  group_by(origin) %>%
  summarise(meanDelay = mean(dep_delay,na.rm=T))

#' 
#' Perform operations by _group_: mean and sd departure delay by airline (`carrier`)
#' 
## ------------------------------------------------------------------------
flights %>% 
  group_by(carrier) %>%  
  summarise(meanDelay = mean(dep_delay,na.rm=T),
            sdDelay =   sd(dep_delay,na.rm=T))

#' 
#' 
#' 
#' <div class="well">
#' Flights from which `origin` airport go the farthest (on average)?   Hint: Group by airport (`origin`) then calculate the maximum flight distance (`distance`).
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2a">Show Solution</button>
#' <div id="demo2a" class="collapse">
#' 
#' 
#' </div>
#' </div>
#' 
#' 
#' # Today's task
#' 
#' Now [complete the task here](CS_03.html) by yourself or in small groups.
#' 
#' ## Colophon
#' This exercise based on code from [here](http://spatial.ly/2012/06/mapping-worlds-biggest-airlines/).
