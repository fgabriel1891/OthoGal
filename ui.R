#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinythemes)

ui = dashboardPage(skin = "black",
  dashboardHeader(titleWidth = 300,
    title = "OtoGal: Otholits of Galapagos"),
  dashboardSidebar(collapsed = T,
    width = 350,
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Interactive Guide", tabName = "guide", icon = icon("database")),
      menuItem("About", tabName = "About", icon = icon("eye")))
    ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "guide",
              fluidPage(
                box(h3("Select an species"),
                    DT::dataTableOutput("speciesList")),
                tabBox(id = "tabBox",
                       tabPanel("Available Otolith Images", 
                                uiOutput("imageData"),
                                fluidRow(
                                imageOutput("otoPlot"))
                       ),
                       tabPanel("Distribution", 
                               tableOutput("distData")
                                ),
                       tabPanel("Ecology", 
                                uiOutput("ecoDataR"),
                                tableOutput("EcoInfo")
                       ),
                       tabPanel("Ecosystem", 
                                h3("Some info here")
                       )
                       )
                
                  
              )
              
    )
      
  )
))