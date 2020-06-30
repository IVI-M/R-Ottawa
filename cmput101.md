---
title: "CMPUT101"
subtitle: "Fundamentals of Software Engineering (with application to Data Engineering)"
author: "Dmitry Gorodnichy"
date: "Lunch and Learn (Summer-Fall, 2020)"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = FALSE)
```


## Outline

- Part 1: General Software Engineering principles
- Part 2: Working with Data (Data Engineering as part of Software Engineering)
- Part 3: Walk through  the "PIK Audit" Project example
- References 


## Part 1: General Software Engineering principles



- Starting your code

- Growing your code

- Saving/source-controling your code

- Sharing your code


## Starting your code

- All functions - Source-agnostic (never use hard-coded values or variable names)
- All codes - modular (`function` or `if()` )
  - Each module finished -> tested -> saved
  - All useful (re-usable) portions converted to functions
  - Larger / multiple portions in a separate file - and `source` it
  - No more "spagetti codes". 
  
- All variable types and meaning undestood by name (unless used within one screen size)
  - Hungarian notation: eg. `dtGeoCa` (not `canada_geo_data`)

- Constant check of proper indentation and other "abnormalities" that IDE shows you

- Extensive dynamic use comments (in both .R and .Rmd)
  - You have an  idea, but dont know how to phrase it or code it -> put in comments!
  
- Extensive use of Table of Contents (and label) - for seeing the   
  
- Less English/French language, More _proper_ Computer language (inside .R)
  - (there's .Rmd down for that)
  
  
## OOP (Object Oriented Programming)

- Think OOP ! (even when you don't use Objects, think `library(R6)` or `modules`)
  - keep everything belonging to one Project (Object) in one place, use object identifiers (`pik.readData()`)
  - I use identifier for each project (`01-pik_read.R)
- parts that can be reused in other projects, move elsewhere (`000-common.R`, `00-)


## Growing your code


- maintain a.a.a version number and Release Notes (eg PIK_AIDIT_v040.Rmd)
- maintain Bug / issues / TODO list 
- backup strategies


##  Saving your code - source-control

- `conda install git`, Git directly from RStudio
- gc codes (gitlab)
- https://blog.developer.atlassian.com/the-power-of-git-subtree/



## Sharing your code, working in a team

- Email to colleagues
- Put it in Apollo
- AWS Code Commit - CBSA only 
- GC codes - All GC



## Part 2: Working with Data 



- Reading data




## Part 3:  "PIK Audit" Project example

- DG built .R library (script containing functions) and .Rmd example that he shared to  DS
  - DS can a) now use it to build his own .Rmd reports,  b) buld his own library (using the same framework)
  - Anyone can use them. 
- Leverages multiple .R libraries that Dmitry wrote between 2015-2020, further improves those libraries
- Source-control  
  - on local laptop using GIT within RStudio, file + Apollo, 
- "Sharing"  by emailing (for now)


Other examples (we can use): 

- hobby projects: Geomapping of Covid (used in R Ottawa  R101), Geomapping of BWT, PSES; 
- CBSA projects: Expert system for BWT prediction/optimization, data cranching and AI for AVATAR (lie detection) 






## References:


R Ottawa Resources page: https://github.com/IVI-M/R-Ottawa/resources.md

About:   
- 10+ years of education in Computing Science, 20+ years of data/AI code developing
  - instructor & course coordinator in CMPUT 101 at UofA in 1999-2000.
  - Developed over dozen complex end-user data processing  / AI tools 
-  Invited by CSPS Digital Academy and uOttawa to teach R 
  -  Teach at R Ottawa "Lunch and Learn R"
