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


                  
# Merge in the location and other route specific data
hourly_summary <- merge(hourly_summary, summary, by="section_id", all.x=TRUE)

# Assign red/orange/green to each observation as follows:
#   red if the est_speed_mph is less than (mean - 0.5 * sd) for the route
#   orange if between (mean -  0.5 * sd) and mean
#   green otherwise

hourly_summary$status <- ifelse(hourly_summary$mean_speed.x<(hourly_summary$mean_speed.y - 0.5*hourly_summary$sd_speed.y), "red",
                         ifelse(hourly_summary$mean_speed.x>=hourly_summary$mean_speed.y, "green", "orange"))

hourly_summary$mean

# Make a pop up field to display on map markers

jtime_min <- as.integer((hourly_summary$mean_travel_time.x/60))
jtime_sec <- round((hourly_summary$mean_travel_time.x/60-jtime_min)*60,0)

hourly_summary$popup <- paste0("<b>", hourly_summary$section_description, "</b><br/>",
                               "Distance: ",
                               round(hourly_summary$distance_miles,1), " miles<br/>",
                               "Average speed: ", 
                               round(hourly_summary$mean_speed.x,0), 
                               " mph <br/>",
                               "Average journey time: ",
                               jtime_min ,
                               " minutes ",
                               jtime_sec,
                               " seconds")

rm(jtime_sec, jtime_min)

# save the hourly_summary data set in the shiny directory

write.csv2(hourly_summary, "src/shinyapps/data/bristol.csv")





