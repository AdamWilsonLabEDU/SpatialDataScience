#' ---
#' title: "Introduction to Raster Package"
#' ---
#' 
#' 
#' 
#' This file is available as a [<i class="fa fa-file-text" aria-hidden="true"></i> R script here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
#' 
#' ## Libraries
#' 
## ----message=F,warning=FALSE---------------------------------------------
library(dplyr)
library(tidyr)
library(sp)
library(ggplot2)

# Three new libraries
library(rgeos)
library(raster)
library(rasterVis)  #visualization library for raster

#' 
#' # RGEOS
#' 
#' ## RGEOS package for polygon operations
#' 
#' * Area calculations (`gArea`)
#' * Centroids (`gCentroid`)
#' * Convex Hull (`gConvexHull`)
#' * Intersections (`gIntersection`)
#' * Unions (`gUnion`)
#' * Simplification (`gSimplify`)
#' 
#' If you have trouble installing `rgeos` on OS X, look [here](http://dyerlab.bio.vcu.edu/2015/03/31/install-rgeos-on-osx/)
#' 
#' 
#' ## Example: gSimplify
#' 
#' Make up some lines and polygons:
## ------------------------------------------------------------------------
p = readWKT(paste("POLYGON((0 40,10 50,0 60,40 60,40 100,50 90,60 100,60",
 "60,100 60,90 50,100 40,60 40,60 0,50 10,40 0,40 40,0 40))"))
l = readWKT("LINESTRING(0 7,1 6,2 1,3 4,4 1,5 7,6 6,7 4,8 6,9 4)")

#' 
#' 
#' 
## ------------------------------------------------------------------------
par(mfrow=c(2,4))
plot(p);title("Original")
plot(gSimplify(p,tol=10));title("tol: 10")
plot(gSimplify(p,tol=20));title("tol: 20")
plot(gSimplify(p,tol=25));title("tol: 25")

plot(l);title("Original")
plot(gSimplify(l,tol=3));title("tol: 3")
plot(gSimplify(l,tol=5));title("tol: 5")
plot(gSimplify(l,tol=7));title("tol: 7")
par(mfrow=c(1,1))

#' 
#' # Raster Package
#' 
#' ## getData
#' 
#' Raster package includes access to some useful datasets with `getData()`:
#' 
#' * Elevation (SRTM 90m resolution)
#' * World Climate (Tmin, Tmax, Precip, BioClim)
#' * Countries from CIA factsheet (vector!)
#' * Global Administrative boundaries (vector!)
#' 
#' `getData()` steps for GADM:
#' 
#' 1. _Select Dataset_: ‘GADM’ returns the global administrative boundaries.
#' 2. _Select country_: Country name of the boundaries using its ISO A3 country code
#' 3. _Specify level_: Level of of administrative subdivision (0=country, 1=first level subdivision).
#' 
#' ## GADM:  Global Administrative Areas
#' Administrative areas in this database are countries and lower level subdivisions.  
#' 
#' <img src="assets/gadm25.png" alt="alt text" width="70%">
#' 
#' 
#' Divided by country (see website for full dataset).  Explore country list:
## ------------------------------------------------------------------------
getData("ISO3")%>%
  as.data.frame%>%
  filter(NAME=="South Africa")

#' 
#' Download data for South Africa
## ------------------------------------------------------------------------
za=getData('GADM', country='ZAF', level=1)

#' 
## ------------------------------------------------------------------------
plot(za)

#' 
#' Danger: `plot()` works, but can be slow for complex polygons.
#' 
#' ### Check out attribute table
#' 
## ------------------------------------------------------------------------
za@data

#' 
#' 
## ------------------------------------------------------------------------
za=subset(za,NAME_1!="Prince Edward Islands")
plot(za)

#' 
#' 
#' ## Your turn
#' 
#' Use the method above to download and plot the boundaries for a country of your choice.
#' 
## ------------------------------------------------------------------------
getData("ISO3")%>%
  as.data.frame%>%
  filter(NAME=="Tunisia")

tun=getData('GADM', country='TUN', level=1)
plot(tun)

#' 
#' 
#' ## Simplify polygons with RGEOS
#' 
## ----eval=F--------------------------------------------------------------
## za2=gSimplify(za,tol = 0.1,topologyPreserve=T)
## plot(za,lwd=2)
## plot(za2,border="red",add=T)

#' 
#' ## Calculate area by province
#' 
## ------------------------------------------------------------------------
za$area=gArea(za,byid = T)

#' 
#' 
#' ## Selecting a Projection
#' For help selecting a projection, see the [projection wizard](http://projectionwizard.org)
#' 
#' <img src="assets/ProjectionWizard.png" alt="alt text" width="70%">
#' 
#' 
#' ### Plot by area with `spplot()`
#' 
## ------------------------------------------------------------------------
za$area=
  spTransform(za,CRS("+proj=aea +lat_1=-34.55302083711272 +lat_2=-31.208904317916957 +lon_0=22.4560546875"))%>%
  gArea(byid = T)/(1000*1000)

spplot(za,zcol="area")


#' 
#' 
#' ## Union
#' 
#' Merge sub-geometries together with `gUnionCascaded()`
#' 
## ------------------------------------------------------------------------
za2=gUnionCascaded(za)

#' 
#' ## Plotting vectors with ggplot
#' 
#' `fortify()` in `ggplot` useful for converting `Spatial*` objects into plottable data.frames.  
#' 
## ------------------------------------------------------------------------
head(fortify(za))

#' 
#' 
#' 
## ------------------------------------------------------------------------
ggplot(fortify(za),aes(x=long,y=lat,group=group,order=order))+
  geom_path()+
  geom_path(data=fortify(za2),
            mapping=aes(x=long,y=lat,
                        group=group,order=order),
            col="red")+
  coord_equal()

#' 
#' # Raster Data
#' 
#' ## Raster introduction
#' 
#' Spatial data structure dividing region ('grid') into rectangles (’cells’ or ’pixels’) storing one or more values each.
#' 
#' <small> Some examples from the [Raster vignette](http://cran.r-project.org/web/packages/raster/vignettes/Raster.pdf) by Robert J. Hijmans. </small>
#' 
#' * `rasterLayer`: 1 band
#' * `rasterStack`: Multiple Bands
#' * `rasterBrick`: Multiple Bands of _same_ thing.
#' 
#' 
#' 
## ------------------------------------------------------------------------
x <- raster()
x

#' 
## ------------------------------------------------------------------------
str(x)

#' 
#' 
#' 
## ------------------------------------------------------------------------
x <- raster(ncol=36, nrow=18, xmn=-1000, xmx=1000, ymn=-100, ymx=900)
res(x)
res(x) <- 100
res(x)
ncol(x)

#' 
#' 
#' 
## ------------------------------------------------------------------------
# change the numer of columns (affects resolution)
ncol(x) <- 18
ncol(x)
res(x)

#' 
#' ## Raster data storage
#' 
## ------------------------------------------------------------------------
r <- raster(ncol=10, nrow=10)
ncell(r)

#' But it is an empty raster
## ------------------------------------------------------------------------
hasValues(r)

#' 
#' 
#' 
#' Use `values()` function:
## ------------------------------------------------------------------------
values(r) <- 1:ncell(r)
hasValues(r)
values(r)[1:10]

#' 
#' 
#' ## Your Turn
#' 
#' Create and then plot a new raster with:
#' 
#' 1. 100 rows
#' 2. 50 columns
#' 3. Fill it with random values (`rnorm()`)
#' 
#' 
#' 
## ------------------------------------------------------------------------
x=raster(nrow=100,ncol=50,vals=rnorm(100*50))
# OR
x= raster(nrow=100,ncol=50)
values(x)= rnorm(5000)

plot(x)

#' 
#' 
#' 
#' Raster memory usage
#' 
## ------------------------------------------------------------------------
inMemory(r)

#' > You can change the memory options using the `maxmemory` option in `rasterOptions()` 
#' 
#' ## Raster Plotting
#' 
#' Plotting is easy (but slow) with `plot`.
#' 
## ------------------------------------------------------------------------
plot(r, main='Raster with 100 cells')

#' 
#' 
#' 
#' ### ggplot and rasterVis
#' 
#' rasterVis package has `gplot()` for plotting raster data in the `ggplot()` framework.
#' 
## ------------------------------------------------------------------------
gplot(r,maxpixels=50000)+
  geom_raster(aes(fill=value))

#' 
#' 
#' Adjust `maxpixels` for faster plotting of large datasets.
#' 
## ------------------------------------------------------------------------
gplot(r,maxpixels=10)+
  geom_raster(aes(fill=value))

#' 
#' 
#' 
#' Can use all the `ggplot` color ramps, etc.
#' 
## ------------------------------------------------------------------------
gplot(r)+geom_raster(aes(fill=value))+
    scale_fill_distiller(palette="OrRd")

#' 
#' 
#' ## Spatial Projections
#' 
#' Raster package uses standard [coordinate reference system (CRS)](http://www.spatialreference.org).  
#' 
#' For example, see the projection format for the [_standard_ WGS84](http://www.spatialreference.org/ref/epsg/4326/).
## ------------------------------------------------------------------------
projection(r)

#' 
#' ## Warping rasters
#' 
#' Use `projectRaster()` to _warp_ to a different projection.
#' 
#' `method=` `ngb` (for categorical) or `bilinear` (continuous)
#' 
## ------------------------------------------------------------------------
r2=projectRaster(r,crs="+proj=sinu +lon_0=0",method = )

par(mfrow=c(1,2));plot(r);plot(r2)


#' 
#' 
#' # WorldClim
#' 
#' ## Overview of WorldClim
#' 
#' Mean monthly climate and derived variables interpolated from weather stations on a 30 arc-second (~1km) grid.
#' See [worldclim.org](http://www.worldclim.org/methods)
#' 
#' 
#' 
#' ## Bioclim variables
#' 
#' <small>
#' 
#' Variable      Description
#' -    -
#' BIO1          Annual Mean Temperature
#' BIO2          Mean Diurnal Range (Mean of monthly (max temp – min temp))
#' BIO3          Isothermality (BIO2/BIO7) (* 100)
#' BIO4          Temperature Seasonality (standard deviation *100)
#' BIO5          Max Temperature of Warmest Month
#' BIO6          Min Temperature of Coldest Month
#' BIO7          Temperature Annual Range (BIO5-BIO6)
#' BIO8          Mean Temperature of Wettest Quarter
#' BIO9          Mean Temperature of Driest Quarter
#' BIO10         Mean Temperature of Warmest Quarter
#' BIO11         Mean Temperature of Coldest Quarter
#' BIO12         Annual Precipitation
#' BIO13         Precipitation of Wettest Month
#' BIO14         Precipitation of Driest Month
#' BIO15         Precipitation Seasonality (Coefficient of Variation)
#' BIO16         Precipitation of Wettest Quarter
#' BIO17         Precipitation of Driest Quarter
#' BIO18         Precipitation of Warmest Quarter
#' BIO19         Precipitation of Coldest Quarter
#' 
#' </small>
#' 
#' 
#' ## Download climate data
#' 
#' Download the data:
#' 
## ------------------------------------------------------------------------
clim=getData('worldclim', var='bio', res=10)

#' 
#' `res` is resolution (0.5, 2.5, 5, and 10 minutes of a degree)
#' 
#' 
#' 
#' ### Gain and Offset
#' 
## ------------------------------------------------------------------------
clim

#' 
#' Note the min/max of the raster.  What are the units?  Always check metadata, the [WorldClim temperature dataset](http://www.worldclim.org/formats) has a `gain` of 0.1, meaning that it must be multipled by 0.1 to convert back to degrees Celsius. Precipitation is in mm, so a gain of 0.1 would turn that into cm.
#' 
## ------------------------------------------------------------------------
gain(clim)=0.1

#' 
#' 
#' 
#' ### Plot with `plot()`
#' 
## ------------------------------------------------------------------------
plot(clim)

#' 
#'  
#' 
#' ## Faceting in ggplot
#' 
#' Or use `rasterVis` methods with gplot
## ------------------------------------------------------------------------
gplot(clim[[13:19]])+geom_raster(aes(fill=value))+
  facet_wrap(~variable)+
  scale_fill_gradientn(colours=c("brown","red","yellow","darkgreen","green"),trans="log10")+
  coord_equal()

#' 
#' 
#' 
#' Let's dig a little deeper into the data object:
#' 
## ------------------------------------------------------------------------
## is it held in RAM?
inMemory(clim)
## How big is it?
object.size(clim)

## can we work with it directly in RAM?
canProcessInMemory(clim)

#' 
#' 
#' ## Subsetting and spatial cropping
#' 
#' Use `[[1:3]]` to select raster layers from raster stack.
#' 
## ------------------------------------------------------------------------
r1 <- crop(clim[[1]], bbox(za))
## crop to a latitude/longitude box
r1 <- crop(clim[[1]], extent(10,35,-35,-20))

#' 
#' 
#' 
## ------------------------------------------------------------------------
r1
plot(r1)

#' 
#' ## Spatial aggregation
## ------------------------------------------------------------------------
## aggregate using a function
aggregate(r1, 3, fun=mean) %>%
  plot()

#' 
#' ## Your turn
#' 
#' Create a new raster by aggregating to the minimum (`min`) value of `r1` within a 10 pixel window
#' 
#' 
#' 
## ------------------------------------------------------------------------
aggregate(r1, 10, fun=min) %>%
  plot()

#' 
#' 
#' ## Focal ("moving window")
## ------------------------------------------------------------------------
## apply a function over a moving window
focal(r1, w=matrix(1,3,3), fun=mean) %>% 
  plot()

#' 
#' 
#' 
## ------------------------------------------------------------------------
## apply a function over a moving window
rf_min <- focal(r1, w=matrix(1,11,11), fun=min)
rf_max <- focal(r1, w=matrix(1,11,11), fun=max)
rf_range=rf_max-rf_min

## or just use the range function
rf_range2 <- focal(r1, w=matrix(1,11,11), fun=range)
plot(rf_range2)

#' 
#' ## Your turn
#' 
#' Plot the focal standard deviation of `r1` over a 3x3 window.
#' 
#' 
## ------------------------------------------------------------------------
focal(r1,w=matrix(1,3,3),fun=sd)%>%
  plot()

#' 
#' 
#' ## Raster calculations
#' 
#' the `raster` package has many options for _raster algebra_, including `+`, `-`, `*`, `/`, logical operators such as `>`, `>=`, `<`, `==`, `!` and functions such as `abs`, `round`, `ceiling`, `floor`, `trunc`, `sqrt`, `log`, `log10`, `exp`, `cos`, `sin`, `max`, `min`, `range`, `prod`, `sum`, `any`, `all`.
#' 
#' So, for example, you can 
## ------------------------------------------------------------------------
cellStats(r1,range)

## add 10
s = r1 + 10
cellStats(s,range)

#' 
#' 
#' 
## ------------------------------------------------------------------------
## take the square root
s = sqrt(r1)
cellStats(s,range)

# round values
r = round(r1)
cellStats(r,range)

# find cells with values less than 15 degrees C
r = r1 < 15
plot(r)

#' 
#' 
#' 
#' ### Apply algebraic functions
## ------------------------------------------------------------------------
# multiply s times r and add 5
s = s * r1 + 5
cellStats(s,range)

#' 
#' ## Extracting Raster Data
#' 
#' * points
#' * lines
#' * polygons
#' * extent (rectangle)
#' * cell numbers
#' 
#' Extract all intersecting values OR apply a summarizing function with `fun`.
#' 
#' 
#' 
#' ### Point data
## ------------------------------------------------------------------------
## define which species to query
library(spocc)
sp='Protea repens'

## run the query and convert to data.frame()
d = occ(query=sp, from='gbif',limit = 1000, has_coords=T) %>% occ2df()
coordinates(d)=c("longitude","latitude")
projection(d)="+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
dc=raster::extract(clim[[1:4]],d,df=T)
head(dc)

#' > Use `package::function` to avoid confusion with similar functions.
#' 
#' 
#' 
## ------------------------------------------------------------------------
gplot(r1)+geom_raster(aes(fill=value))+
  geom_point(data=as.data.frame(d),
             aes(x=longitude,y=latitude),col="red")+
  coord_equal()

#' 
#' 
#' 
## ----warning=F-----------------------------------------------------------
d2=dc%>%
  gather(ID)
colnames(d2)[1]="cell"

ggplot(d2,aes(x=value))+
  geom_density()+
  facet_wrap(~ID,scales="free")


#' 
#' 
#' 
#' 
#' ### Lines
#' 
#' Extract values along a transect.  
## ------------------------------------------------------------------------
transect = SpatialLinesDataFrame(
  SpatialLines(list(Lines(list(Line(
    cbind(c(19, 26),c(-33.5, -33.5)))), ID = "ZAF"))),
  data.frame(Z = c("transect"), row.names = c("ZAF")))

gplot(r1)+geom_tile(aes(fill=value))+
  geom_line(aes(x=long,y=lat),data=fortify(transect))

#' 
#' 
#' 
#' ### Plot Transect
#' 
## ------------------------------------------------------------------------
trans=raster::extract(clim,transect,along=T,cellnumbers=T)%>% 
  as.data.frame()
trans[,c("lon","lat")]=coordinates(clim)[trans$cell]
trans$order=as.integer(rownames(trans))
  
transl=group_by(trans,lon,lat)%>%
  gather(variable, value, -lon, -lat, -cell, -order)

ggplot(transl,aes(x=lon,y=value,
                  colour=variable,group=variable,
                  order=order))+
  geom_line()

#' 
#' 
#' 
#' ### _Zonal_ statistics
#' 
## ------------------------------------------------------------------------
rsp=raster::extract(r1,za,mean,sp=T)
spplot(rsp,zcol="bio1")

#' 
#' ## Your turn
#' 
#' 1. Download the Maximum Temperature dataset using `getData()`
#' 2. Crop it to the country you downloaded (or ZA?)
#' 2. Calculate the overall range for each variable with `cellStats()`
#' 3. Calculate the focal median with an 11x11 window with `focal()`
#' 4. Create a transect across the region and extract the temperature data.
#' 
#' 
#' ## Example
#' 
#' 1. Download the Maximum Temperature dataset using `getData()`
#' 2. Crop it to the country you downloaded (or ZA?)
#' 2. Calculate the overall range for each variable with `cellStats()`
#' 
## ------------------------------------------------------------------------

tun=getData('GADM', country='TUN', level=1)
tmax=getData('worldclim', var='tmax', res=10)
gain(tmax)=0.1
tmax_tun=crop(tmax,tun)

cellStats(tmax_tun,"range")

#' 
#' 
#' 
#' 3. Calculate the focal median with an 11x11 window with `focal()`
#' 4. Create a transect across the region and extract the temperature data.
#' 
## ------------------------------------------------------------------------
tmax_tunf=list()
for(i in 1:nlayers(tmax_tun))
  tmax_tunf[[i]]=focal(tmax_tun[[i]],w=matrix(1,11,11),fun=median)
tmax_tunf=stack(tmax_tunf)

# Transect
transect = SpatialLinesDataFrame(
  SpatialLines(list(Lines(list(Line(
    cbind(c(8, 10),c(36, 36)))), ID = "TUN"))),
  data.frame(Z = c("transect"), row.names = c("TUN")))


#' 
#' 
#' 
## ------------------------------------------------------------------------
gplot(tmax_tun)+geom_tile(aes(fill=value))+
  facet_wrap(~variable)+
  geom_path(data=fortify(tun),
            mapping=aes(x=long,y=lat,
                        group=group,order=order))+
  geom_line(aes(x=long,y=lat),
            data=fortify(transect),col="red")+
  coord_equal()

#' 
#' 
#' 
## ------------------------------------------------------------------------
trans=raster::extract(tmax_tun,transect,along=T,cellnumbers=T)%>% 
  as.data.frame()
trans[,c("lon","lat")]=coordinates(clim)[trans$cell]
trans$order=as.integer(rownames(trans))
  
transl=group_by(trans,lon,lat)%>%
  gather(variable, value, -lon, -lat, -cell, -order)

ggplot(transl,aes(x=lon,y=value,
                  colour=variable,group=variable,
                  order=order))+
  geom_line()


#' 
#' 
#' ## Raster Processing
#' 
#' Things to consider:
#' 
#' * RAM limitations
#' * Disk space and temporary files
#' * Use of external programs (e.g. GDAL)
#' * Use of external GIS viewer (e.g. QGIS)
#' 
#' 
