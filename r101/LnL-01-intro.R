# File: LnL-1-intro.R
# Author: Dmitry Gorodnichy
# Version: 0.1.2 (complete example)
# Date: 2019-10-10
# https://github.com/IVI-M/R-Ottawa/blob/master/r101/LnL-01-intro.R

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
  
  dt <-  fread("data/...20190401 20190707.tab")

  dt %>% names
  dt
  dt %>% str
  dt %>% summary

  dt[ , `Passage Date` := ymd(`Passage Date`)] 
  setnames(dt, "Passage Date", "Date")
  
  aWLOC <- dt$WLOC %>% unique; aWLOC
}

if (T) { # 2. Get small sample to work with ----
  
   if (F) { 
    # randomly sample 1000 data points
    dt1 <- dt [sample(nrow(dt), 10000)][order(PSG_REF_ID)]
  } else {
    # for selected Port and dates 
    aWLOC <- dt$WLOC %>% unique; aWLOC
    aWLOC1 <- aWLOC[1:4]; aWLOC1
    
    dateEnd <- ymd("2019-04-29")
    dateStart <- dateEnd - 7; dateStart
    
    dt1 <- dt [WLOC %in% aWLOC1 & 
                 Date <= dateEnd & Date >= dateStart]
  }
}


if (T) { #3. Compute Error rates by Date and Location ----
  dtRes <- dt1[, .(.N, 
                   N_PNC1=sum(`PNC1...`), 
                   N_PNC2=sum(`PNC2...`), 
                   N_PNC5=sum(`PNC5...`) ), 
               by=c('Date','WLOC')][, ':='(
               #by=c('Date','WLOC', 'Traveller Citizenship', 'Traveller Gender')][, ':='(
                 N_PNC1=round(N_PNC1/N*100,1),
                 N_PNC2=round(N_PNC2/N*100,1), 
                 N_PNC5=round(N_PNC5/N*100,1)
               )
               ]; 
  dtRes <- dtLocations[dtRes, on="WLOC"]
  dtRes
}

if (T) { # 4. Plot Error rates ----
  ggplot(dtRes) + 
    theme_bw() +
    #scale_color_brewer()
   
    geom_line( aes(Date, N_PNC2), col="red", size=1 ) +
    #geom_line( aes(Date, N_PNC2, col=`Traveller Gender`), col="red", size=1 ) + 
    geom_line( aes(Date, N_PNC5), col="orange", size=1 ) + 
    geom_line( aes(Date, N_PNC1), col="blue", size=1 ) + 
    #geom_line( aes(Date, N_PNC1+N_PNC2+N_PNC5), col="black", size=2 ) + 
    facet_grid(.~City) +
    labs(title="PIK performance over time" ,
         y="Failure rate (%)", 
         caption="Blue: below threshod (PNC1). Red: failure to capture (PNC2). Orange: failure to open e-chip (PNC5). Black: Combined",
         subtitle=paste0("Dates: ", dateStart, " - ", dateEnd))
  
  ggsave(paste0(dateStart, "-", dateEnd, "_PNC=f(Date,WLOC).png"), width=16, height=12)
  
  ggplot(dtRes) + 
    theme_minimal() +
    #scale_color_brewer()
    
    geom_line( aes(Date, N_PNC2), col="red", size=1 ) + 
    geom_line( aes(Date, N_PNC5), col="orange", size=1 ) + 
    geom_line( aes(Date, N_PNC1), col="black", size=1 ) + 
    #geom_line( aes(Date, N_PNC1+N_PNC2+N_PNC5), size=3 ) + 
    facet_grid(WLOC~.) +
    labs(title="Failures by WLOC (%)" ,
         subtitle="(PNC1 - black, PNC2 - red, PNC5 - orange)",
         caption=paste0("Dates: ", dateStart, "-", dateEnd))
}



# END: LnL-1-intro.R -----


  
  
 
