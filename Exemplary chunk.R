library(tidyverse)
library(kableExtra)
library(patchwork)
library(scales)

covidC = read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-recent.csv') %>%
  filter(date == max(date), !is.na(fips)) 

# estimated mask usage from July 2020 survey
mask = read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/mask-use/mask-use-by-county.csv') %>%
  rename(fips = 'COUNTYFP') # for merging   

# prep CDC data from directory
vax = read_csv('cdc vax mar1.csv') %>%
  filter(FIPS != 'UNK', Recip_State != 'VI', Completeness_pct > 0, 
         !is.na(Administered_Dose1_Recip)) %>% # drop unknown/incomplete/questionable reports
  rename(fips = FIPS, 
         population = Census2019,
         vaxComplete = Series_Complete_Pop_Pct,
         SVIcategory = SVI_CTGY)   %>%
  select(fips, population, vaxComplete, SVIcategory)

# merge  
covid =
  left_join(covidC, mask) %>%
  left_join(vax) %>%
  mutate(casesPer100k = cases/population*100000,
         deathsPer100k = deaths/population * 100000) # scale by population

summary(covid)

rm(covidC, mask, vax)
