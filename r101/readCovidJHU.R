# source("covid-read.R")
# Author: Dmitry Gorodnichy (dmitry@gorodnichy.ca)

source("dt.R") 

readCovidUS <- function() {
  
  # JHU  used for https://www.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6
  # from https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series
  #
  
  cols <- c ( "Lat"   ,  "Long"  ) ;
  # dtJHUc <- fread( "https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv" , stringsAsFactors=T)
  # dtJHUc [ ,(cols):=NULL] ; dtJHUc <- dtJHUc %>% melt(id=1:2); setnames(dtJHUc, c("state", "country", "date", "confirmed"))
  # dtJHUd <- fread( "https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv" , stringsAsFactors=T)
  # dtJHUd [ ,(cols):=NULL] ; dtJHUd <- dtJHUd %>% melt(id=1:2); setnames(dtJHUd, c("state", "country", "date", "deaths"))
  # dtJHUr <- fread( "https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv" , stringsAsFactors=T)
  # (dtJHUr [ ,(cols):=NULL] %>%  melt(id=1:2) -> dtJHUr) %>%  setnames(c("state", "country", "date", "recovered"))
  # 
  # lapply (list(dtJHUc, dtJHUd, dtJHUr), setkeyv, c("state" ,  "country" ,   "date"))
  # dtJHU <<- dtJHUc [dtJHUd][dtJHUr]
  # 
  # rm(dtJHUc, dtJHUd, dtJHUr);
  # dtJHU [, date := as.character(date) %>% mdy ]
  
  #. US -----
  #
  cols <- c ( 1:5, 8:11 ) ;
  dtUSc <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
  dtUSc [ ,(cols):=NULL] ; 
  dtUSc <- dtUSc %>% melt(id=1:2); 
  setnames(dtUSc, c("admin", "state", "date", "confirmed"))
  
  dtUSd <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv")
  dtUSd [ ,(cols):=NULL] ; 
  dtUSd <- dtUSd %>% melt(id=1:2); 
  setnames(dtUSd, c("admin", "state", "date", "deaths"))
  
  #  dtUSr <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_US.csv")
  
  lapply (list(dtUSc, dtUSd), setkeyv, c("admin" ,  "state" ,   "date"))
  dtUS <<- dtUSc [dtUSd]
  
  rm(dtUSc, dtUSd);
  dtUS [, date := as.character(date) %>% mdy ]
  dtUS$date %>% max()
  dtUS
  
  
}

readCovidJHU <- function(coronavirus_data=NULL) {
  
  #used in [GitHub](https://github.com/AntoineSoetewey/coronavirus_dashboard){target="_blank"}.
  # library(coronavirus)
  # dtJHUa <- coronavirus %>%  data.table() # the same as below
  
  if (is.data.table(coronavirus_data)) {
    dtJHU <<- copy(coronavirus_data)
  } else {
    dtJHU  <<- fread("https://github.com/RamiKrispin/coronavirus-csv/raw/master/coronavirus_dataset.csv")
  }
  
  dtJHU <<- dtJHU %>% 
    dt.rmcols(c("Lat", "Long" )) %>%  
    setnames(c("state", "country", "date", "cases", "type")) %>% 
    dt.convert("date", ymd) %>% 
    setkeyv(c("state" ,  "country" ,   "date")) 
  
  dtJHU[ state == "", state:="(National)", by=country]
  
  dtJHU <<- dcast(dtJHU, date+country+state ~ type, value.var="cases") 
  
  # . clean Canada  ----
  
  cleanJHU.Canada()
}




cleanJHU.Canada <- function() {
  
  dtJHU[country=="Canada"] # NO PROVINCES are CSSEGISandData/COVID-19. !
  dtJHU[country == "Canada" & state == "(National)"]
  dtJHU[state == "Ontario"]
  dtJHU[state == "Quebec"] 
  
  # dtJHU[state %in% c("Recovered", "Diamond Princess", "Grand Princess")][type=="confirmed" & cases>0]
  # # 1: Grand Princess  Canada 2020-03-13     2 confirmed
  # # 2: Grand Princess  Canada 2020-03-17     6 confirmed
  # # 3: Grand Princess  Canada 2020-03-18     1 confirmed
  # # 4: Grand Princess  Canada 2020-03-20     1 confirmed
  # # 5: Grand Princess  Canada 2020-03-22     3 confirmed
  # dtJHU[state %in% c("Recovered", "Diamond Princess", "Grand Princess")][type=="death" & cases>0]
  # # 1: Diamond Princess  Canada 2020-03-22     1  death
  # dtJHU[state %in% c("Recovered", "Diamond Princess", "Grand Princess")][type=="recovered" & cases>0]
  # # Empty data.table 
  # #   dtJHU[state=="Recovered"]
  # dtJHU[state=="Recovered", .N, by=country] # Bug there! in Canada only:  Canada   158
  
  # fix bug
  dtJHU <<- dtJHU [state %ni% c("Recovered", "Diamond Princess", "Grand Princess") ]
  
  #  dtJHU[country == "Canada"][date > max(date) - 14][state=="(National)"]
  
  setkey(dtJHU, date)
  dtN2 <- dtJHU[country == "Canada" & state != "(National)" ,  
                lapply(.SD, sum, na.rm = T), by=c("date"),
                .SDcols= c("confirmed" ,"death" ,"recovered")]
  
  dtJHU[country == "Canada" & state == "(National)"]$confirmed <<- dtN2$confirmed
  dtJHU[country == "Canada" & state == "(National)"]$death <<- dtN2$death
  
  dtJHU[country == "Canada" & state == "(National)", confirmed:= dtN2$confirmed ] 
  dtJHU[country == "Canada" & state == "(National)", death := dtN2$death ]
  
  # if (F) {
  #   dtJHU[cases<0] # another bug ?
  #   dtJHU[cases<0, cases, by=c("country", "date", "type")]
  #   dtJHU$cases <<-  dtJHU$cases %>% abs() 
  #   
  #   dateNeg <-  dt0[recovered<0]$date
  #   negative <- dt0[recovered<0]$recovered
  #   dtJHU.dailytotals[date == dateNeg -1, recovered:=recovered+ negative/2]
  #   dtJHU.dailytotals[date == dateNeg, recovered:=recovered - negative/2]
  # }
  # 
}


readGeo <- function() {
  if (T) {
    return(readRDS("dtCities-fromJHU.Rds"))
  }
  dtGeo <<- fread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/UID_ISO_FIPS_LookUp_Table.csv") %>% 
    dt.rmcols (c("UID"  , "iso2" ,   "iso3"  ,   "code3", "FIPS", "Combined_Key"))  %>% 
    setnames(c("city", "state", "country", "lat", "lng", "population")) %>% lazy_dt() %>% 
    filter(state %ni% c ("Diamond Princess", "Grand Princess", "Recovered")) %>% 
    as.dt 
  
  #   dtGeo[state=="", state:="(National)"]
  
  #dtGeo[country=="Canada"]
  # dtGeo[admin2!=""]
  
  dtGeo[ state == "", state:="(National)", by=country]
  
  saveRDS(dtGeo, "dtCities-fromJHU.Rds")
  return(dtGeo)

}


