Transcript for session 

1:00  - introduction and logististics (please post questions in chat and by email)

6:30   - overview of pages that I'll be using in these Wed sessions
 - This R Ottawa portal
    - /r101 folder with R (where I'll be putting the codes and  session transcripts)
 - rstudio.cloud (where will be coding)
 
 10:00    - showing how to start Tutorials that are included in rstudio.cloud
  - we start the very first Visualization tutorial,  which creates a graph of `mpg` miles per gallon dataset that is included in R

  
14:00 -  Creating your own first project (e.g. to visualize Covid data)
  - note this is exactly the same RStudio that I have on my local machine
  - create New -> R script
  
15:20 -  Copyng a line from `readCovidJHU.R`  (which reads US .csv data from JHU using `fread()`  ) into my R Script
  
- Press CNTR + Enter to run it
- Error in fread - missing libraries
  
16:00 - copying libraries from `readCovidCanada.R` (which we discussed in previous sessions) into my R Script
 
18:00 - installing missing libraries

19:00  - showing my RStudio on my home machine [ My setup is the same, but I used Dark colour Scheme]
- Running`sessionInfo() 3.6.1
- showing the content of my folder

20:00 0 going back to cloud RStudio
- observing what arefiles are there
- Saving our R script as `01-read.R`. Now we have a new file there

21:00 - yellow line on top shows all packages that are listed in the code and that are not installed yet. You can click there to install them all. [ I don't do it beause it will take long time, please do it on you own] 

22:30  - going  through the functionalities of the iTrack Covid app
- It all started with exactly the same line that we pasted today into our script
- What I do in my code: I read current time ,then read time when dataset was updated and show them here .

25:00 - Talking about data challeges:
- I compute speed and acceleration 
(which are Derivative of totals and derivative of speed, derivative being the difference in adjacent values)  
- however note that data are not smooth! It jumps back and forth, sometime not available (NA), sometime negative.
You can't just  take the difference tocompute the derivatives. You need to smooth the data (do the so called convolution)

27:00  - continuing looking int the functionalities of the iTrack Covid app
- in one line, we can write a function that approximates the relationship between vertical and horizontal values.
when we have this function,we can use to predict value in futire

29:00 - Running sessionInfo() in cloud session:  it shows 3.6.0 which is older then the version I have my home computer

29:30 - note for CBSA.
R was approved by IT and it's great. You can use not only for Excel, but also for word. 
In fact, I used all the time for writing my text

30:00 - Creating new -> RMarkdown

- calling it '01-report'    [ i made mistake then. You need to call it '01-report.Rmd]

31:00 - Kniting a document

- You can comment out the part that you dont want to be shown by Pressing CNTR+SHIFT+C .
[ Oops. apparently this short-cut does not work in rstudio.cloud]. Use `<!--  -  -->`

- All my applications (like this Ttrack Covid) are RMarkdown
- Showing how you make a header in RMarkdown

33:30  - trick to show the Table of Content
- You make a comment that ends with #### (or ----) it makes a label that is shown in ToC

35 - review of what we did - created a file and added a line to read a file from JHU

See you next time! We'll start from this line.



 
 

