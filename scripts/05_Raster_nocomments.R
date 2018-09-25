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
getData("ISO3")%>%
  as.data.frame%>%
  filter(NAME=="South Africa")
## za=getData('GADM', country='ZAF', level=1)
data(southAfrica)
za=southAfrica # rename for convenience
## plot(za)
za %>% gSimplify(0.01) %>% plot()
za@data
subset(za,NAME_1=="Western Cape") %>% gSimplify(0.01) %>%
  plot()
x <- raster()
x
str(x)
x <- raster(ncol=36, nrow=18, xmn=-1000, xmx=1000, ymn=-100, ymx=900)
res(x)
res(x) <- 100
res(x)
ncol(x)
# change the numer of columns (affects resolution)
ncol(x) <- 18
ncol(x)
res(x)
r <- raster(ncol=10, nrow=10)
ncell(r)
hasValues(r)
values(r) <- 1:ncell(r)
hasValues(r)
values(r)[1:10]
inMemory(r)
plot(r, main='Raster with 100 cells')
gplot(r,maxpixels=50000)+
  geom_raster(aes(fill=value))
gplot(r,maxpixels=10)+
  geom_raster(aes(fill=value))
gplot(r)+geom_raster(aes(fill=value))+
    scale_fill_distiller(palette="OrRd")
projection(r)
r2=projectRaster(r,crs="+proj=sinu +lon_0=0",method = "ngb")

par(mfrow=c(1,2));plot(r);plot(r2)

## clim=raster::getData('worldclim', var='bio', res=10)
data(worldclim)

#rename for convenience
clim=worldclim
clim
gain(clim)=c(rep(0.1,11),rep(1,7))
plot(clim)
gplot(clim[[13:19]])+geom_raster(aes(fill=value))+
  facet_wrap(~variable)+
  scale_fill_gradientn(colours=c("brown","red","yellow","darkgreen","green"),trans="log10")+
  coord_equal()
## is it held in RAM?
inMemory(clim)
## How big is it?
object.size(clim)

## can we work with it directly in RAM?
canProcessInMemory(clim)
## crop to a latitude/longitude box
r1 <- raster::crop(clim[[1]], extent(10,35,-35,-20))
## Crop using a Spatial polygon
r1 <- raster::crop(clim[[1]], bbox(za))
r1
plot(r1)
## aggregate using a function
aggregate(r1, 3, fun=mean) %>%
  plot()
## apply a function over a moving window
focal(r1, w=matrix(1,3,3), fun=mean) %>% 
  plot()
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
cellStats(r1,range)

## add 10
s = r1 + 10
cellStats(s,range)
## take the square root
s = sqrt(r1)
cellStats(s,range)

# round values
r = round(r1)
cellStats(r,range)

# find cells with values less than 15 degrees C
r = r1 < 15
plot(r)
# multiply s times r and add 5
s = s * r1 + 5
cellStats(s,range)
## define a new dataset of points to play with
pts=sampleRandom(clim,100,xy=T,sp=T)
plot(pts);axis(1);axis(2)
pts_data=raster::extract(clim[[1:4]],pts,df=T)
head(pts_data)
gplot(clim[[1]])+
  geom_raster(aes(fill=value))+
  geom_point(
    data=as.data.frame(pts),
    aes(x=x,y=y),col="red")+
  coord_equal()
d2=pts_data%>%
  gather(ID)
colnames(d2)[1]="cell"
head(d2)
ggplot(d2,aes(x=value))+
  geom_density()+
  facet_wrap(~cell,scales="free")
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
trans=raster::extract(x=clim[[12:14]],
                      y=transect,
                      along=T,
                      cellnumbers=T)%>%
  data.frame()
head(trans)
trans[,c("lon","lat")]=coordinates(clim)[trans$cell]
trans$order=as.integer(rownames(trans))
head(trans)  
transl=group_by(trans,lon,lat)%>%
  gather(variable, value, -lon, -lat, -cell, -order)
head(transl)
ggplot(transl,aes(x=lon,y=value,
                  colour=variable,
                  group=variable,
                  order=order))+
  geom_line()
rsp=raster::extract(x=r1,
                    y=gSimplify(za,0.01),
                    fun=mean,
                    sp=T)
#spplot(rsp,zcol="bio1")
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

country=getData('GADM', country='TUN', level=1)%>%gSimplify(0.01)
tmax=getData('worldclim', var='tmax', res=10)
gain(tmax)=0.1
names(tmax)
sort(names(tmax))

## Options
month.name
month.abb
sprintf("%02d",1:12)
sprintf("%04d",1:12)
names(tmax)=sprintf("%02d",1:12)

tmax_crop=crop(tmax,country)
tmaxave_crop=mean(tmax_crop)  # calculate mean annual maximum temperature 
tmaxavefocal_crop=focal(tmaxave_crop,
                        fun=median,
                        w=matrix(1,11,11))
cellStats(tmax_crop,"quantile")
transect=SpatialLinesDataFrame(
  readWKT("LINESTRING(8 36,10 36)"),
  data.frame(Z = c("T1")))
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
trans=raster::extract(tmax_crop,
                      transect,
                      along=T,
                      cellnumbers=T)%>% 
  as.data.frame()
trans[,c("lon","lat")]=coordinates(tmax_crop)[trans$cell]
trans$order=as.integer(rownames(trans))
head(trans)
  
transl=group_by(trans,lon,lat)%>%
  gather(variable, value, -lon, -lat, -cell, -order)%>%
  separate(variable,into = c("X","month"),1)%>%
  mutate(month=as.numeric(month),monthname=factor(month.name[month],ordered=T,levels=month.name))
head(transl)
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
ggplot(transl,
       aes(x=lon,y=monthname,
           fill=value))+
  ylab("Month")+
    scale_fill_distiller(
      palette="PuBuGn",
      name="Tmax")+
    geom_raster()
