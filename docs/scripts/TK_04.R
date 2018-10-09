#' ---
#' title: "Getting Help!"
#' subtitle: Learning more about finding help
#' reading:
#'    - How to [write a reproducible example](http://adv-r.had.co.nz/Reproducibility.html)
#' presentation:
#'    - day_12_help.html
#' tasks:
#'    - Learn how to read R help files effectively
#'    - Learn how to search for help
#'    - Learn how to create a Minimum Working Example (MWE)
#'    - Debug existing code
#'    - Save your reprex to your course repository as an html file using Export -> "Save As Webpage" in the RStudio "Viewer" Tab.
#' ---
#' 
#' 
#' `r presframe()`
#' 
#' # Reading
#' 
#' # Tasks
#' 
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
library(sf)

library(spData)
data(world)

#' 
#' ## Your problem
#' 
#' You want to make a figure illustrating the distribution of GDP per capita for all countries within each continent using the `world` data in the `spData` package.  Your desired figure looks something like the following:
#' 
#' 
#' You have started working on the figure but can't seem to make it work like you want.  Here is your current version of the code (and the resulting figure):
#' 
## ---- warning=F----------------------------------------------------------
ggplot(world,aes(x=gdpPercap, y=continent, color=continent))+
   geom_density(alpha=0.5,color=F)

#' 
#' You want to ask for help and so you know that you need to make a reproducible example.  Starting with the code above, make the required edits so you can use `reprex()` to generate a nicely formatted example that you could email or post to a forum to ask for help.  See the [reading](https://reprex.tidyverse.org/) for more help. Note: you do _not_ need to recreate the figure above, only to use `reprex()` to illustrate your question.
#' 
#' If you have extra time, try to fix the code above to make the first figure.
#' 
