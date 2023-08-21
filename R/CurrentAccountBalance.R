library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch current account balance data (in US dollars)
current_account_data <- wb_data(indicator = "BN.CAB.XOKA.CD", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_current_account_data <- 
  current_account_data %>%
  filter(country %in% selected_countries)

color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for current account balance
plot_current_account <- plot_ly(subset_current_account_data, x = ~date, y = ~BN.CAB.XOKA.CD, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Current Account Balance (US$)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for current account balance
plot_current_account
