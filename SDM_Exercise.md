# Spatially-explicit logistic regression



 

```r
library(knitr)
library(raster)
library(rasterVis)
library(dplyr)
library(ggplot2)
library(ggmap)
library(rgdal)
library(sp) # handles spatial data

## New Packages
library(mgcv) # package for Generalized Additive Models
library(ncf) # has an easy function for correlograms
library(grid)
library(gridExtra)
library(xtable)
```

## Goal of this class

* To demonstrate a simple presence/absence modelling in spatial context. 
* To model spatial dependence (autocorrelation) in the response. 
  
Overview of [R's spatial toolset is here](http://cran.r-project.org/web/views/Spatial.html).
  
## What is spatial autocorrelation?
  
Today we will model space by **smooth splines** in `mgcv` package. 
  
Examples of Alternative approaches:

  - Simple polynomials
  - Eigenvector Mapping: ```vegan```, ```spdep```
  - Predictive process: ```spbayes```
  
Methods that tweak variance-covariance matrix of **Multivariate Normal Distribution**:

  - Generalized Least Squares: ```MASS```, ```nlme```
  - Autoregressive Models: ```spdep```
  - GeoBUGS module in OpenBUGS
  
See [Dormann et al. 2007 Ecography, 30: 609-628](http://onlinelibrary.wiley.com/doi/10.1111/j.2007.0906-7590.05171.x/full) for a review.

## Species Distribution Modeling

We'll attempt to explain the spatial distribution of the Purple finch (_Carpodacus purpureus_) in San Diego county, California:

![purple finch figure](assets/finch_photo.png)

(photo/Wikimedia)


## Preparing the data

Load a vector dataset (shapefile) representing the [San Diego bird atlas data](http://sdplantatlas.org/BirdAtlas/BirdPages.htm) for the Purple finch:


```r
finch <- readOGR("data", layer="finch")
## add centroid locations to dataframe
finch@data[,c("x","y")]=coordinates(finch)
```


### Plot the shapefile
Plot the finch dataset over a google map layer.


#### First convert to latitude-longitude

```r
finchll=spTransform(finch,CRS("+proj=longlat +datum=WGS84"))
```


#### Get a google map image for the background

```r
map_usa=get_map("usa", zoom = 4,
             maptype = "terrain-background",
             source="stamen")
map_sd=get_map(bbox(finchll), zoom = 9,
             maptype="terrain-background",
             source="stamen")
```

#### Build the ggplot objects

```r
m1=ggmap(map_usa,extent = "device")+
geom_polygon(aes(y=lat,x=long,group=group,order=order),
             data=fortify(finchll),fill="transparent",colour="red",size=2)+
  ylab("")+xlab("")

m2=ggmap(map_sd)+
geom_polygon(aes(y=lat,x=long,group=group,order=order),
             data=fortify(finchll),fill="transparent",colour="red")+
  ylab("Latitude")+xlab("Longitude")
```

#### Draw the plot with an inset using `viewport()`

`viewport()` in the `grid` package allows you to put graphical objects anywhere in the plotting region.  Use it to draw the USA map as an inset to show the location of region with respect to the US. 


```r
print(m2)
print(m1,vp=viewport(width=.25,height=.25,x=.8,y=.8))
```

### Your Turn

Explore adjusting the `viewport()` parameters to see how it moves around.  Can you move it to lower right corner?  Note that the positions (e.g. `width`, `height`, `x`, and `y`) are all with respect to the full plotting domain, so if you change the aspect ratio of the plotting window, things will move around...

<br><br><br><br><br><br><br><br><br><br><br>

## Explore the data
Now look at the associated data frame (analogous to the *.dbf file that accompanied the shapefile):

```r
kable(head(finch@data))
```

> Note: in your final projects, don't simply print out large tables or outputs...  Filter/select only data relevent to tell your 'story'...

## Scaling and centering the environmental variables
Statistical models generally perform better when covariates have a mean of zero and variance of 1, using the `scale()` function:

```r
kable(head(select(finch@data,15:25)))

envi <- finch@data[,15:25] 
envi.scaled <- as.data.frame(scale(envi))
finch@data[,15:25] <- envi.scaled
```


## The predictor (NDVI)  

### Plot a chloropleth

From [Wikipedia](https://en.wikipedia.org/wiki/Choropleth_map):

> A **choropleth** (from Greek χώρο ("area/region") + πλήθος ("multitude")) is a thematic map in which areas are shaded or patterned in proportion to the measurement of the statistical variable being displayed on the map, such as population density or per-capita income.

By default, the rownames in the dataframe are the unique identifier (e.g. the **FID**) for the polygons.  


```r
## add the ID to the dataframe itself for easier indexing
finch$id=as.numeric(rownames(finch@data))
## create fortified version for plotting with ggplot()
pfinch=fortify(finch,region="id")

ggplot(finch@data, aes(map_id = id)) +
    expand_limits(x = pfinch$long, y = pfinch$lat)+
    scale_fill_gradientn(colours = c("grey","goldenrod","darkgreen","green"))+
    coord_equal()+
    geom_map(aes(fill = ndvi), map = pfinch)
```

## Your turn

Explore the other variables in the `finch` dataset with `summary(finch)`.  Plot a map of the mean elevation in each region.

<br><br><br><br><br><br><br><br><br><br><br><br>


```r
ggplot(finch@data, aes(map_id = id)) +
    expand_limits(x = pfinch$long, y = pfinch$lat)+
    scale_fill_gradientn(colours = c("blue","grey","red"))+
    coord_equal()+
    geom_map(aes(fill = meanelev), map = pfinch)
```

Use `grid.arrange()` to plot multiple plots in the same figure.

```r
p1=ggplot(finch@data, aes(map_id = id)) +
    expand_limits(x = pfinch$long, y = pfinch$lat)+
    scale_fill_gradient2(low="blue",mid="grey",high="red")+
    coord_equal()+
    ylab("")+xlab("")+
     theme(legend.position = "top")+
    theme(axis.ticks = element_blank(), axis.text = element_blank())

p1a=p1+geom_map(aes(fill = ndvi), map = pfinch)
p1b=p1+geom_map(aes(fill = meanelev), map = pfinch)
p1c=p1+geom_map(aes(fill = urban), map = pfinch)
p1d=p1+geom_map(aes(fill = maxtmp), map = pfinch)

grid.arrange(p1a,p1b,p1c,p1d,ncol=2)    
```



## The response (presences and absences)

```r
    ggplot(finch@data, aes(map_id = id)) +
    geom_map(aes(fill = as.logical(present)), map = pfinch)+
    expand_limits(x = pfinch$long, y = pfinch$lat)+
    scale_fill_manual(values = c("darkgrey","red"),name="Present")+
    coord_equal()
```

## Fitting the models

Compare three models:

1. Only NDVI
2. Only Space
3. Space and NDVI


### Model 1 - only NDVI

Now we will do the actual modelling. The first simple model links the presences and absences to NDVI.

First, we will fit model a model that only uses NDVI as a predictor of presence and absence:

$\log ( \frac{p_i}{1-p_i} ) = \beta_0 + \beta_1 NDVI_i$

$o_i \sim Bernoulli(p_i)$

> Note: this assumes residuals are _iid_ (independent and identically distributed).  

It can be fitted by simple glm() in R:

```r
  ndvi.only <- glm(present~ndvi, data=finch@data, family="binomial")
  ## and let's extract predictions and residuals:
  preds.ndvi.only <- predict(ndvi.only, type="response")
  resid.ndvi.only <- residuals(ndvi.only)
```


Now let's plot the logistic curve:

```r
  plot(finch$ndvi,preds.ndvi.only, type="p", 
       xlab="(Scaled) NDVI", ylab="P of presence", col="red")
  points(finch$ndvi, finch$present)
```

Print a summary table

```r
xtable(ndvi.only,
       caption="Model summary for 'NDVI-only'")%>%
    print(type="html")
```

### Model 2 - only space

The second model fits only the spatial trend in the data (using GAM and splines):

```r
  space.only <- gam(present~s(X_CEN, Y_CEN),
                   data=finch@data, family="binomial")
  ## extracting predictions
  preds.space.only <- as.numeric(predict(space.only, type="response"))
  resid.space.only <- residuals(space.only)
```

Plot the ***spatial term*** of the model:


```r
  finch$space=as.numeric(predict(space.only,type="terms"))

  ggplot(finch@data, aes(x=x,y=y,z=space, map_id = id)) +
  geom_map(aes(fill = space), map = pfinch)+
  geom_point(aes(col=as.logical(present)))+
  expand_limits(x = pfinch$long, y = pfinch$lat)+
  scale_fill_gradientn(colours=c("darkblue","blue","grey","yellow","orange","red"))+
  scale_color_manual(values=c("transparent","black"),name="Present")+
  coord_equal()
```


Print a summary table

```r
xtable(summary(space.only)$s.table, 
       caption="Model summary for 'Space-only'")%>%
    print(type="html")
```

### Model 3 - space and NDVI

The third model uses both the NDVI and spatial trends to explain the finch's occurrences:

```r
  space.and.ndvi <- gam(present~ndvi + s(X_CEN, Y_CEN),
                   data=finch@data, family="binomial")
  ## extracting predictions and residuals:
  preds.space.and.ndvi <- as.numeric(predict(space.and.ndvi, type="response"))
  resid.space.and.ndvi <- residuals(space.and.ndvi)
```

Print a summary table

```r
xtable(summary(space.and.ndvi)$s.table,
       caption="Model summary for 'Space and NDVI'")%>%
    print(type="html")
```

Plot the ***spatial term*** of the model:

```r
  finch$ndvispace=as.numeric(predict(space.and.ndvi,type="terms")[,2])

  ggplot(finch@data, aes(x=x,y=y, map_id = id)) +
  geom_map(aes(fill = ndvispace), map = pfinch)+
  geom_point(aes(col=as.logical(present)))+
  expand_limits(x = pfinch$long, y = pfinch$lat)+
  scale_fill_gradient2(low="blue",mid="grey",high="red",name="Spatial Effects")+
  scale_color_manual(values=c("transparent","black"),name="Present")+
  coord_equal()
```


## Examine the fitted models

Now let's put all of the predictions together:

```r
predictions <- data.frame(id=finch$id,
                          x=finch$x,
                          y=finch$y,
                          present=finch$present,
                          ndvi=  preds.ndvi.only, 
                          ndvi_resid=  resid.ndvi.only,
                          space =  preds.space.only,
                          space_resid =  resid.space.only,
                          ndvispace=  preds.space.and.ndvi,
                          ndvispace_resid= resid.space.and.ndvi)
```

Combine all the predictions into a single _long_ table:

```r
library(reshape2)

predictionsl= melt(predictions,
                     variable.name="var",
                     id.vars=c("id","x","y"),
                     measure.vars=c(
                       "present",
                       "ndvi","ndvi_resid",
                       "space","space_resid",
                       "ndvispace","ndvispace_resid"))
```
 
Plot predictions from the three models, together with the observed presences and absences: 

```r
    ggplot(filter(predictionsl,!grepl("resid|present",var)), aes(map_id = id)) +
    geom_map(aes(fill = value), map = pfinch)+
      facet_wrap(~var)+
    geom_point(data=finch@data,aes(x=x,y=y,col=as.logical(present)),size=.5)+
    scale_color_manual(values=c("transparent","black"),name="Present")+
    expand_limits(x = pfinch$long, y = pfinch$lat)+
    scale_fill_gradientn(colours = c("blue","grey","red"))+
    coord_equal()+
   theme(axis.ticks = element_blank(), axis.text = element_blank())
```

## Model comparison

We can compare model performance of the models with Akaike's Information Criterion (AIC).  This uses the formula  $-2*log-likelihood + k*npar$, where

* $npar$ number of parameters in the fitted model
* $k = 2$ penalty per parameter 

Lower is better...


```r
kable(AIC(ndvi.only, space.only, space.and.ndvi))
```

## Spatial Autocorrelation of  Residuals

Should always check the spatial correlation in model residuals to evaluate assumptions.   We will use the function ```correlog``` from the ```ncf``` package. An overview of other [functions that plot correlograms is here.](http://www.petrkeil.com/?p=1050).


```r
inc=10000  #spatial increment of correlogram in m

cor=predictionsl%>%
  filter(grepl("present",var)|grepl("resid",var))%>%
  group_by(var)%>%
  do(var=.$var,cor=correlog(.$x,.$y,.$value,increment=inc, resamp=100))%>%
  do(data.frame(
      var=.$var[[1]],
      Distance = .$cor$mean.of.class/1000,
      Correlation=.$cor$correlation,
      pvalue=.$cor$p))
```

And we can plot the correlograms:

```r
ggplot(cor,aes(x=Distance,y=Correlation,col=var,group=var))+
  geom_point(aes(shape=pvalue<=0.05))+
  geom_line()+
  xlab("Distance (km)")+ylab("Spatial\nAuto-correlation")
```

## What did we gain by making the model "spatially explicit"?

- We know that the effect of NDVI is not artificially amplified by pseudoreplication.
- We have more realistic predictions.
- We have a fitted surface that can be interpreted -- perhaps to guide us towards some additional spatially-structured predictors that can be important.

## Your turn

Try adding additional co-variates into the spatial model (e.g. elevation or climate).


```r
m1 <- gam(present~ndvi+meanelev+
            wintert+meanppt+urban + 
            s(X_CEN, Y_CEN),
            data=finch@data, family="binomial")
m2 <- gam(present~ndvi+meanppt + 
            s(X_CEN, Y_CEN),
            data=finch@data, family="binomial")
```

Print a summary table

```r
xtable(summary(m1)$p.table)%>%
    print(type="html")
```

Compare all models

```r
kable(AIC(ndvi.only, 
          space.only, 
          space.and.ndvi,
          m1,m2))
```
