library(dplyr)
library(ggplot2)
library(ggmap)
library(htmlwidgets)
library(widgetframe)
library(DT)
datatable(iris, options = list(pageLength = 5))
library(rbokeh)
figure(width = 400, height=400) %>%
  ly_points(Sepal.Length, Sepal.Width, data = iris,
    color = Species, glyph = Species,
    hover = list(Sepal.Length, Sepal.Width))
library(leaflet)
geocode("Buffalo, NY")
m <- leaflet() %>% setView(lng = -78.87837, lat = 42.88645, zoom = 12) %>% 
  addTiles()
frameWidget(m,height =500)
library(dygraphs)
dygraph(nhtemp, main = "New Haven Temperatures",height = 100) %>% 
  dyRangeSelector(dateWindow = c("1920-01-01", "1960-01-01"))%>%
  frameWidget(height =500)

library(rnoaa)
library(xts)

d=meteo_tidy_ghcnd("USW00014733",
                   date_min = "2016-01-01", 
                   var = c("TMAX"),
                   keep_flags=T)
d$date=as.Date(d$date)
#devtools::install_github("bwlewis/rthreejs")
library(threejs)
z <- seq(-10, 10, 0.1)
x <- cos(z)
y <- sin(z)
scatterplot3js(x, y, z, color=rainbow(length(z)))
library(igraph)
library(networkD3)
karate <- make_graph("Zachary")
wc <- cluster_walktrap(karate)
members <- membership(wc)

# Convert to object suitable for networkD3
karate_d3 <- igraph_to_networkD3(karate, group = members)
forceNetwork(Links = karate_d3$links, Nodes = karate_d3$nodes,
             Source = 'source', Target = 'target', NodeID = 'name',
             Group = 'group')%>%
  frameWidget(height =500)
# Load energy projection data
library(jsonlite)
URL <- paste0(
        "https://cdn.rawgit.com/christophergandrud/networkD3/",
        "master/JSONdata/energy.json")
Energy <- fromJSON(URL)
sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
             Target = "target", Value = "value", NodeID = "name",
             units = "TWh", fontSize = 12, nodeWidth = 30)%>%
  frameWidget(height =500)
URL <- paste0(
        "https://cdn.rawgit.com/christophergandrud/networkD3/",
        "master/JSONdata//flare.json")

## Convert to list format
Flare <- jsonlite::fromJSON(URL, simplifyDataFrame = FALSE)
# Use subset of data for more readable diagram
Flare$children = Flare$children[1:3]

radialNetwork(List = Flare, fontSize = 10, opacity = 0.9, height = 400, width=400)
diagonalNetwork(List = Flare, fontSize = 10, opacity = 0.9, height = 400, width=400)
library(rgl)
library(rglwidget)
library(htmltools)

# Load a low-resolution elevation dataset of a volcano
data(volcano)
persp3d(volcano, type="s",col="green3")
rglwidget(elementId = "example", width = 500, height = 400)%>%
  frameWidget()
