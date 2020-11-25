# Transcript 

## "Learning R together" (Building Covid App from scratch). Session 1 : 2020-04-29



1:00  - introduction and logististics (please post questions in chat or off-line by email)

6:30   - overview of pages that I'll be using in these Wed sessions:
 - This R Ottawa portal
    - `/r101` folder with R codes (This is where I'll be putting the codes and  session transcripts)
 - `rstudio.cloud` (This is where we will be coding)
 
 10:00    - showing how to start Tutorials that are included in `rstudio.cloud`
  - we start the very first Visualization tutorial,  which creates a graph of `mpg` (miles per gallon) as  function of car models     
  NB: the dataset that we use here is called `mtcars` included in R - so you can play with it any time!     
  Other most frequenctly used in R teaching datasets are  `iris` and ` ggplot2:: diamonds`

  
14:00 -  Creating your own first project (This is where will read and visualize Covid data)
  - NB: note this is exactly the same RStudio that I have on my local CBSA laptop
  - create New -> R script
  
15:20 -  Copyng a line from `readCovidJHU.R`  (which reads US .csv data from JHU using `fread()`  ) into our new R Script
  
- Press `CTRL + Enter` to run it
- Our first Error!   in `fread` - missing libraries
  
16:00 - copying libraries from `readCovidCanada.R` into my R Script
 
18:00 - installing missing libraries
  NB: when R Studio sees that you are using libraries (e.g. `library (data.table)` ) and you don't have it yet installed, it will ask you (on the top line in your editor window) if you want to install the missing library

19:00  - showing my RStudio on my home machine (Note; My setup is the exacty same, but I used Dark colour scheme]
- Running `sessionInfo()` 3.6.1
- showing the content of my folder

20:00 - going back to cloud RStudio
- observing what are files are there
- Saving our R script as `01-read.R`. Now we have a new file there in our remote directory

21:00 - yellow line on top shows all packages that are listed in the code and that are not installed yet. You can click there to install them all.   
   (I don't do it now because it will take long time, please do it on you own)

22:30  - going  through the functionalities of the *iTrack Covid - Canada* App that i developed on my own (NB: Now you can instead Ssee our final product that we developed within this R101 from Session 1 to Session 9: https://itrack.shinyapps.io/covid/us.Rmd)
- It all started with exactly the same line that we just pasted today into our script
- What do I do first in my code? I read current time, then I read time when dataset was updated.

25:00 - Talking about data challenges that I had to reseolve for my *iTrack Covid - Canada* App 
- I compute speed and acceleration 
(which are derivative of totals and derivative of speed, derivative being the difference in adjacent values)  
- howeverm note that data are not smooth! It jumps back and forth, sometimes  data are not available (NA), sometimes negative!
You can't just  take the differences to compute the derivatives. You need to smooth the data (do the so called convolution)

27:00  - continuing looking int the functionalities of the *iTrack Covid - Canada* App 
- in one line, we can write a function that approximates the relationship between vertical and horizontal values of the plotted graph
When we have this function, we can use to predict value in future

29:00 - Running `sessionInfo()` in cloud session:  it shows 3.6.0 which is older then the version I have my home computer

29:30 - Note for CBSA.
R was approved by IT and it's great. NB: You can use not only as much more powerful replacement for Excel, but also as replacement for Notepad and Word!
In fact, I used all the time now when I write my reports and other documents

30:00 - Creating new -> R Markdown

- calling it '01-report'    (Note,  i made mistake here. You need to call it explicitely with extension i.e. '01-report.Rmd`

31:00 - Kniting a document

- You can comment out the part that you dont want to be shown by Pressing `CTRL+SHIFT+C` .
This created  `<!--  -  -->` around all lines  - as in a regular html document.
(NB: sometimes, this short-cut does not work  when working in `rstudio.cloud`, e.g. with old internet browsers or from Chrombooks)

- All my Web Apps (like this (iTrack Covid)[], or (iTrack PSES)[], or (iTrack Border)[]) are R Markdown!!
- Showing how you make a header in RMarkdown

33:30  - NB: Important trick - How to make and show the Table of Content of your document
- You make a comment that ends with #### (or ----) it makes a label that is shown in ToC

35 - Eeview of what we did today:  created a file and added a line to read a file from JHU.

See you next time! We'll start from this line.



 
 

