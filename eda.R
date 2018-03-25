install.packages('tidyverse')
library('tidyverse')

install.packages('haven')
library('haven')

dataDirectory = './data'
patientDataFile = './data/patientData.zip'

if (!dir.exists(dataDirectory)) {
  dir.create(dataDirectory)
}

if (!file.exists(patientDataFile)) {
  download.file('ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHHCS/2007/SAS_Data/patientpuf_nhhcs07_SASData_093009.zip', destfile=patientDataFile)
}

patientDataOriginal <- read_sas(patientDataFile)

patientData <- patientDataOriginal %>%
  mutate(
    # factorizing depression
    DEPRESS = factor(DEPRESS, levels = c(1,2,-1,-7,-8), labels = c('DEPRESSED', 'NOT DEPRESSED', 'INAPPLICABLE/NOT ASCERTAINED', 'RF', 'DK')),
    # making all 'INAPPLICABLE/NOT CERTAIN', 'RF' and 'DK' values = NA
    HOSPICEDAYS = replace(HOSPICEDAYS, which(HOSPICEDAYS < 0L), NA),
    # factorizing sexx
    SEX = factor(SEX, levels = c(1, 2), labels = c('Male', 'Female'))
  )

summary(patientData$DEPRESS)
qplot(patientData$DEPRESS)

summary(patientData$HOSPICEDAYS)
qplot(patientData$HOSPICEDAYS)
