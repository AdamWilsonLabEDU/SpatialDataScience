---
title: "Package Introduction"
---

# Description

Each student will be expected to introduce a package (or two) that is relevant to their research interests in a 5 minute presentation during a class session.  The objectives are:

* Learn how to find/download/install a new package and learn how to use it
* Teach your peers about existing R packages that may be useful in their research

The presentation must include:

1. Brief introduction: what does the package do and why is it useful? (**1-2 slides, 1 minute**)
2. Author introduction: a short background (affiliation and other packages, etc.) on at least one of the package authors (**1 slide, 1 minute**)
2. Simple demonstration of package code: example input/output from the examples or custom coded examples (**2-3 slides, 3 minutes**)

There will not be time to actually run any code *on-the-fly* during your presentation.  Instead, copy the code and output into a presentation (powerpoint, etc.) so that you can simply display it.  See an [example presentation here](assets/PackagePresentation.pptx).

To select a package, I recommend starting with the [views on CRAN](https://cran.r-project.org/web/views/) for a topic of interest.  Then read the narrative in the task view for something interesting to you and install the package in R with `install.package("packagename")` in R and take a look at what it can do.  Most package functions include sample code that performs a function.    For example, if I was introducing the `dplyr` package, I might choose the `filter()` function.  If you look in the help you will find a section called "Examples" that you can use for your example code in your presentation.  All you have to do is copy-paste it from the help into the R console and them summarize what it's doing in your presentation.  For example, I might demonstrate (from the `filter()` documentation) that the following code will select all characters from Star Wars that are human.


```r
library(dplyr)
filter(starwars, species == "Human")
```

```
## # A tibble: 35 x 13
##    name  height  mass hair_color skin_color eye_color birth_year gender
##    <chr>  <int> <dbl> <chr>      <chr>      <chr>          <dbl> <chr> 
##  1 Luke…    172    77 blond      fair       blue            19   male  
##  2 Dart…    202   136 none       white      yellow          41.9 male  
##  3 Leia…    150    49 brown      light      brown           19   female
##  4 Owen…    178   120 brown, gr… light      blue            52   male  
##  5 Beru…    165    75 brown      light      blue            47   female
##  6 Bigg…    183    84 black      light      brown           24   male  
##  7 Obi-…    182    77 auburn, w… fair       blue-gray       57   male  
##  8 Anak…    188    84 blond      fair       blue            41.9 male  
##  9 Wilh…    180    NA auburn, g… fair       blue            64   male  
## 10 Han …    180    80 brown      fair       brown           29   male  
## # ... with 25 more rows, and 5 more variables: homeworld <chr>,
## #   species <chr>, films <list>, vehicles <list>, starships <list>
```




