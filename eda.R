install.packages('haven')
library('haven')

install.packages('dplyr')
library('dplyr')

install.packages('ggplot2')
library('ggplot2')

dataDirectory = './data'
patientDataFile = './data/patientData.zip'

if (!dir.exists(dataDirectory)) {
  dir.create(dataDirectory)
}

if (!file.exists(patientDataFile)) {
  download.file('ftp://ftp.cdc.gov/pub/Health_Statistics/NCHS/Datasets/NHHCS/2007/SAS_Data/patientpuf_nhhcs07_SASData_093009.zip', destfile=patientDataFile)
}

patientData <- read_sas(patientDataFile, catalog_file = NULL, 
                        encoding = NULL)

str(patientData)
