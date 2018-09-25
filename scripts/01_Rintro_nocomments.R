x=1
x
x=c(5,8,14,91,3,36,14,30)
x
x+2
## X
## Error: object 'X' not found
x
x[5]
1:5
x[1:5]
(5+8+14+91+3+36+14+30)/8
mean(x)
x1= sum(x)
x2=length(x)
x1/x2
mymean=function(f){
  sum(f)/length(f)
}

mymean(f=x)
mean(x)
x3=c(5,8,NA,91,3,NA,14,30,100)
mymean(x3)
mean(x3)
mean(x3,na.rm=T)
  x

  x3 > 75
 
  x3 == 40
 
  x3 >   15
sum(x3>15,na.rm=T)
result =  x3 >  3
result
x3
mycount(x3)
x3
mycount(x3)
seq(from=0, to=1, by=0.25)
a=rnorm(100,mean=0,sd=10)
hist(a)
y=matrix(1:9,ncol=3)
y
y+2
y[2,3]
data = data.frame( x = c(11,12,14),
                   y = c("a","b","b"),
                   z = c(T,F,T))
data
mean(data$x)

mean(data[["x"]])

mean(data[,1])
library(ggplot2)
