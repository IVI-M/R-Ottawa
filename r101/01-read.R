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
}

STR_TOTAL <- "...COMBINED..."

# 0.1 My functions ----

readGeo <- function() {
  dt <- fread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv") 
  dt[c(1,3)]
  dt[.N]
  dt[c(1:2, (.N-1):.N), 1:3]
  cols <- c("UID"  , "iso2" ,   "iso3"  ,   "code3", "FIPS", "Combined_Key")
  dt [ ,(cols):=NULL] ;  
  dt %>% setnames(c("city", "state", "country", "lat", "lng", "population")) 
  
  dt
  dt[ state == "", state:=STR_TOTAL]
  dt[ city == "", city:=STR_TOTAL]
  
  setcolorder(dt, c( "country" , "state" , "city" , "lat", "lng" , "population"  ) )
  dt
}

readCovidUS <- function() {
  # read confirmed data
  dt <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv", stringsAsFactors = T )
  dt %>% names
  dt[.N]
  dt[.N, 1:12]
  dt[c(1:2, (.N-1):.N), 1:12]
  cols <- c ( 1:5, 8:11 ) ;
  dt [ ,(cols):=NULL] ;   
  dtUSc <- dt %>% melt(id=1:2);   
  dtUSc[c(1,.N)]
  setnames(dtUSc, c("city", "state", "date", "confirmed"));dtUSc [c(1,.N)]
  setkeyv (dtUSc, c("date", "state", "city") )
  dtUSc
  
  # read deaths data  
  dt <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv", stringsAsFactors = T )
  # ...  
  cols <- c ( 1:5, 8:12 ) ;
  dt [ ,(cols):=NULL] ;   
  dtUSd <- dt %>% melt(id=1:2);   
  setnames(dtUSd, c("city", "state", "date", "deaths"))
  setkeyv (dtUSd, c("date", "state", "city") )
  dtUSd
  # merge two data sets;  
  
  dtUS <- merge(dtUSc, dtUSd, by =  c("city", "state", "date") )
  dtUS
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
  dtUS [state=='New York']$city %>% unique()
  
  dtUS[date==dateMax]
  dtUS[confirmed > 10000]
  dtUS[confirmed > 100000 & state=='New York']

  
  return (dtUS)
}




TEST_ME <- function() {
  
  #  1.0 Reading data   ----
  
  dtGeo <- readGeo()
  dtGeo[city == 'New York']
  dtGeo[state == 'New York']
  dtGeo[state == 'New York']$city
  
  # lets fix it !
  dtGeo[city == 'New York City', city:='New York']
  
  dtUS <- readCovidUS()
  dateMax <- dtUS$date %>% max
  
  dtUS$recovered <- NULL
  
  #  1.1 New-York example   ----
  
  dtUS[state == 'New York']$city %>% unique

  city <- "Suffolk"
  city <- "New York"
  
  dtUS[city == 'New York'][date==dateMax]
  dtUS[state == 'New York' & date==dateMax]
  
  dt <- dtUS[state == 'New York'][date==dateMax][order(-confirmed)][1:3];
  dt
  aCities <- dt$city ; 
  aCities
  dt <- dtUS [state == 'New York'][ city %in% aCities];dt

  #  1.2 Merging Geo with Stats data   ----
  
  dtAll <- dtGeo [dt, on=c("country" , "state" , "city")];dtAll

  # 2. Plotting
  
  dtAll[city == 'New York'][ date > dateMax - 30] %>% 
    ggplot() + 
    geom_line(aes(date, confirmed), col="orange") +
    geom_line(aes(date, deaths), col="red") 
  
  
  dtAll[state  == 'New York'][ date > dateMax - 30] %>% 
    ggplot() + 
    facet_wrap(city ~ .) +
    geom_line(aes(date, confirmed), col="orange") +
    geom_line(aes(date, deaths), col="red") 
  
  # 1.3 Compute some stats
  
  
  dtAll[, sum(confirmed),  by=city]
  dtAll[, sum(death),  by=city]

  
}
