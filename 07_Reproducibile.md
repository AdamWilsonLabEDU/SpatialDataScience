# Reproducible Research

# Overview

> "The goal of reproducible research is to tie specific instructions to data analysis and experimental data so that scholarship can be recreated, better understood and verified."  <small> Max Kuhn, CRAN Task View: Reproducible Research </small>


## History of reproducible research

- Mathematics (400 BC?)
- Write scientiﬁc paper, Galileo, Pasteur, etc.  (1660s?)
- Publish a pidgin algorithm and describe simulation datasets (1950s?)
- Sell magtape of code and data (1970s?)
- Place idiosyncratic dataset & software at website (1990s?)
- Publish datasets and scripts at website, eg. biology, political science, genetics, statistics (2000s?)
- Hosted integrated code and data (2020s?)

<small>Gavish & Gonoho AAAS 2011, Oxberry 2013</small>


## Motivations: <br> Claerbout's principle

> "An article about computational result is advertising, not scholarship. The actual scholarship is the full software environment, code and data, that produced the result." <small> Claerbout and Karrenbach, Proceedings of the 62nd Annual International Meeting of the Society of Exploration Geophysics. 1992</small>



## Benefits are straightforward

- **Verification & Reliability**: Find and fix bugs. Today's results == tomorrow's.
- **Transparency**: increased citation count, broader impact, improved institutional memory
- **Efficiency**: Reduces duplication of effort. Payoff in the (not so) long run
- **Flexibility**: When you don’t 'point-and-click' you gain many new analytic options.

## But limitations are substantial


**Technical**

- Classified/sensitive/big data
- Nondisclosure agreements & intellectual property 
- Software licensing issues
- Competition
- Neither necessary nor sufficient for correctness (but useful in disputes)


**Cultural & personal**

- Few follow even minimal reproducibility standards.
- Few expect reproducibility 
- No uniform standards
- Inertia & embarassment


## Our work exists on a spectrum of reproducibility
<img src="07_assets/peng-spectrum.jpg" alt="alt text" width="800">

<small>Peng 2011, Science 334(6060) pp. 1226-1227</small>


## Goal: expose more of the research workflow


<img src="07_assets/peng-pipeline.jpg" alt="alt text" width="600">

<small><small>http://www.stodden.net/AMP2011/slides/pengslides.pdf</small></small>


## Common practices of many scientists  {.columns-2}

- Enter data in Excel
- Use Excel for data cleaning & descriptive statistics
- Import data into SPSS/SAS/Stata for further analysis
- Use point-and-click options to run statistical analyses
- Copy & paste output to Word document, repeatedly

<br><br>
<br><br>
<br><br>

<small>![alt text](07_assets/lemon.png)</small>


## Common practices of many scientists {.columns-2}


- Version control is ad hoc
- Excel handles missing data inconsistently and sometimes incorrectly 
- Excel uses poor algorithms for many functions
- Scripting is possible but rare 

<br><br><br><br><br><br><br><br><br><br>

<img src="07_assets/phd-comic-vcs.gif" alt="alt text" width="400">


## Click trails are ephemeral & dangerous {.columns-2}

- Lots of human effort for tedious & time-wasting tasks
- Error-prone due to manual & ad hoc data handling
- Difficult to record -  hard to reconstruct a 'click history'
- Tiny changes in data or method require extensive reworking

<br><br><br><br>

<img src="07_assets/contrails.jpg" alt="alt text" width="400">


## Case study: Reinhart and Rogoff controversy {.columns-2}

<img src="07_assets/reinhart_rogoff_coding_error_0.png" alt="alt text" width="400">

- 2010: Claimed high debt-to-GDP ratios led to low GDP growth
- Threshold to growth at a debt-to-GDP ratio of >90%
- Substantial popular impact on autsterity politics 

<img src="07_assets/reinhart_rogoff_econ_mag.png" alt="alt text" width="250">

Excel coding error sliced several countries out of the data set....
[The Economist](http://www.economist.com/news/finance-and-economics/21576362-seminal-analysis-relationship-between-debt-and-growth-comes-under)

## Case study: Gay Marrage

#### In May 2015 _Science_ retracted a study of how canvassers can sway people's opinions about gay marriage published just 5 months ago.

* Original survey data not made available for independent reproduction of results
* Survey incentives misrepresented
* Sponsorship statement false. 

<small>- Science Editor-in-Chief Marcia McNutt</small>

Two Berkeley grad students who attempted to replicate the study quickly discovered that the data must have been faked.

[Source](http://news.sciencemag.org/policy/2015/05/science-retracts-gay-marriage-paper-without-lead-author-s-consent)

## Case study: Seizure Medicine

#### 2013 Seizure study retracted after authors realize data got "terribly mixed"

> "The article has been retracted at the request of the authors. After carefully re-examining the data presented in the article, they identified that data of two different hospitals got terribly mixed. The published results cannot be reproduced in accordance with scientific and clinical correctness."" <small> Authors of Low Dose Lidocaine for Refractory Seizures in Preterm Neonates </small>

[Source](http://retractionwatch.com/2013/02/01/seizure-study-retracted-after-authors-realize-data-got-terribly-mixed/)


## Bad spreadsheet merge kills depression paper, quick fix resurrects it
Authors informed the journal that the merge of lab results and other survey data used in the paper resulted in an error regarding the identification codes. Results of the analyses were based on the data set in which this error occurred. 

> "**Lower** levels of CSF IL-6 were associated with current depression and with future depression […]" <small>Original conclusion</small>

> "**Higher** levels of CSF IL-6 and IL-8 were associated with current depression […]" <small> Revised conclusion </small>

[Source](http://retractionwatch.com/2014/07/01/bad-spreadsheet-merge-kills-depression-paper-quick-fix-resurrects-it/)


## Scripted analyses are superior  {.columns-2}

  <img src="07_assets/open-science.png" alt="alt text" width="250px">


  - Plain text files readable for a _long_ time
  - Improved transparency, automation, maintanability, accessibility, standardisation, modularity, portability, efficiency, communicability of process (what more could we want?)
  - Steeper learning curve  



## Literate statistical programming 

> "Instead of imagining that our main task is to instruct a computer what to do, let us concentrate rather on explaining to humans what we want the computer to do." <small>Donald E. Knuth, Literate Programming, 1984</small>



For example...
Let's calculate the current time in R.

```r
time <- format(Sys.time(), "%a %d %b %X %Y")
```
The text and R code are interwoven in the output:

The time is `` `r time` ``

The time is Sun 06 Nov 21:21:29 2016



## Literate programming: for and against   {.columns-2}

**For**

- Text & code in one place, in logical order
- Tables and figures automatically updated
- Automatic test when building document


**Against**

- Text and code in one place; can be hard to read
- Can slow down the processing of documents (use caching!)

# Reproducible Research in R

## Need a programming language  {.columns-2}

The machine-readable part: R

* R: Free, open source, cross-platform, highly interactive, huge user community in academica and private sector
* R packages an ideal 'Compendium'?
* Scriptability → R
* Literate programming → R Markdown
* Version control → Git / GitHub

<img src="07_assets/r-project.jpg" alt="alt text" width="100">


> "both a container for the different elements that make up the document and its computations (i.e. text, code, data, etc.), and as a means for distributing, managing and updating the collection... allow us to move from an era of advertisement to one where our scholarship itself is published" <small>Gentleman and Temple Lang 2004</small>

## Need a document formatting language  {.columns-2}

<img src="07_assets/markdown.png" alt="alt text" width="100">

Markdown: lightweight document formatting syntax. Easy to write, read and publish as-is.

The human-readable part

`rmarkdown`: 
- minor extensions to allow R code display and execution
- embed images in html files (convenient for sharing)
- equations

e.g.

 * `*` for bullet
 * `_` for underline

## Dynamic documents in R  {.columns-2}

`knitr` - descendant of Sweave  

Engine for dynamic report generation in R

<img src="07_assets/knitr.png" alt="alt text" width="200">

<br> 

- Narrative and code in the same file or explicitly linked
- When data or narrative are updated, the document is automatically updated
- Data treated as 'read only'
- Output treated as disposable

## Pandoc: document converter  {.columns-2}


<img src="07_assets/pandoc-workflow-rmd-md.png" alt="alt text" width="100%">
<small><small><small>http://kieranhealy.org/blog/archives/2014/01/23/plain-text/ </small></small></small>

A universal document converter, open source, cross-platform

* Write code and narrative in rmarkdown   
* knitr->markdown (with computation)   
* use pandoc to get HTML/PDF/DOCX

# Version Control

## Tracking changes with version control 

**Payoffs**

- Eases collaboration
- Can track changes in any file type (ideally plain text)
- Can revert file to any point in its tracked history

**Costs**
- Learning curve


<img src="07_assets/git.png" alt="alt text" width="25%">
<img src="07_assets/github.png" alt="alt text" width="25%">
<img src="07_assets/bitbucket.png" alt="alt text" width="25%">

## Environment for reproducible research   {.columns-2}

<img src="07_assets/rstudio.png" alt="alt text" width="10%">

* integrated R console
* deep support for markdown and git
* package development tools, etc. etc.

> RStudio 'projects' make version control & document preparation simple


## Depositing code and data

**Payoffs**
- Free space for hosting (and paid options)
- Assignment of persistent DOIs
- Tracking citation metrics 

**Costs**
- Sometimes license restrictions (CC-BY & CC0)
- Limited or no private storage space


<img src="07_assets/figshare.png" alt="alt text" width="30%">
<img src="07_assets/dryad.png" alt="alt text" width="30%">
<img src="07_assets/zenodo.png" alt="alt text" width="30%">


## A hierarchy of reproducibility 

- **Good**: Use code with an integrated development environment (IDE). Minimize pointing and clicking (RStudio)
- **Better**: Use version control. Help yourself keep track of changes, fix bugs and improve project management (RStudio & Git & GitHub or BitBucket)
- **Best**: Use embedded narrative and code to explicitly link code, text and data, save yourself time, save reviewers time, improve your code. (RStudio & Git & GitHub or BitBucket & rmarkdown & knitr & data repository)

##

<img src="07_assets/VictoriaStoddenIASSISTJune2010-reasons-to.png" alt="alt text" width="800">
<small>Stodden (IASSIST 2010) sampled American academics registered at the Machine Learning conference NIPS (134 responses from 593 requests (23%). Red = communitarian norms, Blue = private incentives</small>

##

<img src="07_assets/VictoriaStoddenIASSISTJune2010-reasons.png" alt="alt text" width="800">
<small>Stodden (IASSIST 2010) sampled American academics registered at the Machine Learning conference NIPS (134 responses from 593 requests (23%). Red = communitarian norms, Blue = private incentives</small>


## Standards to normalise reproducible research

Reproducible Research Standard (Stodden 2009)

- The full compendium on the internet
- Media such as text, figures, tables with Creative Commons Attribution license (CC-BY) 
 - Code with one of Apache 2.0, MIT, LGPL, BSD, etc.
 - Original "selection and arrangement" of data with CC0 or CC-BY

## Biggest challenge: culture change

Promote culture change through positive attribution 

Implement mechanisms to indicate & encourage **degrees of compliance** (ie. clear definitions for different levels of reproducibility), cf. Stodden's:

 - **'Reproducible'**: compendium of text-code-data online
 - **'Reproduced'**: compendium available and independently reproduced 
 - **'Semi-Reproducible'**: when the full compendium is not released
 - **'Semi-Reproduced'**: independent reproduction with other data
 - **'Perpetually Reproducible'**: streaming data

## Our role in the future of reproducible research (Leveque et al 2012)

- Train students by putting homework, assignments & dissertations on the reproducible research spectrum
- Publish examples of reproducible research in our field
- Request code & data when reviewing
- Submit to & review for journals that support reproducible research
- Critically review & audit data management plans in grant proposals
- Consider reproducibility wherever possible in hiring, promotion & reference letters.


#  Demo: let's get started

[<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](07_assets/demo/Demo.Rmd).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  

## R Markdown

Cheatsheet:

<a href="https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf"> <img src="07_assets/rmarkdown.png" alt="alt text" width="400"></a>

<small><small><small>[https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf)</small></small></small>


## Create new file
**File -> New File -> RMarkdown -> Document -> HTML**

<img src="07_assets/rmarkdownwindow.png" alt="alt text" width="500">

## Step 1: Load packages

All R code to be run must be in a _code chunk_ like this:

```r
#```{r,eval=F}
CODE HERE
#```
```

Load these packages in a code chunk (you may need to install some packages):


```r
library(dplyr)
library(ggplot2)
library(maps)
library(spocc)
```

> Do you think you should put `install.packages()` calls in your script?


## Step 2: Load data

Now use the `occ()` function to download all the _occurrence_ records for the American robin (_Turdus migratorius_) from the [Global Biodiversity Information Facility](gbif.org).

<img src="07_assets/Turdus-migratorius-002.jpg" alt="alt text" width="200">

<small><small><small>Licensed under CC BY-SA 3.0 via [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Turdus-migratorius-002.jpg#/media/File:Turdus-migratorius-002.jpg)</small></small></small>


```r
## define which species to query
sp='Turdus migratorius'

## run the query and convert to data.frame()
d = occ(query=sp, from='ebird',limit = 1000) %>% occ2df()
```
This can take a few seconds.

## Step 3: Map it


```r
# Load coastline
map=map_data("world")

ggplot(d,aes(x=longitude,y=latitude))+
  geom_polygon(aes(x=long,y=lat,group=group,order=order),data=map)+
  geom_point(col="red")+
  coord_equal()
```

![](07_Reproducibile_files/figure-html/unnamed-chunk-5-1.png)<!-- -->

## Step 4:
Update the YAML header to keep the markdown file

From this:

```r
title: "Untitled"
author: "Adam M. Wilson"
date: "October 31, 2016"
output: html_document
```

To this:

```r
title: "Demo"
author: "Adam M. Wilson"
date: "October 31, 2016"
output: 
  html_document:
      keep_md: true
```

And click `knit HTML` to generate the output

## Step 5:  Explore markdown functions

1. Use the Cheatsheet to add sections and some example narrative.  
2. Try changing changing the species name to your favorite species and re-run the report. 
3. Add more figures or different versions of a figure
4. Check out the `kable()` function for tables (e.g. `kable(head(d))`)

<a href="https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf"> <img src="07_assets/rmarkdown.png" alt="alt text" width="400"></a>


##  Final

> Abandoning the habit of secrecy in favor of process transparency and peer review was the crucial step by which alchemy became chemistry.<small>Raymond, E. S., 2004, The art of UNIX programming: Addison-Wesley.</small>

## Colophon

[Slides based on Ben Marwick's presentation to the UW Center for Statistics and Social Sciences (12 March 2014)](https://github.com/benmarwick/CSSS-Primer-Reproducible-Research) ([OrcID](http://orcid.org/0000-0001-7879-4531))


Licensing: 
* Presentation: [CC-BY-3.0 ](http://creativecommons.org/licenses/by/3.0/us/)
* Source code: [MIT](http://opensource.org/licenses/MIT) 

## References

See Rmd file for full references and sources


