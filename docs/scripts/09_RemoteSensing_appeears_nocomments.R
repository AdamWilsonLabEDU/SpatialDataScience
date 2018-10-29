library(raster)
library(rasterVis)
library(rgdal)
library(ggplot2)
library(ggmap)
library(tidyverse)

library(DataScienceData)

# New Packages
library(gdalUtils)
library(rts)
library(ncdf4)
lulcf=system.file("extdata", 
                "appeears/MCD12Q1.051_aid0001.nc", 
                package = "DataScienceData")
lulcf
lulc=stack(lulcf,varname="Land_Cover_Type_1")
plot(lulc)
lulc=lulc[[13]]
plot(lulc)
  Land_Cover_Type_1 = c(
    Water = 0, 
    `Evergreen Needleleaf forest` = 1, 
    `Evergreen Broadleaf forest` = 2,
    `Deciduous Needleleaf forest` = 3, 
    `Deciduous Broadleaf forest` = 4,
    `Mixed forest` = 5, 
    `Closed shrublands` = 6,
    `Open shrublands` = 7,
    `Woody savannas` = 8, 
    Savannas = 9,
    Grasslands = 10,
    `Permanent wetlands` = 11, 
    Croplands = 12,
    `Urban & built-up` = 13,
    `Cropland/Natural vegetation mosaic` = 14, 
    `Snow & ice` = 15,
    `Barren/Sparsely vegetated` = 16, 
    Unclassified = 254,
    NoDataFill = 255)

lcd=data.frame(
  ID=Land_Cover_Type_1,
  landcover=names(Land_Cover_Type_1),
  col=c("#000080","#008000","#00FF00", "#99CC00","#99FF99", "#339966", "#993366", "#FFCC99", "#CCFFCC", "#FFCC00", "#FF9900", "#006699", "#FFFF00", "#FF0000", "#999966", "#FFFFFF", "#808080", "#000000", "#000000"),
  stringsAsFactors = F)
# colors from https://lpdaac.usgs.gov/about/news_archive/modisterra_land_cover_types_yearly_l3_global_005deg_cmg_mod12c1
kable(head(lcd))
# convert to raster (easy)
lulc=as.factor(lulc)

# update the RAT with a left join
levels(lulc)=left_join(levels(lulc)[[1]],lcd)

# plot it
gplot(lulc)+
  geom_raster(aes(fill=as.factor(value)))+
  scale_fill_manual(values=levels(lulc)[[1]]$col,
                    labels=levels(lulc)[[1]]$landcover,
                    name="Landcover Type")+
  coord_equal()+
  theme(legend.position = "bottom")+
  guides(fill=guide_legend(ncol=1,byrow=TRUE))
lstf=system.file("extdata", 
                "appeears/MOD11A2.006_aid0001.nc", 
                package = "DataScienceData")
lstf
lst=stack(lstf,varname="LST_Day_1km")
plot(lst[[1:12]])
offs(lst)=-273.15
plot(lst[[1:10]])
lstqc=stack(lstf,varname="QC_Day")
plot(lstqc[[1:2]])
values(lstqc[[1:2]])%>%table()
intToBits(65)
intToBits(65)[1:8]

as.integer(intToBits(65)[1:8])
rev(as.integer(intToBits(65)[1:8]))
## set up data frame to hold all combinations
QC_Data <- data.frame(Integer_Value = 0:255,
Bit7 = NA, Bit6 = NA, Bit5 = NA, Bit4 = NA,
Bit3 = NA, Bit2 = NA, Bit1 = NA, Bit0 = NA,
QA_word1 = NA, QA_word2 = NA, QA_word3 = NA,
QA_word4 = NA)

## 
for(i in QC_Data$Integer_Value){
AsInt <- as.integer(intToBits(i)[1:8])
QC_Data[i+1,2:9]<- AsInt[8:1]
}

QC_Data$QA_word1[QC_Data$Bit1 == 0 & QC_Data$Bit0==0] <- "LST GOOD"
QC_Data$QA_word1[QC_Data$Bit1 == 0 & QC_Data$Bit0==1] <- "LST Produced,Other Quality"
QC_Data$QA_word1[QC_Data$Bit1 == 1 & QC_Data$Bit0==0] <- "No Pixel,clouds"
QC_Data$QA_word1[QC_Data$Bit1 == 1 & QC_Data$Bit0==1] <- "No Pixel, Other QA"

QC_Data$QA_word2[QC_Data$Bit3 == 0 & QC_Data$Bit2==0] <- "Good Data"
QC_Data$QA_word2[QC_Data$Bit3 == 0 & QC_Data$Bit2==1] <- "Other Quality"
QC_Data$QA_word2[QC_Data$Bit3 == 1 & QC_Data$Bit2==0] <- "TBD"
QC_Data$QA_word2[QC_Data$Bit3 == 1 & QC_Data$Bit2==1] <- "TBD"

QC_Data$QA_word3[QC_Data$Bit5 == 0 & QC_Data$Bit4==0] <- "Emiss Error <= .01"
QC_Data$QA_word3[QC_Data$Bit5 == 0 & QC_Data$Bit4==1] <- "Emiss Err >.01 <=.02"
QC_Data$QA_word3[QC_Data$Bit5 == 1 & QC_Data$Bit4==0] <- "Emiss Err >.02 <=.04"
QC_Data$QA_word3[QC_Data$Bit5 == 1 & QC_Data$Bit4==1] <- "Emiss Err > .04"

QC_Data$QA_word4[QC_Data$Bit7 == 0 & QC_Data$Bit6==0] <- "LST Err <= 1"
QC_Data$QA_word4[QC_Data$Bit7 == 0 & QC_Data$Bit6==1] <- "LST Err > 2 LST Err <= 3"
QC_Data$QA_word4[QC_Data$Bit7 == 1 & QC_Data$Bit6==0] <- "LST Err > 1 LST Err <= 2"
QC_Data$QA_word4[QC_Data$Bit7 == 1 & QC_Data$Bit6==1] <- "LST Err > 4"
kable(head(QC_Data))
keep=QC_Data[QC_Data$Bit1 == 0,]
keepvals=unique(keep$Integer_Value)
keepvals

qcvals=table(values(lstqc))  # this takes a minute or two


QC_Data%>%
  dplyr::select(everything(),-contains("Bit"))%>%
  mutate(Var1=as.character(Integer_Value),
         keep=Integer_Value%in%keepvals)%>%
  inner_join(data.frame(qcvals))%>%
  kable()
lstkeep=calc(lstqc,function(x) x%in%keepvals)
gplot(lstkeep[[4:8]])+
  geom_raster(aes(fill=as.factor(value)))+
  facet_grid(variable~.)+
  scale_fill_manual(values=c("blue","red"),name="Keep")+
  coord_equal()+
  theme(legend.position = "bottom")
lst2=mask(lst,mask=lstkeep,maskval=0)


tdates=names(lst)%>%
  sub(pattern="X",replacement="")%>%
  as.Date("%Y.%m.%d")

names(lst2)=1:nlayers(lst2)
lst2=setZ(lst2,tdates)

tseas=as.numeric(sub("Q","",quarters(getZ(lst2))))
tseas[1:20]

lst_seas=stackApply(lst2,
                    indices = tseas,
                    mean,na.rm=T)
names(lst_seas)=c("Q1_Winter",
                  "Q2_Spring",
                  "Q3_Summer",
                  "Q4_Fall")
gplot(lst_seas)+geom_raster(aes(fill=value))+
  facet_wrap(~variable)+
  scale_fill_gradientn(colours=c("blue",mid="grey","red"))+
  coord_equal()+
  theme(axis.text.x=element_text(angle=60, hjust=1))
lw=SpatialPoints(
  data.frame(
    x= -78.791547,
    y=43.007211))

projection(lw)="+proj=longlat"

lw=spTransform(lw,projection(lst2))

lwt=data.frame(date=getZ(lst2),
                 lst=t(raster::extract(
                   lst2,lw,
                   buffer=1000,
                   fun=mean,na.rm=T)))

ggplot(lwt,aes(x=date,y=lst))+
  geom_path()
lulc2=resample(lulc,
             lst,
             method="ngb")

par(mfrow=c(1,2)) 
plot(lulc)
plot(lulc2)
par(mfrow=c(1,1))
table(values(lulc))
lcds1=cbind.data.frame(
  values(lst_seas),
  ID=values(lulc2[[1]]))%>%
  na.omit()
head(lcds1)
lcds2=lcds1%>%
  gather(key="season", value = "value", -ID)%>%
  mutate(ID=as.numeric(ID))%>%
  left_join(lcd)
head(lcds2)
ggplot(lcds2,aes(y=value,x=landcover,group=landcover))+
  facet_wrap(~season)+
  geom_point(alpha=.5,position="jitter")+
  geom_violin(alpha=.5,col="red",scale = "width")+
  theme(axis.text.x=element_text(angle=90, hjust=1))
lct.mean=raster::zonal(lst_seas,
               lulc2,
               'mean',na.rm=T)%>%
  data.frame()

lct.sd=zonal(lst_seas,
             lulc2,
             'sd',na.rm=T)%>%
  data.frame()

lct.count=zonal(lst_seas,
                lulc2,
                'count',na.rm=T)%>%
  data.frame()

lct.summary=rbind(data.frame(lct.mean,var="mean"),
                  data.frame(lct.sd,var="sd"),
                  data.frame(lct.count,var="count"))
lctl=gather(lct.summary, key="season", value="value", -var, -zone)

lctl$season=factor(lctl$season,
                   labels=c("Winter","Spring","Summer","Fall"),
                   ordered=T)
lctl$zone=names(Land_Cover_Type_1)[lctl$zone+1]
lctl=spread(lctl,var,value="value")
head(lctl)%>%kable()
filter(lctl,count>=100)%>%
  mutate(txt=paste0(round(mean,2),
                    " (±",round(sd,2),")"))%>%
  dplyr::select(zone,count,txt,season)%>%
  spread(season, txt)%>%
  kable()
