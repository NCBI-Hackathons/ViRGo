# Load packages
library(shiny)
library(tidyr)
library(dplyr)

# Load data
data_table <- data.frame(Variable1 = sample(LETTERS, 1000, replace=TRUE), Variable2 = sample(c("Orange","Green","Blue","Pink"), 1000, replace=TRUE), Variable3 = sample(c("Square","Triangle","Circle"), 10000, replace=TRUE))

# Define UI
ui <- fluidPage(
  tabsetPanel(type = "tabs", id="tabs",
    tabPanel("Column Summary", value=2,
       sidebarPanel(uiOutput("sidebar_summary")),
       verbatimTextOutput("summary")),
    tabPanel("See Whole Data Table", value=5,
       downloadButton('downLoadFilter',"Download the filtered data"),
       verbatimTextOutput("Raw"),
       DT::dataTableOutput('ex1'))
  )
)

# Define server logic
server <- function(input, output) {
  
  output$sidebar_summary <- renderUI({
    if (input$tabs == 2){
    print("This is a tab with information.")
    }
  })
  
  thedata <- reactive(data_table)
  
  output$Raw <- renderPrint({
    if(input$tabs == 5){
      output$ex1 <- DT::renderDataTable(DT::datatable(thedata(), filter = 'top',escape = FALSE, options = list(pageLength = 10, scrollX='500px',autoWidth = TRUE)))
    }
  })
  
  output$downLoadFilter <- downloadHandler(
    filename = function() {
      paste('Filtered data-', Sys.Date(), '.csv', sep = '')
    },
    content = function(file){
      write.csv(thedata()[input[["ex1_rows_all"]], ],file)
    }
  )
}

# Create Shiny object
shinyApp(ui = ui, server = server)