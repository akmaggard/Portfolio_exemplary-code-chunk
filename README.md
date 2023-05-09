# Portfolio_exemplary-code-chunk

I use an advanced data analysis tool, Palantir Foundry, for my work. Foundry is a nifty tool on several counts, not least because its interface greatly facilitates joins of datasets that would otherwise require direct coding. With that being said, I'm pleased to report that R makes dataset joins quite easy. Of all the functions that R possesses, I find these joins to be especially magical. Below's an example of a join I performed for an assignment for SIS-750.

I have three datasets: covidC (which consists of 3,220 observations and six variables); mask (3,142 observations and six variables); and vax (3,137 observations and four variables).I want to join all three of these datasets into a single one. covidC, mask, and vax are distinct datasets with the exception of one variable shared in common among them that describes the same thing - FIPS (an NIST-assigned unique classifier used to identify and distinguish individual US counties). Using these fips variable (which I have to mutate for each dataset into an identically-named column, "fips", I can use R's join functions (in this case, left_join) to merge these three datasets into one mega dataset (which I named "covid"). Here's what the code looks like:

> covidC = read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-counties-recent.csv') %>%
  filter(date == max(date), !is.na(fips)) 
>
> mask = read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/mask-use/mask-use-by-county.csv') %>%
  rename(fips = 'COUNTYFP')
>
>vax = read_csv('cdc vax mar1.csv') %>%
  filter(FIPS != 'UNK', Recip_State != 'VI', Completeness_pct > 0, 
         !is.na(Administered_Dose1_Recip)) %>% # drop unknown/incomplete/questionable reports
  rename(fips = FIPS, 
         population = Census2019,
         vaxComplete = Series_Complete_Pop_Pct,
         SVIcategory = SVI_CTGY)   %>%
  select(fips, population, vaxComplete, SVIcategory)
>
>covid =
  left_join(covidC, mask) %>%
  left_join(vax) %>%
  mutate(casesPer100k = cases/population*100000,
         deathsPer100k = deaths/population * 100000) # scale by population
>
>summary(covid)

The covid dataset ends up having 16 variables - a combination of the variables from the covidC, mask, and vax datasets. 
Pretty neat stuff! 
