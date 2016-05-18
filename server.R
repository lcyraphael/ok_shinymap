# server.R

library(maps)
library(mapproj)
library(leaflet)
library(rgdal)

source("helpers.R")

# Load in basic county lines 
ok <- map("county", region="oklahoma")

df_rds <- readRDS("./data/okdem.RDS")

# Load in shapefiles from FCC 
# https://www.fcc.gov/general/oklahoma-enhanced-lifeline-support-maps
aesa <- readOGR(dsn = "./data", layer = "adopted_enhanced_support_area")
chero <- readOGR(dsn = "./data/", layer = "cherokee_outlet")

# Load in CSV (as scraped from NTIA's NBP API https://broadbandmap.gov/developer) and trim
ok_dem <- read.csv("./data/ok_dem.csv", header=TRUE)
df <- ok_dem[,c("date", "geographyId", "geographyName", "raceNativeAmerican", "incomeBelowPoverty")]
df_2014 <- subset(df, date=="2014-06-01")

# Load in GEOJSON of OK county lines from http://catalog.opendata.city/dataset/oklahoma-counties-polygon/resource/75b87ccf-da9e-464e-814b-16985041d2ca
# Merge geojson with tabular data on common column FIPS 
okgj <- readOGR(dsn="./data/okcounties.geojson", layer="OGRGeoJSON")
d <- okgj@data
df_2014$longid <- sub("^", "05000US", df_2014$geographyId)
mer = merge(d, df_2014, by.x="geoid", by.y="longid", sort=FALSE)
okgj@data <- mer

shinyServer(
  function(input, output) {
    output$map1 <- renderPlot({
      args1 <- switch(input$var,
                     "Percent Below Poverty Line" = list(df_rds$incomeBelowPoverty*100, "darkgreen", "% Below Poverty Line"),
                     "Percent Native American" = list(df_rds$raceNativeAmerican*100, "darkblue", "% Native American"))
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
    
   #   plot(selectedData(),
   #        col = clusters()$cluster,
   #        pch = 20, cex = 3)
   #   points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
   # })
   # output$table <- renderDataTable({
   #   selectedData()
   # })
  }
)