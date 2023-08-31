# Import necessary libraries
library(Quandl)
library(plotly)

# ---------- Fetch Data ----------
# Fetch S&P 500 Dividend Yield data by month using Quandl API
# Store the fetched data in the variable 'sp500_data'
# API documentation: https://data.nasdaq.com/data/MULTPL/SP500_DIV_YIELD_MONTH-sp-500-dividend-yield-by-month
sp500_data <- Quandl("MULTPL/SP500_DIV_YIELD_MONTH", api_key="rsJKAethJVUA76dPfkgh")

# ---------- Data Visualization ----------
# Create a line chart using the 'plotly' library
# X-axis represents the 'Date' and Y-axis represents 'Value' (Dividend Yield)
# Add layout details like titles and axis labels
plot_ly(data = sp500_data, x = ~Date, y = ~Value, type = "scatter", mode = "lines") %>%
  layout(
    title = "S&P 500 Dividend Yield Over Time",
    xaxis = list(title = "Date"),
    yaxis = list(title = "Dividend Yield (%)")
  )



# Old, manual approach -------------------------------------------------------------------------
# 
# # Load the required libraries
# library(quantmod)
# library(dplyr)
# 
# # Get the S&P 500 data (here I use SPY, which is an ETF that tracks the S&P 500)
# getSymbols("SPY")
# 
# # Get dividend data
# dividend_data <- getDividends("SPY", auto.assign = FALSE)
# 
# # Merge with price data
# merged_data <- merge(Cl(SPY), dividend_data, all = TRUE)
# 
# # Rename columns
# colnames(merged_data) <- c("Close", "Dividend")
# 
# # Forward fill dividends to calculate yield for each day
# merged_data$Dividend[is.na(merged_data$Dividend)] <- 0
# merged_data$Forward_Dividend <- zoo::na.locf(merged_data$Dividend, fromLast = FALSE)
# 
# # Calculate rolling sum of dividends for the past year (approx 252 trading days)
# merged_data$Rolling_Dividends <- rollapply(merged_data$Forward_Dividend, 252, sum, align = "right", fill = NA)
# 
# # Calculate dividend yield as a percentage
# merged_data$Dividend_Yield <- (merged_data$Rolling_Dividends / merged_data$Close) * 100
# 
# # Remove NAs to clean up the data
# clean_data <- na.omit(merged_data)
# 
# # Plot the time series of the dividend yield
# plot(clean_data$Dividend_Yield, main = "Time Series of S&P 500 Dividend Yield", xlab = "Date", ylab = "Dividend Yield (%)")
# 
# 
# 
# 
# # -------------------------------------------------------------------------
# # Load required packages
# library(tidyverse)
# library(zoo)
# library(quantmod)
# library(TTR) # For the rollapply function
# 
# # Import SPY closing prices from CSV
# spy_closing_prices <- read_csv("/Users/timodaehler_1/Desktop/websiteJuly2023/R/SPY.csv") %>%
#   select(Date, Close)
# 
# # Convert Date to a Date object
# spy_closing_prices$Date <- as.Date(spy_closing_prices$Date)
# 
# # Get dividend data from the Internet
# getSymbols("SPY")
# div_data <- getDividends("SPY", auto.assign = FALSE)
# 
# # Transform xts object to a data frame
# div_data <- data.frame(Date = index(div_data), Dividend = as.vector(coredata(div_data)))
# 
# # Convert Dividend Data Date to a Date object
# div_data$Date <- as.Date(div_data$Date)
# 
# # Merge the two data frames by Date
# joined_data <- left_join(spy_closing_prices, div_data, by = "Date")
# 
# # Forward fill dividends to calculate yield for each day
# joined_data$Dividend[is.na(joined_data$Dividend)] <- 0
# 
# # Calculate rolling sum of dividends for the past year (approx 252 trading days)
# joined_data$Rolling_Dividends <- rollapply(joined_data$Dividend, 252, sum, align = "right", fill = NA)
# 
# # Calculate Dividend Yield
# joined_data <- joined_data %>%
#   mutate(Dividend_Yield = (Rolling_Dividends / Close) * 100)
# 
# # Remove NAs to clean up the data
# clean_data <- na.omit(joined_data)
# 
# # Plot the Dividend Yield using plotly
# library(plotly)
# 
# plot_ly(data = clean_data, x = ~Date, y = ~Dividend_Yield, type = "scatter", mode = "lines") %>%
#   layout(title = "Dividend Yield Over Time",
#          xaxis = list(title = "Year"),
#          yaxis = list(title = "Dividend Yield (%)"))
# 
# 
# 
# 
# 
# 
# 
# # new try -----------------------------------------------------------------
# # Load the required libraries
# library(quantmod)
# library(dplyr)
# library(tidyverse)
# library(zoo)
# library(quantmod)
# library(TTR) # For the rollapply function
# library(plotly)
# 
# # Get the S&P 500 data (here I use SPY, which is an ETF that tracks the S&P 500)
# getSymbols("SPY")
# 
# # Get dividend data
# dividend_data <- getDividends("SPY", auto.assign = FALSE)
# 
# # Sum by year
# yearly_sums <- apply.yearly(dividend_data, sum)
# 
# # Show the yearly sums
# print(yearly_sums)
# 
# # Update the index to the last day of each year
# index(yearly_sums) <- as.Date(paste0(format(index(yearly_sums), "%Y"), "-12-31"))
# 
# # Show the updated yearly sums
# print(yearly_sums)
# 
# # Import SPY closing prices from CSV
# spy_closing_prices <- 
#   read_csv("/Users/timodaehler_1/Desktop/websiteJuly2023/R/SPY.csv") %>%
#   select(Date, Close)
# 
# # Convert Date column to Date type if it's not already
# spy_closing_prices$Date <- 
#   as.Date(spy_closing_prices$Date)
# 
# # Add a Year column to the data
# spy_closing_prices$Year <- lubridate::year(spy_closing_prices$Date)
# 
# # Select the last closing price for each year
# last_price_each_year <- 
#   spy_closing_prices %>% 
#   group_by(Year) %>% 
#   slice_tail(n = 1) %>% 
#   ungroup()
# 
# # Show the result
# print(last_price_each_year)
# 
# 
# # Convert yearly_sums to tibble and add Year column
# yearly_sums <- as_tibble(data.frame(Date = index(yearly_sums), SPY_div = as.vector(coredata(yearly_sums))))
# yearly_sums$Year <- lubridate::year(yearly_sums$Date)
# 
# # Merge the data based on Year
# merged_data <- left_join(yearly_sums, last_price_each_year, by = "Year")
# 
# # Calculate dividend yield
# merged_data <- merged_data %>%
#   mutate(Dividend_Yield = (SPY_div / Close) * 100)
# 
# # Show the new data
# print(merged_data)
# 
# 
# 
# # Create the plot
# plot <- plot_ly(data = merged_data, x = ~Date.x, y = ~Dividend_Yield, type = 'scatter', mode = 'lines') %>%
#   layout(title = "Annual Dividend Yield Over Time",
#          xaxis = list(title = "Year"),
#          yaxis = list(title = "Dividend Yield (%)"))
# 
# # Show the plot
# plot

