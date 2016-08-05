library(shiny)

lista = c("")

shinyUI(fluidPage(
  
  titlePanel("Gastos dos deputados paraibanos em 2016"),
  
  p("O objetivo da visualização é analisar como os deputados paraibanos
    gastam sua cota para exercício da atividade parlamentar."),
  h4("Filtros:"),
  p("É possível filtrar os gastos dos deputados pelo mês (Janeiro a Maio) e também pelo tipo
    de despesa. Além disso, podemos observar a evolução dos gastos de um deputado específico a cada
    mês. Note que quando um deputado específico está sendo observado, o filtro do mês torna-se
    irrelevante, já que está sendo mostrada a análise mês a mês."),
  
  h4 ("A análise:"),
  p("De uma forma simples podemos ver quais os deputados que mais gastaram em determinado mês
    e/ou com algum tipo de gasto. Chega a ser espantosa a quantidade de gastos com Divulgação da atividade
    parlamentar comparada a outros tipos de despesas. Nenhum deputado ultrapassou os R$ 60 mil em gastos
    com algum tipo de despesa em todo período observado, a não ser para o caso citado acima, o que comprova
    essa disparidade.
  "),
  
  p("Outro ponto importante observado é o pequeno gasto total do deputado Pedro Cunha Lima. Ele 
  se afastou do cargo no fim do ano passado para terminar o seu mestrado, o que explica esse pequeno valor gasto. 
  Seu substituto, Marcondes Gadelha, inclusive, é o segundo que menos gastou. Observando os dois
  deputados individualmente podemos ver que Marcondes possui gastos em Janeiro e Fevereiro, quando Pedro
  nada gastou. Em Março, ambos gastaram, apesar do valor de Pedro ter sido bem pequeno, o que pode ser
  explicado por um período de transição. Nos meses seguintes (Abril e Maio), Pedro possui gastos
  registrados e Marcondes não, indicando sua saída da câmara."),
  
  p("Outra observaçao interessante que pode ser vista com na análise individual dos deputados
    é o grande aumento dos gastos de Benjamin Maranhão no mês de maio. Ele apresenta até um média baixa
    nos outros meses e depois um aumento considerável de abril para maio. Observando o gráfico
    com os gastos de todos os deputados no mês de maio, Benjamin realmente é o 'vencedor' de gastos daquele
    mês."),

  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("mes", 
                  label = "Escolha um mês",
                  list("Janeiro", "Fevereiro",
                              "Março", "Abril", "Maio", "Todos"),
                  selected = "Todos",
                  inline = FALSE, width = '400px'),
      selectInput("tipo",
                  label = "Tipo de gasto",
                  choices = c("ASSINATURA DE PUBLICAÇÕES","COMBUSTÍVEIS E LUBRIFICANTES.",
                              "CONSULTORIAS, PESQUISAS E TRABALHOS TÉCNICOS.",
                              "DIVULGAÇÃO DA ATIVIDADE PARLAMENTAR.", "FORNECIMENTO DE ALIMENTAÇÃO DO PARLAMENTAR",
                              "HOSPEDAGEM ,EXCETO DO PARLAMENTAR NO DISTRITO FEDERAL.", "LOCAÇÃO OU FRETAMENTO DE VEÍCULOS AUTOMOTORES",
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