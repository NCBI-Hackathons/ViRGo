# Load packages
library(shiny)
library(plotly)
library(tidyr)
library(ggplot2)
library(dplyr)

# Load data
data <- readRDS("data/merged_sub.Rds")
data_table <- data

# Check that input data frame fits the required format. If not, give user Error message and close app.
validate(
  need(all(c("Organism", "OrganismPart", "Individual", "Quality", "Cell", "Sex", "Disease", "Heterozygous.SNP", "Homozygous.SNP") %in% colnames(data_table)), "This Shiny application will not run because your inputted data frame does not contain the necessary column names. Your data frame should contain at least nine column names exactly as follows: 'Organism', 'OrganismPart', 'Individual', 'Quality', 'Cell', 'Sex', 'Disease', 'Heterozygous.SNP', 'Homozygous.SNP'")
)

data_table$Homozygous.SNP <- lapply(data_table$Homozygous.SNP, function(x){strsplit((as.character(x)), ";")})
data_table$Heterozygous.SNP <- lapply(data_table$Heterozygous.SNP, function(x){strsplit((as.character(x)), ";")})
# processing datatable data
for (i in 1:length(data_table$Heterozygous.SNP)){
  if(length(data_table$Heterozygous.SNP[[i]][[1]]) == 0){
    data_table$Heterozygous.SNP[[i]][[1]] = 'NA'
  } else if(length(data_table$Heterozygous.SNP[[i]][[1]]) != 0) {
    for (j in 1:length(data_table$Heterozygous.SNP[[i]][[1]])){
      data_table$Heterozygous.SNP[[i]][[1]][j] = paste0('<a href=\"https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=',data_table$Heterozygous.SNP[[i]][[1]][j],'\">',data_table$Heterozygous.SNP[[i]][[1]][j],'</a>')
    }
  }
  if(length(data_table$Homozygous.SNP[[i]][[1]]) == 0){
    data_table$Homozygous.SNP[[i]][[1]] = 'NA'
  } else if(length(data_table$Homozygous.SNP[[i]][[1]]) != 0) {
    for (j in 1:length(data_table$Homozygous.SNP[[i]][[1]])){
      data_table$Homozygous.SNP[[i]][[1]][j] = paste0('<a href=\"https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=',data_table$Homozygous.SNP[[i]][[1]][j],'\">',data_table$Homozygous.SNP[[i]][[1]][j],'</a>')
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
  tags$h1("ViRGo: Variant Report Generator", align="center"),
  tags$head(
    tags$style(HTML("hr {border-top: 1px solid #545050;}"))
  ),
  # Banner links to our github repo
  tags$div(
    HTML(paste('<a href="https://github.com/NCBI-Hackathons/ViRGo">',
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
  tabsetPanel(type = "tabs", id="tabs",
              tabPanel("Column Summary", value=2,
                       sidebarPanel(uiOutput("sidebar_summary")),
                       verbatimTextOutput("summary")),
              tabPanel("SNP Count Visualization", value=4,
                       sidebarPanel(
                         selectizeInput(inputId = "Organism", label ="Organism", choices = unique(data$Organism), selected = unique(data$Organism), multiple = TRUE, options = NULL),
                         selectizeInput(inputId = "OrganismPart", label ="Organism Part", choices = unique(data$OrganismPart), selected = unique(data$OrganismPart), multiple = TRUE, options = NULL),
                         selectizeInput(inputId = "Individual", label ="Individual", choices = unique(data$Individual), selected = unique(data$Individual), multiple = TRUE, options = NULL),
                         selectizeInput(inputId = "Quality", label ="Quality", choices = unique(data$Quality), selected = unique(data$Quality), multiple = TRUE, options = NULL),
                         selectizeInput(inputId = "Cell", label ="Cell", choices = unique(data$Cell), selected = unique(data$Cell), multiple = TRUE, options = NULL),
                         selectizeInput(inputId = "Sex", label ="Sex", choices = unique(data$Sex), selected = unique(data$Sex), multiple = TRUE, options = NULL),
                         selectizeInput(inputId = "Disease", label ="Disease", choices = unique(data$Disease), selected = unique(data$Disease), multiple = TRUE, options = NULL),
                         
                         hr(),
                         radioButtons(inputId = "Fill",
                                      label = "Fill by",
                                      choices = colnames(data)[-which(colnames(data) %in% c("Heterozygous.SNP","Homozygous.SNP"))],
                                      selected = "Disease") 
                       ),
                       mainPanel(
                         plotlyOutput("homoBarPlot"),
                         plotlyOutput("heteroBarPlot")
                       )
              ),
              tabPanel("See Whole Data Table", value=5,
                       br(),
                       downloadButton('downLoadFilter',"Download the filtered data"),
                       br(),
                       br(),
                       verbatimTextOutput("Raw"),
                       DT::dataTableOutput('ex1')),
              tabPanel("Download", value=6,
                       uiOutput("download")
              )
  )
  )

# Define server logic
server <- function(input, output) {
  
  Organism <- reactive({
    validate(
      need(input$Organism != "", 'Please choose at least value in the Organism field.')
    )
    input$Organism
  })
  
  OrganismPart <- reactive({
    validate(
      need(input$OrganismPart != "", 'Please choose at least one value in the OrganismPart field.')
    )
    input$OrganismPart
  })
  
  Individual <- reactive({
    validate(
      need(input$Individual != "", 'Please choose at least one value in the Individual field.')
    )
    input$Individual
  })
  
  Quality <- reactive({
    validate(
      need(input$Quality != "", 'Please choose at least one value in the Quality field.')
    )
    input$Quality
  })
  
  Cell <- reactive({
    validate(
      need(input$Cell != "", 'Please choose at least one value in the Cell field.')
    )
    input$Cell
  })
  
  Sex <- reactive({
    validate(
      need(input$Sex != "", 'Please choose at least one value in the Sex field.')
    )
    input$Sex
  })
  
  Disease <- reactive({
    validate(
      need(input$Disease != "", 'Please choose at least one value in the Disease field.')
    )
    input$Disease
  })
  
  # Validate data frame has rows
  data3homo <- reactive({
    data2 <- data %>% filter(Organism %in% as.character(Organism()) & 
                               OrganismPart %in% as.character(OrganismPart()) &
                               Individual %in% as.character(Individual()) & 
                               Quality %in% as.character(Quality()) & 
                               Cell %in% as.character(Cell()) & 
                               Sex %in% as.character(Sex()) &
                               Disease %in% as.character(Disease())) %>% select(-Heterozygous.SNP)
    validate(
      need(nrow(data2)>0, 'There are no Homozygous SNPs that meet the values in the selected fields.')
    )
    data3homo <- separate_rows(data2, Homozygous.SNP) %>% filter(Homozygous.SNP!="")
    validate(
      need(nrow(data3homo)>0, 'There are no Homozygous SNPs that meet the values in the selected fields.')
    )
    data3homo
  })
  
  data3hetero <- reactive({
    data2 <- data %>% filter(Organism %in% as.character(Organism()) & 
                               OrganismPart %in% as.character(OrganismPart()) &
                               Individual %in% as.character(Individual()) & 
                               Quality %in% as.character(Quality()) & 
                               Cell %in% as.character(Cell()) & 
                               Sex %in% as.character(Sex()) &
                               Disease %in% as.character(Disease())) %>% select(-Homozygous.SNP)
    validate(
      need(nrow(data2)>0, 'There are no Heterozygous SNPs that meet the values in the selected fields.')
    )
    data3hetero <- separate_rows(data2, Heterozygous.SNP) %>% filter(Heterozygous.SNP!="")
    validate(
      need(nrow(data3hetero)>0, 'There are no Heterozygous SNPs that meet the values in the selected fields.')
    )
    data3hetero
  })
  
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
                   choices = colnames(data))
    }
  })
  
  output$summary <- renderPrint({
    if (input$column %in% c("Homozygous.SNP","Heterozygous.SNP")){
      df <- as.data.frame(summary(data[[input$column]], maxsum = nlevels(data[[input$column]])))
      vec <- unlist(sapply(data[[input$column]], function(x) unlist(strsplit(as.character(x), ";"))))
      df2 <- as.data.frame(table(vec))
      colnames(df2) <- c("", input$column)
      df3 <- df2[order(df2[[input$column]], decreasing = TRUE),]
      colnames(df3) <- c(input$column, "NumOfRows")
      print(df3, row.names = FALSE)  
    }
    else{
      df <- as.data.frame(summary(data[[input$column]], maxsum = nlevels(data[[input$column]])))
      keepOrder = order(df[1], decreasing = TRUE)
      df2 <- as.data.frame(df[keepOrder,])
      df3 <- as.data.frame(df2[rowSums(df2 > 0) >= 1, ])
      df4 <- data.frame(col = rownames(df)[keepOrder][1:nrow(df3)], NumOfRows = df3[,1])
      print(`names<-`(df4, c(input$column, "NumOfRows")), row.names = FALSE)
    }
  })
  
  output$sidebar_unique <- renderUI({
    if(input$tabs == 3){
      radioButtons(inputId = "column2",
                   label = "Choose a column:",
                   choices = colnames(data))
    }
  })
  
  output$homoBarPlot <- renderPlotly({
    if (input$tabs == 4){
      p <- ggplot(data3homo(), aes(Homozygous.SNP)) + geom_bar(aes_string(fill=input$Fill))
      py <- ggplotly(p)
      py
    }
  })
  
  output$heteroBarPlot <- renderPlotly({
    if (input$tabs == 4) {
      p <- ggplot(data3hetero(), aes(Heterozygous.SNP)) + geom_bar(aes_string(fill=input$Fill))
      py <- ggplotly(p)
      py
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
      paste('ViRGo-Filtered', Sys.Date(), '.csv', sep = '')
    },
    content = function(file){
      write.csv(thedata()[input[["ex1_rows_all"]], ],file)
    }
  )
  
  output$download <- renderUI({
    if(input$tabs == 6){
      tags$div(tags$h1('Downloads'),
               tags$ul(
                 tags$li(
                   HTML('CSV file summarizes the single cell RNA-seq study of healthy and diabetes donors <a href="https://raw.githubusercontent.com/NCBI-Hackathons/ViRGo/master/diabetes.csv">Link</a>'))))
    }
  })
  
}

# Create Shiny object
shinyApp(ui = ui, server = server)