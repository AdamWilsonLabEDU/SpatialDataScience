#' ---
#' title: "Working with Spatial Data"
#' ---
#' 
#' 
#' This file is available as a [<i class="fa fa-file-text" aria-hidden="true"></i> R script here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
#' # Setup
#' 
#' ## Load packages
## ----messages=F,warning=F------------------------------------------------
library(sp)
library(rgdal)
library(ggplot2)
library(dplyr)
library(tidyr)
library(maptools)

#' 
#' # Point data
#' 
#' ## Generate some random data
## ------------------------------------------------------------------------
coords = data.frame(
  x=rnorm(100),
  y=rnorm(100)
)
str(coords)

#' 
#' 
#' 
## ------------------------------------------------------------------------
plot(coords)

#' 
#' 
#' 
#' ## Convert to `SpatialPoints`
## ------------------------------------------------------------------------
sp = SpatialPoints(coords)
str(sp)

#' 
#' 
#' 
#' ## Create a `SpatialPointsDataFrame`
#' 
#' First generate a dataframe (analagous to the _attribute table_ in a shapefile)
## ------------------------------------------------------------------------
data=data.frame(ID=1:100,group=letters[1:20])
head(data)

#' 
#' 
#' 
#' Combine the coordinates with the data
## ------------------------------------------------------------------------
spdf = SpatialPointsDataFrame(coords, data)
spdf = SpatialPointsDataFrame(sp, data)

str(spdf)

#' Note the use of _slots_ designated with a `@`.  See `?slot` for more. 
#' 
#' 
#' ## Promote a data frame with `coordinates()`
## ------------------------------------------------------------------------
coordinates(data) = cbind(coords$x, coords$y) 

#' 
## ------------------------------------------------------------------------
str(spdf)

#' 
#' ## Subset data
#' 
## ------------------------------------------------------------------------
subset(spdf, group=="a")

#' 
#' Or using `[]`
## ------------------------------------------------------------------------
spdf[spdf$group=="a",]

#' 
#' Unfortunately, `dplyr` functions do not directly filter spatial objects.
#' 
#' 
#' <div class="well">
#' ## Your turn
#' 
#' Create a new SpatialPointsDataFrame from the following dataframe using the `coordinates()` method.
#' 
## ------------------------------------------------------------------------
df=data.frame(lat=c(12,15,17,12),lon=c(-35,-35,-32,-32),id=c(1,2,3,4))

#' 
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">
#' 
#' 
#' </div>
#' </div>
#' 
#' ## Examine topsoil quality in the Meuse river data set
#' 
## ------------------------------------------------------------------------
## Load the data
data(meuse)
str(meuse)

#' 
#' 
#' ## Your turn
#' _Promote_ the `meuse` object to a spatial points data.frame with `coordinates()`.
#' 
#' 
#' Plot it with ggplot:
## ---- fig.height=2-------------------------------------------------------
  ggplot(as.data.frame(meuse),aes(x=x,y=y))+
    geom_point(col="red")+
    coord_equal()

#' 
#' Note that `ggplot` works only with data.frames.  Convert with `as.data.frame()` or `fortify()`.
#' 
#' # Lines
#' 
#' ### A `Line` is a single chain of points.
#' 
## ------------------------------------------------------------------------
L1 = Line(cbind(rnorm(5),rnorm(5)))
L2 = Line(cbind(rnorm(5),rnorm(5)))
L3 = Line(cbind(rnorm(5),rnorm(5)))
L1

#' 
#' 
## ------------------------------------------------------------------------
plot(coordinates(L1),type="l")

#' 
#' 
#' 
#' ### A `Lines` object is a list of chains with an ID
#' 
## ------------------------------------------------------------------------
Ls1 = Lines(list(L1),ID="a")
Ls2 = Lines(list(L2,L3),ID="b")
Ls2

#' 
#' 
#' 
#' ### A `SpatialLines` is a list of Lines
#' 
## ------------------------------------------------------------------------
SL12 = SpatialLines(list(Ls1,Ls2))
plot(SL12)

#' 
#' 
#' 
#' ### A `SpatialLinesDataFrame` is a `SpatialLines` with a matching `DataFrame`
#' 
## ------------------------------------------------------------------------
SLDF = SpatialLinesDataFrame(
  SL12,
  data.frame(
  Z=c("road","river"),
  row.names=c("a","b")
))
str(SLDF)

#' 
#' 
#' # Polygons
#' 
#' ## Getting complicated
#' 
#' <img src="assets/polygons.png" alt="alt text" width="75%">
#' 
#' ### Issues
#' 
#' * Multipart Polygons
#' * Holes
#' 
#' Rarely construct _by hand_...
#' 
#' # Importing data
#' 
#' But, you rarely construct data _from scratch_ like we did above.  Usually you will import datasets created elsewhere.  
#' 
#' ## Geospatial Data Abstraction Library ([GDAL](gdal.org))
#' 
#' `rgdal` package for importing/exporting/manipulating spatial data:
#' 
#' * `readOGR()` and `writeOGR()`: Vector data
#' * `readGDAL()` and `writeGDAL()`: Raster data
#' 
#' Also the `gdalUtils` package for reprojecting, transforming, reclassifying, etc.
#' 
#' List the file formats that your installation of rgdal can read/write:
## ------------------------------------------------------------------------
knitr::kable(ogrDrivers())

#' 
#' Now as an example, let's read in a shapefile that's included in the `maptools` package.  You can try 
## ------------------------------------------------------------------------
## get the file path to the files
file=system.file("shapes/sids.shp", package="maptools")
## get information before importing the data
ogrInfo(dsn=file, layer="sids")

## Import the data
sids <- readOGR(dsn=file, layer="sids")
summary(sids)
plot(sids)

#' 
#' 
#' ### maptools package
#' Has an alternative function for importing shapefiles that's a little easier to use.
#' 
#' * `readShapeSpatial`
#' 
## ------------------------------------------------------------------------
sids <- readShapeSpatial(file)

#' 
#' # Coordinate Systems
#' 
#' * Earth isn't flat
#' * But small parts of it are close enough
#' * Many coordinate systems exist
#' * Anything `Spatial*` (or `raster*`) can have one
#' 
#' ## Specifying the coordinate system
#' 
#' ### The [Proj.4](https://trac.osgeo.org/proj/) library
#' Library for performing conversions between cartographic projections. 
#' 
#' See [http://spatialreference.org](http://spatialreference.org) for information on specifying projections. For example, 
#' 
#' 
#' #### Specifying coordinate systems 
#' 
#' **WGS 84**:
#' 
#' * proj4: <br><small>`+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs`</small>
#' * .prj / ESRI WKT: <small>`GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984",`<br>`
#' SPHEROID["WGS_1984",6378137,298.257223563]],`<br>`
#' PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]]`</small>
#' * EPSG:`4326`
#' 
#' 
#' 
#' Note that it has no projection information assigned (since it came from a simple data frame).  From the help file (`?meuse`) we can see that the projection is EPSG:28992.  
#' 
## ------------------------------------------------------------------------
proj4string(sids) <- CRS("+proj=longlat +ellps=clrk66")
proj4string(sids)

#' 
#' ## Spatial Transform
#' 
#' Assigning a CRS doesn't change the projection of the data, it just indicates which projection the data are currently in.  
#' So assigning the wrong CRS really messes things up.
#' 
#' Transform (_warp_) projection from one to another with `spTransform`
#' 
#' 
#' Project the `sids` data to the US National Atlas Equal Area (Lambert azimuthal equal-area projection):
## ------------------------------------------------------------------------
sids_us = spTransform(sids,CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))

#' 
#' Compare the _bounding box_:
## ------------------------------------------------------------------------
bbox(sids)
bbox(sids_us)

#' 
#' And plot them:
#' 
## ------------------------------------------------------------------------
# Geographic
ggplot(fortify(sids),aes(x=long,y=lat,order=order,group=group))+
  geom_polygon(fill="white",col="black")+
  coord_equal()
# Equal Area
ggplot(fortify(sids_us),aes(x=long,y=lat,order=order,group=group))+
  geom_polygon(fill="white",col="black")+
  coord_equal()+
  ylab("Northing")+xlab("Easting")

#' 
#' ## Colophon
#' See also:  `Raster` package for working with raster data
#' 
#' Sources:
#' 
#' * [UseR 2012 Spatial Data Workshop](http://www.maths.lancs.ac.uk/~rowlings/Teaching/UseR2012/index.html) by Barry Rowlingson
#' 
#' Licensing: 
#' 
#' * Presentation: [CC-BY-3.0 ](http://creativecommons.org/licenses/by/3.0/us/)
#' * Source code: [MIT](http://opensource.org/licenses/MIT) 
#' 
