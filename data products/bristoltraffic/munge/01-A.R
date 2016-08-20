
# Function to clean up a raw dataset
# input is:
#    journeys is a dataframe in the form specified by Bristol CC
#             in this dataset:  https://opendata.bristol.gov.uk/Mobility/Historic-journey-times/jdq4-bmr7
#    location_fixes is a dataframe that corrects central location points for some routes

clean_traffic_data <- function(journeys, location_fixes) {
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
        journeys$time_period <- ifelse(journeys$hour>=0  & journeys$hour< 6, "Night",
                                ifelse(journeys$hour>=6  & journeys$hour<10, "Morning",       
                                ifelse(journeys$hour>=10 & journeys$hour<16, "Day",
                                ifelse(journeys$hour>=16 & journeys$hour<20, "Evening", "Night")
                                )))
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
        
        
        # these sections have the wrong distance for some lines.
        # remove them because we don't know if it's journey time or speed that is 
        # incorrect (or both even)
        journeys <- journeys[!((journeys$section_id=="SECTIONTL00104" &
                              journeys$distance==1.8) |
                              (journeys$section_id=="SECTIONTL00109" &
                               journeys$distance==1.7)),]             
                                     
        
        # correct the sections that have multiple location points
        # (see file sent by bristol city council)
        journeys<-merge(journeys, location_fixes, by="section_id", all.x=TRUE)
        journeys$location<-as.character(journeys$location)
        journeys$new_loc<-as.character(journeys$new_loc)
        journeys$location<-ifelse(is.na(journeys$new_loc), journeys$location, 
                                  journeys$new_loc)
        journeys$new_loc<-NULL
        
        # remove lat/long columns since they are now inconsistent
        journeys$lat<-NULL
        journeys$long<-NULL
        
        # Re-create some factor variables to make subsequent analysis more efficient
        journeys$section_id<-as.factor(journeys$section_id)
        journeys$location<-as.factor(journeys$location)
        journeys$day<-as.factor(journeys$day)
        journeys$month<-as.factor(journeys$month)
        journeys$time_period<-as.factor(journeys$time_period)
        
        # Return the cleaned up dataframe
        journeys
}

