library(tidyverse)
library(spData)
library(sf)

## New Packages
library(foreach)
library(doParallel)
registerDoParallel()
getDoParWorkers() # check registered cores
i=which(world2$name_long=="Costa Rica")
# neighbor countries
world2[x_par[i,],]$name_long
ggplot()+
  geom_sf(data=world2[x_par[i,],])+
  geom_sf(data=world2[i,],col="red")
