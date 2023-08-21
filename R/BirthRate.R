library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch crude birth rate data
crude_birth_rate_data <- wb_data(indicator = "SP.DYN.CBRT.IN", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_crude_birth_rate_data <- 
  crude_birth_rate_data %>%
  filter(country %in% selected_countries)

# Color palette setup
color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for crude birth rate
plot_crude_birth_rate <- plot_ly(subset_crude_birth_rate_data, x = ~date, y = ~SP.DYN.CBRT.IN, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Crude Birth Rate (per 1,000 population)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for crude birth rate
plot_crude_birth_rate

# Crude birth rate indicates the number of live births occurring during the year, 
# per 1,000 population estimated at midyear. Subtracting the crude death rate from the 
# crude birth rate provides the rate of natural increase, which is equal to the rate of population change in the absence of migration.

