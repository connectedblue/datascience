library('ProjectTemplate')
load.project()


# This data summary is to reproduce a file provided by Bristol City council calculating
# the average speed across all routes 15 Sep - 15 November

hourly_speed_mean <- journeys %>% filter(doy >= as.POSIXlt("15/09/2014", "%d/%m/%Y", tz="GMT")$yday &
                                                 doy <= as.POSIXlt("15/11/2014", "%d/%m/%Y", tz="GMT")$yday) %>%
        group_by(hour) %>%
        summarise(ave_speed=mean(est_speed_mph))