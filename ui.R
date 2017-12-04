# ui.R

library(shiny)

fluidPage(
  
  
  mainPanel(
    h3("Introduction:"),
    h5("This application predicts the next word of your phrase. Type a few words in the box below and hit submit to see the suggested next word."),
    
    textInput("Tcir",label=h3("Type your phrase here:")),
    submitButton('Submit'),
    h4('string you entered : '),
    verbatimTextOutput("inputValue"),
    h4('next word :'),
    verbatimTextOutput("prediction"),
    tags$button(
        id = 'close',
        type = "button",
        class = "btn action-button",
        onclick = "setTimeout(function(){window.close();},500);",  # close browser
        "Close window"
      )
  )
  
)