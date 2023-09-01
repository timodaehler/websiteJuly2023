# install.packages("wbstats")
library(wbstats)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(wbstats)
library(RColorBrewer)


gdp_per_capita_data <- wb_data(indicator = "NY.GDP.PCAP.KD", start_date = 1990, end_date = 2023)

# You can inspect the data with:
head(gdp_per_capita_data)


selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

subset_data <- gdp_per_capita_data %>%
  filter(country %in% selected_countries)





# List of countries
selected_countries <- c("Germany", "Switzerland", "United States", "United Kingdom", "China", "India", "Japan")

# Fetch GDP and GDP per capita data
gdp_data <- wb_data(indicator = "NY.GDP.MKTP.PP.KD", start_date = 1990, end_date = 2023)
gdp_pc_data <- wb_data(indicator = "NY.GDP.PCAP.PP.KD", start_date = 1990, end_date = 2023)

# Combine datasets
combined_data <- left_join(gdp_data, gdp_pc_data, by = c("iso3c", "date", "country"), suffix = c("_gdp", "_gdp_pc"))


# Subset for selected countries
subset_data <- combined_data %>%
  filter(country %in% selected_countries) %>%
  select(iso3c, country, date, NY.GDP.MKTP.PP.KD, NY.GDP.PCAP.PP.KD )

# Reshape data to long format
long_data <- subset_data %>%
  pivot_longer(cols = starts_with("NY.GDP"), names_to = "indicator", values_to = "value")

# # Plot
# ggplot(long_data, aes(x=date, y=value, color=country)) +
#   geom_line() +
#   facet_wrap(~indicator, scales = "free_y", labeller = as_labeller(c(NY.GDP.MKTP.KD = "GDP", NY.GDP.PCAP.KD = "GDP per Capita"))) +
#   labs(title="GDP and GDP per capita over time", y="Value") +
#   theme_minimal()



# Split data into GDP and GDP per Capita
gdp_data <- long_data %>% filter(indicator == "NY.GDP.MKTP.PP.KD")
gdp_pc_data <- long_data %>% filter(indicator == "NY.GDP.PCAP.PP.KD")

# Create plotly plots for GDP
gdp_plot <- gdp_data %>%
  plot_ly(x = ~date, y = ~value, split = ~country, color = ~country,
          colors = RColorBrewer::brewer.pal(length(unique(long_data$country)), "Set1"),
          type = "scatter", mode = "lines", name = "GDP") %>%
  layout(title = "GDP over time", yaxis = list(title = "Value"))

# Create plotly plots for GDP per Capita
gdp_pc_plot <- gdp_pc_data %>%
  plot_ly(x = ~date, y = ~value, split = ~country, color = ~country,
          colors = RColorBrewer::brewer.pal(length(unique(long_data$country)), "Set1"),
          type = "scatter", mode = "lines", name = "GDP per Capita") %>%
  layout(title = "GDP per Capita over time", yaxis = list(title = "Value"))

# Combine plots using subplot
fig <- subplot(gdp_plot, gdp_pc_plot, nrows = 2, shareX = TRUE)

# Show the plot
fig


rm(list = ls())
gc()