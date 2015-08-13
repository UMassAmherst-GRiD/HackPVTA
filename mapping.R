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

