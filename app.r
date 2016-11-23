###app.R


library(shiny)
library(ggplot2)
#options(rsconnect.locale = 'fi')


source("helpers.R")
runners <- readRDS("data/runnersa.rds")

### Init variables, which will be static
x1 <- runners$aika15
y1 <- runners$aika16
p <- ggplot(runners, aes(x=x1,y=y1))
p <- p + geom_abline()

d <- ggplot(runners)
d15 <- geom_density(aes(x1), colour="blue")
d16 <- geom_density(aes(y1), colour="red")


#### Server side of shiny app ####
server <- shinyServer(function(input, output) {
  
  output$text <- renderText({
    paste("juoksija", input$select)
  })
  
  
  #### Plot tab ####
  output$runnersPl <- renderPlot({
    p <- p + geom_point(colour = ifelse(runners$name == input$select, "blue", 
                                        ifelse(x1 > y1, "red", "green")))
    p + labs(x = "Ajat 15 (h)", y = "Ajat 16 (h)")
  })
  
  output$selite <- renderText({
    paste("Ajat punaisella parempia vuonna 16 kuin 15")
  })
  
  #### Density tab ####
  output$density <- renderPlot({
    d + d15 + d16 + labs(x="Aika (h)", y = "tiheys")
  })
  
  #### Data tab ####
  output$dataTable <- renderDataTable({
    runners
  })
  
  #### Summary tab ####
  output$sumTable <- renderTable({
    summaryTable(runners)
  },rownames = TRUE)
  
  output$relTimeDifMed <- renderText({
    medS <- round(median(runners$suhtTimeDif), 3)
    paste("Suhteellinen aika ero (mediaani):", medS, "eli
          ajat olivat", ((1- medS)*100), "% huonompia vuonna 2016.")
  })
  
  output$relTimeDifMean <- renderText({
    
    paste("Suhteellinen aika ero (keskiarvo):", round(mean(runners$suhtTimeDif),3))
  })
  
  #### Text outputs ####
  output$time15 <- renderText({
    paste("Aika 15: ", 
          hoursToTime(runners$aika15[runners$name==input$select]))
  })
  
  output$time16 <- renderText({
    paste("Aika 16: ", 
          hoursToTime(runners$aika16[runners$name==input$select]))
  })
  
  output$diff <- renderText({
    paste("Suht. aika 15/16: ", signif(runners$suhtTimeDif[runners$name==input$select],3))
  })
  
  output$table <- renderTable(orderTable(runners, input$order))

  })

library(shinythemes)

ui <- shinyUI(fluidPage(theme = shinytheme("superhero"),
                  
                  # Application title
                  titlePanel("Vaarojen maraton, 15 ja 16"),
                  
                  sidebarLayout(
                    sidebarPanel(
                      selectInput("select", label = ("Juoksijat"), 
                                  choices = runners$name),
                      h4(textOutput("time15")),
                      h4(textOutput("time16")),
                      h4(textOutput("diff")),
                      
                      selectInput("order", label=("Järjestys"),
                                  choices = list("aika 15", "aika 16", "sij 15", "sij 16",
                                                 "aika ero", "suht. aika ero", "adj. aika")),
                      
                      tableOutput("table")
                      
                    ),
                    
                    mainPanel(
                      #h3(textOutput("text")),
                      tabsetPanel(
                        #### chatter plot ####
                        tabPanel("Plot", plotOutput("runnersPl"),
                                 textOutput("selite")),
                        #### Density ####
                        tabPanel("density", plotOutput("density")),
                        #### Summary ####
                        tabPanel("Summary", tableOutput("sumTable"),
                                 textOutput("relTimeDifMed"),
                                 textOutput("relTimeDifMean")
                                 
                        ),
                        #### Data ####
                        tabPanel("Data", dataTableOutput("dataTable"))
                        
                        
                      )
                    )
                  )
                  
))

shinyApp(ui = ui, server = server)