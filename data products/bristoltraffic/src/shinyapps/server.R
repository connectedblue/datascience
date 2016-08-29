library(shiny)
library(leaflet)
library(dplyr)
library(plotly)


# Set up the data set

hourly_summary <- read.csv2("data/bristol.csv")

# helper functions

city_speed <- function(data){
        round(sum(data$distance_miles)/
                      (sum(data$mean_travel_time.x)/3600),
              0)
}

time_format <- function (h) {
        
        period <- ifelse(h>=6 & h<=10, "Morning",
                  ifelse(h>=10 & h<17, "Afternoon",
                  ifelse(h>=17 & h<20, "Evening", "Nighttime")))
        h1<-h%%12
        if (h1==0) h1<-12
        h2<-(h1+1)%%12
        if (h2==0) h2<-12
        time <- paste0(h1," - ", h2, ifelse(h<12, "am", "pm"))
        list(period=period, time=time)
}

#server part to serve the maps


shinyServer(
        function(input, output, session) {
                
                # Filter data based on user input
                filteredData <- reactive({
                        hourly_summary %>% filter(day==input$day, hour==input$hour)
                })
                
                # show the static map without the circle markers and mean city speed
                
                output$map <- renderLeaflet({
                        leaflet(hourly_summary) %>% addTiles() %>%
                        fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat)) 
                        
                })
                
                
                
                # Create an observer to change the circles and add city speed legend
                
                observe({
                        city_speed <- city_speed(filteredData()) 
                        t_fmt<-time_format(input$hour)
                        period <- t_fmt$period
                        time <- t_fmt$time
                        
                        title <- paste0("<big>",input$day, " ", period, "<br/>", time, "</big>"  )
                        leafletProxy("map", data = filteredData()) %>%
                                clearMarkers() %>%
                                clearControls() %>%
                                addCircleMarkers(
                                        ~long, ~lat,
                                        radius = 10,
                                        color = ~status,
                                        stroke = FALSE, fillOpacity = 0.5,
                                        popup = ~popup
                                ) %>%
                                addLegend("topright", colors=c(""),
                                          title = "Ave City Speed",
                                          labels=c(paste0("<big><big>", city_speed,"<b></big></big><big>&nbsp;mph</big></b>"))
                                ) %>%
                                addLegend("bottomright", title="Route status",
                                          colors=c("red", "orange", "green"),
                                          labels=c("Congested<br/>", "Slow<BR/>", "Normal"),
                                          opacity=0.5
                                ) %>%
                                addLegend("bottomleft", title=title,colors=c(""),
                                          labels=c("")
                                ) 
                })
                
                
        
                
                # plot
                output$plot <- renderPlotly({
                        data <- filteredData()
                        city_speed <- city_speed(data)
                        t_fmt<-time_format(input$hour)
                        period <- t_fmt$period
                        time <- t_fmt$time
                        title <- paste0(input$day, " ", period,": ", time)
                        
                        data$label <- paste0(data$section_description, "ss:ss", data$mean_speed.x)
                        g<-ggplot(data,aes(x=reorder(section_description, -mean_speed.x), 
                                           y=mean_speed.x)) +
                                   geom_bar(stat="identity",
                                            fill=data$status) +
                                   xlab("Routes") + ylab("Average Speed (mph)") +
                                   coord_flip() +
                                   theme(axis.text.y=element_blank(),
                                         axis.ticks.y=element_blank(),
                                         panel.grid.minor=element_blank(), 
                                         panel.grid.major=element_blank(),
                                         panel.background = element_rect(fill = "cornsilk"),
                                         panel.border = element_rect(fill="transparent", colour="black")) +
                                   geom_hline(yintercept = city_speed, linetype="dashed", colour="black", size=1) +
                                   ggtitle(paste0(title, ".  Average city speed: ", city_speed, "mph")               
                            )
                        ggplotly(g)
                })
                 
        }
)

#    geom_text(aes(x=35, y=city_speed, fill="white", label=paste0("Average City\nSpeed ", city_speed)))

