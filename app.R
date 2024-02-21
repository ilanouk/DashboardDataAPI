
library(shiny)
library(mongolite)
library(ggplot2)

source("install_packages.R")
source("meteo.R")


#Interface utilisateur Shiny
ui <- fluidPage(
    titlePanel("Données météorologiques SYNOP de la semaine"),

    mainPanel(
        tabsetPanel(
            tabPanel("Analyse de la température", plotOutput("visu_data_temp")),
            tabPanel("Analyse de l'humidité", plotOutput("visu_data_humi")),
            tabPanel("Analyse de la pression", plotOutput("visu_data_pres")),
            tabPanel("Analyse de la consommation electrique", plotOutput("visu_data_elec"))
            #titlePanel("Analyse de la température sur la semaine",plotOutput("analyse_hebdo_meteo"))
        )
    )
)

#Serveur Shiny
server <- function(input, output, session){
    
    db_meteo <- mongo("Meteo","user")
    db_elec <- mongo("conso_elec","user")
    data_meteo <- obtenirData(db_meteo)
    data_elec <- obtenirData(db_elec)
    
    observe({

        
        output$visu_data_temp <- renderPlot({
            obtenirGraphe(data_meteo, data_meteo$date, data_meteo$temperature)
        })

        output$visu_data_humi <- renderPlot({
            obtenirGraphe(data_meteo, data_meteo$date, data_meteo$humidite)
        })

        output$visu_data_pres <- renderPlot({
            obtenirGraphe(data_meteo, data_meteo$date, data_meteo$pression)
        })
        output$visu_data_elec <- renderPlot({
            obtenirGraphe(data_elec, data_elec$date, data_elec$consommation)
        })


    })

}

#Lancer l'app shiny
shinyApp(ui = ui, server = server)