library(knitr)
library(raster)
library(rasterVis)
library(dplyr)
library(ggplot2)
# devtools::install_github("dkahle/ggmap")
library(ggmap)
library(rgdal)
library(rgeos)
library(tidyr)
library(sf)
library(leaflet)
library(DT)
library(widgetframe)

## New Packages
library(mgcv) # package for Generalized Additive Models
library(ncf) # has an easy function for correlograms
library(grid)
library(gridExtra)
library(xtable)
library(maptools)
finch <- read_sf(system.file("extdata", "finch", 
                package = "DataScienceData"),
                layer="finch")

st_crs(finch)="+proj=utm +zone=11 +ellps=GRS80 +datum=NAD83 +units=m +no_defs "
st_transform(finch,"+proj=longlat +datum=WGS84")%>%
  leaflet() %>% addTiles() %>%
  addPolygons()%>%
  frameWidget(height=400)
st_transform(finch,"+proj=longlat +datum=WGS84")%>%
  leaflet() %>% addTiles() %>%
  addPolygons(label=paste(finch$BLOCKNAME," (NDVI=",finch$ndvi,")"),
              group = "NDVI",
              color = "#444444", 
              weight = 0.1, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", ndvi)(ndvi),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                bringToFront = TRUE)) %>%
    addPolygons(label=paste(finch$BLOCKNAME," (NDVI=",finch$ndvi,")"),
              group = "Presence/Absence",
              color = "#444444", 
              weight = 0.1, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillOpacity = 0.5,
              fillColor = ifelse(finch$present,"red","transparent"),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                bringToFront = TRUE)) %>%
  addLayersControl(
    baseGroups = c("NDVI", "Presence/Absence"),
    options = layersControlOptions(collapsed = FALSE)
  )%>%
addMiniMap()%>%
  frameWidget(height = 600)
p1=ggplot(finch) +
    scale_fill_gradient2(low="blue",mid="grey",high="red")+
    coord_equal()+
    ylab("")+xlab("")+
     theme(legend.position = "right")+
    theme(axis.ticks = element_blank(), axis.text = element_blank())

p1a=p1+geom_sf(aes(fill = ndvi))
p1b=p1+geom_sf(aes(fill = meanelev))
p1c=p1+geom_sf(aes(fill = urban))
p1d=p1+geom_sf(aes(fill = maxtmp))

grid.arrange(p1a,p1b,p1c,p1d,ncol=1)  
datatable(finch, options = list(pageLength = 5))%>%
  frameWidget(height=400)
finch=mutate(finch,ndvi_scaled=as.numeric(scale(ndvi)))
  ndvi.only <- glm(present~ndvi_scaled, 
                   data=finch, family="binomial")
  finch$m_pred_ndvi <- predict(ndvi.only, type="response")
  finch$m_resid_ndvi <- residuals(ndvi.only)
ggplot(finch,aes(x=ndvi/256,y=m_pred_ndvi))+
  geom_line(col="red")+ 
  geom_point(mapping=aes(y=present))+
  xlab("NDVI")+
  ylab("P(presence)")
xtable(ndvi.only,
       caption="Model summary for 'NDVI-only'")%>%
    print(type="html")
  space.only <- gam(present~s(X_CEN, Y_CEN),
                   data=finch, family="binomial")
  finch$m_pred_space <- as.numeric(predict(space.only, type="response"))
  finch$m_resid_space <- residuals(space.only)
  finch$m_space=as.numeric(predict(space.only,type="terms"))

st_transform(finch,"+proj=longlat +datum=WGS84")%>%
  leaflet() %>% addTiles() %>%
  addPolygons(color = "#444444", 
              weight = 0.1, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillOpacity = 0.5,
              fillColor = ~colorQuantile("YlOrRd", m_space)(m_space),
              highlightOptions = highlightOptions(color = "white", weight = 2,
                bringToFront = TRUE))%>%
  frameWidget(height=200)
xtable(summary(space.only)$s.table, 
       caption="Model summary for 'Space-only'")%>%
    print(type="html")
  space.and.ndvi <- gam(present~ndvi + s(X_CEN, Y_CEN),
                   data=finch, family="binomial")
  ## extracting predictions and residuals:
  finch$m_pred_spacendvi <- as.numeric(predict(space.and.ndvi, type="response"))
  finch$m_resid_spacendvi <- residuals(space.and.ndvi)
xtable(summary(space.and.ndvi)$s.table,
       caption="Model summary for 'Space and NDVI'")%>%
    print(type="html")
  finch$m_ndvispace=as.numeric(predict(space.and.ndvi,type="terms")[,2])

  st_transform(finch,"+proj=longlat +datum=WGS84")%>%
    ggplot(aes(x=X_CEN,y=Y_CEN)) +
    geom_sf(aes(fill = m_ndvispace))+
    geom_point(aes(col=as.logical(present)))+
  scale_fill_gradient2(low="blue",mid="grey",high="red",name="Spatial Effects")+
  scale_color_manual(values=c("transparent","black"),name="Present")
p1=st_transform(finch,"+proj=longlat +datum=WGS84")%>%
  ggplot()+
  scale_fill_gradient2(low="blue",mid="grey",high="red")+
  scale_color_manual(values=c("transparent","black"),name="Present",guide="none")+
  coord_equal()+
  ylab("")+xlab("")+
  theme(legend.position = "right")+
  theme(axis.ticks = element_blank(), axis.text = element_blank())

pts=geom_point(data=finch,aes(x=X_CEN,y=Y_CEN,col=as.logical(present)),size=.5)
    

p1a=p1+geom_sf(aes(fill = m_pred_spacendvi))+pts
p1b=p1+geom_sf(aes(fill = m_pred_space))+pts
p1c=p1+geom_sf(aes(fill = m_pred_ndvi))+pts

grid.arrange(p1a,p1b,p1c,ncol=1)  

datatable(AIC(ndvi.only, 
              space.only, 
              space.and.ndvi))
inc=10000  #spatial increment of correlogram in m

# add coordinates of each polygon's centroid to the sf dataset 
finch[,c("x","y")]=st_centroid(finch)%>%st_coordinates()

#use by() in dplyr package to compute a correlogram for each parameter
cor=finch%>%
  dplyr::select(y,x,contains("resid"),present)%>%
  gather(key = "key", value = "value",contains("resid"),present,-y,-x)%>%
  group_by(key)%>%
  do(var=.$key,cor=correlog(.$x,.$y,.$value,increment=inc, resamp=100,quiet=T))%>%
  do(data.frame(
      key=.$key[[1]],
      Distance = .$cor$mean.of.class/1000,
      Correlation=.$cor$correlation,
      pvalue=.$cor$p, stringsAsFactors=F))
ggplot(cor,aes(x=Distance,y=Correlation,col=key,group=key))+
  geom_point(aes(shape=pvalue<=0.05))+
  geom_line()+
  xlab("Distance (km)")+ylab("Spatial\nAuto-correlation")
