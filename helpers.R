# N.B. variables in server.R are accessible here. 
# Input and output IDs in Shiny apps share a global namespace.
# Can modularize as well 

# For Tab2
# define percent map function that is called by do.call() in server.R 
# Takes in list of 3 (lst, str, str)
percent_map2 <- function(var, col, legend.title) {

  # generate vector of fill colors for map
  pal <- colorNumeric(palette = col, domain = var)

  # create pop-up on click
  county_popup <- paste0("<strong>Name: </strong>", okgj$name, "<br><strong>",legend.title,", 2014: </strong>", var*100, "%")

  # produce base map
  map <- leaflet(data=okgj) %>% addTiles()
  
  # add specs
  map %>% 
  addPolygons(
    stroke = FALSE, 
    smoothFactor = 0.2, 
    fillOpacity = 0.8, 
    fillColor = ~pal(var), 
    weight = 1, 
    popup = county_popup) %>% 
  addLegend(
    "bottomleft",
    pal = pal, 
    values = ~var,
    title = legend.title,
    labFormat = labelFormat(suffix = "%"),
    opacity = 1) %>% 
  addPolylines(data=aesa, color="red", popup="Enhanced Support Area") %>% 
  addPolylines(data=chero, color="blue", popup="Cherokee Outlet")
}

# For Slider Map (Tab1)
percent_map1 <- function(var, color, legend.title, min = 0, max = 100) {

  # generate vector of fill colors for map
  shades <- colorRampPalette(c("white", color))(100)
  
  # constrain gradient to percents that occur between min and max
  var <- pmax(var, min)
  var <- pmin(var, max)
  percents <- as.integer(cut(var, 100, include.lowest = TRUE, ordered = TRUE))
  fills <- shades[percents]

  # map(aesa, fill = FALSE, add = TRUE)

  # plot choropleth map
  map("county", region="oklahoma", fill = TRUE, col = fills,
    resolution = 0, lty = 0, projection = "polyconic", 
    myborder = 0, mar = c(0,0,0,0))
  
  # # overlay county borders
  map("county", region="oklahoma", col = "black", fill = FALSE, add = TRUE,
    lty = 1, lwd = 1, projection = "polyconic", 
    myborder = 1, mar = c(0,0,0,0))

  # add a legend
  inc <- (max - min) / 4
  legend.text <- c(paste0(min, " % or less"),
    paste0(min + inc, " %"),
    paste0(min + 2 * inc, " %"),
    paste0(min + 3 * inc, " %"),
    paste0(max, " % or more"))
  
  legend("bottomleft", 
    legend = legend.text, 
    fill = shades[c(1, 25, 50, 75, 100)], 
    title = legend.title)
}