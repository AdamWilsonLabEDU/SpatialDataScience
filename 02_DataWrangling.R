## ----results='hide', message=FALSE, warning=F----------------------------
library(dplyr)
library(tidyr)

## ----results='hide', warning=F-------------------------------------------
library(nycflights13)

## ------------------------------------------------------------------------
head(flights)

## ------------------------------------------------------------------------
glimpse(flights)

## ------------------------------------------------------------------------
select(flights,year, month, day)

## ------------------------------------------------------------------------
select(flights,-tailnum)

## ------------------------------------------------------------------------
select(flights,contains("time"))

## ------------------------------------------------------------------------
select(flights,year,carrier,destination=dest)

## ------------------------------------------------------------------------
filter(flights, month == 1, day == 1)

## ------------------------------------------------------------------------
flights[flights$month == 1 & flights$day == 1, ]

## ----eval=F--------------------------------------------------------------
## filter(flights, month == 1, day == 1)`

## ------------------------------------------------------------------------
filter(flights, month == 1 | month == 2)

## ------------------------------------------------------------------------
slice(flights, 1:10)

## ------------------------------------------------------------------------
arrange(flights, year, month, day)

## ----eval=F--------------------------------------------------------------
## flights[order(flights$year, flights$month, flights$day), ]

## ------------------------------------------------------------------------
arrange(flights, desc(arr_delay))

## ----eval=F--------------------------------------------------------------
## flights[order(desc(flights$arr_delay)), ]

## ------------------------------------------------------------------------
distinct(
  select(flights,carrier)
)

## ------------------------------------------------------------------------
select(
  mutate(flights,ave_speed=distance/(air_time/60)),
  distance, air_time,ave_speed)

## ------------------------------------------------------------------------
a1 <- group_by(flights, year, month, day)
a2 <- select(a1, arr_delay, dep_delay)
a3 <- summarise(a2,
                arr = mean(arr_delay, na.rm = TRUE),
                dep = mean(dep_delay, na.rm = TRUE))
a4 <- filter(a3, arr > 30 | dep > 30)
head(a4)

## ------------------------------------------------------------------------
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

## ------------------------------------------------------------------------
flights %>%
  group_by(year, month, day) %>%
  select(arr_delay, dep_delay) %>%
  summarise(
    arr = mean(arr_delay, na.rm = TRUE),
    dep = mean(dep_delay, na.rm = TRUE)
  ) %>%
  filter(arr > 30 | dep > 30)

## ------------------------------------------------------------------------
flights %>%
  group_by(origin) %>%
  summarise(meanDelay = mean(dep_delay,na.rm=T))

## ------------------------------------------------------------------------
flights %>% 
  group_by(carrier) %>%  
  summarise(meanDelay = mean(dep_delay,na.rm=T),
            sdDelay =   sd(dep_delay,na.rm=T))

## ------------------------------------------------------------------------
flights%>%
  select(-year,-month,-day,-hour,-minute,-dep_time,-dep_delay)%>%
  glimpse()

## ------------------------------------------------------------------------
glimpse(airports)

## ---- result=F, warning=F------------------------------------------------
library(geosphere)
library(maps)
library(ggplot2)
library(sp)
library(rgeos)

## ------------------------------------------------------------------------
data=
  select(airports,
         dest=faa,
         destName=name,
         destLat=lat,
         destLon=lon)%>%
  right_join(flights)%>%
  group_by(dest,
           destLon,
           destLat,
           distance)%>%
  summarise(count=n())%>%
  ungroup()%>%
  select(destLon,
         destLat,
         count,
         distance)%>%
  mutate(id=row_number())%>%
  na.omit()

NYCll=airports%>%filter(faa=="JFK")%>%select(lon,lat)  # get NYC coordinates

# calculate great circle routes
rts <- gcIntermediate(as.matrix(NYCll),
                      as.matrix(select(data,destLon,destLat)),
                      1000,
                      addStartEnd=TRUE,
                      sp=TRUE)
rts.ff <- fortify(
  as(rts,"SpatialLinesDataFrame")) # convert into something ggplot can plot

## join with count of flights
rts.ff$id=as.integer(rts.ff$id)
gcircles <- left_join(rts.ff,
                      data,
                      by="id") # join attributes, we keep them all, just in case


## ----fig.width=10,fig.height=6,dpi=300-----------------------------------
base = ggplot()
worldmap <- map_data("world",
                     ylim = c(10, 70),
                     xlim = c(-160, -80))
wrld <- c(geom_polygon(
  aes(long, lat, group = group),
  size = 0.1,
  colour = "grey",
  fill = "grey",
  alpha = 1,
  data = worldmap
))

## ------------------------------------------------------------------------
base + wrld +
  geom_path(
    data = gcircles,
    aes(
      long,
      lat,
      col = count,
      group = group,
      order = as.factor(distance)
    ),
    alpha = 0.5,
    lineend = "round",
    lwd = 1
  ) +
  coord_equal() +
  scale_colour_gradientn(colours = c("blue", "orange", "red"),
                         guide = "colourbar") +
  theme(panel.background = element_rect(fill = 'white', colour = 'white')) +
  labs(y = "Latitude", x = "Longitude",
       title = "Count of Flights from New York in 2013")

