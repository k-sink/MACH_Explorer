################################################################
### MACH EXPLORER DESKTOP APPLICATION ###
################################################################
# Katharine Sink
# December 2024

.libPaths("F:/MACH_Explorer/R/library")

# load libraries
library(shiny)
library(shinyjs)
library(shinycssloaders)
library(shinyalert)
library(shinybusy)
library(bslib)
library(qs)
library(leaflet) 
library(tidyverse)  
library(DT)
library(sf) 
library(shinythemes) 
library(zip)

# load module resources
source("helpers.R")
source("modules/dataset_import_module.R")
source("modules/site_selection_module.R")
source("modules/daily_data_module.R")
source("modules/monthly_data_module.R")
source("modules/annual_data_module.R")
source("modules/mopex_module.R")
source("modules/attributes_module.R")
source("modules/land_cover_module.R")

###############################
### USER INTERFACE ###
###############################
ui = fluidPage(

  tags$head(tags$style(HTML("
    .well { 
      min-height: 100px; 
      height: auto !important; 
      overflow: hidden; 
    }
    .dataTables_scroll {
     max-height: 70vh !important;
     overflow-y: auto !important;
    }
    .dataTables_paginate { 
      margin-top: 10px !important; 
    }
    .dataTables_info { 
      margin-top: 10px !important; 
    }
      .leaflet-container {
      height: 500px;
      width: 100%;
      margin-bottom: 1rem;
      border: 1px solid #dee2e6;
      }
    
  "))),
  
theme = bs_theme(version = 5, bootswatch = "lumen"),
  useShinyjs(),
  titlePanel("MACH Explorer"),

 
  tabsetPanel(
    id = "tabs",
    
    tabPanel(title = "Dataset Import", datasetImportUI("dataset_import")), 
    tabPanel(title = "Site Selection", siteSelectionUI("site_selection")),  
    tabPanel(title = "Daily Data", dailyDataUI("daily_data")), 
    tabPanel(title = "Monthly Data", monthlyDataUI("monthly_data")), 
    tabPanel(title = "Annual Data", annualDataUI("annual_data")), 
    tabPanel(title = "MOPEX", mopexDataUI("mopex_data")), 
    tabPanel(title = "Attributes", attributesUI("attributes")), 
    tabPanel(title = "Land Cover", landCoverDataUI("land_cover_data"))

) # tabsetPanel close
) # ui close



###############################
### SERVER ###
###############################
server = function(input, output, session) {

  # create shared data for across tabs
  shared_data = reactiveValues( 
    mach_folder = NULL, 
    mopex_folder = NULL, 
    mach_files = character(0), 
    mach_ids = character(0), 
    mopex_files = character(0), 
    mopex_ids = character(0), 
    site_attributes = site_attributes, 
    site = site, 
    basins_shp = basins_shp, 
    discharge_count = discharge_count, 
    qs_cache_dir = NULL, 
    load_mopex = FALSE)
  

   # Lazy load MOPEX data when MOPEX tab is selected
  observeEvent(input$tabs, {
    if (input$tabs == "MOPEX") {
      shared_data$load_mopex <- TRUE
    }
  })

  datasetImportServer(id = "dataset_import", shared_data)
  siteSelectionServer(id = "site_selection", shared_data)
  dailyDataServer(id = "daily_data", shared_data)
  monthlyDataServer(id = "monthly_data", shared_data)
  annualDataServer(id = "annual_data", shared_data)
  mopexDataServer(id = "mopex_data", shared_data)
  attributesServer(id = "attributes", shared_data)
  landCoverDataServer(id = "land_cover_data", shared_data)
  
 onStop(function() {
  temp_dir <- file.path("basin_files")
  if (dir.exists(temp_dir)) {
    unlink(temp_dir, recursive = TRUE, force = TRUE)
  }

  shared_data_list <- reactiveValuesToList(shared_data)
  mach_folder <- shared_data_list$mach_folder
  qs_cache_dir <- file.path(mach_folder, "qs_cache_temp")

  if (!is.null(mach_folder) && dir.exists(qs_cache_dir)) {
    unlink(qs_cache_dir, recursive = TRUE, force = TRUE)
  }
})
 
}
  shinyApp(ui = ui, server = server)