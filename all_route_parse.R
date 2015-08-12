visRtsToDF <- function() {
  # Parsing data from all routes and then
  # turning the data from JSON to data frame
  # format. 
  library(dplyr)
  visRts = getVisibleRoutes()
  
  rtToDF <- function(lst) {
    lst[sapply(lst, is.null)] <- NA
    as.data.frame(lst)
  }
  
  visRts_df = lapply(visRts, rtToDF)
  out = rbind_all(visRts_df)
  out
}