# Load required libraries
library(rvest)
library(stringr)
library(dplyr)
library(clipr)
library(tictoc)
library(readr)
library(dplyr)
library(zoo)
library(WDI)
library(readxl)

# Display the full number instead of scientific notation
options(scipen = 999)

# Specify the file path
file_path <- "/Users/timodaehler_1/Desktop/websiteJuly2023/R/ISIN und Namen von SPI Unternehmen.xlsx"

# Read the data from Sheet2
my_data <- read_excel(file_path, sheet = "Sheet2")

# Fetch Ticker and CompanyName based on ISIN
tic()
for (isin in my_data$ISIN) {
  url <- paste0("https://www.six-group.com/en/products-services/the-swiss-stock-exchange/market-data/shares/share-explorer/share-details.", isin, "CHF4.html#/")
  twitter_title_tag <- read_html(url) %>% html_nodes(xpath = '//meta[@property="twitter:title"]') %>% html_attr('content')
  
  extracted_symbol <- str_extract(twitter_title_tag, "(?<= - )[A-Z]+(?= \\|)")
  
  my_data[my_data$ISIN == isin, "Ticker"] <- extracted_symbol
  
  Sys.sleep(1.5)
}
toc()

# Function to fetch market cap from Yahoo Finance
fetch_market_cap <- 
  function(ticker) {
  url <- paste0("https://finance.yahoo.com/quote/", ticker, ".SW?p=", ticker, ".SW&.tsrc=fin-srch")
  tryCatch({
    web_content <- read_html(url)
    market_cap <- web_content %>%
      html_nodes("td[data-test='MARKET_CAP-value']") %>%
      html_text()
    return(market_cap)
  }, error = function(e) {
    message(sprintf("Error fetching data for %s: %s", ticker, e$message))
    return(NA)
  })
}

# Fetch market cap based on the newly-added Ticker column
tic()
my_data$MarketCap <- 
  sapply(my_data$Ticker, fetch_market_cap)
toc()

# Convert MarketCap to a numeric representation
my_data <- 
  my_data %>%
  mutate(
    MarketCapClean = str_remove_all(MarketCap, ","),
    MarketCapNumeric = case_when(
      str_ends(MarketCapClean, "B") ~ as.numeric(str_extract(MarketCapClean, "[0-9.]+")) * 1e9,
      str_ends(MarketCapClean, "M") ~ as.numeric(str_extract(MarketCapClean, "[0-9.]+")) * 1e6,
      TRUE ~ as.numeric(MarketCapClean) # Keep the original value if it doesn't end in "B" or "M"
    )
  ) %>%
  select(-MarketCapClean)

# Export and reimport data
# saveRDS(my_data, "data_market_cap.rds")
my_data <- readRDS("data_market_cap.rds")

# Calculate the total market capitalization of SPI across all companies and then also display it in billions
total_market_cap_SPI <- sum(my_data$MarketCapNumeric, na.rm = TRUE)  # na.rm = TRUE removes any NA values before summing
total_market_cap_SPI_bn <- total_market_cap_SPI/1E9

# Print the total market capitalization of SPI
print(paste("Total Market Capitalization of SPI (bn): ", total_market_cap_SPI_bn))

# Retrieve the current system date and format it
# update_date <- Sys.Date()
# formatted_today_date <- format(update_date, format = "%d %B %Y")

# Define the URL where the data is hosted
url <- "https://data.snb.ch/api/cube/capchstocki/data/csv/de"

# Fetch the data and convert it to a data frame
data <- read_csv(url, show_col_types = FALSE) %>% data.frame()

# Extract column names from the second row and adjust the data accordingly
col_names <- unlist(strsplit(as.character(data[2, "CubeId.capchstocki"]), ";"))
data <- data[-c(1, 2), ]
data <- data %>% data.frame()

# Separate the columns based on the ";" delimiter
data <- separate(data, col = ".",  into = col_names, sep = ";")

# Replace empty Policy Rate values with NA and convert the values to numeric, also adjusting the scale
# data <- data %>% mutate(`Policy Rate` = ifelse(`Policy Rate` == "", NA, `Policy Rate`))
# data$`Policy Rate` <- as.numeric(data$`Policy Rate`) / 100
data <- 
  data %>% 
  filter(D0 == "GDR")

# Ensure the Value column is of numeric type (if it is not already)
data$Value <- as.numeric(data$Value)

# Identify the latest index value (i.e., the last value in the Value column)
latest_index_value <- tail(data$Value, n=1)

# Normalize the Value column by dividing each value by the latest index value
# Then multiply by the current total market cap of the SPI to get the estimated total market cap
data$Estimated_MarketCap <- (data$Value / latest_index_value) * total_market_cap_SPI

# Create new variable that is market cap in billions for ease of reading
data <- 
  data %>% 
  mutate(Estimated_MarketCap_bn = Estimated_MarketCap/1e9)

# Reformat DAte
data$Date <- 
  as.Date(data$Date, format = "%Y-%m-%d")  # adjust the format according to your data

# Fill up missing values so that the lines in the chart are uninterrupted
data$Estimated_MarketCap <- 
  na.approx(data$Estimated_MarketCap, na.rm = FALSE)

# Fill up missing values so that the lines in the chart are uninterrupted
data$Estimated_MarketCap_bn <- 
  na.approx(data$Estimated_MarketCap_bn, na.rm = FALSE)

# Fetch the nominal GDP (in current US dollars) for Switzerland
# Indicator code for nominal GDP: 'NY.GDP.MKTP.CD'
swiss_gdp_data <- WDI(country="CHE", indicator="NY.GDP.MKTP.CD")

# Convert the year to a Date object in swiss_gdp_data
swiss_gdp_data$Date <- as.Date(paste0(swiss_gdp_data$year, "-12-31"))

# Merge the data based on Date
joined_data_swiss <- merge(data, swiss_gdp_data, by = "Date", all.x = TRUE)

# Interpolate missing GDP values
joined_data_swiss$NY.GDP.MKTP.CD <- na.approx(joined_data_swiss$NY.GDP.MKTP.CD, rule = 2)

# Compute the Buffett Indicator for Switzerland
joined_data_swiss$Buffett_Indicator_Swiss <- (joined_data_swiss$Estimated_MarketCap / joined_data_swiss$NY.GDP.MKTP.CD) * 100

# Remove NAs in Buffett Indicator
joined_data_swiss <- joined_data_swiss %>% drop_na(Buffett_Indicator_Swiss)

# Fit an exponential model (linear on log-transformed y-values)
fit_swiss <- lm(log(Buffett_Indicator_Swiss) ~ Date, data = joined_data_swiss)

# Generate predictions
joined_data_swiss$predicted <- exp(predict(fit_swiss))

median_value_swiss <- median(joined_data_swiss$Buffett_Indicator_Swiss, na.rm = TRUE)


# Plot using plotly
plot_ly() %>%
  add_trace(data = joined_data_swiss, x = ~Date, y = ~Buffett_Indicator_Swiss, type = "scatter", mode = "lines", name = "Buffett Indicator") %>%
  add_trace(data = joined_data_swiss, x = ~Date, y = ~predicted, type = "scatter", mode = "lines", line = list(color = 'red'), name = "Historical Trend Line") %>%
  layout(title = "Buffett Indicator for Switzerland Over Time with Historical Trend Line",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Market Cap to GDP Ratio"),
         shapes = list(
           list(type = "line",
                x0 = min(joined_data_swiss$Date),
                x1 = max(joined_data_swiss$Date),
                y0 = median_value_swiss,
                y1 = median_value_swiss,
                line = list(color = "black", width = 2, dash = "dash"))
         ))


