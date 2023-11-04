



if (!require("quantmod")) {
  install.packages("quantmod")
}
library(quantmod)



# Update date
saveRDS(Sys.time(), "content/project/PPPvsMarketFXRate/PPPvsMarketFXRate1_update_date.rds")


# Set base currency and target currencies
base_currency <- "CHF"
target_currencies <- c("EUR", "USD", "JPY", "GBP", "CNY", "INR")

# Initialize a list to store the exchange rate data
exchange_rates_list <- list()

# Function to fetch and store exchange rates
get_exchange_rates <- function(base, target, start_date, end_date) {
  currency_pair <- paste0(base, target, "=X") # Format required by Yahoo Finance
  getSymbols(currency_pair, src = "yahoo", from = start_date, to = end_date, auto.assign = FALSE)
}

# Loop over the target currencies and fetch the data
for (currency in target_currencies) {
  cat("Fetching data for", currency, "\n")
  exchange_rates_list[[currency]] <- tryCatch({
    get_exchange_rates(base_currency, currency, "2000-01-01", Sys.Date())
  }, error = function(e) {
    cat("Error fetching data for", currency, ":", e$message, "\n")
    NULL # Return NULL if there was an error
  })
}

# Check the structure of the first element in the list as an example
if (length(exchange_rates_list) > 0) {
  print(head(exchange_rates_list[[1]]))
}


# Load required library
library(xts)

# Function to extract the closing prices and convert them to a data frame
extract_and_merge_closing_prices <- function(rates_list) {
  # List to store closing prices of each currency
  closing_prices_list <- list()
  
  # Extract closing prices for each currency pair
  for (currency in names(rates_list)) {
    closing_prices <- Cl(rates_list[[currency]]) # Cl is a function from quantmod to get closing prices
    colnames(closing_prices) <- currency # Rename the column to the currency code
    closing_prices_list[[currency]] <- closing_prices
  }
  
  # Merge all the closing prices by date
  merged_closing_prices <- do.call(merge, closing_prices_list)
  
  # Convert to a data frame
  closing_prices_df <- data.frame(date=index(merged_closing_prices), coredata(merged_closing_prices))
  
  return(closing_prices_df)
}

# Create the dataframe
exchange_rates_df <- extract_and_merge_closing_prices(exchange_rates_list)

# View the first few rows of the dataframe
head(exchange_rates_df)









# --------------------------------------------------------------

# Load necessary libraries
library(priceR)
library(ggplot2)
library(tidyr)
library(hrbrthemes)
library(lubridate)
library(WDI)
library(dplyr)
library(scales)
library(plotly)
library(RColorBrewer)
library(htmlwidgets)

# # Assuming you have today's date in a variable like this:
# update_date <- Sys.Date()  # This gives today's date
# 
# # Format today's date in a readable format:
# formatted_today_date <- format(update_date, format = "%d %B %Y")  # e.g., "05 August 2023"
# 
# # Set base currency and a vector of target currencies
# base_currency <- "CHF"
# target_currencies <- c("EUR", "USD", "JPY", "GBP", "CNY", "INR") # Added "CNY" and "INR"
# 
# 
# # Create an empty list to store the exchange rate data for each target currency
# exchange_rates_list <- list()
# 
# # Loop through each target currency to fetch historical exchange rates from the base currency
# for (currency in target_currencies) {
#   # Fetch historical rates for current currency in the loop
#   exchange_data <-
#     historical_exchange_rates(
#       base_currency,
#       to = currency,
#       start_date = "2000-01-01",
#       end_date = Sys.Date()
#     )
#   
#   # Store this data in our list, indexed by the currency name
#   exchange_rates_list[[currency]] <- exchange_data
# }
# 
# # Rename the 'rate' column of each dataframe in our list to the respective currency name
# for (i in seq_along(target_currencies)) {
#   colnames(exchange_rates_list[[i]])[2] <- target_currencies[i]
# }
# 
# # Collapse all dataframes in the list by 'date' into a single dataframe
# fx_rates <-
#   Reduce(function(x, y)
#     merge(x, y, by = "date", all = TRUE), exchange_rates_list)


# Import PPP data ---------------------------------------------------------
ppp_data <-
  WDI(
    country = c("CHE", "USA", "DEU", "JPN", "GBR", "CHN", "IND"),  # Added "CHN" and "IND"
    indicator = "PA.NUS.PPP",
    start = 1999,
    end = 2023
  )

ppp_data <-
  ppp_data %>%
  select(year, country, PA.NUS.PPP) %>% # Selecting the necessary columns
  spread(key = country, value = PA.NUS.PPP) # Spreading the data based on country

# Calculate ratios relative to Switzerland --------------------------------
ppp_data <-
  ppp_data %>%
  mutate(
    EUR = Germany / Switzerland,
    USD = `United States` / Switzerland,
    JPY = Japan / Switzerland,
    GBP = `United Kingdom` / Switzerland,
    CNY = China / Switzerland,         # Added this line for China
    INR = India / Switzerland          # Added this line for India
  ) %>%
  select(year, EUR, JPY, GBP, USD, CNY, INR)  # Added CNY and INR to selection

# Convert the year column to date
ppp_data$date <-
  as.Date(paste0(ppp_data$year, "-12-31"))

# Create a sequence of daily dates from 1.1.2020 to 30.6.2023
all_dates <-
  seq(as.Date("2020-01-01"), as.Date("2023-06-30"), by = "days")

# Use the zoo package to interpolate data
interpolated_data <-
  as.data.frame(approx(ppp_data$date, ppp_data$EUR, all_dates))
colnames(interpolated_data) <- c("date", "EUR")
for (currency in c("JPY", "GBP", "USD", "CNY", "INR")) {  # Added "CNY" and "INR" to the loop
  temp <-
    as.data.frame(approx(ppp_data$date, ppp_data[[currency]], all_dates))
  interpolated_data[[currency]] <- temp$y
}

# View the data
head(interpolated_data)


# Generate a sequence of daily dates from the start to end of your data
all_dates <-
  seq(as.Date("1999-12-31"), as.Date("2022-12-31"), by = "day")

# # Interpolate for EUR (can repeat this for other currencies)
# interpolated_EUR <-
#   approx(ppp_data$date, ppp_data$EUR, xout = all_dates)

# Initialize df_daily with just the date sequence
df_daily <- data.frame(date = all_dates)

# Interpolate for all currencies including EUR
for (currency in c("EUR", "JPY", "GBP", "USD", "CNY", "INR")) {
  y <- approx(ppp_data$date, ppp_data[[currency]], xout = all_dates)$y
  df_daily[[currency]] <- y
}

# Filter dataframe for 2022 data
df_2022 <-
  df_daily[df_daily$date >= "2022-01-01" &
             df_daily$date <= "2022-12-31",]

# Compute average daily difference for each currency in 2022
avg_diff_EUR <- mean(diff(df_2022$EUR))
avg_diff_JPY <- mean(diff(df_2022$JPY))
avg_diff_GBP <- mean(diff(df_2022$GBP))
avg_diff_USD <- mean(diff(df_2022$USD))
avg_diff_CNY <- mean(diff(df_2022$CNY))  # Added this line for China
avg_diff_INR <- mean(diff(df_2022$INR))  # Added this line for India


# Generate sequence of dates for the first half of 2023
future_dates <-
  seq(from = as.Date("2023-01-01"),
      to = as.Date(Sys.Date()),
      by = "days")

# Create a data frame for these future dates
future_df <- data.frame(date = future_dates)

# Compute extrapolated values using the last value of 2022 and the average difference
future_df$EUR <-
  tail(df_2022$EUR, 1) + cumsum(rep(avg_diff_EUR, length(future_dates)))
future_df$JPY <-
  tail(df_2022$JPY, 1) + cumsum(rep(avg_diff_JPY, length(future_dates)))
future_df$GBP <-
  tail(df_2022$GBP, 1) + cumsum(rep(avg_diff_GBP, length(future_dates)))
future_df$USD <-
  tail(df_2022$USD, 1) + cumsum(rep(avg_diff_USD, length(future_dates)))
future_df$CNY <-   # Added this line for China
  tail(df_2022$CNY, 1) + cumsum(rep(avg_diff_CNY, length(future_dates)))
future_df$INR <-   # Added this line for India
  tail(df_2022$INR, 1) + cumsum(rep(avg_diff_INR, length(future_dates)))

# Combine the original dataframe with the extrapolated dataframe
df_daily <- rbind(df_daily, future_df)

# Assuming you have fx_rates from the previous code, add the year extraction:
fx_rates <- exchange_rates_df %>%
  mutate(year = year(date))

# Merge the two dataframes
combined_data <-
  left_join(fx_rates, df_daily, by = c("date" = "date"))

# Convert the data to a long format for ggplot
fx_rates_vs_ppp_implied_rates <- 
  combined_data %>%
  gather(key = "type_value", value = "rate", EUR.x:INR.x, EUR.y:INR.y) %>%  # Added CNY and INR to selection
  separate(type_value,
           into = c("currency", "type"),
           sep = "\\.")

fx_rates_vs_ppp_implied_rates <- 
  fx_rates_vs_ppp_implied_rates %>%
  mutate(type = case_when(
    type == "x" ~ "Market Rate",
    type == "y" ~ "PPP-Implied Rate",
    TRUE ~ type
  ))

# Fetch the Set1 colors
set1_colors <- brewer.pal(length(unique(fx_rates_vs_ppp_implied_rates$currency)), "Set1")

# Split the data by currency
currencies <- unique(fx_rates_vs_ppp_implied_rates$currency)
plots_list <- list()

color_counter <- 1  # Initialize a counter to assign Set1 colors to each currency

for (curr in currencies) {
  subset_data <- subset(fx_rates_vs_ppp_implied_rates, currency == curr)
  
  # Modify the type column to include currency
  subset_data$type <- paste(curr, subset_data$type)
  
  # Create a color map. PPP-implied rates will be black, and market rates will take a color from Set1
  color_map <- setNames(c(set1_colors[color_counter], "black"), unique(subset_data$type))
  color_counter <- color_counter + 1  # Increment the counter
  
  p <- plot_ly(
    data = subset_data,
    x = ~date, 
    y = ~rate,
    color = ~type,
    colors = color_map,  # Use the color map here
    type = "scatter", 
    mode = "lines",
    line = list(width = 2)
  ) %>%
    layout(
      xaxis = list(title = "Date"),
      yaxis = list(title = "1 CHF in Foreign Currency"),
      showlegend = TRUE,  # Show legend for each subplot
      legend = list(
        orientation = "h",
        xanchor = "center",
        yanchor = "bottom",
        x = 0.5,
        y = -0.3
      )
    )
  
  plots_list[[curr]] <- p
}

# Combine plots using subplot
final_plot <- subplot(plots_list, nrows = 2)

# # Adding a global annotation for the data source
# final_plot <- layout(final_plot, annotations = list(
#   list(
#     text = paste("Source: World Bank. Updated:", formatted_today_date),
#     xref = "paper",
#     yref = "paper",
#     x = 1,
#     xanchor = "right",
#     y = -0.5,  # Adjusted this value to avoid overlapping with the subplot legends
#     yanchor = "top",
#     showarrow = FALSE
#   )
# ))

final_plot



# Export 
saveWidget(final_plot, "content/project/PPPvsMarketFXRate/PPPvsMarketFXRate1.html")

# # Clean-up
# rm(list = ls())
# gc()
