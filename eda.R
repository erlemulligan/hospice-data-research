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
  # 1. filter out comatose
  filter(COMATOSE != 1) %>%
  mutate(
    # factorizing depression
    DEPRESS = factor(DEPRESS, levels = c(1, 2), 
                     labels = c('DEPRESSED', 'NOT DEPRESSED')),
    # factorizing depression level
    DEPRESLV = factor(DEPRESLV, levels = c(1, 2), 
                      labels = c('DEPRESSED', 'NOT DEPRESSED')),
    # making all 'INAPPLICABLE/NOT CERTAIN', 'RF' and 'DK' values = NA
    HOSPICEDAYS = replace(HOSPICEDAYS, which(HOSPICEDAYS < 0), NA),
    # pain level at first assessment
    painLevelFirstAssessment = factor(PAINLVL3, levels = c(1, 2, 3, 4), 
                      labels = c('MILD', 'MODERATE', 'SEVERE', 'NO PAIN')),
    # pain level at last assessment
    painLevelLastAssessment = factor(PAINREC5, levels = c(1, 2, 3, 4), 
                                      labels = c('MILD', 'MODERATE', 'SEVERE', 'NO PAIN')),
    # pain strategy
    painStrategy = factor(NOSTRAT, levels = c(1, 2),
                          labels = c('YES', 'NO')),
    # standing order for pain medication
    painMedsStandingOrder = factor(ORDER, levels = c(1, 2), labels = c('YES', 'NO')),
    # prn order for pain medication
    painMedsPrnOrder = factor(PRN, levels = c(1, 2), labels = c('YES', 'NO')),
    # Non-Pharmacological Methods (distraction, heat/cold massage, positioning, music)
    NONPHARM = factor(NONPHARM, levels = c(1, 2), labels = c('YES', 'NO')),
    # factorizing sexx
    SEX = factor(SEX, levels = c(1, 2), 
                 labels = c('Male', 'Female')),
    # factorizing primary diagnosis (CDDX1)
    primaryDiagnosis = factor(CDDX1)
  )

# summary of depression state
summary(patientData$DEPRESS)
qplot(patientData$DEPRESS)

# summary of days spent in hospice care
summary(patientData$HOSPICEDAYS)
qplot(patientData$HOSPICEDAYS)

# depressed/not depress/na density chart
patientData %>%
  ggplot(aes(x = HOSPICEDAYS, fill = DEPRESS)) +
  geom_density(alpha = 0.3)

# center and spread for number of hospice days by depression status
patientData %>%
  group_by(DEPRESS) %>%
  summarize(median(HOSPICEDAYS, na.rm = TRUE),
            IQR(HOSPICEDAYS, na.rm = TRUE))

patientData %>%
  ggplot(aes(x = DEPRESS, y = HOSPICEDAYS, fill = DEPRESS)) +
  geom_boxplot() +
  ylim(0,75)

summary(patientData$painLevelFirstAssessment)
qplot(patientData$painLevelFirstAssessment)

# pain level at first assessment density chart
patientData %>%
  ggplot(aes(x = HOSPICEDAYS, fill = painLevelFirstAssessment)) +
  geom_density(alpha = 0.3)

patientData %>%
  ggplot(aes(x = painLevelFirstAssessment, y = HOSPICEDAYS, fill = painLevelFirstAssessment)) +
  geom_boxplot() +
  facet_wrap(~DEPRESS) +
  ylim(0,1100)

# pain level at last assessment density chart
patientData %>%
  ggplot(aes(x = HOSPICEDAYS, fill = painLevelLastAssessment)) +
  geom_density(alpha = 0.3)

patientData %>%
  ggplot(aes(x = painLevelLastAssessment, fill = painLevelLastAssessment)) +
  geom_bar() +
  facet_wrap(~DEPRESS) +
  ylim(0,200)

patientData %>%
  ggplot(aes(x = painLevelLastAssessment, y = HOSPICEDAYS, fill = painLevelLastAssessment)) +
  geom_boxplot() +
  facet_wrap(~DEPRESS) +
  ylim(0,75)

# summary of pain strategy
summary(patientData$painStrategy)
qplot(patientData$painStrategy)

summary(patientData$painMedsStandingOrder)
qplot(patientData$painMedsStandingOrder)

patientData %>%
  ggplot(aes(x = HOSPICEDAYS, fill = painMedsStandingOrder)) +
  geom_density(alpha = 0.3) +
  facet_wrap(~DEPRESS) +
  xlim(0,600)

patientData %>%
  ggplot(aes(x = painMedsStandingOrder, fill = painMedsStandingOrder)) +
  geom_bar() +
  facet_wrap(~DEPRESS)

summary(patientData$painMedsPrnOrder)
qplot(patientData$painMedsPrnOrder)

patientData %>%
  ggplot(aes(x = HOSPICEDAYS, fill = painMedsPrnOrder)) +
  geom_density(alpha = 0.3) +
  facet_wrap(~DEPRESS) +
  xlim(0,600)

patientData %>%
  ggplot(aes(x = painMedsPrnOrder, fill = painMedsPrnOrder)) +
  geom_bar() +
  facet_wrap(~DEPRESS)

patientData %>%
  ggplot(aes(x = HOSPICEDAYS, fill = NONPHARM)) +
  geom_density(alpha = 0.3) +
  facet_wrap(~DEPRESS) +
  xlim(0,500)

patientData %>%
  ggplot(aes(x = NONPHARM, fill = NONPHARM)) +
  geom_bar() +
  facet_wrap(~DEPRESS)