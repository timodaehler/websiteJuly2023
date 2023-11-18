# library(fredr)
# # Load necessary libraries
# library(plotly)
# library(dplyr)
# 
# # Fetch the data
# data_fred <- fredr(series_id = "FYFSGDA188S", observation_start = as.Date("1929-01-01"), observation_end = as.Date("2023-12-31"))
# 
# # Convert the data to a tibble for easier manipulation
# data_fred_tibble <- as_tibble(data_fred)
# 
# # Create a Plotly line plot
# plot_fred <- data_fred_tibble %>%
#   plot_ly(x = ~date, y = ~value, type = 'scatter', mode = 'lines') %>%
#   layout(
#          xaxis = list(title = "Fiscal Year"),
#          yaxis = list(title = "Federal Surplus/Deficit (% of GDP)"))
# 
# # Display the plot
# plot_fred





# Load necessary libraries
library(httr)
library(readr)
library(countrycode)


# URL for the OECD general government net lending/borrowing data
url <- "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.GGNLEND.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en"

# Downloading the data
response <- GET(url)

# Check if the download was successful
if (status_code(response) == 200) {
  # Reading the content of the response
  data <- content(response, "text", encoding = "UTF-8")
  
  # Writing the content to a temporary file
  tmp_file <- tempfile(fileext = ".csv")
  writeLines(data, tmp_file)
  
  # Reading the CSV file into a data frame
  oecd_data <- read_csv(tmp_file)
  
  # Displaying the first few rows of the data frame
  head(oecd_data)
} else {
  # Print an error message if the download failed
  print(paste("Error in data download: Status code", status_code(response)))
}


# oecd_data %>% 
#   filter(LOCATION == "USA") %>% view()


oecd_data$CountryName <- countrycode(oecd_data$LOCATION, "iso3c", "country.name")




recession_data <- fredr(series_id = "USREC", observation_start = as.Date("1900-01-01"))



# Assuming your data is in a data frame called 'oecd_data'
# Select specific countries using their ISO codes
selected_countries <- c("DEU", "CHE", "USA", "GBR", "CHN", "IND", "JPN")

# selected_countries <- c("CHE", "USA")

# Filter the data for the selected countries
filtered_data <- oecd_data %>%
  filter(LOCATION %in% selected_countries)

# Create a Plotly time series plot
plot <- filtered_data %>%
  plot_ly(x = ~TIME, y = ~Value, color = ~CountryName, type = 'scatter', mode = 'lines') %>%
  layout(
         xaxis = list(title = "Fiscal Year"),
         yaxis = list(title = "Net Lending/Borrowing (% of GDP)"),
         legend = list(title = list(text = 'Country')))

# Print the plot
plot

recession_data










