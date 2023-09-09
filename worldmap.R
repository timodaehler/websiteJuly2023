# Load the leaflet package
library(leaflet)

# Create a data frame with stock index names and values
stock_data <- data.frame(
  index_name = c("S&P 500", "SMI", "Nikkei 225", "Äänekoski"),
  index_value = c(10000, 11000, 30000, 88),
  lat = c(37.09, 46.82, 36.20, 62.6),
  lng = c(-95.71, 8.23, 138.25, 25.7)
)

stock_data$country <- c("USA", "Switzerland", "Japan", "Finland")


# Generate the leaflet map
m <- leaflet(data = stock_data) %>%
  addProviderTiles(provider = "CartoDB.PositronNoLabels") %>%
  addCircles(
    lat = ~lat,
    lng = ~lng,
    radius = ~sqrt(index_value) * 100,
    label = ~paste0(index_name, ": ", index_value),  # Label without HTML/CSS styling
    # color = "red",
    labelOptions = labelOptions(noHide = TRUE, direction = 'auto', offset=c(0,0))
  )

# Show the map
m







# Load the quantmod package
library(quantmod)

# Define the Yahoo Finance symbols for the various indices
index_symbols <- c("^GSPC", "^DJI", "^IXIC", "^FTSE", "^FCHI", "^GDAXI", "^STOXX50E",
                   "^N225", "^HSI", "^SSEC", "^NSEI", "^AXJO", "^BVSP", "^JN0U.JO", "^SSMI", "^SPI")

# Initialize an empty data frame to store the index values
index_data <- data.frame(Date=as.Date(character(0)), Symbol=character(0), Close=numeric(0))

# Download the index values
for (symbol in index_symbols) {
  tryCatch({
    # Download data from Yahoo Finance
    get_data <- getSymbols(Symbols = symbol, src = "yahoo", auto.assign = FALSE)
    
    # Extract the closing prices and corresponding dates
    close_prices <- Cl(get_data)
    dates <- index(close_prices)
    
    # Create a data frame
    temp_data <- data.frame(Date = dates, Symbol = symbol, Close = as.numeric(close_prices))
    
    # Append to the index_data data frame
    index_data <- rbind(index_data, temp_data)
  }, 
  error = function(e) {
    message(paste("Couldn't fetch data for symbol:", symbol))
  })
}

# Show the data
head(index_data)

# Load the required packages
library(quantmod)
library(leaflet)
library(dplyr)

# ... (Your code for fetching index_data goes here)

# Extract the latest index values
latest_index_values <- index_data %>% group_by(Symbol) %>% filter(Date == max(Date))

# Define a mapping of index symbols to their names, countries, and coordinates
index_mapping <- data.frame(
  Symbol = c("^GSPC", "^DJI", "^IXIC", "^FTSE", "^FCHI", "^GDAXI", "^STOXX50E", "^N225", "^HSI", "^NSEI", "^AXJO", "^BVSP", "^JN0U.JO", "^SSMI", "^SPI"),
  index_name = c("S&P 500", "Dow Jones", "Nasdaq", "FTSE 100", "CAC 40", "DAX", "Euro Stoxx 50", "Nikkei 225", "Hang Seng", "Nifty 50", "ASX 200", "Bovespa", "JSE All Share", "Swiss Market Index", "Swiss Performance Index"),
  country = c("USA", "USA", "USA", "UK", "France", "Germany", "Europe", "Japan", "Hong Kong", "India", "Australia", "Brazil", "South Africa", "Switzerland", "Switzerland"),
  lat = c(40.7128, 40.7128, 40.7128, 51.5074, 48.8566, 52.5200, 50.8503, 35.6895, 22.3964, 28.6139, -33.8688, -23.5505, -26.2041, 46.8182, 46.8182),
  lng = c(-74.0060, -74.0060, -74.0060, -0.1278, 2.3522, 13.4050, 4.3517, 139.6917, 114.1095, 77.2090, 151.2093, -46.6333, 28.0473, 8.2275, 8.2275)
)

# Merge the latest index values with the index mapping
stock_data <- merge(index_mapping, latest_index_values, by = "Symbol")

# Generate the leaflet map
m <- leaflet(data = stock_data) %>%
  addProviderTiles(provider = "CartoDB.PositronNoLabels") %>%
  addCircles(
    lat = ~lat,
    lng = ~lng,
    radius = ~sqrt(Close) * 100,
    label = ~paste0("<b>", index_name, ": ", Close, "</b><br>Country: ", country),
    labelOptions = labelOptions(noHide = TRUE, direction = 'auto', offset=c(0,0))
  )

# Show the map
m

# Generate the leaflet map without bold tags
m <- leaflet(data = stock_data) %>%
  addProviderTiles(provider = "CartoDB.PositronNoLabels") %>%
  addCircles(
    lat = ~lat,
    lng = ~lng,
    radius = ~sqrt(Close) * 100,
    label = ~paste0(index_name, ": ", Close, "Country: ", country),  # removed the <b> tags
    labelOptions = labelOptions(noHide = TRUE, direction = 'auto', offset=c(0,0))
  )

# Show the map
m

# Generate the leaflet map without overlapping labels
m <- leaflet(data = stock_data) %>%
  addProviderTiles(provider = "CartoDB.PositronNoLabels") %>%
  addCircles(
    lat = ~lat,
    lng = ~lng,
    radius = ~sqrt(Close) * 100,
    popup = ~paste0(index_name, ": ", Close, "<br>Country: ", country)
  )

# Show the map
m



