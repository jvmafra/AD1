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
  titlePanel("Análise sobre a avaliação de filmes por parte da audiência"),
  
  p("O objetivo da visualização é analisar como os filmes dos mais variados gêneros são avaliados pelas
    pessoas que os assistiram."),
  
  h3("Perguntas e ferramentas utilizadas para respondê-las:"),
  
  h4("PERGUNTAS:"),
  p("PERGUNTA 1: Existe alguma relação entre o ano de lançamento do filme e a sua avaliação por
    parte das pessoas? Filmes mais antigos são melhores avaliados?"),
  p("PERGUNTA DERIVADA: É possível dizer que filmes de determinado gênero foram 'evoluindo' ou 
    'regredindo' ao longo do tempo?"),
  p("PERGUNTA 2: Existe alguma relação entre o gênero do filme e a sua avaliação por
    parte das pessoas? Filmes de um gênero são melhores avaliados do que o de outros?"),
  p("PERGUNTA DERIVADA: Os gêneros melhores avaliados pelas pessoas são os mais populares?"),
  h4("FERRAMENTAS:"),
  
  h3("ANÁLISE: "),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("escolha", 
                   label = "Escolha a perspectiva",
                   list("Ano", "Gênero (Rating médio)", "Gênero (Popularidade)"),
                   selected = "Ano",
                   inline = FALSE, width = '400px'),
      conditionalPanel(condition = "input.escolha == 'Ano'",
                       sliderInput("range",
                                    "Intervalo de anos:",
                                    min = 1902,
                                    max = 2016,
                                    value = c(1902, 2016)),
                       
                       selectInput("genero_ano", label = "Selecione um gênero",
                                   choices = c("Todos", "Action", "Comedy", "Drama", "Crime", "Documentary", "Horror",
                                               "Musical", "Romance", "Sci-Fi", "Thriller"),
                                   selected = "Todos")),
      
      
      conditionalPanel(condition = "input.escolha != 'Ano'",
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
