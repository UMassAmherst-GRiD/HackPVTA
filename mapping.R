# Mapping bus locations

# try using ggmap package
library(ggplot2)
library(ggmap)
mapdata = get_map(location = c(lon = median(vehicDF$Longitude), 
                               lat = median(vehicDF$Latitude)),
                  color = "color", source = "google", maptype = "terrain", zoom = 10)

g1 = ggmap(mapdata, extent = "device", ylab = "latitude", xlab = "longitude")
g1 + geom_point(data = vehicsToDf(), aes(x = Longitude, y = Latitude), color = "red", size = 2)

# Try using leaflet package
# install.packages("leaflet")
library(leaflet)
library(htmltools)

busIcon <- makeIcon("data/icons/bus.png", iconWidth = 17, iconHeight = 17)

m = vehicsToDf() %>%
  filter(Longitude > -74) %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, popup = htmlEscape(~Name), icon = busIcon)
m


# Try plotting a path taken by a bus, using accumulated data
load("data/busLocations/800.rda")
l800 <- locations800
head(l800)
length(unique(l800$VehicleId))
getRouteID(unique(l800RouteID))

l8 <- l800 %>%
  mutate(LastUpdated = toTime(LastUpdated)) %>%
  left_join(mostRtDetails, by = "RouteId")

head(l8)
glimpse(l8)
unique(l8$LongName)

l8 %>%
  dplyr::filter(ShortName == "B43") %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, popup = htmlEscape(~LastUpdated), icon = busIcon)

# How often was the location updated?
b43 <- l8 %>%
  dplyr::filter(ShortName == "B43")
tdifs = diff(b43$LastUpdated, units = "sec")  
hist(as.numeric(tdifs))
qqnorm(tdifs)

head(l8$LastStop)


# Are the buses done running yet?
load("data/busLocations/3000.rda")
l3 <- locations3000 %>%
  mutate(LastUpdated = toTime(LastUpdated))
vehicsToDf() %>% 
  filter(Longitude > -74) %>%
  leaflet() %>%
  addTiles() %>%
  addMarkers(~Longitude, ~Latitude, popup = htmlEscape(~Name), icon = busIcon)
mostRtDetails %>% 
  dplyr::filter(RouteId == 20030)

getCurrentMessages()
