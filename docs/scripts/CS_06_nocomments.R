library(raster)
library(sf)
library(sp)
library(spData)
library(tidyverse)
data(world)  #load 'world' data from spData package
tmax_monthly <- getData(name = "worldclim", var="tmax", res=10)
