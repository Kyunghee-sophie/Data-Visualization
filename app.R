
map <-rgdal::readOGR(dsn="C://Users//kxr170000//Documents//R//DV", layer="seoul_acc_2018", integer64="warn.loss", encoding = )
map <- map[ -c(1,4,6,8:9,11) ]
  colnames(map@data)[2] = "Potential population"
  colnames(map@data)[3] = "Spatial accessibility"
  colnames(map@data)[4] = "AI"
  colnames(map@data)[5] = "EldRatio"
  colnames(map@data)[6] = "SRI"
  colnames(map@data)[7] = "PopDens"
  colnames(map@data)[8] = "HPI"
  map_vars <- names(map)


ui <- fluidPage(
  titlePanel("Health Map"),
  sidebarLayout(
    sidebarPanel(
      helpText("Spatial accessibility of ADCC with socioeconomic variables in Seoul"),
      selectInput("var", 
                  label = "Choose a variable to display",
                  map_vars[-c(1)])
    ),
    
    mainPanel(tmapOutput("map"),
              tabPanel("Summary", verbatimTextOutput("summary"))
    )
  )
)

server <- function(input, output, session) {
    
  output$map <- renderTmap({
    tm_shape(map) +
      tm_polygons(map_vars[1], zindex = 401)
  })
  
  observe({
    var <- input$var
    Mypal.blue <- c('#f1eef6','#bdc9e1','#74a9cf','#2b8cbe','#045a8d')
    tmapProxy("map", session, {
      tm_remove_layer(401) +
        tm_shape(map) +
        tm_fill(var, style="quantile", palette=Mypal.blue)+
        tm_borders()
    })
  })
  
  output$summary <- renderPrint({
    summary(map[-c(1)]@data)
  })
  
  output$info <- renderText({
    paste0("var", input$var)
  })
  
}	

shinyApp(ui, server)

