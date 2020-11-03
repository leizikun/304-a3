#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from: 
# https://www.voterstudygroup.org/publication/nationscape-data-set
# Author: Kaiyue Wu, Mengxin Zhao, Zikun Lei
# Data: 30 October 2020
# Contact: zikun.lei@mail.utoronto.ca 
# License: MIT

#### Workspace setup ####
library(haven)
library(tidyverse)
library(stringr)
# Read in the raw data.
setwd("D:/PS 3")
raw_data <- read_dta("usa_00004.dta.gz")


# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
reduced_data <- 
  raw_data %>% 
  select(region,
         stateicp,
         sex, 
         age,race,
         citizen,language,gradeatt,empstat
         )
         
colnames(reduced_data)[1]<-"census_region"
colnames(reduced_data)[5]<-"race_ethnicity"
colnames(reduced_data)[9]<-"employment"
reduced_data <-
  reduced_data %>%
  filter(citizen == "naturalized citizen")
levels(reduced_data$census_region)[match("mountain division",levels(reduced_data$census_region))] <- "West"
levels(reduced_data$census_region)[match("pacific division",levels(reduced_data$census_region))] <- "West"
levels(reduced_data$census_region)[match("south atlantic division",levels(reduced_data$census_region))] <- "South"
levels(reduced_data$census_region)[match("east south central div",levels(reduced_data$census_region))] <- "South"
levels(reduced_data$census_region)[match("west south central div",levels(reduced_data$census_region))] <- "South"
levels(reduced_data$census_region)[match("new england division",levels(reduced_data$census_region))] <- "Northeast"
levels(reduced_data$census_region)[match("middle atlantic division",levels(reduced_data$census_region))] <- "Northeast"
levels(reduced_data$census_region)[match("east north central div",levels(reduced_data$census_region))] <- "Midwest"
levels(reduced_data$census_region)[match("west north central div",levels(reduced_data$census_region))] <- "Midwest"

levels(reduced_data$race_ethnicity)[match("american indian or alaska native",levels(reduced_data$race_ethnicity))] <- "American Indian or Alaska Native"
levels(reduced_data$race_ethnicity)[match("chinese",levels(reduced_data$race_ethnicity))] <- "Asian or pacific islander"
levels(reduced_data$race_ethnicity)[match("japanese",levels(reduced_data$race_ethnicity))] <- "Asian or pacific islander"
levels(reduced_data$race_ethnicity)[match("other asian or pacific islander",levels(reduced_data$race_ethnicity))] <- "Asian or pacific islander"
levels(reduced_data$race_ethnicity)[match("black/african american/negro",levels(reduced_data$race_ethnicity))] <- "Black, or African American"
levels(reduced_data$race_ethnicity)[match("other race, nec",levels(reduced_data$race_ethnicity))] <- "Some other race or multiraces"
levels(reduced_data$race_ethnicity)[match("white",levels(reduced_data$race_ethnicity))] <- "White"
levels(reduced_data$race_ethnicity)[match("two major races",levels(reduced_data$race_ethnicity))] <- "Some other race or multiraces"
levels(reduced_data$race_ethnicity)[match("three or more major races",levels(reduced_data$race_ethnicity))] <- "Some other race or multiraces"


#### What's next? ####

## Here I am only splitting cells by age, but you 
## can use other variables to split by changing
## count(age) to count(age, sex, ....)

reduced_data <- 
  reduced_data %>%
  count(age, census_region, race_ethnicity, employment) %>%
  group_by(age, census_region, race_ethnicity, employment) 

reduced_data <- 
  reduced_data %>% 
  filter(age != "less than 1 year old") %>%
  filter(age != "90 (90+ in 1980 and 1990)")

reduced_data$age <- as.integer(reduced_data$age)

# Saving the census data as a csv file in my
# working directory
write_csv(reduced_data, "census_data.csv")



         
