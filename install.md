 (

# Installing RStudio  

[ Home ](https://IVI-M.github.io/R-Ottawa/) --  [ Resources ](resources.md) -- [ Community ](community.md) -- [Lunches with Data Challenges](meetups.md) -- [ R-101 ](https://github.com/IVI-M/R-Ottawa/tree/master/r101)



## For CBSA employees

In Summer 2019, CBSA IT Security approved Anaconda, and RStudio as part of it, for installation on corporate systems.

This means that you can  now have the RStudio icon  on your Computer Desktop just beside the MS Excel or MS Word or MS PowerPoint icons, 
and you can launch just as easily as any other program on your computer, simply by clicking on it.

And once you launched it, there's nothing stopping from taking all power of it for anything you would normally
do using Excel, Word or PowerPoint, and much more. 
It's free (so you can also have it on your home computer), learning resources are also free, as is R community support, and
they all are superb.
There are a few steps however for you to do before RStudio icon will appears on your Desktop. They are outlined below.

Please also note that, for security reasons (it takes time to certify each new release and package), the version of R and RStudio 
used on CBSA networkis  is older than the latest one (which you may wich to have on your home computer).  Currently it is `> sessionInfo()
R version 3.4.3 (2017-11-30)`. Similarly, not all packages are available, and those that are available are in order releases.

Nevertherless, what we have is already quite extraodinary, yielding opportunity to revolutionize how data science is done here; and, 
in fact, 
not any data science and not only anything related to data processing, visualization visualization and reporting, any other scientific and non-scientific , writting memos. collaborative projects  - talk to any of us
***

**Installing RStudio**

--

 

1. Please check if you can read access to the following folder (i.e. click in the link):

\\omega.dce-eir.net\natdfs\Services\Central_storage\CBSA\OGDA\Repos\repo.continuum.io

 

 

IF YOU DON'T , STOP RIGHT HERE  - and let me know.

 

If you do, then proceed to next:

 

 

3. Copy Anaconda3-5.1.0-Windows-x86_64.exe  to local  user account  (which is C:\Users\<6 Digit User>\) from i: drive (which is \\SH12CFFP0001\install):

And Run it from there:

 

 

Destination Folder 

C:\Users\<6 Digit User>\Anaconda3\ is displayed

(where <User> is the actual user 6 digit account ID)

 

Uncheck the following Advanced Options:

·         Add Anaconda to my PATH environment variable

·         Register Anaconda as my default Python 3.6

 

It will take time. In meanwhile read this: 

 

2. Read: \\SH12CFFP0001\install\Anaconda3_510\DOCS\Anaconda3_510_ENG_V1.3.docx

 

 

 

4. copy \\SH12CFFP0001\install\Anaconda3_510\.condarc file to user home directory (i.e. c:\Users\<6 Digit User>)

 

 

 

 

Then wait for me or try yourself:

 

5. Open Anaconda terminal and run:


              conda update conda   ( in conda-4.6.14  Jan 2020. Do not )

              conda update anaconda <-- dont do this one

 
6.  in the same Anaconda terminal run:

 

conda create -n e2020.02.01 mro-base rstudio   
--> This will creates a shortcut  (R) on desktop .

 

Test it that it opens OK.

 

7. In Anaconda terminal run:
conda activate e2020.02.11

8. Add libraries 

(e2020.02.11) C:\Users\gxd006>conda install git r-data.table r-ggplot2 r-lubridate  r-plotly r-dygraphs r-dt 

libraries installed by default: 
r-r6, magrittr, readxl , readr, stringr
 

 
need to be installed separately
  library(ggpubr)
  library(GGally)
 

XXX r-flexdashboard -> removes mro  NOT XXX 


> packageVersion("rmarkdown")

[1] ‘1.8’

> library(rmarkdown)

> rmarkdown::pandoc_version()

[1] ‘2.2.3.2’

  Subject: RE: R markdown tabs, toc, guide

 

It looks like it might be a bug with certain versions of rmarkdown: https://stackoverflow.com/questions/47639445/tabs-not-rendering-when-knitting-rmarkdown-to-html

 

Can you guys check which version of rmarkdown and pandoc you have?

 

> packageVersion("rmarkdown")



[1] ‘1.8’
> rmarkdown::pandoc_version()
[1] ‘1.19.2.1’




conda activate e2020.03.02-markdown_issues


 

  conda install pandoc=1.19.2.1
