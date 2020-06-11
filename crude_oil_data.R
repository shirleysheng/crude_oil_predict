library(quantmod)
library(Quandl)
library(tidyquant)

getSymbols("DX-Y.NYB",src='yahoo',from = "2015-01-01") #US dollar index
getSymbols("^IXIC",src='yahoo',from = "2015-01-01")  #Nasdaq index
getSymbols("^DJI",src='yahoo',from = "2015-01-01")  #DowJones index
Gold<-Quandl("LBMA/GOLD",start_date = "2015-01-01") #gold price
wti_price_usd <- tq_get("DCOILWTICO", get = "economic.data",from = "2015-01-01") #crude oil price

#
us.index<-data.frame(`DX-Y.NYB`)
write.csv(us.index,"US_INDEX.csv",row.names = TRUE)
us.index <- read.csv("US_INDEX.csv")
us.index <- na.omit(us.index)
us.index <- us.index[,c(1,7)]
colnames(us.index)<- c('date','US_INDEX')

Nas <- data.frame(IXIC)
write.csv(Nas,"NAS_INDEX.csv",row.names = TRUE)
Nas <- read.csv("NAS_INDEX.csv")
Nas <- na.omit(Nas)
Nas <- Nas[,c(1,7)]
colnames(Nas)<- c('date','NAS')

DJ <- data.frame(DJI)
write.csv(DJ,"DJ_INDEX.csv",row.names = TRUE)
DJ <- read.csv("DJ_INDEX.csv")
DJ <- na.omit(DJ)
DJ <- DJ[,c(1,7)]
colnames(DJ)<- c('date','DowJ')

gold <- data.frame(Gold)
write.csv(gold,"GOLD_PRICE.csv",row.names = TRUE)
gold <- read.csv("GOLD_PRICE.csv")
gold <- na.omit(gold)
gold <- gold[,c(2,3)]
colnames(gold)<- c('date','gold')

crude.oil <- data.frame(na.omit(wti_price_usd))
write.csv(crude.oil,"OIL_PRICE.csv",row.names = TRUE)
crude.oil <- read.csv("OIL_PRICE.csv")
crude.oil <- crude.oil[,c(2,3)]
colnames(crude.oil) <- c('date','oil')

all_data <- data.frame(NA)
all_data <- merge(crude.oil, gold, by = "date",all= FALSE)
all_data <- merge(all_data, DJ, by = "date",all= FALSE)
all_data <- merge(all_data, Nas, by = "date",all= FALSE)
all_data <- merge(all_data, us.index, by = "date",all= FALSE)
write.csv(all_data,"DATA.csv")


#
all_data <- read.csv("DATA.csv")
direction <- c()
for (i in 2: nrow(all_data)){
  if (all_data[,3][i] >= all_data[,3][i-1]){
    direction[i]<- c("up")
  }
  else {
    direction[i]<- c("down")
  }
}
data<-cbind(all_data,direction)
data <- data.frame(data[-1,])
write.csv(data,"qualitative_DATA.csv")