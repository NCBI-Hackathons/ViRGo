# Load packages
library(shiny)

# Load data
data <- data.frame(letters = factor(sample(LETTERS, 200, replace=TRUE)))

# Define UI
ui <- fluidPage(
sidebarPanel(
  radioButtons(inputId = "column", label = "Choose a summary column:", choices = colnames(data)),
  radioButtons(inputId = "column2", label = "Choose a unique column:", choices = colnames(data))
),
mainPanel(
  verbatimTextOutput("summary"),
  verbatimTextOutput("unique")
)
)


# Define server logic
server <- function(input, output) {

  output$summary <- renderPrint({
    df <- as.data.frame(summary(data[[input$column]], maxsum = nlevels(data[[input$column]])))
    `names<-`(df, input$column)
  })
  
  output$unique <- renderPrint({
    unique(data[input$column2])
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)
