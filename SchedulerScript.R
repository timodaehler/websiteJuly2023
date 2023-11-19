
# Infinite loop to keep running the script
while(TRUE) {
  # Specify the path to your script
  script_path <- "~/Desktop/websiteJuly2023/DatenUndMarkdownUpdate.R"
  
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
  
  
  
  # Run the script
  run_script(script_path)
  
  
  
  
  library(git2r)
  
  commit_and_push <- function(repo_path, commit_message) {
    repo <- repository(repo_path)
    
    # Check if there are uncommitted changes
    if (length(status(repo)$staged) == 0 && length(status(repo)$unstaged) == 0) {
      message("No changes to commit at", Sys.time())
      return()
    }
    
    tryCatch({
      add(repo, "*")  # Add all changes
      commit(repo, commit_message)  # Commit changes
      push(repo)  # Push to remote
      
      message("Changes successfully pushed to GitHub at", Sys.time())
    }, error = function(e) {
      message("Failed to push changes to GitHub:", e$message)
    })
  }
  
  # Set the path to your local Git repository
  repo_path <- "/Users/timodaehler_1/Desktop/websiteJuly2023"
  
  # Set the commit message
  commit_message <- paste("Automated commit and push on", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))
  
  # Call the function
  commit_and_push(repo_path, commit_message)
  
  
  
  
  
  
  
  
  # Wait for 100 seconds before the next run
  Sys.sleep(10000)
}












