# Dieses Skript führt zwei Skripte aus:
#
# DatenUndMarkdowUpdate.R
# AutomatedAddCommitAndPush.R
#
# DatenUndMarkdowUpdate.R führt alle R-Skripte aus und erstellt dann alle .Rmd-Dateien, 
# die Daten enthalten, welche von den R-Skripten importiert und verarbeitet wurden.
# Nach Ausführung von DatenUndMarkdowUpdate.R sind die neuesten Daten für die Website bereit.
#
# Sobald die neuesten Daten für die Website bereit sind, fügt das Skript AutomatedAddCommitAndPush.R 
# diese hinzu, führt einen Commit durch und lädt sie auf GitHub hoch.
#
# Netlify zieht dann alle paar Sekunden die neuesten Inhalte von GitHub und stellt die aktualisierte Website online.

# Endlosschleife, um das Skript kontinuierlich auszuführen
while(TRUE) {
  # Pfad des Skripts festlegen
  script_path <- "~/Desktop/websiteJuly2023/DatenUndMarkdownUpdate.R"
  
  # Funktion, um ein anderes R-Skript auszuführen und Nachrichten zu unterdrücken
  run_script <- function(script_path) {
    tryCatch({
      # Startzeit messen
      start_time <- Sys.time()
      
      # Nachrichten beim Ausführen des Skripts unterdrücken
      suppressMessages(source(script_path))
      
      # Endzeit messen
      end_time <- Sys.time()
      time_taken <- difftime(end_time, start_time, units = "secs")
      
      # Benutzerdefinierte Erfolgsmeldung
      message(paste("- DatenUndMarkdownUpdate.R wurde zuletzt erfolgreich ausgeführt um", end_time, 
                    ", Dauer:", time_taken, "Sekunden"))
    }, error = function(e) {
      # Fehlermeldung
      message(paste("- Fehler bei der Ausführung von DatenUndMarkdownUpdate.R:", Sys.time(), e$message))
    })
  }
  
  # Das Skript ausführen
  run_script(script_path)
  
  # AutomatedAddCommitAndPush.R ausführen. Dieses Added, Committed, und Pushed die gerade generierten, neuen Date. 
  source(glue(here::here(), "AutomatedAddCommitAndPush.R", .sep = "/"))
  
  # Warten, bevor der nächste Durchlauf beginnt
  Sys.sleep(10)
}

