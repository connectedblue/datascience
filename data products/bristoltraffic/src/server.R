library(shiny)

#server part to serve the maps

shinyServer(
        function(input, output) {
        }
)


icon.glyphicon <- makeAwesomeIcon(icon= 'flag', markerColor = 'red',
                                  iconColor = 'black', library = 'glyphicon')


redMarker <- icons(
        iconUrl = "http://leafletjs.com/docs/images/marker-icon-red.png",
        iconWidth = 38, iconHeight = 95,
        iconAnchorX = 22, iconAnchorY = 94
)


# This seems to work simply - coloured circles that stay the same size regardless
# of zoom

(m<-leaflet()  %>% addTiles() %>% setView(lng = -2.61, lat = 51.463, zoom = 13) %>%
                addCircleMarkers(lng=summary$long, lat=summary$lat, popup = summary$section_description,
                weight = 3, radius=7, 
                color=summary$colour, stroke = TRUE, fillOpacity = 0.8) )




m %>% addCircles(~lng, ~lat, popup=ct$type, weight = 3, radius=40, 
                 color="#ffa500", stroke = TRUE, fillOpacity = 0.8) 

(m<-leaflet()  %>% addTiles() %>% setView(lng = -2.61, lat = 51.463, zoom = 13) %>%
        addCircles(lng=summary$long, lat=summary$lat, popup = summary$section_description,
                   weight = 3, radius=40, 
                   color="red", stroke = TRUE, fillOpacity = 0.8) )

        
        
      addMarkers(lng=summary$long, lat=summary$lat, popup = summary$section_description,
                 icon=redMarker))