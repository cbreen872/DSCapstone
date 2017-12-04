# server.R

library(ggplot2)
library(NLP)
library(tm)
library(RWeka)
library(data.table)
library(dplyr)
source("global.R")

shinyServer(
  function(input, output) {
    output$inputValue <- renderPrint({input$Tcir})
    output$prediction <- renderPrint({wordproc(input$Tcir)})
    observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
  }
)
    

options(shiny.sanitize.errors = FALSE)
