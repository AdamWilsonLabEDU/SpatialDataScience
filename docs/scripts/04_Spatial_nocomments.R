library(sp)
library(rgdal)
library(ggplot2)
library(dplyr)
library(tidyr)
library(maptools)
coords = data.frame(
  x=rnorm(100),
  y=rnorm(100)
)
str(coords)
plot(coords)
sp = SpatialPoints(coords)
str(sp)
data=data.frame(ID=1:100,group=letters[1:20])
head(data)
spdf = SpatialPointsDataFrame(coords, data)
spdf = SpatialPointsDataFrame(sp, data)

str(spdf)
coordinates(data) = cbind(coords$x, coords$y) 
str(spdf)
subset(spdf, group=="a")
spdf[spdf$group=="a",]
df=data.frame(
  lat=c(12,15,17,12),
  lon=c(-35,-35,-32,-32),
  id=c(1,2,3,4))
## Load the data
data(meuse)
str(meuse)
  ggplot(as.data.frame(meuse),aes(x=x,y=y))+
    geom_point(col="red")+
    coord_equal()
L1 = Line(cbind(rnorm(5),rnorm(5)))
L2 = Line(cbind(rnorm(5),rnorm(5)))
L3 = Line(cbind(rnorm(5),rnorm(5)))
L1
plot(coordinates(L1),type="l")
Ls1 = Lines(list(L1),ID="a")
Ls2 = Lines(list(L2,L3),ID="b")
Ls2
SL12 = SpatialLines(list(Ls1,Ls2))
plot(SL12)
SLDF = SpatialLinesDataFrame(
  SL12,
  data.frame(
  Z=c("road","river"),
  row.names=c("a","b")
))
str(SLDF)
knitr::kable(ogrDrivers())
## get the file path to the files
file=system.file("shapes/sids.shp", package="maptools")
## get information before importing the data
ogrInfo(dsn=file, layer="sids")

## Import the data
sids <- readOGR(dsn=file, layer="sids")
summary(sids)
plot(sids)
sids <- readShapeSpatial(file)
proj4string(sids) <- CRS("+proj=longlat +ellps=clrk66")
proj4string(sids)
sids_us = spTransform(sids,CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
bbox(sids)
bbox(sids_us)
# Geographic
ggplot(fortify(sids),aes(x=long,y=lat,order=order,group=group))+
  geom_polygon(fill="white",col="black")+
  coord_equal()
# Equal Area
ggplot(fortify(sids_us),aes(x=long,y=lat,order=order,group=group))+
  geom_polygon(fill="white",col="black")+
  coord_equal()+
  ylab("Northing")+xlab("Easting")
library(rgeos)
p = readWKT(paste("POLYGON((0 40,10 50,0 60,40 60,40 100,50 90,60 100,60",
 "60,100 60,90 50,100 40,60 40,60 0,50 10,40 0,40 40,0 40))"))
l = readWKT("LINESTRING(0 7,1 6,2 1,3 4,4 1,5 7,6 6,7 4,8 6,9 4)")
par(mfrow=c(1,4))  # this sets up a 1x4 grid for the plots
plot(l);title("Original")
plot(gSimplify(l,tol=3));title("tol: 3")
plot(gSimplify(l,tol=5));title("tol: 5")
plot(gSimplify(l,tol=7));title("tol: 7")
par(mfrow=c(1,4))  # this sets up a 1x4 grid for the plots
plot(p);title("Original")
plot(gSimplify(p,tol=10));title("tol: 10")
plot(gSimplify(p,tol=20));title("tol: 20")
plot(gSimplify(p,tol=25));title("tol: 25")
file = system.file("shapes/sids.shp", package="maptools")
sids = readOGR(dsn=file, layer="sids")
sids2=gSimplify(sids,tol = 0.2,topologyPreserve=T)
sids%>%
  fortify()%>%
  head()
ggplot(fortify(sids),aes(x=long,y=lat,order=order, group=group))+
  geom_polygon(lwd=2,fill="grey",col="blue")+
  coord_map()
ggplot(fortify(sids),aes(x=long,y=lat,order=order, group=group))+
  geom_polygon(lwd=2,fill="grey",col="blue")+
  geom_polygon(data=fortify(sids2),col="red",fill=NA)+
  coord_map()
sids$area=gArea(sids,byid = T)
## add the ID to the dataframe itself for easier indexing
sids$id=as.numeric(rownames(sids@data))
## create fortified version for plotting with ggplot()
fsids=fortify(sids,region="id")

ggplot(sids@data, aes(map_id = id)) +
    expand_limits(x = fsids$long, y = fsids$lat)+
    scale_fill_gradientn(colours = c("grey","goldenrod","darkgreen","green"))+
    coord_map()+
    geom_map(aes(fill = area), map = fsids)
sids_all=gUnionCascaded(sids)
ggplot(fortify(sids_all),aes(x=long,y=lat,group=group,order=order))+
  geom_path()+
  coord_map()
