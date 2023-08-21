# Load libraries
library(dplyr)
library(plotly)
library(zoo)
library(fredr)

# Fetch data from FRED
WILL5000PR_data <- fredr(series_id = "WILL5000PR")  # Wilshire 5000 Index
getSymbols("GDP", src = "FRED")                     # US GDP

# Convert xts objects and dataframes to a common dataframe structure
GDP_df <- data.frame(Date=index(GDP), coredata(GDP))
WILL5000PR_data$Date <- as.Date(WILL5000PR_data$date)

# Rename WILL5000PR_data's value column for consistency
colnames(WILL5000PR_data)[colnames(WILL5000PR_data) == "value"] <- "WILL5000PR"

# Join dataframes by date
joined_data <- left_join(WILL5000PR_data, GDP_df, by = "Date")

# Remove columns with all NAs
joined_data <- joined_data[, colSums(is.na(joined_data)) != nrow(joined_data)]

# Interpolate NAs for the remaining columns
for (i in 1:ncol(joined_data)) {
  if (any(is.na(joined_data[,i]))) {
    joined_data[,i] <- na.approx(joined_data[,i], rule = 2) # 'rule = 2' to handle NAs at beginning or end of series
  }
}

# Compute the Buffett Indicator
joined_data$Buffett_Indicator <- (joined_data$WILL5000PR / joined_data$GDP) * 100

# Plot using plotly
plot_ly(data = joined_data, x = ~Date, y = ~Buffett_Indicator, type = "scatter", mode = "lines") %>%
  layout(title = "Buffett Indicator Over Time",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Market Cap to GDP Ratio"))

# Fit an exponential model (linear on log-transformed y-values)
fit <- lm(log(Buffett_Indicator) ~ Date, data = joined_data)

# Generate predictions
joined_data$predicted <- exp(predict(fit))

plot_ly() %>%
  add_trace(data = joined_data, x = ~Date, y = ~Buffett_Indicator, type = "scatter", mode = "lines", name = "Buffett Indicator") %>%
  add_trace(data = joined_data, x = ~Date, y = ~predicted, type = "scatter", mode = "lines", line = list(color = 'red'), name = "Historical Trend Line") %>%
  layout(title = "Buffett Indicator Over Time with Historical Trend Line",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Market Cap to GDP Ratio"))
