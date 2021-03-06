
library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
library(plotly)
theme_set(theme_bw())


ler_gastos <- function(arquivo){
  gastos = read.csv(arquivo, stringsAsFactors = FALSE, encoding='UTF-8')
  require("dplyr", warn.conflicts = FALSE)
  return(gastos)
}

gastos <- ler_gastos("ano-atual.csv")
gastos = gastos %>% 
  mutate_each(funs(as.factor), sgPartido, sgUF, txNomeParlamentar, indTipoDocumento)

gastos[gastos$txtDescricao == "Emissão Bilhete Aéreo", "txtDescricao"] = "PASSAGENS AÉREAS"

posicao <- ler_gastos("posicao.csv")

gastos <- merge(gastos, posicao)

gastos <- gastos %>% select (1,2, 5, 6, 15, 23, 30)

names(gastos) <- c("Partido", "Mes", "Nome", "UF", "Tipo", "Valor", "Ideologia_Partidaria")

gastos_pb <- gastos %>% filter (UF == "PB")
gastos_pb <- gastos_pb %>% filter (Mes != 7)
gastos_pb <- gastos_pb %>% filter (Mes != 6)


teste <- gastos_pb %>% group_by(Tipo) %>% summarise(valor = sum(Valor))


meses <- list("Janeiro" = 1,"Fevereiro" = 2, "Março" = 3, "Abril" = 4, "Maio" = 5)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$plotMes <- renderPlot({
    if (input$tipo != "TODOS"){
      gastos_pb <- gastos_pb %>% filter (Tipo == input$tipo)
      nome.tipo = input$tipo
      if (input$tipo == "DIVULGAÇÃO DA ATIVIDADE PARLAMENTAR."){
        if (input$mes == "Todos") escala <- c(0, 150000)
        else escala <- c(0, 60000)
      } 
      else escala <- c(0, 60000)
      
      
      tipo_gasto = TRUE
      
    } else {
      nome.tipo = "todos os tipos de despesas."
      tipo_gasto = FALSE
    }
    
    if (input$deputado == "TODOS"){
      if (input$mes != "Todos"){
        gastos_pb <- gastos_pb %>% filter (Mes == meses[input$mes])
        if (tipo_gasto == FALSE) escala <- c(0, 70000)
        
        nome.mes <- input$mes
      } else {
        if (tipo_gasto == FALSE) escala <- c(0, 250000)
        nome.mes <- "Janeiro a Maio"
      }
      
      agrupa_nome <- gastos_pb %>% 
        group_by(Nome, Ideologia_Partidaria, Partido) %>% 
        summarise(total_gasto = sum(Valor))
      
      if (nrow(agrupa_nome) == 0){
        validate("Não existem deputados com esse tipo de gasto no mês selecionado")
      } else {
        ggplot(agrupa_nome, aes(x = reorder(paste(Nome, "-", Partido), total_gasto),  
                                y = total_gasto,  
                                fill = Ideologia_Partidaria)) +
          ggtitle(sprintf("Gastos dos deputados (%s) com %s", nome.mes, nome.tipo)) +
          geom_bar(stat = "summary", fun.y = "mean") + 
          geom_label(aes(label = paste("R$",as.integer(total_gasto))), hjust=0.3, vjust=0.5, fontface = "bold", size = 4, show.legend = FALSE) +
          scale_y_continuous(limits = escala) +
          coord_flip() + 
          xlab("Nome do deputado") +
          ylab("Valor gasto") +
          labs(fill = "Ideologia partidária")
        
        
        
      }
        
      
     
      
    } else {
      gastos_deputado <- gastos_pb %>% filter(Nome == input$deputado)
      agrupa_mes <- gastos_deputado %>% group_by(Mes) %>% summarise(valor = sum(Valor))
      
      if (nrow(agrupa_mes) == 0) {
        validate("Esse deputado não possui gastos com esse tipo de despesa.")
      } else {
        ggplot(agrupa_mes, aes(x = Mes, y = valor, group = 1)) +
          ggtitle(sprintf("Gastos (Janeiro a Maio) de %s com %s", input$deputado, nome.tipo)) +
          geom_line(colour = "dodgerblue4", alpha=.7) +
          geom_point(colour = "deepskyblue3", size = 3) +
          geom_label(aes(label = paste("R$", as.integer(valor))), hjust=0.5, vjust=-1, fontface = "bold", colour = "dodgerblue3", size = 4, show.legend = FALSE) +
          xlab("Mês do ano") +
          ylab("Valor gasto (em reais)") +
          scale_x_continuous(limits = c(1,5)) +
          scale_y_continuous(limits = c(0, 70000))
      }

      
      

    }
    
    
  })
  
})
