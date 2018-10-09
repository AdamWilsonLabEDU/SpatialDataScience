library(tidyverse)
library(reprex)
mpg%>%
  ggplot(aes(x=drv, y=trans))%>%
  geom_point(aes(color=class))%>%
  geom_smooth()

data=data.frame(x=c(1,2),y=c(1,2),z=c(1.5,1.5))
ggplot(data,aes(x=x,y=y,color=z)) +
geom_point()
