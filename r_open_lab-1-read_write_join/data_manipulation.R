# R Open Lab 1: Reading, writing, and managing multiple datasets

# Part 2: Data manipulation

# Merging data with dplyr

# dplyr allows multiple datasets to be "joined" (terminology from SQL):

# Function	    Objective	Arguments	Multiple keys
# left_join()	  Keep all observations from the origin table

# inner_join()	Excludes all unmatched rows

# full_join()   Merge two datasets. Keeps all observations

# right_join()	Keep all observations from the destination table

# How to use the join functions
library(dplyr)

# Generate some examples
df_primary <- tribble(
  ~ID, ~y,
  "A", 5,
  "B", 5,
  "C", 8,
  "D", 0,
  "F", 9)
df_secondary <- tribble(
  ~ID, ~z,
  "A", 30,
  "B", 21,
  "C", 22,
  "D", 25,
  "E", 29)

# Left join
left_join(df_primary, df_secondary, by ='ID')

# Inner join
inner_join(df_primary, df_secondary, by ='ID')

# Full join
full_join(df_primary, df_secondary, by = 'ID')

# Right join
right_join(df_primary, df_secondary, by = 'ID')

# How could we rewrite the right join as a left join?

# In practice, we will typically use left joins, because they are easier to understand. The primary dataset
# is generally the dataset we want to "add columns" to, and left join is more intuitive for that task.

# Multiple keys
df_primary_m <- tribble(
  ~ID, ~year, ~items,
  "A", 2015,3,
  "A", 2016,7,
  "A", 2017,6,
  "B", 2015,4,
  "B", 2016,8,
  "B", 2017,7,
  "C", 2015,4,
  "C", 2016,6,
  "C", 2017,6)
df_secondary_m <- tribble(
  ~ID, ~year, ~prices,
  "A", 2015,9,
  "A", 2016,8,
  "A", 2017,12,
  "B", 2015,13,
  "B", 2016,14,
  "B", 2017,6,
  "C", 2015,15,
  "C", 2016,15,
  "C", 2017,13)
left_join(df_primary_m, df_secondary_m, by = c('ID', 'year'))

# We'll use this to pull data
library(wbstats)

# The SP.POP.TOTL indicator of total population
pop_wb <- wb_data("SP.POP.TOTL", start_date = 2000, end_date = 2022)
pop_wb

# The SP.DYN.TFRT.INof total fertility rate in rates per woman
tfrt_wb <- wb_data("SP.DYN.TFRT.IN", start_date = 2000, end_date = 2022)
tfrt_wb

# Clean up the World Bank data
pop <- pop_wb %>%
  filter(!is.na(SP.POP.TOTL)) %>%
  select(country, date, SP.POP.TOTL) %>%
  rename(population = SP.POP.TOTL)

tfrt <- tfrt_wb %>%
  filter(!is.na(SP.DYN.TFRT.IN)) %>%
  select(country, date, SP.DYN.TFRT.IN) %>%
  rename(fertility = SP.DYN.TFRT.IN)

# Select subset from 2010
pop_2010 <- pop %>%
  filter(date == 2010) %>%
  select(-date)

tfrt_2010 <- tfrt %>%
  filter(date == 2010) %>%
  select(-date)

# Inner join for the year 2010 of the population and fertility datasets
inner_2010 <- inner_join(pop_2010, 
                         tfrt_2010, 
                         by = "country")
inner_2010

# Full join for 2010
full_2010 <- full_join(pop_2010, 
                       tfrt_2010, 
                       by = "country")
full_2010

# Examine the rows that are missing fertility or population
full_2010 %>%
  filter(is.na(fertility))

full_2010 %>%
  filter(is.na(population))

# Left join
left_2010 <- left_join(pop_2010, 
                       tfrt_2010, 
                       by = "country")
left_2010

# Why do we get the same number of rows as the full join?

right_2010 <- right_join(pop_2010, 
                         tfrt_2010, 
                         by = "country")
right_2010

# How could we rewrite this using a left join?
left_tfrt_2010 <- left_join(tfrt_2010, 
                         pop_2010, 
                         by = "country")
left_tfrt_2010

# anti_join(x, y) returns observations of x with no match in y
anti_join(pop, tfrt, by = c("country", "date"))

# In this case, we get the rows with population values but no fertility values

# Many-to-many relationships
# By default, dplyr guards against many-to-many relationships in equality joins by throwing a warning. These occur when both of the following are true:
  
# 1. A row in x matches multiple rows in y.

# 2. A row in y matches multiple rows in x.

# This is typically surprising, as most joins involve a relationship of one-to-one, one-to-many, or many-to-one, and is often the result of an
# improperly specified join. Many-to-many relationships are particularly problematic because they can result in a Cartesian explosion of the number
# of rows returned from the join.

# many rows of population and fertility for each country (one for each year)
cartesian_explosion <- full_join(tfrt, pop, by="country")

# dplyr protected us from running this join. If we really want a many-to-many join, specify like this:
cartesian_explosion <- full_join(tfrt, pop, by="country", relationship = "many-to-many")

# Remember from the source data: 4991 rows in pop, 4631 rows in tfrt
# many_to_many_explosion has 106605 rows!

# How did we get so many rows? The full join matched the possible combinations of the countries and years.

pop %>% filter(country=="Italy") # 23 rows
tfrt %>% filter(country=="Italy") # 22 rows

# Cartesian product of these two tables is 23 * 22 = 506

cartesian_explosion %>% filter(country=="Italy")

# Each row in pop matched all 22 rows in tfrt.

# Sources for this tutorial:
# - https://www.guru99.com/r-dplyr-tutorial.html

# - https://jmsallan.netlify.app/blog/joining-relational-tables-in-dplyr/

# - https://r4ds.hadley.nz/joins.html

# - https://dplyr.tidyverse.org/reference/mutate-joins.html


