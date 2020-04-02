
# File: LnL-1-intro.R
# Author: Gorodnichy
# Version: 0.1

if (T) { # Start ----
  library(magrittr)
  library(ggplot2)
  library(data.table)
  library(lubridate)
}



if (T) { # 1. Read and merge/bind data  ----
  
  dtLocations<- fread("data/wloc-index.txt")
  dtLocations %>% names()
  dtLocations$Vendor <- NULL
  dtLocations
  dtLocations[WLOC == 4313, WLOC:=4312][]
  
  if (T) {
    dt <- rbind (
      fread("data/PIK Extract  - Passage Details 20190401 20190707.tab"),
      fread("data/PIK Extract  - Passage Details 20190708_20190929.tab")
    ) 
  } else { # The same using pipeline operator %>% : 
    dt <- fread("data/PIK Extract  - Passage Details 20190401 20190707.tab") %>% 
      rbind(
        dt <- fread("data/PIK Extract  - Passage Details 20190708_20190929.tab")
      )
  }
  dt
  dt %>% str
  
  #strNames <- dt0 %>% names(); strNames
  dt[ , `Passage Date` := ymd(`Passage Date`)]
  setnames(dt, "Passage Date", "Date")
  
  aWLOC <- dt$WLOC %>% unique; aWLOC

  
}

if (T) { # 2. Get small sample to work with ----
  
  if (F) { 
    # randomly sample 1000 data points
    dt1 <- dt [sample(nrow(dt), 10000)][order(PSG_REF_ID)]
  } else {
    # for selected Port and dates
    aWLOC1 <- aWLOC[1:4]; aWLOC1
    
    #dateEnd <- format(Sys.time(), "%Y-%m-%d") %>% ymd; dateEnd
    dateEnd <- ymd("2019-04-29")
    dateStart <- dateEnd - 7; dateStart
    
    dt1 <- dt [WLOC %in% aWLOC1 & 
                 Date <= dateEnd & Date >= dateStart]
    #`Passage Date` <= dateEnd & `Passage Date` >= dateStart]
  }
  
  if (F) {
    View(dt1)
  }
  
  dt1 %>% names
}

if (T) { #3. Compute Error rates by Date and Location ----

  dtRes <- dt1[, .(.N, 
                   N_PNC1=sum(`PNC1 FM score below threshold`), 
                   N_PNC2=sum(`PNC2 Failed Photo Capture`), 
                   N_PNC5=sum(`PNC5 No PKD Certificate - not ePassport]`) ), 
               by=c('Date','WLOC')][, ':='(
               #by=c('Date','WLOC', 'Traveller Citizenship', 'Traveller Gender')][, ':='(
                 N_PNC1=round(N_PNC1/N*100,1),
                 N_PNC2=round(N_PNC2/N*100,1), 
                 N_PNC5=round(N_PNC5/N*100,1)
               )
               ]; 
  
  
  dtRes <- dtLocations[dtRes, on="WLOC"]
  dtRes

}


if (T) { # 4. Plot Error rates ----
  ggplot(dtRes) + 
    theme_bw() +
    #scale_color_brewer()
   
    geom_line( aes(Date, N_PNC2), col="red", size=1 ) +
    #geom_line( aes(Date, N_PNC2, col=`Traveller Gender`), col="red", size=1 ) + 
    geom_line( aes(Date, N_PNC5), col="orange", size=1 ) + 
    geom_line( aes(Date, N_PNC1), col="blue", size=1 ) + 
    #geom_line( aes(Date, N_PNC1+N_PNC2+N_PNC5), col="black", size=2 ) + 
    facet_grid(.~City) +
    labs(title="PIK performance over time" ,
         y="Failure rate (%)", 
         caption="Blue: below threshod (PNC1). Red: failure to capture (PNC2). Orange: failure to open e-chip (PNC5). Black: Combined",
         subtitle=paste0("Dates: ", dateStart, " - ", dateEnd))
  
  ggsave(paste0(dateStart, "-", dateEnd, "_PNC=f(Date,WLOC).png"), width=16, height=12)
  
  
  ggplot(dtRes) + 
    theme_minimal() +
    #scale_color_brewer()
    
    geom_line( aes(Date, N_PNC2), col="red", size=1 ) + 
    geom_line( aes(Date, N_PNC5), col="orange", size=1 ) + 
    geom_line( aes(Date, N_PNC1), col="black", size=1 ) + 
    #geom_line( aes(Date, N_PNC1+N_PNC2+N_PNC5), size=3 ) + 
    facet_grid(WLOC~.) +
    labs(title="PIK failure codes by WLOC (%)" ,
         subtitle="(PNC1 - black, PNC2 - red, PNC5 - orange)",
         caption=paste0("Dates: ", dateStart, "-", dateEnd))
  
  
  
  
}






# TMP -----







<!-- 
  
  This is Chart 1.3  

```{r}
library(ggplot2)
dt <- diamonds

``` 


# HEader 2


## Chart 1.3

This is Chart 1.3  

```{r}
ggplot(dt) + geom_histogram(aes(price)) + facet_grid(cut ~ color) + labs(title="Histogram of Price, as function of cut nd color")
```

## Column 2 {.tabset}


### Chart 2


This is Chart 1.3  

```{r}
ggplot(dt) + geom_histogram(aes(carat)) + facet_grid(cut ~ color) + labs(title="Histogram of carat, as function of cut nd color")
```

### Chart 3

```{r}
ggplot(dt) + geom_histogram(aes(x+y+z)) + facet_grid(cut ~ color) + labs(title="Histogram of x+y+z, as function of cut nd color")
```


## More selections

```{r eruptions, echo=FALSE}
inputPanel(
  selectInput("n_breaks", label = "Number of bins:",
              choices = c(10, 20, 35, 50), selected = 20),
  
  sliderInput("bw_adjust", label = "Bandwidth adjustment:",
              min = 0.2, max = 2, value = 1, step = 0.2)
)

renderPlot({
  hist(faithful$eruptions, probability = TRUE, breaks = as.numeric(input$n_breaks),
       xlab = "Duration (minutes)", main = "Geyser eruption duration")
  
  dens <- density(faithful$eruptions, adjust = input$bw_adjust)
  lines(dens, col = "blue")
})
```


-->
  
  
 