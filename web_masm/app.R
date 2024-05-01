#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)

archivos <- c("coeficientes_determinacion_correlacion_ajuste.xlsx",
              "ejercicios_estadistica.xlsx",
              "modelo_regresion_lineal_multiple.xlsx",
              "modelos_precision_intermedia.xlsx",
              "sars_cov_2.xlsm")

descripciones <- c("Esta hoja de cálculo obtiene los coeficientes de correlación y determinación de diferentes modelos de ajuste (lineal, logaritmo, inverso y cubico), selecciona el que mejor corresponde con una serie de datos, para ello utiliza la función condicional SI/IF.",
                   "En este libro se colocan una serie de ejercicios sobre estadística: tablas de análisis de varianza (tanto con valor P como con estadístico F), regresión lineal obtenida por mínimos cuadrados, pruebas de hipótesis con t de Student y chi cuadrada, distintas pruebas de normalidad e intervalos de confianza. Se utilizan funciones de Excel variadas, entre ellas: DISTR.F.CD, INV.F, SI, Y, DESVEST.M, INV.T, INV.NORM.ESTAND, DISTR.NORM.ESTAND y INV.CHICUAD.",
                   "En esta hoja de cálculo se muestra un caso de reducción de parámetros en dos modelos de regresión lineal múltiple, de esta manera se dejan solamente los términos significativos en el modelo y se evitan recolecciones de datos que no serían utilizados. Se utilizan las fórmulas ESTIMACION.LINEAL, SI, ABS, INV.T y DISTR.T.2C.",
                   "En este caso se presentan dos modelos para calcular la precisión intermedia entre dos analistas, un modelo completo y otro con un factor anidado, se presenta una tabla de análisis de varianza para cada caso (se desglosan las sumatorias previas). Se da uso al formato condicional para establecer una conclusión, y a las funciones DISTR.F.INV, SI/IF y de operaciones básicas.",
                   "Buscador de datos del informe 67 sobre COVID19 de la OMS, correspondiente al 27 de marzo de 2020. Ayuda a localizar de manera interactiva y sencilla datos específicos sobre la pandemia a la fecha indicada. Se utilizan las funciones INDICE, COINCIDIR y SI.ERROR. Además cuenta con un Audit Trail (generada con ayuda de una macroinstrucción) para rastrear fácilmente los cambios realizados en la hoja de datos.")

referencias <- c("Datos propios. No publicados",
                 "Datos de ejemplo. No publicados",
                 "Stavros N. Politis, Paolo Colombo, Gaia Colombo & Dimitrios M. Rekkas (2017) Design of experiments (DoE) in pharmaceutical development, Drug Development and Industrial Pharmacy, 43:6, 889-901, DOI: 10.1080/03639045.2017.1291672",
                 "Hernández V, Sánchez E. Introducción a la validación de métodos analíticos para el laboratorio farmacéutico de control de calidad. Universidad Nacional Autónoma De México. Ciudad de México, México. 2017. p.98",
                 "World Health Organization. (2020). Coronavirus disease 2019 (‎COVID-19)‎: situation report, 67. World Health Organization. https://iris.who.int/handle/10665/331613")


miniarchivos <- c("analisis_md.mpx",
                  "modelo_regresion_lineal_multiple.mpx",
                  "pi_experimental.mpx")

minidescripciones <- c("Se realizan histogramas de desviaciones cuadráticas medias y radios de giro obtenidos de una simulación de dinámica molecular (elaboración propia con Gromacs). Se utilizó la herramienta de elaboración de histogramas con ajuste y grupos presente en Minitab.",
                       "En esta hoja de cálculo se muestra un caso de reducción de parámetros en dos modelos de regresión lineal múltiple, de esta manera se dejan solamente los términos significativos en el modelo y se evitan recolecciones de datos que no serían utilizados. Se tiene el cálculo de Minitab para los valores de t de Student, se añade un diagrama de Pareto para observar gráficamente los factores estadísticamente significativos.",
                       "Este archivo contiene una serie de diagramas de caja y bigote correspondientes a un estudio de proliferación celular de dos analistas, el cual es de elaboración propia. Se utiliza la función de elaboración de diagramas de caja y bigote de Minitab.")

minireferencias <- c("Santander Martínez MA. Estudio in silico de bioisósteros de tipo antraciclina con potencial actividad anticancerígena. [Ciudad de México, México]: Universidad Nacional Autónoma de México; 2023.",
                     "Stavros N. Politis, Paolo Colombo, Gaia Colombo & Dimitrios M. Rekkas (2017) Design of experiments (DoE) in pharmaceutical development, Drug Development and Industrial Pharmacy, 43:6, 889-901, DOI: 10.1080/03639045.2017.1291672",
                     "Datos propios. No publicados")


ui <- fluidPage(class = "animated-background",
                
  tags$style(HTML("
                            .animated-background {
                              animation: gradientAnimation 10s ease infinite;
                              background: linear-gradient(to right, #daf5ef, #f5edda);
                              background-size: 200% 200%;
                            }
                            @keyframes gradientAnimation {
                              0% {
                                background-position: 0% 50%;
                              }
                              50% {
                                background-position: 100% 50%;
                              }
                              100% {
                                background-position: 0% 50%;
                              }
                             }
                            ")),

  tags$style(HTML("
                            .animated-radial {
                              animation: gradientAnimation 10s ease infinite;
                              background: radial-gradient(circle at center, #523f27, #f5edda);
                              background-size: 200% 200%;
                            }
                            
                            @keyframes gradientAnimation {
                            from { background-position: 0% 0%;
                            }
                              to { background-position: 100% 100%;
                              }
                            }
                            ")),
  

  tags$style(HTML("
                            .animated-frame {
                              animation: gradientAnimation 3s ease infinite;
                              background: linear-gradient(to right, #4B3621, #623307);
                              background-size: 200% 200%;
                              width: 410px;
                              height: 580px;
                            }
                            @keyframes gradientAnimation {
                              0% {
                                background-position: 0% 50%;
                              }
                              50% {
                                background-position: 100% 50%;
                              }
                              100% {
                                background-position: 0% 50%;
                              }
                             }
                            ")),
  
  tags$style(HTML("
                              .no-download {
                                pointer-events: none;
                                }
                             ")),
  
  tags$head(
    tags$style(HTML("
      .navbar-nav .open .dropdown-menu {
        background-color: #000000;
        color: #ffffff;
      }
      
      .navbar-nav .open .dropdown-menu li a {
        background-color: #000000;
        color: #ffffff;
      }
      
      .navbar-nav .open .dropdown-menu li.active a {
        background-color: #000000;
        color: #ffffff;
      }
    "))
  ),
  
    navbarPage(img(src = "mis_proyectos.png", height="30px", width="150px", class = "no-download"), inverse = TRUE, collapsible = TRUE,
               tabPanel("Sobre mi",
                        sidebarLayout(position = "right",
                          sidebarPanel(class = "animated-frame",
                            img(src = "Marco_Aurelio.png", height="515px", width="370px", class = "no-download", class = "animated-radial"), 
                            h4("Hola, soy yo detrás de la pantalla", style = "text-align: center;color:white")
                          ),

                          mainPanel(

                            h1(strong("Soy Marco Aurelio Santander Martínez")),
                            br(),
                            h2(em("Definiéndome")),
                            p(h3("Mi nombre es Marco Aurelio Santander Martínez y soy un analista de datos junior con un background científico. Me caracterizo por ser una persona curiosa y comprometida con sus proyectos, me gusta analizar los problemas desde diferentes puntos de vista para abordarlos de la mejor manera posible y obtener soluciones óptimas.", style = "text-align: justify")),
                            br(),
                            h2(em("Mi pequeña historia")),
                            p(h3("Me formé profesionalmente como químico farmacéutico biólogo, una carrera científica, lo cual me ayudo a formar un criterio basado en la evidencia que me proporcionaban los datos que yo mismo generaba. Opté por el área terminal de farmacia industrial, lo que me llevó a profundizar en el diseño de experimentos y quedarme prendado de la estadística.", style = "text-align: justify")),
                            p(h3("Posteriormente realicé varios proyectos de bioinformática, esto me llevó a introducirme de manera orgánica en el mundo de las tecnologías de la información. Uno de estos proyectos me valió el primer lugar en una presentación de carteles de la sociedad química de México en 2021, y una versión ampliada del mismo se convirtió en mi tesis, por la cual obtuve una mención honorifica. Además, en este mismo ramo de la bioinformática, impartí algunos cursos y conferencias entre 2022 y 2023.", style = "text-align: justify")),
                            p(h3("Por otra parte, tomé el curso de análisis de datos de Google, ya que quería explotar el potencial del análisis de datos en los proyectos que llevaba a cabo en ese momento. Me encontré con un mundo apasionante, lleno de conceptos conocidos y una estructura similar a la que se sigue en la resolución de problemas en la ciencia, por lo cual ya había desarrollado la mayoría de las habilidades requeridas. Aun así, descubrí muchas herramientas que me ayudarían a llevar mis análisis e informes a un nuevo nivel, y me abrirían el panorama hasta notar que la aplicación de mis conocimientos no solo se limitaba al quehacer científico.", style = "text-align: justify")),
                            p(h3("Esta reevaluación aunada a otras consideraciones, como los riesgos asociados a las cadenas de suministro en la ciencia, me llevaron a la decisión de reenfocar mi carrera profesional al análisis de datos.", style = "text-align: justify")),
                            br(),
                            h2(em("Poniéndonos personales…")),
                            p(h3("Soy una persona entusiasta de los temas científicos, no solo en los temas bioquímicos, también en los físicos y psicológicos. Además, siempre me ha gustado informarme acerca de las nuevas tecnologías y características de cualquier componente electrónico, por ello, últimamente la inteligencia artificial y el machine learning son áreas en las que tengo un interés personal y con afán de saciar mi curiosidad.", style = "text-align: justify")),
                            p(h3("En otros aspectos, me gusta hacer ejercicio regularmente y jugar algún partido de cualquier deporte con amigos, aunque no practico ninguno a nivel profesional o semiprofesional. En mis tiempos de ocio, me gusta jugar a videojuegos, juegos de mesa o mirar alguna película, una historia de misterio a ser posible.", style = "text-align: justify")),
                            br(),
                            br(),
                            br()
                          )
                        )
                        ),
               navbarMenu("Hojas de cálculo",
                          tabPanel("Excel",
                                   h1(strong("Trabajos realizados en Microsoft Excel")),
                                   p(h3("A continuación, se encuentra una tabla que contiene una serie de hojas de cálculo, se divide en columnas que indican: el nombre del archivo, una descripción sobre su contenido, los créditos correspondientes y un botón de descarga. ", style = "text-align: justify")),
                                   p(h3("En estos archivos se observan diferentes pruebas y modelos de carácter estadístico que realice durante mi educación superior, cada uno cuenta con comentarios sobre su contenido dentro del documento. Mis dos proyectos favoritos son el relacionado a la pandemia del SARS-CoV-2, y la reducción de un modelo de regresión lineal múltiple.", style = "text-align: justify")),
                                   DTOutput("tabla_archivos")
                          ),
                          
                          tabPanel("Minitab",
                                   h1(strong("Trabajos realizados en Minitab")),
                                   p(h3("De manera similar al caso de Excel, a continuación, se encuentra una tabla que contiene una serie de hojas de cálculo del programa estadístico Minitab, se divide en columnas que indican: el nombre del archivo, una descripción sobre su contenido, los créditos correspondientes y un botón de descarga.", style = "text-align: justify")),
                                   p(h3("En estos archivos se observan; pruebas estadísticas simples, realizadas como parte de las calibraciones de estudios en células vivas; y una versión automatizada del análisis de regresión lineal múltiple, la automatización de los cálculos es uno de los grandes atractivos de este software y sirve a manera de comprobación de lo realizado en Excel.", style = "text-align: justify")),
                                   DTOutput("tabla_miniarchivos")
                                   )
                          ),
               
               tabPanel("Consultas SQL",
                        h1(strong("Consultas SQL")),
                        p(h3("En este apartado se muestran una serie de consultas en lenguaje estructurado, realizadas principalmente a partir de los datos públicos de la plataforma de Google BigQuery. Están orientadas a mostrar las utilidades básicas de las consultas SQL y su rendimiento en la resolución de problemas logísticos.", style = "text-align: justify")),
                        p(h3("Las consultas están precedidas de una pequeña introducción a su función y las bases de datos utilizadas (scripts sql para cargarlas al administrador), después del código se encuentran los resultados almacenados en formato csv. En caso de desear descargar cualquiera de estos archivos, pulsar la imagen correspondiente.", style = "text-align: justify")),
                        p(h3(strong("Nota:"), "Las bases de datos fueron cargadas a “MySQL Workbench 8.0 CE”, por lo cual, si se utiliza un administrador distinto puede requerirse ajustar las consultas al dialecto correspondiente.", style = "text-align: justify")),
                        br(),
                        h2(strong(em("Cambio de estado procesal en quejas de telecomunicaciones")), style = "text-align: center"),
                        p(h3("Esta consulta permite conocer si existen cambios en el estado de atención de una queja en el ámbito de las telecomunicaciones. Tales modificaciones se estudian entre mayo y septiembre de 2023 a partir de dos bases de datos. Se utiliza; el comando SELECT; las cláusulas FROM e INNER JOIN; además de la función IF.", style = "text-align: justify")),
                        br(),
                        h4(em("Quejas - mayo 2023")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_quejas_telecomunicaciones_enero_mayo_2023.sql",
                            download = "bd_quejas_telecomunicaciones_enero_mayo_2023.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        h4(em("Quejas - septiembre 2023")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_quejas_telecomunicaciones_enero_septiembre_2023.sql",
                            download = "bd_quejas_telecomunicaciones_enero_septiembre_2023.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3(HTML("<pre>SELECT <br>  expediente_mayo, <br>  expediente_septiembre, <br>  estado_procesal_mayo, <br>  estado_procesal_septiembre,  <br>IF(estado_procesal_mayo=estado_procesal_septiembre, 'Sin cambio','Cambio') AS cambio_status<br> <br>FROM <br> `enero_septiembre_2023`<br> <br>INNER JOIN <br>  `enero_mayo_2023` ON <br>  expediente_septiembre = expediente_mayo</pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "cambio_estado_procesal.csv",
                            download = "cambio_estado_procesal.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 98px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("Quejas en materia de Telecomunicaciones. [PROFECO]; Consultado [2023-11-17]. Dirección electrónica:", a(href = "https://datos.gob.mx/busca/dataset/telecomunicaciones", target = "_blank", "https://datos.gob.mx/busca/dataset/telecomunicaciones"), style = "text-align: justify")),
                        p(h4("Liga directa a la descarga de datos:", a(href = "https://datos.profeco.gob.mx/datos_abiertos/telecomunicaciones.php", target = "_blank", "https://datos.profeco.gob.mx/datos_abiertos/telecomunicaciones.php"), style = "text-align: justify")),
                        p(h4(strong("Licencia:"), "Acorde a lo referido en los términos de libre uso MX de los Datos Abiertos del Gobierno de México. Disponible en:", a(href = "https://datos.gob.mx/libreusomx", target = "_blank", "https://datos.gob.mx/libreusomx"), style = "text-align: justify")),
                        br(),
                        h2(strong(em("Cumplimiento de depósito")), style = "text-align: center"),
                        p(h3("Esta consulta, que realicé como parte del curso de análisis de datos de Google, permite conocer si existen cambios en el estado de atención de una queja en el ámbito de las telecomunicaciones. Tales modificaciones se estudian entre mayo y septiembre de 2023 a partir de dos bases de datos. Se utiliza; el comando SELECT; las cláusulas FROM e INNER JOIN; además de la función IF.", style = "text-align: justify")),
                        br(),
                        h4(em("Depósito")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_warehouse.sql",
                            download = "bd_warehouse.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        h4(em("Órdenes")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_orders.sql",
                            download = "bd_orders.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),     
                        br(),                
                        p(h3(HTML('<pre>SELECT<br>  Warehouse.id_deposito, <br>  CONCAT(Warehouse.estado , ":", Warehouse.id_deposito) AS estado_deposito, <br>  COUNT(Orders.id_pedido) AS numero_de_ordenes, <br> <br>  (SELECT<br>    COUNT(*)<br>  FROM `orders` AS Orders<br>  ) <br>  AS ordenes_totales, <br> <br>  CASE<br>    WHEN COUNT(Orders.id_pedido)/(SELECT COUNT(*) FROM `orders` AS Orders) <= 0.2<br>    THEN "0-20% de ordenes manejadas"<br>    WHEN COUNT(Orders.id_pedido)/(SELECT COUNT(*) FROM `orders` AS Orders) > 0.2<br>    AND COUNT(Orders.id_pedido)/(SELECT COUNT(*) FROM `orders` AS Orders) <= 0.6<br>    THEN "21-60% de ordenes manejadas"<br>  ELSE "Más del 60% de ordenes manejadas"<br>  END AS resumen_de_cumplimiento<br> <br>FROM `warehouse` AS Warehouse<br> <br>LEFT JOIN `orders` AS Orders<br>  ON Orders.id_deposito = Warehouse.id_deposito<br> <br>GROUP BY<br>  Warehouse.id_deposito, <br>  Warehouse.estado<br> <br>HAVING<br>  COUNT(Orders.id_pedido) > 0; </pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "cumplimiento_depositos.csv",
                            download = "cumplimiento_depositos.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("Los datos utilizados en este estudio fueron obtenidos del curso en línea “Google Data Analytics” ofrecido por Google en la plataforma Coursera. Los datos consisten en identificadores de los depósitos, cantidad de empleados y su estado; así como, identificadores para las órdenes y sus fechas de inicio y finalización. Para acceder a estos datos, se completaron actividades y ejercicios prácticos dentro del curso, los cuales fueron proporcionados por el proveedor como parte del material de aprendizaje.", style = "text-align: justify")),
                        p(h4(strong("Liga directa a la descarga de datos (no accesibles)"), style = "text-align: justify")),
                        p(h4(em("Depósito:"), a(href = "https://d3c33hcgiwev3.cloudfront.net/eGDFHfJlQHSgxR3yZRB07A_66eb1be6ef0d464baab95992e6a880f1_DAC5M3L3R4B-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=AV3ARQiUwjVlgV3PkAVD8OhdaTZIV7T1SYYtSTsriheVLtsXJn1ZONiGEgTq1p7i1nBuz12HQhNYQaabXJIrTHv7WdHU5ocqLGuxEidh2JJO8sXWrSurLphhlgoBzIskPsdp0-dQEyhO3QJ4LYiDBzHaTJqK-z9q4hqMGmzpaOk_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A", target = "_blank", "https://d3c33hcgiwev3.cloudfront.net/eGDFHfJlQHSgxR3yZRB07A_66eb1be6ef0d464baab95992e6a880f1_DAC5M3L3R4B-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=AV3ARQiUwjVlgV3PkAVD8OhdaTZIV7T1SYYtSTsriheVLtsXJn1ZONiGEgTq1p7i1nBuz12HQhNYQaabXJIrTHv7WdHU5ocqLGuxEidh2JJO8sXWrSurLphhlgoBzIskPsdp0-dQEyhO3QJ4LYiDBzHaTJqK-z9q4hqMGmzpaOk_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A"), style = "text-align: left")),
                        p(h4(em("Órdenes:"), a(href = "https://d3c33hcgiwev3.cloudfront.net/qJjUCL4zRpaY1Ai-MxaWsg_5f9bbac1c646466d9e6391ceb6b6bdf1_DAC5M3L3R4A-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=BZ0-31SOzvuHZWbG0GG04YLnFO-dha0QxvbYCXGCCzxkI9PUH0xSoefhCuVDL3fGNqLZjiyS8fxl6tpxGQ7netvl6vlIdfG~UoMXfu6VT~RgsQYEO3JNjEuuXAgEDD1EWr-BqEYTz-Ej1yajMCzlx9kXBtO~rGRo5ouZGzdFc1s_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A", target = "_blank", "https://d3c33hcgiwev3.cloudfront.net/qJjUCL4zRpaY1Ai-MxaWsg_5f9bbac1c646466d9e6391ceb6b6bdf1_DAC5M3L3R4A-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=BZ0-31SOzvuHZWbG0GG04YLnFO-dha0QxvbYCXGCCzxkI9PUH0xSoefhCuVDL3fGNqLZjiyS8fxl6tpxGQ7netvl6vlIdfG~UoMXfu6VT~RgsQYEO3JNjEuuXAgEDD1EWr-BqEYTz-Ej1yajMCzlx9kXBtO~rGRo5ouZGzdFc1s_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A"), style = "text-align: left")),
                        p(h4(strong("Licencia:"), 'Acorde a las condiciones de servicio de Google: “There are no restrictions on the use of the data, and it can be used or redistributed as desired. The data are provided "AS IS" without any warranty, express or implied, from Google. Google disclaims all liability for any damages, direct or indirect, resulting from the use of the dataset”.', style = "text-align: justify")),
                        br(),
                        h2(strong(em("Viajes en bicicleta")), style = "text-align: center"),
                        p(h3("A continuación, se realizan una serie de consultas con datos de viajes de bicicletas en la ciudad de Nueva York.", style = "text-align: justify")),
                        br(),
                        h4(em("Estaciones")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_citibike_stations.sql",
                            download = "bd_citibike_stations.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        h4(em("Viajes")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_citibike_trips.sql",
                            download = "bd_citibike_trips.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        h2(em("Viajes de duración mayor a una hora"), style = "text-align: left"),
                        p(h3("En esta consulta se utiliza una tabla temporal para calcular la cantidad de viajes con una duración mayor a una hora", style = "text-align: justify")),
                        p(h3(HTML("<pre>WITH trips_over_1_hour AS (<br>  SELECT *<br>  FROM<br>    citibike_trips<br>  WHERE<br>    tripduration >= 60<br>)<br> <br>SELECT<br>  COUNT(*) AS cnt<br> <br>FROM<br>  trips_over_1_hour</pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "mayores_hora.csv",
                            download = "mayores_hora.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        h2(em("Rutas principalmente utilizadas"), style = "text-align: left"),
                        p(h3("En esta consulta se buscan las diez rutas con mayor demanda por parte de los usuarios, para ello se utiliza la cantidad de viajes. Al final el resultado entrega nueve rutas, ya que se utilizan los datos sin limpiar y hay datos nulos.", style = "text-align: justify")),
                        p(h3(HTML('<pre>SELECT (<br>  usertype, <br>  CONCAT(start_station_name, " to ", end_station_name) AS route, <br>  COUNT(*) AS num_trips, <br>  ROUND(AVG(tripduration / 60), 2) AS duration<br> <br>FROM<br>  citibike_trips<br> <br>GROUP BY<br>  start_station_name, <br>  end_station_name, <br>  usertype<br> <br>ORDER BY<br>  num_trips DESC<br> <br>LIMIT 10</pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "rutas.csv",
                            download = "rutas.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        h2(em("De estaciones y suscriptores"), style = "text-align: left"),
                        p(h3("En este caso se utiliza una subconsulta para seleccionar los id de las estaciones donde un suscriptor inicio un viaje, de esta manera se pueden identificar los sitios donde las personas ya son clientes fieles y en que sitios se deben redoblar los esfuerzos para atraer nuevos suscriptores.", style = "text-align: justify")),
                        p(h3(HTML('<pre>SELECT <br>  station_id, <br>  name<br> <br>FROM<br>  citibike_stations<br> <br>WHERE<br>  station_id IN<br>  (<br>    SELECT<br>      start_station_id<br>    FROM <br>      citibike_trips<br>    WHERE<br>      usertype = "subscriber"<br>  ); </pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "inicio_suscriptores.csv",
                            download = "inicio_suscriptores.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        p(h3("Ahora, se obtiene el promedio de bicicletas disponibles por cada estación, de esta manera se pueden detectar las estaciones que requieren de más bicicletas para satisfacer la demanda.", style = "text-align: justify")),
                        p(h3(HTML("<pre>SELECT<br>  station_id, <br>  num_bikes_available, <br> <br>  (SELECT <br>    AVG(num_bikes_available) <br>  FROM citibike_stations) AS avg_num_bikes_available<br> <br>FROM<br>  citibike_stations</pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bicicletas_estación.csv",
                            download = "bicicletas_estación.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        h2(em("Bicicletas y estaciones favoritas"), style = "text-align: left"),
                        p(h3("En esta consulta se obtienen los id de las bicicletas que más tiempo pasaron en viajes, es decir, las bicicletas más utilizadas junto a sus tiempos de viaje.", style = "text-align: justify")),
                        p(h3(HTML("<pre>SELECT<br>  bikeid AS most_used_bikes, <br>  SUM(tripduration) AS trip_duration<br>  <br>FROM<br>  citibike_trips<br>GROUP BY<br>  bikeid<br>ORDER BY<br>  trip_duration <br>DESC<br> <br>LIMIT<br>  5</pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bicicletas_favoritas.csv",
                            download = "bicicletas_favoritas.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3("En el siguiente caso se obtienen los id de las estaciones en donde mayor cantidad de viajes se inician, además de la cantidad de viajes iniciados.", style = "text-align: justify")),
                        p(h3(HTML("<pre>SELECT  <br>  start_station_id, <br>  COUNT(*) AS trip_count<br> <br>FROM<br>  citibike_trips<br> <br>GROUP BY<br>  start_station_id<br> <br>ORDER BY<br>  trip_count <br>DESC<br> <br>LIMIT<br>5; </pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "estaciones_favoritas.csv",
                            download = "estaciones_favoritas.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3("En esta consulta se busca hallar las estaciones de inicio con mayor cantidad de viajes de larga duración por parte de las bicicletas más utilizadas.", style = "text-align: justify")),
                        p(h3(HTML("<pre>SELECT  <br>  trips.start_station_id, <br>  COUNT(*) AS trip_count, <br>  most.bikeid, <br>  tripduration<br> <br>FROM<br>  (SELECT<br>    bikeid, <br>    SUM(tripduration) AS trip_duration<br>  FROM<br>    citibike_trips<br>  GROUP BY<br>    bikeid<br>  ORDER BY<br>    trip_duration DESC<br>  LIMIT 5<br>  ) AS most<br> <br>INNER JOIN<br>  citibike_trips AS trips<br> <br>ON<br>  most.bikeid = trips.bikeid<br> <br>GROUP BY<br>  trips.start_station_id, <br>  most.bikeid, <br>  tripduration<br> <br>ORDER BY<br>  trip_count DESC, <br>  tripduration DESC<br>LIMIT 5; </pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "estaciones_bicicletas.csv",
                            download = "estaciones_bicicletas.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("NYC Citi Bike Trips. [City of New York]; Consultado [2024-03-20]. Dirección electrónica:", a(href = "https://console.cloud.google.com/marketplace/product/city-of-new-york/nyc-citi-bike?project=vernal-store-356400", target = "_blank", "https://console.cloud.google.com/marketplace/product/city-of-new-york/nyc-citi-bike?project=vernal-store-356400"), style = "text-align: justify")),
                        p(h4("Los datos se descargan desde BigQuery, para lo cual basta con crear una cuenta gratuita, almacenando los resultados de las siguientes consultas:", style = "text-align: justify")),
                        h4(em("SELECT * FROM `bigquery-public-data.new_york_citibike.citibike_stations`")),
                        h4(em("SELECT * FROM `bigquery-public-data.new_york_citibike.citibike_trips`")),
                        p(h4(strong("Licencia:"), "conforme al acuerdo de licencia de datos de Citi Bike. Disponible en:", a(href = "https://ride.citibikenyc.com/data-sharing-policy", target = "_blank", "https://ride.citibikenyc.com/data-sharing-policy"), style = "text-align: justify")),
                        br(),
                        h2(strong(em("Resumen de ventas")), style = "text-align: center"),
                        p(h3("En esta consulta se realiza un resumen de ventas con datos útiles acerca del precio unitario máximo y la cantidad de productos vendida. Se utiliza; el comando SELECT; las cláusulas FROM, GROUP BY y ORDER BY; la palabra clave AS; y funciones MAX, SUM, EXTRACT y ROUND.", style = "text-align: justify")),
                        br(),
                        h4(em("Ventas")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_sales.sql",
                            download = "bd_sales.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3(HTML("<pre>SELECT <br>  EXTRACT(YEAR FROM date) AS Year, <br>  EXTRACT(MONTH FROM date) AS Month, <br>  product_id AS ProductId, <br>  ROUND(MAX(unit_price),2) AS UnitaryPrice, <br>  SUM(Quantity) AS UnitsSold <br> <br>FROM<br>  sales<br> <br>GROUP BY <br>  Year, <br>  Month, <br>  ProductId<br> <br>ORDER BY <br>  Year, <br>  Month, <br>  ProductId; </pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "resumen_ventas.csv",
                            download = "resumen_ventas.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("Los datos utilizados en este estudio fueron obtenidos del curso en línea “Google Data Analytics” ofrecido por Google en la plataforma Coursera. Consisten en una tabla con información sobre cada venta; cantidad, precio unitario, fecha y los identificadores de tienda, producto y venta. Para acceder a estos datos, se completaron actividades y ejercicios prácticos dentro del curso, los cuales fueron proporcionados por el proveedor como parte del material de aprendizaje.", style = "text-align: justify")),
                        p(h4(strong("Licencia:"), 'Acorde a las condiciones de servicio de Google: “There are no restrictions on the use of the data, and it can be used or redistributed as desired. The data are provided "AS IS" without any warranty, express or implied, from Google. Google disclaims all liability for any damages, direct or indirect, resulting from the use of the dataset”.', style = "text-align: justify")),
                        br(),
                        h2(strong(em("Empleados y Departamentos")), style = "text-align: center"),
                        p(h3("Esta consulta tiene por finalidad listar el nombre, puesto y departamento al que pertenecen los empleados, los datos se encuentran en dos tablas. Se utiliza; el comando SELECT; las cláusulas FROM, RIGHT JOIN y ON; y la palabra clave AS.", style = "text-align: justify")),
                        br(),
                        h4(em("Departamentos")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_departments.sql",
                            download = "bd_departments.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        h4(em("Empleados")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_employees.sql",
                            download = "bd_employees.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3(HTML("<pre>SELECT <br>  employees.nombre AS nombre_empleado, <br>  puesto AS puesto_empleado, <br>  departments.nombre AS nombre_departamento<br> <br>FROM <br>  employees<br> <br>RIGHT JOIN<br>  departments ON <br>   employees.id_departamento = departments.id_departamento</pre>"))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "departamentos_empleados.csv",
                            download = "departamentos_empleados.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("Los datos utilizados en este estudio fueron obtenidos del curso en línea “Google Data Analytics” ofrecido por Google en la plataforma Coursera. Los datos consisten en dos tablas; la primera contiene los nombres de los empleados, sus puestos y los identificadores de sus departamentos, y la segunda los nombres de los departamentos y sus identificadores. Para acceder a estos datos, se completaron actividades y ejercicios prácticos dentro del curso, los cuales fueron proporcionados por el proveedor como parte del material de aprendizaje.", style = "text-align: justify")),
                        p(h4(strong("Liga directa a la descarga de datos (no accesibles)"), style = "text-align: justify")),
                        p(h4(em("Empleados:"), a(href = "https://d3c33hcgiwev3.cloudfront.net/saejqCrSS7-no6gq0ju_hQ_15a323118994467b96f97aa1f6d351f1_DAC5M3L3V1B-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=KrCR9Fcb8DXdxiBNRg~-uwQZIMhf66RPwKC431MJLlCcOdwJLBdFEqeHh8qeUK4R1Q2jPdWfx3L2hkzuiXNcv133xAesPGWWcAmQMJjunqaaPakhCL2W9-JFjHXw1vf0ehBSXswPlL~f6NWxaGcN9mmN7FJqlCz9rxOnVS333E8_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A", target = "_blank", "https://d3c33hcgiwev3.cloudfront.net/saejqCrSS7-no6gq0ju_hQ_15a323118994467b96f97aa1f6d351f1_DAC5M3L3V1B-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=KrCR9Fcb8DXdxiBNRg~-uwQZIMhf66RPwKC431MJLlCcOdwJLBdFEqeHh8qeUK4R1Q2jPdWfx3L2hkzuiXNcv133xAesPGWWcAmQMJjunqaaPakhCL2W9-JFjHXw1vf0ehBSXswPlL~f6NWxaGcN9mmN7FJqlCz9rxOnVS333E8_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A"), style = "text-align: left")),
                        p(h4(em("Departamentos:"), a(href = "https://d3c33hcgiwev3.cloudfront.net/x3Kcz8GkSySynM_BpCsk1A_38ee237788ce4f388c2d724849a910f1_DAC5M3L3V1A-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=DVdAdg44V7afSvyssmF2eRWF2yqvYvkOWc3yUuHBjGDvdX6isHxVP2LsVhTldpwmpVMVSsamqAM5haHQ~rcBvOG-qFEWXTQcH1ZcRHs~sis05P9JF~lGD-0SgeQnEHOpzZdAyqZushSSpGBB2PpMfrNAb4JtWdyr422pIjnyDiI_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A", target = "_blank", "https://d3c33hcgiwev3.cloudfront.net/x3Kcz8GkSySynM_BpCsk1A_38ee237788ce4f388c2d724849a910f1_DAC5M3L3V1A-ATTACHMENT_SPA.csv?Expires=1688688000&Signature=DVdAdg44V7afSvyssmF2eRWF2yqvYvkOWc3yUuHBjGDvdX6isHxVP2LsVhTldpwmpVMVSsamqAM5haHQ~rcBvOG-qFEWXTQcH1ZcRHs~sis05P9JF~lGD-0SgeQnEHOpzZdAyqZushSSpGBB2PpMfrNAb4JtWdyr422pIjnyDiI_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A"), style = "text-align: left")),
                        p(h4(strong("Licencia:"), 'Acorde a las condiciones de servicio de Google: “There are no restrictions on the use of the data, and it can be used or redistributed as desired. The data are provided "AS IS" without any warranty, express or implied, from Google. Google disclaims all liability for any damages, direct or indirect, resulting from the use of the dataset”.', style = "text-align: justify")),
                        br(),
                        h2(strong(em("Datos Meteorológicos")), style = "text-align: center"),
                        p(h3("La consulta busca eliminar datos anómalos de temperatura, velocidad del viento y precipitación generados por el método de recopilación de la estación.  Solo se muestran los resultados de dos estaciones, una con datos anómalos y otra sin ellos, para hacer más visible la diferencia. Se utiliza; el comando SELECT; las cláusulas FROM, WHERE y ORDER BY; las funciones IF y CAST; las palabras clave AS, DESC y ASC; y el operador lógico OR.", style = "text-align: justify")),
                        br(),
                        h4(em("NOAA Datos Meteorológicos")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_noaa_weather_data.sql",
                            download = "bd_noaa_weather_data.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3(HTML('<pre>SELECT<br>  stn, <br>  date, <br>  temp, <br>  wdsp, <br>  prcp, <br>IF (temp=9999.9,NULL,temp) AS temperature, <br>IF (wdsp="999.9",NULL, CAST(wdsp AS FLOAT)) AS wind_speed, <br>IF (prcp=99.9,0,prcp) AS precipitation<br> <br>FROM <br>  noaa_weather_data_2020<br> <br>WHERE <br>  stn ="725846" OR stn="761220"<br> <br>ORDER BY <br>  date DESC, <br>  stn ASC</pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "datos_meteorologicos.csv",
                            download = "datos_meteorologicos.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("Global Surface Summary of the Day Weather Data. [NOAA]; Consultado [2024-03-20]. Dirección electrónica:", a(href = "https://console.cloud.google.com/marketplace/product/noaa-public/gsod?q=search&referrer=search&project=vernal-store-356400", target = "_blank", "https://console.cloud.google.com/marketplace/product/noaa-public/gsod?q=search&referrer=search&project=vernal-store-356400"), style = "text-align: justify")),
                        p(h4("Los datos se descargan desde BigQuery, para lo cual basta con crear una cuenta gratuita, almacenando los resultados de las siguientes consultas:", style = "text-align: justify")),
                        h4(em("SELECT * FROM `bigquery-public-data.noaa_gsod.gsod2020`")),
                        p(h4(strong("Licencia:"), "Acorde a las condiciones de servicio de Google y a los términos de uso de Datos Abiertos del Gobierno de los Estados Unidos de América. Disponible en:", a(href = "https://data.gov/privacy-policy/#data_policy", target = "_blank", "https://data.gov/privacy-policy/#data_policy"), style = "text-align: justify")),
                        br(),
                        h2(strong(em("Base de datos de Clientes")), style = "text-align: center"),
                        p(h3("A continuación, se realizan una serie de consultas básicas sobre una base de datos de clientes. Se utilizan; los comandos SELECT, DELETE e INSERT INTO; las cláusulas FROM, WHERE y VALUES; el operador DISTINCT; y la función SUBSTR.", style = "text-align: justify")),
                        br(),
                        h4(em("Datos Clientes")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_customer_data.sql",
                            download = "bd_customer_data.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3("En el primer caso, se inserta toda la información sobre un nuevo cliente.", style = "text-align: justify")),
                        p(h3(HTML('<pre>INSERT INTO customer_data<br> (id_cliente,nombre,direccion,ciudad,estado,codigo_postal,pais) <br>VALUES<br>  (2645,"John Thompson", "333 SQL Road","Jackson","MI",49202,"US");</pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "nuevo_cliente.csv",
                            download = "nuevo_cliente.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        p(h3("En este paso, se eliminan los datos del nuevo cliente, añadidos en la consulta anterior.", style = "text-align: justify")),
                        p(h3(HTML('<pre>DELETE FROM customer_data<br>WHERE nombre = "John Thompson";</pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "borrar_cliente.csv",
                            download = "borrar_cliente.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        p(h3("Por último, se seleccionan los clientes residentes en el estado de Ohio, donde cada fila corresponda a un cliente distinto.", style = "text-align: justify")),
                        p(h3(HTML('<pre>SELECT  <br>DISTINCT id_cliente<br> <br>FROM <br>  customer_data<br> <br>WHERE<br>  SUBSTR(estado,1,2)="OH";</pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "clientes_ohio.csv",
                            download = "clientes_ohio.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("Los datos utilizados en este estudio fueron obtenidos del curso en línea “Google Data Analytics” ofrecido por Google en la plataforma Coursera. Consisten en una tabla con información sobre cada cliente; su nombre, identificador, dirección, ciudad, estado, código postal y país. Para acceder a estos datos, se completaron actividades y ejercicios prácticos dentro del curso, los cuales fueron proporcionados por el proveedor como parte del material de aprendizaje.", style = "text-align: justify")),
                        p(h4(strong("Licencia:"), 'Acorde a las condiciones de servicio de Google: “There are no restrictions on the use of the data, and it can be used or redistributed as desired. The data are provided "AS IS" without any warranty, express or implied, from Google. Google disclaims all liability for any damages, direct or indirect, resulting from the use of the dataset”.', style = "text-align: justify")),
                        br(),
                        h2(strong(em("Características de Automóviles")), style = "text-align: center"),
                        p(h3("En los siguientes dos casos se busca modificar la información de las bases de datos como parte de las aplicaciones de SQL en la limpieza de datos.", style = "text-align: justify")),
                        br(),
                        h4(em("Datos de automóviles")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "bd_automobile_data.sql",
                            download = "bd_automobile_data.sql",
                            tags$img(
                              src = "Base.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h3("Esta primera consulta tiene por finalidad actualizar valores con “errores de dedo” al capturar los datos.", style = "text-align: justify")),
                        p(h3(HTML('<pre>UPDATE car_info<br> SET num_of_cylinders = "two" <br>WHERE num_of_cylinders = "tow";</pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "tow_two.csv",
                            download = "tow_two.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        p(h3("En este caso eliminamos filas de datos en las que el atributo “radio de compresión“ del auto es de 70, ya que es un valor imposible y debe ser un error.", style = "text-align: justify")),
                        p(h3(HTML('<pre>DELETE FROM car_info<br>WHERE compression_ratio = 70</pre>'))),
                        h4(em("Resultado")),
                        div(
                          style = "display: flex; justify-content: left;",
                          tags$a(
                            href = "compresion_corregida.csv",
                            download = "compresion_corregida.csv",
                            tags$img(
                              src = "Resultados.png",
                              alt = "Descargar archivo",
                              style = "width: 105px; height: 105px;",
                              class = "no-download"
                            )
                          )
                        ),
                        br(),
                        p(h4(strong("Fuente"))),
                        p(h4("Los datos utilizados en este estudio fueron obtenidos del curso en línea “Google Data Analytics” ofrecido por Google en la plataforma Coursera. Consisten en una tabla que contiene información sobre la marca y tipo de automóviles, así como sus características. Para acceder a estos datos, se completaron actividades y ejercicios prácticos dentro del curso, los cuales fueron proporcionados por el proveedor como parte del material de aprendizaje.", style = "text-align: justify")),
                        p(h4(strong("Licencia:"), 'Acorde a las condiciones de servicio de Google: “There are no restrictions on the use of the data, and it can be used or redistributed as desired. The data are provided "AS IS" without any warranty, express or implied, from Google. Google disclaims all liability for any damages, direct or indirect, resulting from the use of the dataset”.', style = "text-align: justify")),
                        br(),
                        br(),
                        br()
                        ),
               navbarMenu("Visualizaciones de datos",
                          tabPanel("Tableau",
                                   h1(strong("Visualizaciones geográficas y dashboard en Tableau")),
                                   p(h3("A continuación, podemos observar una serie de trabajos de visualización de datos realizados con Tableau, cada uno cuenta con los datos sucios, datos limpios y un Audit Trail generado por macroinstrucción de VBA, lo cual permite seguir las modificaciones realizadas.", style = "text-align: justify")),
                                   br(),
                                   p(h3(strong("Nota:"), "Los archivos empaquetados de Tableau se descargan al presionar la imagen correspondiente con el cursor, mientras que se hace lo propio con los archivos de datos al presionar la imagen con el icono de Excel.", style = "text-align: justify")),
                                   br(),
                                   h2(strong(em("Cantidad de sismos por año en cada estado de México (2015-2023)")), style = "text-align: center"),
                                   p(h3("Visualización de la cantidad de sismos por estado en un mapa de la república mexicana, cuenta con un filtro para seleccionar los datos disponibles, del año 2015 al 2023 (éstos últimos truncados en octubre). Este proyecto surge debido a la elevada actividad sismológica que existe en el territorio nacional, deseaba constatar personalmente el efecto de las placas tectónicas en la sismicidad, como es observable, la zona de la placa de cocos se mantiene con una sismicidad elevada y constante.", style = "text-align: justify")),
                                   br(),
                                   div(
                                     style = "display: flex; justify-content: center;",
                                     tags$a(
                                       href = "sismos_mexico_2015_oct_2023.twbx",
                                       download = "sismos_mexico_2015_oct_2023.twbx",
                                       tags$img(
                                         src = "sismos_en_mexico_2015_oct_2023.png",
                                         alt = "Descargar archivo",
                                         style = "width: 791px; height: 483px;",
                                         class = "no-download"
                                       )
                                     ),
                                     tags$a(
                                       href = "sismos_servicio_sismologico_1900-oct_2023.rar",
                                       download = "sismos_servicio_sismologico_1900-oct_2023.rar",
                                       tags$img(
                                         src = "Datos.png",
                                         alt = "Descargar archivo",
                                         style = "width: 160px; height: 150px;",
                                         class = "no-download"
                                       )
                                     )
                                   ),
                                   br(),
                                   p(h4("Los datos sismológicos fueron obtenidos por el Servicio Sismológico Nacional (México). Se agradece a todo el personal del mismo por el mantenimiento de las estaciones, la adquisición y distribución de los datos.", style = "text-align: justify")),
                                   p(h4(strong("Fuente"))),
                                   p(h4("SSN (2023): Universidad Nacional Autónoma de México, Instituto de Geofísica, Servicio Sismológico Nacional, México. Consultado el 31 de octubre de 2023. Dirección electrónica:", a(href = "http://www2.ssn.unam.mx:8080/catalogo/", target = "_blank", "http://www2.ssn.unam.mx:8080/catalogo/"), style = "text-align: justify")),
                                   p(h4(strong("Licencia:"), "Acorde a lo referido en el aviso legal. Disponible en:", a(href = "http://www.ssn.unam.mx/aviso-legal/", target = "_blank", "http://www.ssn.unam.mx/aviso-legal/"), style = "text-align: justify")),
                                   br(),
                                   h2(strong(em("Años escolares ajustados según el aprendizaje")), style = "text-align: center"),
                                   p(h3("Visualización en un mapa mundial de la cantidad de años escolares aparentes obtenidos a partir del ajuste en el aprendizaje, cuenta con un filtro desplegable para seleccionar entre los datos disponibles de distintos años (2010, 2017, 2018 y 2020). Mi interés por esta temática surge a partir de la curiosidad por ubicar la calidad educativa de mi país, México, respecto al resto del mundo. Cabe destacar, de lo observado en este caso de estudio, que se avala la fama de la calidad educativa en algunos países, como Finlandia, mientras que, al menos a mí, me da algunas sorpresas como el alto nivel educativo en Australia.", style = "text-align: justify")),
                                   br(),
                                   div(
                                     style = "display: flex; justify-content: center;",
                                     tags$a(
                                       href = "tiempo_escolar_ajustado_segun_aprendizaje.twbx",
                                       download = "tiempo_escolar_ajustado_segun_aprendizaje.twbx",
                                       tags$img(
                                         src = "tiempo_escolar_ajustado_segun_aprendizaje.png",
                                         alt = "Descargar archivo",
                                         style = "width: 791px; height: 523px;",
                                         class = "no-download"
                                       )
                                     ),
                                     tags$a(
                                       href = "tiempo_escolar_ajustados_aprendizaje.xlsm",
                                       download = "tiempo_escolar_ajustados_aprendizaje.xlsm",
                                       tags$img(
                                         src = "Datos.png",
                                         alt = "Descargar archivo",
                                         style = "width: 160px; height: 150px;",
                                         class = "no-download"
                                       )
                                     )
                                   ),
                                   br(),
                                   p(h4("Para mayor información sobre el ajuste de la cantidad de años estudiados y el aprendizaje obtenido consultar: Filmer, D., Rogers, H., Angrist, N., & Sabarwal, S. (2018). Learning-adjusted years of schooling (LAYS) defining a new macro measure of education. Worldbank.org.", a(href = "https://documents1.worldbank.org/curated/en/243261538075151093/pdf/Learning-Adjusted-Years-of-Schooling-LAYS-Defining-A-New-Macro-Measure-of-Education.pdf", target = "_blank", "https://documents1.worldbank.org/curated/en/243261538075151093/pdf/Learning-Adjusted-Years-of-Schooling-LAYS-Defining-A-New-Macro-Measure-of-Education.pdf"),style = "text-align: justify")),
                                   p(h4(strong("Fuente"))),
                                   p(h4("World Bank variable id: HD.HCI.LAYS World Bank staff calculation based on methodology in Filmer et al. (2018). Disponible en:", a(href = "https://databank.worldbank.org/reports.aspx?source=Education%20Statistics", target = "_blank", "https://databank.worldbank.org/reports.aspx?source=Education%20Statistics"), style = "text-align: justify")),
                                   p(h4(strong("Licencia:"), "Acorde con la clasificación de información para acceso público referido en los términos de The World Bank. Disponible en:", a(href = "https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets", target = "_blank", "https://www.worldbank.org/en/about/legal/terms-of-use-for-datasets"), style = "text-align: justify")),
                                   br(),
                                   h2(strong(em("Casos de muertes violentas en mujeres (2015-2022)")), style = "text-align: center"),
                                   p(h3("Panel sobre la cantidad de feminicidios y de homicidios a mujeres, cuenta con un filtro asociado a todas las representaciones para seleccionar información perteneciente al rango de años comprendido entre 2015 y 2022. Este proyecto surge desde la intención de realizar una comparación que permita elucidar, refiriéndonos a lo indicado en la clasificación de los delitos, si hay razones de genero detrás de las muertes violentas de mujeres en México. El resultado, quedándonos con las cifras, es que no existen razones de genero para los crímenes, sin embargo, aún queda lugar para ampliar este estudio, como ahondar en la tipificación de los delitos y utilizar algún algoritmo para reclasificarlos en dado caso.", style = "text-align: justify")),
                                   br(),
                                   div(
                                     style = "display: flex; justify-content: center;",
                                     tags$a(
                                       href = "casos_muertes_violentas_mujeres_2015-2022.twbx",
                                       download = "casos_muertes_violentas_mujeres_2015-2022.twbx",
                                       tags$img(
                                         src = "casos_muertes_violentas_mujeres_2015-2022.png",
                                         alt = "Descargar archivo",
                                         style = "width: 956px; height: 538px;",
                                         class = "no-download"
                                       )
                                     ),
                                     tags$a(
                                       href = "cifras_victimas _fuero_comun_2015-septiembre_2023.xlsm",
                                       download = "cifras_victimas _fuero_comun_2015-septiembre_2023.xlsm",
                                       tags$img(
                                         src = "Datos.png",
                                         alt = "Descargar archivo",
                                         style = "width: 160px; height: 150px;justify-content: center;",
                                         class = "no-download"
                                       )
                                     )
                                   ),
                                   br(),
                                   p(h4(strong("Fuente"))),
                                     p(h4("Cifras de Víctimas del Fuero Común, 2015 - septiembre 2023, [Secretariado Ejecutivo del Sistema Nacional de Seguridad]; Consultado [2023-10-26]. Dirección electrónica:", a(href = "https://www.gob.mx/sesnsp/acciones-y-programas/datos-abiertos-de-incidencia-delictiva", target = "_blank", "https://www.gob.mx/sesnsp/acciones-y-programas/datos-abiertos-de-incidencia-delictiva"), style = "text-align: justify")),
                                     p(h4("Liga directa a la descarga de datos:", a(href = "https://drive.google.com/file/d/196JKCe1Ga6TEBb54ruhY5IcSf8Xs5MeJ/view?pli=1", target = "_blank", "https://drive.google.com/file/d/196JKCe1Ga6TEBb54ruhY5IcSf8Xs5MeJ/view?pli=1"), style = "text-align: justify")),
                                     p(h4(strong("Licencia:"), "Acorde a lo referido en los términos de libre uso MX de los Datos Abiertos del Gobierno de México. Disponible en:", a(href = "https://datos.gob.mx/libreusomx", target = "_blank", "https://datos.gob.mx/libreusomx"), style = "text-align: justify")),
                                   br(),
                                   br(),
                                   br()
                          )
                       ),
               
               navbarMenu("Estudios de caso",
                          tabPanel("Bellabeat",
                                   h1(strong("Bellabeat: hábitos de uso de dispositivos de seguimiento")),
                                   p(h3("Este es un proyecto práctico parte del curso de análisis de datos de Google, en dicha praxis, se otorga la posibilidad de que el alumno aborde el problema de la manera que considere pertinente, en mi caso considere explotar el lenguaje R junto a sus diversas herramientas (tidyverse, plotly, R Markdown y Flexdasboard) para construir una solución.", style = "text-align: justify")),
                                   p(h3("Con este estudio de caso, se busca discernir el o los productos en que Bellabeat debe volcar sus esfuerzos de marketing (para un mayor contexto sobre el escenario véase el", a(href = "Planteamiento.pdf", target = "_blank", "planteamiento"),"). Para ello se utilizan datos de uso obtenidos de aparatos Fitbit, dado que son análogos a los de la compañía, y se siguen una serie de", a(href = "Desarrollo.pdf", target = "_blank", "preguntas orientativas"), "para guiar el desarrollo del proyecto. A partir de esto se obtienen gráficos sobre hábitos de uso y registros, los cuales se conjugan en un panel con tres pestañas, observando las tendencias se llega a una conclusión expuesta en los", a(href = "Entregables.pdf", target = "_blank", "resultados escritos."), style = "text-align: justify")),
                                   p(h3("A continuación, se observa el tablero obtenido y la documentación del código utilizado para obtener cada gráfico. Para acceder a los scripts originales y datos completos, favor de descargar el proyecto completo comprimido en WinRAR pulsando la imagen indicada para ello.", style = "text-align: justify")),
                                   br(),
                                   h2(strong(em("Dashboard Bellabeat")), style = "text-align: center"),
                                   tags$iframe(style="height:700px; width:100%", src="dashboard_bellabeat.html"),
                                   br(),
                                   h2(strong(em("Documentación Bellabeat")), style = "text-align: center"),
                                   tags$iframe(style="height:700px; width:100%", src="documentacion_bellabeat.html"),
                                   br(),
                                   div(
                                     style = "display: flex; justify-content: center;",
                                   tags$a(
                                     href = "Bellabeat.rar",
                                     download = "Bellabeat.rar",
                                     tags$img(
                                       src = "Proyecto.png",
                                       alt = "Descargar archivo",
                                       style = "width: 150px; height: 150px;",
                                       class = "no-download"
                                     )
                                   )
                                   ),
                                   br(),
                                   p(h4(strong("Cita"))),
                                   p(h4("Furberg, R., Brinton, J., Keating, M., & Ortiz, A. (2016). Crowd-sourced Fitbit datasets 03.12.2016-05.12.2016 [Data set]. Zenodo.", a(href = "https://doi.org/10.5281/zenodo.53894", target = "_blank", "https://doi.org/10.5281/zenodo.53894"), style = "text-align: justify")),
                                   p(h4("Liga directa a la descarga de datos:", a(href = "https://www.kaggle.com/datasets/arashnic/fitbit", target = "_blank", "https://www.kaggle.com/datasets/arashnic/fitbit"), style = "text-align: justify")),
                                   p(h4(strong("Licencia:"), "Acorde a lo referido en los términos de la licencia CC0 de creative commons. Disponible en:", a(href = "https://creativecommons.org/publicdomain/zero/1.0/legalcode.es", target = "_blank", "https://creativecommons.org/publicdomain/zero/1.0/legalcode.es"), style = "text-align: justify")),
                                   br(),
                                   br(),
                                   br(),
                          )
               ),
               tabPanel("Logros",
                        h1(strong("Los logros en mi camino")),
                        p(h3("No quiero dejar pasar la oportunidad de compartir algunos de mis logros más significativos, ya que los considero muestra de mi dedicación y habilidades, y rastros de los aprendizajes que he tenido en los últimos tiempos.", style = "text-align: justify")),
                        br(),
                        h2(strong(em("Graduado con mención honorifica (2023)")), style = "text-align: center"),
                        p(h3('Opté por la opción de titulación más tradicional y realicé una tesis en el campo de la química computacional para obtener mi título de licenciatura. Mi proyecto de investigación fue "Estudio in silico de bioisósteros de tipo antraciclina con potencial actividad anticancerígena".', style = "text-align: justify")),
                        p(h3("Mi tarea consistía en llevar a cabo una investigación exhaustiva y multidisciplinaria para explorar el potencial de los bioisósteros de tipo antraciclina como agentes anticancerígenos utilizando herramientas de química computacional. Para lograr este objetivo, desarrollé una metodología coherente y eficaz para mi investigación, llevé a cabo un estudio multidisciplinario que abarcaba áreas como la química orgánica, la biofísica, la física teórica y la bioinformática; modelé un sistema biológico en un entorno computacional, interpreté visualizaciones de datos complejas y me preparé meticulosamente para la presentación y defensa de mi proyecto. Utilicé diversas herramientas y enfoques para abordar cada fase de la investigación de manera óptima.", style = "text-align: justify")),
                        p(h3("Como resultado de mi investigación, escritura, presentación y defensa del proyecto, así como mi desempeño académico en general, fui galardonado con una mención honorífica. Logro que reconoce mi habilidad en el uso de la metodología de la investigación, capacidad para enfrentar desafíos complejos y lograr resultados sobresalientes en entornos exigentes.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                                 tags$img(
                                   src = "acta.png",
                                   style = "width: 1020px; height: 1320px;",
                                   class = "no-download"
                                 )
                        ),
                        br(),
                        p(h3("A continuación, el trabajo en cuestión, espero sea de su agrado.", style = "text-align: justify")),
                        tags$iframe(style="height:600px; width:100%", src="http://132.248.9.195/ptd2023/junio/0842357/Index.html"),
                        br(),
                        br(),
                        h2(strong(em("Impartí cursos en Flyteek (2022 - 2023)")), style = "text-align: center"),
                        p(h3("Trabajé en Flyteek, un startup de Perú, donde lideré dos ciclos de cursos en línea sincrónicos sobre acoplamiento molecular y un curso asincrónico de quimioinformática.", style = "text-align: justify")),
                        p(h3("En mi rol de instructor, mi tarea principal era capacitar a estudiantes de toda América latina en el uso y los fundamentos de distintos programas bioinformáticos en los cursos “Docking molecular para el estudio de candidatos a fármacos” y “Quimioinformática aplicada en el diseño y descubrimiento de fármacos”. Los objetivos incluían familiarizar a los estudiantes con las herramientas bioinformáticas relevantes y enseñarles cómo aplicarlas en proyectos de investigación.", style = "text-align: justify")),
                        p(h3("Me enfoqué en mostrar el uso práctico del software y explicar detalladamente los algoritmos utilizados, incluidos los algoritmos de optimización. Utilicé una variedad de herramientas didácticas y de comunicación, como Microsoft Powerpoint, Mentimeter y Kahoot, para proporcionar una instrucción interactiva y efectiva. Adapté mi enfoque según las necesidades y el nivel de comprensión de los estudiantes, fomentando una participación activa y brindando apoyo individual cuando fuera necesario.", style = "text-align: justify")),
                        p(h3("Como resultado de estas iniciativas, el alumnado logró un promedio del 87.83% de aprovechamiento en los cursos. Además de estos resultados cuantitativos, recibí comentarios positivos de los estudiantes sobre la claridad de la instrucción y la utilidad de las herramientas utilizadas, lo que sugiere un impacto positivo en su aprendizaje y comprensión de la materia.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                          tags$a(href = "https://flyteek.com/producto/quimioinformatica-aplicada-en-el-diseno-y-descubrimiento-de-farmacos/", target = "_blank",
                          tags$img(
                            src = "Flyteek.jpg",
                            style = "width: 1100px; height: 550px;",
                            class = "no-download"
                          )
                          )
                        ),
                        br(),
                        h2(strong(em("Ponencia para la Asociación Peruana de Estudiantes de Farmacia y Bioquímica (2022)")), style = "text-align: center"),
                        p(h3('Participé como ponente en el evento "III Curso Taller De Bioquimioinformatica", organizado por la Asociación Peruana de Estudiantes de Farmacia y Bioquímica.', style = "text-align: justify")),
                        p(h3('Como ponente, tuve la responsabilidad de impartir una conferencia de dos horas titulada “El mundo del diseño y desarrollo de fármacos”. Mi enfoque fue proporcionar una visión general del panorama del diseño de fármacos asistido por computadora y sus aplicaciones prácticas, además de fomentar el interés del público objetivo del evento, compuesto principalmente por estudiantes de farmacia y bioquímica, a profundizar en alguna de las áreas presentadas.', style = "text-align: justify")),
                        p(h3("Para cumplir con mi tarea, preparé una presentación informativa y visualmente atractiva que cubría diversos aspectos del diseño de fármacos asistido por computadora, incluyendo metodologías, herramientas y ejemplos de casos prácticos. Además, organicé una demostración práctica donde los asistentes pudieron familiarizarse con algunas de las herramientas informáticas más comunes en este campo. Para complementar la conferencia, reservé un espacio para responder preguntas de los asistentes, facilitando discusiones y proporcionando orientación individual cuando fue necesario.", style = "text-align: justify")),
                        p(h3("Como reconocimiento a mi participación como ponente en el simposio, recibí una constancia de participación emitida por la Asociación Peruana de Estudiantes de Farmacia y Bioquímica. Además, recibí retroalimentación positiva de los asistentes, quienes expresaron su aprecio por la información proporcionada y la dinámica interactiva de la sesión. Mi contribución como ponente ayudó a enriquecer la experiencia de aprendizaje de los participantes y a promover el interés en el campo del diseño de fármacos asistido por computadora.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                          tags$img(
                            src = "apefyb.jpg",
                            style = "width: 1100px; height: 850px;",
                            class = "no-download"
                          )
                        ),
                        br(),
                        h2(strong(em("Primer lugar en el Concurso Nacional de Carteles Estudiantiles de la Sociedad Química de México (2021)")), style = "text-align: center"),
                        p(h3("Participé en el Congreso Internacional de la Sociedad Química de México en 2021 como estudiante de química.", style = "text-align: justify")),
                        p(h3('Presenté un proyecto titulado "Diseño computacional de bioisósteros tipo antraciclina con potencial actividad anti-cancerígena" en el Concurso Nacional de Carteles Estudiantiles (CNCE) en la categoría de Química al Servicio de la Salud (QS). Por ello, realicé una investigación exhaustiva utilizando herramientas computacionales para diseñar bioisósteros que podrían tener una potencial actividad anti-cancerígena. Esto incluyó la identificación y modelado de estructuras moleculares, análisis de propiedades físico-químicas y evaluación de la actividad biológica esperada.', style = "text-align: justify")),
                        p(h3("Como resultado de mi trabajo, obtuve el primer lugar en el Concurso Nacional de Carteles Estudiantiles (CNCE) en la categoría de Química al Servicio de la Salud (QS). Este logro no solo reconoció mis habilidades en investigación y diseño computacional, sino que también validó la importancia de mi proyecto en el campo de la química medicinal y la lucha contra el cáncer.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                          tags$img(
                            src = "cnce.png",
                            style = "width: 1100px; height: 778px;",
                            class = "no-download"
                          )
                        ),
                        br(),
                        br(),
                        br()
                ),
               tabPanel("Educación",
                        h1(strong("Educación")),
                        p(h3("En esta sección quiero dedicar un espacio a los cursos en los que he participado como alumno, ya que todos han sido parte de mi formación y me llevado muy buenos recuerdos.", style = "text-align: justify")),
                        br(),
                        h2(strong(em("Licenciatura en Química Farmacéutica Biológica en la Facultad de Estudios Superiores Zaragoza de la Universidad Nacional Autónoma de México")), style = "text-align: center"),
                        p(h3("Decidí estudiar una carrera científica a causa de un examen vocacional que tomé durante mi formación en la Escuela Nacional Preparatoria número 2, terminé por decantarme por Química Farmacéutica Biológica por las amplias áreas de estudio que se deben dominar, dado que siempre he tenido curiosidad por aprender distintas disciplinas. Algunas de las áreas de conocimiento abarcadas fueron; fisicomatemáticas, fisicoquímica, química, biología, bioquímica, farmacia, estadística, administración y socio-humanística. Mi paso por esta carrera inicio en agosto de 2015 y concluyó en mayo de 2020, concluyendo con un promedio de 9.12 sobre 10.00 mi educación superior.", style = "text-align: justify")),
                        div(
                                     style = "display: flex; justify-content: center;",
                                     tags$img(
                                       src = "estudios.png",
                                       style = "width: 1018px; height: 1320px;",
                                       class = "no-download"
                                     )
                            ),
                        br(),
                        h2(strong(em("Certificado de análisis de datos de Google en Coursera")), style = "text-align: center"),
                        p(h3("Esta es mi certificación más importante hasta la fecha, dado que constituye la base del nuevo rumbo que busco darle a mi carrera profesional. Conseguí una beca de la asociación INROADS para unirme a la certificación, inicialmente la consideré un complemento atractivo para mi licenciatura, sin embargo, me fue generando interés el encontrar temas afines a mi formación, cómo la estadística, el uso de hojas de cálculo, una metodología similar al método científico y el uso de lenguajes de programación, aunque en este último caso distintos al que había utilizado.", style = "text-align: justify")),
                        p(h3("A pesar de las similitudes mencionadas, me decanté a cambiar mi enfoque, al notar que se dependía en mucha menor medida de cadenas de suministro, y a que el aprendizaje era mucho más variado, dado que los datos provienen de distintas fuentes en las que se tiene que ahondar para dar análisis acertados. Comencé el curso en junio y lo concluí en agosto de 2023.", style = "text-align: justify")),
                        p(h3(strong("Nota:"), "Presionar la imagen para ver la insignia en mi perfil de Credly.", style = "text-align: justify")),
                         div(
                          style = "display: flex; justify-content: center;",
                          tags$a(href = "https://www.credly.com/badges/56d96d07-85f4-4417-90cf-962c23f76aa2/public_url", target = "_blank",
                          tags$img(
                            src = "analisis.png",
                            style = "width: 1100px; height: 850px;",
                            class = "no-download"
                          )
                          )
                        ),
                        br(),
                        h2(strong(em("Conceptos básicos del aprendizaje automático")), style = "text-align: center"),
                        p(h3("En este caso, me enteré de una conferencia de AWS sobre conceptos de aprendizaje automático, comprendí que me serviría como inducción para dicho campo. Aprendí los tipos de machine learning que existen (supervisado, no supervisado y por refuerzo), modelos, clustering, canalización del machine learning y la definición y funcionamiento del deep learning. En este caso la conferencia se dio en abril de 2024, y para obtener el certificado fue necesario aprobar con al menos 80% una prueba de conocimientos.", style = "text-align: justify")),
                        div(
                                     style = "display: flex; justify-content: center;",
                                     tags$img(
                                       src = "machine.png",
                                       style = "width: 1100px; height: 777px;",
                                       class = "no-download"
                                     )
                            ),
                        br(),
                        h2(strong(em("Certificado de gestión de proyectos de Google en Coursera")), style = "text-align: center"),
                        p(h3("Decidí tomar un segundo certificado por parte de INROADS, dado que observé en muchos perfiles de analistas de datos las competencias que moldea este curso. Durante este periodo reforcé y aprendí el uso de herramientas como el diagrama de Gantt, diagrama de causa-efecto, plan de gestión de riesgo estatuto de proyecto, entre otras. Además, amplié mis conocimientos en metodologías como Lean y Six Sigma, así como me introduje a Waterfall y Agile. Inicié el curso en enero, y concluí en marzo de 2024.", style = "text-align: justify")),
                        p(h3(strong("Nota:"), "Presionar la imagen para ver la insignia en mi perfil de Credly.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                          tags$a(href = "https://www.credly.com/badges/40bde4f6-5cd9-43d3-a612-f79169518d5a/public_url", target = "_blank",
                          tags$img(
                            src = "gestion.png",
                            style = "width: 1100px; height: 850px;",
                            class = "no-download"
                          )
                          )
                        ),
                        br(),
                        h2(strong(em("Aspectos básicos de Microsoft Azure")), style = "text-align: center"),
                        p(h3("De manera similar a lo ocurrido con el certificado de gestión de proyectos, tomé un curso de preparación oficial de Microsoft sobre los fundamentos del sistema de nube de ésta misma empresa, el código del curso es AZ-900T00-A. Durante este curso se definieron los conceptos de la nube; los centros de datos; regiones de disponibilidad; la infraestructura, plataforma, y software como servicios; así como los presupuestos. Tomé este curso en julio de 2023.", style = "text-align: justify")),
                        p(h3(strong("Nota:"), "Presionar la imagen para ver las insignias en mi perfil de Microsoft.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                          tags$a(href = "https://learn.microsoft.com/es-es/users/marcoaureliosantandermartnez-9458/", target = "_blank",
                          tags$img(
                            src = "azure.png",
                            style = "width: 1100px; height: 340px;",
                            class = "no-download"
                          )
                          )
                        ),
                        br(),
                        h2(strong(em("Introducción a Power BI de SEDECO")), style = "text-align: center"),
                        p(h3("En este caso decidí aprovechar la oportunidad de tener una introducción guiada a la herramienta Power BI, dado que es, junto a Tableau, una de las herramientas más importantes de visualización de datos. Aprendí a cargar bases de datos, relacionar sus elementos, crear visualizaciones con dicha información y distribuirlas en un panel. Constó de una sesión en julio de 2023.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                          tags$img(
                            src = "sedeco.png",
                            style = "width: 1100px; height: 619px;",
                            class = "no-download"
                          )
                        ),
                        br(),
                        h2(strong(em("Python For Data Science: Fundamentals Part I de la plataforma en línea Dataquest")), style = "text-align: center"),
                        p(h3("A pesar de que este curso de Python estaba orientado a la ciencia de datos, lo tomé simplemente como una introducción para familiarizarme con el programa en que parametrizaría algunas moléculas durante mis trabajos en el ámbito de la quimioinformática, es por lo que solo cursé la primera parte. Aprendí las bases teóricas, instalación del programa, tipos de datos primitivos y complejos, así como lógica de programación orientada a objetos. Formé parte del curso durante enero de 2022.", style = "text-align: justify")),
                         div(
                          style = "display: flex; justify-content: center;",
                          tags$img(
                            src = "python.png",
                            style = "width: 1100px; height: 778px;",
                            class = "no-download"
                          )
                        ),
                        br(),
                        h2(strong(em("Diplomado en educación financiera de la CONDUSEF")), style = "text-align: center"),
                        p(h3("En este caso tome el curso por un interés personal, quería darme una idea de cómo funciona el sistema financiero nacional y cuáles son las entidades que participan del mismo. Aprendí a hacer un presupuesto personal, conceptos básicos, el rol de las entidades reguladoras y financieras, y la importancia de la inclusión financiera. Me formé con este curso desde marzo hasta junio de 2020.", style = "text-align: justify")),
                        div(
                          style = "display: flex; justify-content: center;",
                          tags$img(
                            src = "condusef.png",
                            style = "width: 1020px; height: 1320px;",
                            class = "no-download"
                          )
                        ),
                        br(),
                        br(),
                        br()                                               
                        )
    )
)

server <- function(input, output) {
  
    addResourcePath("data", "./data")

    output$tabla_miniarchivos <- renderDT({
      data <- data.frame(
        Archivo = miniarchivos,
        Descripción = minidescripciones,
        Créditos = minireferencias,
        Descargar = ""
      )
      
      for (i in 1:length(miniarchivos)) {
        data$Descargar[i] <- as.character(downloadButton(
          outputId = paste0("download_", miniarchivos[i]),
          label = "Descargar",
          href = paste0("data/", miniarchivos[i])
        ))
      }
      datatable(data, escape = FALSE, options = list(
        dom = 'Bfrtip',
        initComplete = JS(
          "function(settings, json) {",
          "$(this.api().table().header()).css({'background-color': '#143b78', 'color': '#ffffff', 'font-size': '20px', 'font-family': 'Arial'});",
          "$(this.api().table().body()).css({'background-color': '#e9f1f7', 'color': '#000000', 'font-size': '16px', 'font-family': 'Arial'});",
          "}"
          
        )
      ))
    })
    
    output$tabla_archivos <- renderDT({
      data <- data.frame(
        Archivo = archivos,
        Descripción = descripciones,
        Créditos = referencias,
        Descargar = ""
      )
      
      for (i in 1:length(archivos)) {
        data$Descargar[i] <- as.character(downloadButton(
          outputId = paste0("download_", archivos[i]),
          label = "Descargar",
          href = paste0("data/", archivos[i])
        ))
      }
      datatable(data, escape = FALSE, options = list(
        dom = 'Bfrtip',
        initComplete = JS(
          "function(settings, json) {",
          "$(this.api().table().header()).css({'background-color': '#03994c', 'color': '#ffffff', 'font-size': '20px', 'font-family': 'Arial'});",
          "$(this.api().table().body()).css({'background-color': '#ebf7e9', 'color': '#000000', 'font-size': '16px', 'font-family': 'Arial'});",
          "}"
        )
      ))
    })
    
  }
  
shinyApp(ui = ui, server = server)
