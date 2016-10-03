# Getting Graphic



<div>
<object data="03_assets/03_Plotting.pdf" type="application/pdf" width="100%" height="600px"> 
  <p>It appears you don't have a PDF plugin for this browser.
   No biggie... you can <a href="03_assets/03_Plotting.pdf">click here to
  download the PDF file.</a></p>  
 </object>
 </div>
 <p><a href="03_assets/03_Plotting.pdf">Download the PDF of the presentation</a></p>  


[<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](03_Plotting.R).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  


## Data
In this module, we'll primarily use the `mtcars` data object.  The data was extracted from the 1974 Motor Trend US magazine, and comprises fuel consumption and 10 aspects of automobile design and performance for 32 automobiles (1973–74 models).

A data frame with 32 observations on 11 variables.

| Column name   |  Description                              |
|:--------------|:------------------------------------------|
| mpg           |	Miles/(US) gallon                         |
|	cyl           |	Number of cylinders                       |
|	disp          |	Displacement (cu.in.)                     |
|	hp            |	Gross horsepower                          |
|	drat          |	Rear axle ratio                           |
|	wt            |	Weight (lb/1000)                          |
|	qsec          |	1/4 mile time                             |
|	vs            |	V/S                                       |
|	am            |	Transmission (0 = automatic, 1 = manual)  |
|	gear          |	Number of forward gears                   |
|	carb          |	Number of carburetors                     |

```

Here's what the data look like:

```r
library(ggplot2);library(knitr)
kable(head(mtcars))
```

                      mpg   cyl   disp    hp   drat      wt    qsec   vs   am   gear   carb
------------------  -----  ----  -----  ----  -----  ------  ------  ---  ---  -----  -----
Mazda RX4            21.0     6    160   110   3.90   2.620   16.46    0    1      4      4
Mazda RX4 Wag        21.0     6    160   110   3.90   2.875   17.02    0    1      4      4
Datsun 710           22.8     4    108    93   3.85   2.320   18.61    1    1      4      1
Hornet 4 Drive       21.4     6    258   110   3.08   3.215   19.44    1    0      3      1
Hornet Sportabout    18.7     8    360   175   3.15   3.440   17.02    0    0      3      2
Valiant              18.1     6    225   105   2.76   3.460   20.22    1    0      3      1


# Base graphics


## Base `plot()`

R has a set of 'base graphics' that can do many plotting tasks (scatterplots, line plots, histograms, etc.)


```r
plot(y=mtcars$mpg,x=mtcars$wt)
```

![](03_Plotting_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

Or you can use the more common *formula* notation:


```r
plot(mpg~wt,data=mtcars)
```

![](03_Plotting_files/figure-html/unnamed-chunk-4-1.png)<!-- -->

And you can customize with various parameters:


```r
plot(mpg~wt,data=mtcars,
  ylab="Miles per gallon (mpg)",
  xlab="Weight (1000 pounds)",
  main="Fuel Efficiency vs. Weight",
  col="red"
  )
```

![](03_Plotting_files/figure-html/unnamed-chunk-5-1.png)<!-- -->


Or switch to a line plot:


```r
plot(mpg~wt,data=mtcars,
  type="l",
  ylab="Miles per gallon (mpg)",
  xlab="Weight (1000 pounds)",
  main="Fuel Efficiency vs. Weight",
  col="blue"
  )
```

![](03_Plotting_files/figure-html/unnamed-chunk-6-1.png)<!-- -->


See `?plot` for details.

## Histograms

Check out the help for basic histograms.

```r
?hist
```

Plot a histogram of the fuel efficiencies in the `mtcars` dataset.


```r
hist(mtcars$mpg)
```

![](03_Plotting_files/figure-html/unnamed-chunk-8-1.png)<!-- -->


# [`ggplot2`](http://ggplot2.org)
The _grammar of graphics_:  consistent aesthetics, multidimensional conditioning, and step-by-step plot building.


1.	Data: 		The raw data
2.	`geom_`: The geometric shapes representing data
3.	`aes()`:	Aesthetics of the geometric and statistical objects (color, size, shape, and position)
4.	`scale_`:	Maps between the data and the aesthetic dimensions

```
data
+ geometry,
+ aesthetic mappings like position, color and size
+ scaling of ranges of the data to ranges of the aesthetics
```


### Additional settings

5.	`stat_`:	Statistical summaries of the data that can be plotted, such as quantiles, fitted curves (loess, linear models), etc.
6.	`coord_`:	Transformation for mapping data coordinates into the plane of the data rectangle
7.	`facet_`:	Arrangement of data into grid of plots
8.	`theme`:	Visual defaults (background, grids, axes, typeface, colors, etc.)

For example, a simple scatterplot:
<img src="03_assets/ggplot_intro1.png" alt="alt text" width="100%">

Add variable colors and sizes: 
<img src="03_assets/ggplot_intro2.png" alt="alt text" width="100%">

## Simple scatterplot

First, create a *blank* ggplot object with the data and x-y geometry set up.  

```r
p <- ggplot(mtcars, aes(x=wt, y=mpg))
summary(p)
```

```
## data: mpg, cyl, disp, hp, drat, wt, qsec,
##   vs, am, gear, carb [32x11]
## mapping:  x = wt, y = mpg
## faceting: facet_null()
```

```r
p
```

![](03_Plotting_files/figure-html/unnamed-chunk-9-1.png)<!-- -->



```r
p + geom_point()
```

![](03_Plotting_files/figure-html/unnamed-chunk-10-1.png)<!-- -->

Or you can do both at the same time:

```r
ggplot(mtcars, aes(x=wt, y=mpg)) + 
  geom_point()
```

![](03_Plotting_files/figure-html/unnamed-chunk-11-1.png)<!-- -->


### Aesthetic map: color by # of cylinders


```r
p + 
  geom_point(aes(colour = factor(cyl)))
```

![](03_Plotting_files/figure-html/unnamed-chunk-12-1.png)<!-- -->

### Set shape using # of cylinders 

```r
p + 
  geom_point(aes(shape = factor(cyl)))
```

![](03_Plotting_files/figure-html/unnamed-chunk-13-1.png)<!-- -->

### Adjust size by `qsec` 

```r
p + 
  geom_point(aes(size = qsec))
```

![](03_Plotting_files/figure-html/unnamed-chunk-14-1.png)<!-- -->

### Color by cylinders and size by `qsec` 

```r
p + 
  geom_point(aes(colour = factor(cyl),size = qsec))
```

![](03_Plotting_files/figure-html/unnamed-chunk-15-1.png)<!-- -->

### Multiple aesthetics

```r
p + 
  geom_point(aes(colour = factor(cyl),size = qsec,shape=factor(gear)))
```

![](03_Plotting_files/figure-html/unnamed-chunk-16-1.png)<!-- -->

### Add a linear model

```r
p + geom_point() + 
  geom_smooth(method="lm")
```

![](03_Plotting_files/figure-html/unnamed-chunk-17-1.png)<!-- -->

### Add a LOESS smooth

```r
p + geom_point() + 
  geom_smooth(method="loess")
```

![](03_Plotting_files/figure-html/unnamed-chunk-18-1.png)<!-- -->


### Change scale color


```r
p + geom_point(aes(colour = cyl)) + 
  scale_colour_gradient(low = "blue")
```

![](03_Plotting_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

### Change scale shapes


```r
p + geom_point(aes(shape = factor(cyl))) + 
  scale_shape(solid = FALSE)
```

![](03_Plotting_files/figure-html/unnamed-chunk-20-1.png)<!-- -->

### Set aesthetics to fixed value

```r
ggplot(mtcars, aes(wt, mpg)) + 
  geom_point(colour = "red", size = 3)
```

![](03_Plotting_files/figure-html/unnamed-chunk-21-1.png)<!-- -->

### Transparancy: alpha=0.2

```r
d <- ggplot(diamonds, aes(carat, price))
d + geom_point(alpha = 0.2)
```

![](03_Plotting_files/figure-html/unnamed-chunk-22-1.png)<!-- -->

Varying alpha useful for large data sets

### Transparancy: alpha=0.1


```r
d + 
  geom_point(alpha = 0.1)
```

![](03_Plotting_files/figure-html/unnamed-chunk-23-1.png)<!-- -->

### Transparancy: alpha=0.01


```r
d + 
  geom_point(alpha = 0.01)
```

![](03_Plotting_files/figure-html/unnamed-chunk-24-1.png)<!-- -->


## Building ggplots

<img src="03_assets/ggplotSyntax.png" alt="alt text" width="90%">

## Other Plot types

<img src="03_assets/ggplot01.png" alt="alt text" width="70%">


<div class="well">
Edit plot `p` to include:

1. points
2. A smooth ('loess') curve
3. a "rug" to the plot

```
p <- ggplot(mtcars, aes(x=wt, y=mpg))
```

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
<div id="demo1" class="collapse">


```r
p+
  geom_point()+
  geom_smooth()+
  geom_rug()
```

![](03_Plotting_files/figure-html/unnamed-chunk-25-1.png)<!-- -->
</div>
</div>




<img src="03_assets/ggplot02.png" alt="alt text" width="100%">

<img src="03_assets/ggplot03.png" alt="alt text" width="70%">

<img src="03_assets/ggplot05.png" alt="alt text" width="80%">

### Discrete X, Continuous Y


```r
p <- ggplot(mtcars, aes(factor(cyl), mpg))
p + geom_point()
```

![](03_Plotting_files/figure-html/unnamed-chunk-26-1.png)<!-- -->

### Discrete X, Continuous Y + geom_jitter()


```r
p + 
  geom_jitter()
```

![](03_Plotting_files/figure-html/unnamed-chunk-27-1.png)<!-- -->

### Discrete X, Continuous Y + geom_violin()


```r
p + 
  geom_violin()
```

![](03_Plotting_files/figure-html/unnamed-chunk-28-1.png)<!-- -->

### Discrete X, Continuous Y + geom_violin()


```r
p + 
  geom_violin() + geom_jitter(position = position_jitter(width = .1))
```

![](03_Plotting_files/figure-html/unnamed-chunk-29-1.png)<!-- -->

<img src="03_assets/ggplot06.png" alt="alt text" width="100%">

### Three Variables
<img src="03_assets/ggplot07.png" alt="alt text" width="120%">

Will return to this when we start working with raster maps.

### Stats
Visualize a data transformation

<img src="03_assets/ggplotStat01.png" alt="alt text" width="100%">

* Each stat creates additional variables with a common ``..name..`` syntax
* Often two ways: `stat_bin(geom="bar")`  OR  `geom_bar(stat="bin")`

<img src="03_assets/ggplotStat02.png" alt="alt text" width="100%">

### 2D kernel density estimation

Old Faithful Geyser Data on duration and waiting times.


```r
library("MASS")
```

```
## 
## Attaching package: 'MASS'
```

```
## The following object is masked from 'package:dplyr':
## 
##     select
```

```
## The following objects are masked from 'package:raster':
## 
##     area, select
```

```r
data(geyser)
m <- ggplot(geyser, aes(x = duration, y = waiting))
```

<img src="03_assets/Old_Faithful.jpg" alt="alt text" width="50%"> <small>[photo: Greg Willis](https://commons.wikimedia.org/wiki/File:Old_Faithful_(3679482556).jpg)</small>

See `?geyser` for details.


```r
m + 
  geom_point()
```

![](03_Plotting_files/figure-html/unnamed-chunk-31-1.png)<!-- -->


```r
m + 
  geom_point() +  stat_density2d(geom="contour")
```

![](03_Plotting_files/figure-html/unnamed-chunk-32-1.png)<!-- -->

Check `?geom_density2d()` for details


```r
m + 
  geom_point() +  stat_density2d(geom="contour") +
  xlim(0.5, 6) + ylim(40, 110)
```

![](03_Plotting_files/figure-html/unnamed-chunk-33-1.png)<!-- -->

Update limits to show full contours.  Check `?geom_density2d()` for details





```r
m + stat_density2d(aes(fill = ..level..), geom="polygon") + 
  geom_point(col="red")
```

![](03_Plotting_files/figure-html/unnamed-chunk-34-1.png)<!-- -->

Check `?geom_density2d()` for details



<img src="03_assets/ggplotStat03.png" alt="alt text" width="80%">


<div class="well">
## Your turn

Edit plot `m` to include: 

* The point data (with red points) on top
* A `binhex` plot of the Old Faithful data

Experiment with the number of bins to find one that works.  

See `?stat_binhex` for details.

```
m <- ggplot(geyser, aes(x = duration, y = waiting))
```

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
<div id="demo2" class="collapse">


```r
m + stat_binhex(bins=10) + 
  geom_point(col="red")
```

![](03_Plotting_files/figure-html/unnamed-chunk-35-1.png)<!-- -->

</div>
</div>


## Specifying Scales

<img src="03_assets/ggplotScales01.png" alt="alt text" width="100%">



### Discrete color: default


```r
b=ggplot(mpg,aes(fl))+
  geom_bar( aes(fill = fl)); b
```

![](03_Plotting_files/figure-html/unnamed-chunk-36-1.png)<!-- -->




### Discrete color: greys


```r
b + scale_fill_grey( start = 0.2, end = 0.8, 
                   na.value = "red")
```

![](03_Plotting_files/figure-html/unnamed-chunk-37-1.png)<!-- -->



### Continuous color: defaults


```r
a <- ggplot(mpg, aes(x=hwy,y=cty,col=displ)) + 
  geom_point(); a
```

![](03_Plotting_files/figure-html/unnamed-chunk-38-1.png)<!-- -->



### Continuous color: `gradient`


```r
a +  scale_color_gradient( low = "red", 
                          high = "yellow")
```

![](03_Plotting_files/figure-html/unnamed-chunk-39-1.png)<!-- -->



### Continuous color: `gradient2`


```r
a + scale_color_gradient2(low = "red", high = "blue", 
                       mid = "white", midpoint = 4)
```

![](03_Plotting_files/figure-html/unnamed-chunk-40-1.png)<!-- -->



### Continuous color: `gradientn`


```r
a + scale_color_gradientn(
  colours = rainbow(10))
```

![](03_Plotting_files/figure-html/unnamed-chunk-41-1.png)<!-- -->



### Discrete color: brewer


```r
b + 
  scale_fill_brewer( palette = "Blues")
```

![](03_Plotting_files/figure-html/unnamed-chunk-42-1.png)<!-- -->

## [colorbrewer2.org](http://colorbrewer2.org)


<img src="03_assets/brewer1.png" alt="alt text" width="100%">



## ColorBrewer: Diverging

<img src="03_assets/brewer2.png" alt="alt text" width="100%">

## ColorBrewer: Filtered

<img src="03_assets/brewer3.png" alt="alt text" width="100%">


<div class="well">
## Your turn


Edit the contour plot of the geyser data:

1. Reduce the size of the points
2. Use a sequential brewer palette (select from [colorbrewer2.org](http://colorbrewer2.org)) 
3. Add informative x and y labels

```
m <- ggplot(geyser, aes(x = duration, y = waiting)) +
  stat_density2d(aes(fill = ..level..), geom="polygon") + 
  geom_point(col="red")
```

Note:  `scale_fill_distiller()` rather than `scale_fill_brewer()` for continuous data

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo3">Show Solution</button>
<div id="demo3" class="collapse">


```r
m + stat_density2d(aes(fill = ..level..), geom="polygon") + 
  geom_point(size=.75)+
  scale_fill_distiller(palette="OrRd",
                       name="Kernel\nDensity")+
      xlim(0.5, 6) + ylim(40, 110)+
  xlab("Eruption Duration (minutes)")+
  ylab("Waiting time (minutes)")
```

![](03_Plotting_files/figure-html/unnamed-chunk-43-1.png)<!-- -->

Or use `geom=tile` for a raster representation.


```r
m + stat_density2d(aes(fill = ..density..), geom="tile",contour=F) + 
  geom_point(size=.75)+
  scale_fill_distiller(palette="OrRd",
                       name="Kernel\nDensity")+
      xlim(0.5, 6) + ylim(40, 110)+
  xlab("Eruption Duration (minutes)")+
  ylab("Waiting time (minutes)")
```

![](03_Plotting_files/figure-html/unnamed-chunk-44-1.png)<!-- -->


</div>
</div>


## Axis scaling


Create noisy exponential data


```r
set.seed(201)
n <- 100
dat <- data.frame(
    xval = (1:n+rnorm(n,sd=5))/20,
    yval = 10^((1:n+rnorm(n,sd=5))/20)
)
```



Make scatter plot with regular (linear) axis scaling

```r
sp <- ggplot(dat, aes(xval, yval)) + geom_point()
sp
```

![](03_Plotting_files/figure-html/unnamed-chunk-46-1.png)<!-- -->

<small> Example from [R Cookbook](http://www.cookbook-r.com/Graphs/Axes_(ggplot2)/) </small>



log10 scaling of the y axis (with visually-equal spacing)


```r
sp + scale_y_log10()
```

![](03_Plotting_files/figure-html/unnamed-chunk-47-1.png)<!-- -->

## Coordinate Systems

<img src="03_assets/ggplotCoords.png" alt="alt text" width="55%">


## Position

<img src="03_assets/ggplotPosition.png" alt="alt text" width="80%">



### Stacked bars


```r
ggplot(diamonds, aes(clarity, fill=cut)) + geom_bar()
```

![](03_Plotting_files/figure-html/unnamed-chunk-48-1.png)<!-- -->



### Dodged bars



```r
ggplot(diamonds, aes(clarity, fill=cut)) + geom_bar(position="dodge")
```

![](03_Plotting_files/figure-html/unnamed-chunk-49-1.png)<!-- -->


# Facets

Use facets to divide graphic into *small multiples* based on a categorical variable.  

`facet_wrap()` for one variable:


```r
ggplot(mpg, aes(x = cty, y = hwy, color = factor(cyl))) +
  geom_point()+
  facet_wrap(~year)
```

![](03_Plotting_files/figure-html/unnamed-chunk-50-1.png)<!-- -->



`facet_grid()`: two variables


```r
ggplot(mpg, aes(x = cty, y = hwy, color = factor(cyl))) +
  geom_point()+
  facet_grid(year~cyl)
```

![](03_Plotting_files/figure-html/unnamed-chunk-51-1.png)<!-- -->

*Small multiples* (via facets) are very useful for visualization of timeseries (and especially timeseries of spatial data.)


# Themes
Set *default* display parameters (colors, font sizes, etc.) for different purposes (for example print vs. presentation) using themes.

## GGplot Themes

<img src="03_assets/ggplotThemes.png" alt="alt text" width="80%">

Quickly change plot appearance with themes.

### More options in the `ggthemes` package.

```r
library(ggthemes)
```

Or build your own!



### Theme examples: default

```r
p=ggplot(mpg, aes(x = cty, y = hwy, color = factor(cyl))) +
  geom_jitter() +
  labs(
    x = "City mileage/gallon",
    y = "Highway mileage/gallon",
    color = "Cylinders"
  )
```



### Theme examples: default

```r
p
```

![](03_Plotting_files/figure-html/unnamed-chunk-54-1.png)<!-- -->

 

### Theme examples: Solarized

```r
p + theme_solarized()
```

![](03_Plotting_files/figure-html/unnamed-chunk-55-1.png)<!-- -->

 

### Theme examples: Solarized Dark

```r
p +  theme_solarized(light=FALSE)
```

![](03_Plotting_files/figure-html/unnamed-chunk-56-1.png)<!-- -->

 

### Theme examples: Excel

```r
p + theme_excel() 
```

![](03_Plotting_files/figure-html/unnamed-chunk-57-1.png)<!-- -->

 

### Theme examples: _The Economist_

```r
p + theme_economist()
```

![](03_Plotting_files/figure-html/unnamed-chunk-58-1.png)<!-- -->


# Saving/exporting

## Saving using the GUI
<img src="03_assets/ggplot_guisave.png" alt="alt text" width="80%">




## Saving using `ggsave()`
Save a `ggplot` with sensible defaults:

```r
ggsave(filename, plot = last_plot(), scale = 1, width, height)
```



## Saving using devices

Save any plot with maximum flexibility:


```r
pdf(filename, width, height)  # open device
ggplot()                      # draw the plot(s)
dev.off()                     # close the device
```

**Formats**

* pdf
* jpeg
* png
* tif

and more...


<div class="well">
## Your turn

1. Save the `p` plot from above using `png()` and `dev.off()`
2. Switch to the solarized theme with `light=FALSE`
2. Adjust fontsize with `base_size` in the theme `+ theme_solarized(base_size=24)`

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo4">Show Solution</button>
<div id="demo4" class="collapse">

## Save a plot: Example 1


```r
png("03_assets/test1.png",width=600,height=300)
p +  theme_solarized(light=FALSE)
dev.off()
```

```
## quartz_off_screen 
##                 2
```

<img src="03_assets/test1.png" alt="alt text" width="80%">


## Save a plot: Example 2


```r
png("03_assets/test2.png",width=600,height=300)
p +  theme_solarized(light=FALSE, base_size=24)
dev.off()
```

```
## quartz_off_screen 
##                 2
```
<img src="03_assets/test2.png" alt="alt text" width="80%">


</div>
</div>


## GGPLOT2 Documentation

Perhaps R's best documented package: [docs.ggplot2.org](http://docs.ggplot2.org/current/)

<img src="03_assets/ggplotDoc.png" alt="alt text" width="100%">

## Colophon

Sources:

*  [ggplot cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf)

Licensing: 

* Presentation: [CC-BY-3.0 ](http://creativecommons.org/licenses/by/3.0/us/)
* Source code: [MIT](http://opensource.org/licenses/MIT) 

