---
title: "CMPUT101 "
subtitle: "Fundamentals of Software Engineering (with application to Data Engineering)"
author: "Dmitry Gorodnichy"
date: "Lunch and Learn (Summer, 2020) - under construction"
---


## Outline

- Part 1: General Software Engineering principles
- Part 2: Working with Data (Data Engineering as part of Software Engineering)
- Part 3: Walk through  the "COVID App" and "XXX Audit" Projects examples
- References 


## Part 1: General Software Engineering principles



- Starting your code

- Growing your code

- Saving/source-controling your code

- Sharing your code


## Starting your code

- All functions - Source-agnostic (never use hard-coded values or variable names)
- All codes - modular (`function()` or `if()` )
  - Each module finished -> tested -> saved
  - All useful (re-usable) portions converted to functions
  - Put finished large / multiple portions in a separate file: then  `source("000-common.R"")` or `{r covidApp_base.Rmd, child = 'covidApp_base.Rmd'}`
  - No  "spagetti codes"... 
  
- All variable types and meaning should be undestood by name (unless used within one screen size)
  - Hungarian notation: eg. `dtGeoCa` (not `canada_geo_data`) - easy for sortning and hierchy viewing

- Pay attention to proper indentation and other "abnormalities" that IDE shows you

- Extensive dynamic use of comments (in both .R and .Rmd)
  - When you have an  idea, but dont know how to phrase it or code it, or crashes -> put in comments!
  
- Extensive use of Table of Contents (and label) - for seeing the   
  
- Less good *English/French* language, More good _Computer_ language (inside .R)
  - use .Rmd for reporting
  
  
## OOP (Object Oriented Programming)

- Think OOP ! (even when you don't use Objects, think `library(R6)` or `modules`)
  - keep everything belonging to one Project (Object) in one place, use object identifiers in their names and functions (`covid.readData()`, `covid.readGeo()`) - for all functions working with Covid
  - Use identifiers for scripts belonging to one project (`01-covid_read.R`, `01-covid_plot.R` etc)
- parts that can be reused in other projects, move elsewhere (`000-common.R`, `00-)


## Growing your code


- maintain x.x.x style for version number and Release Notes (e.g., CovidApp_v040.Rmd)
- maintain Bug / issues / TODO list 
- backup strategies (on github, and locally - save all documented Releases)


##  Saving your code - source-control

- `conda install git`, Git directly from RStudio
- gc codes (gitlab)
- github.com

<!-- - https://blog.developer.atlassian.com/the-power-of-git-subtree/ -->



<!-- ## Sharing your code, working in a team -->

<!-- - By Email  -->
<!-- - Put it in Apollo -->
<!-- - AWS Code Commit  -->
<!-- - GC codes - All GC -->



## Part 2: Working with Data 


- Read data strategies

- View data strategies

- Rename variables

- Reshape data

- Tidy data

- Organize data (merge, split - according to logic)




## Part 3:  Examples

### COVID App (R Ottawa Lunch and Learn)

- we build App for US, but then ... (almost as magic) with one line replacement, we can convert the App process data from Canada
- source control: at github and inside RStudio in `rstudio.cloud`

### "XXX Audit" Project example

- DG built .R library (script containing functions) and .Rmd example that he shared to  DS
  - DS can a) now use it to build his own .Rmd reports,  b) buld his own library (using the same framework)
  - Anyone can use them. 
- Leverages multiple .R libraries that Dmitry wrote between 2015-2020, further improves those libraries
- Source-control:
  - on local laptop using GIT within RStudio
  - "Sharing"  by emailing (for now)
  - Each developer responsible for her own source file


Other examples (we can use): 

- hobby projects: Geomapping of Covid (used in R Ottawa Lunch and Learn R101), Geomapping of BWT (https://itrack.shinyapps.io/border/), PSES (https://itrack.shinyapps.io/PSES/); 
- CBSA projects: Expert system for BWT prediction/optimization, data cranching and AI for [AVATAR / Behaviour screening project](https://sites.google.com/site/aider4canada/projects/behaviour)






## References:

- R Ottawa Resources page: https://github.com/IVI-M/R-Ottawa/resources.md
  - https://github.com/IVI-M/R-Ottawa/r101
- TBA

### About Author:   

- 10+ years of education in Computing Science, 20+ years of data/AI code developing
- Instructor & course coordinator in CMPUT 101 at UofA in 1999-2000 
- Developed over dozen of complex end-user data processing  / AI tools (eg www.nouse.ca, more on https://github.com/gorodnichy)

