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
        journeys$hour <- as.numeric(strftime(journeys$time, "%H"))
        journeys$distance <- round(journeys$travel.time/(60*60)*journeys$est_speed,1)

        # fix errors in the data, found through exploratory analysis
        
        # some sections have 2 leading zeros instead of 3
        journeys$section_id <- sub("SECTIONTL00([0-9])([0-9])$", "SECTIONTL000\\1\\2", 
                                   journeys$section_id)
        
        # this section has the wrong section ID - should be 176, not 130
        journeys$section_id <-ifelse(journeys$section_id=="SECTIONTL00130" & 
                                     journeys$section_description=="St Michaels OB to Blackboy Hill OB",
                                     "SECTIONTL00176", journeys$section_id )
        
        # these sections have the wrong distance - corrected to the majority for the route
        journeys$distance <-ifelse(journeys$section_id=="SECTIONTL00104" &
                                   journeys$distance==1.8, 2.8, journeys$distance )
        journeys$distance <-ifelse(journeys$section_id=="SECTIONTL00109" &
                                           journeys$distance==1.7, 2.8, journeys$distance )
        
}

# cache and tidy up
update_cache(c("Historic.journey.times", "journeys"))
rm(Historic.journey.times)

summary <- journeys %>% group_by(section_id, section_description,
                                 distance) %>%
                     summarise(n=n())

