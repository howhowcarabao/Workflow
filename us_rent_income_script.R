#--------------------------------------------U.S._rent_income data set code------------------------------------------

#load library
library("tidyverse")

#view pre-loaded data sets
data()
View(us_rent_income)#data set
?us_rent_income # find out more information about the data set

# Explore the data set
# =====================
us_rent_income %>%
  filter( variable == "income") %>%
  select(NAME,estimate) %>% 
  arrange(desc(estimate)) %>%
  View()
  #head(15)
us_rent_income %>%
  filter( variable == "rent") %>%
  select(NAME,estimate) %>% 
  arrange(estimate) %>% 
  head(15)

# Prepare the data 
# =====================

#convert to wide form
duplicated(us_rent_income[,c("GEOID","estimate")])#data should be unique at id and estimate level
sum(  duplicated(us_rent_income[,c("GEOID","estimate")]) )# for more complex data

# create df to work in
df.wide <- us_rent_income %>%
  select(-c(GEOID,moe)) %>% 
  slice(-c(103,104))
df.wide <- pivot_wider(df.wide, names_from = variable, values_from = estimate)#long to wide
df.wide <- df.wide %>% 
  rename(state = NAME)
#--------create state/region data(code in 'State Region Data' file)---------

#create region column with state/region data
df.wide$region <- sapply(df.wide$state, 
                     function(x) names(region.list)[grep(x,region.list)])

#conduct descriptive analysis
df.wide %>%
  select(NAME,rent) %>% 
  arrange(rent) %>% 
  head(15) 
df.wide %>%
  select(NAME,income) %>% 
  arrange(desc(income)) %>% 
  head(15)             
df.wide %>% 
  summarise(Average_income = mean(income),min = min(income), med = median(income), max = max(income))
summary(df.wide$rent)

#download the new data as a .csv file
write.csv(df.wide,"U.S._rent_income.csv")