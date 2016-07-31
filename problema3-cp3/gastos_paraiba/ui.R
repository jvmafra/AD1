library(shiny)

lista = c("")

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Gastos dos deputados paraibanos em 2016"),
  
  # Sidebar with a slider input for number of bins 
  pageWithSidebar(
    sidebarPanel(
      radioButtons("mes", 
                  label = "Escolha um mês",
                  choices = c("Janeiro", "Fevereiro",
                              "Março", "Abril", "Maio", "Todos"),
                  selected = "Janeiro",
                  inline = TRUE, width = '400px')
    ),
    
    sidebarPanel(
      selectInput("deputado", 
                   label = "Escolha um deputado",
                   choices = c("AGUINALDO RIBEIRO", "BENJAMIN MARANHÃO", "DAMIÃO FELICIANO",
                               "EFRAIM FILHO", "HUGO MOTTA", "LUIZ COUTO", "MANOEL JUNIOR",
                               "MARCONDES GADELHA", "PEDRO CUNHA LIMA", "RÔMULO GOUVEIA",
                               "VENEZIANO VITAL DO RÊGO", "WELLINGTON ROBERTO", "WILSON FILHO",
                               "TODOS"),
                   selected = "TODOS")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plotMes")
    )
  )
))