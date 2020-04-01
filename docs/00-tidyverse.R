
# File: 00-tidyverse.R
# Author: Dmitry Gorodnichy. Date: Jan 2017 - 08/2018
# Everything by Hadley Wickham and Co, except text
#
# Contents  / Includes :


library(ggplot2)
# data.table 1.10.4
library(data.table) #masked from 'package:lubridate': hour, isoweek, mday, minute, month, quarter, second, wday, week, yday, year

#library(dplyr)
# %.%
library(magrittr); #%>% https://www.rstudio.com/resources/webinars/pipelines-for-data-analysis-in-r/
# mtcars %$% cor(disp, mpg)
# mtcars %<>% transform(cyl = cyl * 2)
#  %T>%
# library(pipeR) # rnorm(20) %>>% plot(main=sprintf("length: %d",length(.)))
library(wrapr) # 1:4 %.>% .^2
# https://www.r-bloggers.com/supercharge-your-r-code-with-wrapr/

#library(stringr)


# >> dplyr tricks ----

if (F) {


  # . (in comparison with data.table) -----
  library(broom)
  library(dplyr)
  data(Orange)
  Orange = tbl_dt(Orange)

  ggplot(Orange, aes(age, circumference, color = Tree)) + geom_line()

  Orange %>% group_by(Tree) %>% summarize(correlation = cor(age, circumference))
  require(data.table)
  Orange[, .(correlation = cor(age, circumference)), by = Tree]



  #library(magrittr)
  #library(tidyr)
  library(dplyr)
  ##library(readr)
  ##library(dplyr, warn.conflicts = FALSE)


  #Google: vignette(nse) r

  # https://danieljhocking.wordpress.com/2014/11/06/dplyr-is-great-but/


  tapply(mtcars[['mpg']], mtcars[['cyl']], mean)
  #Looking at the functions offered by dplyr, a better alternative to the previous line is:
  summarize(group_by(mtcars, cyl), mean_mpg = mean(mpg))

  # with  %>% provided through the magrittr package which comes  with dplyr.
  mtcars %>%
    group_by(cyl) %>%
    summarize(mean_mpg = mean(mpg))

  # for looping !!!

  #using Standard evaluation
  mean_mpg = function(data, group_col) {
    data %>% group_by_(group_col) %>% summarize(mean_mpg = mean(mpg))
  }
  mtcars %>% mean_mpg("gear")

  #or using non-standard evaluation, with lazyeval package which also comes  with dplyr.

  mean_mpg = function(data, group_col) {
    data %>% group_by_(.dots = lazyeval::lazy(group_col)) %>% summarize(mean_mpg = mean(mpg))
  }
  mtcars %>% mean_mpg(gear)

  mean_mpg = function(data, ...) {
    data %>% group_by_(.dots = lazyeval::lazy_dots(...)) %>% summarize(mean_mpg = mean(mpg))
  }
  mtcars %>% mean_mpg(cyl, gear)






  # https://cran.r-project.org/web/packages/dplyr/vignettes/nse.html ----



  #NSE
  summarise(mtcars, mean(mpg))
  #SE
  summarise_(mtcars, ~mean(mpg))  # the best
  summarise_(mtcars, quote(mean(mpg)))
  summarise_(mtcars, "mean(mpg)")


  summarise_(mtcars, .dots = setNames(dots, c("mean", "count")))




  # Interp works with formulas, quoted calls and strings (but formulas are best)
  interp(~ x + y, x = 10)
  #> ~10 + y
  interp(quote(x + y), x = 10)
  #> 10 + y
  interp("x + y", x = 10)
  #> [1] "10 + y"

  # Use as.name if you have a character string that gives a variable name
  interp(~ mean(var), var = as.name("mpg"))
  #> ~mean(mpg)
  # or supply the quoted name directly
  interp(~ mean(var), var = quote(mpg))
  #> ~mean(mpg)



  #Because every action in R is a function call you can use this same idea to modify functions:

  interp(~ f(a, b), f = quote(mean))
  #> ~mean(a, b)
  interp(~ f(a, b), f = as.name("+"))
  #> ~a + b
  interp(~ f(a, b), f = quote(`if`))
  #> ~if (a) b

  #If you already have a list of values, use .values:

  interp(~ x + y, .values = list(x = 10))
  #> ~10 + y

  # You can also interpolate variables defined in the current
  # environment, but this is a little risky becuase it's easy
  # for this to change without you realising
  y <- 10
  interp(~ x + y, .values = environment())
  #> ~x + 10



  ################################################################################################# #
  # How to use dplyr within functions and loops? ----
  # http://stackoverflow.com/questions/42398867/how-to-use-dplyr-within-functions-and-loops

  # This is the original code:
  tbl = diamonds
  tbl %>%
    filter(cut != "Fair") %>%
    group_by(cut) %>%
    summarize(
      AvgPrice = mean(price),
      Count = n()
    )

  #  This is its dataset-agnostic equivalent:
  nVarGroup = 2 #"cut"
  nVarMeans = 7 #"price"

  strGroupConditions = levels(dt[[nVarGroup]])[-1] # "Good" "Very Good" "Premium" "Ideal"
  strVarGroup = names(dt)[nVarGroup]
  strVarMeans = names(dt)[nVarMeans]
  qAction=quote(mean(substitute(strVarMeans)))
  qGroup=quote(substitute(strVarGroup) %in% strGroupConditions)

  qAction=quote(mean(strVarMeans))
  qGroup=quote(get(strVarGroup) %in% strGroupConditions)


  tbl %>%
    filter(strVarGroup != "Fair")



  # Now, you can cut-n-paste it for all your looping needs, as in here:

  for(nVarGroup in 2:4)
    for(nVarMeans in 5:10) {

    }

  %>%
    filter(eval(qGroup))

  tbl %>%
    group_by(substitute(strVarGroup))

  filter(substitute(strVarGroup)  != "Fair")

  group_by(strVarGroup) %>%

    mean(get(strVarMeans)

         tbl %>%
           filter(eval(qGroup))    %>%
           group_by(strVarGroup) %>%
           summarize(
             AvgPrice = eval(qAction),
           )


}


# SANDBOX -----

# all useful from https://www.r-bloggers.com/

######################################################### #
#https://www.r-bloggers.com/wrapr-r-code-sweeteners/ ####
######################################################### #


library(wrapr)
1:4 %.>% .^2

'a' := 'x'
#    a
#  "x"

#(note this is subtly different than binding values for names as with base::substitute() or base::with()).
let(
  c(VAR = 'a'),
  eval = FALSE,
  {
    VAR + VAR
  }
)
#  {
#      a + a
#  }

let(
  c(VAR = 'a'),
  debugPrint = TRUE,
  {
    VAR + VAR
  }
)
#  {
#      a + a
#  }
#  [1] 14

vignette('DebugFnW', package='wrapr')

######################################################### #
#https://www.r-bloggers.com/tidy-evaluation-most-common-actions/
#http://rlang.tidyverse.org/reference/quosure.html ####
######################################################### #

library(tidyverse)

mtcars %>% select(!!quote(cyl))%>% head(1)

bare_to_quo <- function(x, var){
  x %>% select(!!var) %>% head(1)
}
bare_to_quo(mtcars, quo(cyl))


bare_to_quo_mult_chars <- function(x, ...) {
  grouping <- rlang::syms(...)
  x %>% group_by(!!!grouping) %>% summarise(nr = n())
}
bare_to_quo_mult_chars(mtcars, list("vs", "cyl"))
