library(gtrendsR)

ch <- gconnect("notes@evercam.co.uk", "nIQpfUwq9GvbXFBblEVh")

x<-gtrends(c("How to smoke salmon"), c("US-OR", "US-AK"), type="trends")


df<-x$trend

mean_or<-mean(df[3], na.rm = T)
mean_ak<-mean(df[4], na.rm = T)
