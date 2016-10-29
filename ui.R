#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(rsconnect)

#setwd("/home/patrick/Documents/Coursera/Data Science Specialization/09_Developing Data Products/Course Projects/Course Project")

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Performance Microsoft Shares"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("stock", "Choose Share:", 
                  choices = c("Microsoft")),
      dateRangeInput('dateRange',
                     label = 'Select range within September', 
                     start = "2016-09-01", 
                     end = "2016-09-30",
                     min = "2016-09-01", 
                     max = "2016-09-30"
                     
      ),
       checkboxInput("showNasdaq", "Compare with Nasdaq (NDX)", TRUE),
       checkboxInput("showApple", "Compare with Apple (APPL)", TRUE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot"),
      htmlOutput("srvMSFTTitle"),
      verbatimTextOutput("srvMSFT"),
      htmlOutput("srvNDXTitle"),
      htmlOutput("srvNDX"),
      htmlOutput("srvAPPLTitle"),
      htmlOutput("srvAPPL")

       
    )
  )
))
