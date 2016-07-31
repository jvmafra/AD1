
library(shiny)
library(dplyr, warn.conflicts = FALSE)
library(ggplot2)
theme_set(theme_bw())


ler_gastos <- function(arquivo){
  gastos = read.csv(arquivo, stringsAsFactors = FALSE, encoding='UTF-8')
  require("dplyr", warn.conflicts = FALSE)
  return(gastos)
}

gastos <- ler_gastos("../dados/ano-atual.csv")
gastos = gastos %>% 
  mutate_each(funs(as.factor), sgPartido, sgUF, txNomeParlamentar, indTipoDocumento)

posicao <- ler_gastos("../dados/posicao.csv")

gastos <- merge(gastos, posicao)

gastos <- gastos %>% select (1,2, 5, 6, 15, 23, 30)

names(gastos) <- c("Partido", "Mes", "Nome", "UF", "Tipo", "Valor", "Ideologia_Partidaria")

gastos_pb <- gastos %>% filter (UF == "PB")

meses <- list("Janeiro" = 1,"Fevereiro" = 2, "Março" = 3, "Abril" = 4, "Maio" = 5)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$plotMes <- renderPlot({
    if (input$teste != "Todos"){
      gastos_pb <- gastos_pb %>% filter (Mes == meses[input$teste])
      escala <- c(0, 70000)
    } else {
      escala <- c(0, 250000)
    }
    
    agrupa_nome <- gastos_pb %>% 
      group_by(Nome, Ideologia_Partidaria, Partido) %>% 
      summarise(total_gasto = sum(Valor))
    
    ggplot(agrupa_nome, aes(x = reorder(sprintf("%s - %s", Nome, Partido), total_gasto),  
                            y = total_gasto,  
                            fill = Ideologia_Partidaria)) + 
      geom_bar(stat = "summary", fun.y = "mean") + 
      scale_y_continuous(limits = escala) +
      coord_flip() + 
      xlab("Nome do deputado") +
      ylab("Valor gasto")
    
  })
  
})
