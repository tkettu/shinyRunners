
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(shinythemes)
options(rsconnect.locale = 'en_US')

runners <- readRDS("runnersa.rds")

shinyUI(fluidPage(theme = shinytheme("superhero"),

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
        tabPanel("Plot", plotOutput("runnersPl"),
                          textOutput("selite")),
        tabPanel("density", plotOutput("density"))
     
      )
      
    )
  )
  
))
