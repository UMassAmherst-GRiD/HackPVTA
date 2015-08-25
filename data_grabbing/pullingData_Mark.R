# First attempt at pulling data, inspecting its structure
# Mark Hagemann
# 8/5/15

library(httr)
library(jsonlite)

get1 <- GET('http://bustracker.pvta.com/InfoPoint/rest/stopdepartures/get/115')

str(get1)
class(get1)

dat1 <- content(get1)
str(dat1)
dat2 <- dat1[[1]]
str(dat2)
class(dat2)
names(dat2)
str(dat2$StopId)
str(dat2$StopRecordId)
str(dat2$RouteDirections)
str(dat2$LastUpdated)

rtDirs <- dat2$RouteDirections
length(rtDirs)

str(rtDirs[[1]])
str(rtDirs[[2]])

