#Download and unzip file
zipFile<-"https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
destFile="assignWK1_Dataset.zip"
if(!file.exists(destFile)) {
  download.file(zipFile,destFile,method="curl")
}
unzip(destFile,overwrite=TRUE)

#Load file
dataFile<-"household_power_consumption.txt"
hpcData<-read.table(dataFile,sep=";",header=TRUE,stringsAsFactors = FALSE,na.strings = "?")

#Subset data 
hpc<-sqldf("select Date ,Time, Global_active_power, Global_reactive_power, Voltage, Global_intensity, Sub_metering_1, Sub_metering_2,Sub_metering_3 from hpcData where Date='1/2/2007' OR Date='2/2/2007'")

#Convert date to Date data type
hpc$Date2<-as.Date(hpc$Date,"%d/%m/%Y")
#Combine date and time
hpc$DateTime<-paste(hpc$Date,hpc$Time)
#convert time to date time
hpc$Time2<-strptime(hpc$DateTime,"%d/%m/%Y %H:%M:%S") 
hpc$Time2<-as.POSIXct(hpc$Time2)
hpc$DateTime<-strptime(hpc$DateTime,"%d/%m/%Y %H:%M:%S") 

#plot 4
par(mfrow = c(2, 2)) # Two rows and two columns
with(hpc, {
  
  #Row 1, Col1
  plot( y = Global_active_power, x= DateTime,
        ylab="Global Active Power (kilowatts)",
        xlab=" ",
        type = "l"
  )
  
  #Row 1, Col 2
  plot( y = Voltage, x= DateTime,
        ylab="Voltage",
        xlab=" ",
        type = "l"
  )
  
  #Row 2, Col 1
  plot(y=Sub_metering_1, x=DateTime, ylab="Energy sub metering",type = "l")
  points(y=Sub_metering_2, x=DateTime, col= "red", type="l")
  points(y=Sub_metering_3, x=DateTime, col= "blue", type="l")
  legend("topright", pch = "-",lwd=3, col = c("black","blue", "red"), legend =c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
  
  #Row 2, Col 2
  plot( y = Global_reactive_power, x= DateTime,
        xlab=" ",
        type = "l"
  )
})

dev.copy(png, width=480,height=480,file = "plot4.png") ## Save as PNG file
dev.off() 

