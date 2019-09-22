library(shiny)
library(dplyr)

source("deploy_model01.R")
source("nextWord_model01.R")

server <- function(input, output) {
  
  result.table <- reactive({
      
    return(nextWord(input$text))
    
  })
  
  output$result.text1 <- renderTable(colnames = FALSE,
    
    if (input$text != "") {result.table()[1,1]}
    
  )
  
  output$result.table <- renderTable(colnames = FALSE,
    
    if (input$text != "") {result.table()[-1,1]}
    
  )
  
  output$result.table2 <- renderTable(digits = 10,
                                          
    if (input$text != "") {result.table()}
                                          
  )
  
} 