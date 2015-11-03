# assembleData.R
# Puts all location data frames from data/busLocations/ into a single data.frame.

dataFiles <- list.files("data/busLocations/", recursive = FALSE, 
                        pattern = "\\.rda", ignore.case = TRUE,
                        full.names = TRUE, include.dirs = FALSE)

# Make an empty environment in which to store the individual data frames obtained from `load`
locenv <- new.env()

# `load` the saved objects
lapply(dataFiles, load, envir = locenv, verbose = TRUE)

# get information that we'll join to locs (this is a saved object in the rpvta package)
data(mostRtDetails)

# combine all the data frames into one
locs <- dplyr::bind_rows(as.list(locenv)) %>%
  left_join(mostRtDetails[2:6], by = "RouteId")


