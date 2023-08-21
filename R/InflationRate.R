library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch inflation rate data
inflation_rate_data <- wb_data(indicator = "FP.CPI.TOTL.ZG", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_inflation_data <- 
  inflation_rate_data %>%
  filter(country %in% selected_countries)

# Set up the color palette using the Set1 palette from RColorBrewer
color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for inflation rate
plot_inflation <- plot_ly(subset_inflation_data, x = ~date, y = ~FP.CPI.TOTL.ZG, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Inflation Rate (%)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for inflation rate
plot_inflation
