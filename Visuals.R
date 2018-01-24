# Load packages
library(shiny)
library(plotly)
library(tidyr)
library(ggplot2)
library(dplyr)

# Load data
data <- readRDS("m1_sub.Rds")
data_table <- data
# processing datatable data
for (i in 1:length(data_table$Heterozygous.SNP)){
  if(length(data_table$Heterozygous.SNP[[i]][[1]]) == 0){
    data_table$Heterozygous.SNP[[i]][[1]] = 'NA'
  } else if(length(data_table$Heterozygous.SNP[[i]][[1]]) != 0) {
    for (j in 1:length(data_table$Heterozygous.SNP[[i]][[1]])){
      data_table$Heterozygous.SNP[[i]][[1]][j] = paste0('<a href=\"https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=',data_table$Heterozygous.SNP[[i]][[1]][j],'\">',data$Heterozygous.SNP[[i]][[1]][j],'</a>')
    }
  }
  if(length(data_table$Homozygous.SNP[[i]][[1]]) == 0){
    data_table$Homozygous.SNP[[i]][[1]] = 'NA'
  } else if(length(data_table$Homozygous.SNP[[i]][[1]]) != 0) {
    for (j in 1:length(data_table$Homozygous.SNP[[i]][[1]])){
      data_table$Homozygous.SNP[[i]][[1]][j] = paste0('<a href=\"https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=',data_table$Homozygous.SNP[[i]][[1]][j],'\">',data$Homozygous.SNP[[i]][[1]][j],'</a>')
    }
  }

  data_table$Heterozygous.SNP[i] = paste(unlist(data_table$Heterozygous.SNP[i][1]), collapse=',')
  data_table$Homozygous.SNP[i] = paste(unlist(data_table$Homozygous.SNP[i][1]), collapse=',')

}
data_table$Heterozygous.SNP = unlist(data_table$Heterozygous.SNP)
data_table$Homozygous.SNP = unlist(data_table$Homozygous.SNP)

# Define UI
ui <- fluidPage(
  # App title
  tags$h1("SCRVV", align="center"),
  # Banner links to our github repo
  tags$div(
    HTML(paste('<a href="https://github.com/NCBI-Hackathons/SCRVV/">',
                 '<img style="position: absolute; top: 0; right: 0; border: 0;"',
                   'src="https://camo.githubusercontent.com/365986a132ccd6a44c23a9169022c0b5c890c387/',
                      '68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e73',
                      '2f666f726b6d655f72696768745f7265645f6161303030302e706e67" ',
                   'alt="Fork me on GitHub" data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png">',
               '</a>',sep=""))
  ),
  tags$head(tags$style(type="text/css", "
             #loadmessage {
               position:relative;
               top: 100px;
               left: 0px;
               width: 100%;
               padding: 5px 0px 5px 0px;
               text-align: center;
               font-size: 100%;
               color: #000000;
               background-color: #CCFF66;
               z-index: 105;
             }
          ")),
  conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                   tags$div("Loading...",id="loadmessage")),
  mainPanel(
    tabsetPanel(type = "tabs", id="tabs",
                tabPanel("All Columns", value=1,
                         verbatimTextOutput("all_columns")),
                tabPanel("Summary", value=2,
                  sidebarPanel(uiOutput("sidebar_summary")),
                  verbatimTextOutput("summary")),
                tabPanel("Unique", value=3,
                  sidebarPanel(uiOutput("sidebar_unique")),
                  verbatimTextOutput("unique")),
                tabPanel("Lutter", value=4,
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
                  plotlyOutput("homoBarPlot"),
                  plotlyOutput("heteroBarPlot")
                ),
                tabPanel("Raw", value=5,
                  verbatimTextOutput("Raw"),
                  DT::dataTableOutput('ex1'))
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$all_columns <- renderPrint({
    if (input$tabs == 1){
      for (i in 1:11) {
        cat(colnames(data)[i], "\n")
      }
    }
  })

  output$sidebar_summary <- renderUI({
    if (input$tabs == 2){
      radioButtons(inputId = "column",
                   label = "Choose a column:",
                   choices = colnames(data)[1:9])
    }
  })

  output$summary <- renderPrint({
    summary(data[input$column])
  })

  output$sidebar_unique <- renderUI({
    if(input$tabs == 3){
      radioButtons(inputId = "column2",
                   label = "Choose a column:",
                   choices = colnames(data))
    }
  })

  output$unique <- renderPrint({
    unique(data[input$column2])
  })

  output$homoBarPlot <- renderPlotly({
    if (input$tabs == 4){
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
    }
  })

  output$heteroBarPlot <- renderPlotly({
    if (input$tabs == 4) {
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
    }
  })

  output$Raw <- renderPrint({
    if(input$tabs == 5){
      
      output$ex1 <- DT::renderDataTable(DT::datatable(data_table, filter = 'top',escape = FALSE, options = list(pageLength = 10, scrollX='500px',autoWidth = TRUE)))
    }
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)