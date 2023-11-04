


# Alles aus dem Memory löschen
rm(list = ls())
gc()
(begin <- Sys.time())

# Die notwendigen Pakete laden 
library(rmarkdown)
library(devtools)
library(blogdown)


# blogdown::install_hugo() 
# Die Version wird später noch wichtig sein: 
# The latest Hugo version is v0.115.4 

# Jetzt gehen wir auf https://themes.gohugo.io 
# # Wir wollen ein Theme dass kürzlich geupdated wurde 
# # Ich habe mich für das Academic Theme entschieden 

# blogdown::new_site(theme = "wowchemy/starter-hugo-academic") 
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





stop_server()



# Funktion definieren, die Liste aller R Skripte erstellt
list_r_scripts <- function(directory) {
  # Get the full paths of all files in the directory
  files <- list.files(directory, full.names = TRUE, recursive = FALSE)
  # Filter for files that end with the .R extension (case insensitive)
  r_scripts <- grep("\\.R$", files, value = TRUE, ignore.case = TRUE)

  # Print the scripts to the console
  cat("R scripts found:\n")
  if (length(r_scripts) > 0) {
    cat(r_scripts, sep = "\n")
  } else {
    cat("No R scripts found in the directory.\n")
  }

  return(r_scripts)
}

# Funktion verwenden um Liste aller R Skripte zu erstellen
scripts_to_run <- list_r_scripts("/Users/timodaehler_1/Desktop/websiteJuly2023/R")


# Funktion definieren, die Liste aller R Skripte basierend auf Vektor "scripts_to_run" ausfuert
run_r_scripts <- function(scripts_to_run) {
  # Check if scripts_to_run is not NULL or has length 0
  if (is.null(scripts_to_run) || length(scripts_to_run) == 0) {
    cat("No scripts to run.\n")
    return()
  }

  # Iterate over each script path
  for (script in scripts_to_run) {
    cat("Running:", script, "...\n")

    # Try sourcing the script and catch any errors
    tryCatch({
      source(script)
      # If sourcing is successful, print a success message
      cat("Success: The script", basename(script), "ran without errors.\n")
    }, error = function(e) {
      # If an error occurs, print an error message
      cat("Error in", basename(script), ":", e$message, "\n")
    }, warning = function(w) {
      # If a warning occurs, print a warning message
      cat("Warning in", basename(script), ":", w$message, "\n")
    }, finally = {
      # This block runs after either try or catch block
      cat("Finished attempting to run", basename(script), "\n\n")
    })
  }
}


# scripts_to_run <- scripts_to_run %>% head(n = 1)


run_r_scripts(scripts_to_run)




# Alle .Rmd Files updaten respektive knitten ------------------------------
# Hier schreibe ich eine Funktion die mir die Pfade zu allen index.Rmd Files gibt. 
# Diese Files beinhalten die einzelnen Blogposts, die theoretisch täglich updaten sollte. 
get_index_paths <- function(directory) {
  # 'index.Rmd' Dateien im Verzeichnis und seinen Unterverzeichnissen suchen
  index_files <- list.files(directory, pattern = "index\\.Rmd$", recursive = TRUE, full.names = TRUE)
  # Die gefundenen Pfade zurückgeben
  return(index_files)
}

# Die Funktion anwenden, um die Pfade zu erhalten:
index_paths <- get_index_paths("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/")

# Die gefundenen Pfade ausdrucken
print(index_paths)


# Eine Funktion definieren, um eine einzelne Rmd-Datei zu stricken (knit)
knit_single_file <- function(file_path) {
  tryCatch({
    # Versuchen, die Rmd-Datei zu rendern und das Ergebnis als Markdown-Datei zu speichern
    rmarkdown::render(
      input = file_path, 
      output_format = rmarkdown::md_document(variant = "gfm", preserve_yaml = TRUE),
      quiet = TRUE
    )
    # Erfolgsmeldung ausgeben, wenn das Stricken erfolgreich war
    message("Erfolgreich gestrickt: ", file_path)
  }, error = function(e) {
    # Fehlermeldung ausgeben, wenn das Stricken fehlgeschlagen ist
    message("Stricken fehlgeschlagen: ", file_path, "\n", "Fehler: ", e$message)
  })
}

# Eine einzelne Rmd-Datei stricken (Beispiel auskommentiert)
# knit_single_file("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project//Bitcoin/index.Rmd")



# Eine Funktion definieren, um alle 'index.Rmd' Dateien in einem Verzeichnis zu stricken
knit_all_index_files <- function(directory) {
  # Die Pfade zu allen 'index.Rmd' Dateien holen
  index_paths <- get_index_paths(directory)
  # Über die Pfade iterieren und jede Datei einzeln stricken
  for (path in index_paths) {
    knit_single_file(path)
  }
}

# Alle 'index.Rmd' Dateien im Projektordner und dessen Unterverzeichnissen stricken
knit_all_index_files("/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/")


stop_server()
serve_site()


(end <- Sys.time())

# end - begin

