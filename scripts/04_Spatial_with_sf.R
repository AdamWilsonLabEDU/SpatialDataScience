#' ---
#' title: "Working with Spatial Data"
#' ---
#' 
#' 
#' <div>
#' <iframe src="04_assets/04_Presentation.html" width=100% height=400px></iframe>
#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
#' # Setup
#' 
#' You may need to install a few of these packages with `install.packages()` or using the GUI. Note, much of the material below was taken from the [sf vignettes available here](https://cran.r-project.org/web/packages/sf/vignettes).
#' 
#' ## Load packages
## ----messages=F,warning=F, results="hide"--------------------------------
library(rgdal)
library(rgeos)
library(sf)
library(ggplot2)
library(dplyr)
library(tidyr)
library(maptools)

#' 
#' # Background
#' 
#' There are currently two main approaches in R to handle geographic vector data. 
#' 
#' ## The `sp` package
#' 
#' The first package to provide classes and methods for spatial data types in R is called [`sp`](https://cran.r-project.org/package=sp)[^1]. Development of the `sp` package began in the early 2000s in an attempt to standardize how spatial data would be treated in R and to allow for better interoperability between different analysis packages that use spatial data. The package (first release on CRAN in 2005) provides classes and methods to create _points_, _lines_, _polygons_, and _grids_ and to operate on them. About 350 of the spatial analysis packages use the spatial data types that are implemented in `sp` i.e. they "depend" on the `sp` package and many more are indirectly dependent.
#' 
#' [^1]: R Bivand (2011) [Introduction to representing spatial objects in R](http://geostat-course.org/system/files/monday_slides.pdf)
#' 
#' 
#' The foundational structure for any spatial object in `sp` is the `Spatial` class. It has two "slots" ([new-style S4 class objects in R have pre-defined components called slots](http://stackoverflow.com/a/4714080)):
#' 
#' * a __bounding box__ 
#'       
#' * a __CRS class object__ to define the Coordinate Reference System 
#' 
#' This basic structure is then extended, depending on the characteristics of the spatial object (point, line, polygon).
#' 
#' To build up a spatial object in `sp` we could follow these steps:  
#' 
#' ### I. Create geometric objects (topology)
#' 
#' __Points__ (which may have 2 or 3 dimensions) are the most basic spatial data objects. They are generated out of either a single coordinate or a set of coordinates, like a two-column matrix or a dataframe with a column for latitude and one for longitude.  
#' __Lines__ are generated out of `Line` objects. A `Line` object is a spaghetti collection of 2D coordinates[^2] and is generated out of a two-column matrix or a dataframe with a column for latitude and one for longitude. A `Lines` object is a __list__ of one or more `Line` objects, for example all the contours at a single elevation.  
#' __Polygons__ are generated out of `Polygon` objects. A `Polygon` object is a spaghetti collection of 2D coordinates with equal first and last coordinates and is generated out of a two-column matrix or a dataframe with a column for latitude and one for longitude. A `Polygons` object is a __list__ of one or more `Polygon` objects, for example islands belonging to the same country.
#' 
#' [^2]: Coordinates should be of type double and will be promoted if not.
#' 
#' See here for a very simple example for how to create a `Line` object:
## ------------------------------------------------------------------------
ln <- Line(matrix(runif(6), ncol=2))
str(ln)

#' See here for a very simple example for how to create a `Lines` object:
## ------------------------------------------------------------------------
lns <- Lines(list(ln), ID = "a") # this contains just one Line!
str(lns)

#' 
#'  
#' ### II. Create spatial objects `Spatial*` object (`*` stands for Points, Lines, or Polygons). 
#' 
#' This step adds the bounding box (automatically) and the slot for the Coordinate Reference System or CRS (which needs to be filled with a value manually). `SpatialPoints` can be directly generated out of the coordinates.  `SpatialLines` and `SpatialPolygons` objects are generated using lists of `Lines` or `Polygons` objects respectively (more below).
#' 
#' See here for how to create a `SpatialLines` object:
## ------------------------------------------------------------------------
sp_lns <- SpatialLines(list(lns))
str(sp_lns)

#'  
#' ### III. Add attributes (_Optional_:) 
#' 
#' Add a data frame with attribute data, which will turn your `Spatial*` object into a `Spatial*DataFrame` object.  The points in a `SpatialPoints` object may be associated with a row of attributes to create a `SpatialPointsDataFrame` object. The coordinates and attributes may, but do not have to be keyed to each other using ID values.  
#' `SpatialLinesDataFrame` and `SpatialPolygonsDataFrame` objects are defined using `SpatialLines` and `SpatialPolygons` objects and data frames. The ID fields are here required to match the data frame row names.
#' 
#' See here for how to create a `SpatialLinesDataframe`:
#' 
## ------------------------------------------------------------------------
dfr <- data.frame(id = "a", use = "road", cars_per_hour = 10) # note how we use the ID from above!
sp_lns_dfr <- SpatialLinesDataFrame(sp_lns, dfr, match.ID = "id")
str(sp_lns_dfr)

#' 
#' A number of spatial methods are available for the classes in `sp`. Common ones include:
#' 
#' function | and what it does
#' ------------ | ------------------------------------------------------
#' `bbox()` | returns the bounding box coordinates
#' `proj4string()` | sets or retrieves projection attributes using the CRS object.
#' `CRS()` | creates an object of class of coordinate reference system arguments
#' `spplot()` | plots a separate map of all the attributes unless specified otherwise
#' `coordinates()` | set or retrieve the spatial coordinates. For spatial polygons it returns the centroids.
#' `over(a, b)` | used for example to retrieve the polygon or grid indices on a set of points
#' `spsample()` | sampling of spatial points within the spatial extent of objects
#' 
#' ## The `sf` package
#' 
#' The second package, first released on CRAN in late October 2016, is called [`sf`](https://cran.r-project.org/package=sf)[^3]. It implements a formal standard called ["Simple Features"](https://en.wikipedia.org/wiki/Simple_Features) that specifies a storage and access model of spatial geometries (point, line, polygon). A feature geometry is called simple when it consists of points connected by straight line pieces, and does not intersect itself. This standard has been adopted widely, not only by spatial databases such as PostGIS, but also more recent standards such as GeoJSON. 
#' 
#' [^3]: E. Pebesma & R. Bivand (2016)[Spatial data in R: simple features and
#' future perspectives](http://pebesma.staff.ifgi.de/pebesma_sfr.pdf)
#' 
#' 
#' [Simple features](https://en.wikipedia.org/wiki/Simple_Features) or [_simple feature access_](http://www.opengeospatial.org/standards/sfa) refers to a formal standard (ISO 19125-1:2004) that describes how objects in the real world can be represented in computers, with emphasis on the _spatial_ geometry of these objects. It also describes how such objects can be stored in and retrieved from databases, and which geometrical operations should be defined for them.
#' 
#' The standard is widely implemented in spatial
#' databases (such as PostGIS), commercial GIS (e.g., [ESRI
#' ArcGIS](http://www.esri.com/)) and forms the vector data basis for
#' libraries such as [GDAL](http://www.gdal.org/). A subset of
#' simple features forms the [GeoJSON](http://geojson.org/) standard.
#' 
#' If you work with PostGis or GeoJSON you may have come across the [WKT (well-known text)](https://en.wikipedia.org/wiki/Well-known_text) format, for example like these: 
#' 
#'     POINT (30 10)
#'     LINESTRING (30 10, 10 30, 40 40)
#'     POLYGON ((30 10, 40 40, 20 40, 10 20, 30 10))
#' 
#' `sf` implements this standard natively in R. Data are structured and conceptualized very differently from the `sp` approach.
#' 
#' In `sf` spatial objects are stored as a simple data frame with a special column that contains the information for the geographic coordinates. That special column is a list with the same length as the number of rows in the data frame. Each of the individual list elements then can be of any length needed to hold the coordinates that correspond to an individual feature.  
#' 
#' To create a spatial object manually the basic steps would be:  
#' 
#' ### I. Create geometric objects (topology)  
#' 
#' Geometric objects (simple features) can be created from a numeric vector, matrix or a list with the coordinates. They are called `sfg` objects for Simple Feature Geometry.
#' 
#' See here for an example of how a LINESTRING `sfg` object is created:
## ------------------------------------------------------------------------
lnstr_sfg <- st_linestring(matrix(runif(6), ncol=2)) 
class(lnstr_sfg)

#' 
#' ### II. Combine all individual single feature objects for the special column. 
#' 
#' In order to work our way towards a data frame for all features we create what is called an `sfc` object with all individual features, which stands for Simple Feature Collection. The `sfc` object also holds the bounding box and the projection information.
#' 
#' See here for an example of how a `sfc` object is created:
## ------------------------------------------------------------------------
(lnstr_sfc <- st_sfc(lnstr_sfg)) # just one feature here
class(lnstr_sfc) 

#' 
#' ### III. Add attributes. 
#' 
#' We now combine the dataframe with the attributes and the simple feature collection.
#' See here how its done.
## ------------------------------------------------------------------------
(lnstr_sf <- st_sf(dfr , lnstr_sfc))
class(lnstr_sf)

#' 
#' There are many methods available in the `sf` package, to find out use `methods(class="sp")`
#' 
#' Here are some of the other highlights of `sf` you might be interested in:
#' 
#' * provides **fast** I/O, particularly relevant for large files 
#' * directly reads from and writes to spatial **databases** such as PostGIS
#' * stay tuned for a new `ggplot` release that will be able to read and plot the `sf` format without the need of conversion to a data frame, like the `sp` format
#' 
#' Note that `sp` and `sf` are not the only way spatial objects are conceptualized in R. Other spatial packages may use their own class definitions for spatial data (for example `spatstat`). Usually you can find functions that convert `sp` and increasingly `sf` objects to and from these formats.
#' 
#' 
#' ## sf: objects with simple features
#' 
#' As we usually do not work with geometries of single simple features,
#' but with datasets consisting of sets of features with attributes, the
#' two are put together in `sf` (simple feature) objects.  The following
#' command reads the `nc` dataset from a file that is contained in the
#' `sf` package:
#' 
## ------------------------------------------------------------------------
file=system.file("shape/nc.shp", package="sf")
file
nc <- st_read(file)

#' 
#' (Note that you will rarely use `system.file` but instead give a `filename` directly, and that shapefiles consist of more than one file, all with identical basename, which reside in the same directory.)
#' 
#' The short report printed gives the file name, the driver (ESRI Shapefile), mentions that there are 100 features (records, represented as rows) and 14
#' fields (attributes, represented as columns). This object is of class
#' 
## ------------------------------------------------------------------------
class(nc)

#' meaning it extends (and "is" a) `data.frame`, but with a single
#' list-column with geometries, which is held in the column with name
#' 
## ------------------------------------------------------------------------
attr(nc, "sf_column")

#' 
#' If we print the first three features, we see their attribute values
#' and an abridged version of the geometry
#' 
## ---- echo=TRUE, eval=FALSE----------------------------------------------
## print(nc[9:15], n = 3)

#' which would give the following output:
#' 
#' ![](04_spatial_with_sf/sf_xfig.png)
#' 
#' In the output we see:
#' 
#' * in green a simple feature: a single record, or `data.frame` row, consisting of attributes and geometry
#' * in blue a single simple feature geometry (an object of class `sfg`)
#' * in red a simple feature list-column (an object of class `sfc`, which is a column in the `data.frame`)
#' * that although geometries are native R objects, they are printed as [well-known text](#wkb)
#' 
#' Methods for `sf` objects are
## ------------------------------------------------------------------------
methods(class = "sf")

#' 
#' It is also possible to create `data.frame` objects with geometry list-columns that are not of class `sf`, e.g. by
## ------------------------------------------------------------------------
nc.no_sf <- as.data.frame(nc)
class(nc.no_sf)

#' 
#' However, such objects:
#' 
#' * no longer register which column is the geometry list-column
#' * no longer have a plot method, and
#' * lack all of the other dedicated methods listed above for class `sf`
#' 
#' ## sfc: simple feature geometry list-column
#' 
#' The column in the `sf` data.frame that contains the geometries is a list, of class `sfc`.
#' We can retrieve the geometry list-column in this case by `nc$geom` or `nc[[15]]`, but the
#' more general way uses `st_geometry`:
#' 
## ------------------------------------------------------------------------
nc_geom <- st_geometry(nc)

#' 
#' Geometries are printed in abbreviated form, but we can
#' can view a complete geometry by selecting it, e.g. the first one by
#' 
## ------------------------------------------------------------------------
nc_geom[[1]]

#' 
#' The way this is printed is called _well-known text_, and is part of the standards. The word `MULTIPOLYGON` is followed by three parenthesis, because it can consist of multiple polygons, in the form of `MULTIPOLYGON(POL1,POL2)`, where `POL1` might consist of an exterior ring and zero or more interior rings, as of `(EXT1,HOLE1,HOLE2)`. Sets of coordinates are held together with parenthesis, so we get `((crds_ext)(crds_hole1)(crds_hole2))` where `crds_` is a comma-separated set of coordinates of a ring. This leads to the case above, where `MULTIPOLYGON(((crds_ext)))` refers to the exterior ring (1), without holes (2), of the first polygon (3) - hence three parentheses.
#' 
#' We can see there is a single polygon with no rings:
#' 
## ----fig.height=3--------------------------------------------------------
plot(nc[1])
plot(nc[1,1], col = 'grey', add = TRUE)

#' 
#' but some of the polygons in this dataset have multiple exterior rings; they can be identified by
## ----fig.height=3.5------------------------------------------------------
w <- which(sapply(nc_geom, length) > 1)
plot(nc[w,1], col = 2:7)

#' 
#' Following the `MULTIPOLYGON` datastructure, in R we have a list of lists of lists of matrices. For instance,
#' we get the coordinate pairs of the second exterior ring (first ring is always exterior) for the geometry
#' of feature 4 by
#' 
## ------------------------------------------------------------------------
nc_geom[[4]][[2]][[1]]

#' 
#' Geometry columns have their own class,
#' 
## ------------------------------------------------------------------------
class(nc_geom)

#' 
#' Methods for geometry list-columns include
## ------------------------------------------------------------------------
methods(class = 'sfc')

#' 
#' Coordinate reference systems (`st_crs` and `st_transform`) are discussed in the section on [coordinate reference systems](#crs).
#' `st_as_wkb` and `st_as_text` convert geometry list-columns into well-known-binary or well-known-text, explained [below](#wkb).
#' `st_bbox` retrieves the coordinate bounding box.
#' 
#' Attributes include
## ------------------------------------------------------------------------
attributes(nc_geom)

#' 
#' ## Mixed geometry types
#' 
#' The class of `nc_geom` is `c("sfc_MULTIPOLYGON", "sfc")`: `sfc`
#' is shared with all geometry types, and `sfc_TYPE` with `TYPE`
#' indicating the type of the particular geometry at hand.
#' 
#' There are two "special" types: `GEOMETRYCOLLECTION`, and `GEOMETRY`.
#' `GEOMETRYCOLLECTION` indicates that each of the geometries may contain
#' a mix of geometry types, as in
## ------------------------------------------------------------------------
mix <- st_sfc(st_geometrycollection(list(st_point(1:2))),
    st_geometrycollection(list(st_linestring(matrix(1:4,2)))))
class(mix)

#' Still, the geometries are here of a single type.
#' 
#' The second `GEOMETRY`, indicates that the geometries in the geometry
#' list-column are of varying type:
## ------------------------------------------------------------------------
mix <- st_sfc(st_point(1:2), st_linestring(matrix(1:4,2)))
class(mix)

#' 
#' These two are fundamentally different: `GEOMETRY` is a superclass without instances, `GEOMETRYCOLLECTION` is a geometry instance. `GEOMETRY` list-columns occur when we read in a data source with a mix of geometry types. `GEOMETRYCOLLECTION` *is* a single feature's geometry: the intersection of two feature polygons may consist of points, lines and polygons, see the example [below](#geometrycollection).
#' 
#' ## sfg: simple feature geometry
#' 
#' Simple feature geometry (`sfg`) objects carry the geometry for a
#' single feature, e.g. a point, linestring or polygon.
#' 
#' Simple feature geometries are implemented as R native data, using the following rules
#' 
#' 1. a single POINT is a numeric vector
#' 2. a set of points, e.g. in a LINESTRING or ring of a POLYGON is a `matrix`, each row containing a point
#' 3. any other set is a `list`
#' 
#' Creator functions are rarely used in practice, since we typically
#' bulk read and write spatial data. They are useful for illustration:
#' 
## ------------------------------------------------------------------------
(x <- st_point(c(1,2)))
str(x)
(x <- st_point(c(1,2,3)))
str(x)
(x <- st_point(c(1,2,3), "XYM"))
str(x)
(x <- st_point(c(1,2,3,4)))
str(x)
st_zm(x, drop = TRUE, what = "ZM")

#' This means that we can represent 2-, 3- or 4-dimensional
#' coordinates. All geometry objects inherit from `sfg` (simple feature
#' geometry), but also have a type (e.g. `POINT`), and a dimension
#' (e.g. `XYM`) class name. A figure illustrates six of the seven most
#' common types.
#' 
#' With the exception of the `POINT` which has a single point as
#' geometry, the remaining six common single simple feature geometry
#' types that correspond to single features (single records, or rows
#' in a `data.frame`) are created like this
#' 
## ------------------------------------------------------------------------
p <- rbind(c(3.2,4), c(3,4.6), c(3.8,4.4), c(3.5,3.8), c(3.4,3.6), c(3.9,4.5))
(mp <- st_multipoint(p))
s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
(ls <- st_linestring(s1))
s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
s3 <- rbind(c(0,4.4), c(0.6,5))
(mls <- st_multilinestring(list(s1,s2,s3)))
p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
pol <-st_polygon(list(p1,p2))
p3 <- rbind(c(3,0), c(4,0), c(4,1), c(3,1), c(3,0))
p4 <- rbind(c(3.3,0.3), c(3.8,0.3), c(3.8,0.8), c(3.3,0.8), c(3.3,0.3))[5:1,]
p5 <- rbind(c(3,3), c(4,2), c(4,3), c(3,3))
(mpol <- st_multipolygon(list(list(p1,p2), list(p3,p4), list(p5))))
(gc <- st_geometrycollection(list(mp, mpol, ls)))

#' 
#' The objects created are shown here:
#' 
## ---- echo=FALSE---------------------------------------------------------
par(mar = c(0.1, 0.1, 1.3, 0.1), mfrow = c(2, 3))
plot(mp, col = 'red')
box()
title("MULTIPOINT")

plot(ls, col = 'red')
box()
title("LINESTRING")

plot(mls, col = 'red')
box()
title("MULTILINESTRING")

plot(pol, border = 'red', col = 'grey', xlim = c(0,4))
box()
title("POLYGON")

plot(mpol, border = 'red', col = 'grey')
box()
title("MULTIPOLYGON")

plot(gc, border = 'grey', col = 'grey')
box()
title("GEOMETRYCOLLECTION")
par(mfrow = c(1, 1))

#' 
#' Geometries can also be empty, as in
#' 
## ------------------------------------------------------------------------
x <- st_geometrycollection()
length(x)

#' 
#' ## Well-known text, well-known binary, precision {#wkb}
#' 
#' ### WKT and WKB
#' 
#' Well-known text (WKT) and well-known binary (WKB) are two encodings
#' for simple feature geometries. Well-known text, e.g. seen in
## ------------------------------------------------------------------------
x <- st_linestring(matrix(10:1,5))
st_as_text(x)

#' (but without the leading `## [1]` and quotes), is
#' human-readable. Coordinates are usually floating point numbers,
#' and moving large amounts of information as text is slow and
#' imprecise. For that reason, we use well-known binary (WKB) encoding
#' 
## ------------------------------------------------------------------------
st_as_binary(x)

#' 
#' WKT and WKB can both be transformed back into R native objects by
#' 
## ------------------------------------------------------------------------
st_as_sfc("LINESTRING(10 5, 9 4, 8 3, 7 2, 6 1)")[[1]]
st_as_sfc(structure(list(st_as_binary(x)), class = "WKB"))[[1]]

#' 
#' GDAL, GEOS, spatial databases and GIS read and write WKB which
#' is fast and precise. Conversion between R native objects and WKB
#' is done by package `sf` in compiled (C++/Rcpp) code, making this a
#' reusable and fast route for I/O of simple feature geometries in R.
#' 
#' ## Reading and writing
#' 
#' As we've seen above, reading spatial data from an external file can be done by
#' 
## ------------------------------------------------------------------------
filename <- system.file("shape/nc.shp", package="sf")
nc <- st_read(filename)

#' we can suppress the output by adding argument `quiet=TRUE` or
#' by using the otherwise nearly identical but more quiet
## ------------------------------------------------------------------------
nc <- read_sf(filename)

#' 
#' Writing takes place in the same fashion, using `st_write`:
#' 
## ------------------------------------------------------------------------
st_write(nc, "nc.shp")

#' 
#' If we repeat this, we get an error message that the file already
#' exists, and we can overwrite by
#' 
## ------------------------------------------------------------------------
st_write(nc, "nc.shp", delete_layer = TRUE)

#' 
#' or its quiet alternative that does this by default,
#' 
## ------------------------------------------------------------------------
write_sf(nc, "nc.shp") # silently overwrites

#' 
#' ### Driver-specific options
#' 
#' The `dsn` and `layer` arguments to `st_read` and `st_write`
#' denote a data source name and optionally a layer name.  Their exact
#' interpretation as well as the options they support vary per driver,
#' the [GDAL driver documentation](http://www.gdal.org/ogr_formats.html)
#' is best consulted for this.  For instance, a PostGIS table in
#' database `postgis` might be read by
#' 
## ----eval=FALSE----------------------------------------------------------
## meuse <- st_read("PG:dbname=postgis", "meuse")

#' 
#' where the `PG:` string indicates this concerns the PostGIS driver,
#' followed by database name, and possibly port and user credentials.
#' When the `layer` and `driver` arguments are not specified, `st_read`
#' tries to guess them from the datasource, or else simply reads the
#' first layer, giving a warning in case there are more.
#' 
#' `st_read` typically reads the coordinate reference system as
#' `proj4string`, but not the EPSG (SRID).  GDAL cannot retrieve SRID
#' (EPSG code) from `proj4string` strings, and, when needed, it has
#' to be set by the user. See also the section on [crs](crs).
#' 
#' `st_drivers()` returns a `data.frame` listing available drivers,
#' and their metadata: names, whether a driver can write, and whether
#' it is a raster and/or vector driver. All drivers can read. Reading
#' of some common data formats is illustrated below:
#' 
#' `st_layers(dsn)` lists the layers present in data source `dsn`,
#' and gives the number of fields, features and geometry type for each
#' layer:
## ------------------------------------------------------------------------
st_layers(system.file("osm/overpass.osm", package="sf"))

#' we see that in this case, the number of features is `NA` because
#' for this xml file the whole file needs to be read, which may be
#' costly for large files. We can force counting by
## ------------------------------------------------------------------------
Sys.setenv(OSM_USE_CUSTOM_INDEXING="NO")
st_layers(system.file("osm/overpass.osm", package="sf"), do_count = TRUE)

#' 
#' Another example of reading kml and kmz files is:
## ---- eval=FALSE---------------------------------------------------------
## # Download .shp data
## u_shp <- "http://coagisweb.cabq.gov/datadownload/biketrails.zip"
## download.file(u_shp, "biketrails.zip")
## unzip("biketrails.zip")
## u_kmz <- "http://coagisweb.cabq.gov/datadownload/BikePaths.kmz"
## download.file(u_kmz, "BikePaths.kmz")
## # Read file formats
## biketrails_shp <- st_read("biketrails.shp")
## if(Sys.info()[1] == "Linux") # may not work if not Linux
##   biketrails_kmz <- st_read("BikePaths.kmz")
## u_kml = "http://www.northeastraces.com/oxonraces.com/nearme/safe/6.kml"
## download.file(u_kml, "bikeraces.kml")
## bikraces <- st_read("bikeraces.kml")

#' 
#' ### Create, read, update and delete {#crud}
#' 
#' GDAL provides the
#' [crud](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete)
#' (create, read, update, delete) functions to persistent storage.
#' `st_read` (or `read_sf`) are used for reading. `st_write` (or `write_sf`)
#' creates, and has the following arguments to control update and delete:
#' 
#' * `update=TRUE` causes an existing data source to be updated, if it
#' exists; this options is by default `TRUE` for all database drivers,
#' where the database is updated by adding a table.
#' * `delete_layer=TRUE` causes `st_write` try to open the the data
#' source and delete the layer; no errors are given if the data source is
#' not present, or the layer does not exist in the data source.
#' * `delete_dsn=TRUE` causes `st_write` to delete the data source when
#' present, before writing the layer in a newly created data source. No
#' error is given when the data source does not exist. This option
#' should be handled with care, as it may wipe complete directories
#' or databases.
#' 
#' 
#' ### Directly reading and writing to spatial databases
#' 
#' Two further functions, `st_read_db` and `st_write_db` attempt to
#' read and write from spatial databases, directly reading WKB or WKT
#' without using GDAL. The advantage over `st_read` may be that instead
#' of a complete table, the result of a (spatial) query may be fetched,
#' limiting the amount of data that is read into R, and potentially
#' benefiting from the spatial index of the database. Although intended
#' to use the DBI interface, current use and testing of these functions
#' are limited to PostGIS.
#' 
#' ## Coordinate reference systems and transformations {#crs}
#' 
#' Coordinate reference systems (CRS) are like measurement units for
#' coordinates: they specify which location on Earth a particular
#' coordinate pair refers to. We saw above that `sfc` objects
#' (geometry list-columns) have two attributes to store a CRS: `epsg`
#' and `proj4string`.  This implies that all geometries in a geometry
#' list-column must have the same CRS. Both may be `NA`, e.g. in case
#' the CRS is unknown, or when we work with local coordinate systems
#' (e.g. inside a building, a body, or an abstract space).
#' 
#' `proj4string` is a generic, string-based description of a CRS,
#' understood by the [PROJ.4](http://proj4.org/) library. It defines
#' projection types and (often) defines parameter values for particular
#' projections, and hence can cover an infinite amount of different
#' projections.  This library (also used by GDAL) provides functions
#' to convert or transform between different CRS.  `epsg` is the
#' integer ID for a particular, known CRS that can be resolved into a
#' `proj4string`. There is no (known, simple and general) way to resolve
#' `proj4string` values into `epsg` IDs.
#' 
#' The importance of having `epsg` values stored with data besides
#' `proj4string` values is that the `epsg` refers to particular,
#' well-known CRS, whose parameters may change (improve) over time;
#' fixing only the `proj4string` may remove the possibility to benefit
#' from such improvements, and limit the provenance of datasets.
#' 
#' Coordinate reference system transformations can be carried out using
#' `st_transform`, e.g. converting longitudes/latitudes in NAD27 to
#' web mercator (EPSG:3857) can be done by
#' 
## ------------------------------------------------------------------------
nc.web_mercator <- st_transform(nc, 3857)
st_geometry(nc.web_mercator)[[4]][[2]][[1]][1:3,]

#' 
#' ## Conversion, including to and from sp
#' 
#' `sf` objects and objects deriving from `Spatial` (package `sp`) can be coerced both ways:
#' 
## ------------------------------------------------------------------------
# anticipate that sp::CRS will expand proj4strings:
p4s <- "+proj=longlat +datum=NAD27 +no_defs +ellps=clrk66 +nadgrids=@conus,@alaska,@ntv2_0.gsb,@ntv1_can.dat"
st_crs(nc) <- p4s
# anticipate geometry column name changes:
names(nc)[15] = "geometry"
attr(nc, "sf_column") = "geometry"
nc.sp <- as(nc, "Spatial")
class(nc.sp)
nc2 <- st_as_sf(nc.sp)
#all.equal(nc, nc2)

#' 
#' As the `Spatial*` objects only support `MULTILINESTRING` and `MULTIPOLYGON`, `LINESTRING` and `POLYGON` geometries
#' are automatically coerced into their `MULTI` form. When converting `Spatial*` into `sf`, if all geometries consist of a single
#' `POLYGON` (possibly with holes), a `POLYGON` and otherwise all geometries are returned as `MULTIPOLYGON`: a
#' mix of `POLYGON` and `MULTIPOLYGON` (such as common in shapefiles) is not created. Argument `forceMulti=TRUE`
#' will override this, and create `MULTIPOLYGON`s in all cases. For `LINES` the situation is identical.
#' 
#' ## Geometrical operations {#geometrycollection}
#' 
#' The standard for simple feature access defines a number of geometrical operations.
#' 
#' `st_is_valid` and `st_is_simple` return a boolean indicating whether
#' a geometry is valid or simple.
#' 
## ------------------------------------------------------------------------
st_is_valid(nc[1:2,])

#' 
#' `st_distance` returns a dense numeric matrix with distances
#' between geometries. `st_relate` returns a character matrix with the
#' [DE9-IM](https://en.wikipedia.org/wiki/DE-9IM#Illustration) values
#' for each pair of geometries:
#' 
## ------------------------------------------------------------------------
x = st_transform(nc, 32119)
st_distance(x[c(1,4,22),], x[c(1, 33,55,56),])
st_relate(nc[1:5,], nc[1:4,])

#' 
#' The commands `st_intersects`, `st_disjoint`, `st_touches`,
#' `st_crosses`, `st_within`, `st_contains`, `st_overlaps`,
#' `st_equals`, `st_covers`, `st_covered_by`, `st_equals_exact` and
#' `st_is_within_distance` return a sparse matrix with matching (TRUE)
#' indexes, or a full logical matrix:
#' 
## ------------------------------------------------------------------------
st_intersects(nc[1:5,], nc[1:4,])
st_intersects(nc[1:5,], nc[1:4,], sparse = FALSE)

#' 
#' The commands `st_buffer`, `st_boundary`, `st_convexhull`,
#' `st_union_cascaded`, `st_simplify`, `st_triangulate`,
#' `st_polygonize`, `st_centroid`, `st_segmentize`, and `st_union`
#' return new geometries, e.g.:
#' 
## ----fig.height=3--------------------------------------------------------
sel <- c(1,5,14)
geom = st_geometry(nc.web_mercator[sel,])
buf <- st_buffer(geom, dist = 30000)
plot(buf, border = 'red')
plot(geom, add = TRUE)
plot(st_buffer(geom, -5000), add = TRUE, border = 'blue')

#' 
#' Commands `st_intersection`, `st_union`, `st_difference`,
#' `st_sym_difference` return new geometries that are a function of
#' pairs of geometries:
#' 
## ----fig.height=3--------------------------------------------------------
par(mar = rep(0,4))
u <- st_union(nc)
plot(u)

#' 
#' The following code shows how computing an intersection between two polygons
#' may yield a `GEOMETRYCOLLECTION` with a point, line and polygon:
#' 
## ----fig.height=3, fig.width=7-------------------------------------------
opar <- par(mfrow = c(1, 2))
a <- st_polygon(list(cbind(c(0,0,7.5,7.5,0),c(0,-1,-1,0,0))))
b <- st_polygon(list(cbind(c(0,1,2,3,4,5,6,7,7,0),c(1,0,.5,0,0,0.5,-0.5,-0.5,1,1))))
plot(a, ylim = c(-1,1))
title("intersecting two polygons:")
plot(b, add = TRUE, border = 'red')
(i <- st_intersection(a,b))
plot(a, ylim = c(-1,1))
title("GEOMETRYCOLLECTION")
plot(b, add = TRUE, border = 'red')
plot(i, add = TRUE, col = 'green', lwd = 2)
par(opar)

#' 
#' ## Non-valid geometries
#' 
#' Invalid geometries are for instance self-intersecting lines (left) or polygons with slivers (middle) or self-intersections (right).
#' 
## ------------------------------------------------------------------------
x1 <- st_linestring(cbind(c(0,1,0,1),c(0,1,1,0)))
x2 <- st_polygon(list(cbind(c(0,1,1,1,0,0),c(0,0,1,0.6,1,0))))
x3 <- st_polygon(list(cbind(c(0,1,0,1,0),c(0,1,1,0,0))))
st_is_simple(st_sfc(x1))
st_is_valid(st_sfc(x2,x3))

#' 
## ----echo=FALSE,fig=TRUE,fig.height=3------------------------------------
opar <- par(mfrow = c(1,3))
par(mar=c(1,1,4,1))
plot(st_sfc(x1), type = 'b', axes = FALSE, xlab = NULL, ylab = NULL);
title(st_as_text(x1))
plot(st_sfc(st_linestring((cbind(c(0,1,1,1,0,0),c(0,0,1,0.6,1,0))))), type='b', axes = FALSE)
title(st_as_text(x2))
plot(st_sfc(st_linestring(cbind(c(0,1,0,1,0),c(0,1,1,0,0)))), type = 'b', axes=F, xlab=NULL,ylab=NULL)
title(st_as_text(x3))
par(opar)

#' 
#' # Units
#' 
#' Where possible geometric operations such as `st_distance()`, `st_length()` and `st_area()` report results with a units attribute appropriate for the CRS:
#' 
## ------------------------------------------------------------------------
a <- st_area(nc[1,])
attributes(a)

#' 
#' The **units** package can be used to convert between units:
#' 
## ------------------------------------------------------------------------
units::set_units(a, km^2) # result in square kilometers
units::set_units(a, ha) # result in hectares

#' 
#' The result can be stripped of their attributes if needs be:
#' 
## ------------------------------------------------------------------------
as.numeric(a)

#' 
#' # How attributes relate to geometries
#' 
#' (This will eventually be the topic of a new vignette; now here to explain the last attribute of `sf` objects)
#' 
#' The standard documents about simple features are very detailed about the geometric aspects of features, but say nearly nothing about attributes, except that their values should be understood in another reference system (their units of measurement, e.g. as implemented in the package [**units**](https://CRAN.R-project.org/package=units)). But there is more to it. For variables like air temperature, interpolation usually makes sense, for others like human body temperature it doesn't. The difference is that air temperature is a field, which continues between sensors, where body temperature is an object property that doesn't extend beyond the body -- in spatial statistics bodies would be called a point pattern, their temperature the point marks. For geometries that have a non-zero size (positive length or area), attribute values may refer to the every sub-geometry (every point), or may summarize the geometry. For example, a state's population density summarizes the whole state, and is not a meaningful estimate of population density for a give point inside the state without the context of the state. On the other hand, land use or geological maps give polygons with constant land use or geology, every point inside the polygon is of that class.
#' Some properties are spatially [extensive](https://en.wikipedia.org/wiki/Intensive_and_extensive_properties), meaning that attributes would summed up when two geometries are merged: population is an example. Other properties are spatially intensive, and should be averaged, with population density the example.
#' 
#' Simple feature objects of class `sf` have an _agr_ attribute that points to the _attribute-geometry-relationship_, how attributes relate to their geometry. It can be defined at creation time:
#' 
## ------------------------------------------------------------------------
nc <- st_read(system.file("shape/nc.shp", package="sf"),
    agr = c(AREA = "aggregate", PERIMETER = "aggregate", CNTY_ = "identity",
        CNTY_ID = "identity", NAME = "identity", FIPS = "identity", FIPSNO = "identity",
        CRESS_ID = "identity", BIR74 = "aggregate", SID74 = "aggregate", NWBIR74 = "aggregate",
        BIR79 = "aggregate", SID79 = "aggregate", NWBIR79 = "aggregate"))
st_agr(nc)
data(meuse, package = "sp")
meuse_sf <- st_as_sf(meuse, coords = c("x", "y"), crs = 28992, agr = "constant")
st_agr(meuse_sf)

#' 
#' When not specified, this field is filled with `NA` values, but if non-`NA`, it has one
#' of three possibilities
#' 
#' | value | meaning                           |
#' |-------| ----------------------------------|
#' | constant | a variable that has a constant value at every location over a spatial extent; examples: soil type, climate zone, land use |
#' | aggregate | values are summary values (aggregates) over the geometry, e.g. population density, dominant land use |
#' | identity | values identify the geometry: they refer to (the whole of) this and only this geometry |
#' 
#' With this information (still to be done) we can for instance
#' 
#' * either return missing values or generate warnings when a _aggregate_ value at a point location inside a polygon is retrieved, or
#' * list the implicit assumptions made when retrieving attribute values at points inside a polygon when `relation_to_geometry` is missing.
#' * decide what to do with attributes when a geometry is split: do nothing in case the attribute is constant, give an error or warning in case it is an aggregate, change the `relation_to_geometry` to _constant_ in case it was _identity_.
#' 
#' 
#' 
#' ### Simple feature geometries manipulation
#' Simple features can be manipulated including:
#' 
#' * type transformations (e.g., `POLYGON` to `MULTIPOLYGON`)
#' * affine transformation (shift, scale, rotate)
#' * transformation into a different coordinate reference system 
#' * geometrical operations, e.g. finding the centroid of a polygon, detecting whether pairs of feature geometries intersect, or find the union (overlap) of two polygons.
#' 
#' ## Coordinate reference systems conversion and transformation
#' 
#' ### Getting and setting coordinate reference systems of sf objects
#' 
#' The coordinate reference system of objects of class `sf` or `sfc` is
#' obtained by `st_crs`, and replaced by `st_crs<-`:
## ------------------------------------------------------------------------
geom = st_sfc(st_point(c(0,1)), st_point(c(11,12)))
s = st_sf(a = 15:16, geometry = geom)
st_crs(s)
s1 = s
st_crs(s1) <- 4326
st_crs(s1)
s2 = s
st_crs(s2) <- "+proj=longlat +datum=WGS84"
all.equal(s1, s2)

#' an alternative, more pipe-friendly version of `st_crs<-` is 
## ------------------------------------------------------------------------
s1 %>% st_set_crs(4326)

#' 
#' ### Coordinate reference system transformations
#' 
#' If we change the coordinate reference system from one non-missing
#' value into another non-missing value, the crs is is changed without
#' modifying any coordinates, but a warning is issued that this
#' did not reproject values:
## ------------------------------------------------------------------------
s3 <- s1 %>% st_set_crs(4326) %>% st_set_crs(3857)

#' A cleaner way to do this that better expresses intention and does
#' not generate this warning is to first wipe the CRS by assigning it 
#' a missing value, and then setting it to the intended value.
## ------------------------------------------------------------------------
s3 <- s1  %>% st_set_crs(NA) %>% st_set_crs(3857)

#' To carry out a coordinate conversion or transformation, we use
#' `st_transform`
## ------------------------------------------------------------------------
s3 <- s1 %>% st_transform(3857)
s3

#' for which we see that coordinates are actually modified (projected).
#' 
#' ## Geometrical operations
#' 
#' All geometrical operations `st_op(x)` or or `st_op2(x,y)` work
#' both for `sf` objects as well as `sfc` objects `x` and `y`; since
#' the operations work on the geometries, the non-geometries parts of
#' an `sf` object are simply discarded. Also, all binary operations
#' `st_op2(x,y)` called with a single argument, as `st_op2(x)`, are
#' handled as `st_op2(x,x)`.
#' 
#' We will illustrate the geometrical operations on a very simple dataset:
#' 
## ----figure=TRUE---------------------------------------------------------
b0 = st_polygon(list(rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))))
b1 = b0 + 2
b2 = b0 + c(-0.2, 2)
x = st_sfc(b0, b1, b2)
a0 = b0 * 0.8
a1 = a0 * 0.5 + c(2, 0.7)
a2 = a0 + 1
a3 = b0 * 0.5 + c(2, -0.5)
y = st_sfc(a0,a1,a2,a3)
plot(x, border = 'red')
plot(y, border = 'green', add = TRUE)

#' 
#' ### Unary operations
#' 
#' `st_is_valid` returns whether polygon geometries are topologically valid:
## ------------------------------------------------------------------------
b0 = st_polygon(list(rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))))
b1 = st_polygon(list(rbind(c(-1,-1), c(1,-1), c(1,1), c(0,-1), c(-1,-1))))
st_is_valid(st_sfc(b0,b1))

#' and `st_is_simple` whether line geometries are simple:
## ------------------------------------------------------------------------
s = st_sfc(st_linestring(rbind(c(0,0), c(1,1))), 
	st_linestring(rbind(c(0,0), c(1,1),c(0,1),c(1,0))))
st_is_simple(s)

#' 
#' `st_area` returns the area of polygon geometries, `st_length` the
#' length of line geometries:
## ------------------------------------------------------------------------
st_area(x)
st_area(st_sfc(st_point(c(0,0))))
st_length(st_sfc(st_linestring(rbind(c(0,0),c(1,1),c(1,2))), st_linestring(rbind(c(0,0),c(1,0)))))
st_length(st_sfc(st_multilinestring(list(rbind(c(0,0),c(1,1),c(1,2))),rbind(c(0,0),c(1,0))))) # ignores 2nd part!

#' 
#' ### Binary operations: distance and relate
#' `st_distance` computes the shortest distance matrix between geometries; this is
#' a dense matrix:
## ------------------------------------------------------------------------
st_distance(x,y)

#' `st_relate` returns a dense character matrix with the DE9-IM relationships
#' between each pair of geometries:
## ------------------------------------------------------------------------
st_relate(x,y)

#' element [i,j] of this matrix has nine characters, refering to relationship between x[i] and y[j], encoded as $I_xI_y,I_xB_y,I_xE_y,B_xI_y,B_xB_y,B_xE_y,E_xI_y,E_xB_y,E_xE_y$ where $I$ refers to interior, $B$ to boundary, and $E$ to exterior, and e.g. $B_xI_y$ the dimensionality of the intersection of the the boundary $B_x$ of x[i] and the interior $I_y$ of y[j], which is one of {0,1,2,F}, indicating zero-, one-, two-dimension intersection, and (F) no intersection, respectively.
#' 
#' ![DE9-IM](04_assets/DE9-IM.png)
#' Reading from left-to-right and top-to-bottom, the DE-9IM(a,b) string code is '212101212', the compact representation of $I_xI_y=2,I_xB_y=1,I_xE_y=2,B_xI_y=1,B_xB_y=0,B_xE_y=1,E_xI_y=2,E_xB_y=1,E_xE_y=2$. Figure from [here](https://en.wikipedia.org/wiki/DE-9IM#Illustration).
#' 
#' ### Binary logical operations: 
#' Binary logical operations return either a sparse matrix
## ------------------------------------------------------------------------
st_intersects(x,y)

#' or a dense matrix
## ------------------------------------------------------------------------
st_intersects(x, x, sparse = FALSE)
st_intersects(x, y, sparse = FALSE)

#' where list element `i` of a sparse matrix contains the indices of
#' the `TRUE` elements in row `i` of the the dense matrix. For large
#' geometry sets, dense matrices take up a lot of memory and are
#' mostly filled with `FALSE` values, hence the default is to return
#' a sparse matrix.
#' 
#' `st_intersects` returns for every geometry pair whether they
#' intersect (dense matrix), or which elements intersect (sparse).
#' 
#' Other binary predicates include (using sparse for readability):
#' 
## ------------------------------------------------------------------------
st_disjoint(x, y, sparse = FALSE)
st_touches(x, y, sparse = FALSE)
st_crosses(s, s, sparse = FALSE)
st_within(x, y, sparse = FALSE)
st_contains(x, y, sparse = FALSE)
st_overlaps(x, y, sparse = FALSE)
st_equals(x, y, sparse = FALSE)
st_covers(x, y, sparse = FALSE)
st_covered_by(x, y, sparse = FALSE)
st_covered_by(y, y, sparse = FALSE)
st_equals_exact(x, y,0.001, sparse = FALSE)

#' 
#' ### Operations returning a geometry
#' 
## ---- fig=TRUE-----------------------------------------------------------
u = st_union(x)
plot(u)

#' 
## ---- fig=TRUE-----------------------------------------------------------
par(mfrow=c(1,2), mar = rep(0,4))
plot(st_buffer(u, 0.2))
plot(u, border = 'red', add = TRUE)
plot(st_buffer(u, 0.2), border = 'grey')
plot(u, border = 'red', add = TRUE)
plot(st_buffer(u, -0.2), add = TRUE)

#' 
## ------------------------------------------------------------------------
plot(st_boundary(x))

#' 
## ------------------------------------------------------------------------
par(mfrow = c(1:2))
plot(st_convex_hull(x))
plot(st_convex_hull(u))
par(mfrow = c(1,1))

#' 
## ---- fig=TRUE-----------------------------------------------------------
par(mfrow=c(1,2))
plot(x)
plot(st_centroid(x), add = TRUE, col = 'red')
plot(x)
plot(st_centroid(u), add = TRUE, col = 'red')

#' 
#' The intersection of two geometries is the geometry covered by both; it is obtained by `st_intersection`:
## ---- fig=TRUE-----------------------------------------------------------
plot(x)
plot(y, add = TRUE)
plot(st_intersection(st_union(x),st_union(y)), add = TRUE, col = 'red')

#' 
#' To get _everything but_ the intersection, use `st_difference` or st_sym_difference`:
## ----fig=TRUE------------------------------------------------------------
par(mfrow=c(2,2), mar = c(0,0,1,0))
plot(x, col = '#ff333388'); 
plot(y, add=TRUE, col='#33ff3388')
title("x: red, y: green")
plot(x, border = 'grey')
plot(st_difference(st_union(x),st_union(y)), col = 'lightblue', add = TRUE)
title("difference(x,y)")
plot(x, border = 'grey')
plot(st_difference(st_union(y),st_union(x)), col = 'lightblue', add = TRUE)
title("difference(y,x)")
plot(x, border = 'grey')
plot(st_sym_difference(st_union(y),st_union(x)), col = 'lightblue', add = TRUE)
title("sym_difference(x,y)")

#' 
#' Function `st_segmentize` adds points to straight line sections of a lines or polygon object:
## ----fig=TRUE------------------------------------------------------------
par(mfrow=c(1,3),mar=c(1,1,0,0))
pts = rbind(c(0,0),c(1,0),c(2,1),c(3,1))
ls = st_linestring(pts)
plot(ls)
points(pts)
ls.seg = st_segmentize(ls, 0.3)
plot(ls.seg)
pts = ls.seg
points(pts)
pol = st_polygon(list(rbind(c(0,0),c(1,0),c(1,1),c(0,1),c(0,0))))
pol.seg = st_segmentize(pol, 0.3)
plot(pol.seg, col = 'grey')
points(pol.seg[[1]])

#' 
#' Function `st_polygonize` polygonizes a multilinestring, as far as the points form a closed polygon:
## ----fig=TRUE------------------------------------------------------------
par(mfrow=c(1,2),mar=c(0,0,1,0))
mls = st_multilinestring(list(matrix(c(0,0,0,1,1,1,0,0),,2,byrow=TRUE)))
x = st_polygonize(mls)
plot(mls, col = 'grey')
title("multilinestring")
plot(x, col = 'grey')
title("polygon")

#' 
#' Further reading:
#' 
#' 1. S. Scheider, B. Gräler, E. Pebesma, C. Stasch, 2016. Modelling spatio-temporal information generation. Int J of Geographic Information Science, 30 (10), 1980-2008. ([pdf](http://pebesma.staff.ifgi.de/generativealgebra.pdf))
#' 2. Stasch, C., S. Scheider, E. Pebesma, W. Kuhn, 2014. Meaningful Spatial Prediction and Aggregation. Environmental Modelling & Software, 51, (149–165, [open access](http://dx.doi.org/10.1016/j.envsoft.2013.09.006)).
