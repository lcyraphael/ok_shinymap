# ui.R
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Oklahoma Demographics for Determining Lifeline Broadband Subsidies"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create interactive demographic maps with 
               information from the National Broadband Map and the Federal Communications Commission."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent Below Poverty Line", "Percent Native American"),
                  selected = "Percent Below Poverty Line"),

      sliderInput("range", 
                  label = "Range of interest: (For slider tab)",
                  min = 0, max = 100, value = c(0, 100)),

      tags$hr(),
      tags$a(href="https://lcyraphael.github.io/oklahoma_lifeline.html", "Read more about visualizing Lifeline"),
      tags$br(),
      tags$a(href="https://github.com/lcyraphael/ok_shinymap", "Source code"),
      tags$h6("By Raphael Leung, Oxford Internet Institute")
      ), 
    
    mainPanel(
      tabsetPanel(
        type="tabs",
        tabPanel(title = "Drag the slider", plotOutput("map1")),
        tabPanel(title = "Explore the data (Click on the counties)", leafletOutput("map2"))
      )
    )
  )
))