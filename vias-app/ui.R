library(shiny)
library(tidyverse)
library(here)
source(here("code/read_wrangle.R"))


profissoes_nos_dados = read_wrangle_data() %>% 
    filter(!is.na(tipo_profissao)) %>%  
    pull(tipo_profissao) %>% 
    unique()


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  tags$link(
      href=paste0("http://fonts.googleapis.com/css?",
                  "family=Source+Sans+Pro:300,600,300italic"),
      rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
             "body {font-family: 'Source Sans Pro'}"
  ),
  
  h2("Análise das ruas de CG"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        selectInput("tipo_profissao", 
                    "Tipo profissão", 
                    choices = profissoes_nos_dados)),
    
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("comprimento_trecho"), 
       plotOutput("hist"),
       tableOutput("listagem")
    )
  )
))
