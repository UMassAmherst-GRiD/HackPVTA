# Getting snapshots of the data 
# on specific time increments and then saving those to a 
# file. 

# WARNING : Not yet debugged. 

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

min_sleep <- function (time){
  # Delay execution for a specific amount of minutes
  Sys.sleep(time*60)
}


# Number of data calls to take 
data_calls_num = 3

# Time to wait between sampling (in mins)
wait = 0.1

# Number of times to iterate before you dump data to file
dump = 1

data <- vector(mode="list",length = data_calls_num)

j = 1 

for (i in 1:data_calls_num){
  # Call for new data and append to list.
  data[j] <- visRtsToDF()
  
  if(i%%dump == 0){
    # Every dump iterations, dump data to a file
#      lapply(data, write, "pvta_route_data.txt", append=TRUE)
 #     j = 0      
  }
  
  j = j+1 # Move to next element
 # min_sleep(wait) 
}
