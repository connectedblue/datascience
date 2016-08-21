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
if(!config$keep_raw_data) rm(Historic.journey.times)
rm(fix.locations)

# Summarise the key data for each route

summary <- journeys %>% group_by(section_id, section_description,
                                 distance_miles, location) %>%
        summarise(mean_speed=mean(est_speed_mph), 
                  sd_speed=sd(est_speed_mph),
                  mean_travel_time=mean(travel.time), 
                  sd_travel_time=sd(travel.time))

summary <- cbind(as.data.frame(summary), split_location(summary$location))

#  Calculate mean for each hour and day on each route

hourly_summary <- journeys %>% group_by(section_id, day, hour) %>%
        summarise(mean_speed=mean(est_speed_mph), 
                  sd_speed=sd(est_speed_mph),
                  mean_travel_time=mean(travel.time), 
                  sd_travel_time=sd(travel.time))

hourly_summary <- as.data.frame(hourly_summary)


hourly_summary <- merge(hourly_summary, summary, by="section_id", all.x=TRUE)

# Assign red/orange/green to each observation as follows:
#   red if the est_speed_mph is less than (mean - sd) for the route
#   orange if between (mean - sd) and mean
#   green otherwise

hourly_summary$status <- ifelse(hourly_summary$mean_speed.x<(hourly_summary$mean_speed.y - hourly_summary$sd_speed.y), "red",
                         ifelse(hourly_summary$mean_speed.x>=hourly_summary$mean_speed.y, "green", "orange"))




# This data summary is to reproduce a file provided by Bristol City council calculating
# the average speed across all routes 15 Sep - 15 November

hourly_speed_mean <- journeys %>% filter(doy >= as.POSIXlt("15/09/2014", "%d/%m/%Y", tz="GMT")$yday &
                                         doy <= as.POSIXlt("15/11/2014", "%d/%m/%Y", tz="GMT")$yday) %>%
                                  group_by(hour) %>%
                                  summarise(ave_speed=mean(est_speed_mph))



