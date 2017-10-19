#' ---
#' title: "Reproducible Research"
#' ---
#' 
#' 
#' <div>
#' <iframe src="07_assets/Reproducible_Presentation.html" width=100% height=400px></iframe>
#' </div>
#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
#' 
#' 
#' ## R Markdown
#' 
#' Cheatsheet:
#' 
#' <a href="https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf"> <img src="07_assets/rmarkdown.png" alt="alt text" width="400"></a>
#' 
#' <small><small><small>[https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)</small></small></small>
#' 
#' 
#' ## Create new file
#' **File -> New File -> RMarkdown -> Document -> HTML**
#' 
#' <img src="07_assets/rmarkdownwindow.png" alt="alt text" width="500">
#' 
#' ## Step 1: Load packages
#' 
#' All R code to be run must be in a _code chunk_ like this:
## ---- eval=F,asis=T------------------------------------------------------
## #```{r,eval=F}
## CODE HERE
## #```

#' 
#' Load these packages in a code chunk (you may need to install some packages):
#' 
## ---- message=F----------------------------------------------------------
library(dplyr)
library(ggplot2)
library(maps)
library(spocc)

#' 
#' > Do you think you should put `install.packages()` calls in your script?
#' 
#' 
#' ## Step 2: Load data
#' 
#' Now use the `occ()` function to download all the _occurrence_ records for the American robin (_Turdus migratorius_) from the [Global Biodiversity Information Facility](gbif.org).
#' 
#' <img src="07_assets/Turdus-migratorius-002.jpg" alt="alt text" width="200">
#' 
#' <small><small><small>Licensed under CC BY-SA 3.0 via [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Turdus-migratorius-002.jpg#/media/File:Turdus-migratorius-002.jpg)</small></small></small>
#' 
## ---- warning=F----------------------------------------------------------
## define which species to query
sp='Turdus migratorius'

## run the query and convert to data.frame()
d = occ(query=sp, from='ebird',limit = 1000) %>% occ2df()

#' This can take a few seconds.
#' 
#' ## Step 3: Map it
#' 
## ---- fig.width=6--------------------------------------------------------
# Load coastline
map=map_data("world")

ggplot(d,aes(x=longitude,y=latitude))+
  geom_polygon(aes(x=long,y=lat,group=group,order=order),data=map)+
  geom_point(col="red")+
  coord_equal()

#' 
#' ## Step 4:
#' Update the YAML header to keep the markdown file
#' 
#' From this:
## ---- eval=F-------------------------------------------------------------
## title: "Untitled"
## author: "Adam M. Wilson"
## date: "October 31, 2016"
## output: html_document

#' 
#' To this:
## ---- eval=F-------------------------------------------------------------
## title: "Demo"
## author: "Adam M. Wilson"
## date: "October 31, 2016"
## output:
##   html_document:
##       keep_md: true

#' 
#' And click `knit HTML` to generate the output
#' 
#' ## Step 5:  Explore markdown functions
#' 
#' 1. Use the Cheatsheet to add sections and some example narrative.  
#' 2. Try changing changing the species name to your favorite species and re-run the report. 
#' 3. Add more figures or different versions of a figure
#' 4. Check out the `kable()` function for tables (e.g. `kable(head(d))`)
#' 
#' <a href="https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf"> <img src="07_assets/rmarkdown.png" alt="alt text" width="400"></a>
