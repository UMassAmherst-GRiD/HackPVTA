# functions to pull data from the PVTA API
# Mark Hagemann
# 8/12/2015

# following slides posted on http://www.r-bloggers.com/web-scraping-working-with-apis/
# and infoPoint pdf documenting REST requests

library(rjson)

getCurrentMessages <- function() {
  baseUrl <- "http://bustracker.pvta.com/InfoPoint/rest/"
  urlAppendage <- "PublicMessages/GetCurrentMessages"
  
  queryUrl <- paste0(baseUrl, urlAppendage)
  
  lookUp <- URLencode(queryUrl)
  
  dat <- rjson::fromJSON(readLines(lookUp, warn = FALSE))
  dat
}

# foo = getCurrentMessages()


getVisibleRoutes <- function() {
  baseUrl <- "http://bustracker.pvta.com/InfoPoint/rest/"
  urlAppendage <- "routes/getvisibleroutes"
  
  queryUrl <- paste0(baseUrl, urlAppendage)
  
  lookUp <- URLencode(queryUrl)
  
  dat <- rjson::fromJSON(readLines(lookUp, warn = FALSE))
  dat
}

# foo = getVisibleRoutes()


getRoute <- function(routeID) {
  baseUrl <- "http://bustracker.pvta.com/InfoPoint/rest/"
  urlAppendage <- "routes/get/"
  
  queryUrl <- paste0(baseUrl, urlAppendage, routeID)
  
  lookUp <- URLencode(queryUrl)
  
  dat <- rjson::fromJSON(readLines(lookUp, warn = FALSE))
  dat
}


getRouteDetails <- function(routeID = "all") {
  baseUrl <- "http://bustracker.pvta.com/InfoPoint/rest/"
  urlAppendage <- ifelse(routeID == "all", "routedetails/getallroutedetails", 
                         paste0("routedetails/get/", routeID))
  
  queryUrl <- paste0(baseUrl, urlAppendage)
  lookUp <- URLencode(queryUrl)
  
  dat <- rjson::fromJSON(readLines(lookUp, warn = FALSE))
  dat
}

# foo = getRouteDetails()
# length(foo)
# str(foo, 2)

getStops <- function(stopID = "all") {
  baseUrl <- "http://bustracker.pvta.com/InfoPoint/rest/"
  urlAppendage <- ifelse(stopID == "all", "stops/getallstops", 
                         paste0("stops/get/", stopID))
  
  queryUrl <- paste0(baseUrl, urlAppendage)
  lookUp <- URLencode(queryUrl)
  
  dat <- rjson::fromJSON(readLines(lookUp, warn = FALSE))
  dat
}

# foo = getStops()
# length(foo)
# str(foo[[2]], 2)
# getStops(1000)

getDepartures <- function(stopID) {
  baseUrl <- "http://bustracker.pvta.com/InfoPoint/rest/"
  urlAppendage <- paste0("stopdepartures/get/", stopID)
  
  queryUrl <- paste0(baseUrl, urlAppendage)
  lookUp <- URLencode(queryUrl)
  
  dat <- rjson::fromJSON(readLines(lookUp, warn = FALSE))
  dat
}

# foo = getDepartures(1000)
# str(foo, 4)


getVehicles <- function(routeID = "all") {
  baseUrl <- "http://bustracker.pvta.com/InfoPoint/rest/"
  urlAppendage <- ifelse(routeID == "all", "vehicles/getallvehicles", 
                         paste0("vehicles/getallvehiclesforroute?routeID=", routeID))
  
  queryUrl <- paste0(baseUrl, urlAppendage)
  lookUp <- URLencode(queryUrl)
  
  dat <- rjson::fromJSON(readLines(lookUp, warn = FALSE))
  dat
}

# foo = getVehicles()
# length(foo)
# str(foo, 2)
# 
# getVehicles(routeID = "20030")


# convert date to POSIX datetime

toTime <- function(datestr) {
  numbstr = strsplit(datestr, "\\(|\\)")[[1]][2]
  seconds = strsplit(numbstr, "-")[[1]]
  as.POSIXct(as.numeric(seconds[1]) / 1000, origin = "1970-01-01 00:00:00")
}
# 
# foo = getVehicles(routeID = "20030")[[1]]$LastUpdated
# bar = foo
# toTime(foo)
# while (toTime(foo) == toTime(bar)) {
#   Sys.sleep(1)
#   bar = getVehicles(routeID = "20030")[[1]]$LastUpdated
# }
# toTime(foo)
# toTime(bar)


#'
#' Fetch visible routes, convert to data.frame

visRtsToDF <- function() {
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


#'
#' Function to fetch route details, put some of them into data.frame.
#' NOT ESPECIALLY USEFUL, SINCE DATA IS REDUNDANT WITH visRtsToDF
bindRtDeets <- function() {
  rtDeets = getRouteDetails()
  trimDeets<- function(lst) {
    lst <- lst[1:16]
    lst[sapply(lst, is.null)] = NA
    as.data.frame(lst[1:16])
  }
  rbind_all(lapply(rtDeets, trimDeets))
}


#'
#' Function to get route ID from a route shortname
#' 
#' @param shortname a character giving the short name, e.g. "B34", "31"
getRouteID <- function(shortname) {
  data(mostRtDetails)
  out = mostRtDetails[mostRtDetails$ShortName == shortname, "RouteId"]
  as.numeric(out)
}
