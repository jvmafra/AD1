

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

movies_genres = ler_dados("movies-genre.csv")

um_genero = movies %>% filter(num_genres == 1)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    
    if (input$escolha == "Ano"){
      
      year1 = input$range[1]
      year2 = input$range[2]
      
      filtrado = movies %>% filter(ano >= year1 & ano <= year2)
      escala = c(3.2, 3.8)
      
      if (input$genero_ano != "Todos"){
        filtrado = movies_genres %>% filter (genre == input$genero_ano)
        filtrado = filtrado %>% filter(ano >= year1 & ano <= year2)
        escala = c(2.75, 4)
      }
      if (nrow(filtrado) == 0 || nrow(filtrado) == 1){
        validate("Não existem filmes dentro dos critérios selecionados")
      }
      
      periodo = paste(year1, "a", year2, "- Gênero:", input$genero_ano)
      
      b = bootstrap(filtrado, mean(rating), R = 100)
      mean.filme = CI.bca(b, probs = c(.025, .975))
      df = data.frame(rbind(mean.filme))
      
      df$periodo = "Intervalo de lançamento dos filmes."
      
      df %>% 
        ggplot(aes(x = periodo, ymin = X2.5., ymax = X97.5.)) + 
        geom_errorbar(width = .2) + xlab(periodo) +
        ggtitle("Intervalo de confiança para o rating médio dos filmes de determinado período.") +
        ylab("Rating médio") + 
        scale_y_continuous(limits = escala)
      
    } else if (input$escolha == "Gênero (Rating médio)"){
      if (input$genero == "Todos"){
        selecionados = movies
      } else {
        selecionados = movies_genres %>% filter(genre == input$genero)
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
        
      
    } else if (input$escolha == "Gênero (Popularidade)"){
      if (input$genero == "Todos"){
        selecionados_popularity = movies
      } else {
        selecionados_popularity = movies_genres %>% filter(genre == input$genero)
      }
      
      b = bootstrap(selecionados_popularity, median(popularity), R = 100)
      median.filme.popularity = CI.percentile(b, probs = c(.025, .975))
      df3 = data.frame(rbind(median.filme.popularity))
      
      df3$title = row.names(df3)
      df3[1,3] = "Gênero do filme."
      
      
      df3 %>% 
        ggplot(aes(x = title, ymin = X2.5., ymax = X97.5.)) + 
        geom_errorbar(width = .2) + xlab(input$genero) + 
        ggtitle("Intervalo de confiança para mediana da popularidade dos filmes de determinado gênero.")+
        ylab("Mediana da popularidade")+ scale_y_continuous(limits = c(200, 1400))
      
      
    } else {
      filtrado1 = movies_genres %>% filter (genre == input$genero_comp1)
      filtrado1 = filtrado1 %>% filter(ano >= input$range_comp1[1] & ano <= input$range_comp1[2])
      
      filtrado2 = movies_genres %>% filter (genre == input$genero_comp2)
      filtrado2 = filtrado2 %>% filter(ano >= input$range_comp2[1] & ano <= input$range_comp2[2])
      
      escala = c(2.75, 4)
      
      if ((nrow(filtrado1) == 0 || nrow(filtrado1) == 1) && (nrow(filtrado2) == 1 || nrow(filtrado2) == 0)){
        validate("Impossível fazer comparação. Não existem filmes dentro dos critérios selecionados.")
      }
      
      b1 = bootstrap(filtrado1, mean(rating), R = 100)
      mean.filme1 = CI.bca(b1, probs = c(.025, .975))
      
      b2 = bootstrap(filtrado2, mean(rating), R = 100)
      mean.filme2 = CI.bca(b2, probs = c(.025, .975))
      
      
      
      df_comp = data.frame(rbind(mean.filme1, mean.filme2))
      
      df_comp$title = row.names(df_comp)
      
      df_comp[1,3] = paste(input$genero_comp1, "-", input$range_comp1[1], "a", input$range_comp1[2])
      df_comp[2,3] = paste(input$genero_comp2, "-", input$range_comp2[1], "a", input$range_comp2[2])
      
      df_comp %>% 
        ggplot(aes(x = title, ymin = X2.5., ymax = X97.5.)) + 
        geom_errorbar(width = .2) + xlab("Gênero") + ylab("Intervalo de confiança para Rating médio (95% de confiança)") +
        scale_y_continuous(limits = c(2.75, 4.2))
      
      
    }
    
    
  })
  
})
