source("covid-read.R")  

# **************************** -----
# 0.1 My functions ----

covid.reduceToTopNCitiesToday <- function(dt0, N=5, sortby="confirmed") {
  
  dateMax <- dt0$date %>% max
  # dt <- dt0[date==dateMax][order(-confirmed)][1: min(N, nrow(dt))];
  dt <- dt0[date==dateMax][order(-get(sortby))][1: min(N, nrow(dt0))];
  dt
  topNcities <- dt$city ; 
  topNcities
  dt <- dt0[ city %in% topNcities];
  dt
}


addDerivatives <- function (dt0, colsCases, colsGeo, convolution_window=3, difference_window=1) {
  
  colTotal <- paste0(colsCases, "Total")
  colSpeed <- paste0(colsCases, "Speed") # DailyAve") # "Speed"
  colAccel <- paste0(colsCases, "Accel") # "WeeklyDynamics") # "Accel." WeeklyAccel - change since last week in DailyAve
  # colSpeedAve <- paste0(colsCases, "SpeedAve")
  colAccel. <- paste0(colsCases, "Accel.")  # AccelAve
  colGrowth <- paste0(colsCases, "Growth")  #
  colGrowth. <- paste0(colsCases, "Growth.")  #
  colGrowth.Accel <- paste0(colsCases, "Growth.Accel")  #
  
  
  dt0[ ,  (colTotal) := cumsum(.SD),  by=c(colsGeo), .SDcols = colsCases]
  
  dt0[ ,  (colSpeed) := frollmean(.SD, convolution_window, align = "right", fill=0),  by=c(colsGeo), .SDcols = colsCases][, (colSpeed) := lapply(.SD, round, 1), .SDcols = colSpeed]
  
  dt0[ ,  (colSpeed) := lapply(.SD, function(x) ifelse (x<0,0,x) ), .SDcols = colSpeed]
  
  dt0[ ,  (colAccel) := .SD - shift(.SD,difference_window),  by=c(colsGeo), .SDcols = colSpeed]
  
  dt0[ ,  (colAccel.) := frollmean(.SD, convolution_window, align = "right", fill=0),  by=c(colsGeo), .SDcols = colAccel][, (colAccel.) := lapply(.SD, round, 1), .SDcols = colAccel.]
  
  
  # dN(T)/ N(T)
  # dt0[ ,  confirmedGrowth0 := confirmedTotal/confirmedSpeed]
  # dt0[ ,  recoveredGrowth0 := recoveredTotal/recoveredSpeed]
  # dt0[ ,  deathGrowth0 := deathTotal/deathSpeed]
  
  # dN(T+1) / dN(T)
  dt0[ ,  (colGrowth) := .SD / shift(.SD, difference_window<-1),  by=c(colsGeo), .SDcols = colSpeed]
  
  dt0[ ,  (colGrowth.) := frollmean(.SD, 2, align = "right", fill=0),  by=c(colsGeo), .SDcols = colGrowth][, (colGrowth.) := lapply(.SD, round, 3), .SDcols = colGrowth.]
  
  # dt0[ ,  (colGrowth.) := colGrowth,  by=c(colsGeo), .SDcols = colGrowth][, (colGrowth.) := lapply(.SD, round, 3), .SDcols = colGrowth.] ?? does it work?
  
  
  dt0[ ,  (colGrowth.Accel) := .SD - shift(.SD,difference_window),  by=c(colsGeo), .SDcols = colGrowth.][, (colGrowth.Accel) := lapply(.SD, round, 3), .SDcols = colGrowth.Accel]
  
  dt0[, (colAccel):= NULL]
  dt0[, (colGrowth) := NULL]
  
}


addPredictions  <- function (dt00, colsCases,  date0=dateMax, N=7) {
  # dt00$result <- "Observed"
  dt00[ , .(date, confirmedSpeed,result)]
  r2 <- r <- dt00 [date==date0]
  r2$result <- r$result <- "Expected"
  
  r2$date <- r$date <- dt00 [date==date0]$date + N
  
  a <- r$confirmed + r$confirmedAccel.*N ; a
  b <- r$confirmed * r$confirmedGrowth.^N ; b
  aa <- r$confirmed + r$confirmedAccel*N ; aa
  bb <- r$confirmed * r$confirmedGrowth^N ; bb
  
  r$confirmed <- min(a,b,aa,bb) %>% max(0)
  r2$confirmed <- min(a,b,aa,bb) %>% max(0)
  
  dt00 <- dt00 %>% rbind(r) %>% rbind(r2) %>% unique 
  setkey(dt00, date)
  
  # [1]  0.0  0.0  0.0  0.0  0.0  0.0  0.0  2.0  2.2  2.2  2.2  2.4  2.1  1.8  2.2  3.2  4.4  5.5  9.5 15.0 20.9 28.1 32.1 35.0 36.4
  # [26] 38.2 38.2 35.6 33.0 30.2 29.4 29.9 30.1 31.1 30.0 31.1 33.8 32.9 34.9 37.0 39.1 40.5 41.8 44.5 41.5 44.1 43.9 45.5 49.8 53.6
  # [51] 55.4 56.1 55.5 53.1 50.5 44.8 38.2  
  # >   r$confirmed  # [1] 24
  # >   r$confirmedSpeed  # [1] 38.2
  # >   aa <- r$confirmed + r$confirmedAccel ; aa   # [1] 17.4
  # >   a <- r$confirmed + r$confirmedAccel. ; a    # [1] 22.55
  # >   bb <- r$confirmed * r$confirmedGrowth ; bb  # [1] 20.46429
  # >   b <- r$confirmed * r$confirmedGrowth. ; b   # [1] 23.28
}

# predictCovid <- function (totalToday, days, dailySpeed, dailyAccel) {
#   x1 <- x + v*t + a*t*t/2
#   if (x1<0) x1 <- 0
#   x1
# }
# 
# getPredicted <- function (dt0) {
#   
#   colsPredicted1 <- paste0(cols, "Predicted1")
#   dt0[ , (colsPredicted) := lapply(.SD, predictCovid, ), by=c("country", "state"), .SDcols=cols]
#   
#   t = 1
#   c <- dt0[date==dt0$date %>% max] %$% predictCovid(confirmedTotal, 0, confirmedDailyAve, confirmedWeeklyDynamics)
#   
#   
#   
#   
# }


if (F) {
  
  g1 <- ggplot(dt00, aes(x=city)) +
    coord_flip() +
    scale_col_brewer(palette = "Greens", direction = 1) +   #scale_fill_grey(0.3, 0.9) +
    
    #geom_col(aes_string(y=strColLast), fill="Green", alpha=0.2) +  # for plotly
    geom_col(aes_string(y=strColLast,  col="date"), alpha=0.6) +
    geom_point(aes_string(y=strColLast), alpha=0.9, col="green", size=7) +
    geom_point(aes_string(y=strColPrevious), alpha=0.8, col="brown", size=4) +
    geom_segment( aes_string(xend="Metric", y=strColPrevious, yend=strColLast), size = 1, col="brown",
                  arrow = arrow(length = unit(0.2, "cm"))) +
    
    guides(fill="none", col="none") +
    theme_bw() +
    theme(legend.position = "bottom") +
    
    labs(
      title= title,
      subtitle=paste0("Dates: ", from, " - ", to),
      caption = "Change since previous period is marked by arrow.",
      # caption="Green: Current period. Red: Previous period. Dot: historical average",
      # caption="Cross indicates historical average. Change since last period marked by arrow",
      #  y="Transactions",
      y=NULL,
      x=NULL
    ) 
  
  
  
}


# getTodayMetric  <- function (dt0, metric, strMetrics) {
#   
#   dtToday <<- dt0[date == dt0$date %>% max |
#                     #  date == dt0$date %>% max - 30 |
#                     date == dt0$date %>% max - 1 |
#                     date == dt0$date %>% max - 7  ] [ 
#                       , region:= paste0(country, " - ", state)]  %>% setcolorder("region")
#   
#   return(dtToday1)
# }


# getMetricsToday2old <-  function() {  # (date)
# 
#   
#   metric <- c("confirmed", "deaths", "recovered")
#   cols <- c("state", "country")
#   
#   dtCountries1 <<- dtJHU[ 
#     , .(
#       total=sum(.SD), 
#       today= as.integer(.SD[.N]+.SD[.N-1])/2,
#       yesterday= as.integer(.SD[.N-2]+.SD[.N-1])/2,
#       
#     ), keyby = cols, .SDcol=metric]
#   
#   dtCountries1 <<- dtJHU[ 
#     , .(
#       total = sum(.SD), 
#       today2 = as.integer(.SD[.N]+.SD[.N-1])/2,
#       yesterday2 = as.integer(.SD[.N-2]+.SD[.N-1])/2,
#       
#     ), keyby = cols, .SDcol=metric]
#   
#   
#   metric = "confirmed"
#   
#   dtCountries2 <<- dtJHU [ order(date)] [  
#     , .(today= as.integer(.SD[.N]+.SD[.N-1])/2), keyby = cols, .SDcol=metric]
#   dtCountries3 <<- dtJHU [ order(date)] [  
#     , .(yesterday= as.integer(.SD[.N-2]+.SD[.N-1])/2), keyby = cols, .SDcol="confirmed"]
#   
#   a=0
#   dtCountries4 <<- dtJHU [ order(date)] [  
#     , .(DailyAveThisWeek = as.integer( (.SD[.N-a]+.SD[.N-1-a]+.SD[.N-2-a]+.SD[.N-3-a]+.SD[.N-4-a]+.SD[.N-5-a]+.SD[.N-6-a])/7 ) ), keyby = cols, .SDcol="confirmed"]; dtCountries4
#   a=7
#   dtCountries4b <<- dtJHU [ order(date)] [  
#     , .(DailyAveLastWeek = as.integer( (.SD[.N-a]+.SD[.N-1-a]+.SD[.N-2-a]+.SD[.N-3-a]+.SD[.N-4-a]+.SD[.N-5-a]+.SD[.N-6-a])/7 ) ), keyby = cols, .SDcol="confirmed"]; dtCountries4b
#   
#   a=14
#   dtCountries4c <<- dtJHU.dailytotals [ order(date)] [  
#     , .(DailyAveLastWeek2 = as.integer( (.SD[.N-a]+.SD[.N-1-a]+.SD[.N-2-a]+.SD[.N-3-a]+.SD[.N-4-a]+.SD[.N-5-a]+.SD[.N-6-a])/7 ) ), keyby = cols, .SDcol="confirmed"]; dtCountries4b
#   
#   
#   dtRegions <- dtCountries1[dtCountries2][dtCountries3][dtCountries4][dtCountries4b][dtCountries4c][
#     , WeeklyDynamics:=DailyAveThisWeek - DailyAveLastWeek][
#       ,  WeeklyDynamicsLastWeek:=DailyAveLastWeek - DailyAveLastWeek2]
#   
#   dtRegions[order(-WeeklyDynamics)][1:40]; 
#   
#   
#   
#   dtCountriesCases <- dtRegions[ , lapply(.SD, sum, na.rm=T), by=country, .SDcols = c("Cases", "today" ,"yesterday" ,"DailyAveThisWeek", "DailyAveLastWeek", "WeeklyDynamics")][order(-Cases)]; dtCountries[1:30]
#   
#   
#   
#   dtJHU.dailytotals  [, (cols):=NULL]
#   
# }


#  ************************************* -----


plotToday2 <- function(dt00, input ){
  dateMax <- dt00$date %>% max(na.rm = T)
  dtToday <- dt00[date==dateMax]
  g <- dtToday %>% 
    ggplot(
      # aes(x=region   )
      aes(x=reorder(region, get(input$sortby)) )
    )  + 
    theme_bw() +
    coord_flip() + 
    # scale_color_distiller(palette = "Oranges", direction = 1) +   #scale_fill_grey(0.3, 0.9) +
    
    geom_col(aes(y=confirmedSpeed,fill=confirmedGrowth., width=confirmedTotal/max(confirmedTotal)), alpha=1) +
    scale_fill_gradient2(low = "yellow", high="red", mid="orange", midpoint = 1) +   #scale_fill_grey(0.3, 0.9) +
    

    # 
    # geom_point(aes(y=confirmedSpeed, size=confirmedSpeed), data=dt00[data==dataMax-1], alpha=0.4,  col="orange") +
    
    geom_point(aes(y=confirmedSpeed-confirmedAccel., size=confirmedSpeed), alpha=0.4,  col="orange") +     
    geom_point(aes(y=confirmedSpeed, size=confirmedSpeed ), alpha=1, col="orange") +
    
    geom_segment( aes( 
      xend = region,
      yend=confirmedSpeed, y=confirmedSpeed-confirmedAccel.      ), 
      size = 1, col="black",
      arrow = arrow(length = unit(0.2, "cm"))
    ) +
    
    
    guides(size="none") +
    guides(fill="none") +
    # theme(legend.position = "bottom") +
    labs(
      title= paste0("New cases a day (Speed)"),
      # title= paste0("Pandemic situation today (Last updated ", dateMax, ")"),
      subtitle=
        paste0(
          # "(Top ", input$showN, " results according to selected criteria)"
          "Date: ", input$dateToday
          ),
      # size="New cases a day",
      # fill="Growth rate (Rt)",

      
      # y =  paste0("Pandemic spread speed (average number of new cases a day)\n",
      # "Change since yesterday is marked by arrow. Bar width is proportional to the total number of confirmed cases."),
      y=
        paste0("Change since yesterday is marked by arrow. \n",
               "Bar width is proportional to the total number of confirmed cases\n",
               "Colour is proportional to Growth rate (Rt)\n"
               # "Top ", min(input$showN), " results according to selected criteria are shown."
        ),
    
      x=NULL,
      caption=
        paste0(  
        "Data sources: John Hopkins University, University of Toronto, Government of Canada.\n",
        caption.covid
      )
    )
  
  if(input$overlaytext) {
    g <- g + geom_text(aes(y=max(0), label=label), hjust=0, vjust=0, alpha=0.77, col="blue") 
    # g <- g + geom_text(aes(y=max(confirmedSpeed), label=label), hjust=1, vjust=0, alpha=0.5, col="red") 
    # g <- g + geom_text(aes(y=max(confirmedSpeed)/2, label=label), hjust=0, vjust=0, alpha=0.7) 
    # g <- g + geom_text(aes(y=0, label=label), hjust=0, vjust=1, alpha=0.7) 
  }
  
  if (input$log10 ) {
    g <- g + scale_y_log10()
  }
  g
}

plotTodayRt2 <- function(dt00, input) {
  dateMax <- dt00$date %>% max (na.rm = T)
  dtToday <- dt00[date==dateMax]
  g <- dtToday %>% 
    ggplot(       
      aes(x=reorder(region, get(input$sortby)) )      
    )  +
    theme_bw() +
    coord_flip() + 
    scale_y_continuous(limits = c(0.5, 1.5)) + 
    
    geom_hline(yintercept=1, col="black", size=1, alpha=0.5, linetype=2) + 
    
    geom_point(aes(y=confirmedGrowth., size=confirmedSpeed), data = dt00[date==dateMax-1], col="orange", alpha=0.4) +
    
    geom_point(aes(y=confirmedGrowth., size=confirmedSpeed,col= confirmedGrowth.)) +
    # guides(col="none") +
    scale_color_gradient2(low = "yellow", high="red", mid="orange", midpoint = 1) +   #scale_fill_grey(0.3, 0.9) +
    
    
    geom_segment( aes( 
      xend = region,
      yend=confirmedGrowth., y=confirmedGrowth.-confirmedGrowth.Accel ), 
      size = 1, col="black",
      arrow = arrow(length = unit(0.2, "cm"))
    ) +
    
    # theme(legend.position = "bottom") +
    labs(
      title= paste0("Growth Rate (Rt)"),
      subtitle = paste0(
        # "Change since yesterday is marked by arrow. ",
        "Date: ", input$dateToday
      ),
      size = "New cases a day",
      col="Growth rate (Rt)",
      # fill = "Growth",
      y=NULL, 
      # paste0("Rt\n",
      # "Change since yesterday is marked by arrow. "),
      x=NULL,
      
      caption=caption.covid
    )
  
  
  if (input$log10 ) {
    g <- g + scale_y_log10()
  }
  
  g
  
}



plotTodayAll <- function(dt00, input ){
  
  dateMax <- dt00$date %>% max(na.rm = T)
  dtToday <- dt00[date==dateMax]
  
  g <- dtToday %>% 
    ggplot(
      # aes(x=region   )
      aes(x=reorder(region, get(input$sortby)) )
    )  + 
    theme_bw() +
    
    coord_flip() + 
    # scale_color_distiller(palette = "Oranges", direction = 1) +   #scale_fill_grey(0.3, 0.9) +
    
    
    
    geom_col(aes(y=confirmedSpeed,fill=confirmedGrowth., width=confirmedTotal/max(confirmedTotal)), alpha=1) +
    scale_fill_gradient2(low = "yellow", high="red", mid="orange", midpoint = 1) +   #scale_fill_grey(0.3, 0.9) +
    
    guides(size="none") +
    guides(fill="none") +
    
    # geom_point(aes(y=confirmedSpeed, size=confirmedSpeed), data=dt00[data==dataMax-1], alpha=0.4,  col="orange") +
    
    geom_point(aes(y=confirmedSpeed-confirmedAccel., size=confirmedSpeed), alpha=0.4,  col="orange") +     
    geom_point(aes(y=confirmedSpeed, size=confirmedSpeed ), alpha=1, col="orange") +
    
    geom_segment( aes( 
      xend = region,
      yend=confirmedSpeed, y=confirmedSpeed-confirmedAccel.      ), 
      size = 1, col="black",
      arrow = arrow(length = unit(0.2, "cm"))
    ) +
    
    geom_text(aes(y=0, label=label), hjust=0, vjust=1, alpha=0.7)  +
    
    # theme(legend.position = "bottom") +
    labs(
      title= paste0("New cases a day (Speed)"),
      # title= paste0("Pandemic situation today (Last updated ", dateMax, ")"),
      subtitle= paste0("Bar width is proportional to the total number of confirmed cases"),
      size="Total number of cases",
      fill="Growth rate (Rt)",
      # fill = "Growth",
      
      # y =  paste0("Pandemic spread speed (average number of new cases a day)\n",
      # "Change since yesterday is marked by arrow. Bar width is proportional to the total number of confirmed cases."),
      y=NULL,
      x=NULL,
      caption=paste0(  
        "Last updated: ", dateMax
        # "Data sources: John Hopkins University,University of Toronto, Government of Canada"
        # caption.covid
      )
    )
  
  if (input$log10 ) {
    g <- g + scale_y_log10()
  }
  g

  
  g1 <- dtToday %>% 
    
    ggplot(       
      aes(x=reorder(region, get(input$sortby)) )      
    )  +
    theme_bw() +
    coord_flip() + 
    scale_y_continuous(limits = c(0.5, 1.5)) + 
    
    geom_hline(yintercept=1, col="black", size=1, alpha=0.5, linetype=2) + 
    
    geom_point(aes(y=confirmedGrowth., size=confirmedSpeed), data = dt00[date==dateMax-1], col="orange", alpha=0.4) +
    
    geom_point(aes(y=confirmedGrowth., size=confirmedSpeed,col= confirmedGrowth.)) +
    # guides(col="none") +
    scale_color_gradient2(low = "yellow", high="red", mid="orange", midpoint = 1) +   #scale_fill_grey(0.3, 0.9) +
    
    
    geom_segment( aes( 
      xend = region,
      yend=confirmedGrowth., y=confirmedGrowth.-confirmedGrowth.Accel ), 
      size = 1, col="black",
      arrow = arrow(length = unit(0.2, "cm"))
    ) +
    
    # theme(legend.position = "bottom") +
    labs(
      title= paste0("Growth Rate (Rt)"),
      subtitle = 
        "Change since yesterday is marked by arrow. ",
      # paste0("Last updated: ",dateMax),
      size = "New cases a day",
      col="Growth rate (Rt)",
      # fill = "Growth",
      y=NULL, 
      # paste0("Rt\n",
      # "Change since yesterday is marked by arrow. "),
      x=NULL,
      
      caption=caption.covid
    )
  
  
  if (input$log10 ) {
    g1 <- g1 + scale_y_log10()
  }
  
  p <- ggpubr::ggarrange(
    g, g1, # + rremove("x.text"),   p3+font("x.text", size = 10),
    #  p1, p2, p3 + rremove("x.text"),   p3+font("x.text", size = 10),
    # labels = c("A", "B"),
    ncol = 2, nrow = 1);
  p

}



plotToday <- function(dt00, input) {   
  cols <- c("confirmed", "recovered", "deaths")
  # cols3 <- paste0(cols, input$fRadio)
  cols3 <- paste0(cols, "Speed")
  
  dtToday <- dt00[date==input$dateToday]
  dtToday [ , deathRate:= as.integer(deathsTotal / confirmedTotal * 100 )+1]
  
  if (input$normalize == T & dtToday$population %>% min(na.rm = T) > 1)
    dtToday[ , (cols3):= lapply(.SD, function(x) {as.integer(x/population*1000000)}),.SDcols=cols3]
  
  # dtToday[, region:=reorder(region, get(input$sortby))]
  
  g <- dtToday %>% 
    ggplot(
      # aes(x=region   )
      aes(x=reorder(region, get(input$sortby)) )
      
    )  + 
    theme_bw() +
    
    
    coord_flip() + 
    
    
    geom_col(aes(y=confirmedSpeed, fill=confirmedGrowth., width=confirmedTotal/max(confirmedTotal)), alpha=1) +
    scale_fill_gradient2(low = "yellow", high="red", mid="orange", midpoint = 1) +   #scale_fill_grey(0.3, 0.9) +
    # guides(fill="none") +
    
    # geom_col(aes(y=confirmedSpeed), alpha=0.3, fill="orange") +
    geom_point(aes(y=confirmedSpeed-confirmedAccel., size=confirmedTotal), alpha=0.4, col="orange") +     
    geom_point(aes(y=confirmedSpeed, size=confirmedTotal ), alpha=1, col="orange") +
    
    # geom_point(aes(y=confirmedSpeed-confirmedAccel., size=confirmedTotal-confirmedSpeed ), alpha=0.4, col="orange") + 
    
    # geom_col(aes(y=deathsSpeed, fill=deathRate), alpha=0.99) +
    geom_point(aes(y=deathsSpeed, size=deathsTotal, col= deathRate), alpha=1) +
    scale_color_distiller(palette = "Blues", direction = 1) +   #scale_fill_grey(0.3, 0.9) +
    # guides(col="none") +
    
    geom_segment( aes( 
      # xend=reorder(region, get(input$sortby)),
      xend = region,
      yend=confirmedSpeed, y=confirmedSpeed-confirmedAccel.      ), 
      size = 1, col="black",
      arrow = arrow(length = unit(0.1, "cm"))
    ) +
    
    
    # theme(legend.position = "bottom") +
    labs(
      title= paste0("Infected and deaths per day on ", input$dateToday),
      size="Total number of cases",
      fill="Growth rate (Rt)",
      col="Mortality rate (%)",
      # y="Infected (orange) and deaths (red) per day. \nChange since yesterday is marked by arrow.",
      
      y =  paste0(
        "Pandemic spread speed (average number of new cases a day)\n",
        "Change since yesterday is marked by arrow. Bar width is proportional to the total number of confirmed cases."),
      x=NULL,
      
      caption=caption.covid
    )
  
  
  if (input$log10 ) {
    g <- g + scale_y_log10()
  }
  
  g
  
}

plotTrends <- function(dt00, input) {
  cols <- c("confirmed", "recovered", "deaths")
  cols3 <- paste0(cols, input$fRadio)
  
  dtToday <- dt00[date==input$dateToday]
  dt <- dt00[date >= input$date]
  
  
  if (input$normalize == T)
    # if (input$normalize == T & dt$population %>% min(na.rm = T) > 1)
    dt[ , (cols3):= lapply(.SD, function(x) {as.integer(x/population*1000000)}),.SDcols=cols3]
  
  
  g <- ggplot( dt  ) + 
    
    facet_wrap(.~
                 # region,
                 reorder(region, -get(input$sortby))    ,  
               scales=ifelse(input$scale, "fixed", "free_y")   
    ) +
    #scale_y_continuous(limits = c(0, NA)) +
    # scale_y_continuous(limits = c(min(dt00[[ cols3[1] ]]), max(dt00[[ cols3[1] ]]) )) +
    scale_y_continuous(limits = c(min(dt[[ cols3[1] ]]), NA )) +
    
    geom_vline(xintercept=input$dateToday, col = "orange", size=2) +
    geom_vline(xintercept=ymd(input$dateToday)-14, col = "orange", size=1) +
    # geom_vline(xintercept=input$dateToday-14, col = "orange", size=1) +
    geom_point(aes_string("date", cols3[1]), alpha=0.5, col="purple", size=2) +
    geom_line(aes_string("date", cols3[1]), alpha=0.5, col="purple", size=1) +
    
    theme_bw() +
    scale_x_date(date_breaks = "1 week",
                 date_minor_breaks = "1 day", date_labels = "%b %d") +
    labs(
      
      title= paste0("Dynamics over time: from ", 
                    input$date , " to " ,  input$dateToday
                    # , 
                    # " (", input$fRadio, " over time)"
      ),
      
      # title= paste0("Number of infected from ", input$date , " to " ,  input$dateToday, 
      #               " (", input$fRadio, " over time)"),
      # 
      # subtitle=
      #   # r.subtitle(),
      #   paste0("Top ", min (dtToday %>% nrow, input$showN), " regions ",
      #          "in ", my.paste(input$region, ", "),
      #          " (sorted by '", input$sortby, "')."
      #          # , ". States/Provinces: ", my.paste(input$state, ", ")
      #   ),
      
      
      y=paste("Confirmed Cases ", input$fRadio, ifelse(input$normalize, " (per Million)","")),
      # y=paste("Cases"),
      # y=NULL,
      x=NULL,
      
      caption=caption.covid
    )
  
  if (input$log10 ) {
    g <- g + scale_y_log10()
  }
  
  if (input$trend ) {
    
    # if (input$trend_SE ) {
    g <- g + geom_smooth(aes_string("date", cols3[1]), size = 1, level=0.99,
                         method= "gam", # method= "gam",  formula = y ~ s(x,k=3),
                         # method = "lm", formula = y ~ poly(x, 4),
                         col = "black", linetype = 2, alpha=0.3)
    # } else
    #   {
    #   g <- g + geom_smooth(aes_string("date", cols3[1]), size = 1, se = FALSE,
    #                        method= "gam",   # method= "gam",  formula = y ~ s(x,k=3),
    #                        # method = "lm", formula = y ~ poly(x, 4),
    #                        col = "black", linetype = 3, alpha=0.5)
    # }
    
  }
  
  g
}



plotTrendsPrediction <- function(dt00, input) {
  
  dt00 <- dt00[date >= input$date]
  
  cols <- c("confirmed", "recovered", "deaths")
  cols3 <- paste0(cols, input$fRadio)
  
  cols <- c("confirmed")
  cols3 <- "confirmedSpeed"
  
  
  g <- ggplot( dt00 [result=="Observed"] ) + 
    # facet_wrap(.~ region      ) +
    scale_y_continuous(limits = c(min(dt00[[ cols3[1] ]]), NA )) +
    # 
    # geom_vline(xintercept=input$dateToday, col = "orange", size=2) +
    # geom_vline(xintercept=ymd(input$dateToday)-14, col = "orange", size=1) +
    # geom_vline(xintercept=input$dateToday-14, col = "orange", size=1) +
    geom_point(aes_string("date", "confirmedSpeed"), alpha=0.5, col="purple", size=2) +
    geom_line(aes_string("date", cols3[1]), alpha=0.5, col="purple", size=1) +
    
    
    theme_bw() +
    scale_x_date(date_breaks = "1 week",
                 date_minor_breaks = "1 day", date_labels = "%b %d") +
    labs(
      
      title= paste0("Dynamics over time: from ", 
                    input$date , " to " ,  input$dateToday
                    # , 
                    # " (", input$fRadio, " over time)"
      ),
      
      # subtitle=
      #   # r.subtitle(),
      #   paste0("Top ", min (dt %>% nrow, input$showN), " regions ",
      #          "in ", my.paste(input$region, ", "),
      #          " (sorted by '", input$sortby, "')."
      #          # , ". States/Provinces: ", my.paste(input$state, ", ")
      #   ),
      
      
      y=paste("Cases ", input$fRadio, ifelse(input$normalize, " (per Million)","")),
      # y=paste("Cases"),
      # y=NULL,
      x=NULL,
      
      caption=caption.covid
    )
  
  
  if (input$trend ) {
    
    # if (input$trend_SE ) {
    g <- g + geom_smooth(aes_string("date", cols3[1]),  data=dt00, size = 1, level=0.99,
                         method= "gam", # method= "gam",  formula = y ~ s(x,k=3),
                         # method = "lm", formula = y ~ poly(x, 4),
                         col = "black", linetype = 2, alpha=0.3)
    
  }
  
  g
}



plotMap <- function(dtToday, input) {
  
  # 
  # dtToday <- r.dt()[date==dateMax] 
  dtToday[, ratingcol:= ifelse(confirmedGrowth<1, "yellow", "red")]
  
  dtToday[, strMessage:= paste0(state, " - ", city, 
                                ":<br><b>Confirmed</b>",
                                "<br>  Total: ", confirmedTotal, "(", confirmedTotalPercentage, "%)",
                                "<br>  Daily: ", confirmed, "(", confirmedPercentage, "% population)", 
                                "<br> <b>Deaths</b>",
                                "<br>  Total: ", deathsTotal, "(", deathsTotalPercentage, "%)",
                                "<br>  Daily: ", deaths, "(", deathsPercentage, "% population)",
                                "<br><b>Death rate </b>", 
                                "<br>  Today: ", deathRate, ". Average: ", deathRateAverage, 
                                "<br>  Rt = ", confirmedGrowth 
  )  ]
  
  leaflet::leaflet(dtToday) %>% 
    addTiles() %>%
    addCircleMarkers(~lng, ~lat, 
                     color = ~ratingcol, 
                     popup = ~strMessage,
                     label = ~paste0(region, ": ", confirmed, "(", confirmedPercentage, "%) / day. R0=", confirmedGrowth) 
    ) %>% 
    addPopups(~lng,  ~lat, 
              popup = ~paste0(city, ": ", confirmed, " / day. Rt=", confirmedGrowth) 
    )  %>%
    addLegend("bottomleft",
              colors = c("yellow","red"),
              labels = c(
                "Growth (Rt) < 1",
                "Growth (Rt) > 1"),
              opacity = 0.7)

  
}
  


plotMap.doesnotworkwithUS <- function(dt, input) {
  
  # pal <- colorNumeric(c("green", "yellow", "red"), 0:30)
  
  dt[, ratingcol:= 
       ifelse(confirmedSpeed==0, "green",
              ifelse(confirmedGrowth.<1, "yellow",
                     ifelse(confirmedGrowth. == 1, "orange", "red")))
     ]
  
  dt[, strShort:= paste(
    # region, "- ", confirmedSpeed, "(",  confirmedAccel., ") / day"
    sprintf("%s: %i (%+.2f) / day. R0=%.3f", 
            region, 
            as.integer(confirmedSpeed), confirmedAccel., confirmedGrowth.
    )
  )
  ]
  
  dt[, strMessage:= paste(
    # region,
    sprintf("<b> %s </b><br>", region),
    
    sprintf("Growth rate (R0):  %+.3f (%+.3f)  <br>", as.integer(confirmedGrowth.), confirmedGrowth.Accel),
    sprintf("INFECTED:  %i (%+.2f) / day <br>", as.integer(confirmedSpeed), confirmedAccel.),
    # sprintf("Per capita, in a million:  %i (%+i) / day <br>", as.integer(confirmedSpeedPerMil), as.integer(confirmedAccel.PerMil)),
    sprintf("DEATHS:  %i (%+i) / day <br>", as.integer(deathsSpeed), as.integer(deathsAccel.)),
    # sprintf("Per capita, in a million:  %i (%+i) / day <br>", as.integer(deathsSpeedPerMil), as.integer(deathsAccel.PerMil)),
    #     sprintf("TOTAL:  %i (%+.2f) / day <br>", as.integer(confirmedSpeed), confirmedAccel.),
    # "TOTALS: ", confirmedTotal
    "MORTALITY RATE: ", deathRate, "(%)"
    # sprintf("Mortality rate: %.2f (%%)", deathsTotal/confirmedTotal) 
  )
  ]
  
  
  leaflet(data = dt) %>% 
    addTiles() %>%
    addCircleMarkers(~lng, ~lat, 
                     #color = ~pal(traveller), 
                     # radius = ~ confirmedSpeed,
                     color = ~ratingcol, 
                     popup = ~as.character(strMessage),
                     label = ~strShort, #"Click for details", #~region
                     labelOptions = labelOptions(
                       noHide = F,
                       direction = 'auto')
    ) %>% 
    #  addMarkers(clusterOptions = markerClusterOptions())
    #  addMarkers(~lng, ~lat,   popup = ~as.character(confirmedSpeed), label = paste("BWT: ", ~confirmedSpeed)             )  %>%
    addPopups(dt$lng, 
              dt$lat, 
              popup = dt$strShort, # region, 
              options = popupOptions(
                closeButton = F) 
    )   %>%
    addLegend("bottomleft",
              colors = c("green", "yellow", "orange", "red"),
              labels = c(
                "COVID free",
                "R0<1",
                "R0=1",
                "R0>1"),
              opacity = 0.7)
}



# ****************************************************** ------
# *** R101 - 01-read.R ****************************************************** -------
# ****************************************************** ------
# R101
# 01-read.R
# https://github.com/IVI-M/R-Ottawa/new/master/r101
# Last updated: 22 May 2020

# 0. General libraries and functions ----

# print(sessionInfo())
# source("000-common.R")
source("dt.R")  

# if (T) { 
#   options(scipen=999); #remove scientific notation
#   library(data.table)
#   options(datatable.print.class=TRUE)
#   library(magrittr)
#   library(lubridate)
#   library(ggplot2)
#   library(plotly)
#   library(DT)
# }
# 
# STR_TOTAL <- "COMBINED"


# *********************************** -----

TEST_ME <- function() {
  
  #  1.0 Reading data   ----
  
  dtGeo <- readGeo()
  dtGeo
  dtGeo[city == 'New York'] # No such city???
  dtGeo[state == 'New York'] # Lets find it
  dtGeo[state == 'New York']$city
  
  # lets fix it !
  dtGeo[city == 'New York City', city:='New York']
  
  dtUS <- readCovidUS()
  dtUS
  dateMax <- dtUS$date %>% max; dateMax
  
  dtUS$recovered <- NULL
  
  #  1.1 New-York example   ----
  
  dtUS[state == 'New York']$city %>% unique
  
  city <- "Suffolk"
  city <- "New York"
  
  dtUS[city == 'Suffolk'][date==dateMax]
  dtUS[city == 'New York'][date==dateMax]
  dtUS[state == 'New York' & date==dateMax]
  
  # . Find top 3  cities in New York ----
  
  
  dt0 <-  dtUS[state == 'New York']
  dt0$city %>% unique() %>% length
  
  dt <- dt0[date==dateMax][order(-confirmed)][1:3];
  dt
  topNcities <- dt$city ; 
  topNcities
  dt <- dt0[ city %in% topNcities];
  dt
  
  # copied to covid.reduceToTopNCitiesToday <- function(dt0, N=5) 
  
  # Now the same using the function
  dt0 <- dt0 %>% covid.reduceToTopNCitiesToday()
  dt0$city %>% unique()
  dt <- dt0
  
  
  #  1.2 Merging Geo with Stats data   ----
  
  dtAll <- dtGeo [dt, on=c("country" , "state" , "city")];dtAll
  
  # 2. Plotting
  
  g <- dtAll[city == 'New York'][ date > dateMax - 30] %>% 
    ggplot() + 
    geom_line(aes(date, confirmed), col="orange") +
    geom_line(aes(date, deaths), col="red") 
  g
  
  dtAll[ date > dateMax - 30] %>% 
    ggplot() + 
    #facet_wrap( city ~ .) +
    # facet_wrap( reorder(city, lng) ~ .) +
    facet_wrap( reorder(city, -confirmed) ~ ., scales="free") +
    # facet_wrap( reorder(city, state) ~ .) +
    geom_line(aes(date, confirmed), col="orange") +
    geom_line(aes(date, deaths), col="red") +
    labs(
      title= paste0("Infected per day"),
      subtitle=paste0("State: ", 'New York', ". Date: ", dateMax),  
      caption=paste0(
        "Cities are sorted by location\n", 
        "Data source: Johns Hopkins University U.S. Coronavirus database\n", 
        "Generated by R Ottawa"
      )
    )
  
  
  ggsave("New York.png")
  
  # 1.3 Compute some stats: Totals
  
  
  dtAll[, sum(confirmed),  by=city][]
  dtAll[, sum(deaths),  by=city][]
  
  dtAll[ date > dateMax - 3][, mean(confirmed),  by=city][]
  dtAll[ date > dateMax - 3][, mean(deaths),  by=city][]
  
  # Better way
  
  cols <- c("confirmed", "deaths")
  colsTotal <- paste0(cols, "Total"); colsTotal
  colsSpeed <- paste0(cols, "Speed"); colsSpeed
  
  dtAll[, lapply(.SD, sum), .SDcols=cols]
  
  my.filter <- function(vector) {
    # ( vector[length(vector)] + vector[length(vector)-1] ) / 2
    ( vector[length(vector)] + vector[max(1, length(vector)-1) ] ) / 2
  }
  my.filter (1:10)
  
  dtAll[, lapply(.SD, my.filter), .SDcols=cols]
  
  
  # . By city ----
  
  dtAll[, lapply(.SD, sum), by=city, .SDcols=cols] 
  
  dt2 <- dtAll[, lapply(.SD, sum), by=city, .SDcols=cols] %>% setnames(cols, colsTotal)
  
  dt3 <- dtAll[, lapply(.SD, my.filter), by=city, .SDcols=cols] %>% setnames(cols, colsSpeed)
  
  dt2[dt3, on="city"]
  
  
  # .. Total for each day so we can plot it ----
  
  dtAll[, (colsTotal):= lapply(.SD, cumsum), .SDcols=cols]
  
  dtAll[ date > dateMax - 30] %>% 
    ggplot() + 
    #facet_wrap( city ~ .) +
    # facet_wrap( reorder(city, lng) ~ .) +
    # facet_wrap( reorder(city, lng) ~ ., scales="free") +
    facet_wrap( reorder(city, -confirmed) ~ .) +
    # facet_wrap( reorder(city, state) ~ .) +
    geom_line(aes(date, confirmedTotal), col="orange") +
    geom_line(aes(date, deathsTotal), col="red") +
    labs(
      title= paste0("Total infected"),
      subtitle=paste0("State: ", 'New York', ". Date: ", dateMax), 
      caption=paste0(
        "Cities are sorted by location\n", 
        "Data source: Johns Hopkins University U.S. Coronavirus database\n", 
        "Generated by R Ottawa"
      )
    )
  
  
}


# ****************************************************** ------
# *** END of R101 *************************************************** ------
# ****************************************************** ------


# *** TEST ZONE ****************************** ------
testme <- function() {
  
  #  source("covid-read.R")
  
  dtJHU <-readCovidJHU() %T>% print; 
  dtCa <- readCovidUofT() %T>% print 
  dtUS <- readCovidUS() %T>% print
  dtJHU[.N]; dtCa[.N]; dtUS[.N]
  dtAll <-   dtJHU %>% rbind ( dtCa ) %>% rbind (dtUS)
  
  dateMax <- dtAll$date %>% max ; dateMax
  
  
  
  dtGeoAll <-readGeo() %T>% print
  # dtGeoCa <- readGeoCa() %T>% print
  # dtGeoAll <- dtGeoCa %>% rbind(dtGeo)
  
  colsGeo <- c("country",   "state",       "city")
  colsCases <- c("confirmed", "deaths", "recovered")
  
  dtAll [, (colsCases):= lapply(.SD, tidyr::replace_na, 0), .SDcol = colsCases]
  
  dt <- dtGeoAll [dtAll, on=colsGeo]
  
  dt <- addDerivatives(dt, colsCases, colsGeo) # , input$convolution)
  
  
  
  dt [ , deathRate:= as.integer(deathsTotal / confirmedTotal * 100 )]
  dt [ , recoveryRate:= as.integer(recoveredTotal / confirmedTotal * 100 )]
  
  dt [ , activeTotal := confirmedTotal - recoveredTotal - deathsTotal]
  
  cols <- c("confirmed", "deaths",  "confirmedTotal" ,  "deathsTotal"  ,  "confirmedSpeed"  , "deathsSpeed"   )
  colsPerMil <- paste0(cols, "PerMil")
  dt[ , (colsPerMil):= lapply(.SD, function(x) {as.integer(x/population*1000000)}),.SDcols=cols]
  
  
  dt %>% names()
  
  colsNeeded <- c(
    "date"       ,      "country"   ,       "state"      ,      "city"      ,    
    "lat"       ,       "lng"            ,    "population"    ,
    # "confirmed",        "deaths"  ,   
    "confirmedTotal",   "deathsTotal"  ,   "confirmedSpeed" ,  "deathsSpeed"    ,  
    "confirmedAccel."  , "deathsAccel."  ,  "confirmedGrowth." ,"deathsGrowth.", "deathRate", 
    "confirmedTotalPerMil" ,"deathsTotalPerMil"  ,  "confirmedSpeedPerMil","deathsSpeedPerMil"  
  )
  
  
  dtGeo0 <- dt[date == dateMax][, (colsNeeded), with=F]
  
  setcolorder(dtGeo0, c( "date", "country" , "state" , "city" , "lat", "lng" , "population"  ) )
  
  saveRDS(dtGeo0, "dtGeoAll-0.Rds")  
  dtToday <- readRDS("dtGeoAll-0.Rds") 
  
  
  dtToday[ , region:=paste0( str_trunc(country, 2, ellipsis = ""), "-", str_trunc(state, 3, ellipsis = ""), ": ",  city)]
  
  dtToday %>% names
  dtToday [order(get(input$sortby))][1:input$showN]
  dtToday0 <- dtToday[country == "Canada"]
  
  
  # dt000: country=="Canada" & city=="Ottawa" ----
  
  
  
  dt000 <- dtAll[dtGeo0[country=="Canada" & city=="Ottawa", c(colsGeo, "lat", "lng", "population"), with =F], on=colsGeo]; dt000
  
  addDerivatives(dt000, colsCases, colsGeo) # , input$convolution)
  
  dt000$result <- "Observed"
  dt000 <- addPredictions(dt000, colsCases,  dateMax, N=7)
  dt000 <- addPredictions(dt000, colsCases,  dateMax, N=14)
  
  # dt000 <- addPredictions(dt000, colsCases,  dateMax, N=1); 
  # dt000 <- addPredictions(dt000, colsCases,  dateMax, N=3)
  # dt000 <- addPredictions(dt000, colsCases,  dateMax, N=2)
  
  dt000[ , .(date, confirmedSpeed,result)]
  
  
  dt000[ , region:=paste0( str_trunc(country, 2, ellipsis = ""), "-", str_trunc(state, 3, ellipsis = ""), ": ",  city)]
  
  
  plotTrendsPrediction( dt000, input)
  
  # .... plot  ----
  
  input$country <- "Canada";  input$state <- "Ontario" ; input$city <- "Ottawa"
  input$country <- "US";  input$state <- "New York" ; input$city <- "New York"
  
  
  input$sortby = choices[6]; input$sortby
  
  input$showN = 20
  
  
  input$city <- STR_ALL
  
  dtToday [    country %in%input$country  & state %in%  input$state ] [ city %in% input$city ]  
  
  
  dtToday0 <- dtToday [ country %in% ifelse  (input$country == STR_ALL, dtToday$country %>% unique, input$country )]  ; dtToday0
  dtToday0 <- dtToday0 [ state %in% ifelse  (input$state == STR_ALL, dtToday0$state %>% unique, input$state )]  ; dtToday0
  #  dtToday0 <- dtToday0 [ city %in% ifelse  (input$city == STR_ALL, dtToday0$city %>% unique, input$city )  ]  ;dtToday0
  dtToday0 <- dtToday0 [order(get(input$sortby))][ 1:input$showN] ; dtToday0
  
  input$sortby = "confirmedGrowth."
  input$fRadio = "confirmedSpeed"
  
  
  
  if (inp$sortby =="name"){
    dtToday0[ , region := reorder(region, confirmedSpeed)]
  } 
  
  dtToday0$region <- reorder( dtToday0$region , dtToday0[[input$sortby ]] )
  
  
  
  
  
}

