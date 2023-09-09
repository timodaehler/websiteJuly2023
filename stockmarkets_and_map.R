# Load Packages
library(tidyquant)
library(tidyverse)
library(lubridate)

# List of Stock Indices (excluding the unavailable ones, and adding Wilshire 5000, Mexican Bolsa, and TSE)
indices <- c("^DJI", "^GSPC", "^IXIC", "^FTSE", "^GDAXI", "^FCHI", 
             "^STOXX50E", "^N225", "^HSI", "000001.SS", "^BSESN", 
             "^AXJO", "^BVSP", "^SSMI", "^W5000", "BOLSAA.MX", "^GSPTSE")

# Create a named vector to map index symbols to names
index_names <- c("^DJI" = "Dow Jones", "^GSPC" = "S&P 500", "^IXIC" = "NASDAQ",
                 "^FTSE" = "FTSE 100", "^GDAXI" = "DAX", "^FCHI" = "CAC 40", 
                 "^STOXX50E" = "Euro Stoxx 50", "^N225" = "Nikkei 225", "^HSI" = "Hang Seng",
                 "000001.SS" = "Shanghai Composite", "^BSESN" = "SENSEX",
                 "^AXJO" = "ASX 200", "^BVSP" = "Bovespa",
                 "^SSMI" = "Swiss Market Index (SMI)", "^W5000" = "Wilshire 5000",
                 "BOLSAA.MX" = "Mexican Bolsa", "^GSPTSE" = "Toronto Stock Exchange")

# Map index symbols to countries
index_countries <- c("^DJI" = "United States", "^GSPC" = "United States", "^IXIC" = "United States",
                     "^FTSE" = "United Kingdom", "^GDAXI" = "Germany", "^FCHI" = "France", 
                     "^STOXX50E" = "Europe", "^N225" = "Japan", "^HSI" = "Hong Kong",
                     "000001.SS" = "China", "^BSESN" = "India",
                     "^AXJO" = "Australia", "^BVSP" = "Brazil",
                     "^SSMI" = "Switzerland", "^W5000" = "United States",
                     "BOLSAA.MX" = "Mexico", "^GSPTSE" = "Canada")

# Date Range
start_date <- "2017-01-01"
end_date <- today()  # Today's date

# Fetch Data
index_data <- tq_get(indices, 
                     from = start_date,
                     to = end_date,
                     get = "stock.prices")

# Add index name and country based on the symbol
index_data <- index_data %>% 
  mutate(index_name = index_names[symbol],
         country = index_countries[symbol])

# View unique index names
unique(index_data$index_name)

# View Data
head(index_data)

index_data %>% distinct(country, index_name)





# Define function
get_index_summary <- function(index_data) {
  index_summary <- index_data %>%
    group_by(index_name, country) %>%
    filter(!is.na(close)) %>%  # Remove NA closing prices
    arrange(date) %>%
    summarise(
      most_recent_close = last(close),
      most_recent_date = last(date),
      last_year_close = last(close[date < ymd(paste(year(today()) - 1, "-12-31"))]),
      last_year_date = last(date[date < ymd(paste(year(today()) - 1, "-12-31"))]),
      one_year_ago_close = last(close[date <= (most_recent_date - years(1))]),
      one_year_ago_date = last(date[date <= (most_recent_date - years(1))]),
      two_years_ago_close = last(close[date <= (most_recent_date - years(2))]),
      two_years_ago_date = last(date[date <= (most_recent_date - years(2))]),
      three_years_ago_close = last(close[date <= (most_recent_date - years(3))]),
      three_years_ago_date = last(date[date <= (most_recent_date - years(3))]),
      five_years_ago_close = last(close[date <= (most_recent_date - years(5))]),
      five_years_ago_date = last(date[date <= (most_recent_date - years(5))])
    )
  
  return(index_summary)
}

# Generate the summary DataFrame
index_summary <- get_index_summary(index_data)

# Print out the DataFrame
print(index_summary)


# Create a new DataFrame with percentage changes
index_percentage_changes <- index_summary %>%
  mutate(
    ytd_percentage_change = ((most_recent_close - last_year_close) / last_year_close) * 100,
    one_year_percentage_change = ((most_recent_close - one_year_ago_close) / one_year_ago_close) * 100,
    two_year_percentage_change = ((most_recent_close - two_years_ago_close) / two_years_ago_close) * 100,
    three_year_percentage_change = ((most_recent_close - three_years_ago_close) / three_years_ago_close) * 100,
    five_year_percentage_change = ((most_recent_close - five_years_ago_close) / five_years_ago_close) * 100
  ) %>%
  select(country, index_name, ytd_percentage_change, one_year_percentage_change, two_year_percentage_change, three_year_percentage_change, five_year_percentage_change)

# Print out the new DataFrame
print(index_percentage_changes)

index_percentage_changes


# Install required packages if not already installed
if (!requireNamespace("leaflet", quietly = TRUE)) {
  install.packages("leaflet")
}

# Load packages
library(leaflet)

# Create a dataset with country latitude and longitude information
# Updated country_lat_lon dataframe with all countries from index_percentage_changes
country_lat_lon <- data.frame(
  country = c("Australia", "Brazil", "France", "Germany", "United States", "Europe", "United Kingdom", "Hong Kong", "Mexico", "Japan", "India", "China", "Switzerland", "Canada"),
  latitude = c(-25.2744, -14.2350, 46.6034, 51.1657, 37.0902, 51.1657, 55.3781, 22.3964, 23.6345, 36.2048, 20.5937, 35.8617, 46.8182, 56.1304),
  longitude = c(133.7751, -51.9253, 2.3522, 10.4515, -95.7129, 10.4515, -3.4360, 114.1095, -102.5528, 138.2529, 78.9629, 104.1954, 8.2275, -106.3468)
)


# Merge the dataframes based on the country column
final_data <- merge(index_percentage_changes, country_lat_lon, by = "country")

# Manually adjust coordinates for specific indices to avoid overlap
final_data <- 
  final_data %>%
  mutate(
    latitude = case_when(
      index_name == "FTSE 100" ~ 60,  # Move more towards North Atlantic
      index_name == "CAC 40" ~ 42,   # Move more towards South West
      index_name == "DAX" ~ 54,      # Move more towards North East
      index_name == "Swiss Market Index (SMI)" ~ 50, # Move more towards North East
      index_name == "Euro Stoxx 50" ~ 60,  # Move more towards North East
      index_name == "SENSEX" ~ 10,   # Move Indian index more South
      index_name == "Nikkei 225" ~ 45, # Move Japan further Northeast
      TRUE ~ latitude
    ),
    longitude = case_when(
      index_name == "FTSE 100" ~ -30, # Move more towards North Atlantic
      index_name == "CAC 40" ~ -10,  # Move more towards South West
      index_name == "DAX" ~ 20,      # Move more towards North East
      index_name == "Swiss Market Index (SMI)" ~ 20, # Move more towards North East
      index_name == "Euro Stoxx 50" ~ 40,  # Move more towards North East
      index_name == "SENSEX" ~ 80,   # Keep longitude the same for the Indian index
      index_name == "Nikkei 225" ~ 160, # Move Japan further Northeast
      TRUE ~ longitude
    )
  )

# Create Leaflet map
leaflet(agg_data) %>%
  addProviderTiles(providers$OpenStreetMap) %>%
  addCircleMarkers(
    lng = ~longitude,
    lat = ~latitude,
    popup = ~sprintf(
      "<strong>Country:</strong> %s <br> %s",
      country,
      popup_text
    ),
    label = ~sprintf("<strong>Country:</strong> %s <br> %s", country, popup_text),
    labelOptions = labelOptions(noHide = TRUE, direction = 'auto')
  )








