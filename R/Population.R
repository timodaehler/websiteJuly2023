library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch population growth rate data
population_growth_data <- wb_data(indicator = "SP.POP.GROW", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_population_data <- 
  population_growth_data %>%
  filter(country %in% selected_countries)

# Set up the color palette using the Set1 palette from RColorBrewer
color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for population growth rate
plot_population_growth <- plot_ly(subset_population_data, x = ~date, y = ~SP.POP.GROW, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Population Growth Rate (%)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for population growth rate
plot_population_growth



library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch total population data
population_total_data <- wb_data(indicator = "SP.POP.TOTL", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_population_total_data <- 
  population_total_data %>%
  filter(country %in% selected_countries)

# Set up the color palette using the Set1 palette from RColorBrewer
color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for total population
plot_population_total <- plot_ly(subset_population_total_data, x = ~date, y = ~SP.POP.TOTL, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Total Population"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for total population
plot_population_total