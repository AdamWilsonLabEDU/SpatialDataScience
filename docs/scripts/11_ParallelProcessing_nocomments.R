library(knitr)
library(raster)
library(rasterVis)
library(dplyr)
library(ggplot2)

## New Packages
library(foreach)
library(doParallel)
library(arm)
library(fields)
library(snow)
x=vector()
for(i in 1:3) 
  x[i]=i^2

x
x <- foreach(i=1:3) %do% 
  i^2

x
x <- foreach(i=1:3,.combine='c') %do% 
  i^2

x
x <- foreach(i=1:3,.combine='rbind') %do% 
  i^2
x
# register specified number of workers
registerDoParallel(3)
# or, reserve all all available cores 
#registerDoParallel()		
# check how many cores (workers) are registered
getDoParWorkers() 	
## run the loop
x <- foreach(i=1:3, .combine='c') %dopar% 
  i^2
x
n <- 100000              # number of data points
x1 <- rnorm (n)          # make up x1 covariate
b0 <- 1.8                # set intercept (beta0)
b1 <- -1.5                # set beta1
p = invlogit(b0+b1*x1)
y <- rbinom (n, 1, p)  # simulate data with noise
data=cbind.data.frame(y=y,x1=x1,p=p)
kable(head(data),row.names = F,digits = 2)
ggplot(data,aes(y=x1,x=as.factor(y)))+
  geom_boxplot()+
  coord_flip()+
  geom_line(aes(x=p+1,y=x1),col="red",size=2,alpha=.5)+
  xlab("Binary Response")+
  ylab("Covariate")
size=5
sample_n(data,size,replace=T)
trials = 10000
tsize = 100

  ptime <- system.time({
  result <- foreach(i=1:trials,
                    .combine = rbind.data.frame) %dopar% 
    {
      tdata=sample_n(data,tsize,replace=TRUE)
      M1=glm(y ~ x1, data=tdata, family=binomial(link="logit"))
      ## return parameter estimates
      cbind.data.frame(trial=i,t(coefficients(M1)))
    }
  })
ptime

kable(head(result),digits = 2)
ggplot(dplyr::select(result,everything(),Intercept=contains("Intercept")))+
  geom_density(aes(x=Intercept),fill="black",alpha=.2)+
  geom_vline(aes(xintercept=b0),size=2)+
  geom_density(aes(x=x1),fill="red",alpha=.2)+
  geom_vline(aes(xintercept=b1),col="red",size=2)+
  xlim(c(-5,5))+
  ylab("Parameter Value")+
  xlab("Density")
  stime <- system.time({
  result <- foreach(i=1:trials,
                    .combine = rbind.data.frame) %do% 
    {
      tdata=sample_n(data,tsize,replace=TRUE)
      M1=glm(y ~ x1, data=tdata,family=binomial(link="logit"))
      ## return parameter estimates
      cbind.data.frame(trial=i,t(coefficients(M1)))
    }
  })
stime

n <- 10000              # number of data points
x1 <- rnorm (n)          # make up x1 covariate
b0 <- 25                # set intercept (beta0)
b1 <- -15                # set beta1
y <- rnorm (n, b0+b1*x1,10)  # simulate data with noise
data2=cbind.data.frame(y=y,x1=x1)
## assign target directory
td=tempdir()

  foreach(i=1:trials,
          .combine = rbind.data.frame) %dopar% 
    {
      tdata=sample_n(data,
                     tsize,
                     replace=TRUE)
      M1=glm(y ~ x1, 
             data=tdata,
             family=binomial(link="logit"))
      ## return parameter estimates
      results=cbind.data.frame(
      trial=i,
      t(coefficients(M1)))
      ## write results to disk
      file=paste0(td,"/results_",i,".csv")
      write.csv(results,file=file)
      return(NULL)
    }
list.files(td,pattern="results")%>%head()
simrast=function(nx=60,
                 ny=60,
                 theta=10,
                 seed=1234){
      ## create random raster with spatial structure
      ## Theta is scale of exponential decay  
      ## This controls degree of autocorrelation, 
      ## values ~1 are close to random while values ~nx/4 have high autocorrelation
     r=raster(nrows=ny, ncols=nx,vals=1,xmn=-nx/2, 
              xmx=nx/2, ymn=-ny/2, ymx=ny/2)
      names(r)="z"
      # Simulate a Gaussian random field with an exponential covariance function
      set.seed(seed)  #set a seed so everyone's maps are the same
      grid=list(x=seq(xmin(r),xmax(r)-1,
                      by=res(r)[1]),
                y=seq(ymin(r),ymax(r)-1,res(r)[2]))
      obj<-Exp.image.cov(grid=grid,
                         theta=theta,
                         setup=TRUE)
      look<- sim.rf( obj)      
      values(r)=t(look)*10
      return(r)
      }

r=simrast(nx=3000,ny=1000,theta = 100)
r
gplot(r)+
  geom_raster(aes(fill = value))+ 
  scale_fill_gradient(low = 'white', high = 'blue')+
  coord_equal()+ylab("Y")+xlab("X")
tilebuilder=function(raster,size=10,overlap=NULL){
  ## get raster extents
  xmin=xmin(raster)
  xmax=xmax(raster)
  ymin=ymin(raster)
  ymax=ymax(raster)
  xmins=c(seq(xmin,xmax-size,by=size))
  ymins=c(seq(ymin,ymax-size,by=size))
  exts=expand.grid(xmin=xmins,ymin=ymins)
  exts$ymax=exts$ymin+size
  exts$xmax=exts$xmin+size
  if(!is.null(overlap)){
  #if overlapped tiles are requested, create new columns with buffered extents
    exts$yminb=exts$ymin
    exts$xminb=exts$xmin
    exts$ymaxb=exts$ymax
    exts$xmaxb=exts$xmax
    
    t1=(exts$ymin-overlap)>=ymin
    exts$yminb[t1]=exts$ymin[t1]-overlap
    t2=exts$xmin-overlap>=xmin
    exts$xminb[t2]=exts$xmin[t2]-overlap    
    t3=exts$ymax+overlap<=ymax
    exts$ymaxb[t3]=exts$ymax[t3]+overlap
    t4=exts$xmax+overlap<=xmax
    exts$xmaxb[t4]=exts$xmax[t4]+overlap  
  }
  exts$tile=1:nrow(exts)
  return(exts)
}
jobs=tilebuilder(r,size=1000,overlap=80)
kable(jobs,row.names = F,digits = 2)
ggplot(jobs)+
  geom_raster(data=cbind.data.frame(
    coordinates(r),fill = values(r)), 
    mapping = aes(x=x,y=y,fill = values(r)))+ 
  scale_fill_gradient(low = 'white', high = 'blue')+
  geom_rect(mapping=aes(xmin=xmin,xmax=xmax,
                        ymin=ymin,ymax=ymax),
            fill="transparent",lty="dashed",col="darkgreen")+
  geom_rect(aes(xmin=xminb,xmax=xmaxb,
                ymin=yminb,ymax=ymaxb),
            fill="transparent",col="black")+
  geom_text(aes(x=(xminb+xmax)/2,y=(yminb+ymax)/2,
                label=tile),size=10)+
  coord_equal()+ylab("Y")+xlab("X")
stime2=system.time({
  r_focal1=focal(r,w=matrix(1,101,101),mean,pad=T)
  })
stime2
gplot(r_focal1)+
  geom_raster(aes(fill = value))+ 
  scale_fill_gradient(low = 'white', high = 'blue')+
  coord_equal()+ylab("Y")+xlab("X")
focal_par=function(i,raster,jobs,w=matrix(1,101,101)){
  ## identify which row in jobs to process
  t_ext=jobs[i,]
  ## crop original raster to (buffered) tile
  r2=crop(raster,extent(t_ext$xminb,t_ext$xmaxb,
                        t_ext$yminb,t_ext$ymaxb))
  ## run moving window mean over tile
  rf=focal(r2,w=w,mean,pad=T)
  ## crop to tile
  rf2=crop(rf,extent(t_ext$xmin,t_ext$xmax,
                     t_ext$ymin,t_ext$ymax))
  ## return the object - could also write the file to disk and aggregate later outside of foreach()
  return(rf2)
}
registerDoParallel(3)  	

ptime2=system.time({
  r_focal=foreach(i=1:nrow(jobs),.combine=merge,
                  .packages=c("raster")) %dopar% focal_par(i,r,jobs)
  })

identical(r_focal,r_focal1)
ncores=2
beginCluster(ncores)

fn=function(x) x^3

system.time(fn(r))
system.time(clusterR(r, fn, verbose=T))

endCluster()
cat(paste("
          library(getopt)
          ## get options
          opta <- getopt(
              matrix(c(
                  'date', 'd', 1, 'character'
              ), ncol=4, byrow=TRUE))
          ## extract value
          date=as.Date(opta$date) 
          
          ## Now your script using date as an input
          print(date+1)
          q(\"no\")
          "
          ),file=paste("script.R",sep=""))
## Rscript script.R --date 2013-11-05
## system("Rscript script.R --date 2013-11-05")
script="script.R"
dates=seq(as.Date("2000-01-01"),as.Date("2000-12-31"),by=60)
pjobs=data.frame(jobs=paste(script,"--date",dates))

write.table(pjobs,                     
  file="process.txt",
  row.names=F,col.names=F,quote=F)
pjobs
## ### Set up submission script
## nodes=2
## walltime=5
## ### write SLURM script to disk from R
## 
## cat(paste("#!/bin/sh
## #SBATCH --partition=general-compute
## #SBATCH --time=00:",walltime,":00
## #SBATCH --nodes=",nodes,"
## #SBATCH --ntasks-per-node=8
## #SBATCH --constraint=IB
## #SBATCH --mem=300
## # Memory per node specification is in MB. It is optional.
## # The default limit is 3000MB per core.
## #SBATCH --job-name=\"date_test\"
## #SBATCH --output=date_test-srun.out
## #SBATCH --mail-user=adamw@buffalo.edu
## #SBATCH --mail-type=ALL
## ##SBATCH --requeue
## #Specifies that the job will be requeued after a node failure.
## #The default is that the job will not be requeued.
## 
## ## Load necessary modules
## module load openmpi/gcc-4.8.3/1.8.4
## module load R
## 
## IDIR=~
## WORKLIST=$IDIR/process.txt
## EXE=Rscript
## LOGSTDOUT=$IDIR/log/stdout
## LOGSTDERR=$IDIR/log/stderr
## 
## ### use mpiexec to parallelize across lines in process.txt
## mpiexec -np $CORES xargs -a $WORKLIST -p $EXE 1> $LOGSTDOUT 2> $LOGSTDERR
## ",sep=""),file=paste("slurm_script.txt",sep=""))
## ## run it!
## system("sbatch slurm_script.txt")
## ## Check status with squeue
## system("squeue -u adamw")
