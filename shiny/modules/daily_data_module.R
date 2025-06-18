###################################
### DAILY DATA MODULE ###
###################################
dailyDataUI = function(id) {
  ns = NS(id)
  tagList(
    br(),
    fluidRow(
      column(width = 4,
        wellPanel(
          style = "overflow: visible; height: auto;",
          h6(strong("Select Variable(s)")),
          checkboxInput(ns("select_prcp"), "Precipitation, PRCP (mm)", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_prcp"), "'] == true"),
            sliderInput(ns("prcp1"), label = NULL,
              min = 0, max = 300, value = c(0, 300), ticks = FALSE)),

          checkboxInput(ns("select_tair"), HTML("Mean Temperature, TAIR (°C)"), FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_tair"), "'] == true"),
            sliderInput(ns("tair1"), label = NULL,
              min = -50, max = 50, value = c(-50, 50), ticks = FALSE)),

          checkboxInput(ns("select_tmin"), HTML("Minimum Temperature, TMIN (°C)"), FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_tmin"), "'] == true"),
            sliderInput(ns("tmin1"), label = NULL,
              min = -50, max = 50, value = c(-50, 50), ticks = FALSE)),

          checkboxInput(ns("select_tmax"), HTML("Maximum Temperature, TMAX (°C)"), FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_tmax"), "'] == true"),
            sliderInput(ns("tmax1"), label = NULL,
              min = -50, max = 50, value = c(-50, 50), ticks = FALSE)),
  
          checkboxInput(ns("select_pet"), "Potential Evapotranspiration, PET (mm)", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_pet"), "'] == true"),
            sliderInput(ns("pet1"), label = NULL,
              min = -1, max = 40, value = c(-1, 40), ticks = FALSE)),

          checkboxInput(ns("select_aet"), "Actual Evapotranspiration, AET (mm)", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_aet"), "'] == true"),
            sliderInput(ns("aet1"), label = NULL,
              min = -1, max = 40,  value = c(-1, 40), ticks = FALSE)),

          checkboxInput(ns("select_disch"), "Observed Discharge, OBSQ (mm)", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_disch"), "'] == true"),
            sliderInput(ns("disch1"), label = NULL,
              min = -1, max = 400, value = c(-1, 400), ticks = FALSE)),
 
          checkboxInput(ns("select_swe"), "Snow Water Equivalent, SWE (mm)", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_swe"), "'] == true"),
            sliderInput(ns("swe1"), label = NULL,
              min = 0, max = 1850, value = c(0, 1850), ticks = FALSE)),

          checkboxInput(ns("select_srad"), HTML("Shortwave Radiation, SRAD (W/m<sup>2</sup>)"), FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_srad"), "'] == true"),
            sliderInput(ns("srad1"), label = NULL,
              min = 10, max = 900, value = c(10, 900), ticks = FALSE)),

          checkboxInput(ns("select_vp"), "Water Vapor Pressure, VP (Pa)", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_vp"), "'] == true"),
            sliderInput(ns("vp1"), label = NULL,
              min = 5, max = 4000, value = c(5, 4000), ticks = FALSE)),

          checkboxInput(ns("select_dayl"), "Day Length, DAYL (sec)", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_dayl"), "'] == true"),
            sliderInput(ns("dayl1"), label = NULL, 
              min = 30000, max = 60000, value = c(30000, 60000), ticks = FALSE)),

          br(),
          h6(strong("Select Time Period(s)")),
          checkboxInput(ns("select_date"), "Date Range", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_date"), "'] == true"),
            dateRangeInput(ns("date_range1"), label = NULL,
              start = "1980-01-01", end = "2023-12-31", 
              format = "mm/dd/yyyy", separator = "to")),

          checkboxInput(ns("select_year"), "Calendar Year", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_year"), "'] == true"),
            selectizeInput(ns("year1"), label = NULL,
              choices = seq(1980, 2023, 1), multiple = TRUE,
              options = list(placeholder = "Select one or more"))),
 
          checkboxInput(ns("select_month"), "Month", FALSE),
          conditionalPanel(
            condition = paste0("input['", ns("select_month"), "'] == true"),
            selectizeInput(ns("month1"), label = NULL,
              choices = c("JAN" = 1, "FEB" = 2, "MAR" = 3, "APR" = 4, "MAY" = 5, "JUN" = 6,
                          "JUL" = 7, "AUG" = 8, "SEP" = 9, "OCT" = 10, "NOV" = 11, "DEC" = 12),
              multiple = TRUE, options = list(placeholder = "Select one or more"))),

          br(),
          actionButton(ns("retrieve_data"), "Retrieve and View Data")),

        br(),
        wellPanel(
          h6(strong("Download Daily Data")),
          br(),
          downloadButton(ns("download_csv"), "Export as csv"),
          br(), br(),
          downloadButton(ns("download_separate"), "Export as separate csv files"))),

      column(width = 8,
        wellPanel(
          h6(strong("Filtered Daily Data")),
          br(),
          withSpinner(DTOutput(ns("merged_data_table")), type = 5)
        )
      )
    )
  )
}


### SERVER ###

dailyDataServer = function(id, shared_data) {
  moduleServer(id, function(input, output, session) {
    ns = session$ns

    # get filtered site numbers 
    filtered_sites = reactive({
      req(shared_data$site$SITENO)
      shared_data$site$SITENO
    })

    # retrieve and process data when button is clicked
    table = eventReactive(input$retrieve_data, {
      
      # Show progress modal
      show_modal_progress_line(text = "Retrieving data...", session = session)
      on.exit(remove_modal_progress(session = session))
      
      # validate inputs for mach folder 
      if (is.null(shared_data$mach_folder) || !dir.exists(shared_data$mach_folder)) {
        shinyalert::shinyalert(
          title = "Error",
          text = "Please specify MACH data location",
          type = "error"
        )
        return(data.frame(Message = "No data available"))
      }

      if (is.null(shared_data$qs_cache_dir) || !dir.exists(shared_data$qs_cache_dir)) {
        shinyalert::shinyalert(
          title = "Error",
          text = "Click the 'Confirm Sites' button on the Site Selection tab to proceed.",
          type = "error"
        )
        return(data.frame(Message = "No data available"))
      }
      
      
      if (length(filtered_sites()) == 0) {
        shinyalert::shinyalert(
          title = "Error",
          text = "No sites selected",
          type = "error"
        )
        return(data.frame(Message = "No sites selected"))
      }

      # collect selected variables with isolate to prevent reactivity
      selected_vars = isolate({
        vars = c()
        if (input$select_prcp) vars = c(vars, "PRCP")
        if (input$select_tair) vars = c(vars, "TAIR")
        if (input$select_tmin) vars = c(vars, "TMIN")
        if (input$select_tmax) vars = c(vars, "TMAX")
        if (input$select_pet) vars = c(vars, "PET")
        if (input$select_aet) vars = c(vars, "AET")
        if (input$select_disch) vars = c(vars, "OBSQ")
        if (input$select_swe) vars = c(vars, "SWE")
        if (input$select_srad) vars = c(vars, "SRAD")
        if (input$select_vp) vars = c(vars, "VP")
        if (input$select_dayl) vars = c(vars, "DAYL")
        vars
      })

      if (length(selected_vars) == 0) {
        shinyalert::shinyalert(
          title = "Error",
          text = "No variables selected",
          type = "error"
        )
        return(data.frame(Message = "No data available"))
      }

      # get matching files and IDs from site selection 
      selected_site_ids = shared_data$mach_ids[shared_data$mach_ids %in% filtered_sites()]
      gauge_numbers = shared_data$mach_files[shared_data$mach_ids %in% selected_site_ids]

      if (length(gauge_numbers) == 0) {
        shinyalert::shinyalert(
          title = "Error",
          text = "No matching data files found",
          type = "error"
        )
        return(data.frame(Message = "No data available"))
      }

      
       # check for missing QS files
      missing_qs = sapply(selected_site_ids, function(gauge_id) {
        qs_file = file.path(shared_data$qs_cache_dir, paste0("basin_", gauge_id, "_MACH.qs"))
        !file.exists(qs_file)
      })
      if (any(missing_qs)) {
        shinyalert::shinyalert(
          title = "Error",
          text = "Click the 'Confirm Sites' button on the Site Selection tab to proceed.",
          type = "error"
        )
        return(data.frame(Message = "No data available"))
      }
      
      
      combined_df = tryCatch({
        withProgress(message = "Processing sites", value = 0, {
          purrr::map_dfr(seq_along(gauge_numbers), function(i) {
            file_path = gauge_numbers[i]
            gauge_id = stringr::str_extract(basename(file_path), "(?<=basin_)\\d{8}(?=_MACH\\.csv)")
            qs_file = file.path(shared_data$qs_cache_dir, paste0("basin_", gauge_id, "_MACH.qs"))
            incProgress(1 / length(gauge_numbers), detail = paste("Site", gauge_id))
            read_qs(qs_file, selected_vars, gauge_id, frequency = "daily")
          })
        })
      }, error = function(e) {
        shinyalert::shinyalert(
          title = "Error",
          text = paste("Error processing data:", e$message),
          type = "error"
        )
        return(data.frame(Message = "Error processing data"))
      })

      if (nrow(combined_df) == 0 || "Message" %in% colnames(combined_df)) {
        shinyalert::shinyalert(
          title = "Error",
          text = "No data available after processing",
          type = "error"
        )
        return(data.frame(Message = "No data available"))
      }

      # apply numeric filters with isolated inputs
      combined_df = isolate({
        df = combined_df
        df = apply_filters(df, selected_site_ids, "PRCP", input$select_prcp, input$prcp1)
        df = apply_filters(df, selected_site_ids, "TAIR", input$select_tair, input$tair1)
        df = apply_filters(df, selected_site_ids, "TMIN", input$select_tmin, input$tmin1)
        df = apply_filters(df, selected_site_ids, "TMAX", input$select_tmax, input$tmax1)
        df = apply_filters(df, selected_site_ids, "PET", input$select_pet, input$pet1)
        df = apply_filters(df, selected_site_ids, "AET", input$select_aet, input$aet1)
        df = apply_filters(df, selected_site_ids, "OBSQ", input$select_disch, input$disch1)
        df = apply_filters(df, selected_site_ids, "SWE", input$select_swe, input$swe1)
        df = apply_filters(df, selected_site_ids, "SRAD", input$select_srad, input$srad1)
        df = apply_filters(df, selected_site_ids, "VP", input$select_vp, input$vp1)
        df = apply_filters(df, selected_site_ids, "DAYL", input$select_dayl, input$dayl1)
        df
      })

      # apply date filter if selected
      if (isolate(input$select_date)) {
        combined_df = combined_df %>%
          dplyr::filter(DATE >= as.Date(isolate(input$date_range1[1])) &
                        DATE <= as.Date(isolate(input$date_range1[2])))
      }

      # apply year filter if selected
      if (isolate(input$select_year)) {
        selected_years = as.numeric(isolate(input$year1))
        if (isolate(input$select_date)) {
          date_start_year = lubridate::year(isolate(input$date_range1[1]))
          date_end_year = lubridate::year(isolate(input$date_range1[2]))
          if (!any(selected_years %in% seq(date_start_year, date_end_year))) {
            shinyalert::shinyalert(
              title = "Error",
              text = "Year not in date range",
              type = "error"
            )
            return(data.frame(Message = "No data available"))
          }
        }
        combined_df = combined_df %>%
          dplyr::filter(lubridate::year(DATE) %in% selected_years)
      }

      # apply month filter if selected
      if (isolate(input$select_month)) {
        combined_df = combined_df %>%
          dplyr::filter(lubridate::month(DATE) %in% as.numeric(isolate(input$month1)))
      }

      if (nrow(combined_df) == 0) {
        shinyalert::shinyalert(
          title = "Error",
          text = "No data matches the selected filters",
          type = "error"
        )
        return(data.frame(Message = "No data available"))
      }

      return(combined_df)
    })

    # render data table
    output$merged_data_table = renderDT({
      data = table()
      if ("Message" %in% colnames(data)) {
        DT::datatable(
          data,
          options = list(pageLength = 10, scrollX = TRUE, dom = "t"),
          class = "display responsive nowrap"
        )
      } else {
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
      }
    })



   # download the data displayed in the table as csv file if button is clicked 
  output$download_csv = downloadHandler(
    filename = function() {
      paste0("MACH_daily_", Sys.Date(), ".csv")
    },
    content = function(file) {
      withProgress(message = "Creating CSV file", value = 0, {
        for (i in 1:5) {           
        Sys.sleep(0.2)
                  incProgress(1/5)
                  }
      write.csv(table(), file, row.names = FALSE) 
    })
    }
  )

 # download the data displayed in the table as individual csv files if button is clicked    
output$download_separate = downloadHandler(
  filename = function() {
    paste0("MACH_daily_", Sys.Date(), ".zip")
  },
  content = function(file) {
    temp_dir = "basin_files/"
    dir.create(temp_dir, showWarnings = FALSE)
    unlink(paste0(temp_dir, "*"), recursive = TRUE)
    full_data = table()
    sites = unique(full_data$SITENO)
    n_sites = length(sites)
    withProgress(message = "Creating ZIP file", value = 0, {
      for (i in seq_along(sites)) {
        siteno = sites[i]
        data = full_data[full_data$SITENO == siteno, ]
        write.csv(data, file = paste0(temp_dir, "MACH_daily_", siteno, ".csv"), row.names = FALSE)
        incProgress(1 / n_sites)
      }
      zip::zip(
        zipfile = file,
        files = list.files(temp_dir, full.names = TRUE)
      )
    })
  }
)
  


  })
}
