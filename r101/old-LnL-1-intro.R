
# File: LnL-1-intro.R
# Author: Gorodnichy
# Version: 0.1.2 (simpler)

if (T) { # Start ----
  library(magrittr)
  library(ggplot2)
  library(data.table)
  library(lubridate)
}



if (T) { # 1. Read and merge/bind data  ----
  
  dtLocations<- fread("data/wloc-index.txt")
  dtLocations %>% names()
  dtLocations$Vendor <- NULL
  dtLocations
  dtLocations[WLOC == 4313, WLOC:=4312][]
  
dt <-  fread("data/PIK Extract  - Passage Details 20190401 20190707.tab")

   dt %>% names
  dt
  dt %>% str
dt %>% summary

  dt[ , `Passage Date` := ymd(`Passage Date`)]


  
}

if (T) { # 2. Get small sample to work with ----
  
  
  aWLOC <- dt$WLOC %>% unique; aWLOC
    aWLOC1 <- aWLOC[1:4]; aWLOC1
    

    dateEnd <- ymd("2019-04-29")
    dateStart <- dateEnd - 7; dateStart
    
    dt1 <- dt [WLOC %in% aWLOC1 & 
                 Date <= dateEnd & Date >= dateStart]

  



}




# END: LnL-1-intro.R -----


  
  
 
