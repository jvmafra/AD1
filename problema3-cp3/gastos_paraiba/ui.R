library(shiny)

lista = c("")

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Gastos dos deputados paraibanos em 2016"),
  
  helpText("Nota: Quando algum deputado está selecionado, o filtro do mês torna-se irrelevante,
           tendo em vista que já está sendo mostrada a evolução dos gastos daquele deputado mês
           a mês"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("mes", 
                  label = "Escolha um mês",
                  list("Janeiro", "Fevereiro",
                              "Março", "Abril", "Maio", "Todos"),
                  selected = "Janeiro",
                  inline = FALSE, width = '400px'),
      selectInput("tipo",
                  label = "Tipo de gasto",
                  choices = c("ASSINATURA DE PUBLICAÇÕES","COMBUSTÍVEIS E LUBRIFICANTES.",
                              "CONSULTORIAS, PESQUISAS E TRABALHOS TÉCNICOS.",
                              "DIVULGAÇÃO DA ATIVIDADE PARLAMENTAR.", "FORNECIMENTO DE ALIMENTAÇÃO DO PARLAMENTAR",
                              "HOSPEDAGEM ,EXCETO DO PARLAMENTAR NO DISTRITO FEDERAL", "LOCAÇÃO OU FRETAMENTO DE VEÍCULOS AUTOMOTORES",
                              "MANUTENÇÃO DE ESCRITÓRIO DE APOIO À ATIVIDADE PARLAMENTAR",
                              "PASSAGENS AÉREAS",
                              "SERVIÇO DE SEGURANÇA PRESTADO POR EMPRESA ESPECIALIZADA.", "SERVIÇO DE TÁXI, PEDÁGIO E ESTACIONAMENTO",
                              "SERVIÇOS POSTAIS","TELEFONIA","TODOS"),
                  selected = "TODOS"),
      selectInput("deputado", 
                  label = "Evolução dos gastos por deputado",
                  choices = c("AGUINALDO RIBEIRO", "BENJAMIN MARANHÃO", "DAMIÃO FELICIANO",
                              "EFRAIM FILHO", "HUGO MOTTA", "LUIZ COUTO", "MANOEL JUNIOR",
                              "MARCONDES GADELHA", "PEDRO CUNHA LIMA", "RÔMULO GOUVEIA",
                              "VENEZIANO VITAL DO RÊGO", "WELLINGTON ROBERTO", "WILSON FILHO",
                              "TODOS"),
                  selected = "TODOS")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plotMes", height = "550px")
    )
  )
))