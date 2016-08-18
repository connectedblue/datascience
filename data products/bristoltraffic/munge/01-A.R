# Create a dataset called journeys from the raw data
# Add some additional fields
# Correct some data errors

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
        journeys$doy <- as.numeric(strftime(journeys$time, "%j"))
        journeys$distance_miles <- round(journeys$travel.time/(60*60)*journeys$est_speed,1)
        
        # Rename column to show mph
        names(journeys)[names(journeys)=="est_speed"] <- "est_speed_mph"

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
        
        # correct the sections that have multiple location points
        # (see file sent by bristol city council.  This is loaded into fix.locations)
        journeys<-merge(journeys, fix.locations, by="section_id", all.x=TRUE)
        journeys$location=ifelse(is.na(journeys$new_loc), journeys$location, journeys$new_loc)
        journeys$new_loc<-NULL
}

# cache and tidy up
update_cache(c("Historic.journey.times", "journeys"))
rm(Historic.journey.times)


summary <- journeys %>% group_by(section_id, section_description,
                                 distance, location) %>%
                     summarise(n=n())

# This data summary is to reproduce a file provided by Bristol City council calculating
# the average speed across all routes 15 Sep - 15 November

hourly_speed_mean <- journeys %>% filter(doy >= as.POSIXlt("15/09/2014", "%d/%m/%Y", tz="GMT")$yday &
                                         doy <= as.POSIXlt("15/11/2014", "%d/%m/%Y", tz="GMT")$yday) %>%
                                  group_by(hour) %>%
                                  summarise(ave_speed=mean(est_speed_mph))



