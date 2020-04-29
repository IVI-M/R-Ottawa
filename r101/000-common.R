##  source("000-common.R")  
  
if (T) { # 0. General libraries and functions ----
  
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
  print(sessionInfo())
}
