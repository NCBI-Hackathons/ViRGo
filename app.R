# Load packages
library(shiny)

# Load data
data <- readRDS("m1_sub.Rds")

# Define UI
ui <- fluidPage(
  
  # App title ----
  titlePanel("Data Column Information"),
  
  # Sidebar layout with a input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for choosing column ----
      radioButtons(inputId = "column",
        label = "Choose a column:",
        choices = colnames(data))
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Verbatim text for data summary ----
      verbatimTextOutput("summary"),
      
      plotlyOutput("diseaseSNP")
      
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Return the requested column ----
  columnInput <- reactive({input$column})
  
  # Generate a summary of the column ----
  output$summary <- renderPrint({
    column <- columnInput()
    table(data[column])
  })
  
  output$diseaseSNP <- renderPlotly({
    
  })
  
}

# Create Shiny object
shinyApp(ui = ui, server = server)