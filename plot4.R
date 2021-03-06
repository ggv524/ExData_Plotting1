plot4 <- function() {
# JHU4:Week 1 - Peer Graded Assignment: Course Project 1
# This script downloads a file of individual household electric power consumption data, 
# limits it to two days worth of data, and creates a Line plot from the data.

#STEP001 - Load the libraries to be used in this script
   library(data.table)
   library(utils)
   library(graphics)
   library(datasets)
   
#STEP002 - If the data directory doesn't exist, create it
   if(!file.exists("./data")) {dir.create("./data")}
   
#STEP003 - Acquire the external data file, if not already downloaded, and prepare it for plotting
   fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
   if(!file.exists("./data/household_power_consumption.zip")) {
      download.file(fileUrl, destfile="./data/household_power_consumption.zip", method = "auto")
	unzip("./data/household_power_consumption.zip")
	hpcFile <- file("./household_power_consumption.txt")
      hpcData <- read.table(header=TRUE, sep=";", text=grep("^[1,2]/2/2007", readLines(hpcFile), 
         value=TRUE), na.strings="?")
      colnames(hpcData) <- c("Date", "Time", "Global_Active_Power", "Global_Reactive_Power", 
         "Voltage", "Global_Intensity", "Sub_Metering_1", "Sub_Metering_2", "Sub_Metering_3")
      ###FOR DEBUG: write.table(hpcData, file = "./hpcData.txt", row.names = FALSE)
   }

#STEP004 - Reformat the Date and Time values
   DateTime <- paste(hpcData$Date, hpcData$Time)
   hpcData$DateTime <- strptime(DateTime, "%d/%m/%Y %H:%M:%S")

#STEP005 - Create a set of four Plots in one device
   par(mfrow = c(2,2))
   with(hpcData, {
   #Plot 1:
   plot(DateTime, Global_Active_Power, type="l", xlab="", ylab="Global Active Power (killowatts)")
   #Plot 2:
   plot(DateTime, Voltage, type="l", xlab="datetime", ylab="Voltage")
   #Plot 3:
   plot(DateTime, Sub_Metering_1, xlab="", ylab="Energy sub metering", type="n")
   points(DateTime, Sub_Metering_1, type="l", col="black")
   points(DateTime, Sub_Metering_2, type="l", col="red")
   points(DateTime, Sub_Metering_3, type="l", col="blue")
   legend("topright", lty=1, lwd=2, bty="n", col=c("black", "red", "blue"),
      legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
   #Plot 4:
   plot(DateTime, Global_Reactive_Power, type="l", xlab="datetime", ylab="Global_reactive_power")
   })

#STEP006 - Save the plot as a 480 x 480 pixel .png file.
   dev.copy(png, file="./plot4.png")
   dev.off()  # to close the PNG device

}