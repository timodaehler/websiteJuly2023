library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch central government debt as % of GDP data
govt_debt_data <- wb_data(indicator = "GC.DOD.TOTL.GD.ZS", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_govt_debt_data <- 
  govt_debt_data %>%
  filter(country %in% selected_countries)

color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for government debt as % of GDP
plot_govt_debt <- plot_ly(subset_govt_debt_data, x = ~date, y = ~GC.DOD.TOTL.GD.ZS, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Government Debt as % of GDP"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for government debt as % of GDP
plot_govt_debt