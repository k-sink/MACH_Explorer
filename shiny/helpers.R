###################################
### GLOBAL FUNCTIONS ###
###################################

# create water year using date 
  wYear = function(date) {
  ifelse(month(date) < 10, year(date), year(date)+1)}

  
# create complete date to include missing OBSQ values as NA
  create_complete_dates = function(gauge_id, frequency = "daily") {
    complete_dates = switch(
      frequency,
      "daily" = seq.Date(from = as.Date("1980-01-01"), to = as.Date("2023-12-31"), by = "day"),
      "monthly" = seq.Date(from = as.Date("1980-01-01"), to = as.Date("2023-12-31"), by = "month"),
      "yearly" = seq.Date(from = as.Date("1980-01-01"), to = as.Date("2023-12-31"), by = "year"), 
      "wyearly" = seq.Date(from = as.Date("1980-10-01"), to = as.Date("2023-09-30"), by = "year")
    )
    data.frame(SITENO = gauge_id, DATE = complete_dates)
  }  

  
# read and format data with a complete date sequence, handles missing days
  read_and_format = function(file_path, variable_names, gauge_id, frequency = "daily") {
    complete_dates = create_complete_dates(gauge_id, frequency)
    if (file.exists(file_path)) {
     # df = read_csv(file_path, col_types = cols(
      #  SITENO = col_character(), 
       # DATE = col_date(), 
      #  .default = col_double()))
      df = qs::qread(file_path)  # for qs files instead of csv
      
      required_columns = c("SITENO", "DATE", variable_names)
      if (!all(required_columns %in% colnames(df))) {
        df_complete = complete_dates
        for (variable in variable_names) {
          df_complete[[variable]] = NA
        }
        return(df_complete)
      }
      df = df %>% 
        dplyr::select(SITENO, DATE, dplyr::all_of(variable_names))
      df_complete = dplyr::full_join(complete_dates, df, by = c("SITENO", "DATE"))
    df_complete = df_complete %>% arrange(DATE)
    return(df_complete) 
    } else {
      df_complete = complete_dates # if the file does not exist, return complete date sequence with NA
      for (variable in variable_names) {
        df_complete[[variable]] = NA
      }
      return(df_complete)
    }
  }


 # function to read qs files
read_qs <- function(qs_file, variable_names, gauge_id, frequency = "daily") {
  if (!file.exists(qs_file)) {
    stop("QS file does not exist: ", qs_file)
  }
  tryCatch({
    read_and_format(qs_file, variable_names, gauge_id, frequency)
  }, error = function(e) {
    stop("Failed to read QS file ", qs_file, ": ", e$message)
  })
} 
  
  

# conditionally apply filters based on the input values in the sliders    
apply_filters = function(df, gauge_numbers, var_name, input_check, range_input) {
  if(input_check) {
    df = df %>% 
      dplyr::filter(SITENO %in% gauge_numbers) %>% 
      dplyr::filter(is.na(.data[[var_name]]) |
          (.data[[var_name]] >= range_input[1] & .data[[var_name]] <= range_input[2])
      )
  }
  df
}   



# function to clear temporary directories on app closure
clear_temp_dirs <- function(mach_folder) {
  if (!is.null(mach_folder) && dir.exists(mach_folder)) {
    qs_cache_dir <- file.path(mach_folder, "qs_cache_temp")
    if (dir.exists(qs_cache_dir)) {
      unlink(qs_cache_dir, recursive = TRUE, force = TRUE)
    }
  }
  
  zip_dirs <- list.dirs(temp_dir(), full.names = TRUE, recursive = FALSE)
  zip_dirs <- zip_dirs[grepl("^zip_export_", basename(zip_dirs))]
  for (zip_dir in zip_dirs) {
    if (dir.exists(zip_dir)) {
      unlink(zip_dir, recursive = TRUE, force = TRUE)
    }
  }
}