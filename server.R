# server.R

library(maps)
library(mapproj)
library(leaflet)

df <- readRDS("data/okdem.rds")
source("helpers.R")

shinyServer(
  function(input, output) {
    output$map <- renderPlot({
      args <- switch(input$var,
                     "Percent Below Poverty Line" = list(df$incomeBelowPoverty, "darkgreen", "% Below Poverty Line"),
                     "Percent Native American" = list(df$raceNativeAmerican, "darkblue", "% Native American"))
      
      args$min <- input$range[1]
      args$max <- input$range[2]
      
      do.call(percent_map, args)
    })
  }
)
