library(shiny)
library(leaflet)



# UI for the map display

shinyUI(pageWithSidebar(
        headerPanel("Data science FTW!"),
        sidebarPanel(
                h3('Sidebar text'),
                sliderInput("hour", "Hour", min=0, max=23,
                            value = 9, step = 1
                ),
                selectInput("day", "Day", 
                            choices=c("Sunday", "Monday", "Tuesday", "Wednesday",
                                      "Thursday", "Friday", "Saturday"),
                            selected = "Monday"
                )
        ),
        mainPanel(
                leafletOutput("map")
        )
))

