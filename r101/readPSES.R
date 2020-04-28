# readPSES.R
# D.Gorodnichy


  PSES_ID_COLS = c("LEVEL1ID"  ,   "LEVEL2ID"    , "LEVEL3ID"   ,  "LEVEL4ID"   ,  "LEVEL5ID"  ); psesKeys = PSES_ID_COLS; COLS_PSES = PSES_ID_COLS
  
  OPEN_CANADA_URL <- "https://www.canada.ca/content/dam/tbs-sct/documents/datasets/pses-saff/2018/2018_PSES_open_dataset_Ensemble_de_donn%C3%A9es_ouvertes_du_SAFF_2018.csv"

  myID0 = c(83, 200, 307, 416 , 0) # 2019
  myID = myID0

  


# data to read ---- 
strUrlDocumentation2018local  <- "https://www.canada.ca/content/dam/tbs-sct/documents/datasets/2019_PSES_Supporting_Documentation_Document_de_reference_du_SAFF_2019.xlsx"
strUrlDocumentation2018local  <- "source-data/2019_PSES_Supporting_Documentation_Document_de_reference_du_SAFF_2019.xlsx"
strUrlDocumentation2018local  <- "source-data/2018_PSES_Supporting_Documentation_Document_de_référence_du_SAFF_2018.xlsx"

createPsesDepartments <- function() {
  
  dtDepartments <- read_excel(strUrlDocumentation2018local, sheet=6) %>% data.table();
  
  dtDepartments[ str_detect(Organization,"Border")]
  
  setkeyv(dtDepartments, PSES_ID_COLS)
  
  dtDepartments[as.list(myID0)] # 83 200 304 418   0
  
  dtDepartments[LEVEL1ID==83 & LEVEL2ID==200, .(.N,Organization) , by=LEVEL3ID] # 83 200 304 418   0
  #51
  dtDepartments[LEVEL1ID==83 & LEVEL2ID==200 & LEVEL3ID==307, .(.N,Organization) , by=LEVEL4ID] # 83 200 304 418   0
  #9
  
  dtDepartments[LEVEL1ID==83 & LEVEL2ID==200 & 
                  LEVEL3ID==307 & LEVEL4ID==416, .(.N,Organization) , by=LEVEL5ID] # 83 200 307 416  0
  #9
  
  dtDepartments[, .N]; dtDepartments %>% names
  dtDepartments$`DESCRIPTION FR` <- NULL
  setnames(dtDepartments, old="DESCRIPTION ENG", new="Organization")
  dtDepartments[1]
  cols <- PSES_ID_COLS # c("LEVEL1ID", "LEVEL2ID", "LEVEL3ID", "LEVEL4ID", "LEVEL5ID" )
  cols=1:5; 
  dtDepartments[, (cols):=lapply(.SD, as.integer), .SDcols=cols]; 
  
  
  # . Add PS (0.0.0.0.0)  ----
  dtDepartments <- dtDepartments %>% rbind(data.table(0L,0L,0L,0L,0L,"Public Service"), use.names=F)
  
  #. Truncate Dept name  -----
  dtDepartments$Organization.fullname <- dtDepartments$Organization
  dtDepartments[ , Organization:= Organization %>% str_trunc(50,side="center", ellipsis = "...") ]
  
  #. Replace `-`` to `/`` -----
  dtDepartments$Organization<- gsub("/", "-", dtDepartments$Organization ) 
  
  # . Add Acronyms (AADD) -----
  dtDepartments$AADD <-  abbreviate(dtDepartments$Organization, 1, named = FALSE)
  
  #NB: some Acronyms are the same !
  dtDepartments[, .(AADD,Organization)] #2404 / 2019: 3201
  dtDepartments[, .(AADD,Organization)] %>% unique() # 2177: 
  
  for (i in 1:5) dtDepartments[, AADD := str_replace (AADD, '\\(', "")] 
  
  dtDepartments[, AADD := str_replace (AADD, "[[:lower:]]+", "")] 
  dtDepartments$AADD <- str_replace(dtDepartments$AADD, "[[]:punct:]]+", "")
  
  #for (i in 1:5) dtDepartments[, AADD := str_replace (AADD, "[:lower:]+", "")] 
  #for (i in 1:5) dtDepartments$AADD <- str_replace(dtDepartments$AADD, "[:punct:]+", "")
  #  dtDepartments[AADD == "I", AADD:= "N.A."]
  dtDepartments[AADD == "I", AADD:= "N/A"]
  
  
  
  # . Add IDlevel ----
  dtDepartments[ , IDlevel:=ifelse(LEVEL1ID == 0, 0, 
                                   ifelse(LEVEL2ID == 0, 1, 
                                          ifelse(LEVEL3ID == 0, 2, 
                                                 ifelse(LEVEL4ID == 0, 3, 
                                                        ifelse(LEVEL5ID == 0, 4, 5)))))]
  
  # . factor(dtDepartments$IDlevel----
  dtDepartments$IDlevel <- factor(dtDepartments$IDlevel,  levels = order(dtDepartments$IDlevel,decreasing=T))
  
  
  
  # . pathString: ORG_, LEV_  CBSA-HQ-ISTB-SED  ----
  
  if(T) { # NB: this will take ~10 mins to compute !
    
    for (i in 1:nrow(dtDepartments))  {
      # if (dtDepartments[i,]$LEVEL2ID==999 | dtDepartments[i,]$LEVEL2ID==0)
      #   next;
      id <- dtDepartments[i, (PSES_ID_COLS),with=F] %>% unlist; id
      # if (getLevel(id)==0) 
      #   next
      ll <- getLevel(id);ll
      getIDupto(id,ll)
      
      #    dtDepartments[i, BB_DD:=""]
      setkeyv(dtDepartments, PSES_ID_COLS)
      
      for (l in 0:getLevel(id)) {
        # for (l in 1:getLevel(id)) {
        x <- dtDepartments[as.list(getIDupto(id,l))]$AADD ; #x %>% print
        xx <- dtDepartments[as.list(getIDupto(id,l))]$Organization.fullname %>% 
          str_trunc(40,ellipsis = "...")
        dtDepartments[i, paste0("LEV_", l):= x]
        dtDepartments[i, paste0("ORG_", l):= xx]
      }
    }
    
    dtDepartments[ , pathString:=paste(LEV_1, LEV_2,LEV_3,LEV_4, sep = "/")]
    for (i in 1:5) dtDepartments[, pathString := str_replace (pathString, '/NA', "")] 
    
    # dtDepartments[IDlevel==0, pathString:="All Public Service"]
    # dtDepartments[IDlevel==1, pathString:=AADD]
  }
  
  # . Order by Key and Add order number: .I -----
  setkeyv(dtDepartments, PSES_ID_COLS)
  dtDepartments[, I:= .I]
  
  # .[ remove 999. ie. "I can't find my unit"] -----
  
  # .. Test Uniqueness of names,Org,pathString-----
  dtDepartments %>% nrow() # [1] 2404
  dtDepartments$Organization %>% unique() %>% length()# [1] 2177
  dtDepartments$pathString %>% unique() %>% length()# [1] 2206 2267
  dtDepartments$AADD %>% unique() %>% length()# [1] 1997
  
  samePaths <- dtDepartments[, .N, by=pathString][N>1]$pathString
  dtDepartments[pathString %in% samePaths]
  
  #. [ order decreasing = T ] ----
  # dtDepartments <- dtDepartments[order(Organization, decreasing = T)]
  
  # . Save -----
  dtDepartments[,.N];   dtDepartments %>% names
  dtDepartments[c(1,.N)]
  dtDepartments[LEVEL1ID==83]
  fwrite(dtDepartments, "dtDepartments.csv", sep="\t"); 
  fwrite(dtDepartments, "dtDepartments2019.csv", sep="\t"); 
  #dtDepartments <- fread("dtDepartments.csv")
}
#. createPsesDepartments ----
if (F)
  createPsesDepartments()

#.................................................... ----

#............................................................... ----

createPsesScores <- function() {
  
  if (F) {  # I. Read 2018 /2019 only  ----
    
    
    # strUrl2018local <- "https://www.canada.ca/content/dam/tbs-sct/documents/datasets/2019_PSES_SAFF_%20subset-1_Sous-ensemble-1.csv"
    # 
    # strUrl2018local <-
    #   "https://www.canada.ca/content/dam/tbs-sct/documents/datasets/Main_9.12.03.b_subset_2.csv"
    # strUrl2018local <- 
    #   "https://www.canada.ca/content/dam/tbs-sct/documents/datasets/Main_9.12.03.b_subset_3.csv"
    # strUrl2018local <- 
    #   "https://www.canada.ca/content/dam/tbs-sct/documents/datasets/Main_9.12.03.b_subset_4.csv"
    
    # strUrl2018local <- "source-data/2018_PSES_open_dataset_Ensemble_de_données_ouvertes_du_SAFF_2018.csv"
    strUrl2018local <-    "source-data/Main_9.12.03.b_subset_2.csv" 
    strUrl2018local <- "source-data/2019_PSES_SAFF_ subset-1_Sous-ensemble-1.csv"
    # 1.csv: 49301, 2.csv: 1888191 , 3.csv: 3177825  4.csv: 1804844
    # 
    dtPSES <<- fread(strUrl2018local); 
    
    dtPSES %>% dim
    dtPSES[LEVEL1ID==83, .N] # 83 200 307
    
    # 32216 63751 32216

    dtPSES[LEVEL1ID==83, .N, by=LEVEL2ID] # 83 200 307
    # LEVEL2ID     N
    # <int> <int>
    #   1:        0 32272
    
    dtPSES[LEVEL1ID==83 & LEVEL2ID==200 ] # 83 200 307 416 
    dtPSES[LEVEL1ID==83 & LEVEL2ID==200 & LEVEL3ID==307 ] # 83 200 307 416 
    dtPSES[LEVEL1ID==83 & LEVEL2ID==200 & LEVEL3ID==307 & LEVEL4ID==416] # 83 200 307 416 
    
    setkeyv(dtPSES, PSES_ID_COLS)
    dtPSES[as.list(myID0)] 
    
    dtPSES[as.list(getIDupto(myID0, 3))][QUESTION=="Q34"]
    dtPSES[as.list(getIDupto(myID0, 3))][QUESTION=="Q34"]

    myID <- getIDupto(myID0, 3);myID
    dtPSES[as.list(myID)] 
    dtPSES[as.list(c(83,0,0,0,0))]$SURVEYR %>% unique()
    

    
    
    dtPSES[as.list(c(83,0,0,0,0)), .(QUESTION,TITLE_E)][1:200] %>% unique() 
    
    
    if (T) { # . Keep 2018 only 
      dtPSES[ , .N, by = SURVEYR]
      dtPSES[SURVEYR == 2018 ] # 1062480:  
      ## dtPSES <<- dtPSES [SURVEYR==2018] 
      
      dtPSES[SURVEYR == 2018, .N ] #14878
      dtPSES[SURVEYR == 2019, .N ] #17776
      
    }
  } else { # II. Read 2011-2018 files ---- 
    
    # THIS NEEDS TO BE VALIDATED
    
    
    ########################################################### #
    #  0.Read dtQmapping  ---- 
    ########################################################### #
    #Question number concordance with past surveys
    
    #https://www.canada.ca/en/treasury-board-secretariat/services/innovation/public-service-employee-survey/2018/question-number-concordance-past-surveys-2018.html
    
    
    cols <- c("n2018", "n2017","n2017a","n2014","n2011","n2008")
    dtQmapping[, (cols):=lapply(.SD, as.integer), .SDcols=cols]
    dtQmapping[, (cols):=lapply(.SD, function(x) sprintf("Q%02i",x)), .SDcols=cols]
    dtQmapping[, (cols):=lapply(.SD, function(x) ifelse(x=="QNA", NA, x)), .SDcols=cols]
    dtQmapping
    
    #. Read 2011-2018 .csv data ----
    strUrl2018local <- "source-data/2018_PSES_open_dataset_Ensemble_de_données_ouvertes_du_SAFF_2018.csv"
    strUrl2017local  <- "source-data/2017_PSES_SAFF_Open_dataset_Ensemble_donnees_ouvertes.csv"
    strUrl2014local  <- "source-data/2014-results-resultats.csv"
    strUrl2011local  <- "source-data/2011_results-resultats.csv"
    
    dt2011 <- fread(strUrl2011local); dim(dt2011)# 22 cols
    dt2014 <- fread(strUrl2014local); dim(dt2014)# 23 cols
    dt2017 <- fread(strUrl2017local); dim(dt2017)# 23 cols
    dt2018<- fread(strUrl2018local); dim(dt2018)
    
    
    #. Remove AGREE column in 2014-2018 .csv data ----
    dt2014$AGREE <- NULL
    dt2017$AGREE <- NULL
    dt2018$AGREE <- NULL
    
    
    #. Rename nQ column in 2011  so we can merge by it----
    setnames(dt2011, "V9", "nQ");     dt2011 %>% names
    
    # . Rename question numbers in each set ----
    dt2018$nQ %>% unique #  Q01 2312923: 
    dt2017$nQ %>% unique # A_Q01 3289210:  
    dt2014$nQ %>% unique# A_Q01 1509724:  
    dt2011$nQ %>% unique# A_Q01  1069189: 
    
    dt2017[, nQ := nQ %>% substring(3)]
    dt2014[, nQ := nQ %>% substring(3)]
    dt2011[, nQ := nQ %>% substring(3)]
    
    
    
    # . * Replace question via mapping  ----
    dt2011[
      dtQmapping,
      on = c(nQ = "n2011"),
      nQ := n2018
      ]
    
    dt2014[
      dtQmapping,
      on = c(nQ = "n2014"),
      nQ := n2018
      ]
    
    dt2017[
      dtQmapping,
      on = c(nQ = "n2017"),
      nQ := n2018
      ]     
    
    # . rbind them together (dt2011-2018) ----
    dtPSES <- dt2018 %>% rbind(dt2017) %>% rbind (dt2014) %>% rbind(dt2011, use.names=F)
    
    rm(dt2018);  rm(dt2017);  rm(dt2014);  rm(dt2011); 
  }
  


