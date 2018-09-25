library(maps)
library(ggplot2)
library(spData)
library(dplyr)
library(sf)
# library(units) #this one is optional, but can help with unit conversions.
#load 'world' data from spData package
data(world) 
# load 'states' boundaries
states <- sf::st_as_sf(maps::map("state", plot = FALSE, fill = TRUE)) 

plot(world[1])
plot(states)
albers="+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs "
