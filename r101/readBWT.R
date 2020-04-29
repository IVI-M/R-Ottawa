# readBWT.R
# DG

#. dtNow: read current BWT ----

readNow <- function()  {
  strUrl <- "http://www.cbsa-asfc.gc.ca/bwt-taf/bwt-eng.csv"
  dtNow <<- fread(strUrl, stringsAsFactors = T, header=T)
  
  cols <- c("V2", "V4", "V6", "V8", "V10", "V12", "V14", "V15")
  dtNow [, (cols):=NULL]
  # dtNow %>% summary()
  # dtNow %>% names
  # dtNow[1:3]  
  names(dtNow) <- c("OFFICE",  "LOCATION",   "TIME",  "commercial",  "commercial_US", "traveller", "traveller_US") 
  
  
  #  dt.cleanBWT.byreference(dtNow)
  
  numcols =  c("commercial",  "traveller")
  dtNow[, (numcols) := lapply(.SD, cleanEntries), .SDcols = numcols] 
  dtNow[, (numcols) := lapply(.SD,function(x)(as.numeric(as.character(x)))), .SDcols = numcols]
  dtNow[, (numcols) := lapply(.SD, roundByInt), .SDcols = numcols]
  
  dtNow[, TIME := as.POSIXct(TIME, format = "%Y-%m-%d %H:%M ") ]
  # dtNow[, TIME := roundByMins(TIME)]
  
  return(dtNow)
}
if (F) 
  readNow()
  
  
  
#. dtPast: read past BWT ----

readPast <- function()  {
  if (T) { 
    dtPast <<-  readRDS ("dtPast-2010-2018.rds")
    
    return(dtPast)
  }else {
    
    if (F) {
      strUrl <- "http://www.cbsa-asfc.gc.ca/data/bwt-taf-2010-2014-eng.csv"
      dtPast <- fread(strUrl, stringsAsFactors = F, header=T) # 68.1 Mb
      names(dtPast) <- c("OFFICE", "LOCATION", "TIME", "commercial",  "traveller")
      
      
    }
    
    dtPast <<- NULL
    y=2018; q=1
    for (y in 2014:2018) { # Data available only for: 2014 Q2 - 2018 Q1
      #for (y in 2017:2017) {
      for (q in 1:4) {
        strUrl <- sprintf("http://cbsa-asfc.gc.ca/data/bwt-taf-%i-%02i-01--%i-%02i-31-en.csv", 
                          y, 3*(q-1)+1,y, 3*q); strUrl %>% print
        dt <- try(fread(strUrl, stringsAsFactors = T, header=T), T) # (5.1 MB)
        
        if (is.data.frame(dt) == F) {
          strUrl <- sprintf("http://cbsa-asfc.gc.ca/data/bwt-taf-%i-%02i-01--%i-%02i-30-en.csv", 
                            y, 3*(q-1)+1,y, 3*q); strUrl %>% print
          dt <- try(fread(strUrl, stringsAsFactors = T, header=T), T) # (5.1 MB)  
        }
        if (is.data.frame(dt) == F) 
          next
        
        names(dt) <- c("OFFICE",  "LOCATION",   "TIME",  "commercial",  "traveller")
        dtPast <<- dt %>% rbind(dtPast)
      }
    }
    
    
    dt.cleanBWT.byreference(dtPast)
    
    
    # not needed, once dtPort is created. We index by OFFICE
    dtPast$LOCATION <- NULL
    
    if (F) {
      dtPast %>% summary
      dtPast$traveller %>% unique()
      dtPast[1:3]
    }
    saveRDS(dtPast, "dtPast-2017.rds")
    saveRDS(dtPast, "dtPast-2014-2018.rds")
    saveRDS(dtPast, "dtPast-2010-2014.rds")
    dt <- dtPast  %>% rbind(readRDS("dtPast-2014-2018.rds"))
    setkey(dt,OFFICE,TIME)
    saveRDS(dt, "dtPast-2010-2018.rds")
    # fwrite (dtPast, "dtPast-2014-2018.csv", sep="\t")
    #fwrite (dtPast, "dtPast-2017.csv", sep="\t")
    
  }
  
}

