# Import necessary libraries
library(htmlwidgets)
library(quantmod)
library(plotly)
library(dplyr)

# Download BTC-USD daily data from Yahoo Finance and store it in btc_data
btc_data <- getSymbols("BTC-USD", auto.assign = FALSE)
btc_data <- fortify.zoo(btc_data)

btc_data <- 
  btc_data %>% 
  select(Index, contains("Close")) %>% 
  mutate(Date = Index) %>% 
  select(-Index) %>% 
  rename("Close" = "BTC-USD.Close", "Date" = Date)

# Save the btc_data object as an RDS file
saveRDS(btc_data, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/Bitcoin/btc_data.rds")

# Calculate the median of Close prices
median_close <- median(btc_data$Close)

# Create the main Plotly time series plot
# Create the main Plotly time series plot
btc_plot <- 
  plot_ly(data = btc_data, x = ~Date, y = ~Close, type = "scatter", mode = "lines", name = "1 Bitcoin in USD") %>%
  layout(
    # title = "Bitcoin (BTC-USD) Closing Prices Over Time",
    xaxis = list(title = ""),
    yaxis = list(title = "Close Price"),
    legend = list(
      x = 0.5,
      y = -0.1,
      xanchor = "center",
      orientation = "h"
    )
  ) %>%
  # Add horizontal line at the median Close price
  add_trace(x = ~Date, y = rep(median_close, length(btc_data$Date)), type = "scatter", mode = "lines",
            line = list(dash = "dash", color = "black"), name = "Median")


# Show the plot
btc_plot

# Update date
saveRDS(Sys.time(), "content/project/Bitcoin/Bitcoin1_update_date.rds")

# Export 
saveWidget(btc_plot, "content/project/Bitcoin/Bitcoin1.html")

# Clean-up
rm(list = ls())
gc()






# Load the packages
library(dplyr)
library(gt)

# Order the data by Date
btc_data <- btc_data %>% arrange(Date)

# Get the latest date in the dataset
latest_date_btc <- max(btc_data$Date)

# Calculate Year-To-Date change for Bitcoin
start_of_year_btc <- as.Date(paste0(format(latest_date_btc, "%Y"), "-01-01"))
ytd_data_btc <- btc_data %>% filter(Date >= start_of_year_btc)
ytd_change_btc <- (last(ytd_data_btc$Close) / first(ytd_data_btc$Close) - 1) * 100

# Calculate change over the last 365 days for Bitcoin
one_year_ago_btc <- latest_date_btc - 365
one_year_data_btc <- btc_data %>% filter(Date >= one_year_ago_btc)
one_year_change_btc <- (last(one_year_data_btc$Close) / first(one_year_data_btc$Close) - 1) * 100

# Calculate change over the last 5 years for Bitcoin
five_years_ago_btc <- latest_date_btc - 365 * 5
five_year_data_btc <- btc_data %>% filter(Date >= five_years_ago_btc)
five_year_change_btc <- (last(five_year_data_btc$Close) / first(five_year_data_btc$Close) - 1) * 100

# Create a data frame to hold the metrics for Bitcoin
metrics_data_btc <- data.frame(
  Metric = c("Year-To-Date Change (%)", "One-Year Change (%)", "Five-Year Change (%)"),
  Value = c(ytd_change_btc, one_year_change_btc, five_year_change_btc)
)

# Create a pretty table using the gt package
pretty_table_btc <- gt(metrics_data_btc) %>% 
  tab_header(
    title = "Bitcoin Performance Metrics",
    subtitle = paste("As of", latest_date_btc)
  )

# Show the table
pretty_table_btc

gt::gtsave(pretty_table_btc, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/Bitcoin/pretty_table_btc.html")

