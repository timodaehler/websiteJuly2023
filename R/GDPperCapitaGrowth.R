library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch GDP per capita growth rate data
gdp_per_capita_growth_data <- wb_data(indicator = "NY.GDP.PCAP.KD.ZG", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_gdp_per_capita_growth_data <- 
  gdp_per_capita_growth_data %>%
  filter(country %in% selected_countries)

color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for GDP per capita growth rate
plot_gdp_per_capita_growth <- plot_ly(subset_gdp_per_capita_growth_data, x = ~date, y = ~NY.GDP.PCAP.KD.ZG, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "GDP Per Capita Growth Rate (%)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for GDP per capita growth rate
plot_gdp_per_capita_growth
