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
library(htmlwidgets)
library(widgetframe)

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
geocode("Buffalo, NY")
m <- leaflet() %>% setView(lng = -78.87837, lat = 42.88645, zoom = 12) %>% 
  addTiles()
frameWidget(m)

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
  dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"))%>%
  frameWidget()


#' 
#' <div class="well">
#' ## Your turn
#' Make a dygraph of recent daily maximum temperature data from Buffalo, NY.
#' 
#' Hints:
#' 
#' * Use the following code to download the daily weather data (if this is taking too long, you can use the nhtemps object loaded above)
## ---- messages=F, warning=F----------------------------------------------
library(rnoaa)
library(xts)

d=meteo_tidy_ghcnd("USW00014733",
                   date_min = "2016-01-01", 
                   var = c("TMAX","PRCP"),
                   keep_flags=T)
d$date=as.Date(d$date)

#' 
#' * create a `xts` time series object as required by `dygraph()` using `xts()` and specify the vector of data and the date column (see `?xts` for help). 
#' * use `dygraph()` to draw the plot
#' * add a `dyRangeSelector()` with a `dateWindow` of `c("2017-01-01", "2017-12-31")`
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
#' <div id="demo2" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' # rthreejs
#' 
## ---- messages=F, results=F----------------------------------------------
#devtools::install_github("bwlewis/rthreejs")
library(threejs)
z <- seq(-10, 10, 0.1)
x <- cos(z)
y <- sin(z)
scatterplot3js(x, y, z, color=rainbow(length(z)))%>%
  frameWidget()

#' 
#' # networkD3
#' 
#' 
## ------------------------------------------------------------------------
library(igraph)
library(networkD3)

karate <- make_graph("Zachary")
wc <- cluster_walktrap(karate)
members <- membership(wc)

# Convert to object suitable for networkD3
karate_d3 <- igraph_to_networkD3(karate, group = members)

# Create force directed network plot
forceNetwork(Links = karate_d3$links, Nodes = karate_d3$nodes,
             Source = 'source', Target = 'target', NodeID = 'name',
             Group = 'group')%>%
  frameWidget()


#' 
## ------------------------------------------------------------------------
# Load energy projection data
library(jsonlite)
URL <- paste0(
        "https://cdn.rawgit.com/christophergandrud/networkD3/",
        "master/JSONdata/energy.json")
Energy <- fromJSON(URL)

#' 
#' ## Plot the energy data as a Sankey Network
## ------------------------------------------------------------------------
sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             units = "TWh", fontSize = 12, nodeWidth = 30)%>%
  frameWidget()

#' 
#' ## Radial Network
## ------------------------------------------------------------------------
URL <- paste0(
        "https://cdn.rawgit.com/christophergandrud/networkD3/",
        "master/JSONdata//flare.json")

## Convert to list format
Flare <- jsonlite::fromJSON(URL, simplifyDataFrame = FALSE)

#' 
#' 
## ------------------------------------------------------------------------
# Use subset of data for more readable diagram
Flare$children = Flare$children[1:3]

radialNetwork(List = Flare, fontSize = 10, opacity = 0.9)%>%
  frameWidget()

#' 
#' # Diagonal Network
## ------------------------------------------------------------------------
diagonalNetwork(List = Flare, fontSize = 10, opacity = 0.9)%>%
  frameWidget()

#' 
#' 
#' # rglwidget
#' 
## ------------------------------------------------------------------------
library(rgl)
library(rglwidget)
library(htmltools)


data(volcano)
# Use the Weather data we downloaded before
#material3d(col = "black")

persp3d(volcano, type="s",col="green3")
rglwidget(elementId = "example", width = 500, height = 400)%>%
  frameWidget()

#' 
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
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo3">Show Solution</button>
#' <div id="demo3" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' 
#' # And many more!
#' Check out the [HTML Widgets page](http://gallery.htmlwidgets.org/) for many more examples.
