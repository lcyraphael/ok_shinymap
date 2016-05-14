# ui.R

shinyUI(fluidPage(
  titlePanel("Oklahoma Demographics for Determining Lifeline Broadband Subsidies"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
               information from the National Broadband Map."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent Below Poverty Line", "Percent Native American"),
                  selected = "Percent Below Poverty Line"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
      ), 
    mainPanel(plotOutput("map"))
  )
))