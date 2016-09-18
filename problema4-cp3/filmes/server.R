

library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(plotly)
library(resample)
theme_set(theme_bw())

ler_dados <- function(arquivo){
  dados = read.csv(arquivo, stringsAsFactors = FALSE, encoding='UTF-8')
  require("dplyr", warn.conflicts = FALSE)
  return(dados)
}

substrYear <- function(titulo){
  substr(titulo, nchar(titulo)-4, nchar(titulo)-1)
}

l2w_genres = function(line){
  resposta = rep(line, times = l)
  g = data.frame(genre = unlist(strsplit(line$genres, '[|]')))
  g$title = line$title
  return(full_join(as.data.frame(line), g))
}

movies <- ler_dados("ratings-por-filme.csv")

all_movies <- ler_dados("movies.csv")


movies =  movies %>%
  rowwise() %>%
  mutate(num_genres = length(unlist(strsplit(genres, '[|]'))))

movies =  movies %>%
  rowwise() %>%
  mutate(ano = substrYear(title))

movies = movies %>% filter(title != "Big Bang Theory, The (2007-)")
movies = movies %>% filter (title != "Justice League: Doom (2012) ")
movies = movies %>% filter(title != "Babylon 5")

movies = transform(movies, ano = as.numeric(ano))

um_genero = movies %>% filter(num_genres == 1)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    if (input$escolha == "Ano"){
      
      year1 = input$range[1]
      year2 = input$range[2]
      
      filtrado = movies %>% filter(ano >= year1 & ano <= year2)
      
      periodo = paste(year1, "a", year2)
      
      print(nrow(filtrado))
      
      b = bootstrap(filtrado, mean(rating), R = 100)
      mean.filme = CI.bca(b, probs = c(.025, .975))
      df = data.frame(rbind(mean.filme))
      
      df$periodo = "Intervalo de lançamento dos filmes."
      
      df %>% 
        ggplot(aes(x = periodo, ymin = X2.5., ymax = X97.5.)) + 
        geom_errorbar(width = .2) + xlab(periodo) +
        ggtitle("Intervalo de confiança para o rating médio dos filmes de determinado período.") +
        ylab("Rating médio") + 
        scale_y_continuous(limits = c(3.2,3.8))
      
    } else {
      if (input$genero == "Todos"){
        selecionados = um_genero
      } else {
        selecionados = um_genero %>% filter(genres == input$genero)
      }
      
      
      b = bootstrap(selecionados, mean(rating), R = 10)
      mean.filme.rating = CI.bca(b, probs = c(.025, .975))
      df2 = data.frame(rbind(mean.filme.rating))
      
      df2$title = row.names(df2)
      df2[1,3] = "Gênero do filme."
      
      
      df2 %>% 
        ggplot(aes(x = title, ymin = X2.5., ymax = X97.5.)) + 
        geom_errorbar(width = .2) + xlab(input$genero) + 
        ggtitle("Intervalo de confiança para o rating médio dos filmes de determinado gênero.")+
        ylab("Rating médio") + 
        scale_y_continuous(limits = c(2.6,3.8))
        
      
    }
    
    
  })
  
})
