---
title:  APIs, time-series, and weather Data
---

# API

## Application Programming Interface


# Climate Metrics

## Climate Metrics: ClimdEX
Indices representing extreme aspects of climate derived from daily data:

<img src="08_assets/climdex.png" alt="alt text" width="50%">

Climate Change Research Centre (CCRC) at University of New South Wales (UNSW) ([climdex.org](http://www.climdex.org)).  

## 27 Core indices

For example:

* **FD** Number of frost days: Annual count of days when TN (daily minimum temperature) < 0C.
* **SU** Number of summer days: Annual count of days when TX (daily maximum temperature) > 25C.
* **ID** Number of icing days: Annual count of days when TX (daily maximum temperature) < 0C.
* **TR** Number of tropical nights: Annual count of days when TN (daily minimum temperature) > 20C.
* **GSL** Growing season length: Annual (1st Jan to 31st Dec in Northern Hemisphere (NH), 1st July to 30th June in Southern Hemisphere (SH)) count between first span of at least 6 days with daily mean temperature TG>5C and first span after July 1st (Jan 1st in SH) of 6 days with TG<5C.
* **TXx** Monthly maximum value of daily maximum temperature
* **TN10p** Percentage of days when TN < 10th percentile
* **Rx5day** Monthly maximum consecutive 5-day precipitation
* **SDII** Simple pricipitation intensity index


## Weather Data

### Climate Data Online

![CDO](08_assets/climatedataonline.png)

### GHCN 

![ghcn](08_assets/ghcn.png)

## Options for downloading data in R

### `FedData` package

* National Elevation Dataset digital elevation models (1 and 1/3 arc-second; USGS)
* National Hydrography Dataset (USGS)
* Soil Survey Geographic (SSURGO) database 
* International Tree Ring Data Bank.
* **Global Historical Climatology Network** (GHCN)

## NOAA API

![noaa api](08_assets/noaa_api.png)

[National Climatic Data Center application programming interface (API)]( http://www.ncdc.noaa.gov/cdo-web/webservices/v2). 

## `rNOAA` package

Handles downloading data directly from NOAA APIv2.

* `buoy_*`  NOAA Buoy data from the National Buoy Data Center
* `ghcnd_*`  GHCND daily data from NOAA
* `isd_*` ISD/ISH data from NOAA
* `homr_*` Historical Observing Metadata Repository
* `ncdc_*` NOAA National Climatic Data Center (NCDC)
* `seaice` Sea ice
* `storm_` Storms (IBTrACS)
* `swdi` Severe Weather Data Inventory (SWDI)
* `tornadoes` From the NOAA Storm Prediction Center

---

## Libraries


```r
library(raster)
library(sf)
library(tidyverse)
library(ggmap)
library(maps)
library(scales)
# New Packages
library(rnoaa)
library(climdex.pcic)
library(zoo)
library(broom)
library(knitr)
```

## Station locations 

Download the GHCN station inventory with `ghcnd_stations()`.  


```r
datadir="data"

st = ghcnd_stations()
head(st)%>%kable()
```



id             latitude   longitude   elevation  state   name                    gsn_flag   wmo_id   element    first_year   last_year
------------  ---------  ----------  ----------  ------  ----------------------  ---------  -------  --------  -----------  ----------
ACW00011604     17.1167    -61.7833        10.1          ST JOHNS COOLIDGE FLD                       TMAX             1949        1949
ACW00011604     17.1167    -61.7833        10.1          ST JOHNS COOLIDGE FLD                       TMIN             1949        1949
ACW00011604     17.1167    -61.7833        10.1          ST JOHNS COOLIDGE FLD                       PRCP             1949        1949
ACW00011604     17.1167    -61.7833        10.1          ST JOHNS COOLIDGE FLD                       SNOW             1949        1949
ACW00011604     17.1167    -61.7833        10.1          ST JOHNS COOLIDGE FLD                       SNWD             1949        1949
ACW00011604     17.1167    -61.7833        10.1          ST JOHNS COOLIDGE FLD                       PGTM             1949        1949

## GHCND Variables: 5 core values

* **PRCP** Precipitation (tenths of mm)
* **SNOW** Snowfall (mm)
* **SNWD** Snow depth (mm)
* **TMAX** Maximum temperature
* **TMIN** Minimum temperature

---

### And ~50 others!  For example:

* **ACMC** Average cloudiness midnight to midnight from 30-second ceilometer 
* **AWND** Average daily wind speed
* **FMTM** Time of fastest mile or fastest 1-minute wind
* **MDSF** Multiday snowfall total

## `filter()` to temperature and precipitation

```r
st_filtered=dplyr::filter(st,element%in%c("TMAX","TMIN","PRCP"))
```

## Map GHCND stations

First, get a global country polygon

```r
library(spData)
data(world)
```

---

Plot all stations:

```r
ggplot(data=st_filtered,aes(y=latitude,x=longitude)) +
  facet_grid(element~.)+ #make panels for each variable
  geom_sf(data=world,inherit.aes = F,size=.1,fill="grey",colour="black")+
  geom_point(size=.1,col="red")+
  coord_sf()
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-5-1.png)

It's hard to see all the points, let's bin them...

---


```r
ggplot(st_filtered,aes(y=latitude,x=longitude)) +
  geom_sf(data=world,inherit.aes = F,size=.1,fill="grey",colour="black")+
  facet_grid(element~.)+
  stat_bin2d(bins=100)+
  scale_fill_distiller(palette="YlOrRd",trans="log",direction=-1,
                       breaks = c(1,10,100,1000))+
  coord_sf()
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-6-1.png)

<div class="well">
## Your turn

Produce a binned map (like above) with the following modifications:

* include only stations with a data record that starts before 1950 and ends after 2000 (keeping only complete records during that time).
* include only `tmax`

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
<div id="demo1" class="collapse">


```r
ggplot(filter(st_filtered,
              first_year<=1950 & 
              last_year>=2000 & 
              element=="TMAX"),
       aes(y=latitude,x=longitude)) +
  geom_sf(data=world, inherit.aes = F, size=.1, fill="grey", colour="black")+
  stat_bin2d(bins=75)+
  scale_fill_distiller(palette="YlOrRd",trans="log",direction=-1,
    breaks = c(1,10,50))+
  coord_sf()
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-7-1.png)
</div>
</div>

## Download daily data from GHCN

`ghcnd()` will download a `.dly` file for a particular station.  But how to choose?

### `geocode` in ggmap package useful for geocoding place names 
Geocodes a location (find latitude and longitude) using either (1) the Data Science Toolkit (http://www.datasciencetoolkit.org/about) or (2) Google Maps. 


```r
geocode("University at Buffalo, NY",source = "dsk")
```

```
## Information from URL : http://www.datasciencetoolkit.org/maps/api/geocode/json?address=University%20at%20Buffalo,%20NY&sensor=false
```

```
##         lon      lat
## 1 -78.80388 42.95973
```

---

However, you have to be careful:

```r
geocode("My Grandma's house")
```

```
## Information from URL : http://maps.googleapis.com/maps/api/geocode/json?address=My%20Grandma's%20house&sensor=false
```

```
## Warning: geocode failed with status OVER_QUERY_LIMIT, location = "My
## Grandma's house"
```

```
##   lon lat
## 1  NA  NA
```

But this is pretty safe for well known places.

```r
coords=as.matrix(geocode("Buffalo, NY",source = "dsk"))
```

```
## Information from URL : http://www.datasciencetoolkit.org/maps/api/geocode/json?address=Buffalo,%20NY&sensor=false
```

```r
coords
```

```
##            lon      lat
## [1,] -78.88642 42.89606
```

---

Now use that location to spatially filter stations with a rectangular box.

```r
bufferwidth=1 #size of rectangular buffer in decimal degrees

dplyr::filter(st_filtered,
              grepl("BUFFALO",name)&
              between(latitude, coords[2] - bufferwidth, coords[2] + bufferwidth) &
              between(longitude, coords[1] - bufferwidth, coords[1] + bufferwidth)&
         element=="TMAX")
```

```
## # A tibble: 3 x 11
##   id    latitude longitude elevation state name  gsn_flag wmo_id element
##   <chr>    <dbl>     <dbl>     <dbl> <chr> <chr> <chr>    <chr>  <chr>  
## 1 USC0…     42.9     -78.9    -1000. NY    BUFF… ""       ""     TMAX   
## 2 USC0…     42.9     -78.9      177. NY    BUFF… ""       ""     TMAX   
## 3 USW0…     42.9     -78.7      211. NY    BUFF… ""       HCN 7… TMAX   
## # ... with 2 more variables: first_year <int>, last_year <int>
```
You could also spatially filter using `sf` package...

---
With the station ID, we can download daily data from NOAA.

```r
d=meteo_tidy_ghcnd("USW00014733",
                   var = c("TMAX","TMIN","PRCP"),
                   keep_flags=T)
head(d)%>%kable()
```



id            date         mflag_prcp   mflag_tmax   mflag_tmin    prcp  qflag_prcp   qflag_tmax   qflag_tmin   sflag_prcp   sflag_tmax   sflag_tmin    tmax   tmin
------------  -----------  -----------  -----------  -----------  -----  -----------  -----------  -----------  -----------  -----------  -----------  -----  -----
USW00014733   1938-05-01   T                                          0                                         0            0            0              144     39
USW00014733   1938-05-02   T                                          0                                         0            0            0              211     83
USW00014733   1938-05-03                                             25                                         0            0            0              167     72
USW00014733   1938-05-04                                            112                                         0            0            0              206     94
USW00014733   1938-05-05   T                                          0                                         0            0            0              311    106
USW00014733   1938-05-06                                             64                                         0            0            0              194     78

---

See [CDO Daily Description](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/GHCND_documentation.pdf) and raw [GHCND metadata](http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/readme.txt) for more details.  If you want to download multiple stations at once, check out `meteo_pull_monitors()`

---

## Quality Control: MFLAG

Measurement Flag/Attribute

* **Blank** no measurement information applicable
* **B** precipitation total formed from two twelve-hour totals
* **H** represents highest or lowest hourly temperature (TMAX or TMIN) or average of hourly values (TAVG)
* **K** converted from knots
* ...

See [CDO Description](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/GHCND_documentation.pdf) 

## Quality Control: QFLAG

* **Blank** did not fail any quality assurance check 
* **D** failed duplicate check
* **G** failed gap check
* **I** failed internal consistency check
* **K** failed streak/frequent-value check
* **N** failed naught check
* **O** failed climatological outlier check
* **S** failed spatial consistency check
* **T** failed temporal consistency check
* **W** temperature too warm for snow
* ...

See [CDO Description](http://www1.ncdc.noaa.gov/pub/data/cdo/documentation/GHCND_documentation.pdf) 

## Quality Control: SFLAG

Indicates the source of the data...

## Summarize QC flags

Summarize the QC flags.  How many of which type are there?  Should we be more conservative?


```r
table(d$qflag_tmin)  
```

```
## 
##           G     I     S 
## 29026     2     7     4
```
* **G** failed gap check
* **I** failed internal consistency check
* **S** failed spatial consistency check

---

### Filter with QC data and change units

```r
d_filtered=d%>%
  mutate(tmax=ifelse(qflag_tmax!=" "|tmax==-9999,NA,tmax/10))%>%  # convert to degrees C
  mutate(tmin=ifelse(qflag_tmin!=" "|tmin==-9999,NA,tmin/10))%>%  # convert to degrees C
  mutate(prcp=ifelse(qflag_prcp!=" "|prcp==-9999,NA,prcp))%>%  # convert to degrees C
  arrange(date)
```

---

Plot temperatures

```r
ggplot(d_filtered,
       aes(y=tmax,x=date))+
  geom_line(col="red")
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-15-1.png)

---
Limit to a few years and plot the daily range and average temperatures.

```r
d_filtered_recent=filter(d_filtered,date>as.Date("2013-01-01"))

  ggplot(d_filtered_recent,
         aes(ymax=tmax,ymin=tmin,x=date))+
    geom_ribbon(col="grey",fill="grey")+
    geom_line(aes(y=(tmax+tmin)/2),col="red")
```

```
## Warning: Removed 11 rows containing missing values (geom_path).
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-16-1.png)

## Zoo package for rolling functions

Infrastructure for Regular and Irregular Time Series (Z's Ordered Observations)

* `rollmean()`:  Rolling mean
* `rollsum()`:   Rolling sum
* `rollapply()`:  Custom functions

Use rollmean to calculate a rolling 60-day average. 

* `align` whether the index of the result should be left- or right-aligned or centered

---


```r
d_rollmean = d_filtered_recent %>% 
  arrange(date) %>%
  mutate(tmax.60 = rollmean(x = tmax, 60, align = "center", fill = NA),
         tmax.b60 = rollmean(x = tmax, 60, align = "right", fill = NA))
```

---


```r
d_rollmean%>%
  ggplot(aes(ymax=tmax,ymin=tmin,x=date))+
    geom_ribbon(fill="grey")+
    geom_line(aes(y=(tmin+tmax)/2),col=grey(0.4),size=.5)+
    geom_line(aes(y=tmax.60),col="red")+
    geom_line(aes(y=tmax.b60),col="darkred")
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-18-1.png)

<div class="well">
## Your Turn

Plot a 30-day rolling "right" aligned sum of precipitation.

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
<div id="demo2" class="collapse">

```r
tp=d_filtered_recent %>%
  arrange(date)  %>% 
  mutate(prcp.30 = rollsum(x = prcp, 30, align = "right", fill = NA))

ggplot(tp,aes(y=prcp,x=date))+
  geom_line(aes(y=prcp.30),col="black")+ 
  geom_line(col="red") 
```

```
## Warning: Removed 40 rows containing missing values (geom_path).
```

```
## Warning: Removed 11 rows containing missing values (geom_path).
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-19-1.png)
</div>
</div>


# Time Series analysis

Most timeseries functions use the time series class (`ts`)


```r
tmin.ts=ts(d_filtered_recent$tmin,frequency = 365)
```

## Temporal autocorrelation

Values are highly correlated!


```r
ggplot(d_filtered_recent,aes(y=tmin,x=lag(tmin)))+
  geom_point()+
  geom_abline(intercept=0, slope=1)
```

```
## Warning: Removed 12 rows containing missing values (geom_point).
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-21-1.png)

## Autocorrelation functions

* autocorrelation  $x$ vs. $x_{t-1}$  (lag=1)
* partial autocorrelation.  $x$  vs. $x_{n}$ _after_ controlling for correlations $\in t-1:n$

## Autocorrelation

```r
acf(tmin.ts,lag.max = 365*3,na.action = na.exclude )
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-22-1.png)

#### Partial Autocorrelation

```r
pacf(tmin.ts,lag.max = 365,na.action = na.exclude )
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-23-1.png)


# Checking for significant trends

## Compute temporal aggregation indices

## Group by month, season, year, and decade.

How to convert years into 'decades'?

```r
1938
```

```
## [1] 1938
```

```r
round(1938,-1)
```

```
## [1] 1940
```

```r
floor(1938/10)
```

```
## [1] 193
```

```r
floor(1938/10)*10 
```

```
## [1] 1930
```
Now we can make a 'decade' grouping variable.

---

Calculate seasonal and decadal mean temperatures.

```r
d_filtered2=d_filtered%>%
  mutate(month=as.numeric(format(date,"%m")),
        year=as.numeric(format(date,"%Y")),
        season=ifelse(month%in%c(12,1,2),"Winter",
            ifelse(month%in%c(3,4,5),"Spring",
              ifelse(month%in%c(6,7,8),"Summer",
                ifelse(month%in%c(9,10,11),"Fall",NA)))),
        dec=(floor(as.numeric(format(date,"%Y"))/10)*10))
d_filtered2%>%dplyr::select(date,month,year,season,dec,tmax)%>%head()%>%kable()
```



date          month   year  season     dec   tmax
-----------  ------  -----  -------  -----  -----
1938-05-01        5   1938  Spring    1930   14.4
1938-05-02        5   1938  Spring    1930   21.1
1938-05-03        5   1938  Spring    1930   16.7
1938-05-04        5   1938  Spring    1930   20.6
1938-05-05        5   1938  Spring    1930   31.1
1938-05-06        5   1938  Spring    1930   19.4

## Timeseries models


How to assess change? Simple differences?


```r
d_filtered2%>%
  mutate(period=ifelse(year<=1976-01-01,"early","late"))%>% #create two time periods before and after 1976
  group_by(period)%>%  # divide the data into the two groups
  summarize(n=n(),    # calculate the means between the two periods
            tmin=mean(tmin,na.rm=T),
            tmax=mean(tmax,na.rm=T),
            prcp=mean(prcp,na.rm=T))%>%
  kable()
```



period        n       tmin       tmax       prcp
-------  ------  ---------  ---------  ---------
early     13394   4.199753   13.67348   25.09372
late      15645   4.764507   13.75706   28.44032

---

But be careful, there were lots of missing data in the beginning of the record

```r
d_filtered2%>%
  group_by(year)%>%
  summarize(n=n())%>%
  ggplot(aes(x=year,y=n))+
  geom_line()
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-27-1.png)


```r
# which years don't have complete data?
d_filtered2%>%
  group_by(year)%>%
  summarize(n=n())%>%
  filter(n<360)
```

```
## # A tibble: 2 x 2
##    year     n
##   <dbl> <int>
## 1  1938   245
## 2  2017   304
```

---

Plot 10-year means (excluding years without complete data):

```r
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
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-29-1.png)


## Look for specific events: was 2017 unusually hot in Buffalo, NY?
Let's compare 2017 with all the previous years in the dataset.  First add 'day of year' to the data to facilitate showing all years on the same plot.

```r
df=d_filtered2%>%
  mutate(doy=as.numeric(format(date,"%j")),
         doydate=as.Date(paste("2017-",doy),format="%Y-%j"))
```

---

Then plot all years (in grey) and add 2017 in red.

```r
ggplot(df,aes(x=doydate,y=tmax,group=year))+
  geom_line(col="grey",alpha=.5)+ # plot each year in grey
  stat_smooth(aes(group=1),col="black")+   # Add a smooth GAM to estimate the long-term mean
  geom_line(data=filter(df,year>2016),col="red")+  # add 2017 in red
  scale_x_date(labels = date_format("%b"),date_breaks = "2 months")
```

```
## `geom_smooth()` using method = 'gam' and formula 'y ~ s(x, bs = "cs")'
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-31-1.png)

---

Then 'zoom' into just the past few months and add 2017 in red.

```r
ggplot(df,aes(x=doydate,y=tmax,group=year))+
  geom_line(col="grey",alpha=.5)+
  stat_smooth(aes(group=1),col="black")+
  geom_line(data=filter(df,year>2016),col="red")+
  scale_x_date(labels = date_format("%b"),date_breaks = "2 months",
               lim=c(as.Date("2017-08-01"),as.Date("2017-10-31")))
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-32-1.png)

So there was an unusually warm spell in late September.

## Summarize by season

```r
seasonal=d_filtered2%>%
  group_by(year,season)%>%
  summarize(n=n(),
            tmin=mean(tmin),
            tmax=mean(tmax),
            prcp=mean(prcp))%>%
  filter(n>75)
```

---


```r
ggplot(seasonal,aes(y=tmin,x=year))+
  facet_wrap(~season,scales = "free_y")+
  stat_smooth(method="lm", se=T)+
  geom_line()
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-34-1.png)


## Linear regression of maximum temperature in fall

```r
s1=seasonal%>%
  filter(season=="Summer")

ggplot(s1,aes(y=tmin,x=year))+
  stat_smooth(method="lm", se=T)+
  geom_line()
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-35-1.png)

---


```r
lm1=lm(tmin~year, data=s1)
str(lm1)
```

```
## List of 13
##  $ coefficients : Named num [1:2] -23.551 0.0197
##   ..- attr(*, "names")= chr [1:2] "(Intercept)" "year"
##  $ residuals    : Named num [1:79] 0.566 0.187 -0.676 -0.349 -0.147 ...
##   ..- attr(*, "names")= chr [1:79] "1" "2" "3" "4" ...
##  $ effects      : Named num [1:79] -137.232 4.023 -0.752 -0.424 -0.222 ...
##   ..- attr(*, "names")= chr [1:79] "(Intercept)" "year" "" "" ...
##  $ rank         : int 2
##  $ fitted.values: Named num [1:79] 14.7 14.7 14.7 14.7 14.7 ...
##   ..- attr(*, "names")= chr [1:79] "1" "2" "3" "4" ...
##  $ assign       : int [1:2] 0 1
##  $ qr           :List of 5
##   ..$ qr   : num [1:79, 1:2] -8.888 0.113 0.113 0.113 0.113 ...
##   .. ..- attr(*, "dimnames")=List of 2
##   .. .. ..$ : chr [1:79] "1" "2" "3" "4" ...
##   .. .. ..$ : chr [1:2] "(Intercept)" "year"
##   .. ..- attr(*, "assign")= int [1:2] 0 1
##   ..$ qraux: num [1:2] 1.11 1.17
##   ..$ pivot: int [1:2] 1 2
##   ..$ tol  : num 1e-07
##   ..$ rank : int 2
##   ..- attr(*, "class")= chr "qr"
##  $ df.residual  : int 77
##  $ na.action    : 'omit' Named int 9
##   ..- attr(*, "names")= chr "9"
##  $ xlevels      : Named list()
##  $ call         : language lm(formula = tmin ~ year, data = s1)
##  $ terms        :Classes 'terms', 'formula'  language tmin ~ year
##   .. ..- attr(*, "variables")= language list(tmin, year)
##   .. ..- attr(*, "factors")= int [1:2, 1] 0 1
##   .. .. ..- attr(*, "dimnames")=List of 2
##   .. .. .. ..$ : chr [1:2] "tmin" "year"
##   .. .. .. ..$ : chr "year"
##   .. ..- attr(*, "term.labels")= chr "year"
##   .. ..- attr(*, "order")= int 1
##   .. ..- attr(*, "intercept")= int 1
##   .. ..- attr(*, "response")= int 1
##   .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
##   .. ..- attr(*, "predvars")= language list(tmin, year)
##   .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
##   .. .. ..- attr(*, "names")= chr [1:2] "tmin" "year"
##  $ model        :'data.frame':	79 obs. of  2 variables:
##   ..$ tmin: num [1:79] 15.2 14.9 14 14.4 14.6 ...
##   ..$ year: num [1:79] 1938 1939 1940 1941 1942 ...
##   ..- attr(*, "terms")=Classes 'terms', 'formula'  language tmin ~ year
##   .. .. ..- attr(*, "variables")= language list(tmin, year)
##   .. .. ..- attr(*, "factors")= int [1:2, 1] 0 1
##   .. .. .. ..- attr(*, "dimnames")=List of 2
##   .. .. .. .. ..$ : chr [1:2] "tmin" "year"
##   .. .. .. .. ..$ : chr "year"
##   .. .. ..- attr(*, "term.labels")= chr "year"
##   .. .. ..- attr(*, "order")= int 1
##   .. .. ..- attr(*, "intercept")= int 1
##   .. .. ..- attr(*, "response")= int 1
##   .. .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
##   .. .. ..- attr(*, "predvars")= language list(tmin, year)
##   .. .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
##   .. .. .. ..- attr(*, "names")= chr [1:2] "tmin" "year"
##   ..- attr(*, "na.action")= 'omit' Named int 9
##   .. ..- attr(*, "names")= chr "9"
##  - attr(*, "class")= chr "lm"
```

```r
summary(lm1)
```

```
## 
## Call:
## lm(formula = tmin ~ year, data = s1)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -2.00360 -0.45550 -0.02385  0.57754  1.90919 
## 
## Coefficients:
##               Estimate Std. Error t value Pr(>|t|)    
## (Intercept) -23.551009   8.042522  -2.928  0.00448 ** 
## year          0.019713   0.004066   4.848 6.33e-06 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.8298 on 77 degrees of freedom
##   (1 observation deleted due to missingness)
## Multiple R-squared:  0.2339,	Adjusted R-squared:  0.2239 
## F-statistic: 23.51 on 1 and 77 DF,  p-value: 6.333e-06
```

---
You can extract values of interest by looking at the structure of the object.


```r
str(summary(lm1))
```

```
## List of 12
##  $ call         : language lm(formula = tmin ~ year, data = s1)
##  $ terms        :Classes 'terms', 'formula'  language tmin ~ year
##   .. ..- attr(*, "variables")= language list(tmin, year)
##   .. ..- attr(*, "factors")= int [1:2, 1] 0 1
##   .. .. ..- attr(*, "dimnames")=List of 2
##   .. .. .. ..$ : chr [1:2] "tmin" "year"
##   .. .. .. ..$ : chr "year"
##   .. ..- attr(*, "term.labels")= chr "year"
##   .. ..- attr(*, "order")= int 1
##   .. ..- attr(*, "intercept")= int 1
##   .. ..- attr(*, "response")= int 1
##   .. ..- attr(*, ".Environment")=<environment: R_GlobalEnv> 
##   .. ..- attr(*, "predvars")= language list(tmin, year)
##   .. ..- attr(*, "dataClasses")= Named chr [1:2] "numeric" "numeric"
##   .. .. ..- attr(*, "names")= chr [1:2] "tmin" "year"
##  $ residuals    : Named num [1:79] 0.566 0.187 -0.676 -0.349 -0.147 ...
##   ..- attr(*, "names")= chr [1:79] "1" "2" "3" "4" ...
##  $ coefficients : num [1:2, 1:4] -23.55101 0.01971 8.04252 0.00407 -2.92831 ...
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:2] "(Intercept)" "year"
##   .. ..$ : chr [1:4] "Estimate" "Std. Error" "t value" "Pr(>|t|)"
##  $ aliased      : Named logi [1:2] FALSE FALSE
##   ..- attr(*, "names")= chr [1:2] "(Intercept)" "year"
##  $ sigma        : num 0.83
##  $ df           : int [1:3] 2 77 2
##  $ r.squared    : num 0.234
##  $ adj.r.squared: num 0.224
##  $ fstatistic   : Named num [1:3] 23.5 1 77
##   ..- attr(*, "names")= chr [1:3] "value" "numdf" "dendf"
##  $ cov.unscaled : num [1:2, 1:2] 93.928528 -0.047483 -0.047483 0.000024
##   ..- attr(*, "dimnames")=List of 2
##   .. ..$ : chr [1:2] "(Intercept)" "year"
##   .. ..$ : chr [1:2] "(Intercept)" "year"
##  $ na.action    : 'omit' Named int 9
##   ..- attr(*, "names")= chr "9"
##  - attr(*, "class")= chr "summary.lm"
```

```r
summary(lm1)$r.squared
```

```
## [1] 0.2338852
```

---

Print a summary table:

```r
tidy(lm1)%>%kable()
```



term              estimate   std.error   statistic     p.value
------------  ------------  ----------  ----------  ----------
(Intercept)    -23.5510090   8.0425217   -2.928311   0.0044803
year             0.0197133   0.0040659    4.848415   0.0000063

## Autoregressive models
See [Time Series Analysis Task View](https://cran.r-project.org/web/views/TimeSeries.html) for summary of available packages/models. 

* Moving average (MA) models
* autoregressive (AR) models
* autoregressive moving average (ARMA) models
* frequency analysis
* Many, many more...

---

# Other Climate Metrics

## Climdex indices
[ClimDex](http://www.climdex.org/indices.html)

##  Format data for `climdex`


```r
library(PCICt)
## Parse the dates into PCICt.
pc.dates <- as.PCICt(as.POSIXct(d_filtered$date),cal="gregorian")
```


## Generate the climdex object

```r
  library(climdex.pcic)
    ci <- climdexInput.raw(
      tmax=d_filtered$tmax,
      tmin=d_filtered$tmin,
      prec=d_filtered$prcp,
      pc.dates,pc.dates,pc.dates, 
      base.range=c(1971, 2000))
years=as.numeric(as.character(unique(ci@date.factors$annual)))
```

## Cumulative dry days


```r
cdd= climdex.cdd(ci, spells.can.span.years = TRUE)
plot(cdd~years,type="l")
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-41-1.png)

## Diurnal Temperature Range


```r
dtr=climdex.dtr(ci, freq = c("annual"))
plot(dtr~years,type="l")
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-42-1.png)

## Frost Days


```r
fd=climdex.fd(ci)
plot(fd~years,type="l")
```

![](PS_09_weather_files/figure-revealjs/unnamed-chunk-43-1.png)
