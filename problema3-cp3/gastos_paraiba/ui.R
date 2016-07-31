library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Gastos dos deputados paraibanos"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("teste", 
                  label = "Escolha um mês",
                  choices = c("Janeiro", "Fevereiro",
                              "Março", "Abril", "Maio", "Todos"),
                  selected = "Janeiro")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plotMes")
    )
  )
))