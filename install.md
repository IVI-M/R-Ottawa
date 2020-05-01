

# Installing RStudio  

[ Home ](https://IVI-M.github.io/R-Ottawa/) --  [ Resources ](resources.md) -- [ Community ](community.md) -- [Lunches with Data Challenges](meetups.md) -- [ R-101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101)

## On your home computer

Google: RStudio download  
Note: You can install it on Windows, Mac and Linux, but you cannot install it on Chromebook. Nevertherless, if all you have is Chromebook, don't get discouraged, you can still program in R - on https://rstudio.cloud !

## For CBSA employees

In Summer 2019, CBSA IT Security approved Anaconda, and RStudio as part of it, for installation on corporate systems.

This means that you can  now have the RStudio icon  on your Computer Desktop just beside the MS Excel or MS Word or MS PowerPoint icons, 
and you can launch it just as easily as any other program on your computer, simply by clicking on it.
And once you launched it, there's nothing stopping you from taking all power of it  - for anything you  normally
do using Excel, Word or PowerPoint, and much more. 

It's free (so you can also have it on your home computer), learning resources are also free, as is R community support, and
they all are superb.
There are a few steps however for you to do before RStudio icon will appears on your Desktop. They are outlined below.

Please also note that, for security reasons (it takes time to certify each new release and package), the version of R and RStudio 
used on CBSA networkis  is older than the latest one (which you may wich to have on your home computer).  Currently it is `> sessionInfo()
R version 3.4.3 (2017-11-30)`. Similarly, not all packages are available, and those that are available are in order releases.

Nevertherless, what we have is already quite extraodinary, yielding opportunity to revolutionize how data science is done here; and, 
in fact, 
not any data science and not only anything related to data processing, visualization  and reporting, but also for writting memos, reports, decks (scientific and as non-scientific), as well as leading collaborative projects - for work and fun.


Talk to any of us, will show you how.


***

**Installing RStudio**


 

Step 1. Please check if you can read access to the following folder (i.e. click in the link):
\\omega.dce-eir.net\natdfs\Services\Central_storage\CBSA\OGDA\Repos\repo.continuum.io


IF YOU DON'T , STOP RIGHT HERE  - and let me know. Your name will need to be submitted to grant you access to this folder

If you do, then proceed to next step:

 

Step 2. Copy `Anaconda3-5.1.0-Windows-x86_64.exe`   from i: drive (which is `\\SH12CFFP0001\install`) to your local  user account  (which is `C:\Users\<6 Digit User>\`), and Run it from there.


Destination Folder: `C:\Users\<6 Digit User>\Anaconda3\` is displayed
(where <User> is the actual user 6 digit account ID)

 
Uncheck the following Advanced Options:

- Add Anaconda to my PATH environment variable

- Register Anaconda as my default Python 3.6

 

It will take time. In meanwhile read this:   `\\SH12CFFP0001\install\Anaconda3_510\DOCS\Anaconda3_510_ENG_V1.3.docx` 

 

Step 3. copy `\\SH12CFFP0001\install\Anaconda3_510\.condarc` file to user home directory (i.e. c:\Users\<6 Digit User>)

 

Step 4. Open Anaconda Prompt (from Start-> Anaconda3 (64-bit) -> Anaconda Prompt) and run:    

`conda create -n e2020.02.01 mro-base rstudio`   (replace `e2020.02.01` with `eDATE_YOU_INSTALL`)

(NB: we don't run   `conda update conda` or ` conda update anaconda` )  

<!-- Currently we have  conda-4.6.14 as of Jan 2020. Do not change it)   -->

This will create a shortcut  (R) on desktop.
Test it. If it opens OK, you are ready go. 
But lets load useful packages to your safe space (so called virtual environemnt) where you'll be coding.

 
Step 5.
In Anaconda Prompt terminal run:    
`conda activate e2020.02.11`

and then run:    
`(e2020.02.11) C:\Users\gxd006>conda install git r-data.table r-ggplot2 r-lubridate  r-plotly -dt` 

Note the following libraries are installed by default: 
`r-r6, magrittr, readxl , readr, stringr`
 


(Step 6.)

If you have rmarkdown problems, run this:   
`conda install pandoc=1.19.2.1`


You are all set now.
