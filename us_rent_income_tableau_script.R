#--------------------------------------------U.S._rent_income tableau script------------------------------------------
#load library
library("tidyverse")

#prepare the data set

sum(  duplicated(us_rent_income[,c("GEOID","estimate")]) )#data should be unique at id and estimate level

df.wide <- us_rent_income %>% # create data frame to work in
  select(-c(GEOID,moe)) %>% 
  slice(-c(103,104))

df.wide <- pivot_wider(df.wide, names_from = variable, values_from = estimate)# convert from long to wide

df.wide <- df.wide %>% # rename state column
  rename(state = NAME)

#-------------------create state/region data----------------------

NE.name <- c("Connecticut","Maine","Massachusetts","New Hampshire",
             "Rhode Island","Vermont","New Jersey","New York",
             "Pennsylvania")
NE.ref <- c(NE.name)

MW.name <- c("Indiana","Illinois","Michigan","Ohio","Wisconsin",
             "Iowa","Kansas","Minnesota","Missouri","Nebraska",
             "North Dakota","South Dakota")
MW.ref <- c(MW.name)

S.name <- c("Delaware","District of Columbia","Florida","Georgia",
            "Maryland","North Carolina","South Carolina","Virginia",
            "West Virginia","Alabama","Kentucky","Mississippi",
            "Tennessee","Arkansas","Louisiana","Oklahoma","Texas")
S.ref <- c(S.name)

W.name <- c("Arizona","Colorado","Idaho","New Mexico","Montana",
            "Utah","Nevada","Wyoming","Alaska","California",
            "Hawaii","Oregon","Washington")
W.ref <- c(W.name)

region.list <- list(
  Northeast=NE.ref,
  Midwest=MW.ref,
  South=S.ref,
  West=W.ref)
----------------------------------------------------------------------
  
  #create region column with state/region data
  df.wide$region <- sapply(df.wide$state, 
                           function(x) names(region.list)[grep(x,region.list)])

#download the new data as a .csv file
write.csv(df.wide,"U.S._rent_income.csv")