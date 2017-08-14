#' ---
#' title: "Parallel Computing with R"
#' ---
#' 
#' 
#'  
## ----cache=F, message=F,warning=FALSE------------------------------------
library(knitr)
library(raster)
library(rasterVis)
library(dplyr)
library(ggplot2)

## New Packages
library(foreach)
library(doParallel)
library(arm)
library(coda)
library(ggmcmc)
library(fields)
library(snow)

#' 
#' If you don't have the packages above, install them in the package manager or by running `install.packages("doParallel")`. 
#' 
#' # Introduction
#' 
#' ## Serial Computing
#' Most (legacy) software is written for serial computation:
#' 
#'   * Problem broken into discrete set of instructions
#'   * Instructions executed sequentially on a single processor
#'   
#' ![https://computing.llnl.gov/tutorials/parallel_comp/](assets/serialProblem.gif)
#' <span style="color:grey; font-size:1em;">Figure from [here](https://computing.llnl.gov/tutorials/parallel_comp/) </span>
#' 
#' ## Parallel computation
#' 
#' Parallel computing is the simultaneous use of multiple compute resources:
#' 
#'   * Problem divided into discrete parts that can be solved concurrently
#'   * Instructions from each part execute simultaneously on different processors
#'   * An overall control/coordination mechanism is employed
#' 
#' ![https://computing.llnl.gov/tutorials/parallel_comp/](assets/parallelProblem.gif)
#' <span style="color:grey; font-size:1em;">Figure from [here](https://computing.llnl.gov/tutorials/parallel_comp/) </span>
#' 
#' 
#' 
#' ## Flynn's taxonomy
#' A classification of computer architectures ([Flynn, 1972](http://dx.doi.org/10.1109/TC.1972.5009071))
#' 
#' *  *Single Instruction, Single Data (SISD)*
#'     * No parallelization
#' *  *Single Instruction, Multiple Data (SIMD)*
#'     * Run the same code/analysis on different datasets
#'     * Examples: 
#'          * different species in species distribution model
#'          * same species under different climates
#'          * different MCMC chains from a Bayesian Model
#' * *Multiple Instruction, Single Data (MISD)*
#'     * Run different code/analyses on the same data
#'     * Examples:
#'         * One species, multiple models
#' * *Multiple Instruction, Multiple Data streams (MIMD)*
#'     * Run different code/analyses on different data
#'     * Examples:
#'          * Different species & different models
#'     
#' ![http://en.wikipedia.org/wiki/Flynn%27s_taxonomy](assets/SISD.png)
#' <span style="color:grey; font-size:1em;">Figure from [here](http://en.wikipedia.org/wiki/Flynn%27s_taxonomy)</span>
#' 
#' ## Our focus: *Single Instruction, Multiple Data (SIMD)*
#' 1. Parallel functions within an R script
#'     * starts on single processor
#'     * runs looped elements on multiple 'slave' processors
#'     * returns results of all iterations to the original instance
#'     * foreach, multicore, plyr, raster
#' 2. Alternative: run many separate instances of R in parallel with `Rscript`
#'     * need another operation to combine the results
#'     * preferable for long, complex jobs
#'     * NOT planning to discuss in this session
#' 
#' ### R Packages
#' There are many R packages for parallelization, check out the CRAN Task View on [High-Performance and Parallel Computing](http://cran.r-project.org/web/views/HighPerformanceComputing.html) for an overview.  For example: 
#' 
#' * [Rmpi](http://cran.r-project.org/web/packages/Rmpi/index.html): Built on MPI (Message Passing Interface), a de facto standard in parallel computing.
#' * [snow](http://cran.r-project.org/web/packages/snow/index.html):  Simple Network of Workstations can use several standards (PVM, MPI, NWS)
#' * [parallel](https://stat.ethz.ch/R-manual/R-devel/library/parallel/doc/parallel.pdf) Built in R package (since v2.14.0).
#' 
#' ---------------
#' 
#' ## Foreach Package
#' In this session we'll focus on the foreach package, which has numerous advantages including:
#' 
#'   * intuitive `for()` loop-like syntax
#'   * flexibility of choosing a parallel 'backend' for laptops through to supercomputers (using multicore, parallel, snow, Rmpi, etc.)
#'   * nice options for combining output from parallelized jobs
#' 
#' ### Documentation for foreach:
#'  - [foreach manual](http://cran.r-project.org/web/packages/foreach/foreach.pdf)
#'  - [foreach vignette](http://cran.r-project.org/web/packages/foreach/vignettes/foreach.pdf)
#'  - [Nested Loops](http://cran.r-project.org/web/packages/foreach/vignettes/nested.pdf)
#' 
#' 
#' ### Foreach _backends_
#'  - [doParallel](http://cran.r-project.org/web/packages/doParallel/index.html) best for use on multicore machines (uses `fork` on linux/mac and `snow` on windows).
#'  - [doMPI](http://cran.r-project.org/web/packages/doMPI/vignettes/doMPI.pdf): Interface to MPI (Message-Passing Interface)
#'  - [doSNOW](http://cran.r-project.org/web/packages/doSNOW/doSNOW.pdf): Simple Network of Workstations
#' 
#' 
#' # Simple examples
#' 
#' ## _Sequential_ `for()` loop
## ------------------------------------------------------------------------
x=vector()
for(i in 1:3) x[i]=i^2
x

#' 
#' 
#' 
#' ## _Sequential_ `foreach()` loop
## ------------------------------------------------------------------------
x <- foreach(i=1:3) %do% i^2
x

#' 
#' Note that `x` is a list with one element for each iterator variable (`i`).  You can also specify a function to use to combine the outputs with `.combine`.  Let's concatenate the results into a vector with `c`.
#' 
#' ## _Sequential_ `foreach()` loop with `.combine`
## ------------------------------------------------------------------------
x <- foreach(i=1:3,.combine='c') %do% i^2
x

#' 
#' Tells `foreach()` to first calculate each iteration, then `.combine` them with a `c(...)`
#' 
#' ## _Sequential_ `foreach()` loop with `.combine`
## ------------------------------------------------------------------------
x <- foreach(i=1:3,.combine='rbind') %do% i^2
x

#' 
#' ## Your Turn
#' 
#' Write a `foreach()` loop that:
#' 
#' * generates 10 sets of 100 random values from a normal distribution (`rnorm()`)
#' * column-binds (`cbind`) them.  
#' 
#' <br><br><br><br><br><br><br><br><br><br><br><br><br><br>
#' 
#' 
#' 
#' ## _Parallel_ `foreach()` loop
#' So far we've only used `%do%` which only uses a single processor.
#' 
#' Before running `foreach()` in parallel, you have to register a _parallel backend_ with one of the `do` functions such as `doParallel()`. On most multicore systems, the easiest backend is typically `doParallel()`. On linux and mac, it uses `fork` system call and on Windows machines it uses `snow` backend. The nice thing is it chooses automatically for the system.
#' 
## ----cache=F,message=FALSE-----------------------------------------------
# register specified number of workers
registerDoParallel(3)
# or, reserve all all available cores 
#registerDoParallel()		
# check how many cores (workers) are registered
getDoParWorkers() 	

#' 
#' > _NOTE_ It may be a good idea to use n-1 cores for processing (so you can still use your computer to do other things while the analysis is running)
#' 
#' To run in parallel, simply change the `%do%` to `%dopar%`.  Wasn't that easy?
#' 
## ------------------------------------------------------------------------
## run the loop
x <- foreach(i=1:3, .combine='c') %dopar% i^2
x

#' 
#' 
#' ## A slightly more complicated example
#' 
#' In this section we will:
#' 
#' 1. Generate data with known parameters
#' 2. Fit a set of regression models using subsets of the complete dataset (e.g. bootstrapping)
#' 3. Compare processing times for sequential vs. parallel execution
#' 
#' For more on motivations to bootstrap, see [here](http://www.sagepub.com/sites/default/files/upm-binaries/21122_Chapter_21.pdf).
#' 
#' Make up some data:
## ------------------------------------------------------------------------
n <- 100000              # number of data points
x1 <- rnorm (n)          # make up x1 covariate
b0 <- 1.8                # set intercept (beta0)
b1 <- -1.5                # set beta1
p = invlogit(b0+b1*x1)
y <- rbinom (n, 1, p)  # simulate data with noise
data=cbind.data.frame(y=y,x1=x1,p=p)

#' 
#' Let's look at the data:
## ------------------------------------------------------------------------
kable(head(data),row.names = F,digits = 2)

#' 
#' 
## ------------------------------------------------------------------------
ggplot(data,aes(y=x1,x=as.factor(y)))+
  geom_boxplot()+
  coord_flip()+
  geom_line(aes(x=p+1,y=x1),col="red",size=2,alpha=.5)+
  xlab("Binary Response")+
  ylab("Covariate")

#' 
#' ### Sampling from a dataset with `sample_n()`
#' 
## ------------------------------------------------------------------------
size=5
sample_n(data,size,replace=T)

#' 
#' 
#' ### Simple Generalized Linear Model
#' 
#' This is the formal definition of the model we'll use:
#' 
#' $y_i \sim Bernoulli(p_i)$
#' 
#' $logit(p_i) = \beta_0 + \beta_1 X_i$
#' 
#' The index $i$ identifies each grid cell (data point). $\beta_0$ - $\beta_1$ are model coefficients (intercept and slope), and $y_i$ is the simulated observation from cell $i$.
#' 
## ---- eval=T-------------------------------------------------------------
trials = 10000
tsize = 100

#' 
## ------------------------------------------------------------------------
  ptime <- system.time({
  result <- foreach(i=1:trials,
                    .combine = rbind.data.frame) %dopar% {
  tdata=sample_n(data,tsize,replace=TRUE)
  M1=glm(y ~ x1, data=tdata, family=binomial(link="logit"))
  ## return parameter estimates
  cbind.data.frame(trial=i,t(coefficients(M1)))
    }
  })
ptime


#' 
#' 
#' Look at `results` object containing slope and aspect from subsampled models. There is one row per sample with columns for the estimated intercept and slope for that sample.
#' 
## ------------------------------------------------------------------------
kable(head(result),digits = 2)

#' 
## ------------------------------------------------------------------------
ggplot(dplyr::select(result,everything(),Intercept=contains("Intercept")))+
  geom_density(aes(x=Intercept),fill="black",alpha=.2)+
  geom_vline(aes(xintercept=b0),size=2)+
  geom_density(aes(x=x1),fill="red",alpha=.2)+
  geom_vline(aes(xintercept=b1),col="red",size=2)+
  xlim(c(-5,5))+
  ylab("Parameter Value")+
  xlab("Density")

#' 
#' 
#' So we were able to perform `r trials` separate model fits in `r #ptime[3]` seconds.  Let's see how long it would have taken in sequence.
#' 
## ------------------------------------------------------------------------
  stime <- system.time({
  result <- foreach(i=1:trials,
                    .combine = rbind.data.frame) %do% {
  tdata=sample_n(data,tsize,replace=TRUE)
  M1=glm(y ~ x1, data=tdata,family=binomial(link="logit"))
  ## return parameter estimates
  cbind.data.frame(trial=i,t(coefficients(M1)))
    }
  })
stime


#' 
#' So we were able to run `r trials` separate model fits in `r #ptime[3]` seconds when using `r foreach::getDoParWorkers()` CPUs and `r #stime[3]` seconds on one CPU.  That's `r #round(stime[3]/ptime[3],1)`X faster for this simple example.
#' 
#' ## Your Turn
#' 
#' * Generate some random as follows:
#' 
## ------------------------------------------------------------------------
n <- 10000              # number of data points
x1 <- rnorm (n)          # make up x1 covariate
b0 <- 25                # set intercept (beta0)
b1 <- -15                # set beta1
y <- rnorm (n, b0+b1*x1,10)  # simulate data with noise
data2=cbind.data.frame(y=y,x1=x1)

#' 
#' Write a parallel `foreach()` loop that:
#' 
#' * selects a sample (as above) with `sample_n()`
#' * fits a 'normal' linear model with `lm()`
#' * Compiles the coefficient of determination (R^2) from each model
#' 
#' Hint: see `?summary.lm`.
#' 
#' <br><br><br><br><br><br><br><br><br><br><br><br><br>
#' 
#' 
#' 
#' ### Writing data to disk
#' For long-running processes, you may want to consider writing results to disk _as-you-go_ rather than waiting until the end in case of a problem (power failure, single job failure, etc.).
#' 
## ------------------------------------------------------------------------
## assign target directory
td=tempdir()

  foreach(i=1:trials,
                    .combine = rbind.data.frame) %dopar% {
  tdata=sample_n(data,tsize,replace=TRUE)
  M1=glm(y ~ x1, data=tdata, family=binomial(link="logit"))
  ## return parameter estimates
  results=cbind.data.frame(trial=i,t(coefficients(M1)))
  
  ## write results to disk
  file=paste0(td,"/results_",i,".csv")
  write.csv(results,file=file)
  return(NULL)
    }

#' 
#' That will save the result of each subprocess to disk (be careful about duplicated file names!):
## ------------------------------------------------------------------------
list.files(td,pattern="results")%>%head()

#' 
#' ### Other useful `foreach` parameters
#' 
#'   * `.inorder` (true/false)  results combined in the same order that they were submitted?
#'   * `.errorhandling` (stop/remove/pass)
#'   * `.packages` packages to made available to sub-processes
#'   * `.export` variables to export to sub-processes
#' 
#' 
#' # Spatial example
#' In this section we will:
#' 
#' 1. Generate some _spatial_ data
#' 2. Tile the region to facilitate processing the data in parallel.
#' 2. Perform a moving window mean for the full area
#' 3. Compare processing times for sequential vs. parallel execution
#' 
#' ## Generate Spatial Data
#' 
#' A function to generate `raster` object with spatial autocorrelation.
## ------------------------------------------------------------------------
simrast=function(nx=60,ny=60,theta=10,seed=1234){
      ## create a random raster with some spatial structure
      ## Theta is the scale of an exponential decay function.  
      ## This controls degree of autocorrelation, 
      ## values close to 1 are close to random while values near nx/4 have high autocorrelation
     r=raster(nrows=ny, ncols=nx,vals=1,xmn=-nx/2, xmx=nx/2, ymn=-ny/2, ymx=ny/2)
      names(r)="z"
      # Simulate a Gaussian random field with an exponential covariance function
      set.seed(seed)  #set a seed so everyone's maps are the same
      grid=list(x=seq(xmin(r),xmax(r)-1,by=res(r)[1]),y=seq(ymin(r),ymax(r)-1,res(r)[2]))
      obj<-Exp.image.cov(grid=grid, theta=theta, setup=TRUE)
      look<- sim.rf( obj)      
      values(r)=t(look)*10
      return(r)
      }


#' 
#' Generate a raster using `simrast`.
## ------------------------------------------------------------------------
r=simrast(nx=3000,ny=1000,theta = 100)
r

#' 
#' Plot the raster showing the grid.
## ----fig.height=3--------------------------------------------------------
gplot(r)+
  geom_raster(aes(fill = value))+ 
  scale_fill_gradient(low = 'white', high = 'blue')+
  coord_equal()+ylab("Y")+xlab("X")

#' 
#' 
#' ## "Tile" the region
#' 
#' To parallelize spatial data, you often need to _tile_ the data and process each tile separately. Here is a function that will take a bounding box, tile size and generate a tiling system.  If given an `overlap` term, it will also add buffers to the tiles to reduce/eliminate edge effects, though this depends on what algorithm/model you are using.
#' 
## ------------------------------------------------------------------------
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

#' 
#' Generate a tiling system for that raster.  Here will use only three tiles (feel free to play with this).
#' 
## ------------------------------------------------------------------------
jobs=tilebuilder(r,size=1000,overlap=80)
kable(jobs,row.names = F,digits = 2)

#' 
#' 
#' Plot the raster showing the grid.
## ----fig.height=4,fig.width=9--------------------------------------------
ggplot(jobs)+
  geom_raster(aes(x=coordinates(r)[,1],y=coordinates(r)[,2],fill = values(r)))+ 
  scale_fill_gradient(low = 'white', high = 'blue')+
  geom_rect(mapping=aes(xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax),
            fill="transparent",lty="dashed",col="darkgreen")+
  geom_rect(aes(xmin=xminb,xmax=xmaxb,ymin=yminb,ymax=ymaxb),
            fill="transparent",col="black")+
  geom_text(aes(x=(xminb+xmax)/2,y=(yminb+ymax)/2,label=tile),size=10)+
  coord_equal()+ylab("Y")+xlab("X")

#' 
#' ## Run a simple spatial analysis:  `focal` moving window
#' Use the `focal` function from the raster package to calculate a 3x3 moving window mean over the raster.
## ---- fig.height=4,fig.width=9-------------------------------------------
stime2=system.time({
  r_focal1=focal(r,w=matrix(1,101,101),mean,pad=T)
  })
stime2

## plot it
gplot(r_focal1)+
  geom_raster(aes(fill = value))+ 
  scale_fill_gradient(low = 'white', high = 'blue')+
  coord_equal()+ylab("Y")+xlab("X")

#' 
#' That works great (and pretty fast) for this little example, but as the data (or the size of the window) get larger, it can become prohibitive.  
#' 
#' ## Repeat the analysis, but parallelize using the tile system.
#' 
#' First write a function that breaks up the original raster, computes the focal mean, then puts it back together.  You could also put this directly in the `foreach()` loop.
#' 
## ------------------------------------------------------------------------
focal_par=function(i,raster,jobs,w=matrix(1,101,101)){
  ## identify which row in jobs to process
  t_ext=jobs[i,]
  ## crop original raster to (buffered) tile
  r2=crop(raster,extent(t_ext$xminb,t_ext$xmaxb,t_ext$yminb,t_ext$ymaxb))
  ## run moving window mean over tile
  rf=focal(r2,w=w,mean,pad=T)
  ## crop to tile
  rf2=crop(rf,extent(t_ext$xmin,t_ext$xmax,t_ext$ymin,t_ext$ymax))
  ## return the object - could also write the file to disk and aggregate later outside of foreach()
  return(rf2)
}

#' 
#' Run the parallelized version.
## ------------------------------------------------------------------------
registerDoParallel(3)  	

ptime2=system.time({
  r_focal=foreach(i=1:nrow(jobs),.combine=merge,.packages=c("raster")) %dopar% focal_par(i,r,jobs)
  })


#' 
#' Are the outputs the same?
## ------------------------------------------------------------------------
identical(r_focal,r_focal1)

#' 
#' So we were able to process the data in `r #ptime2[3]` seconds when using `r foreach::getDoParWorkers()` CPUs and `r #stime2[3]` seconds on one CPU.  That's `r #round(stime2[3]/ptime2[3],1)`X faster for this simple example.
#' 
#' 
#' ## Parallelized Raster functions
#' Some functions in raster package also easy to parallelize.
#' 
## ------------------------------------------------------------------------
ncores=2
beginCluster(ncores)

fn=function(x) x^3

system.time(fn(r))
system.time(clusterR(r, fn, verbose=T))

endCluster()

#' 
#' Does _not_ work with:
#' 
#' * merge
#' * crop
#' * mosaic
#' * (dis)aggregate
#' * resample
#' * projectRaster
#' * focal
#' * distance
#' * buffer
#' * direction
#' 
#' 
#' # High Performance Computers (HPC)
#' _aka_ *supercomputers*, for example, check out the [University at Buffalo  HPC](https://www.buffalo.edu/ccr.html)
#' 
#' ![](assets/CCR.png)
#' 
#' Working on a cluster can be quite different from a laptop/workstation.  The most important difference is the existence of _scheduler_ that manages large numbers of individual tasks.
#' 
#' ## SLURM and R
#' 
#' You typically don't run the script _interactively_, so you need to edit your script to 'behave' like a normal `#!` (linux command line) script.  This is easy with [getopt](http://cran.r-project.org/web/packages/getopt/index.html) package. 
#' 
#' 
## ------------------------------------------------------------------------
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

#' 
#' Then you can run this script from the command line like this:
## ----eval=F--------------------------------------------------------------
## Rscript script.R --date 2013-11-05

#' You will need the complete path if `Rscript` is not on your system path.  For example, on OS X, it might be at `/Library/Frameworks/R.framework/Versions/3.2/Resources/Rscript`.
#' 
#' 
#' Or even from within R like this:
## ---- eval=F-------------------------------------------------------------
## system("Rscript script.R --date 2013-11-05",intern=T)

#' 
#' ### Driving cluster from R
#' 
#' Possible to drive the cluster from within R via SLURM.  First, define the jobs and write that file to disk:
## ------------------------------------------------------------------------
script="script.R"
dates=seq(as.Date("2000-01-01"),as.Date("2000-12-31"),by=60)
pjobs=data.frame(jobs=paste(script,"--date",dates))

write.table(pjobs,                     
  file="process.txt",
  row.names=F,col.names=F,quote=F)

#' 
#' This table has one row per task:
## ----results='markup'----------------------------------------------------
pjobs

#' 
#' Now identify other parameters for SLURM.
## ----eval=FALSE----------------------------------------------------------
## ### Set up submission script
## nodes=2
## walltime=5

#' 
#' ### Write the SLURM script
#' 
#' [More information here](https://www.buffalo.edu/ccr.html)
#'  
## ----eval=F--------------------------------------------------------------
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

#' 
#' Now we have a list of jobs and a qsub script that points at those jobs with the necessary PBS settings.
## ----eval=FALSE----------------------------------------------------------
## ## run it!
## system("sbatch slurm_script.txt")
## ## Check status with squeue
## system("squeue -u adamw")

#' 
#' For more detailed information about the UB HPC, [see the CCR Userguide](https://www.buffalo.edu/ccr/support/UserGuide.html).
#' 
#' # Summary
#' > Each task should involve computationally-intensive work.  If the tasks are very small, it can take _longer_ to run in parallel.
#' 
#' 
#' ## Choose your method
#' 1. Run from master process (e.g. `foreach`)
#'      - easier to implement and collect results
#'      - fragile (one failure can kill it and lose results)
#'      - clumsy for *big* jobs
#' 2. Run as separate R processes
#'      - see [`getopt`](http://cran.r-project.org/web/packages/getopt/index.html) library
#'      - safer for big jobs: each job completely independent
#'      - update job list to re-run incomplete submissions
#'      - compatible with slurm / cluster computing
#'      - forces you to have a clean processing script
#' 
#' 
#' ## Further Reading
#' 
#' * [CRAN Task View: High-Performance and Parallel Computing with R](http://cran.r-project.org/web/views/HighPerformanceComputing.html)
#' * [Simple Parallel Statistical Computing in R](www.stat.uiowa.edu/~luke/talks/uiowa03.pdf)
#' * [Parallel Computing with the R Language in a Supercomputing Environment](http://download.springer.com/static/pdf/832/chp%253A10.1007%252F978-3-642-13872-0_64.pdf?auth66=1415215123_43bf0cbf5ae8f5143b7ee309ff5e3556&ext=.pdf)
