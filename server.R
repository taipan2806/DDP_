#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Read and preprocess data
  rawData <- read.csv("stockprices.csv", header = TRUE, sep = ";")
  prices <- rawData
  prices$posixDate <- as.POSIXct(prices$DATE);
  prices$shortDate <- format(as.POSIXct(prices$DATE), "%d.")
  #Normalize prices
  prices$normalizedAPPL <- prices$APPL / 2 
  prices$normalizedNDX <- prices$NDX / 87
  
  #Performance calculation
  from <- reactive({substr(as.character(input$dateRange[1]), 1, 10)})
  to <- reactive({substr(as.character(input$dateRange[2]), 1, 10)})
  msPerformance <- reactive({(prices[prices$posixDate == to(), ]$MSFT - prices[prices$posixDate == from(), ]$MSFT) * 100 / prices[prices$posixDate == from(), ]$MSFT})
  ndxPerformance <- reactive({(prices[prices$posixDate == to(), ]$NDX - prices[prices$posixDate == from(), ]$NDX) * 100 / prices[prices$posixDate == from(), ]$NDX})
  applePerformance <- reactive({(prices[prices$posixDate == to(), ]$APPL - prices[prices$posixDate == from(), ]$APPL) * 100 / prices[prices$posixDate == from(), ]$APPL})
  
  #Generate output
  msText <- reactive({paste(round(msPerformance(), 2), "%", sep = "")})
  ndxText <- reactive({paste(round(ndxPerformance(), 2), "%", sep = "")})
  appleText <- reactive({paste(round(applePerformance(), 2), "%", sep = "")})
  
  #Assign data to variables
  output$srvMSFT <- renderText(msText())
  output$srvMSFTTitle <- renderText("<font color=\"#FF0000\"><b>Microsoft (MSFT)</b>:</font>") 
  output$srvNDX <- reactive({ifelse(input$showNasdaq, ndxText(), "")})
  output$srvNDXTitle <- renderText(ifelse(input$showNasdaq, "<br><font color=\"#333333\"><b>Nasdaq 100 Index (NDX):</b></font>", ""))
  output$srvAPPL <- reactive({ifelse(input$showApple, appleText(), "")})
  output$srvAPPLTitle <- renderText(ifelse(input$showApple, "<br><font color=\"#0000CC\"><b>Apple (APPL):</b></font>", ""))
  output$srvTitle <- renderText(paste("Performance between ", from(), " and ", to()))
  
  #Generate plot
  output$plot <- renderPlot({
    p <- ggplot(prices[prices$posixDate >= from() & prices$posixDate <= to() & prices$MSFT != "", ])  
      p <- p + geom_line(mapping = aes(x = shortDate, y = MSFT, group = 1), colour = "red") 
      p <- p + xlab("Date")  
      p <- p + ylab("Price (normalized)")  
      p <- p + ggtitle(paste("Performance between ", from(), " and ", to(), sep = ""))
      if(input$showNasdaq){
        p <- p + geom_line(mapping = aes(x = shortDate, y = normalizedNDX, group = 1), colour = "black", linetype = "dashed") 
      }
      if(input$showApple){
        p <- p + geom_line(mapping = aes(x = shortDate, y = normalizedAPPL, group = 1), colour = "blue") 
      }
    p
  })
  

})
