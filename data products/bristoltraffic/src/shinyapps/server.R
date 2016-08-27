library(shiny)
library(leaflet)

# Set up the data set

library (ProjectTemplate)

load.project()


#server part to serve the maps


shinyServer(
        function(input, output, session) {
                
                # Filter data based on user input
                filteredData <- reactive({
                        hourly_summary %>% filter(day==input$day, hour==input$hour)
                })
                
                # show the static map without the circle markers
                
                output$map <- renderLeaflet({
                        leaflet(hourly_summary) %>% addTiles() %>%
                        fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat)) 
                        
                })
                
                
                
                # Create an observer to change the circles based on user input
                
                observe({
                        
                        leafletProxy("map", data = filteredData()) %>%
                                clearMarkers() %>%
                                addCircleMarkers(
                                        ~long, ~lat,
                                        radius = 10,
                                        color = ~status,
                                        stroke = FALSE, fillOpacity = 0.5,
                                        popup = ~section_description
                                )
                })
                
        }
)



