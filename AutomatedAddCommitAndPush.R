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
repo_path <- "~/Desktop/websiteJuly2023/"

# Set the commit message
commit_message <- paste("Automated commit and push on", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))

# Call the function
commit_and_push(repo_path, commit_message)
