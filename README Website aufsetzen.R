library(devtools)
library(blogdown)


blogdown::install_hugo() 
# Die Version wird später noch wichtig sein: 
# The latest Hugo version is v0.115.4 

# Jetzt gehen wir auf https://themes.gohugo.io 
# # Wir wollen ein Theme dass kürzlich geupdated wurde 
# # Ich habe mich für das Academic Theme entschieden 

blogdown::new_site(theme = "wowchemy/starter-hugo-academic") 
# Jetzt wird die Website erstellt indem alle Ordner heruntergeladen werden 

# | Adding the sample post to content/post/2020-12-01-r-rmarkdown/index.en.Rmd
# | Converting all metadata to the YAML format
# | Adding netlify.toml in case you want to deploy the site to Netlify
# | Adding .Rprofile to set options() for blogdown
# ― The new site is ready
# ○ To start a local preview: use blogdown::serve_site(), or the RStudio add-in "Serve Site"
# ○ To stop a local preview: use blogdown::stop_server(), or restart your R session

# Wenn wir die Seite generiert haben, mache ich den ersten Commit. 
# Danach gehen wir zu Netlify.com. Da logge ich ein mit meinem Github Account
# 
# Dann add new site
# Import an existing project
# deploy with github
# Dann wähle ich das Project aus, in meinem Fall websiteJuly2023

# Build command muss "hugo" sein
# Public directory muss "public" sein
# 
# Danach noch eine Environment Variable > New Variable einfügen
# Key muss "HUGO_VERSION" sein und dann Value muss unsere Hugo Version sein: blogdown::hugo_version() 0.115.4

# Dann kann man auf Deploy Site klicken
# 
# Workflow ist aler folgender: Man bearbeitet die Seite in R/RStudio und kann sie anschauen. 
# Wenn man zufrieden ist, pushed man die Seite auf Github. 
# Netlify ruft Github alle paar Minuten ab und stellt die Seite dann online. 
# 
# Unter Site overview > Dommain management > Options > Edit Site name > 
# könnte man Domain ändern. Aber ich mache das im Moment nicht, da man 
# eine einmal gewählte Domain nicht mehr ändern kann. 
# 
# Der hat danach in config.toml die baserl auf seine url gesetzt



rm(list = ls())
gc()


library(rmarkdown)
library(blogdown)


stop_server()
# 
# library(rmarkdown)
# 
# knit_single_file <- function(file_path) {
#   tryCatch({
#     rmarkdown::render(input = file_path, quiet = TRUE)
#     message("Successfully knitted: ", file_path)
#   }, error = function(e) {
#     message("Failed to knit: ", file_path, "\n", "Error: ", e$message)
#   })
# }

# Use it like this
# knit_single_file("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/Bitcoin/index.Rmd")




get_index_paths <- function(directory) {
  # Search for 'index.Rmd' files in the directory and its subdirectories
  index_files <- list.files(directory, pattern = "index\\.Rmd$", recursive = TRUE, full.names = TRUE)
  return(index_files)
}

# Use the function like this:
index_paths <- get_index_paths("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/")
print(index_paths)




# knit_single_file <- function(file_path) {
#   tryCatch({
#     rmarkdown::render(input = file_path, quiet = TRUE)
#     message("Successfully knitted: ", file_path)
#   }, error = function(e) {
#     message("Failed to knit: ", file_path, "\n", "Error: ", e$message)
#   })
# }



# knit_single_file <- function(file_path) {
#   tryCatch({
#     rmarkdown::render(input = file_path, output_format = "md_document", quiet = TRUE)
#     message("Successfully knitted: ", file_path)
#   }, error = function(e) {
#     message("Failed to knit: ", file_path, "\n", "Error: ", e$message)
#   })
# }
# 
# knit_single_file("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project//PolicyRates/index.Rmd")
# 





knit_single_file <- function(file_path) {
  tryCatch({
    rmarkdown::render(
      input = file_path, 
      output_format = rmarkdown::md_document(variant = "gfm", preserve_yaml = TRUE),
      quiet = TRUE
    )
    message("Successfully knitted: ", file_path)
  }, error = function(e) {
    message("Failed to knit: ", file_path, "\n", "Error: ", e$message)
  })
}

# knit_single_file("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project//Bitcoin/index.Rmarkdown")





knit_all_index_files <- function(directory) {
  index_paths <- get_index_paths(directory)
  for (path in index_paths) {
    knit_single_file(path)
  }
}

# Knit all the index.Rmd files in the project folder and subfolders
knit_all_index_files("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/")


serve_site()
