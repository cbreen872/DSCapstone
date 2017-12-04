# server.R

library(shiny)
library(NLP)
library(tm)
library(RWeka)
source("global.R")


shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$Tcir})
    output$prediction <- renderPrint({wordproc(input$Tcir)})  
  }
)