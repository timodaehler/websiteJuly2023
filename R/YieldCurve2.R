library(quantmod)
library(plotly)

# Download data
getSymbols("DGS1MO", src = "FRED")  # 1-month treasury rate
getSymbols("DGS3MO", src = "FRED")  # 3-month treasury rate
getSymbols("DGS6MO", src = "FRED")  # 6-month treasury rate
getSymbols("DGS2", src = "FRED")    # 2-year treasury rate
getSymbols("DGS1", src = "FRED")    # 1-year treasury rate
getSymbols("DGS5", src = "FRED")    # 5-year treasury rate
getSymbols("DGS10", src = "FRED")   # 10-year treasury rate
getSymbols("DGS30", src = "FRED")   # 30-year treasury rate

# Merge datasets
yield_data <- merge(DGS1MO, DGS3MO, DGS6MO, DGS2, DGS1, DGS5, DGS10, DGS30, all = TRUE)

# Replace NA with the last available observation for continuity
yield_data <- na.locf(yield_data)

# Convert to data frame and add a Date column
yield_df <- data.frame(Date = index(yield_data), coredata(yield_data))
# yield_df <- yield_df %>% filter(year(ymd(Date))>1990)

# Extract unique years from Date column
# unique_years <- unique(year(yield_df$Date))

all_years <- unique(year(yield_df$Date))
unique_years <- seq(min(all_years), max(all_years), by = 5)

# Define maturity values
maturity_vals <- c(1/12, 3/12, 6/12, 2, 1, 5, 10, 30)  # in years

# Find the range of your yields to help normalize zero (excluding the Date column)
min_yield <- min(yield_df[,-1], na.rm = TRUE)
max_yield <- max(yield_df[,-1], na.rm = TRUE)

# Compute the relative position of zero within the range
zero_pos <- (0 - min_yield) / (max_yield - min_yield)

# Define the custom color scale
color_scale <- list(
  c(0, "red"),               # Red for minimum yield (most negative)
  c(zero_pos, "lightblue"), # Light blue for zero
  c(1, "darkblue")          # Dark blue for maximum yield (most positive)
)

p <- 
  plot_ly(data = yield_df, x = ~maturity_vals, y = ~Date, z = as.matrix(yield_df[,-1]), type = "surface", colorscale = color_scale) %>%
  layout(scene = list(
    xaxis = list(title = "Maturity (yr)", autorange = "reversed"),
    yaxis = list(title = "",
                 tickvals = as.Date(paste0(unique_years, "-01-01")),
                 ticktext = unique_years),
    zaxis = list(title = "Yield (%)"),
    camera = list(
      eye = list(x = 2, y = 4.5, z = 2)  # Adjust these values as necessary
    ),
    aspectratio = list(x=1, y=4, z=1)  # Adjust this to make y-axis longer relative to others
  ))

p

# # Filter for the latest date
# latest_date_yield <- yield_df %>% 
#   filter(Date == max(Date))
# 
# # Extract yield values
# yields_latest_date <- unlist(latest_date_yield[,-1])
# 
# # Create a 2D line plot for the yield curve of the latest date
# p <- plot_ly(x = maturity_vals, y = yields_latest_date, type = "scatter", mode = "lines+markers") %>%
#   layout(
#     xaxis = list(title = "Maturity"),
#     yaxis = list(title = "Yield"),
#     title = paste("Yield Curve for", latest_date_yield$Date)
#   )


# Update date
saveRDS(Sys.time(), "content/project/YieldCurves/YieldCurves2_update_date.rds")

# Export 
saveWidget(p, "content/project/YieldCurves/YieldCurves2.html")

# Clean-up
rm(list = ls())
gc()





# # Use the custom color scale in the plot
# plot_ly(data = yield_df, x = ~maturity_vals, y = ~Date, z = as.matrix(yield_df[,-1]), type = "surface", colorscale = color_scale) %>%
#   layout(scene = list(
#     xaxis = list(title = "Maturity", autorange = "reversed"),
#     yaxis = list(title = "Date",
#                  tickvals = as.Date(paste0(unique_years, "-01-01")),
#                  ticktext = unique_years),
#     zaxis = list(title = "Yield")
#   ))

# # ... [The previous code remains unchanged]

# Use the custom color scale in the plot
# plot_ly(data = yield_df, x = ~maturity_vals, y = ~Date, z = as.matrix(yield_df[,-1]), type = "surface", colorscale = color_scale) %>%
#   layout(scene = list(
#     xaxis = list(title = "Maturity", autorange = "reversed"),
#     yaxis = list(title = "Date",
#                  tickvals = as.Date(paste0(unique_years, "-01-01")),
#                  ticktext = unique_years),
#     zaxis = list(title = "Yield"),
#     camera = list(
#       eye = list(x = 2, y = 2, z = 2)  # Adjust these values as necessary
#     )
#   ))