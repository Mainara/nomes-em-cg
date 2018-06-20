#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(here)
source(here("code/read_wrangle.R"))

vias = read_wrangle_data()

profissoes_nos_dados = vias %>% 
  filter(!is.na(tipo_profissao)) %>%  
  pull(tipo_profissao) %>% 
  unique()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    prof_selecionada = reactive({input$tipo_profissao})
    output$comprimento_trecho <- renderPlot({
        vias_profissao = vias %>% filter(tipo_profissao == prof_selecionada())
        vias_profissao %>% 
            ggplot(aes(x = comprimento, y = trechos)) + 
            geom_point(size = 1)
    })
    
    output$hist <- renderPlot({

    })
    
    output$listagem <- renderTable({
        vias %>% 
            filter(tipo_profissao == prof_selecionada()) %>% 
            select(nome = nomelograd, 
                   comprimento)
    })
    
})

