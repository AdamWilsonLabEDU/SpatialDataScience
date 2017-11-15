#' ---
#' title: "Dynamic Visualization"
#' ---
#' 
#' 
#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
#' # Introduction
#' 
#' In this module we will explore several ways to generate dynamic and interactive data displays.  These include making maps and graphs that you can pan/zoom, select features for more information, and interact with in other ways.  The most common output format is HTML, which can easily be embedded in a website (such as your final project!).
#' 
## ----cache=F, message=F,warning=FALSE------------------------------------
library(dplyr)
library(ggplot2)
library(ggmap)

#' 
#' If you don't have the packages above, install them in the package manager or by running `install.packages("doParallel")`. 
#' 
#' # DataTables
#' 
#' [DataTables](http://rstudio.github.io/DT/) display R data frames as interactive HTML tables (with filtering, pagination, sorting, and search).
#' 
## ------------------------------------------------------------------------
library(DT)
datatable(iris, options = list(pageLength = 5))

#' 
#' # ggplotd3 instead?
#' 
#' # rbokeh
#' 
#' [Bokeh](http://hafen.github.io/rbokeh) 
#' 
## ---- warning=F, message=F-----------------------------------------------
library(rbokeh)
figure() %>%
  ly_points(Sepal.Length, Sepal.Width, data = iris,
    color = Species, glyph = Species,
    hover = list(Sepal.Length, Sepal.Width))

#' 
#' 
#' # Leaflet
#' 
#' [Leaflet](http://rstudio.github.io/leaflet/) is a JavaScript library for creating dynamic maps that support panning and zooming along with various annotations like markers, polygons, and popups.  The examples below were adapted from the [leaflet vignettes](http://rstudio.github.io/leaflet).
#' 
## ---- warning=F, message=F-----------------------------------------------
library(leaflet)
loc=geocode("Buffalo, NY")
m <- leaflet() %>% setView(lng = loc$lon, lat = loc$lat, zoom = 12)
m %>% addTiles()

#' 
## ------------------------------------------------------------------------
pal <- colorQuantile("YlOrRd", NULL, n = 8)
#leaflet() %>% 
#  addTiles() %>%
#  addCircleMarkers(color = ~pal(tann))

#' 
#' <div class="well">
#' ## Your turn
#' Make a leaflet map of mean income in each census tracts in Buffalo using using the XX background 
#' 
#' Hints:
#' 
#' * Use the following code to download the census tract information
## ---- eval=F-------------------------------------------------------------
## library(tidycensus)
## library(tidyverse)
## library(viridis)
## 
## #census_buffalo=
## 

#' 
#' * use `leaflet()` with
#' 
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' 
#' # dygraphs
#' 
## ------------------------------------------------------------------------
library(dygraphs)
dygraph(nhtemp, main = "New Haven Temperatures") %>% 
  dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"))


#' 
#' <div class="well">
#' ## Your turn
#' Make a dygraph of recent daily maximum temperature data from Buffalo, NY.
#' 
#' Hints:
#' 
#' * Use the following code to download the daily weather data (if this is taking too long, you can use the nhtemps object loaded above)
## ------------------------------------------------------------------------
library(rnoaa)
library(xts)

d=meteo_tidy_ghcnd("USW00014733",
                   date_min = "2016-01-01", 
                   var = c("TMAX"),
                   keep_flags=T,
                  )
d$date=as.Date(d$date)
head(d)

#' 
#' * create a `xts` time series object as required by `dygraph()` using `xts()` and specify the vector of data and the date column (see `?xts` for help). 
#' * use `dygraph()` to draw the plot
#' * add a `dyRangeSelector()` with a `dateWindow` of `c("2017-01-01", "2017-12-31")`
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' # networkD3
#' 
#' 
## ------------------------------------------------------------------------
library(networkD3)
data(MisLinks, MisNodes)
forceNetwork(Links = MisLinks, Nodes = MisNodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             Group = "group", opacity = 0.4)

#' 
#' <div class="well">
#' ## Your turn
#' Make a dynamic network graph with `networkD3` to show the 
#' 
#' Hints:
#' 
#' * Use the following code to download the census tract information
## ---- eval=F-------------------------------------------------------------
## NA

#' 
#' * use `dygraph()` to draw the plot
#' * add a `dyRangeSelector()` with a `dateWindow` of `c("1920-01-01", "2017-01-01")`
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">
#' 
#' </div>
#' </div>
