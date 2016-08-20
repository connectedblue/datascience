# If not already present, create a dataset called journeys from the raw historic data
# and clean up 

if(!exists("journeys")){
        
        journeys<- Historic.journey.times
        
        # first line is blank, so remove
        journeys <- journeys[2:nrow(journeys),]
        
        # Clean up
        journeys <- clean_traffic_data(journeys, fix.locations)
}

# cache and tidy up
update_cache(c("Historic.journey.times", "journeys"))
rm(Historic.journey.times)
rm(fix.locations)



# Summarise the key data for each route

summary <- journeys %>% group_by(section_id, section_description,
                                 distance_miles, location) %>%
                     summarise(n=n())

summary <- cbind(as.data.frame(summary), split_location(summary$location))


# This data summary is to reproduce a file provided by Bristol City council calculating
# the average speed across all routes 15 Sep - 15 November

hourly_speed_mean <- journeys %>% filter(doy >= as.POSIXlt("15/09/2014", "%d/%m/%Y", tz="GMT")$yday &
                                         doy <= as.POSIXlt("15/11/2014", "%d/%m/%Y", tz="GMT")$yday) %>%
                                  group_by(hour) %>%
                                  summarise(ave_speed=mean(est_speed_mph))



