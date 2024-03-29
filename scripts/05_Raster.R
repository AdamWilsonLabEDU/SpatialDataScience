#' ---
#' title: "Introduction to Raster Package"
#' ---
#' 
#' 
#' <div class="extraswell">
#' <button data-toggle="collapse" class="btn btn-link" data-target="#pres">View Presentation </button> [Open presentation in a new tab](presentations/PS_06_raster.html){target="_blank"}
#' <div id="pres" class="collapse">
#' <div class="embed-responsive embed-responsive-16by9">
#'   <iframe class="embed-responsive-item" src="presentations/PS_06_raster.html" allowfullscreen></iframe>
#' _Click on presentation and then use the space bar to advance to the next slide or escape key to show an overview._
#' </div>
#' </div>
#' </div>
#' 
#' 
#' ## Download
#' 
#' | [<i class="fas fa-code fa-2x" aria-hidden="true"></i><br>  R Script](`r output_nocomment`) | [<i class="fa fa-file-code-o fa-2x"></i> <br> Commented R Script](`r output`) | [<i class="far fa-file-alt fa-2x"></i> <br>  Rmd Script](`r fullinput`)|
#' |:--:|:-:|:-:|
#' 
#' ## Libraries
#' 
## ----message=F,warning=FALSE, results='hide'-----------------------------
library(dplyr)
library(tidyr)
library(sp)
library(ggplot2)
library(rgeos)
library(maptools)

# load data for this course
# devtools::install_github("adammwilson/DataScienceData")
library(DataScienceData)

# New libraries
library(raster)
library(rasterVis)  #visualization library for raster

#' 
#' # Raster Package
#' 
#' ## `getData()`
#' 
#' Raster package includes access to some useful (vector and raster) datasets with `getData()`:
#' 
#' * Elevation (SRTM 90m resolution raster)
#' * World Climate (Tmin, Tmax, Precip, BioClim rasters)
#' * Countries from CIA factsheet (vector!)
#' * Global Administrative boundaries (vector!)
#' 
#' `getData()` steps for GADM:
#' 
#' 1. _Select Dataset_: ‘GADM’ returns the  global administrative boundaries.
#' 2. _Select country_: Country name of the boundaries using its ISO A3 country code
#' 3. _Specify level_: Level of of administrative subdivision (0=country, 1=first level subdivision).
#' 
#' ## GADM:  Global Administrative Areas
#' Administrative areas in this database are countries and lower level subdivisions.  
#' 
#' <img src="05_assets/gadm25.png" alt="alt text" width="70%">
#' 
#' Divided by country (see website for full dataset).  Explore country list:
## ------------------------------------------------------------------------
getData("ISO3")%>%
  as.data.frame%>%
  filter(NAME=="South Africa")

#' 
#' Download data for South Africa
## ---- eval=F-------------------------------------------------------------
## za=getData('GADM', country='ZAF', level=1)

#' 
#' Or use the version in the DataScienceData
## ------------------------------------------------------------------------
data(southAfrica)
za=southAfrica # rename for convenience

#' 
#' 
## ---- eval=F-------------------------------------------------------------
## plot(za)

#' Danger: `plot()` works, but can be slow for complex polygons.  If you want to speed it up, you can plot a simplified version as follows:
#' 
#' 
## ------------------------------------------------------------------------
za %>% gSimplify(0.01) %>% plot()

#' 
#' 
#' ### Check out attribute table
#' 
## ------------------------------------------------------------------------
za@data

#' 
#' 
#' Plot a subsetted region:
## ------------------------------------------------------------------------
subset(za,NAME_1=="Western Cape") %>% gSimplify(0.01) %>%
  plot()

#' 
#' 
#' <div class="well">
#' ## Your turn
#' 
#' Use the method above to download and plot the boundaries for a country of your choice.
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' 
#' 
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
## ---- echo=TRUE----------------------------------------------------------
x <- raster()
x

#' 
## ------------------------------------------------------------------------
str(x)

#' 
#' 
#' 
## ---- echo=T, results=T--------------------------------------------------
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
#' <div class="well">
#' ## Your turn
#' 
#' Create and then plot a new raster with:
#' 
#' 1. 100 rows
#' 2. 50 columns
#' 3. Fill it with random values (`rnorm()`)
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
#' <div id="demo2" class="collapse">
#' 
#' </div>
#' </div>
#' 
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
r2=projectRaster(r,crs="+proj=sinu +lon_0=0",method = "ngb")

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
## ---- eval=F-------------------------------------------------------------
## clim=raster::getData('worldclim', var='bio', res=10)

#' 
#' `res` is resolution (0.5, 2.5, 5, and 10 minutes of a degree)
#' 
#' Instead of downloading the full dataset, we'll use the copy in the `DataScienceData` package:
#' 
## ------------------------------------------------------------------------
data(worldclim)

#rename for convenience
clim=worldclim

#' 
#' 
#' ### Gain and Offset
#' 
## ------------------------------------------------------------------------
clim

#' 
#' Note the min/max of the raster.  What are the units?  Always check metadata, the [WorldClim temperature dataset](http://www.worldclim.org/formats) has a `gain` of 0.1, meaning that it must be multipled by 0.1 to convert back to degrees Celsius. We'll set the temperature variables (see table above) to 0.1 and leave the others at 1.
#' 
## ------------------------------------------------------------------------
gain(clim)=c(rep(0.1,11),rep(1,7))

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
## crop to a latitude/longitude box
r1 <- raster::crop(clim[[1]], extent(10,35,-35,-20))
## Crop using a Spatial polygon
r1 <- raster::crop(clim[[1]], bbox(za))

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
#' <div class="well">
#' ## Your turn
#' Create a new raster by aggregating to the minimum (`min`) value of `r1` within a 10 pixel window
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo3">Show Solution</button>
#' <div id="demo3" class="collapse">
#' 
#' </div>
#' </div>
#' 
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

## or do it all at once
range2=function(x,na.rm=F) {
  max(x,na.rm)-min(x,na.rm)
}

rf_range2 <- focal(r1, w=matrix(1,11,11), fun=range2)

plot(rf_range)
plot(rf_range2)

#' 
#' 
#' <div class="well">
#' ## Your turn
#' 
#' Plot the focal standard deviation of `r1` over a 3x3 window.
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo4">Show Solution</button>
#' <div id="demo4" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' 
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
#' ### Point data
#' 
#' `sampleRandom()` generates random points and automatically extracts the raster values for those points.  Also check out `?sampleStratified` and `sampleRegular()`.  
#' 
#' Generate 100 random points and the associated climate variables at those points.
## ------------------------------------------------------------------------
## define a new dataset of points to play with
pts=sampleRandom(clim,100,xy=T,sp=T)
plot(pts);axis(1);axis(2)

#' 
#' ### Extract data using a `SpatialPoints` object
#' Often you will have some locations (points) for which you want data from a raster* object.  You can use the `extract` function here with the `pts` object (we'll pretend it's a new point dataset for which you want climate variables).
## ------------------------------------------------------------------------
pts_data=raster::extract(clim[[1:4]],pts,df=T)
head(pts_data)

#' > Use `package::function` to avoid confusion with similar functions.
#' 
#' 
#' ### Plot the global dataset with the random points
## ------------------------------------------------------------------------
gplot(clim[[1]])+
  geom_raster(aes(fill=value))+
  geom_point(
    data=as.data.frame(pts),
    aes(x=x,y=y),col="red")+
  coord_equal()

#' 
#' ### Summarize climate data at point locations
#' Use `gather()` to reshape the climate data for easy plotting with ggplot.
#' 
## ----warning=F-----------------------------------------------------------
d2=pts_data%>%
  gather(ID)
colnames(d2)[1]="cell"
head(d2)

#' 
#' And plot density plots (like histograms).
## ------------------------------------------------------------------------
ggplot(d2,aes(x=value))+
  geom_density()+
  facet_wrap(~cell,scales="free")

#' 
#' 
#' ### Lines
#' 
#' Extract values along a transect.  
## ------------------------------------------------------------------------
transect = SpatialLinesDataFrame(
  SpatialLines(list(Lines(list(Line(
    rbind(c(19, -33.5),c(26, -33.5)))), ID = "ZAF"))),
  data.frame(Z = c("transect"), row.names = c("ZAF")))

# OR

transect=SpatialLinesDataFrame(
  readWKT("LINESTRING(19 -33.5,26 -33.5)"),
  data.frame(Z = c("transect")))


gplot(r1)+geom_tile(aes(fill=value))+
  geom_line(aes(x=long,y=lat),data=fortify(transect),col="red")

#' 
#' 
#' 
#' ### Plot Transect
#' 
## ------------------------------------------------------------------------
trans=raster::extract(x=clim[[12:14]],
                      y=transect,
                      along=T,
                      cellnumbers=T)%>%
  data.frame()
head(trans)

#' 
#' #### Add other metadata and reshape
## ------------------------------------------------------------------------
trans[,c("lon","lat")]=coordinates(clim)[trans$cell,]
trans$order=as.integer(rownames(trans))
head(trans)  

#' 
## ------------------------------------------------------------------------
transl=group_by(trans,lon,lat)%>%
  gather(variable, value, -lon, -lat, -cell, -order)
head(transl)

#' 
## ------------------------------------------------------------------------
ggplot(transl,aes(x=lon,y=value,
                  colour=variable,
                  group=variable,
                  order=order))+
  geom_line()

#' 
#' 
#' 
#' ### _Zonal_ statistics
#' Calculate mean annual temperature averaged by province (polygons).
#' 
## ------------------------------------------------------------------------
rsp=raster::extract(x=r1,
                    y=gSimplify(za,0.01),
                    fun=mean,
                    sp=T)
#spplot(rsp,zcol="bio1")

#' 
## ------------------------------------------------------------------------
## add the ID to the dataframe itself for easier indexing in the map
rsp$id=as.numeric(rownames(rsp@data))
## create fortified version for plotting with ggplot()
frsp=fortify(rsp,region="id")

ggplot(rsp@data, aes(map_id = id, fill=bio1)) +
    expand_limits(x = frsp$long, y = frsp$lat)+
    scale_fill_gradientn(
      colours = c("grey","goldenrod","darkgreen","green"))+
    coord_map()+
    geom_map(map = frsp)


#' 
#' > For more details about plotting spatialPolygons, see [here](https://github.com/hadley/ggplot2/wiki/plotting-polygon-shapefiles)
#' 
#' ## Example Workflow
#' 
#' 
#' 1. Download the Maximum Temperature dataset using `getData()`
#' 2. Set the gain to 0.1 (to convert to degrees Celcius)
#' 2. Crop it to the country you downloaded (or ZA?)
#' 2. Calculate the overall range for each variable with `cellStats()`
#' 3. Calculate the focal median with an 11x11 window with `focal()`
#' 4. Create a transect across the region and extract the temperature data.
#' 
## ------------------------------------------------------------------------
country=getData('GADM', country='TUN', level=1)%>%gSimplify(0.01)
tmax=getData('worldclim', var='tmax', res=10)
gain(tmax)=0.1
names(tmax)

#' 
#' Default layer names can be problematic/undesirable.
## ------------------------------------------------------------------------
sort(names(tmax))

## Options
month.name
month.abb
sprintf("%02d",1:12)
sprintf("%04d",1:12)

#' See `?sprintf` for details
#' 
## ------------------------------------------------------------------------
names(tmax)=sprintf("%02d",1:12)

tmax_crop=crop(tmax,country)
tmaxave_crop=mean(tmax_crop)  # calculate mean annual maximum temperature 
tmaxavefocal_crop=focal(tmaxave_crop,
                        fun=median,
                        w=matrix(1,11,11))

#' 
#' > Only a few datasets are available usig `getData()` in the raster package, but you can download almost any file on the web with `file.download()`.
#' 
#' Report quantiles for each layer in a raster* object
## ------------------------------------------------------------------------
cellStats(tmax_crop,"quantile")

#' 
#' 
#' ## Create a Transect  (SpatialLinesDataFrame)
## ------------------------------------------------------------------------
transect=SpatialLinesDataFrame(
  readWKT("LINESTRING(8 36,10 36)"),
  data.frame(Z = c("T1")))

#' 
#' 
#' ## Plot the timeseries of climate data
## ----fig.width=20,fig.height=20------------------------------------------
gplot(tmax_crop)+
  geom_tile(aes(fill=value))+
  scale_fill_gradientn(
    colours=c("brown","red","yellow","darkgreen","green"),
    name="Temp")+
  facet_wrap(~variable)+
  ## now add country overlays
  geom_path(data=fortify(country),
            mapping=aes(x=long,y=lat,
                        group=group,
                        order=order))+
  # now add transect line
  geom_line(aes(x=long,y=lat),
            data=fortify(transect),col="red",size=3)+
  coord_map()

#' 
#' 
#' ## Extract and clean up the transect data
## ------------------------------------------------------------------------
trans=raster::extract(tmax_crop,
                      transect,
                      along=T,
                      cellnumbers=T)%>% 
  as.data.frame()
trans[,c("lon","lat")]=coordinates(tmax_crop)[trans$cell]
trans$order=as.integer(rownames(trans))
head(trans)
  

#' 
#' Reformat to 'long' format.
## ------------------------------------------------------------------------
transl=group_by(trans,lon,lat)%>%
  gather(variable, value, -lon, -lat, -cell, -order)%>%
  separate(variable,into = c("X","month"),1)%>%
  mutate(month=as.numeric(month),monthname=factor(month.name[month],ordered=T,levels=month.name))
head(transl)

#' 
#' ## Plot the transect data
## ------------------------------------------------------------------------
ggplot(transl,
       aes(x=lon,y=value,
           colour=month,
           group=month,
           order=order))+
  ylab("Maximum Temp")+
    scale_color_gradientn(
      colors=c("blue","green","red"),
      name="Month")+
    geom_line()

#' 
#' Or the same data in a levelplot:
## ------------------------------------------------------------------------
ggplot(transl,
       aes(x=lon,y=monthname,
           fill=value))+
  ylab("Month")+
    scale_fill_distiller(
      palette="PuBuGn",
      name="Tmax")+
    geom_raster()

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
