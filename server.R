# server.R

library(maps)
library(mapproj)
library(leaflet)
library(rgdal)

source("helpers.R")

shinyServer(
  function(input, output) {
    
    output$map1 <- renderPlot({
      args1 <- switch(input$var,
                     "Percent Below Poverty Line" = list(df_rds1$incomeBelowPoverty, "darkgreen", "% Below Poverty Line"),
                     "Percent Native American" = list(df_rds1$raceNativeAmerican, "darkblue", "% Native American"))
      args1$min <- input$range[1]
      args1$max <- input$range[2]
      
      do.call(percent_map1, args1)
    })
    
    output$map2 <- renderLeaflet({
      # Pass in var as obtained from SelectInput from ui.R
      args2 <- switch(input$var,
                     "Percent Below Poverty Line" = list(okgj@data$incomeBelowPoverty, "YlGnBu", "% Below Poverty Line"),
                     "Percent Native American" = list(okgj@data$raceNativeAmerican, "YlOrRd", "% Native American"))      
      do.call(percent_map2, args2)
    })
  }
)