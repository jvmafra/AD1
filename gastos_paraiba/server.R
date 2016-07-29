#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
theme_set(theme_bw())
setwd("~/Documentos/AD1")


ler_gastos <- function(arquivo = "dados/ano-atual.csv"){
  
  require("dplyr", warn.conflicts = FALSE)
  
  gastos = read.csv(arquivo, stringsAsFactors = FALSE, encoding='UTF-8')
  gastos = gastos %>% 
    mutate_each(funs(as.factor), sgPartido, sgUF, txNomeParlamentar, indTipoDocumento)
  return(gastos)
}

gastos <- ler_gastos()


gastos <- gastos %>% select (1,2, 5, 6, 15, 23)

names(gastos) <- c("Partido", "Mes", "Nome", "UF", "Tipo", "Valor")

gastos_pb <- gastos %>% filter (UF == "PB")
gastos_pb <- gastos_pb %>% filter (Mes != 7)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$plotMes <- renderPlot({
    gastos_pb <- gastos_pb %>% filter (Mes == input$mes)
    
    agrupa_nome <- gastos_pb %>% 
      group_by(Nome, Partido) %>% 
      summarise(total_gasto = sum(Valor))
    
    ggplot(agrupa_nome, aes(x = reorder(Nome, total_gasto),  
                            y = total_gasto,  
                            fill = Partido)) + 
      geom_bar(stat = "summary", fun.y = "mean") + coord_flip() + 
      xlab("Nome do deputado") +
      ylab("Valor gasto")
    
  })
  
})
