# Script to pull bus location data, save periodically 

dir.create("data/busLocations")
curdf <- data.frame()
olddf <- data.frame()
i = 0
while(TRUE) {
  # increment counter
  i = i + 1
  
  # get positions
  newdf <- vehicsToDf()
  # Check for duplicates against most recent data
  dupls <- duplicated(rbind(olddf, newdf))[-1:-nrow(olddf)]
  
  # replace most recent
  olddf = newdf
  
  # remove redundant rows, rbind to master
  curdf <- rbind(curdf, newdf[!dupls, ])
  
  # sleep for 20 seconds
  Sys.sleep(20)
  
  # print status every 10 requests
  if(i %% 10 == 0) {
    cat(i)
    cat(" ")
  }
  
  # Write to disk every 500 requests (about 3 1/3 hours)
  if (i %% 500 == 0) {
    # give curdf a new name to distinguish it from others
    assign(paste0("locations", i), curdf)
    # save to disk
    save(list = paste0("locations", i), 
         file = paste0("data/busLocations/", i, ".rda"))
    rm(list = paste0("locations", i))
    # reset curdf
    curdf = data.frame()
  }
}