#' ---
#' title: Dynamic HTML graph of Daily Temperatures
#' subtitle: Using DyGraph library.
#' week: 12
#' type: Case Study
#' reading:
#'    - Explore the [DyGraphs webpage](http://rstudio.github.io/dygraphs/)
#' tasks:
#'    - Download daily weather data for Buffalo, NY using an API
#'    - Generate a dynamic html visualization of the timeseries. 
#'    - Save the graph using Export->Save as Webpage
#' ---
#' 
#' 
#' 
#' # Reading
#' 
#' 
#' 
#' # Tasks
#' 
#' 
#' ## Background
#' 
#' # Objective
#' > Make a dygraph of recent daily maximum temperature data from Buffalo, NY.
#' 
#' ## Detailed Steps
#' 
#' First use the following code to download the daily weather data.
#' 
## ---- messages=F, warning=F, results=F-----------------------------------
library(rnoaa)
library(xts)
library(dygraphs)

d=meteo_tidy_ghcnd("USW00014733",
                   date_min = "2016-01-01", 
                   var = c("TMAX"),
                   keep_flags=T)
d$date=as.Date(d$date)

#' 
#' Remaining steps:
#' 
#' 1. Convert `d` into an `xts` time series object using `xts()`.  You will need to specifify which column has the data (`d$tmax`) and `order.by=d$date`. See `?xts` for help. 
#' 2. Use `dygraph()` to draw the plot
#' 3. Set the title of the dygraph to be `main="Daily Maximum Temperature in Buffalo, NY"`
#' 3. Add a `dyRangeSelector()` with a `dateWindow` of `c("2017-01-01", "2017-12-31")`
#' 
#' 
#' ## Output
#' 
#' Your final graph should look something like this:
#' 
