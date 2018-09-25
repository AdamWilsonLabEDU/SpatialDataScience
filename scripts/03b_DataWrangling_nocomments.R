library(tidyverse)
library(nycflights13)
flights%>%
  select(-year,-month,-day,-hour,-minute,-dep_time,-dep_delay)%>%
  glimpse()
glimpse(airports)
library(geosphere)
library(rgdal)
library(maps)
library(ggplot2)
library(sp)
library(rgeos)
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
