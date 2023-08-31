# Ich habe die Dividenden von hier:
# https://www.ubs.com/ch/en/assetmanagement/funds/etf/ch0130595124-ubs-etf-ch-spi-mid-pd001.html#Holdings

# Packages
library(quantmod)
library(lubridate)
library(readxl)
library(dplyr)
library(plotly)

# ---------- Data Extraction ----------
# Define the ticker symbol for stock data
ticker <- "SPMCHA.SW"
# Get stock data
getSymbols(ticker)
# Extract closing prices
closing_prices <- Cl(get(ticker))

# ---------- Yearly Closing Prices ----------
# Filter for the last index (date) for each year
last_price_each_year <- apply.yearly(closing_prices, last)
# Convert xts object to data frame
last_price_each_year_df <- as.data.frame(last_price_each_year)
# Add Date and Year columns
last_price_each_year_df$Date <- as.Date(rownames(last_price_each_year_df))
rownames(last_price_each_year_df) <- NULL
last_price_each_year_df$Year <- year(last_price_each_year_df$Date)

# ---------- Import Dividend Data ----------
# Define the path to the Excel file
excel_path <- "/Users/timodaehler_1/Desktop/websiteJuly2023/R/UBSFunds_Distribution_20230831_125743.xlsx"
# Read data from the Excel file
distribution_data <- read_excel(excel_path)

# ---------- Data Transformation ----------
# Convert "Distribution date" to Date format
distribution_data$`Distribution date` <- dmy(distribution_data$`Distribution date`)
# Extract year from "Distribution date"
distribution_data$Year <- year(distribution_data$`Distribution date`)

# Group by Year and Sum up the "Distribution"
yearly_distribution_sum <- distribution_data %>%
  group_by(Year) %>%
  summarise(Total_Distribution = sum(as.numeric(Distribution), na.rm = TRUE))

# ---------- Merge Data ----------
# Merge the two data frames by 'Year'
merged_data <- left_join(yearly_distribution_sum, last_price_each_year_df, by = "Year")
# Calculate the dividend yield
merged_data <- merged_data %>% mutate(Dividend_Yield = Total_Distribution / `SPMCHA.SW.Close` * 100)

# ---------- Data Visualization ----------
# Create the plot
plot_ly(data = merged_data, x = ~Year, y = ~Dividend_Yield, type = "scatter", mode = "lines") %>%
  layout(title = "Dividend Yield Over Time",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Dividend Yield (%)"))
