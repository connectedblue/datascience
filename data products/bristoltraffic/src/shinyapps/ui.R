library(shiny)
library(leaflet)
library(plotly)



# UI for the map display

shinyUI(pageWithSidebar(
        headerPanel("Bristol City traffic"),
        sidebarPanel(
                p('Select below to explore average traffic conditions on that day and hour'),
                selectInput("day", "Day", 
                            choices=c("Sunday", "Monday", "Tuesday", "Wednesday",
                                      "Thursday", "Friday", "Saturday"),
                            selected = "Monday"),
                sliderInput("hour", "Hour", min=0, max=23,
                            value = 9, step = 1)
                
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel("Traffic Map", 
                                 p("The circles are the centre of each route.
                                   Click to show detailed route information for this time"),
                                 leafletOutput("map")),
                        tabPanel("Route Speeds",
                                 p("The bar graph below shows the average speed of each route
                                   during this time period. Hover over each bar to see the route name"),
                                 plotlyOutput("plot")),
                        tabPanel("About", includeHTML("instructions.html"))
                        
                )
        )
))

