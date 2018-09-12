---
title: "Tasklist"
output:
  html_document:
    toc: true
    toc_depth: 1
---



Below are a set of tasks that we will work on in class (either alone or in small groups).



___
# [ CS_01 :  Create a simple, functioning script ]( ./CS_01.html ) 
 2018-08-30  
 
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
# [ CS_02 :  My grandfather says climate is cooling ]( ./CS_02.html ) 
 2018-09-06  
 
  Import data, generate and save a graphic.  
 
 <a class="btn btn-link" href="./CS_02.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i2">Preview Readings & Tasks </button><div id="i2" class="collapse">
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
# [ TK_01 :  Git-01 ]( ./TK_01.html ) 
 2018-09-06  
 
  Install Git and get organized!  
 
 <a class="btn btn-link" href="./TK_01.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i3">Preview Readings & Tasks </button><div id="i3" class="collapse">
## Readings
- Chapters [4-8 in Happy Git and Github for the useR - Installation](http://happygitwithr.com/installation-pain.html){target='blank'}

## Tasks
- Create a [GitHub account](https://github.com/join?source=header-home){target="blank"} and post your github username [here](https://goo.gl/forms/wy25GL0YWZIHplDH2)
- Install git on your computer
- Make sure git works in R-Studio
- Work through readings on git and github
- Sign up for the [GitHub Education pack](https://education.github.com/pack)
</div>
___
# [ TK_02 :  Git-02 ]( ./TK_02.html ) 
 2018-09-11  
 
  Start using Github to manage course materials  
 
 <a class="btn btn-link" href="./TK_02.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i4">Preview Readings & Tasks </button><div id="i4" class="collapse">
## Readings
- Chapters [13-15 in Happy Git and Github for the useR - Installation](http://happygitwithr.com){target='blank'}
- Overview of [Using the R-Studio GUI by R-Studio](https://support.rstudio.com/hc/en-us/articles/200532077-Version-Control-with-Git-and-SVN){target='blank'}
- Chapter [8 R for Data Science - Projects](http://r4ds.had.co.nz/workflow-projects.html){target='blank'}
- RStudio and [the Git GUI](https://www.youtube.com/watch?v=E2d91v1Twcc){target='blank'}

## Tasks
- Create a new repository for this course by following [this link](https://classroom.github.com/a/etsQwbE7).
- Create a new project in Rstudio and connect it to the new repository in GitHub (these are labeled `YEAR-GEO503-GITHUBUSERNAME`). Helpful instructions are [here](http://happygitwithr.com/rstudio-git-github.html#clone-the-new-github-repository-to-your-computer-via-rstudio)
- Update your README.md in your repository
- Stage and Commit your changes to Git (using the git tab in the upper right of RStudio)
- Push the repository up to GitHub
</div>
___
# [ CS_03 :  Wealth over time ]( ./CS_03.html ) 
 2018-09-13  
 
  Data wrangling plus more advanced ggplot  
 
 <a class="btn btn-link" href="./CS_03.html" role="button" >Full Description</a><button data-toggle="collapse" class="btn btn-link" data-target="#i5">Preview Readings & Tasks </button><div id="i5" class="collapse">
## Readings
- The [ggplot2 vignette](https://ggplot2.tidyverse.org/){target='blank'}
- R4DS [Chapter 3 - Data visualization](http://r4ds.had.co.nz/data-visualisation.html){target='blank'}
- The [Hans Rosling The River of Myths](https://youtu.be/OwII-dwh-bk){target='blank'}
- Watch the [Hons Rosling video](https://www.ted.com/talks/hans_rosling_shows_the_best_stats_you_ve_ever_seen){target="blank"}

## Tasks
- Recreate the two graphics shown using `gapminder` dataset from `library(gapminder)` (get them to match as closely as you can)
- Use `filter()` to remove "Kuwait" for reasons noted in the background
- Use `group_by()` to group by `continent` and `year`
- Use `summarize()` to calculate 1) `gdpPercapweighted.mean(x=gdpPercap,w=pop)` and 2)  pop = sum(as.numeric(pop)) that will be the data for the black continent average line on the second plot.
- Use `library(ggplot2)` and the `theme_bw()` to duplicate the first plot
- Use  `scale_y_continuous(trans = "sqrt")` to get the correct scale on the y-axis.
- Use `library(ggplot2)` and the `theme_bw()` to duplicate the second plot. You will need to use the new data you summarized to make the black lines and dots showing the continent average.
- Use `ggsave()` and save each plot as a `.png` with a width of 15 inches
- Save your script.
</div>

