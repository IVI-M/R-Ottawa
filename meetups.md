

# Lunches with Data Challenges - Weekly meet-ups

[ Home ](https://IVI-M.github.io/R-Ottawa/) --  [ Resources ](resources.md) -- [ Community ](community.md) -- [Lunches with Data Challenges](meetups.md) -- [ R-101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101)


### Dial-in details

Topic: Lunches with Data Challenges    
Lead by: Dmitry Gorodnichy      
Time: Every Wednesday, starting March 18 1,2020 at 12:20-12:50 AM Eastern Time (US and Canada)    
Join Zoom Meeting: https://us04web.zoom.us/j/337086550     
Password: *please contact the organizer or get it from
[GCCollab](https://gccollab.ca/discussion/view/4482867/enlunches-with-data-challenges-on-wednesdays-on-rfr)*


### Agendas:

See also [ R-101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101) for archived discussed codes.


2020/04/29: (this session was recorded and will be posted in [GCCollab](https://gccollab.ca/discussion/view/4482867/enlunches-with-data-challenges-on-wednesdays-on-rfr)*

- - Jump start to coding in R from [https://rstudio.cloud](https://rstudio.cloud) - (requires gmail or other email to login)
- Programming together in [https://rstudio.cloud](https://rstudio.cloud) 
  - new project -> new R file -> copying codes from R101 into your project -> saving it -> 
  - trying to run a line to open JHU Covid data using `data.table` package
    - Overview of visualization that canbemadefrom this dataset in iTrack Covid App
  - installing missing libraries (`source("000-common.R')` - added to [ R-101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101) )
  - trick for viewing the table of contents of your code
  - commenting with `#` (CNTRL+SHIFT+C)
- Doing tutorial from [https://rstudio.cloud](https://rstudio.cloud) together (more at https://rstudio.com/ -> Reources -> Education)
  - Left menu -> Primers -> The Basics -> Visualization Basic, using built-in `mpg` dataset
- Introduction to RMarkdown -> new R markdown. Converting it to html. Use of comments `<!--` - `-->` (CNTRL+SHIFT+C)
  - iTrack Covid App is written in RMarkdown
  
- Note on using RStudio in CBSA - Install instruction for CBSA employees are added in [here](install.md)


2020/04/22: (Zoom meetings extended to GC)

- Introductions to wider GC community
- Overview of R Ottawa resources, apps and topics of interest
- Walk through the iTrack Covid App, and associated data processing challenges (e.g. dealing with missing/negative entries)
- Code to read data from JHU database - added

2020/04/15:  (Accessing Covid data for Canada)

- Problem with direct access to Covid .csv data from Stats Canada site. 
- Code to read data from UofT google doc - added

2020/04/01:  (Focus shifted to Covid data)

- Since the break-up of covid pandemic, we discuss covid data related challenges and solutions (how to read it, visualize it, make good use of it using R and AI). 
- Public datasets on Covid - in Canada and International


2020/03/24: (Meet-ups go Zoom)

- What's up with our work and Community  with new normal -  in CBSA and elsewhere
- Where do we go from here


###  List of topics available for discussion

- [https://itrack.shinyapps.io/covid](https://itrack.shinyapps.io/covid/):   
Interactive Web App to better visualize and predict the spread of Covid19 pandemic [(LinkedIn article](https://www.linkedin.com/pulse/interactive-web-app-visualize-predict-spread-covid19-gorodnichy/))
  - accessing remote data: from GitHub (JHU database), from Google Docs (UofT database)
  - fast data manipulation using `data.table`
  - strategies for dealing with data abnomalities
  - use of `plotly` (interactive graphs), `DT` (interactive data tables), `dygraph`(interactive time-series visualizations)
  - `shiny` (interactive menus)
  - `rmarkdown`, `flexdashboard` - automated generation of reports and dashboards 
    - static self-contained html reports (which can be shared by email or locally),  vs.  
    - dynamic Web Apps reports/apps (which need to be hosted on the R server)
  - short-term forecasting 101 (features, assumptions, predictive models)
  - reproducible data science
  - functional, modular, scalable, agile programming
  - software Engineering 101 (naming conventions, splitting and sourcing, source control, github)
  
- [https://itrack.shinyapps.io/border/](https://itrack.shinyapps.io/border/)   
Predicting and optimizing Border Wait Time using Artificial Intelligence  [(LinkedIn article](https://www.linkedin.com/pulse/predicting-optimizing-border-wait-time-using-dmitry-gorodnichy/))
  - use of `leaflet` (interactive map)
  - building predictive models / machine learning
  - machine learning 101 (features, assumptions, predictive models), 
    - short-term vs. long-term forecasting
  - operations reseach 101 (resource optimization, constraint satisfaction)
  - running simulations  using `simmer`
  
- [https://itrack.shinyapps.io/PSES/](https://itrack.shinyapps.io/PSES/):   
Improving Public Service performance using Public Service Employee Surveys and Data Science [(LinkedIn article](https://www.linkedin.com/pulse/analyzing-improving-public-service-performance-using-data-gorodnichy/))
  - Compare to: PSES Power BI Visualization Tool from [https://hranalytics-analytiquerh.tbs-sct.gc.ca](https://hranalytics-analytiquerh.tbs-sct.gc.ca)
  - graphics and annotations with `ggplot2`
  - nested menus in `shiny`
  - `flexdahboard` layouts and options
  - data aggregation using `data.table`
  - automated report generation using `knitr` and `glue`


Check  [ R-101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101) for samples of discussed R codes.   
Back to [R Ottawa](https://ivi-m.github.io/R-Ottawa/). 
