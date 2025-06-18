###################################
### DATASET IMPORT MODULE ###
###################################

datasetImportUI = function(id) {
  ns = NS(id)
  tagList(
    br(),
    fluidRow(
      column(width = 12,
        wellPanel(
          h6(strong("WELCOME TO MACH EXPLORER")),
          p("This app allows users to navigate and manipulate the MACH dataset, 
            which contains daily climate and streamflow data along with catchment 
            attributes for 1,014 watersheds within the United States. 
            All tabs retrieve data based on the sites selected on the 'Site Selection' tab.")
        )
      )
    ),
    br(),
    fluidRow(
      column(width = 12,
        wellPanel(
          h6(strong("DATA IMPORT")),
          p(strong("The Daily Data, Monthly Data, and Annual Data tabs use data from the MACH timeseries.")),
          tags$ul(
            tags$li(HTML("Prior to utilizing any of these tabs, download the MACH_ts.zip folder from <a href='https://zenodo.org/records/15311986' target='_blank'>https://zenodo.org/records/15311986</a>.")),
            tags$li("Unzip the folder to your local machine, making sure to retain the 'MACH_ts' folder name and the 1,014 csv files within.")
          ),
          p(strong("The MOPEX tab uses data from the MOPEX timeseries.")),
          tags$ul(
            tags$li(HTML("Prior to utilizing any of these tabs, download the MOPEX_ts.zip folder from <a href='https://zenodo.org/records/15311986' target='_blank'>https://zenodo.org/records/15311986</a>.")),
            tags$li("Unzip the folder to your local machine, making sure to retain the 'MOPEX_ts' folder name and the 395 csv files within.")
          )
        )
      )
    ),
    br(),
    fluidRow(
      column(width = 12,
        wellPanel(
          h6(strong("LOCATE FILES")),
          p(strong("Use the browse button to locate the unzipped MACH_ts folder.")),
          actionButton(ns("machBtn"), "Browse for MACH data folder"),
          textOutput(ns("machFolderPath")),
          br(),
          p(strong("Use the browse button to locate the unzipped MOPEX_ts folder.")),
          actionButton(ns("mopexBtn"), "Browse for MOPEX data folder"),
          textOutput(ns("mopexFolderPath"))
        )
      )
    )
  )
}

datasetImportServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # JavaScript to call IPC functions for folder retrieval
    shinyjs::runjs(sprintf('
      Shiny.addCustomMessageHandler("%s", function(message) {
        window.electronAPI.selectFolderMach().then(function(path) {
          Shiny.setInputValue("%s", path);
        });
      });
      Shiny.addCustomMessageHandler("%s", function(message) {
        window.electronAPI.selectFolderMopex().then(function(path) {
          Shiny.setInputValue("%s", path);
        });
      });
    ', ns("triggerMachFolderSelect"), ns("machFolderSelected"),
       ns("triggerMopexFolderSelect"), ns("mopexFolderSelected")))

    # Handle MACH button click
    observeEvent(input$machBtn, {
      cat("MACH button clicked\n")
      session$sendCustomMessage(ns("triggerMachFolderSelect"), "select")
    })

    # Handle MOPEX button click
    observeEvent(input$mopexBtn, {
      cat("MOPEX button clicked\n")
      session$sendCustomMessage(ns("triggerMopexFolderSelect"), "select")
    })

    # Update MACH folder path
    observeEvent(input$machFolderSelected, {
      if (!is.null(input$machFolderSelected) && dir.exists(input$machFolderSelected)) {
        shared_data$mach_folder <- normalizePath(input$machFolderSelected)
        showNotification("MACH folder selected!", type = "message")
      } else {
        shared_data$mach_folder <- NULL
        showNotification("Invalid MACH folder selected.", type = "error")
      }
      output$machFolderPath <- renderText({
        if (is.null(shared_data$mach_folder)) "No folder selected" else shared_data$mach_folder
      })
    })

    # Update MOPEX folder path
    observeEvent(input$mopexFolderSelected, {
      if (!is.null(input$mopexFolderSelected) && dir.exists(input$mopexFolderSelected)) {
        shared_data$mopex_folder <- normalizePath(input$mopexFolderSelected)
        showNotification("MOPEX folder selected!", type = "message")
      } else {
        shared_data$mopex_folder <- NULL
        showNotification("Invalid MOPEX folder selected.", type = "error")
      }
      output$mopexFolderPath <- renderText({
        if (is.null(shared_data$mopex_folder)) "No folder selected" else shared_data$mopex_folder
      })
    })

    # Reactive file lists filtered by SITENO
    mach_files <- reactive({
      req(shared_data$mach_folder, shared_data$site$SITENO)
      if (!dir.exists(shared_data$mach_folder)) return(character(0))
      files <- list.files(shared_data$mach_folder, pattern = "basin_\\d{8}_MACH\\.csv", full.names = TRUE)
      ids <- stringr::str_extract(basename(files), "(?<=basin_)\\d{8}(?=_MACH\\.csv)")
      files[ids %in% shared_data$site$SITENO]
    })

    mach_ids <- reactive({
      if (length(mach_files()) == 0) return(character(0))
      stringr::str_extract(basename(mach_files()), "(?<=basin_)\\d{8}(?=_MACH\\.csv)")
    })

    mopex_files <- reactive({
      req(shared_data$mopex_folder, shared_data$site$SITENO, shared_data$load_mopex)
      if (!dir.exists(shared_data$mopex_folder)) return(character(0))
      files <- list.files(shared_data$mopex_folder, pattern = "basin_\\d{8}_MOPEX\\.csv", full.names = TRUE)
      ids <- stringr::str_extract(basename(files), "(?<=basin_)\\d{8}(?=_MOPEX\\.csv)")
      files[ids %in% shared_data$site$SITENO]
    })

    mopex_ids <- reactive({
      if (length(mopex_files()) == 0) return(character(0))
      stringr::str_extract(basename(mopex_files()), "(?<=basin_)\\d{8}(?=_MOPEX\\.csv)")
    })

    # Store file lists in shared_data
    observe({
      shared_data$mach_files <- mach_files()
      shared_data$mach_ids <- mach_ids()
      shared_data$mopex_files <- mopex_files()
      shared_data$mopex_ids <- mopex_ids()
    })

  })
}
