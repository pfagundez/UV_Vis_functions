# ============================================================================
# FUNCIONES PARA ANÁLISIS DE ESPECTROS UV-VISIBLE
# Autor: Pablo Fagúndez
# Fecha: 2025
# ============================================================================

# Función para encontrar máximos de absorbancia en espectros
encontrar_maximos <- function(datos, rango_min = NULL, rango_max = NULL) {
  
  # Primera columna = longitud de onda
  longitud_onda <- datos[, 1]
  
  # Resto de columnas = espectros
  espectros <- datos[, -1]
  
  # Filtrar por rango si se especifica
  if (!is.null(rango_min) || !is.null(rango_max)) {
    indices_rango <- rep(TRUE, length(longitud_onda))
    
    if (!is.null(rango_min)) {
      indices_rango <- indices_rango & (longitud_onda >= rango_min)
    }
    if (!is.null(rango_max)) {
      indices_rango <- indices_rango & (longitud_onda <= rango_max)
    }
    
    longitud_onda <- longitud_onda[indices_rango]
    espectros <- espectros[indices_rango, , drop = FALSE]
  }
  
  # Dataframe para resultados
  resultados <- data.frame(
    Espectro = character(),
    Longitud_Onda_Max = numeric(),
    Absorbancia_Max = numeric(),
    stringsAsFactors = FALSE
  )
  
  # Encontrar máximo para cada espectro
  for (i in 1:ncol(espectros)) {
    nombre_espectro <- colnames(espectros)[i]
    valores <- espectros[, i]
    
    # Índice del máximo
    indice_max <- which.max(valores)
    
    # Agregar a resultados
    resultados <- rbind(resultados, data.frame(
      Espectro = nombre_espectro,
      Longitud_Onda_Max = longitud_onda[indice_max],
      Absorbancia_Max = valores[indice_max]
    ))
  }
  
  return(resultados)
}

# ============================================================================

#Determinación de tamaño de AuNPs a partir de espectros
#Tomado de Haiss et al. 

#Se debe aplicar primero la función "encontrar_maximos", 
#para obtener los valores de absorbancia a las longitudes de onda máxima
#o deseada. 

diametro_Haiss <- function(A1sPR, A450) {
  # Valores constantes
  m <- 0.3335
  B0 <- 0.730
  B1 <- 1 / m   # ≈ 2.9985
  B2 <- B0 / m  # ≈ 2.1886
  exp(B1 * (A1sPR / A450) - B2)
}

#Función completa, a la que se le da un dataframe con espectros y devuelve los diámetros
calcular_diametro_Haiss <- function(datos) {
  # Definir rangos
  rangos_min <- c(400, 450)
  rangos_max <- c(1000, 450)
  
  # Aplicar función
  resultados <- Map(function(rmin, rmax) {
    resultado <- encontrar_maximos(datos, rango_min = rmin, rango_max = rmax)
    names(resultado) <- paste0(names(resultado), "_", rmin, "_", rmax)
    return(resultado)
  }, rangos_min, rangos_max)
  
  # Unir por columnas
  tabla_final <- do.call(cbind, resultados)
  
  # Si ya tienes tu tabla_final
  diametros <- mapply(diametro_Haiss, 
                      tabla_final[, 3],  # Columna 3 (A1sPR)
                      tabla_final[, 6])  # Columna 6 (A450)
  
  
  # Agregar a la tabla
  tabla_final_con_diametros <- cbind(tabla_final$Espectro_400_1000, diametros)
df.diametros <- as.data.frame.matrix(tabla_final_con_diametros)
df.diametros$diametros <- as.numeric(df.diametros$diametros)
  return(df.diametros)
  }


