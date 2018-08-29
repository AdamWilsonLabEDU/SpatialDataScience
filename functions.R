
library(rmarkdown)
library(yaml)

## md_bullet turns a vector in a markdown formated list
md_bullet<-function(x) cat(paste('-', x), sep = '\n') 

## extract YAML metata from a file and adds some additional fields
yaml_extract=function(file){
  yaml=scan(file,what = "char",skip=1,sep="\n",quiet = T)
  yaml2=paste(yaml[1:(which(yaml=="---")-1)],collapse="\n")
  yaml2=paste(yaml[1:(which(yaml=="---")-1)])
  yaml3=read_yaml(text=yaml2)
  yaml3$file=file
  yaml3$file2=sub("[.]Rmd","",basename(file))
  yaml3$type=sub("_.*","",yaml3$file2)
  yaml3$number=as.numeric(sub("^.*_","",yaml3$file2))
  yaml3$url=paste(sub("[.]Rmd",".html",yaml3$file))
  return(yaml3)
}

## Extract YAML from an entire directory
yaml_dir=function(files=NULL,dir=NULL){
  if(!is.null(dir)) files=list.files(dir,pattern="^CS_.*Rmd",full=T)
  if(is.null(files)&is.null(dir)) files=list.files(pattern="^CS_.*Rmd",full=T)
  lapply(files,FUN=yaml_extract)
}
