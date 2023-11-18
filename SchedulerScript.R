# Function to run another R script and suppress messages
run_script <- function(script_path) {
  tryCatch({
    # Start timer
    start_time <- Sys.time()
    
    # Suppress messages while running the script
    suppressMessages(source(script_path))
    
    # End timer
    end_time <- Sys.time()
    time_taken <- difftime(end_time, start_time, units = "secs")
    
    # Custom success message
    message(paste("- DatenUndMarkdownUpdate.R ran successfully for the last time at exactly", end_time, 
                  "taking", time_taken, "seconds"))
  }, error = function(e) {
    # Error message
    message(paste("- Error running DatenUndMarkdownUpdate.R:", Sys.time(), e$message))
  })
}

# Infinite loop to keep running the script
while(TRUE) {
  # Specify the path to your script
  script_path <- "~/Desktop/websiteJuly2023/DatenUndMarkdownUpdate.R"
  
  # Run the script
  run_script(script_path)
  
  # Wait for 5 minutes (300 seconds) before the next run
  Sys.sleep(300)
}












