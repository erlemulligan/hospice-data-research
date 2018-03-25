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

# TODO:
# 1. filter out comatose and dead on arrival patients
# 2. factorize other potential quality of life indicators
patientData <- patientDataOriginal %>%
  mutate(
    # factorizing depression
    DEPRESS = factor(DEPRESS, levels = c(1,2,-1,-7,-8), labels = c('DEPRESSED', 'NOT DEPRESSED', 'INAPPLICABLE/NOT ASCERTAINED', 'RF', 'DK')),
    # factorizing depression level
    DEPRESLV = factor(DEPRESLV, levels = c(1,2,-1,-7,-8), labels = c('DEPRESSED', 'NOT DEPRESSED', 'INAPPLICABLE/NOT ASCERTAINED', 'RF', 'DK')),
    # making all 'INAPPLICABLE/NOT CERTAIN', 'RF' and 'DK' values = NA
    HOSPICEDAYS = replace(HOSPICEDAYS, which(HOSPICEDAYS < 0), NA),
    # factorizing sexx
    SEX = factor(SEX, levels = c(1, 2), labels = c('Male', 'Female')),
    # factorizing primary diagnosis (CDDX1)
    primaryDiagnosis = factor(CDDX1)
  )

# summary of depression state
summary(patientData$DEPRESS)
qplot(patientData$DEPRESS)

# summary of depression level state
summary(patientData$DEPRESLV)
qplot(patientData$DEPRESLV)

# summary of days spent in hospice care
summary(patientData$HOSPICEDAYS)
qplot(patientData$HOSPICEDAYS)
