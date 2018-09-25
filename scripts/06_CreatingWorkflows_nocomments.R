library(knitr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(raster)
library(rasterVis)
library(scales)
library(rgeos)

# load data for this course
# devtools::install_github("adammwilson/DataScienceData")
library(DataScienceData)

getData("ISO3")%>%
  as.data.frame%>%
  filter(NAME=="Bangladesh")
datadir="~/Downloads/data"
if(!file.exists(datadir)) dir.create(datadir, recursive=T)
## bgd=getData('GADM', country='BGD', level=0,path = datadir)
data(bangladesh)
bgd=bangladesh
bgd%>%
  gSimplify(0.01)%>%
  plot()
## bgdc=gCentroid(bgd)%>%coordinates()
## 
## dem1=getData("SRTM",lat=bgdc[2],lon=bgdc[1],path=datadir)
## dem2=getData("SRTM",lat=23.7,lon=85,path=datadir)
## dem=merge(dem1,dem2)
data(bangladesh_dem)
dem=bangladesh_dem # rename for convenience
plot(dem)
bgd%>%
  gSimplify(0.01)%>%
  plot(add=T)
inMemory(dem)
dem@file@name
file.size(sub("grd","gri",dem@file@name))*1e-6
showTmpFiles()
rasterOptions()
## dem=merge(dem1,dem2,filename=file.path(datadir,"dem.tif"),overwrite=T)
## writeRaster(dem, filename = file.path(datadir,"dem.tif"))
# crop to a lat-lon box
dem=crop(dem,extent(90,91,21.5,24),filename=file.path(datadir,"dem_bgd.tif"),overwrite=T)

plot(dem)
bgd%>%
  gSimplify(0.01)%>%
  plot(add=T)
gplot(dem,max=1e5)+
  geom_tile(aes(fill=value))+
  scale_fill_gradientn(
    colours=c("red","yellow","grey30","grey20","grey10"),
    trans="log1p",breaks= log_breaks(n = 5, base = 10)(c(1, 1e3)))+
  coord_equal(ylim=c(21.5,24),xlim=c(90,91))+
  geom_path(data=fortify(bgd),
            aes(x=long,y=lat,group=group),size=.5)
reg1=crop(dem,extent(90.6,90.7,23.25,23.4))
plot(reg1)
slope=terrain(reg1,opt="slope",unit="degrees")
plot(slope)
aspect=terrain(reg1,opt="aspect",unit="degrees")
plot(aspect)
tpi=terrain(reg1,opt="TPI")

gplot(tpi,max=1e6)+geom_tile(aes(fill=value))+
  scale_fill_gradient2(low="blue",high="red",midpoint=0)+
  coord_equal()
tri=terrain(reg1,opt="TRI")
plot(tri)
rough=terrain(reg1,opt="roughness")
plot(rough)
hs=hillShade(slope*pi/180,aspect*pi/180)

plot(hs, col=grey(0:100/100), legend=FALSE)
plot(reg1, col=terrain.colors(25, alpha=0.5), add=TRUE)
flowdir=terrain(reg1,opt="flowdir")

plot(flowdir)
slr=data.frame(year=2100,
               scenario=c("RCP2.6","RCP4.5","RCP6.0","RCP8.5"),
               low=c(0.26,0.32,0.33,0.53),
               high=c(0.54,0.62,0.62,0.97))
slr
ss=c(2.5,10)
area=raster::area(dem)
plot(area)
rcl=matrix(c(-Inf,2.76,1,
           2.76,10.97,2,
           10.97,Inf,3),byrow=T,ncol=3)
rcl
regclass=reclassify(dem,rcl)

gplot(regclass,max=1e5)+
  geom_tile(aes(fill=as.factor(value)))+
  scale_fill_manual(values=c("red","orange","blue"),
                    name="Flood Class")+
  coord_equal()
gplot(dem,max=1e5)+
  geom_tile(aes(fill=cut(value,c(-Inf,2.76,10.97,Inf))))+
  scale_fill_manual(values=c("red","orange","blue"),
                    name="Flood Class")+
  coord_equal()
## pop_global=raster(file.path(datadir,"gpw-v4-population-density-2015/gpw-v4-population-density_2015.tif"))
data(bangladesh_population)
## tf=tempfile()
## download.file("https://github.com/adammwilson/DataScienceData/raw/master/data/bangladesh_population.rda",destfile = tf)
## load(tf)
## make a virtual copy with a shorter name for convenience

pop=bangladesh_population
gplot(pop,max=1e5)+geom_tile(aes(fill=value))+
  scale_fill_gradientn(colours=c("grey90","grey60","darkblue","blue","red"),
                       trans="log1p",breaks= log_breaks(n = 5, base = 10)(c(1, 1e5)))+
  coord_equal()
pop
dem

res(pop)
res(dem)

origin(pop)
origin(dem)

# Look at average cell area in km^2 
cellStats(raster::area(pop),"mean")
cellStats(raster::area(dem),"mean")
pop_fine=pop%>%
  resample(dem,method="bilinear")

gplot(pop_fine,max=1e5)+geom_tile(aes(fill=value))+
  scale_fill_gradientn(
    colours=c("grey90","grey60","darkblue","blue","red"),
    trans="log1p",breaks= log_breaks(n = 5, base = 10)(c(1, 1e5)))+
  coord_equal()

res(pop)/res(dem)
dem_coarse=dem%>%
  aggregate(fact=10,fun=min,expand=T)%>%
  resample(pop,method="bilinear")
popcenter=pop>5000
popcenter=mask(popcenter,popcenter,maskvalue=0)
plot(popcenter,col="red",legend=F)
popcenterdist=distance(popcenter)
plot(popcenterdist)
vpop=rasterToPolygons(popcenter, dissolve=TRUE)

gplot(dem,max=1e5)+geom_tile(aes(fill=value))+
  scale_fill_gradientn(
    colours=c("red","yellow","grey30","grey20","grey10"),
    trans="log1p",breaks= log_breaks(n = 5, base = 10)(c(1, 1e3)))+
  coord_cartesian(ylim=c(21.5,24),xlim=c(90,91))+
  geom_path(data=fortify(bgd),aes(x=long,y=lat,group=group),size=.5)+
  geom_path(data=fortify(vpop),aes(x=long,y=lat,group=group),size=1,col="green")

## plot3D(dem)
## decorate3d()
## plot3D(dem,drape=pop, zfac=0.2)
## decorate3d()
