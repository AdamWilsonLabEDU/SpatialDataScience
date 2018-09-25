library(tidyverse)
library(nycflights13)
head(flights)
glimpse(flights)
select(flights,year, month, day)
select(flights,-tailnum)
select(flights,contains("time"))
select(flights,year,carrier,destination=dest)
filter(flights, month == 1, day == 1)
flights[flights$month == 1 & flights$day == 1, ]
## filter(flights, month == 1, day == 1)
filter(flights, month == 1 | month == 2)
slice(flights, 1:10)
arrange(flights, year, month, day)
## flights[order(flights$year, flights$month, flights$day), ]
arrange(flights, desc(arr_delay))
## flights[order(desc(flights$arr_delay)), ]
distinct(
  select(flights,carrier)
)
mutate(flights,ave_speed=distance/(air_time/60))%>%
  select(distance, air_time,ave_speed)
a1 <- group_by(flights, year, month, day)
a2 <- select(a1, arr_delay, dep_delay)
a3 <- summarise(a2,
                arr = mean(arr_delay, na.rm = TRUE),
                dep = mean(dep_delay, na.rm = TRUE))
a4 <- filter(a3, arr > 30 | dep > 30)
head(a4)
filter(
  summarise(
    select(
      group_by(flights, year, month, day),
      arr_delay, dep_delay
    ),
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ),
  arr > 30 | dep > 30
)
flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ) %>%
  filter(arr > 30 | dep > 30)
flights %>%
  group_by(origin) %>%
  summarise(meanDelay = mean(dep_delay,na.rm=T))
flights %>% 
  group_by(carrier) %>%  
  summarise(meanDelay = mean(dep_delay,na.rm=T),
            sdDelay =   sd(dep_delay,na.rm=T))
