###################################
### DAILY DATA MODULE ###
###################################
# file path to data files and shapefile
data_dir = "data"
attributes_dir = file.path(data_dir, "attributes")
site_attributes = qs::qread(file.path(attributes_dir, "site_info.qs")) 
                  
site = site_attributes
site_names = colnames(site)[-(1:2)]


discharge_count = qs::qread(file.path(attributes_dir, "discharge_mach.qs"))

shapefile_dir = file.path(data_dir, "shapefile")
shp_files = list.files(shapefile_dir, pattern = "\\.shp$", full.names = TRUE)
basins_shp = tryCatch(st_read(shp_files[grep("MACH_basins\\.shp$", shp_files)]) %>% st_transform(4326), 
             error = function(e) stop("Failed to load MACH_basins.shp: ", e$message))

###################################
siteSelectionUI = function(id) {
  ns = NS(id)
  tagList(
    fluidRow(
      column(width = 7,
        wellPanel(h6(strong("USGS Stream Gauging Site Locations")), br(), 
          withSpinner(leafletOutput(ns("my_leaflet"), height = 500), type = 5))),
      
      column(width = 3,
        wellPanel(style = "overflow: visible; height: auto;",
          h6(strong("Filter Sites")), br(), 
          selectizeInput(ns("state1"), "State",
            choices = NULL, multiple = TRUE,
            options = list(placeholder = "Select one or more states")),
          checkboxInput(ns("latitude"), HTML("Latitude (°N)"), FALSE),
          conditionalPanel(condition = "input.latitude == true", ns = ns,
            sliderInput(ns("latitude1"), NULL, min = 25, max = 50, value = c(25, 50), ticks = FALSE)),
          checkboxInput(ns("longitude"), HTML("Longitude (°W)"), FALSE),
          conditionalPanel(condition = "input.longitude == true", ns = ns,
            sliderInput(ns("longitude1"), NULL, min = -125, max = -65, value = c(-125, -65), ticks = FALSE)),
          checkboxInput(ns("elevation"), "Mean Elevation (m)", FALSE),
          conditionalPanel(condition = "input.elevation == true", ns = ns,
            sliderInput(ns("elevation1"), NULL, min = 5, max = 3605, value = c(5, 3605), ticks = FALSE)),
          checkboxInput(ns("area"), HTML("Drainage Area (km<sup>2</sup>)"), FALSE),
          conditionalPanel(condition = "input.area == true", ns = ns,
            sliderInput(ns("area1"), NULL, min = 2, max = 26000, value = c(2, 26000), ticks = FALSE)),
          checkboxInput(ns("slope"), "Mean Slope (percent)", FALSE),
          conditionalPanel(condition = "input.slope == true", ns = ns,
            sliderInput(ns("slope1"), NULL, min = 0, max = 70, value = c(0, 70), ticks = FALSE)),
          br(),
          actionButton(ns("reset"), "Reset Filters"))),
      column(width = 2,
        wellPanel(h6(strong("Edit Site Selections")), br(), 
          textInput(ns("add_site_no"), "Manually Add Site", placeholder = "Enter 8-digit SITENO"),
          actionButton(ns("add_site_btn"), "Add Site"),
          br(), br(),
          textInput(ns("remove_site_no"), "Manually Remove Site", placeholder = "Enter 8-digit SITENO"),
          actionButton(ns("remove_site_btn"), "Remove Site"),
          br(), br(),
          actionButton(ns("remove_site_all"), "Remove All Sites"), 
          br(), br(), 
          actionButton(ns("confirm_sites"), textOutput(ns("confirm_label")))))
    ),
    fluidRow(
      column(width = 5,
        br(),
        wellPanel(h6(strong("Stream Discharge Record")), br(),
          withSpinner(DTOutput(ns("discharge_days")), type = 5))),
      column(width = 7,
        br(),
        wellPanel(h6(strong("Selected Stream Gauging Sites")), br(),
          withSpinner(DTOutput(ns("gauges")), type = 5)))
    )
  )
}


siteSelectionServer <- function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
   ns = session$ns
   
      # Dynamic confirm button label
    output$confirm_label <- renderText({
      req(shared_data$site)
      paste("Confirm", length(shared_data$site$SITENO), "Selected Sites")
    })
    
     observe({
      req(shared_data$site_attributes)
      updateSelectizeInput(session, "state1", choices = sort(unique(shared_data$site_attributes$state)))
    })
    
    # Reactive filtered sites
    manual_edit <- reactive({
      req(shared_data$site_attributes)
      siteinfo <- shared_data$site_attributes
      if (!is.null(input$state1) && length(input$state1) > 0) {
        siteinfo <- siteinfo %>% dplyr::filter(state %in% input$state1)
      }
      if (!is.null(input$latitude1) && length(input$latitude1) == 2 && input$latitude) {
        siteinfo <- siteinfo %>% dplyr::filter(dec_lat_va >= input$latitude1[1], dec_lat_va <= input$latitude1[2])
      }
      if (!is.null(input$longitude1) && length(input$longitude1) == 2 && input$longitude) {
        siteinfo <- siteinfo %>% dplyr::filter(dec_long_va >= input$longitude1[1], dec_long_va <= input$longitude1[2])
      }
      if (!is.null(input$elevation1) && length(input$elevation1) == 2 && input$elevation) {
        siteinfo <- siteinfo %>% dplyr::filter(elev_mean >= input$elevation1[1], elev_mean <= input$elevation1[2])
      }
      if (!is.null(input$area1) && length(input$area1) == 2 && input$area) {
        siteinfo <- siteinfo %>% dplyr::filter(NHD_drain_area_sqkm >= input$area1[1], NHD_drain_area_sqkm <= input$area1[2])
      }
      if (!is.null(input$slope1) && length(input$slope1) == 2 && input$slope) {
        siteinfo <- siteinfo %>% dplyr::filter(basin_slope >= input$slope1[1], basin_slope <= input$slope1[2])
      }
      siteinfo %>% dplyr::select(
        SITENO = SITENO,
        NAME = station_name,
        STATE = state,
        LAT = dec_lat_va,
        LONG = dec_long_va,
        ELEV = elev_mean,
        AREA = NHD_drain_area_sqkm,
        SLOPE = basin_slope
      )
    })

    observe({
      shared_data$site <- manual_edit()
    })
    
    # Add site manually
    observeEvent(input$add_site_btn, {
      req(input$add_site_no)
      #new_site_no <- sprintf("%08d", as.numeric(input$add_site_no))
      new_site_no <- stringr::str_pad(input$add_site_no, 8, pad = "0")
      new_site <- shared_data$site_attributes %>% dplyr::filter(SITENO == new_site_no)
      if (nrow(new_site) > 0) {
        new_site <- new_site %>% dplyr::select(
          SITENO = SITENO,
          NAME = station_name,
          STATE = state,
          LAT = dec_lat_va,
          LONG = dec_long_va,
          ELEV = elev_mean,
          AREA = NHD_drain_area_sqkm,
          SLOPE = basin_slope
        )
        if (!new_site_no %in% shared_data$site$SITENO) {
          shared_data$site <- rbind(shared_data$site, new_site)
          showNotification(paste("Site", input$add_site_no, "added successfully!"), type = "message")
        } else {
          showNotification("Site already selected.", type = "warning")
        }
      } else {
        showNotification("Invalid site number. Site not found.", type = "error")
      }
      updateTextInput(session, "add_site_no", value = "")
    })

    # Remove site manually
    observeEvent(input$remove_site_btn, {
      req(input$remove_site_no)
      #remove_site_no <- sprintf("%08d", as.numeric(input$remove_site_no))
      remove_site_no <- stringr::str_pad(input$remove_site_no, 8, pad = "0")
      if (remove_site_no %in% shared_data$site$SITENO) {
        shared_data$site <- shared_data$site %>% dplyr::filter(SITENO != remove_site_no)
        showNotification(paste("Site", input$remove_site_no, "removed successfully!"), type = "message")
      } else {
        showNotification("Site number not found in the current table.", type = "error")
      }
      updateTextInput(session, "remove_site_no", value = "")
    })

    # Remove all sites
    observeEvent(input$remove_site_all, {
      shared_data$site <- shared_data$site_attributes[0, ] %>% dplyr::select(
        SITENO, NAME = station_name, STATE = state, LAT = dec_lat_va, LONG = dec_long_va,
        ELEV = elev_mean, AREA = NHD_drain_area_sqkm, SLOPE = basin_slope
      )
      showNotification("All sites removed successfully!", type = "message")
    })
  
observeEvent(input$reset, {
      updateSelectizeInput(session, "state1", selected = "")
      updateCheckboxInput(session, "latitude", value = FALSE)
      updateSliderInput(session, "latitude1", value = c(25, 50))
      updateCheckboxInput(session, "longitude", value = FALSE)
      updateSliderInput(session, "longitude1", value = c(-125, -65))
      updateCheckboxInput(session, "elevation", value = FALSE)
      updateSliderInput(session, "elevation1", value = c(5, 3605))
      updateCheckboxInput(session, "area", value = FALSE)
      updateSliderInput(session, "area1", value = c(2, 26000))
      updateCheckboxInput(session, "slope", value = FALSE)
      updateSliderInput(session, "slope1", value = c(0, 70))
      shared_data$site <- shared_data$site_attributes %>% dplyr::select(
       SITENO, NAME = station_name, STATE = state, LAT = dec_lat_va, LONG = dec_long_va, 
       ELEV = elev_mean, AREA = NHD_drain_area_sqkm, SLOPE = basin_slope)
      
    })

 # Render gauges table
    output$gauges <- renderDT({
      data <- shared_data$site
      if (nrow(data) == 0) {
        return(DT::datatable(
          data.frame(Message = "No sites selected"),
          options = list(pageLength = 10, scrollX = TRUE, dom = "t"),
          class = "display responsive nowrap"
        ))
      }
      DT::datatable(
        data,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          lengthMenu = c(5, 10, 20, 50),
          dom = "Blfrtip",
          paging = TRUE, 
          server = TRUE
        ),
        class = "display responsive nowrap"
      ) %>% DT::formatRound(columns = c("LAT", "LONG"), digits = 2)
    })

    # Render discharge table
    output$discharge_days <- renderDT({
      data <- shared_data$discharge_count %>% dplyr::filter(SITENO %in% shared_data$site$SITENO)
      if (nrow(data) == 0) {
        return(DT::datatable(
          data.frame(Message = "No sites selected"),
          options = list(pageLength = 10, scrollX = TRUE, dom = "t"),
          class = "display responsive nowrap"
        ))
      }
      DT::datatable(
        data,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          lengthMenu = c(5, 10, 20, 50),
          dom = "Blfrtip",
          paging = TRUE, 
          server = TRUE
        ),
        class = "display responsive nowrap"
      )
    })

output$my_leaflet <- renderLeaflet({
      req(shared_data$basins_shp, shared_data$site)
      leaflet() %>%
        setView(lng = -99, lat = 40, zoom = 4) %>%
        addTiles(group = "OpenStreetMap", options = tileOptions(maxZoom = 18)) %>%
        addProviderTiles(providers$Esri.WorldTopoMap, group = "EsriTopo", options = tileOptions(maxZoom = 18)) %>%
        addCircleMarkers(
          data = shared_data$site,
          lng = ~LONG,
          lat = ~LAT,
          radius = 3,
          color = "blue",
          popup = ~paste0(
            "Gauge ID: ", SITENO, "<br>",
            "Gauge Name: ", NAME, "<br>",
            "Latitude: ", LAT, "<br>",
            "Longitude: ", LONG
          )
        ) %>%
        addPolygons(
          data = shared_data$basins_shp,
          color = "black",
          fillColor = "white",
          weight = 1,
          opacity = 0.7,
          fillOpacity = 0.2,
          group = "Basin Delineations"
        ) %>%
        addLayersControl(
          baseGroups = c("OpenStreetMap", "EsriTopo"),
          overlayGroups = c("Basin Delineations"),
          options = layersControlOptions(collapsed = FALSE)
        ) %>%
        hideGroup("Basin Delineations") %>%
        setMaxBounds(lng1 = -125, lat1 = 25, lng2 = -65, lat2 = 50)
    })


# Function to convert CSV to QS
    convert_csv_to_qs <- function(file_path_csv, gauge_id, frequency = "daily", cache_dir) {
      if (is.null(cache_dir) || !dir.exists(cache_dir)) {
        stop("Invalid or missing QS cache directory")
      }
      cache_dir <- normalizePath(cache_dir, winslash = "/")
      file_path_csv <- normalizePath(file_path_csv, winslash = "/")
      if (!file.exists(file_path_csv)) {
        stop("CSV file does not exist: ", file_path_csv)
      }
      qs_file <- file.path(cache_dir, paste0("basin_", gauge_id, "_MACH.qs"))
      qs_file <- normalizePath(qs_file, winslash = "/", mustWork = FALSE)
      all_vars <- c("PRCP", "TAIR", "TMIN", "TMAX", "PET", "AET", "OBSQ", "SWE", "SRAD", "VP", "DAYL")
      tryCatch({
        df <- read_csv(file_path_csv, col_types = cols(
          SITENO = col_character(), DATE = col_date(), .default = col_double()))
        required_columns <- c("SITENO", "DATE", all_vars)
        if (!all(required_columns %in% colnames(df))) {
          complete_dates <- create_complete_dates(gauge_id, frequency)
          df_complete <- complete_dates
          for (var in all_vars) {
            df_complete[[var]] <- NA
          }
          qs::qsave(df_complete, qs_file, preset = "high", nthreads = 2)
          return(df_complete)
        }
        df <- df %>% dplyr::select(SITENO, DATE, dplyr::all_of(all_vars))
        complete_dates <- create_complete_dates(gauge_id, frequency)
        df_complete <- dplyr::full_join(complete_dates, df, by = c("SITENO", "DATE"))
        df_complete <- df_complete %>% arrange(DATE)
        qs::qsave(df_complete, qs_file, preset = "high", nthreads = 2)
        return(df_complete)
      }, error = function(e) {
        stop("Failed to convert CSV to QS for ", file_path_csv, ": ", e$message)
      })
    }


  # Confirm site selection and convert CSVs to QS
    observeEvent(input$confirm_sites, {
      if (is.null(shared_data$mach_folder) || !dir.exists(shared_data$mach_folder)) {
        shinyalert::shinyalert(
          title = "Error",
          text = "Please select MACH folder in the Dataset Import tab.",
          type = "error"
        )
        return()
      }
      req(shared_data$site$SITENO, shared_data$mach_folder, shared_data$mach_files)
      selected_site_ids <- shared_data$mach_ids[shared_data$mach_ids %in% shared_data$site$SITENO]
      gauge_numbers <- shared_data$mach_files[shared_data$mach_ids %in% selected_site_ids]
      if (length(gauge_numbers) == 0) {
        shinyalert::shinyalert(
          title = "Error",
          text = "No matching data files found for selected sites",
          type = "error"
        )
        return()
      }
      
      
      # Create qs_cache_temp directory
      qs_cache_dir <- file.path(shared_data$mach_folder, "qs_cache_temp")
      if (!dir.exists(qs_cache_dir)) {
        dir.create(qs_cache_dir, showWarnings = FALSE)
      }
      shared_data$qs_cache_dir <- qs_cache_dir
      # Clear existing QS files
      qs_files <- list.files(qs_cache_dir, pattern = "\\.qs$", full.names = TRUE)
      if (length(qs_files) > 0) {
        unlink(qs_files, force = TRUE)
      }
      # Convert CSVs to QS
      show_modal_progress_line(text = "Preparing data...", session = session)
      withProgress(message = "Converting CSVs to QS", value = 0, {
        for (i in seq_along(gauge_numbers)) {
          file_path <- gauge_numbers[i]
          gauge_id <- stringr::str_extract(basename(file_path), "(?<=basin_)\\d{8}(?=_MACH\\.csv)")
          incProgress(1 / length(gauge_numbers), detail = paste("Site", gauge_id))
          tryCatch({
            convert_csv_to_qs(file_path, gauge_id, frequency = "daily", cache_dir = qs_cache_dir)
          }, error = function(e) {
            shinyalert::shinyalert(
              title = "Warning",
              text = paste("Failed to convert CSV for site", gauge_id, ":", e$message),
              type = "warning"
            )
          })
        }
      })
      remove_modal_progress(session = session)
      shinyalert::shinyalert(
        title = "Success",
        text = paste(length(gauge_numbers), "sites prepared for data retrieval"),
        type = "success"
      )
    })
  })
}