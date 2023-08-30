library(dplyr)
library(stringr)


my_vector <- read_clip()

# Select only the ISINs, which are in the even positions in the vector
selected_isins <- my_vector[seq(2, length(my_vector), by = 2)]

# Print the selected ISINs
print(selected_isins)









# Load required libraries
library(rvest)
library(stringr)

# Fetch Ticker and CompanyName
isin_list <- 
  selected_isins
#   c(
#   "CH0012221716",
#   "CH1169360919",
#   "CH0522213468",
#   "CH0029850754",
#   "CH0012138605",
#   "CH0008967926",
#   "CH0478634105",
#   "CH0010947627",
#   "CH0432492467",
#   "CH0008837566",
#   "CH0024590272"
# )

extracted_data <- data.frame(Ticker = character(), CompanyName = character(), stringsAsFactors = FALSE)

for (isin in isin_list) {
  url <- paste0("https://www.six-group.com/en/products-services/the-swiss-stock-exchange/market-data/shares/share-explorer/share-details.", isin, "CHF4.html#/")
  twitter_title_tag <- read_html(url) %>% html_nodes(xpath = '//meta[@property="twitter:title"]') %>% html_attr('content')
  
  extracted_symbol <- str_extract(twitter_title_tag, "(?<= - )[A-Z]+(?= \\|)")
  extracted_name <- str_extract(twitter_title_tag, "^[^ -]+")
  
  extracted_data <- rbind(extracted_data, data.frame(Ticker = extracted_symbol, CompanyName = extracted_name, stringsAsFactors = FALSE))
}

# Function to fetch market cap from Yahoo Finance
fetch_market_cap <- function(ticker) {
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

# Initialize final results data frame
final_results <- data.frame(Ticker = character(), CompanyName = character(), MarketCap = character(), stringsAsFactors = FALSE)

# Loop through each extracted ticker to fetch market cap
for (i in 1:nrow(extracted_data)) {
  ticker <- extracted_data$Ticker[i]
  company_name <- extracted_data$CompanyName[i]
  
  market_cap_value <- fetch_market_cap(ticker)
  
  # Append to final results data frame
  final_results <- rbind(final_results, data.frame(Ticker = ticker, CompanyName = company_name, MarketCap = market_cap_value, stringsAsFactors = FALSE))
  
  # Be respectful to the website's resources
  Sys.sleep(3)
}

# View final results
print(final_results)











final_results_test <- 
  final_results %>%
  mutate(
    MarketCapClean = str_remove_all(MarketCap, ","),
    MarketCapNumeric = case_when(
      str_ends(MarketCapClean, "B") ~ as.numeric(str_extract(MarketCapClean, "[0-9.]+")) * 1e9,
      str_ends(MarketCapClean, "M") ~ as.numeric(str_extract(MarketCapClean, "[0-9.]+")) * 1e6,
      TRUE ~ as.numeric(MarketCapClean) # Keep the original value if it doesn't end in "B" or "M"
    )
  ) %>%
  select(-MarketCapClean)

# Set scipen option to make R less likely to use scientific notation
options(scipen = 999)

# Now when you print your data frame, the numbers should be displayed in full
print(final_results_test)

final_results_test <- 
  final_results_test %>% 
  mutate(MarketCapNumericMillions = MarketCapNumeric / 1E6, 
         MarketCapNumericBillions = MarketCapNumeric/1E9 )


print(final_results_test)









my_data <- read_clip_tbl()
# 
# # Separate the vector into companies and ISINs based on their position
# companies <- my_vector[seq(1, length(my_vector), by = 2)]
# isins <- my_vector[seq(2, length(my_vector), by = 2)]
# my_df <- data.frame(Company = companies, ISIN = isins)
# my_df
# 
# clipr::write_clip(my_df)



