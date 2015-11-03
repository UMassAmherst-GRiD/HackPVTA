# load dependencies

if(!require(devtools)) {
  install.packages(devtools)
  library(devtools)
}

if(!require(dplyr)) {
  install.packages(dplyr)
  library(dplyr)
}

if(!require(ggplot2)) {
  install.packages(ggplot2)
  library(ggplot2)
}
  
# Install rpvta package from GitHub
install_github("UMassAmherst-GRiD/rpvta")
library(rpvta)

source("assembleData.R")

# Look at the data!
glimpse(locs)

# Neat map of the current bus locations:
leafletBusLocs() # this requires installing the leaflet package.

# Do stuff with the data!
# For example: a histogram of B43 early/lateness to Haigis Mall:
locs %>%
  filter(RouteId == 30043, LastStop == "Haigis Mall") %>%
  #   glimpse()
  ggplot(aes(x = Deviation)) + 
  geom_histogram(binwidth = 5)

