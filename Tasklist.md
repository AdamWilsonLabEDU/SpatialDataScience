---
title: "Tasklist"
output:
  html_document:
    toc: true
    toc_depth: 1
---



Below are a set of tasks that we will work on in class (either alone or in small groups).



___
## [ CS_01 :  Create a simple, functioning script ]( ./CS_01.html ) 
   
 
  Write a script that reads in data, calculates a statistic, and makes a plot.  
 
 <a class="btn btn-link" href="./CS_01.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i1">Preview Readings & Tasks </button><div id="i1" class="collapse">
## Readings
- R4DS [Chapter 1](http://r4ds.had.co.nz/introduction.html)
- R4DS [Chapter 2](http://r4ds.had.co.nz/explore-intro.html)
- Datacamp's [_How to Make a Histogram with Basic R_](https://www.datacamp.com/community/tutorials/make-histogram-basic-r)
- Datacamp's [_How to Make a Histogram with ggplot_](https://www.datacamp.com/community/tutorials/make-histogram-ggplot2)

## Tasks
- Create a new R script in RStudio
- Load the iris dataset with `data(iris)`
- Calculate the mean of the `Petal.Length` field
- Plot the distribution of the `Petal.Length` column as a histogram
- Save the script
- Click 'Source' in RStudio to run it from beginning to end
</div>
___
## [ TK_01 :  Git-01 ]( ./TK_01.html ) 
   
 
  Install Git and get organized!  
 
 <a class="btn btn-link" href="./TK_01.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i2">Preview Readings & Tasks </button><div id="i2" class="collapse">
## Readings
- Chapters [1-2 in R4DS](http://r4ds.had.co.nz)
- Chapters [4-8 in Happy Git and Github for the useR - Installation](http://happygitwithr.com/installation-pain.html){target='blank'}

## Tasks
- Create a [GitHub account](https://github.com/join?source=header-home){target="blank"} and post your github username [here](https://goo.gl/forms/wy25GL0YWZIHplDH2)
- Install git on your computer
- Make sure git works in R-Studio
- Sign up for the [GitHub Education pack](https://education.github.com/pack)
- Complete DataCamp Course in [Introduction to R](https://www.datacamp.com/courses/introduction-to-r)
</div>
___
## [ CS_02 :  My grandfather says climate is cooling ]( ./CS_02.html ) 
   
 
  Import data, generate and save a graphic.  
 
 <a class="btn btn-link" href="./CS_02.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i3">Preview Readings & Tasks </button><div id="i3" class="collapse">
## Readings
- The [ggplot2 vignette](https://ggplot2.tidyverse.org/)

## Tasks
- Create a new R script in RStudio
- Load data from a comma-separated-values formatted text file hosted on a website
- Graph the annual mean temperature in June, July and August (`JJA`) using ggplot
- Add a smooth line with `geom_smooth()`
- Add informative axis labels using `xlab()` and `ylab()` including [units](https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show.cgi?id=425003010120&dt=1&ds=5)
- Add a graph title with `ggtitle()`
- Save a graphic to a png file using `png()` and `dev.off()` OR [`ggsave`](https://ggplot2.tidyverse.org/reference/ggsave.html)
- Save the script
- Click 'Source' in RStudio to run the script from beginning to end to re-run the entire process
</div>
___
## [ TK_02 :  Git-02 ]( ./TK_02.html ) 
   
 
  Start using Github to manage course materials  
 
 <a class="btn btn-link" href="./TK_02.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i4">Preview Readings & Tasks </button><div id="i4" class="collapse">
## Readings
- Chapters [3 in R4DS](http://r4ds.had.co.nz)
- Chapters [13-15 in Happy Git and Github for the useR - Installation](http://happygitwithr.com){target='blank'}
- Overview of [Using the R-Studio GUI by R-Studio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN){target='blank'}
- Chapter [8 R for Data Science - Projects](http://r4ds.had.co.nz/workflow-projects.html){target='blank'}
- RStudio and [the Git GUI](https://www.youtube.com/watch?v=E2d91v1Twcc){target='blank'}

## Tasks
- Create a new repository for this course by following [this link](https://classroom.github.com/a/etsQwbE7).
- Create a new project in Rstudio and connect it to the new repository in GitHub (these are labeled `YEAR-GEO503-GITHUBUSERNAME`). Helpful instructions are [here](http://happygitwithr.com/rstudio-git-github.html#clone-the-new-github-repository-to-your-computer-via-rstudio)
- Edit the README.md file in your repository to include a brief description of the repository (e.g. "Coursework for Spatial Data Science").
- Stage and Commit your changes to Git (using the git tab in the upper right of RStudio)
- Push the repository up to GitHub
</div>
___
## [ CS_03 :  Wealth over time ]( ./CS_03.html ) 
   
 
  Data wrangling plus more advanced ggplot  
 
 <a class="btn btn-link" href="./CS_03.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i5">Preview Readings & Tasks </button><div id="i5" class="collapse">
## Readings
- The [ggplot2 vignette](https://ggplot2.tidyverse.org/){target='blank'}
- R4DS [Chapter 3 - Data visualization](http://r4ds.had.co.nz/data-visualisation.html){target='blank'}
- The [Hans Rosling The River of Myths](https://youtu.be/OwII-dwh-bk){target='blank'}
- Watch the [Hons Rosling video](https://www.ted.com/talks/hans_rosling_shows_the_best_stats_you_ve_ever_seen){target="blank"}

## Tasks
- Recreate layered graphics with ggplot including raw and transformed data
- Save graphical output as a .png file
- Save your script as a .R or .Rmd in your course repository
</div>
___
## [ TK_03 :  Data Wrangling ]( ./TK_03.html ) 
   
 
  Data Transformation (Filtering, selecting, transforming)  
 
 <a class="btn btn-link" href="./TK_03.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i6">Preview Readings & Tasks </button><div id="i6" class="collapse">
## Readings
- Chapters [4-5 in R4DS](http://r4ds.had.co.nz)

## Tasks
- Quickly describe any functions that seem especially useful in the README.md file for this week.
</div>
___
## [ CS_04 :  Farthest airport from New York City ]( ./CS_04.html ) 
   
 
  Joining Relational Data  
 
 <a class="btn btn-link" href="./CS_04.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i7">Preview Readings & Tasks </button><div id="i7" class="collapse">
## Readings
- R4DS [Chapter 13 - Relational Data](http://r4ds.had.co.nz/relational-data.html){target='blank'}

## Tasks
- Join two datasets using a common column
- Answer a question that requires understanding how multiple tables are related
- Save your script as a .R or .Rmd in your course repository
</div>
___
## [ TK_04 :  Data Wrangling 2 ]( ./TK_04.html ) 
   
 
  Joining data  
 
 <a class="btn btn-link" href="./TK_04.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i8">Preview Readings & Tasks </button><div id="i8" class="collapse">
## Readings
- Chapters [11-13 in R4DS](http://r4ds.had.co.nz)

## Tasks
- Briefly describe functions that seem especially useful in the README.md file for this week.
</div>
___
## [ CS_05 :  Beware the Canadians! ]( ./CS_05.html ) 
   
 
  Working with Spatial Data and the sf package  
 
 <a class="btn btn-link" href="./CS_05.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i9">Preview Readings & Tasks </button><div id="i9" class="collapse">
## Readings
- The [Spatial Features Package (sf)](https://r-spatial.github.io/sf/){target='blank'}

## Tasks
- Reproject spatial data using `st_transform()`
- Perform spatial operations on spatial data (e.g. intersection and buffering)
- Generate a polygon that includes all land in NY that is within 10km of the Canadian border and calculate the area
- Save your script as a .R or .Rmd in your course repository
</div>
___
## [ TK_05 :  Spatial Vector Data ]( ./TK_05.html ) 
   
 
  Vector data processing. Integrating ‘traditional GIS’ analyses with statistical modelling.  Data intersection, overlays, zonal statistics  
 
 <a class="btn btn-link" href="./TK_05.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i10">Preview Readings & Tasks </button><div id="i10" class="collapse">
## Readings
- Chapters [1-2 in GCR](https://geocompr.robinlovelace.net/)

## Tasks
- Quickly describe functions that seem especially useful in the README.md file for this week.
</div>
___
## [ CS_06 :  Find hottest country on each continent ]( ./CS_06.html ) 
   
 
  Use sf and raster to quantify maximum temperature for each country and then identify the hottest one on each continent.  
 
 <a class="btn btn-link" href="./CS_06.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i11">Preview Readings & Tasks </button><div id="i11" class="collapse">
## Readings
- Raster Vector Interactions [GCR](https://geocompr.robinlovelace.net/geometric-operations.html#raster-vector){target='blank'}

## Tasks
- Calculate annual maximum temperatures from a monthly spatio-temporal dataset
- Remove Antarctica from the `world` dataset
- Summarize raster values within polygons
- Generate a summary figure and table.
- Save your script as a .R or .Rmd in your course repository
</div>
___
## [ TK_06 :  Spatial Raster Data ]( ./TK_06.html ) 
   
 
  Gridded spatial data  
 
 <a class="btn btn-link" href="./TK_06.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i12">Preview Readings & Tasks </button><div id="i12" class="collapse">
## Readings
- Chapters [3-4 in GCR](https://geocompr.robinlovelace.net/)

## Tasks
- Quickly describe functions that seem especially useful in the README.md file for this week.
</div>
___
## [ CS_07 :  Getting Help! ]( ./CS_07.html ) 
   
 
  Learning more about finding help  
 
 <a class="btn btn-link" href="./CS_07.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i13">Preview Readings & Tasks </button><div id="i13" class="collapse">
## Readings
- How to [write a reproducible example](http://adv-r.had.co.nz/Reproducibility.html)
- Using [Reprex package](https://reprex.tidyverse.org/)

## Tasks
- Learn how to read R help files effectively
- Learn how to search for help
- Learn how to create a Minimum Working Example (MWE)
- Debug existing code
- Save your reprex to your course repository as an html file using Export -> "Save As Webpage" in the RStudio "Viewer" Tab.
</div>
___
## [ TK_07 :  Project Proposal ]( ./TK_07.html ) 
   
 
    
 
 <a class="btn btn-link" href="./TK_07.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i14">Preview Readings & Tasks </button><div id="i14" class="collapse">
## Readings
- Chapters [3-4 in GCR](https://geocompr.robinlovelace.net/)

## Tasks
- Complete project proposal and upload .Rmd and .md to Github
</div>
___
## [ CS_08 :  One Script, Many Products ]( ./CS_08.html ) 
   
 
  RMarkdown to create dynamic research outputs.  Publishing to github/word/html/etc  
 
 <a class="btn btn-link" href="./CS_08.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i15">Preview Readings & Tasks </button><div id="i15" class="collapse">
## Readings
- Browse website about [RMarkdown](https://rmarkdown.rstudio.com/index.html)
- list(`Browse [_R Markdown` = "the Definitive Guide_](https://bookdown.org/yihui/rmarkdown/)")

## Tasks
- Create a new RMarkdown Document in Rstudio with `File -> New File -> R Markdown` and save it in the case_study folder for this session
- Click "Knit" button or `File -> Knit` Document to generate an HTML document
- Adjust the YAML header to produce a HTML, Word, and PDF version of the document.
- Save the outputs in your course folder for this week
- Think about how you could use this "one document, several outputs" approach in a project and make a few notes in your README.md file for this session.
</div>
___
## [ TK_08 :  Create Final Project Webpage ]( ./TK_08.html ) 
   
 
  Data I/O. RMarkdown to create dynamic research outputs.  Publishing to github/word/html/etc  
 
 <a class="btn btn-link" href="./TK_08.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i16">Preview Readings & Tasks </button><div id="i16" class="collapse">
## Readings
- Chapters  [11, 26-30 in R4DS](http://r4ds.had.co.nz)
- Browse website about [RMarkdown](https://rmarkdown.rstudio.com/index.html)
- Browse details about creating [RMarkdown Websites](https://rmarkdown.rstudio.com/rmarkdown_websites.htm)

## Tasks
- Create repository for final project
- Explore various options for your project website
- Push changes back to GitHub
- Enable website on GitHub
- Complete DataCamp Course in [Reporting with R Markdown](https://www.datacamp.com/courses/reporting-with-r-markdown)
</div>
___
## [ TK_09 :  APIs, time-series, and weather Data ]( ./TK_09.html ) 
   
 
  Processing daily weather data from NOAA  
 
 <a class="btn btn-link" href="./TK_09.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i17">Preview Readings & Tasks </button><div id="i17" class="collapse">
## Readings
- Overview of the [GHCN Dataset](https://www.ncdc.noaa.gov/data-access/land-based-station-data/land-based-datasets/global-historical-climatology-network-ghcn)

## Tasks
- Access and work with station weather data from Global Historical Climate Network (GHCN)
- Explore options for plotting timeseries
- Trend analysis
- Compute Climate Extremes
</div>
___
## [ TK_11 :  Project First Draft ]( ./TK_11.html ) 
   
 
  Review project drafts from your peers  
 
 <a class="btn btn-link" href="./TK_11.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i18">Preview Readings & Tasks </button><div id="i18" class="collapse">
## Readings
- GitHub [Pull Requests](https://help.github.com/articles/about-pull-requests/)

## Tasks
- Commit your first draft of your project to GitHub
</div>
___
## [ CS_12 :  Dynamic HTML graph of Daily Temperatures ]( ./CS_12.html ) 
   
 
  Using DyGraph library.  
 
 <a class="btn btn-link" href="./CS_12.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i19">Preview Readings & Tasks </button><div id="i19" class="collapse">
## Readings
- Explore the [DyGraphs webpage](http://rstudio.github.io/dygraphs/)

## Tasks
- Download daily weather data for Buffalo, NY using an API
- Generate a dynamic html visualization of the timeseries.
- Save the graph using Export->Save as Webpage
</div>
___
## [ TK_12 :  Project Peer Review ]( ./TK_12.html ) 
   
 
    
 
 <a class="btn btn-link" href="./TK_12.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i20">Preview Readings & Tasks </button><div id="i20" class="collapse">
## Readings
- GitHub [Pull Requests](https://help.github.com/articles/about-pull-requests/)
- Chapter [28 in R4DS](http://r4ds.had.co.nz)

## Tasks
- Review at least two other students' projects and make comments via a _pull request_ in GitHub before next class next week. - Browse the [Leaflet website](http://rstudio.github.io/leaflet/) and take notes in your readme.md about potential uses in your project. What data could you use?  How would you display it? - Browse the [HTML Widgets page](http://gallery.htmlwidgets.org/) for many more examples. Take notes in your readme.md about potential uses in your project.
</div>
___
## [ TK_13 :  Thanksgiving Week (Tuesday Class Optional) ]( ./TK_13.html ) 
   
 
  Optional Course Workshop  
 
 <a class="btn btn-link" href="./TK_13.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i21">Preview Readings & Tasks </button><div id="i21" class="collapse">
## Readings
- NULL

## Tasks
- Continue working on final project
- Come to class with any questions
</div>
___
## [ TK_14 :  Building and summarizing models ]( ./TK_14.html ) 
   
 
  Interactive web-based visualizations  
 
 <a class="btn btn-link" href="./TK_14.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i22">Preview Readings & Tasks </button><div id="i22" class="collapse">
## Readings
- Chapter [23-25 in R4DS](http://r4ds.had.co.nz)

## Tasks
- Demonstrate a simple presence/absence model in spatial context.
- Model spatial dependence (autocorrelation) in the response.
</div>
___
## [ TK_15 :  Final Presentation ]( ./TK_15.html ) 
   
 
  Present your project to the class  
 
 <a class="btn btn-link" href="./TK_15.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i23">Preview Readings & Tasks </button><div id="i23" class="collapse">
## Readings
- Wikipedia pages about [Lightning talks](http://en.wikipedia.org/wiki/Lightning_Talk)
- Wikipedia pages about [Ignite Sessions](http://en.wikipedia.org/wiki/Ignite_(event))

## Tasks
- Prepare to give your 5 minute presentation
- Present your analysis to your roommates, significant other, etc. and update your presentation based on the feedback
- Get feedback from 2-3 fellow classmates on your presentation and update it based on their feedback
- Give your 5 minute presentation in class
</div>

