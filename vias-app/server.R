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
library(ggplot2)
library(plotly)
library(DT)

vias = read_wrangle_data()

profissoes_nos_dados = vias %>% 
  filter(!is.na(tipo_profissao)) %>%  
  pull(tipo_profissao) %>% 
  unique()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    prof_selecionada = reactive({input$tipo_profissao})
    
    output$comprimento_trecho <- renderPlotly({
        vias_profissao = vias %>% filter(tipo_profissao == prof_selecionada())    
        plot_ly(vias_profissao, type="scatter", x = vias_profissao$comprimento, y = vias_profissao$arvore,
        text = paste("Nome: ",vias_profissao$nomelograd), 
        mode = "markers", size = vias_profissao$faixapedes) %>% 
            layout(
                title = "Relação entre comprimento e quantidade de árvores"
                ) 
            
    })
    
    output$hist <- renderPlotly({
        vias_profissao = vias %>% filter(tipo_profissao == prof_selecionada())
        p = vias_profissao%>% 
            ggplot(aes(x = profissao)) +
            geom_bar(aes(x = profissao,
                         fill = profissao,
                         text = paste(profissao),
                         label = ..count..),
                     stat = "count"
            )  +
            labs(x = "Profissão", y = "Total") + 
            theme(axis.text.x = element_text(angle = 90,
                                             hjust = 1),
                  legend.position="none") 
            
        
        ggplotly(p, tooltip = c("text","label")) %>%
            layout(title = "Número de profissões")
    })
    
    output$listagem <- renderDataTable({
        table = vias %>% 
            filter(tipo_profissao == prof_selecionada()) %>% 
            select(nomelograd, profissao, tipo_profissao)
            DT::datatable(table, options = list(pageLength = 10))
    })
    
})

