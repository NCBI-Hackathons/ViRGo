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
      selectizeInput(inputId = "Organism", label ="Organism", choices = unique(data$Organism), selected = unique(data$Organism), multiple = TRUE, options = NULL),
      selectizeInput(inputId = "OrganismPart", label ="Organism Part", choices = unique(data$OrganismPart), selected = unique(data$OrganismPart), multiple = TRUE, options = NULL),
      selectizeInput(inputId = "Individual", label ="Individual", choices = unique(data$Individual), selected = unique(data$Individual), multiple = TRUE, options = NULL),
      selectizeInput(inputId = "Quality", label ="Quality", choices = unique(data$Quality), selected = unique(data$Quality), multiple = TRUE, options = NULL),
      selectizeInput(inputId = "Cell", label ="Cell", choices = unique(data$Cell), selected = unique(data$Cell), multiple = TRUE, options = NULL),
      selectizeInput(inputId = "Sex", label ="Sex", choices = unique(data$Sex), selected = unique(data$Sex), multiple = TRUE, options = NULL),
      selectizeInput(inputId = "Disease", label ="Disease", choices = unique(data$Disease), selected = unique(data$Disease), multiple = TRUE, options = NULL),
      radioButtons(inputId = "Fill",
         label = "Fill by:",
         choices = colnames(data)[-which(colnames(data) %in% c("Heterozygous.SNP","Homozygous.SNP"))],
         selected = "Disease")
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      plotlyOutput("homoBarPlot"),
      plotlyOutput("heteroBarPlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Return the requested column ----
  
  output$homoBarPlot <- renderPlotly({
    data2 <- data %>% filter(Organism %in% as.character(input$Organism) & 
             OrganismPart %in% as.character(input$OrganismPart) &
             Individual %in% as.character(input$Individual) & 
             Quality %in% as.character(input$Quality) & 
             Cell %in% as.character(input$Cell) & 
             Sex %in% as.character(input$Sex) &
             Disease %in% as.character(input$Disease)) %>% select(-Heterozygous.SNP)
    data3 <- separate_rows(data2, Homozygous.SNP) %>% filter(Homozygous.SNP!="")
    p <- ggplot(data3, aes(Homozygous.SNP)) + geom_bar(aes_string(fill=input$Fill))
    py <- ggplotly(p)
    py
  })
  
  output$heteroBarPlot <- renderPlotly({
    data2 <- data %>% filter(Organism %in% as.character(input$Organism) &
             OrganismPart %in% as.character(input$OrganismPart) &
             Individual %in% as.character(input$Individual) &
             Quality %in% as.character(input$Quality) &
             Cell %in% as.character(input$Cell) &
             Sex %in% as.character(input$Sex) &
             Disease %in% as.character(input$Disease)) %>% select(-Homozygous.SNP)
    data3 <- separate_rows(data2, Heterozygous.SNP) %>% filter(Heterozygous.SNP!="")
    p <- ggplot(data3, aes(Heterozygous.SNP)) + geom_bar(aes_string(fill=input$Fill))
    py <- ggplotly(p)
    py
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)