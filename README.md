# Análisis de Espectros UV-Vis

Este script carga funciones personalizadas, procesa datos espectroscópicos, encuentra máximos de absorbancia y calcula diámetros de nanopartículas usando la aproximación de Haiss.

## Código paso a paso

### 1. Cargar funciones personalizadas desde GitHub
```r
source("https://raw.githubusercontent.com/pfagundez/UV_Vis_functions/main/funciones_espectro.R")
```
- Importa funciones de análisis de espectros directamente del repositorio

### 2. Leer datos desde el portapapeles
```r
datos <- read.delim("clipboard", header = FALSE)
```
- **Formato requerido:**
  - Primera columna: Longitudes de onda
  - Columnas siguientes: Valores de absorbancia para cada espectro

### 3. Asignar nombres descriptivos a las columnas
```r
colnames(datos) <- c("longitud_onda", "1.5_1", "1.5_1*", "0.7_1", "0.7_1*", "0.5_1*", "0.3_1*")
```
- Estructura de nombres:
  - `longitud_onda`: Columna con valores de longitud de onda
  - Demás columnas: Identificadores de muestras (ej: concentración/replica)

### 4. Encontrar máximos de absorbancia en rango específico
```r
maximos <- encontrar_maximos(
  datos, 
  rango_min = 450, 
  rango_max = 450
)
```
- Busca picos de absorbancia en la región de 450 nm
- Ajustar `rango_min` y `rango_max` para diferentes regiones espectrales

### 5. Calcular diámetro de nanopartículas (aproximación de Haiss)
```r
haiss <- calcular_diametro_Haiss(datos)
```
- Aplica la relación matemática de Haiss para estimar tamaño de partículas
- Devuelve resultados en nanómetros (nm)

## Uso típico
1. Copiar datos espectroscópicos (longitud onda + absorbancia) al portapapeles
2. Ejecutar el script completo
3. Resultados disponibles en:
   - `maximos`: Posiciones de picos de absorbancia
   - `haiss`: Diámetros calculados para cada espectro

## Dependencias
- Funciones de `funciones_espectro.R` (cargadas automáticamente)
- Paquetes base de R (utils, stats)
