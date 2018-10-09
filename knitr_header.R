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
fullinput=file.path("scripts",input)
file.copy(input,fullinput) # also copy .Rmd to script folder.

presframe=function(path=rmarkdown::metadata$presentation,prefix="presentations"){ 
  paste0("
<div class='extraswell'>
  <button data-toggle='collapse' class='btn btn-link' data-target='#pres'>View Presentation </button>      [Open presentation in a new tab](",file.path(prefix,path),"){target='_blank'}
<div id='pres' class='collapse'>
<div class='embed-responsive embed-responsive-16by9'>
  <iframe class='embed-responsive-item' src='",file.path(prefix,path),
   "' allowfullscreen></iframe>
  _Click on presentation and then use the space bar to advance to the next slide
   or escape key to show an overview._
</div>
</div>
</div>
")}


output_table=function(){
  paste(
"| [<i class='fas fa-code fa-2x' aria-hidden='true'></i><br>  R Script](",output_nocomment,") | [<i class='fa fa-file-code-o fa-2x'></i> <br> Commented R Script](",output,") | [<i class='far fa-file-alt fa-2x'></i> <br>  Rmd Script](",fullinput,")|
|:--:|:-:|:-:|",collapse="")}
