# Plot some basic data onto a map

library(leaflet)
library(manipulate)
# Create a palette that maps factor levels to colors

#pal <- colorFactor(c("navy", "red"), domain = c("ship", "pirate"))

#test <- hourly_summary %>% filter(day==day, hour==hour)

day="Monday"
hour=15

#manipulate(
m<-leaflet(data=(hourly_summary %>% filter(day==day, hour==hour))) %>% addTiles() %>%
        setView(lat= 51.454514, lng=-2.587910, zoom = 14) %>%
        addCircleMarkers(
                ~long, ~lat,
                radius = 10,
                color = ~status,
                stroke = FALSE, fillOpacity = 0.5,
                popup = ~section_description
        )