library(rvest)

# Given list of ticker symbols
tickers <- c("UBSG", "SREN", "ZURN")

# Function to fetch market cap from Yahoo Finance
fetch_market_cap <- function(ticker) {
  url <- paste0("https://finance.yahoo.com/quote/", ticker, ".SW?p=", ticker, ".SW&.tsrc=fin-srch")
  
  # Try fetching the data and handle potential errors
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

# Create an empty data frame to store results
results <- data.frame(Ticker = character(), MarketCap = character(), stringsAsFactors = FALSE)

# Fetch and store market cap for each ticker
for (ticker in tickers) {
  market_cap_value <- fetch_market_cap(ticker)
  
  # Append to results data frame
  results <- rbind(results, data.frame(Ticker = ticker, MarketCap = market_cap_value, stringsAsFactors = FALSE))
  
  # Wait for 3 seconds between requests
  Sys.sleep(3)
}

# View results
print(results)





library(rvest)

# Given list of ticker symbols
tickers <- c("UBSG", "SREN", "ZURN")

# Function to fetch market cap from Yahoo Finance
fetch_market_cap <- function(ticker) {
  url <- paste0("https://finance.yahoo.com/quote/", ticker, ".SW?p=", ticker, ".SW&.tsrc=fin-srch")
  
  # Try fetching the data and handle potential errors
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

# Create an empty data frame to store results
results <- data.frame(Ticker = character(), MarketCap = character(), stringsAsFactors = FALSE)

# Fetch and store market cap for each ticker
for (ticker in tickers) {
  market_cap_value <- fetch_market_cap(ticker)
  
  # Append to results data frame
  results <- rbind(results, data.frame(Ticker = ticker, MarketCap = market_cap_value, stringsAsFactors = FALSE))
  
  # Wait for 3 seconds between requests
  Sys.sleep(3)
}

# View results
print(results)

