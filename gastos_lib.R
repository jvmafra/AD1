
ler_gastos <- function(arquivo = "/dados/ano-atual.csv"){
  #' Lê um csv criado a partir dos dados de gastos dos deputados da 
  #' Câmara e seta os tipos de colunas mais convenientemente. 
  #' Versão sem readr, para máquinas onde não é possível instalar esse pacote. 
  #' É um pouco mais lenta que a com readr.
  require("dplyr", warn.conflicts = FALSE)
  
  gastos = read.csv(arquivo, stringsAsFactors = FALSE)
  gastos = gastos %>% 
    mutate_each(funs(as.factor), sgPartido, sgUF, txNomeParlamentar, indTipoDocumento)
  return(gastos)
}