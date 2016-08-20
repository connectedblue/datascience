library(shiny)

# UI for the map display

shinyUI(pageWithSidebar(
        headerPanel("Data science FTW!"),
        sidebarPanel(
                h3('Sidebar text')
        ),
        mainPanel(
                h3('Main Panel text')
        )
))