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


#plot 3
with(hpc, plot(y=Sub_metering_1, x=DateTime, ylab="Energy sub metering",type = "l"))
with(hpc, points(y=Sub_metering_2, x=DateTime, col= "red", type="l"))
with(hpc, points(y=Sub_metering_3, x=DateTime, col= "blue", type="l"))
legend("top", pch = "-",lwd=3, col = c("black","blue", "red"), legend =c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"))
dev.copy(png, width=480,height=480,file = "plot3.png") ## Save as PNG file
dev.off() 