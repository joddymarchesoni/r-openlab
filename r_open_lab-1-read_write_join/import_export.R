# R Open Lab 1: Reading, writing, and managing multiple datasets

# Part 1: Importing and exporting data in R

# Getting and setting your path, and using paths in R

# Get the working directory
getwd()

# Set the working directory (Linux and Mac)
setwd("/Users/jimarche/R/r open labs/r_open_lab-1-read_write_join/data")

# Check whether it changed to "data"
getwd()

# What if you are on Windows?
# setwd("C:/Users/jimarche/R/r open labs/r_open_lab-1-read_write_join/data")

# 1. Importing data

# Text file

# `read.table()` is the most basic importing function.

# You can specify tons of different arguments in this function. 
stocks <- read.table("sample-5.tsv", sep="\t", skip=26, skipNul=TRUE, header=TRUE)
stocks <- stocks[,-1] # Get rid of the first column, which is blank

library(readr)

stocks <- read_tsv("sample-5.tsv", skip=20, col_select=-1) # col_select lets us delete column 1 in the read function

# Comma separated variable (csv)

library(readr)

birds <- read_csv("birds.csv")

birds <- read_csv("birds.csv", col_names=TRUE, skip=0)

# Excel (xls, xlsx)

library(readxl)

ufo <- read_excel("ufo.xlsx")

# using range= to: take the first 200 rows from ufo.xlsx, dropping the last 3 columns 
ufo <- read_excel("ufo.xlsx", col_names=TRUE, range="B1:H201")

# Loading a sheet from an excel file with multiple sheets
ufo <- read_excel("ufo.xlsx", sheet="ufo")

# read_xls for older excel files (.xls)
participants <- read_xls("participants.xls")

# Other data formats using Haven

library(haven)

#  **SAS**: `read_sas()` reads .sas7bdat and .sas7bcat files and `read_xpt()` reads SAS transport files (version 5 and version 8).
# `write_sas()` writes .sas7bdat files.
airline <- read_sas("airline.sas7bdat")

# **SPSS**: `read_sav()` reads .sav files and `read_por()` reads the older .por files. `write_sav()` writes .sav files.
bankloan <- read_sav("bankloan.sav")

# **Stata**: `read_dta()` reads .dta files (up to version 15).
# `write_dta()` writes .dta files (versions 8-15).
auto <- read_dta("auto.dta")

# 2. Writing datasets from data.frame or tibble

# Writing .txt and .csv files
# Loading mtcars data
# Write data to txt file: tab separated values
write.table(mtcars, file = "mtcars.txt", sep = "\t",
            row.names = TRUE, col.names = NA)

# Write data to csv files:  
# decimal point = "." and value separators = comma (",")
write.csv(mtcars, file = "mtcars.csv")

# Using the readr package (tidyverse)

# Loading mtcars data
data(mtcars)
library(readr)

# Writing mtcars data to a tsv file
write_tsv(mtcars, path = "mtcars.txt")
# Writing mtcars data to a csv file
write_csv(mtcars, path = "mtcars.csv")

# Writing .xlsx files

library(writexl)

df <- data.frame(
  name = c("UCLA", "Berkeley", "Jeroen"),
  founded = c(1919, 1868, 2030),
  website = xl_hyperlink(c("http://www.ucla.edu", "http://www.berkeley.edu", NA), "homepage") )
df$age <- xl_formula('=(YEAR(TODAY()) - INDIRECT("B" & ROW()))')
write_xlsx(df, 'universities.xlsx')

# Exporting R data files

# Saving and restoring one single R object:
  # Save a single object to a file
saveRDS(mtcars, "mtcars.rds")
# Restore it under a different name
my_data <- readRDS("mtcars.rds")

# Saving and restoring one or more R objects:

ufo1 <- ufo[1:100,]
ufo2 <- ufo[101:200,]

# Save multiple objects
save(ufo1, ufo2, file = "ufo_first200.RData")
# To load the data again
load("ufo_first200.RData")

# What other file types have you worked with? Let's try to import them into R!






