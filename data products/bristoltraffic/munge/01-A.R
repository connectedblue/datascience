# Example preprocessing script.

if(!exists("journeys")){
        # Rename dataframe to something easier to manage
        
        journeys<- Historic.journey.times
        
        # first line is blank, so remove
        
        journeys <- journeys[2:nrow(journeys),]
        
        
        # convert time column to date object
        
        
        journeys$time <- as.POSIXct(as.character(journeys$time), 
                                         format="%m/%d/%Y %I:%M:%S %p %z")
        
        
        
        # Create some new columns to split the date object into more useful components
        journeys$day <- weekdays(journeys$time)
        journeys$month <- months(journeys$time)
        journeys$week <- as.numeric(strftime(journeys$time, "%W"))
        
}

# cache and tidy up
update_cache(c("Historic.journey.times", "journeys"))
rm(Historic.journey.times)

