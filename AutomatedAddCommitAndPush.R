
commit_and_push <- function(repo_path, commit_message) {
  tryCatch({
    # Open the repository
    repo <- repository(repo_path)
    
    # Add all changes to the staging area
    add(repo, "*")
    
    # Commit the changes
    commit(repo, commit_message)
    
    # Push to the remote repository
    # Assumes you have already set up remote and have the necessary permissions
    push(repo)
    
    message("Changes successfully pushed to GitHub at", Sys.time())
  }, error = function(e) {
    message("Failed to push changes to GitHub:", e$message)
  })
}

