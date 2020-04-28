# https://github.com/IVI-M/R-Ottawa/blob/master/r101/r01-opendata.R

if (F) { # 0. General libraries and functions ----
  ##  source("000-common.R")
  print(sessionInfo())
 
  library(magrittr)
  library(readxl)
  library(readr)
  library(stringr)
  library(R6)
  
  library(ggplot2)
  library(data.table); library(dtplyr)
  options(datatable.print.class=TRUE)
  library(lubridate,  quietly=T)
  options(lubridate.week.start =  1)
  library(dplyr)
  #library(tidyverse) # includes:  readr ggplot2 stringr (which we use), dplyr tidyr tibble forcats purrr and others - https://www.tidyverse.org/packages/
  
  library(dygraphs)
  library(plotly)
  library(DT)
  
  options(digits = 3); # 7
  #options(max.print = 100) # 1000
  options(scipen=999); #remove scientific notation
  
  # library(GGally);  # library(flexdashboard) # NOT compatible with R version 3.4.3 (!!
}

library(data.table)
library(magrittr)

##################################################### #
# 1.1 canada Official ----
# From "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310076701"

str1a <- "https://www150.statcan.gc.ca/t1/tbl1/#?pid=13100767&file=1310076701-eng.csv" # no work/ need tosave locally 
str1b <- "data/1310076701-eng(1).csv"
dt <- fread(str1b, header=T, stringsAsFactors=T, skip=5);dt %>% dim ; dt %>% names # 3095   12
names(dt) <- dt[1] %>% transpose() %>% unlist 
dt <- dt [-1]

# 13100767-eng.zip (Compressed Archive (ZIP), 295.43kB)
str2a <- "https://www150.statcan.gc.ca/n1/tbl/csv/13100767-eng.zip" #not work
require(readr)
myData <- read_csv(str2a)  #not work
data <- read.table(str2a, nrows=10, header=T, quote="\"", sep=",")  #not work 

str2b <- "data/13100767.csv"
dt <- fread(str2b);dt %>% dim ; dt %>% names # 30930    16



#From https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html
str3 <- "https://health-infobase.canada.ca/src/data/covidLive/covid19.csv"
dt <- fread(str3); dt %>% dim ; dt %>% names

##################################################### #

#  1.1 EU /World  ----
library(readxl)
library(httr)

#create the URL where the dataset is stored with automatic updates every day
url <- paste("https://www.ecdc.europa.eu/sites/default/files/documents/COVID-19-geographic-disbtribution-worldwide-",format(Sys.time(), "%Y-%m-%d"), ".xlsx", sep = "")

#download the dataset from the website to a local temporary file
GET(url, authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".xlsx")))

#read the Dataset sheet into “R”
dtEA1 <- read_excel(tf)  %>% data.table() %T>% dim# 8102   10

##################################################### #

# 2.1 canada UoT ----  
# used in
# https://art-bd.shinyapps.io/covid19canada/ - R
# https://georgeflerovsky-canada.github.io/Canada-COVID-19-dashboard/  - PowerBI
# https://covid19canada.herokuapp.com/ - Dash 
# https://itrack.shinyapps.io/covid19-canada/ - R (where code below is used)
# More at https://github.com/gorodnichy/iTrack-covid

strCovid <- "https://docs.google.com/spreadsheets/d/1D6okqtBS3S2NRC7GFVHzaZ67DuTw7LX49-fqSLwJyeo/"
sheets <- c("Cases" ,"Mortality" ,"Recovered", "Testing" ,"Codebook")

i=1
strCovidCsv <- paste0(strCovid, "gviz/tq?tqx=out:csv&sheet=", sheets[i]); strCovidCsv
dt <- fread(strCovidCsv,header=T, stringsAsFactors=T)


fOpen <- function(i, col1name) {
  strCovidCsv <- paste0(strCovid, "gviz/tq?tqx=out:csv&sheet=", sheets[i])
  dt <- fread(strCovidCsv, header=T, stringsAsFactors=T, select= 1:15)
  names (dt) <- c(col1name, names (dt) [-1] )
  return(dt)
}

fRemoveV <- function(dt) {
  str <- names(dt)
  cols <- str [ str_detect(str, regex("^V+")) ]
  dt [ , (cols):=NULL ]
  print(str)
  return(dt)
}

#1 ----
dtCases <- fOpen(1, "case_id")  %>% fRemoveV()  %>% select(1:12) %>% data.table() 
dtCases$date_report  <- dtCases$date_report %>% as.character() %>% dmy()
dtCases$travel_yn  <- dtCases$travel_yn %>% as.factor()
dtCases[`locally_acquired`=="Close contact", locally_acquired:="Close Contact"]
dtCases %>% summary(30)

#2 ----
dtMortality  <-fOpen(2,"death_id") %>% fRemoveV() %>%  select(c(1:9, 11)) %>% data.table() 
dtMortality$date_death_report  <- dtMortality$date_death_report %>% as.character() %>% dmy()
dtMortality %>%  summary

dtMortality2 <- dtCases[dtMortality[ , .(case_id,date_death_report,additional_info)], on="case_id"]
dtMortality2 %>%  summary

#3 ----
dtRecovered  <-fOpen(3,"date_recovered") %>% fRemoveV() %>%  select(1:4) %>% data.table() 
dtRecovered$date_recovered  <- dtRecovered$date_recovered %>% as.character() %>% dmy()
dtRecovered %>%  summary

#4 ----
dtTesting  <-fOpen(4,"date_testing") %>% fRemoveV() %>%  select(1:4) %>% data.table() 
dtTesting$date_testing  <- dtTesting$date_testing %>% as.character() %>% dmy()
dtTesting%>%  summary

#5 ----
dtCodeBook  <-fOpen(5, "variable") %>% select(1:3) %>% slice(-(1:2)) %>% as.data.table()
setnames(dtCodeBook, c("Variable", "Description", "Label"))



# END ----
