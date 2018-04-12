#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(rfishbase)


database = read.csv("data/fishdata.csv", header = T, stringsAsFactors = F)
database$img = paste("www/", database$img, sep = "")
species = unique(database["species"])
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$speciesList <- DT::renderDataTable({
DT::datatable(species,rownames = F,style = "bootstrap",
              options = list (pageLength = 15), filter = "top", selection = "single")
  })
  
  matchData = eventReactive(input$speciesList_rows_selected,{
   r =  grep(species[input$speciesList_rows_selected,],database$species)
   r
  })
  
 

  
  output$imageData <-renderUI({
    dat = data.frame(database["codigo"][matchData(),])
    selectInput("imageList", label = "Select an image", choices = dat)
  })
  
  rendPlot = eventReactive(input$imageList,{
    database$img[database$codigo == input$imageList]
  })
  
  output$otoPlot = renderImage({
    list(src = rendPlot())
  })
  
  
  dat <- eventReactive(input$speciesList_rows_selected,{
    data.frame( unique(database["species"][matchData(),]))})
  
  
  output$distData = renderTable({
    dist = rfishbase::distribution(dat())
    dist[c("Status", "FAO")]
  })
  
  
  eco <- eventReactive(input$speciesList_rows_selected, {
    rfishbase::ecology(dat())})
  
  output$ecoDataR = renderUI({
   

    eco = eco()[-which(is.na(eco()))]
    eco = eco[-which(eco == 0)]
    selectInput("ecoNames" ,
                label = "Select a category",
                choices = names(eco))
    
  })

  table = eventReactive(input$ecoNames,{
    print(eco()[,input$ecoNames])
    
  })
  
  output$EcoInfo = renderTable({
    
    table()
  })
  
})


rfishbase::sci_to_common(species[3,])



