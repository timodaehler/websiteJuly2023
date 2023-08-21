library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch life expectancy at birth for males data
male_life_expectancy_data <- wb_data(indicator = "SP.DYN.LE00.MA.IN", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_male_life_expectancy_data <- 
  male_life_expectancy_data %>%
  filter(country %in% selected_countries)

color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for life expectancy at birth for males
plot_male_life_expectancy <- plot_ly(subset_male_life_expectancy_data, x = ~date, y = ~SP.DYN.LE00.MA.IN, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Life Expectancy at Birth for Males (years)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for life expectancy at birth for males
plot_male_life_expectancy



library(tidyverse)
library(wbstats)
library(plotly)
library(RColorBrewer)

# List of countries with their names
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch life expectancy at birth for females data
female_life_expectancy_data <- wb_data(indicator = "SP.DYN.LE00.FE.IN", start_date = 1959, end_date = 2023)

# Subset for selected countries
subset_female_life_expectancy_data <- 
  female_life_expectancy_data %>%
  filter(country %in% selected_countries)

color_palette <- brewer.pal(length(selected_countries), "Set1")

# Create a Plotly line plot for life expectancy at birth for females
plot_female_life_expectancy <- plot_ly(subset_female_life_expectancy_data, x = ~date, y = ~SP.DYN.LE00.FE.IN, color = ~country) %>%
  add_lines(line = list(color = color_palette)) %>%
  layout(yaxis = list(title = "Life Expectancy at Birth for Females (years)"),
         showlegend = TRUE,
         legend = list(title = "Country"))

# Display the Plotly plot for life expectancy at birth for females
plot_female_life_expectancy
