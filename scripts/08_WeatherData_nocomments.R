library(raster)
library(sp)
library(rgdal)
library(ggplot2)
library(ggmap)
library(dplyr)
library(tidyr)
library(maps)
library(scales)
# New Packages
library(rnoaa)
library(climdex.pcic)
library(zoo)
library(reshape2)
library(broom)
datadir="data"

st = ghcnd_stations()

## Optionally, save it to disk
# write.csv(st,file.path(datadir,"st.csv"))
## If internet fails, load the file from disk using:
# st=read.csv(file.path(datadir,"st.csv"))
st=dplyr::filter(st,element%in%c("TMAX","TMIN","PRCP"))
worldmap=map_data("world")
ggplot(data=st,aes(y=latitude,x=longitude)) +
  facet_grid(element~.)+
  annotation_map(map=worldmap,size=.1,fill="grey",colour="black")+
  geom_point(size=.1,col="red")+
  coord_equal()
ggplot(st,aes(y=latitude,x=longitude)) +
  annotation_map(map=worldmap,size=.1,fill="grey",colour="black")+
  facet_grid(element~.)+
  stat_bin2d(bins=100)+
  scale_fill_distiller(palette="YlOrRd",trans="log",direction=-1,
                       breaks = c(1,10,100,1000))+
  coord_equal()
geocode("University at Buffalo, NY")
geocode("My Grandma's house")
coords=as.matrix(geocode("Buffalo, NY"))
coords
dplyr::filter(st,
              grepl("BUFFALO",name)&
              between(latitude,coords[2]-1,coords[2]+1) &
              between(longitude,coords[1]-1,coords[1]+1)&
         element=="TMAX")
d=meteo_tidy_ghcnd("USW00014733",
                   var = c("TMAX","TMIN","PRCP"),
                   keep_flags=T)
head(d)
table(d$qflag_tmax)  
table(d$qflag_tmin)  
table(d$qflag_prcp)  
d_filtered=d%>%
  mutate(tmax=ifelse(qflag_tmax!=" "|tmax==-9999,NA,tmax/10))%>%  # convert to degrees C
  mutate(tmin=ifelse(qflag_tmin!=" "|tmin==-9999,NA,tmin/10))%>%  # convert to degrees C
  mutate(prcp=ifelse(qflag_tmin!=" "|prcp==-9999,NA,prcp))%>%  # convert to degrees C
  arrange(date)
ggplot(d_filtered,
       aes(y=tmax,x=date))+
  geom_line(col="red")
d_filtered_recent=filter(d_filtered,date>as.Date("2013-01-01"))

  ggplot(d_filtered_recent,
         aes(ymax=tmax,ymin=tmin,x=date))+
    geom_ribbon(col="grey",fill="grey")+
    geom_line(aes(y=(tmax+tmin)/2),col="red")
d_rollmean = d_filtered_recent %>% 
  arrange(date) %>%
  mutate(tmax.60 = rollmean(x = tmax, 60, align = "center", fill = NA),
         tmax.b60 = rollmean(x = tmax, 60, align = "right", fill = NA))
d_rollmean%>%
  ggplot(aes(ymax=tmax,ymin=tmin,x=date))+
    geom_ribbon(fill="grey")+
    geom_line(aes(y=(tmin+tmax)/2),col=grey(0.4),size=.5)+
    geom_line(aes(y=tmax.60),col="red")+
    geom_line(aes(y=tmax.b60),col="darkred")
tmin.ts=ts(d_filtered_recent$tmin,frequency = 365)
ggplot(d_filtered_recent,aes(y=tmin,x=lag(tmin)))+
  geom_point()+
  geom_abline(intercept=0, slope=1)
acf(tmin.ts,lag.max = 365*3,na.action = na.exclude )
pacf(tmin.ts,lag.max = 365*3,na.action = na.exclude )
1938
round(1938,-1)
floor(1938/10)*10
d_filtered2=d_filtered%>%
  mutate(month=as.numeric(format(date,"%m")),
        year=as.numeric(format(date,"%Y")),
        season=ifelse(month%in%c(12,1,2),"Winter",
            ifelse(month%in%c(3,4,5),"Spring",
              ifelse(month%in%c(6,7,8),"Summer",
                ifelse(month%in%c(9,10,11),"Fall",NA)))),
        dec=(floor(as.numeric(format(date,"%Y"))/10)*10))
knitr::kable(head(d_filtered2))
d_filtered2%>%
  mutate(period=ifelse(year<=1976-01-01,"early","late"))%>% #create two time periods before and after 1976
  group_by(period)%>%  # divide the data into the two groups
  summarize(n=n(),    # calculate the means between the two periods
            tmin=mean(tmin,na.rm=T),
            tmax=mean(tmax,na.rm=T),
            prcp=mean(prcp,na.rm=T))
d_filtered2%>%
  group_by(year)%>%
  summarize(n=n())%>%
  ggplot(aes(x=year,y=n))+
  geom_line(col="grey")

# which years don't have complete data?
d_filtered2%>%
  group_by(year)%>%
  summarize(n=n())%>%
  filter(n<360)
d_filtered2%>%
  filter(year>1938, year<2017)%>%
  group_by(dec)%>%
  summarize(
            n=n(),
            tmin=mean(tmin,na.rm=T),
            tmax=mean(tmax,na.rm=T),
            prcp=mean(prcp,na.rm=T)
            )%>%
  ggplot(aes(x=dec,y=tmax))+
  geom_line(col="grey")
df=d_filtered2%>%
  mutate(doy=as.numeric(format(date,"%j")),
         doydate=as.Date(paste("2017-",doy),format="%Y-%j"))
ggplot(df,aes(x=doydate,y=tmax,group=year))+
  geom_line(col="grey",alpha=.5)+ # plot each year in grey
  stat_smooth(aes(group=1),col="black")+   # Add a smooth GAM to estimate the long-term mean
  geom_line(data=filter(df,year>2016),col="red")+  # add 2017 in red
  scale_x_date(labels = date_format("%b"),date_breaks = "2 months")
ggplot(df,aes(x=doydate,y=tmax,group=year))+
  geom_line(col="grey",alpha=.5)+
  stat_smooth(aes(group=1),col="black")+
  geom_line(data=filter(df,year>2016),col="red")+
  scale_x_date(labels = date_format("%b"),date_breaks = "2 months",
               lim=c(as.Date("2017-08-01"),as.Date("2017-10-31")))
seasonal=d_filtered2%>%
  group_by(year,season)%>%
  summarize(n=n(),
            tmin=mean(tmin),
            tmax=mean(tmax),
            prcp=mean(prcp))%>%
  filter(n>75)

ggplot(seasonal,aes(y=tmin,x=year))+
  facet_grid(season~.,scales = "free_y")+
  stat_smooth(method="lm", se=T)+
  geom_line()
s1=seasonal%>%
  filter(season=="Summer")

ggplot(s1,aes(y=tmin,x=year))+
  stat_smooth(method="lm", se=T)+
  geom_line()
lm1=lm(tmin~year, data=s1)
str(lm1)
summary(lm1)
str(summary(lm1))
summary(lm1)$r.squared
tidy(lm1)
library(PCICt)
## Parse the dates into PCICt.
pc.dates <- as.PCICt(as.POSIXct(d_filtered$date),cal="gregorian")
  library(climdex.pcic)
    ci <- climdexInput.raw(
      tmax=d_filtered$tmax,
      tmin=d_filtered$tmin,
      prec=d_filtered$prcp,
      pc.dates,pc.dates,pc.dates, 
      base.range=c(1971, 2000))
years=as.numeric(as.character(unique(ci@date.factors$annual)))
cdd= climdex.cdd(ci, spells.can.span.years = TRUE)
plot(cdd~years,type="l")
dtr=climdex.dtr(ci, freq = c("annual"))
plot(dtr~years,type="l")
fd=climdex.fd(ci)
plot(fd~years,type="l")
climdex.get.available.indices(ci)
