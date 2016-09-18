#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Análise sobre filmes"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("escolha", 
                   label = "Escolha a perspectiva",
                   list("Ano", "Genero"),
                   selected = "Ano",
                   inline = FALSE, width = '400px'),
      conditionalPanel(condition = "input.escolha == 'Ano'",
                       sliderInput("range",
                                    "Intervalo de anos:",
                                    min = 1902,
                                    max = 2016,
                                    value = c(1902, 2016))),
      
      
      conditionalPanel(condition = "input.escolha == 'Genero'",
                       selectInput("genero", label = "Selecione um gênero",
                                   choices = c("Todos", "Action", "Comedy", "Drama", "Crime", "Documentary", "Horror",
                                               "Musical", "Romance", "Sci-Fi", "Thriller"),
                                   selected = "Todos"
                       ))
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       plotOutput("generoPlot")
    )
  )
))
