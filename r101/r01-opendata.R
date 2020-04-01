# r-01-opendata.R
#
#


if (T) { # 0. General libraries and functions ----
  
  # print(sessionInfo())
  
  # system(paste('"C:\\Program Files\\internet explorer\\iexplore.exe"', '-url cran.r-project.org'), wait = FALSE)
  
  # packages <- c("learnr","ggplot2","plotly", "  shiny", "shinythemes")
  # lapply(packages, library, character.only = TRUE)
  
  library(magrittr)
  library(readxl)
  library(readr)
  library(stringr)
  library(R6)
  
  library(ggplot2)
  library(data.table)
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
  
  # library(GGally);  # library(flexdashboard) #flexdashboard_0.5.1.1 -> !! is NOT compatible with R version 3.4.3 (!!
}
  ##  source("000-common.R")
  

library(data.table)
library(magrittr)
library(ggplot2)

# From "https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310076701"
# 13100767-eng.zip (Compressed Archive (ZIP), 295.43kB)

str1 <- "https://www150.statcan.gc.ca/t1/tbl1/#?pid=13100767&file=1310076701-eng.csv"
str1 <- "data/1310076701-eng(1).csv"

str2 <- "https://www150.statcan.gc.ca/n1/tbl/csv/13100767-eng.zip"
str2 <- "data/13100767.csv"




dt1 <- fread(str1);dt1
dt2 <- fread(str2);dt2



strCovid <- "https://docs.google.com/spreadsheets/d/1D6okqtBS3S2NRC7GFVHzaZ67DuTw7LX49-fqSLwJyeo/"
sheets <- c("Cases" ,"Mortality" ,"Recovered", "Testing" ,"Codebook")

i=1
strCovidCsv <- paste0(strCovid, "gviz/tq?tqx=out:csv&sheet=", sheets[i]); strCovidCsv

dt <- fread(strCovidCsv)