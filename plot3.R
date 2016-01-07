#clean up
rm(list=ls())

#load required libraries
library(data.table)
library(lubridate)
library(dplyr)

# get zipped data set if not present yet and unzip

datasetURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datasetfilename <- "exdata-data-household_power_consumption.zip"
if (!file.exists(datasetfilename)) { download.file(url = datasetURL, dest = datasetfilename) }
unzip(zipfile = datasetfilename, overwrite = FALSE)

# Extract data for 1 and 2 Feb 2007: 2 days, 24 hours per day, 60 minutes per hour
df <- fread("household_power_consumption.txt", sep = ";", header = FALSE, na.strings = '?', skip = "1/2/2007", nrows = 2*24*60,
            col.names = as.vector(strsplit(readLines("household_power_consumption.txt", 1), ";")[[1]]),
            colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

# Concatenate Date and Time, convert to POSIXct format
df <- mutate(df, DateTime = dmy_hms(paste(Date, Time, sep = " ")))

# One graph per page
par(mfrow=c(1,1))

# Plot of the 3 Sub_metering variables vs. time, with legend
plot(x = df$DateTime, y = df$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Energy sub metering")
lines(x = df$DateTime, y = df$Sub_metering_2, type = "l", col = "red")
lines(x = df$DateTime, y = df$Sub_metering_3, type = "l", col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), text.col = "black", lty = 1, lwd = 1)

# Copy to PNG file
dev.copy(device = png, filename = 'plot3.png', width = 480, height = 480)
dev.off() 

# And finally, clean up again...
rm(df, datasetfilename, datasetURL)
