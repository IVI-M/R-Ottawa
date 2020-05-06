# R101
# 01-read.R
# https://github.com/IVI-M/R-Ottawa/new/master/r101

# 0. General libraries and functions ----
##  source("000-common.R")
if (F) { 
  print(sessionInfo())

  options(scipen=999); #remove scientific notation
  # Required packages
  packages <- c("ggplot2","plotly", "shiny")
  sapply(packages, library, character.only = TRUE)

  library(dplyr)
  library(magrittr)
  library(lubridate,  quietly=T)
  options(lubridate.week.start =  1)
  
  library(stringr)
  
  library("data.table"); 
  library(dtplyr);   
  as.dt <- as.data.table
  options(datatable.print.class=TRUE)
  
  library(flexdashboard)
  library(DT)
}

library(data.table)
library(magrittr)

#  1.0 Reading data   ----

cols <- c ( 1:5, 8:11 ) ;
dtUSc <- fread("https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv")
dtUSc [ ,(cols):=NULL] ; 
dtUSc <- dtUSc %>% melt(id=1:2); 
setnames(dtUSc, c("admin", "state", "date", "confirmed"))
dtUSc


#  1.1 Merging data   ----


#  1.2 New-York example   ----

