---
title: "Introduction to R"
---

# Who uses R

## {data-background-iframe="http://r4stats.com/articles/popularity"}

[Popularity of Data Science Software](http://r4stats.com/articles/popularity)

## Software in Job Ads
![](https://i0.wp.com/r4stats.com/wp-content/uploads/2017/02/Fig-1a-IndeedJobs-2017.png)

The number of data science jobs for the more popular software (those with 250 jobs or more, 2/2017).

## Data science job trends
![](https://i1.wp.com/r4stats.com/wp-content/uploads/2017/02/Fig-1c-R-v-SAS-2017-02-18.png?w=733)

R (blue) and SAS (orange).


## Scholarly Articles
![](https://i1.wp.com/r4stats.com/wp-content/uploads/2017/06/Fig_2a_ScholarlyImpact2016-3.png?w=650)

Number of scholarly articles found in the most recent complete year (2016) for the more popular data science software. To be included, software must be used in at least 750 scholarly articles.

## Trend in scholarly articles
![](https://i0.wp.com/r4stats.com/wp-content/uploads/2017/06/Fig_2d_ScholarlyImpact2016.png?w=650)

The number of scholarly articles found in each year by Google Scholar. Only the top six “classic" statistics packages are shown.

## Trend in scholarly articles
![](https://i0.wp.com/r4stats.com/wp-content/uploads/2017/06/Fig_2e_ScholarlyImpactSubset2016.png?w=650)

The number of scholarly articles found in each year by Google Scholar for classic statistics packages after the curves for SPSS and SAS have been removed.
 
## Rexer's biannual Data Science Survey 
![](img/rexer_tooluse.png)

1,220 respondents from 72 different countries

## Tool Use
![](img/rexer_rise.png)

## Change over time
![](img/rexer_concurrent.png)

## Interface to R
![](img/rexer_interface.png)

# Getting Started

## Questions from the readings?


## Many 'Cheatsheets' available

https://www.rstudio.com/resources/cheatsheets/

## Basic R Data Structures
![](img/CheatSheet_basicR.png)
http://github.com/rstudio/cheatsheets/raw/master/base-r.pdf

## Data Transformation
![](img/CheatSheet_data-transformation.png)
https://github.com/rstudio/cheatsheets/raw/master/data-transformation.pdf

# Training your eyes

## Fix the errors

Do you see any errors in the following code?


```r
library(tidyverse)

ggplot(dota = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8)
filter(diamond, carat > 3)
```

## Interpret these error statements

Discuss with your neighbor what the error statement is saying. How would you fix it?


```r
ggplot(dota = mpg) + 
+   geom_point(mapping = aes(x = displ, y = hwy))
#> Error in structure(list(data = data, layers = list(), 
#> scales = scales_list(),  : 
#>  argument "data" is missing, with no default
```


```r
fliter(mpg, cyl = 8)
#> Error in fliter(mpg, cyl = 8) : could not find function "fliter"
```


```r
filter(diamond, carat > 3)
#> Error in filter(diamond, carat > 3) : object 'diamond' not found
```

## Let's get coding...

Open [today's activity](../01_Rintro.html) and work through the exercise.
