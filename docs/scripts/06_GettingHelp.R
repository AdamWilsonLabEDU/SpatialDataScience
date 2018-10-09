#' ---
#' title: "Getting Help!"
#' reading:
#'    - How to [write a reproducible example](http://adv-r.had.co.nz/Reproducibility.html)
#' presentation:
#'    - day_12_help.html
#' tasks:
#'    - Learn how to read R help files effectively
#'    - Learn how to search for help
#'    - Learn how to create a Minimum Working Example (MWE)
#' ---
#' 
#' 
#' `r presframe()`
#' 
#' ## Download
#' 
#' `r output_table()`
#' 
#' ## Libraries
#' 
## ----message=F,warning=FALSE---------------------------------------------
library(tidyverse)
library(reprex)

#' 
#' 
## ------------------------------------------------------------------------
mpg%>%
  ggplot(aes(x=drv, y=trans))%>%
  geom_point(aes(color=class))%>%
  geom_smooth()

data=data.frame(x=c(1,2),y=c(1,2),z=c(1.5,1.5))
ggplot(data,aes(x=x,y=y,color=z)) +
geom_point()

#' 
#' 
#' 
