library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch the Crude Death Rate data
death_rate_data <- wb_data(indicator = "SP.DYN.CDRT.IN", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_death_rate_data <- 
  death_rate_data %>%
  filter(country %in% selected_countries)

color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for the Crude Death Rate
plot_death_rate <- plot_ly(subset_death_rate_data, x = ~date, y = ~SP.DYN.CDRT.IN, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Crude Death Rate (per 1,000 people)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for the Crude Death Rate
plot_death_rate


# Crude death rate indicates the number of deaths occurring during the year, 
# per 1,000 population estimated at midyear. Subtracting the crude death rate 
# from the crude birth rate provides the rate of natural increase, which is equal 
# to the rate of population change in the absence of migration.

