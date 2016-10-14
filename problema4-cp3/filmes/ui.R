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
    pessoas que os assistiram. Como temos posse apenas de um amostra e nosso objetivo é concluir
    algo sobre a população, serão utilizados intervalos de confiança (Com nível de confiança de 95%) para o rating médio das
    avaliações e para mediana da popularidade de um filme. O primeiro trata de uma nota dada pelo
    usuário ao filme, que pode ir de 0 a 5. O segundo trata de quantas avaliações tal filme recebeu."),
  
  p("Para o rating, utilizou-se a estatística da média, enquanto que para popularidade utilizou-se
    a mediana, já que a média pode ser afetada por valores muito grandes ou muito pequenos."),
  
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
  p("Para responder a essas perguntas foram utilizados alguns filtros de dados."),
  h5("Perspectiva do ano:"),
  p("É possível observar o intervalo de confiança para a média das avaliações (de um gênero ou de todos) variando o intervalo
    de tempo"),
  h5("Perspectiva do gênero (Rating médio):"),
  p("É possível observar o intervalo de confiança para a média das avaliações (de um gênero ou de todos)"),
  
  h5("Perspectiva do gênero (Popularidade):"),
  p("É possível observar o intervalo de confiança para a mediana da popularidade de um gênero"),
  
  h5("Comparativo:"),
  p("É possível comparar o intervalo de confiança para a média das avaliações entre dois gêneros em um
    intervalo de tempo selecionado. Podemos comparar dois gêneros diferentes em um mesmo espaço de tempo para
    ver quem teve melhor avaliação e comparar dois gêneros iguais em intervalos de tempos diferentes, para
    concluir por exemplo que as comédias mais antigas era bem melhores avaliadas que as atuais."),
  
  h3("ANÁLISE:"),
  
  h4("PERGUNTA 1:"),
  p("Os dados mostram que filmes mais antigos são melhores avaliados pelas pessoas. A primeira perspectiva
    nos permite ver isso selecionando TODOS os gêneros e variando o intervalo de anos. À medida que aumentamos
    o range do ano o levando para anos mais recentes, podemos ver claramente a média diminuindo (no caso o seu intervalo)."),
  
  h4("DERIVADA:"),
  p("Ainda na perspectiva 1, podemos ver que sim. Se selecionarmos um gênero qualquer e formos variando
    o intervalo de tempo para anos mais recentes, vemos que a média vai diminuindo. Isso foi uma confirmação
    da resposta da primeira pergunta. Também podemos ver isso claramente sob a perspectiva do comparativo. Podemos
    selecionar um mesmo gênero em dois intervalos diferentes e comparar os intervalos de confiança."),
  
  h4("PERGUNTA 2:"),
  p("Sim, existe. Alguns gêneros são realmente melhores avaliados do que outros. Podemos ver isso
     na perspectiva 2, olhando para apenas um gênero ou no Comparativo. O gênero de Documentário, por exemplo, é melhor 
     avaliado que os demais, em geral."),
  
  h4("DERIVADA:"),
  p("Não. Os filmes de documentário são muito bem avaliados, mas possuem baixa popularidade. Os filmes
    de ação são bem populares, mas não são tão bem avaliados, por exemplo. Isso pode ser visto sob a perspectiva
    3, que constrói intervalos de confiança para mediana da popularidade dos filmes. A perspectiva 2
    olha para a nota média."),
  
  
  

  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("escolha", 
                   label = "Escolha a perspectiva",
                   list("Ano", "Gênero (Rating médio)", "Gênero (Popularidade)", "Comparativo"),
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
      
      
      conditionalPanel(condition = "input.escolha != 'Ano' && input.escolha != 'Comparativo'",
                       selectInput("genero", label = "Selecione um gênero",
                                   choices = c("Todos", "Action", "Comedy", "Drama", "Crime", "Documentary", "Horror",
                                               "Musical", "Romance", "Sci-Fi", "Thriller"),
                                   selected = "Todos"
                       )),
      
      
      conditionalPanel(condition = "input.escolha == 'Comparativo'",
                       selectInput("genero_comp1", label = "Selecione um gênero",
                                   choices = c("Action", "Comedy", "Drama", "Crime", "Documentary", "Horror",
                                               "Musical", "Romance", "Sci-Fi", "Thriller"),
                                   selected = "Action"
                       ),
                       
                       sliderInput("range_comp1",
                                   "Intervalo de anos:",
                                   min = 1902,
                                   max = 2016,
                                   value = c(1902, 2016)),
                       
                       selectInput("genero_comp2", label = "Selecione um gênero",
                                   choices = c("Action", "Comedy", "Drama", "Crime", "Documentary", "Horror",
                                               "Musical", "Romance", "Sci-Fi", "Thriller"),
                                   selected = "Comedy"
                       ),
                       sliderInput("range_comp2",
                                   "Intervalo de anos:",
                                   min = 1902,
                                   max = 2016,
                                   value = c(1902, 2016)))
                       
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       plotOutput("generoPlot")
    )
  )
))
