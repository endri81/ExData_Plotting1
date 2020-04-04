# Instructions

# The dataset has 2,075,259 rows and 9 columns. 
# First calculate a rough estimate of how much memory the dataset will require in memory 
# before reading into R. Make sure your computer has enough memory.
# We will only be using data from the dates 2007-02-01 and 2007-02-02. 
# One alternative is to read the data from just those dates.
# Useful to convert the Date and Time variables 
# to Date/Time classes in R using strptime() and as.Date() functions.
# Missing values are coded as ?

# ------------------------------------
# Load required libraries
if (!require('tidyverse')) install.packages('tidyverse')
library(tidyverse)

# Let's start with data download
# We copy link used in project description Electric power consumption
# and assign it to fileurl

filename <- 'household_power_consumption.zip'

# Controll for already existing files
# If folder doesn't exist proceed with download
if (!file.exists(filename)){
  fileURL <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
  download.file(fileURL, filename, method='curl')
}  

#If folder exists proceed with unzip
if (!file.exists('household_power_consumption.txt')) { 
  unzip(filename) 
}

# Now we read data frame
# from file household_power_consumption.txt
# We will use all the data

# Inside read.table function we will use na.strings = '?' option to replace missing values with NA
df <- read.table('./household_power_consumption.txt', header=TRUE, sep=';', 
stringsAsFactors=FALSE, dec='.', na.strings = '?')

# Now we keep only needed data interval

df <- filter(df, Date=="1/2/2007" | Date=="2/2/2007")

# Let's check for the number of missing values
sum(is.na(df)) 

# We will convert the Date and Time variables to Date/Time classes 
# First we check classes of every column inside df
lapply(df,class)

# From the result we see that columns Date and Time is of class 'character' 
# For plotting we create a variable dt (Date and Time as timestamp) 
df$dt <- strptime(paste(df$Date, df$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 

# If We want we can convert variable Date like
df$Date <- as.Date(df$Date, format = "%d/%m/%Y")



