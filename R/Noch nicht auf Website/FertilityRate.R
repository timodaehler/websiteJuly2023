library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch total fertility rate data
fertility_rate_data <- wb_data(indicator = "SP.DYN.TFRT.IN", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_fertility_rate_data <- 
  fertility_rate_data %>%
  filter(country %in% selected_countries)

# Color palette setup
color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for total fertility rate
plot_fertility_rate <- plot_ly(subset_fertility_rate_data, x = ~date, y = ~SP.DYN.TFRT.IN, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Total Fertility Rate"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for total fertility rate
plot_fertility_rate



# Total fertility rate represents the number of children that would be born to a woman 
# if she were to live to the end of her childbearing years and bear children in accordance 
# with age-specific fertility rates of the specified year.

