library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch real interest rate data
real_interest_rate_data <- wb_data(indicator = "FR.INR.RINR", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_rate_data <- 
  real_interest_rate_data %>%
  filter(country %in% selected_countries)

# Set up the color palette using the Set1 palette from RColorBrewer
colors <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot
plot <- plot_ly(subset_rate_data, x = ~date, y = ~FR.INR.RINR, color = ~country) %>%
  add_lines(line = list(color = colors)) %>%
  layout(yaxis = list(title = "Real Interest Rate (%)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot
plot



rm(list = ls())
gc()