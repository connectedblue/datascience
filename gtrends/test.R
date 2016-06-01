library(gtrendsR)
library(dplyr)


data(countries)

states<-countries %>% filter(country=="United States") %>% select(subcode)



ch <- gconnect("notes@evercam.co.uk", "nIQpfUwq9GvbXFBblEVh")

sublist<-states$subcode[2]

x<-gtrends(c("where is the internet"), geo=sublist, start_date = "2007-01-01")


df<-x$trend

mean_or<-mean(df[,3], na.rm = T)
mean_ak<-mean(df[,4], na.rm = T)
