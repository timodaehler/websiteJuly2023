# Das sind die Yield Curves für die USA Zuerst die 3 D Yield Curve. Danach 
# die simple Yield Curve für das aktuellste Datum. 
# Und dann der Plot mit den Yields für verschiedene Laufzeiten pro Zeitpunkt über die Zeit. 


# Load the required libraries for data visualization and manipulation
library(RColorBrewer)
library(tidyverse)
library(scales)
library(htmlwidgets)
library(plotly)
library(quantmod)


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

plot_3d_US_yield_curve <- 
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

plot_3d_US_yield_curve


# Update date
saveRDS(Sys.time(), "content/project/YieldCurves/plot_3d_US_yield_curve_update_date.rds")

# Export 
saveWidget(plot_3d_US_yield_curve, "content/project/YieldCurves/plot_3d_US_yield_curve.html")









# Convert the Date column to Date format if it's not already
yield_df$Date <- as.Date(yield_df$Date)

# Find the most recent date
most_recent_date <- max(yield_df$Date)

# Filter the data for the most recent date
recent_data <- yield_df %>% filter(Date == most_recent_date)

# Transform the data to long format for plotting
# Transform the data to long format for plotting
long_recent_data <- recent_data %>% 
  select(-Date) %>% 
  gather(key = "Maturity", value = "Yield") %>%
  mutate(Maturity_Number = gsub("DGS|MO", "", Maturity), # Remove 'DGS' and 'MO'
         Maturity_Number = ifelse(grepl("MO", Maturity), as.numeric(Maturity_Number) / 12, as.numeric(Maturity_Number)), # Convert months to years
         Yield = as.numeric(Yield)) %>%  # Convert Yield to numeric
  arrange(Maturity_Number) # Arrange by numeric value

# Find the maximum Y value
max_yield <- max(long_recent_data$Yield, na.rm = TRUE)

# Creating the yield curve plot with customized y-axis limits
plot_simple_US_yield_curve <-
  plot_ly(
    data = long_recent_data,
    x = ~ Maturity_Number,
    y = ~ Yield,
    type = 'scatter',
    mode = 'lines',
    text = ~ Maturity,
    hoverinfo = 'text+y'
  )

# Customize the plot
plot_simple_US_yield_curve <-
  plot_simple_US_yield_curve %>% layout(
    title = paste("Yield Curve on", most_recent_date),
    xaxis = list(title = "Maturity (Years)"),
    yaxis = list(title = "Yield (%)", range = c(-0.5, max_yield + 0.5))
  )

# Print the plot
plot_simple_US_yield_curve

# Export 
saveWidget(plot_simple_US_yield_curve, "content/project/YieldCurves/plot_simple_US_yield_curve.html")





# Plot mit den Yields für verschiedene Laufzeiten pro Zeitpunkt über die Zeit --------

# Transform the data to long format
long_data <- yield_df %>%
  gather(key = "Maturity", value = "Yield", -Date) %>%
  mutate(
    Maturity = gsub("Maturity_", "", Maturity),  # Remove 'Maturity_' prefix
    Maturity_Label = ifelse(as.numeric(Maturity) == 1, paste(Maturity, "yr"), paste(Maturity, "yrs")),  # Add 'yr' or 'yrs'
    Yield = as.numeric(Yield)  # Ensure Yield is numeric
  )

# Create the plot with custom hover text
p <- plot_ly(data = long_data, x = ~Date, y = ~Yield, color = ~Maturity_Label, type = 'scatter', mode = 'lines',
             hoverinfo = 'text', text = ~paste(format(Date, "%d %b %Y"), ", ", format(Yield, digits = 4), ", ", Maturity_Label))

# Customize the plot
p <- p %>% layout(title = "Yield vs. Date for Different Maturities",
                  xaxis = list(title = "Date"),
                  yaxis = list(title = "Yield", tickformat = ".2f"))

# Print the plot
p




# Clean-up
rm(list = ls())
gc()


