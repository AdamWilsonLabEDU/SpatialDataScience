knitr::opts_chunk$set(cache=T,
                      fig.width=7,
                      fig.height=4,
                      dpi=300,
                      dev="png",
                      tidy=FALSE, 
                      tidy.opts=list(width.cutoff=75))
options(knitr.duplicate.label = 'allow')

presentation_theme <- ggplot2::theme_grey()+
                ggplot2::theme(
                  text = ggplot2::element_text(size = 25, colour = "black"))
  
ggplot2::theme_set(presentation_theme)
  
## Purl to a  .R version
input  = knitr::current_input()  # filename of input document
output = file.path("scripts",paste(tools::file_path_sans_ext(input), 
                                  'R', sep = '.'))
output_nocomment = file.path("scripts",paste0(tools::file_path_sans_ext(input), 
                                   '_nocomments.R'))
knitr::purl(input,output,documentation=2,quiet=F,envir=new.env())
knitr::purl(input,output_nocomment,documentation=0,quiet=F,envir=new.env())
file.copy(input,file.path("scripts/",input)) # also copy .Rmd to script folder.
  