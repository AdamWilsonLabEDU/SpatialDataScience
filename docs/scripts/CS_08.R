#' ---
#' title:  One Script, Many Products
#' subtitle: RMarkdown to create dynamic research outputs.  Publishing to github/word/html/etc
#' week: 8
#' type: Case Study
#' reading:
#'   - Browse website about [RMarkdown](https://rmarkdown.rstudio.com/index.html)
#'   - Browse [_R Markdown: the Definitive Guide_](https://bookdown.org/yihui/rmarkdown/)
#' tasks:
#'    - Create a new RMarkdown Document in Rstudio with `File -> New File -> R Markdown` and save it in the case_study folder for this session
#'    - Click "Knit" button or `File -> Knit` Document to generate an HTML document
#'    - Adjust the YAML header to produce a HTML, Word, and PDF version of the document. 
#'    - Save the outputs in your course folder for this week
#'    - Think about how you could use this "one document, several outputs" approach in a project and make a few notes in your README.md file for this session.
#' ---
#' 
#' 
#' # Reading
#' 
## ----reading,results='asis',echo=F---------------------------------------
md_bullet(rmarkdown::metadata$reading)

#' 
#' # Tasks
#' 
## ----tasks,results='asis',echo=F-----------------------------------------
md_bullet(rmarkdown::metadata$tasks)

