
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
options(rsconnect.locale = 'fi')


source("helpers.R")
runners <- readRDS("runnersa.rds")

x1 <- runners$aika15
y1 <- runners$aika16
p <- ggplot(runners, aes(x=x1,y=y1))
p <- p + geom_abline()
#p <- p + geom_point(colour = ifelse(runners$name == input$select, "blue", "green"))
d <- ggplot(runners)
d15 <- geom_density(aes(x1), colour="blue")
d16 <- geom_density(aes(y1), colour="red")

shinyServer(function(input, output) {
  
  
  
  
  #runner <- reactive(
     #input$select)
  
  #runner <- input$select
  
  
  output$text <- renderText({
    paste("juoksija", input$select)
  })

  output$runnersPl <- renderPlot({

    #p <- ggplot(runners, aes(x=x1, y=y1))
    p <- p + geom_point(colour = ifelse(runners$name == input$select, "blue", "green"))
    p + labs(x = "Ajat 15 (h)", y = "Ajat 16 (h)")
    
                                                    #            "yellow"))))#, 
         #col = ifelse( runners$name == input$select, "darkblue",
          #            "yellow"))

  })
  
  output$selite <- renderText({
    paste("Ajat viivan alla parempia vuonna 16 kuin 15")
  })
  
  output$density <- renderPlot({
    d + d15 + d16 + labs(x="Aika (h)", y = "tiheys")
  })
  
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
