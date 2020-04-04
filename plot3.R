# Instructions

# The dfset has 2,075,259 rows and 9 columns. 
# First calculate a rough estimate of how much memory the dfset will require in memory 
# before reading into R. Make sure your computer has enough memory.
# We will only be using df from the dates 2007-02-01 and 2007-02-02. 
# One alternative is to read the df from just those dates.
# Useful to convert the Date and Time variables 
# to Date/Time classes in R using strptime() and as.Date() functions.
# Missing values are coded as ?

# ------------------------------------
# Load required libraries
if (!require('tidyverse')) install.packages('tidyverse')
library(tidyverse)

# Let's start with df download
# We copy link used in project description Electric power consumption
# and assign it to fileurl

filename <- 'household_power_consumption.zip'

# Controll for already existing files
# If folder doesn't exist proceed with download
if (!file.exists(filename)){
  fileURL <- 'https://d396qusza40orc.cloudfront.net/exdf%2Fdf%2Fhousehold_power_consumption.zip'
  download.file(fileURL, filename, method='curl')
}  

#If folder exists proceed with unzip
if (!file.exists('household_power_consumption.txt')) { 
  unzip(filename) 
}

# Now we read df frame
# from file household_power_consumption.txt
# We will use all the df

# Inside read.table function we will use na.strings = '?' option to replace missing values with NA
df <- read.table('./household_power_consumption.txt', header=TRUE, sep=';', 
                 stringsAsFactors=FALSE, dec='.', na.strings = '?')

# Now we keep only needed df interval

df <- filter(df, Date=="1/2/2007" | Date=="2/2/2007")

# Let's check for the number of missing values
sum(is.na(df)) 

# We will convert the Date and Time variables to Date/Time classes 
# First we check classes of every column inside df
lapply(df,class)

# From the result we see that columns Date and Time is of class 'character' 
# If we want we can convert variable Date like
df$Date <- as.Date(df$Date, format="%d/%m/%Y")
# If we want we can convert variable Time like
df$Time <- strptime(df$Time, format="%H:%M:%S")
df[1:1440,"Time"] <- format(df[1:1440,"Time"],"2007-02-01 %H:%M:%S")
df[1441:2880,"Time"] <- format(df[1441:2880,"Time"],"2007-02-02 %H:%M:%S")

# For the sake of plotting we create a timestamp dt
df$dt <- as.POSIXct(paste(df$Date, df$Time))

# Export plot3 as png
png("plot3.png")

# Now we construct plot3
plot(c(df$Sub_metering_1), type="l", xlab="", ylab="Energy sub metering", lab=c(3,4,31) , xaxt = "n")
axis(side=1, at=c(1, 1442, 2881), labels=c("Thu","Fri","Sat"))
lines(df$Sub_metering_2,col="red")
lines(df$Sub_metering_3,col="blue")
legend("topright","left",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty=1)

#Turn off
dev.off() 