#' ---
#' title: "Working With MODIS data"
#' ---
#' 
#' 
#' <div>
#' <iframe src="09_presentation/09_RemoteSensing.html" width="75%" height="300px"> </iframe>
#' </div>
#' 
#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
#' 
#' ### Libraries
#' 
## ----results='hide',message=FALSE----------------------------------------
library(raster)
library(rasterVis)
library(rgdal)
library(sp)
library(ggplot2)
library(ggmap)
library(dplyr)
library(reshape2)
library(knitr)
library(tidyr)

# New Packages
library(MODISTools)
library(gdalUtils)
library(rts)

#' 
#' 
#' ## Specify directory to store data (absolute or relative to current working directory). 
## ------------------------------------------------------------------------
download.file("http://adamwilson.us/RDataScience/09_data.zip",
              destfile=file.path("09_data.zip"))
datadir="09_data"
unzip("09_data.zip",exdir = datadir)

#' 
#' 
#' ## Working with _raw_ HDF files 
#' 
#' Will only work if your `gdal` was compiled with HDF support
## ---- eval=T-------------------------------------------------------------
gdalinfo(formats = T) %>% grep(pattern="HDF",value=T)

#' 
## ------------------------------------------------------------------------
hdf=file.path(datadir,"MCD12Q1.A2012001.h12v04.051.2014288200441_subset.hdf")
gdalinfo(hdf)

#' More information available with `nomd=F`.
#' 
#' ### Subdatasets
#' 
#' * SUBDATASET_1_NAME=HDF4_EOS:EOS_GRID:\"09_data/MCD12Q1.A2012001.h12v04.051.2014288200441_subset.hdf\":MOD12Q1:Land_Cover_Type_1
#' * SUBDATASET_1_DESC=[2400x2400] Land_Cover_Type_1 MOD12Q1 (8-bit unsigned integer)                         SUBDATASET_2_NAME=HDF4_EOS:EOS_GRID:\"09_data/MCD12Q1.A2012001.h12v04.051.2014288200441_subset.hdf\":MOD12Q1:Land_Cover_Type_1_Assessment
#' * SUBDATASET_2_DESC=[2400x2400] Land_Cover_Type_1_Assessment MOD12Q1 (8-bit unsigned integer)
#' * SUBDATASET_3_NAME=HDF4_EOS:EOS_GRID:\"09_data/MCD12Q1.A2012001.h12v04.051.2014288200441_subset.hdf\":MOD12Q1:Land_Cover_Type_QC.Num_QC_Words_01
#' * SUBDATASET_3_DESC=[2400x2400] Land_Cover_Type_QC.Num_QC_Words_01 MOD12Q1 (8-bit unsigned integer)
#' 
#' #### Translate to GEOtif
## ---- eval=F-------------------------------------------------------------
## gdal_translate("HDF4_EOS:EOS_GRID:\"09_data/MCD12Q1.A2012001.h12v04.051.2014288200441_subset.hdf\":MOD12Q1:Land_Cover_Type_1",
##                "test.tif")
## gdalinfo("test.tif",nomd=T)

#' 
#' #### Plot it
#' 
## ------------------------------------------------------------------------
d=raster("test.tif")
plot(d)

#' 
#' See also the `ModisDownload()` function in `library(rts)`:
#' 
#' * Downloads series of MODIS images in a specific timeframe for specified tile(s)
#' * MODIS Reproject Tool (MRT) software to mosaic, reproject, reformat
#' 
#' # Use MODISTools package to access the MODISweb
#' 
#' ##  List MODIS products
## ------------------------------------------------------------------------
GetProducts()

#' 
## ------------------------------------------------------------------------
GetBands(Product = "MCD12Q1")

#' 
#' ## Selection locations
#' 
## ------------------------------------------------------------------------
loc=rbind.data.frame(
  list("UB Spine",43.000753, -78.788195))
colnames(loc)=c("loc","lat","long")
coordinates(loc)=cbind(loc$long,loc$lat)

#' 
#' ## Available dates
## ------------------------------------------------------------------------
mdates=GetDates(Product = "MOD11A2", Lat = loc$lat[1], Long = loc$long[1])

#' 
#' ### MODIS date codes:
#' 
#' `.A2006001` - Julian Date of Acquisition (A-YYYYDDD)
#' 
#' Convert to a _proper_ date:
#' 
#' * Drop the "`A`"
#' * Specify date format with julian day `[1,365]`
#' 
## ------------------------------------------------------------------------
td=mdates[1:5]
td

#' 
#' `sub()` to _substitute_ a character in a `vector()`
## ------------------------------------------------------------------------
sub("A","",td)

#' 
#' Check `?strptime` for date formats.
#' 
#' * `%Y` 4-digit year
#' * `%j` 3-digit Julian day
#' 
## ------------------------------------------------------------------------
sub("A","",td)%>%
  as.Date("%Y%j")

#' 
#' ## Add start and end dates to `loc` object
#' 
## ------------------------------------------------------------------------
dates=mdates%>%sub(pattern="A",replacement="")%>%as.Date("%Y%j")

loc$start.date <- min(as.numeric(format(dates,"%Y")))
loc$end.date <- max(as.numeric(format(dates,"%Y")))


#' 
#' ## Identify (and create) download folders
#' 
#' Today we'll work with:
#' 
#' * Land Surface Temperature (`lst`): MOD11A2
#' * Land Cover (`lc`): MCD12Q1
#' 
## ------------------------------------------------------------------------
lstdir=file.path(datadir,"lst")
if(!file.exists(lstdir)) dir.create(lstdir)

lcdir=file.path(datadir,"lc")
if(!file.exists(lcdir)) dir.create(lcdir)

#' ##  Download subset
#' 
#' `Size`  whole km (integers) for each direction. 
#' 
#' `Size=c(1,1)` for 250m resolution data will return a 9x9 pixel tile for each location, centred on the input coordinate. 
#' 
#' `Size=c(0,0)` only the central pixel. 
#' 
#' **Maximum** size tile `Size=c(100,100)`
#' 
#' This can take a few minutes to run, so you can use the file provided in the data folder.  
#' 
#' ### Get Land Surface Temperature Data
## ---- eval=F-------------------------------------------------------------
## MODISSubsets(LoadDat = loc,
##              Products = c("MOD11A2"),
##              Bands = c( "LST_Day_1km", "QC_Day"),
##              Size = c(10,10),
##              SaveDir=lstdir,
##              StartDate=T)

#' 
#' ### Get LULC
## ---- eval=F-------------------------------------------------------------
## MODISSubsets(LoadDat = loc,
##              Products = c("MCD12Q1"),
##              Bands = c( "Land_Cover_Type_1"),
##              Size = c(10,10),
##              SaveDir=lcdir,
##              StartDate=T)

#' 
#' List available files:
## ------------------------------------------------------------------------
lst_files=list.files(lstdir,pattern="Lat.*asc",full=T)
head(lst_files)

#' 
#' Output:
#' 
#' * 1 file per location in `loc`
#' * Rows: time-steps
#' * Columns: data bands
#' 
## ------------------------------------------------------------------------
#lst_subset <- read.csv(lst_files[1],header = FALSE, as.is = TRUE)
#dim(lst_subset)
#lst_subset[1:5,1:15]

#' 
#' ## Convert to ASCII Grid raster files
#' 
#' Use `MODISGrid()` to convert to separate [ASCII Grid format](http://resources.esri.com/help/9.3/arcgisdesktop/com/gp_toolref/spatial_analyst_tools/esri_ascii_raster_format.htm) files:
#' 
#' ```
#' NCOLS xxx
#' NROWS xxx
#' XLLCENTER xxx | XLLCORNER xxx
#' YLLCENTER xxx | YLLCORNER xxx
#' CELLSIZE xxx
#' NODATA_VALUE xxx
#' row 1
#' row 2
#' ...
#' row n
#' ```
#' 
#' ## Convert LST Data
## ---- eval=F-------------------------------------------------------------
## MODISGrid(Dir = lstdir,
##           DirName = "modgrid",
##           SubDir = TRUE,
##           NoDataValues=
##               list("MOD11A2" = c("LST_Day_1km" = 0,
##                                  "QC_Day" = -1)))

#' 
#' ## Convert LandCover Data
## ---- eval=F-------------------------------------------------------------
## MODISGrid(Dir = lcdir,
##           DirName = "modgrid",
##           SubDir = TRUE,
##           NoDataValues=
##               list("MCD12Q1" = c("Land_Cover_Type_1" = 255)))

#' 
#' ## Get lists of `.asc` files
#' 
## ------------------------------------------------------------------------
lst_files=list.files(file.path(lstdir,"modgrid"),recursive=T,
                     pattern="LST_Day.*asc",full=T)
head(lst_files)

lstqc_files=list.files(file.path(lstdir,"modgrid"),recursive=T,
                     pattern="QC_Day.*asc",full=T)


#' 
#' ## Create raster stacks of evi and evi qc data
## ------------------------------------------------------------------------
lst=stack(lst_files)
plot(lst[[1:2]])

#' 
#' ### Check gain and offset in [metadata](https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mod11a2).
#' 
## ------------------------------------------------------------------------
gain(lst)=0.02
offs(lst)=-273.15
plot(lst[[1:2]])

#' 
#' # MODLAND Quality control
#' 
#' See a detailed explaination [here](https://lpdaac.usgs.gov/sites/default/files/public/modis/docs/MODIS_LP_QA_Tutorial-1b.pdf).  Some code below from [Steven Mosher's blog](https://stevemosher.wordpress.com/2012/12/05/modis-qc-bits/).
#' 
#' ## MOD11A2 (Land Surface Temperature) Quality Control
#' [MOD11A2 QC Layer table](https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mod11a2)
#' 
#' ![](09_assets/lst_qc.png)
#' 
## ------------------------------------------------------------------------
lstqc=stack(lstqc_files)
plot(lstqc[[1:2]])

#' 
#' ### LST QC data
#' 
#' QC data are encoded in 8-bit 'words' to compress information.
#' 
## ------------------------------------------------------------------------
values(lstqc[[1:2]])%>%table()

#' 
#' 
#' ![](09_assets/QCdata.png)
#' 
## ------------------------------------------------------------------------
intToBits(65)
intToBits(65)[1:8]

as.integer(intToBits(65)[1:8])

#' #### MODIS QC data are _Big Endian_
#' 
#' Format          Digits              value     sum
#' ----            ----                ----      ----
#' Little Endian   1 0 0 0 0 0 1 0     65        2^0 + 2^6
#' Big Endian      0 1 0 0 0 0 0 1     65        2^6 + 2^0
#' 
#' 
#' Reverse the digits with `rev()` and compare with QC table above.
#' 
## ------------------------------------------------------------------------
rev(as.integer(intToBits(65)[1:8]))

#' QC for value `65`:
#' 
#' * LST produced, other quality, recommend exampination of more detailed QA
#' * good data quality of L1B in 7 TIR bands
#' * average emissivity error <= 0.01
#' * Average LST error <= 2K
#' 
#' 
#' <div class="well">
#' ## Your turn
#' What does a QC value of 81 represent?
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">
#' </div>
#' </div>
#' 
#' ### Filter the the lst data using the QC data
#' 
## ------------------------------------------------------------------------
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

#' 
#' ### Select which QC Levels to keep
## ------------------------------------------------------------------------
keep=QC_Data[QC_Data$Bit1 == 0,]
keepvals=unique(keep$Integer_Value)
keepvals


#' 
#' ### How many observations will be dropped?
#' 
## ----warning=F-----------------------------------------------------------
qcvals=table(values(lstqc))  # this takes a minute or two


QC_Data%>%
  dplyr::select(everything(),-contains("Bit"))%>%
  mutate(Var1=as.character(Integer_Value),
         keep=Integer_Value%in%keepvals)%>%
  inner_join(data.frame(qcvals)) 

#' 
#' Do you want to update the values you are keeping?
#' 
#' ### Filter the LST Data keeping only `keepvals`
#' 
#' These steps take a couple minutes.  
#' 
#' Make logical flag to use for mask
## ------------------------------------------------------------------------
lstkeep=calc(lstqc,function(x) x%in%keepvals)

#' 
#' Plot the mask
## ----fig.height=12-------------------------------------------------------
gplot(lstkeep[[4:8]])+
  geom_raster(aes(fill=as.factor(value)))+
  facet_grid(variable~1)+
  scale_fill_manual(values=c("blue","red"),name="Keep")+
  coord_equal()+
  theme(legend.position = "bottom")

#' 
#' 
#' Mask the lst data using the QC data
## ------------------------------------------------------------------------
lst2=mask(lst,mask=lstkeep,maskval=0)


#' 
#' 
#' ## Add Dates to Z dimension
#' 
## ------------------------------------------------------------------------

tdates=names(lst)%>%
  sub(pattern=".*_A",replacement="")%>%
  as.Date("%Y%j")

names(lst2)=1:nlayers(lst2)
lst2=setZ(lst2,tdates)


#' 
#' ## Summarize to Seasonal climatologies
#' 
#' Use `stackApply()` with a seasonal index.
#' 
## ------------------------------------------------------------------------
tseas=as.numeric(sub("Q","",quarters(getZ(lst2))))
tseas[1:20]

lst_seas=stackApply(lst2,
                    indices = tseas,
                    mean,na.rm=T)
names(lst_seas)=c("Q1_Winter",
                  "Q2_Spring",
                  "Q3_Summer",
                  "Q4_Fall")

#' 
## ----fig.height=9--------------------------------------------------------
gplot(lst_seas)+geom_raster(aes(fill=value))+
  facet_wrap(~variable)+
  scale_fill_gradientn(colours=c("blue",mid="grey","red"))+
  coord_equal()+
  theme(axis.text.x=element_text(angle=60, hjust=1))

#' 
#' 
#' <div class="well">
#' ## Your turn
#' Use `stackApply()` to generate and plot monthly median lst values.
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
#' <div id="demo2" class="collapse">
#' 
#' 
#' </div>
#' </div>
#' 
#' ## Extract timeseries for a point
#' 
## ---- warning=F----------------------------------------------------------
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

#' 
#' See the `library(rts)` for more timeseries related functions.
#' 
#' ### Process landcover data
## ------------------------------------------------------------------------
lc_files=list.files(
  file.path(lcdir,"modgrid"),
  recursive=T,
  pattern="Land_Cover_Type_1.*asc",
  full=T)

lc=raster(lc_files[1])

#' 
#' Get cover clases from [MODIS website](https://lpdaac.usgs.gov/dataset_discovery/modis/modis_products_table/mcd12q1)
#' 
## ------------------------------------------------------------------------
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

#' 
#' Convert to `factor` raster
## ----warnings=F----------------------------------------------------------
lc=as.factor(lc)
lcd=data.frame(
  ID=Land_Cover_Type_1,
  landcover=names(Land_Cover_Type_1))
levels(lc)=lcd

#' Warnings about `.checkLevels()` OK here because some factors not present in this subset...
#' 
#' ### Resample `lc` to `lst` grid
#' 
## ------------------------------------------------------------------------
lc2=resample(lc,
             lst,
             method="ngb")

par(mfrow=c(1,2)) 
plot(lc)
plot(lc2)
par(mfrow=c(1,1))

#' 
#' ### Summarize mean monthly temperatures by Landcover
#' 
## ------------------------------------------------------------------------
table(values(lc))

#' 
#' Extract values from `lst` and `lc` rasters.  
#' 
## ------------------------------------------------------------------------
lcds1=cbind.data.frame(
  values(lst_seas),
  ID=values(lc2))
head(lcds1)

#' 
#' Melt table and add LandCover Name
## ------------------------------------------------------------------------
lcds2=lcds1%>%
  melt(id.vars="ID",
       variable.name = "season",
       value.var="value")%>%
  mutate(ID=as.numeric(ID))%>%
  left_join(lcd)
head(lcds2)

#' 
#' #### Explore LST distributions by landcover
#' 
## ----fig.height=12-------------------------------------------------------
ggplot(lcds2,aes(y=value,x=landcover,group=landcover))+
  facet_wrap(~season)+
  geom_point(alpha=.5,position="jitter")+
  geom_violin(alpha=.5,col="red",scale = "width")+
  theme(axis.text.x=element_text(angle=90, hjust=1))


#' 
#' 
#' ### Use Zonal Statistics to calculate summaries
## ------------------------------------------------------------------------
lct.mean=zonal(lst_seas,
               lc2,
               'mean',na.rm=T)%>%
  data.frame()

lct.sd=zonal(lst_seas,
             lc2,
             'sd',na.rm=T)%>%
  data.frame()

lct.count=zonal(lst_seas,
                lc2,
                'count',na.rm=T)%>%
  data.frame()

lct.summary=rbind(data.frame(lct.mean,var="mean"),
                  data.frame(lct.sd,var="sd"),
                  data.frame(lct.count,var="count"))

#' 
#' #### Summarize seasonal values
## ------------------------------------------------------------------------
lctl=melt(lct.summary,
          id.var=c("zone","var"),
          value="lst")
lctl$season=factor(lctl$variable,
                   labels=c("Winter","Spring","Summer","Fall"),
                   ordered=T)
lctl$lc=levels(lc)[[1]][lctl$zone+1,"landcover"]
lctl=dcast(lctl,zone+season+lc~var,value="value")
head(lctl)%>%kable()

#' 
#' ## Build summary table
## ------------------------------------------------------------------------
filter(lctl,count>=100)%>%
  mutate(txt=paste0(round(mean,2),
                    " (±",round(sd,2),")"))%>%
  dcast(lc+count~season,
        value.var="txt")%>%
  kable()

#' 
#' <div class="well">
#' ## Your turn
#' Calculate the  maximum observed seasonal average lst in each land cover type.  
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo3">Show Solution</button>
#' <div id="demo3" class="collapse">
#' 
#' </div>
#' </div>
#' 
#' 
#' 
#' Things to think about:
#' 
#' * What tests would you use to identify differences?
#' * Do you need to worry about unequal sample sizes?
#' 
