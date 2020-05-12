# R101
# 01-read.R
# https://github.com/IVI-M/R-Ottawa/new/master/r101
# Last updated: 10 May 2020

# 0. General libraries and functions ----

# print(sessionInfo())
# source("000-common.R")

if (T) { 
  library(data.table)
  options(datatable.print.class=TRUE)
  library(magrittr)
  library(lubridate)
  library(ggplot2)
  
  STR_TOTAL <- "...COMBINED..."
}



# 0.1 My functions ----


readCovidUS <- function() {
  
# read confirmed data
  dt <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv", stringsAsFactors = T )
  dt %>% names
  dt[1:2]
  dt[.N, 1:12]
  dt[c(1:2, (.N-1):.N), 1:12]
  cols <- c ( 1:5, 8:11 ) ;
  dt [ ,(cols):=NULL] ;   
  dtUSc <- dt %>% melt(id=1:2);   
  dtUSc[c(1,.N)]
  setnames(dtUSc, c("city", "state", "date", "confirmed"));dtUSc [c(1,.N)]
  setkeyv (dtUSc, c("date", "state", "city") )
  
# read deaths data  
  dt <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv", stringsAsFactors = T )
# ...  
  cols <- c ( 1:5, 8:12 ) ;
  dt [ ,(cols):=NULL] ;   
  dtUSd <- dt %>% melt(id=1:2);   
  setnames(dtUSd, c("city", "state", "date", "deaths"))
  setkeyv (dtUSd, c("date", "state", "city") )

# merge two data sets;  
  
  dtUS <- merge(dtUSc, dtUSd, by =  c("city", "state", "date") )
# OR
#  dtUS <- dtUSc [dtUSd]

  dtUS [, date := as.character(date) %>% mdy ]

  dtUS$country <- "US"
  dtUS$recovered <- NA
  dtUS[ city == "", city:=STR_TOTAL]
  setcolorder(dtUS, c("date", "country", "state", "city", "confirmed", "deaths", "recovered" ))
  
  
  dtUS %>% summary
  
  dateMax <- dtUS$date %>% max()
  dtUS$state %>% unique
  
  dtUS[date==dateMax]
  dtUS[confirmed > 10000]
  
  dtUS[confirmed > 100000 & state=='New York']
  
  return (dtUS)
}


readGeo <- function() {
 
  dtGeo <- fread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv") 
  
  cols <- c("UID"  , "iso2" ,   "iso3"  ,   "code3", "FIPS", "Combined_Key")
  dtGeo [ ,(cols):=NULL] ;  
  dtGeo %>% setnames(c("city", "state", "country", "lat", "lng", "population")) 
  
  dtGeo[ state == "", state:=STR_TOTAL]
  dtGeo[ city == "", city:=STR_TOTAL]
  
  setcolorder(dtGeo, c( "country" , "state" , "city" , "lat", "lng" , "population"  ) )
  return(dtGeo)
}




#  1.0 Reading data   ----

dtGeo <- readGeo()
dtGeo[city == 'New York']
dtGeo[state == 'New York']

# lets fix it !

dtUS <- readCovidUS()

#  1.1 Merging data   ----

dt <- dtUS[city == 'New York']
dt <- dtUS[state == 'New York']

dt <- dtGeo [dt, on=c("country" , "state" , "city")]

dt 
#  1.2 New-York example   ----



# 2. Plotting

dtUS[city == 'New York'][ date > dateMax - 30] %>% 
  ggplot() + 
  facet_wrap(city ~ .) +
  geom_line(aes(date, confirmed), col="orange") +
  geom_line(aes(date, deaths), col="red") 


dtUS[, sum(confirmed),  by=state]


