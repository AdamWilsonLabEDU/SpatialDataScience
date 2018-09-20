#' ---
#' title       : "Data Wrangling 2"
#' ---
#' 
#' 
#' [<i class="fas fa-desktop fa-3x" aria-hidden="true"></i> Presentation](presentations/day_07.html){target="_blank"}  
#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> R Script](`r output`){target="_blank"}  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
## ----results='hide', message=FALSE, warning=F----------------------------
library(tidyverse)
library(nycflights13)

#' 
#' 
#' # Combining data sets
#' 
#' ## `dplyr` _join_ methods
#' <img src="03_assets/join1.png" alt="Drawing" style="width: 50%;"/>
#' 
#' * `left_join(a, b, by = "x1")` Join matching rows from b to a.
#' * `right_join(a, b, by = "x1")` Join matching rows from a to b.
#' * `inner_join(a, b, by = "x1")` Retain only rows in both sets.
#' * `full_join(a, b, by = "x1")` Join data. Retain all values, all rows.
#' 
#' 
#' ### Left Join
#' `left_join(a, b, by = "x1")` Join matching rows from b to a.
#' 
#' <img src="03_assets/join1.png" alt="Drawing" style="width: 50%;"/>
#' <img src="03_assets/join_left.png" alt="Drawing" style="width: 50%;"/>
#' 
#' ### Right Join
#' `right_join(a, b, by = "x1")` Join matching rows from a to b.
#' 
#' <img src="03_assets/join1.png" alt="Drawing" style="width: 50%;"/>
#' <img src="03_assets/join_right.png" alt="Drawing" style="width: 50%;"/>
#' 
#' ### Inner Join
#' `inner_join(a, b, by = "x1")` Retain only rows in both sets.
#' 
#' <img src="03_assets/join1.png" alt="Drawing" style="width: 50%;"/>
#' <img src="03_assets/join_inner.png" alt="Drawing" style="width: 50%;"/>
#' 
#' ### Full Join
#' `full_join(a, b, by = "x1")` Join data. Retain all values, all rows.
#' 
#' <img src="03_assets/join1.png" alt="Drawing" style="width: 50%;"/>
#' <img src="03_assets/join_full.png" alt="Drawing" style="width: 50%;"/>
#' 
#' 
## ------------------------------------------------------------------------
flights%>%
  select(-year,-month,-day,-hour,-minute,-dep_time,-dep_delay)%>%
  glimpse()

#' 
#' Let's look at the `airports` data table (`?airports` for documentation):
## ------------------------------------------------------------------------
glimpse(airports)

#' 
#' Now [complete the task here](CS_04.html) by yourself or in small groups.
#' 
#' 
#' # Extras
#' 
#' If you made it through the material above, here's an example of some more 'advanced' coding to extract the geographic locations for all flights and plotting the connections as 'great circles' on a map.  This is just meant as an example to illustrate how one might use these functions to perform a more advanced analysis and spatial visualization.  
#' 
#' ### Join destination airports
#' 
## ---- result=F, warning=F, message=F-------------------------------------
library(geosphere)
library(rgdal)
library(maps)
library(ggplot2)
library(sp)
library(rgeos)

#' 
#' 
## ------------------------------------------------------------------------
data=
  select(airports,
         dest=faa,
         destName=name,
         destLat=lat,
         destLon=lon)%>%
  right_join(flights)%>%
  group_by(dest,
           destLon,
           destLat,
           distance)%>%
  summarise(count=n())%>%
  ungroup()%>%
  select(destLon,
         destLat,
         count,
         distance)%>%
  mutate(id=row_number())%>%
  na.omit()

NYCll=airports%>%filter(faa=="JFK")%>%select(lon,lat)  # get NYC coordinates

# calculate great circle routes
rts <- gcIntermediate(as.matrix(NYCll),
                      as.matrix(select(data,destLon,destLat)),
                      1000,
                      addStartEnd=TRUE,
                      sp=TRUE)
rts.ff <- fortify(
  as(rts,"SpatialLinesDataFrame")) # convert into something ggplot can plot

## join with count of flights
rts.ff$id=as.integer(rts.ff$id)
gcircles <- left_join(rts.ff,
                      data,
                      by="id") # join attributes, we keep them all, just in case


#' 
#' 
#' Now build a basemap using data in the `maps` package.
#' 
## ----fig.width=10,fig.height=6,dpi=300-----------------------------------
base = ggplot()
worldmap <- map_data("world",
                     ylim = c(10, 70),
                     xlim = c(-160, -80))
wrld <- c(geom_polygon(
  aes(long, lat, group = group),
  size = 0.1,
  colour = "grey",
  fill = "grey",
  alpha = 1,
  data = worldmap
))

#' 
#' Now draw the map using `ggplot`
## ------------------------------------------------------------------------
base + wrld +
  geom_path(
    data = gcircles,
    aes(
      long,
      lat,
      col = count,
      group = group,
    ),
    alpha = 0.5,
    lineend = "round",
    lwd = 1
  ) +
  coord_equal() +
  scale_colour_gradientn(colours = c("blue", "orange", "red"),
                         guide = "colourbar") +
  theme(panel.background = element_rect(fill = 'white', colour = 'white')) +
  labs(y = "Latitude", x = "Longitude",
       title = "Count of Flights from New York in 2013")

#' 
#' ## Colophon
#' This exercise based on code from [here](http://spatial.ly/2012/06/mapping-worlds-biggest-airlines/).
