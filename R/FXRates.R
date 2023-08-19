# Load necessary libraries
library(priceR)
library(ggplot2)
library(tidyr)
library(hrbrthemes)
library(lubridate)
library(WDI)
library(dplyr)
library(scales)
library(plotly)
library(RColorBrewer)
library(htmlwidgets)

# Assuming you have today's date in a variable like this:
update_date <- Sys.Date()  # This gives today's date

# Format today's date in a readable format:
formatted_today_date <- format(update_date, format = "%d %B %Y")  # e.g., "05 August 2023"

# Set base currency and a vector of target currencies
base_currency <- "CHF"
target_currencies <- c("EUR", "USD", "JPY", "GBP", "CNY", "INR") # Added "CNY" and "INR"


# Create an empty list to store the exchange rate data for each target currency
exchange_rates_list <- list()

# Loop through each target currency to fetch historical exchange rates from the base currency
for (currency in target_currencies) {
  # Fetch historical rates for current currency in the loop
  exchange_data <-
    historical_exchange_rates(
      base_currency,
      to = currency,
      start_date = "2000-01-01",
      end_date = Sys.Date()
    )
  
  # Store this data in our list, indexed by the currency name
  exchange_rates_list[[currency]] <- exchange_data
}

# Rename the 'rate' column of each dataframe in our list to the respective currency name
for (i in seq_along(target_currencies)) {
  colnames(exchange_rates_list[[i]])[2] <- target_currencies[i]
}

# Collapse all dataframes in the list by 'date' into a single dataframe
fx_rates <-
  Reduce(function(x, y)
    merge(x, y, by = "date", all = TRUE), exchange_rates_list)


# Import PPP data ---------------------------------------------------------
ppp_data <-
  WDI(
    country = c("CHE", "USA", "DEU", "JPN", "GBR", "CHN", "IND"),  # Added "CHN" and "IND"
    indicator = "PA.NUS.PPP",
    start = 1999,
    end = 2023
  )

ppp_data <-
  ppp_data %>%
  select(year, country, PA.NUS.PPP) %>% # Selecting the necessary columns
  spread(key = country, value = PA.NUS.PPP) # Spreading the data based on country

# Calculate ratios relative to Switzerland --------------------------------
ppp_data <-
  ppp_data %>%
  mutate(
    EUR = Germany / Switzerland,
    USD = `United States` / Switzerland,
    JPY = Japan / Switzerland,
    GBP = `United Kingdom` / Switzerland,
    CNY = China / Switzerland,         # Added this line for China
    INR = India / Switzerland          # Added this line for India
  ) %>%
  select(year, EUR, JPY, GBP, USD, CNY, INR)  # Added CNY and INR to selection

# Convert the year column to date
ppp_data$date <-
  as.Date(paste0(ppp_data$year, "-12-31"))

# Create a sequence of daily dates from 1.1.2020 to 30.6.2023
all_dates <-
  seq(as.Date("2020-01-01"), as.Date("2023-06-30"), by = "days")

# Use the zoo package to interpolate data
interpolated_data <-
  as.data.frame(approx(ppp_data$date, ppp_data$EUR, all_dates))
colnames(interpolated_data) <- c("date", "EUR")
for (currency in c("JPY", "GBP", "USD", "CNY", "INR")) {  # Added "CNY" and "INR" to the loop
  temp <-
    as.data.frame(approx(ppp_data$date, ppp_data[[currency]], all_dates))
  interpolated_data[[currency]] <- temp$y
}

# View the data
head(interpolated_data)


# Generate a sequence of daily dates from the start to end of your data
all_dates <-
  seq(as.Date("1999-12-31"), as.Date("2022-12-31"), by = "day")

# # Interpolate for EUR (can repeat this for other currencies)
# interpolated_EUR <-
#   approx(ppp_data$date, ppp_data$EUR, xout = all_dates)

# Initialize df_daily with just the date sequence
df_daily <- data.frame(date = all_dates)

# Interpolate for all currencies including EUR
for (currency in c("EUR", "JPY", "GBP", "USD", "CNY", "INR")) {
  y <- approx(ppp_data$date, ppp_data[[currency]], xout = all_dates)$y
  df_daily[[currency]] <- y
}

# Filter dataframe for 2022 data
df_2022 <-
  df_daily[df_daily$date >= "2022-01-01" &
             df_daily$date <= "2022-12-31",]

# Compute average daily difference for each currency in 2022
avg_diff_EUR <- mean(diff(df_2022$EUR))
avg_diff_JPY <- mean(diff(df_2022$JPY))
avg_diff_GBP <- mean(diff(df_2022$GBP))
avg_diff_USD <- mean(diff(df_2022$USD))
avg_diff_CNY <- mean(diff(df_2022$CNY))  # Added this line for China
avg_diff_INR <- mean(diff(df_2022$INR))  # Added this line for India


# Generate sequence of dates for the first half of 2023
future_dates <-
  seq(from = as.Date("2023-01-01"),
      to = as.Date(Sys.Date()),
      by = "days")

# Create a data frame for these future dates
future_df <- data.frame(date = future_dates)

# Compute extrapolated values using the last value of 2022 and the average difference
future_df$EUR <-
  tail(df_2022$EUR, 1) + cumsum(rep(avg_diff_EUR, length(future_dates)))
future_df$JPY <-
  tail(df_2022$JPY, 1) + cumsum(rep(avg_diff_JPY, length(future_dates)))
future_df$GBP <-
  tail(df_2022$GBP, 1) + cumsum(rep(avg_diff_GBP, length(future_dates)))
future_df$USD <-
  tail(df_2022$USD, 1) + cumsum(rep(avg_diff_USD, length(future_dates)))
future_df$CNY <-   # Added this line for China
  tail(df_2022$CNY, 1) + cumsum(rep(avg_diff_CNY, length(future_dates)))
future_df$INR <-   # Added this line for India
  tail(df_2022$INR, 1) + cumsum(rep(avg_diff_INR, length(future_dates)))

# Combine the original dataframe with the extrapolated dataframe
df_daily <- rbind(df_daily, future_df)

# Assuming you have fx_rates from the previous code, add the year extraction:
fx_rates <- fx_rates %>%
  mutate(year = year(date))

# Merge the two dataframes
combined_data <-
  left_join(fx_rates, df_daily, by = c("date" = "date"))

# Convert the data to a long format for ggplot
fx_rates_vs_ppp_implied_rates <- 
  combined_data %>%
  gather(key = "type_value", value = "rate", EUR.x:INR.x, EUR.y:INR.y) %>%  # Added CNY and INR to selection
  separate(type_value,
           into = c("currency", "type"),
           sep = "\\.")

fx_rates_vs_ppp_implied_rates <- 
  fx_rates_vs_ppp_implied_rates %>%
  mutate(type = case_when(
    type == "x" ~ "Market Rate",
    type == "y" ~ "PPP-Implied Rate",
    TRUE ~ type
  ))

# Fetch the Set1 colors
set1_colors <- brewer.pal(8, "Set1")

# Split the data by currency
currencies <- unique(fx_rates_vs_ppp_implied_rates$currency)
plots_list <- list()

color_counter <- 1  # Initialize a counter to assign Set1 colors to each currency

for (curr in currencies) {
  subset_data <- subset(fx_rates_vs_ppp_implied_rates, currency == curr)
  
  # Modify the type column to include currency
  subset_data$type <- paste(curr, subset_data$type)
  
  # Create a color map. PPP-implied rates will be black, and market rates will take a color from Set1
  color_map <- setNames(c(set1_colors[color_counter], "black"), unique(subset_data$type))
  color_counter <- color_counter + 1  # Increment the counter
  
  p <- plot_ly(
    data = subset_data,
    x = ~date, 
    y = ~rate,
    color = ~type,
    colors = color_map,  # Use the color map here
    type = "scatter", 
    mode = "lines",
    line = list(width = 2)
  ) %>%
    layout(
      xaxis = list(title = "Date"),
      yaxis = list(title = "1 CHF in Foreign Currency"),
      showlegend = TRUE,  # Show legend for each subplot
      legend = list(
        orientation = "h",
        xanchor = "center",
        yanchor = "bottom",
        x = 0.5,
        y = -0.3
      )
    )
  
  plots_list[[curr]] <- p
}

# Combine plots using subplot
final_plot <- subplot(plots_list, nrows = 2)

# Adding a global annotation for the data source
final_plot <- layout(final_plot, annotations = list(
  list(
    text = paste("Source: World Bank. Updated:", formatted_today_date),
    xref = "paper",
    yref = "paper",
    x = 1,
    xanchor = "right",
    y = -0.5,  # Adjusted this value to avoid overlapping with the subplot legends
    yanchor = "top",
    showarrow = FALSE
  )
))

final_plot

# Export to FXRates
saveWidget(final_plot, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/FXRates/PPPvsMarket.html")







# Second plot ------------------------------------------------------------
# Load necessary libraries
library(priceR)
library(ggplot2)
library(tidyr)
library(hrbrthemes)
library(lubridate)
library(WDI)
library(dplyr)
library(scales)
library(plotly)
library(RColorBrewer)
library(htmlwidgets)

# Assuming you have today's date in a variable like this:
update_date <- Sys.Date()  # This gives today's date

# Format today's date in a readable format:
formatted_today_date <- format(update_date, format = "%d %B %Y")  # e.g., "05 August 2023"

# Set base currency and a vector of target currencies
base_currency <- "CHF"
target_currencies <- c("EUR", "USD", "JPY", "GBP", "CNY", "INR") # Added "CNY" and "INR"


# Create an empty list to store the exchange rate data for each target currency
exchange_rates_list <- list()

# Loop through each target currency to fetch historical exchange rates from the base currency
for (currency in target_currencies) {
  # Fetch historical rates for current currency in the loop
  exchange_data <-
    historical_exchange_rates(
      base_currency,
      to = currency,
      start_date = "2000-01-01",
      end_date = Sys.Date()
    )
  
  # Store this data in our list, indexed by the currency name
  exchange_rates_list[[currency]] <- exchange_data
}

# Rename the 'rate' column of each dataframe in our list to the respective currency name
for (i in seq_along(target_currencies)) {
  colnames(exchange_rates_list[[i]])[2] <- target_currencies[i]
}

# Collapse all dataframes in the list by 'date' into a single dataframe
fx_rates <-
  Reduce(function(x, y)
    merge(x, y, by = "date", all = TRUE), exchange_rates_list)


# Import PPP data ---------------------------------------------------------
ppp_data <-
  WDI(
    country = c("CHE", "USA", "DEU", "JPN", "GBR", "CHN", "IND"),  # Added "CHN" and "IND"
    indicator = "PA.NUS.PPP",
    start = 1999,
    end = 2023
  )

ppp_data <-
  ppp_data %>%
  select(year, country, PA.NUS.PPP) %>% # Selecting the necessary columns
  spread(key = country, value = PA.NUS.PPP) # Spreading the data based on country

# Calculate ratios relative to Switzerland --------------------------------
ppp_data <-
  ppp_data %>%
  mutate(
    EUR = Germany / Switzerland,
    USD = `United States` / Switzerland,
    JPY = Japan / Switzerland,
    GBP = `United Kingdom` / Switzerland,
    CNY = China / Switzerland,         # Added this line for China
    INR = India / Switzerland          # Added this line for India
  ) %>%
  select(year, EUR, JPY, GBP, USD, CNY, INR)  # Added CNY and INR to selection

# Convert the year column to date
ppp_data$date <-
  as.Date(paste0(ppp_data$year, "-12-31"))

# Create a sequence of daily dates from 1.1.2020 to 30.6.2023
all_dates <-
  seq(as.Date("2020-01-01"), as.Date("2023-06-30"), by = "days")

# Use the zoo package to interpolate data
interpolated_data <-
  as.data.frame(approx(ppp_data$date, ppp_data$EUR, all_dates))
colnames(interpolated_data) <- c("date", "EUR")
for (currency in c("JPY", "GBP", "USD", "CNY", "INR")) {  # Added "CNY" and "INR" to the loop
  temp <-
    as.data.frame(approx(ppp_data$date, ppp_data[[currency]], all_dates))
  interpolated_data[[currency]] <- temp$y
}

# View the data
head(interpolated_data)


# Generate a sequence of daily dates from the start to end of your data
all_dates <-
  seq(as.Date("1999-12-31"), as.Date("2022-12-31"), by = "day")

# # Interpolate for EUR (can repeat this for other currencies)
# interpolated_EUR <-
#   approx(ppp_data$date, ppp_data$EUR, xout = all_dates)

# Initialize df_daily with just the date sequence
df_daily <- data.frame(date = all_dates)

# Interpolate for all currencies including EUR
for (currency in c("EUR", "JPY", "GBP", "USD", "CNY", "INR")) {
  y <- approx(ppp_data$date, ppp_data[[currency]], xout = all_dates)$y
  df_daily[[currency]] <- y
}

# Filter dataframe for 2022 data
df_2022 <-
  df_daily[df_daily$date >= "2022-01-01" &
             df_daily$date <= "2022-12-31",]

# Compute average daily difference for each currency in 2022
avg_diff_EUR <- mean(diff(df_2022$EUR))
avg_diff_JPY <- mean(diff(df_2022$JPY))
avg_diff_GBP <- mean(diff(df_2022$GBP))
avg_diff_USD <- mean(diff(df_2022$USD))
avg_diff_CNY <- mean(diff(df_2022$CNY))  # Added this line for China
avg_diff_INR <- mean(diff(df_2022$INR))  # Added this line for India


# Generate sequence of dates for the first half of 2023
future_dates <-
  seq(from = as.Date("2023-01-01"),
      to = as.Date(Sys.Date()),
      by = "days")

# Create a data frame for these future dates
future_df <- data.frame(date = future_dates)

# Compute extrapolated values using the last value of 2022 and the average difference
future_df$EUR <-
  tail(df_2022$EUR, 1) + cumsum(rep(avg_diff_EUR, length(future_dates)))
future_df$JPY <-
  tail(df_2022$JPY, 1) + cumsum(rep(avg_diff_JPY, length(future_dates)))
future_df$GBP <-
  tail(df_2022$GBP, 1) + cumsum(rep(avg_diff_GBP, length(future_dates)))
future_df$USD <-
  tail(df_2022$USD, 1) + cumsum(rep(avg_diff_USD, length(future_dates)))
future_df$CNY <-   # Added this line for China
  tail(df_2022$CNY, 1) + cumsum(rep(avg_diff_CNY, length(future_dates)))
future_df$INR <-   # Added this line for India
  tail(df_2022$INR, 1) + cumsum(rep(avg_diff_INR, length(future_dates)))

# Combine the original dataframe with the extrapolated dataframe
df_daily <- rbind(df_daily, future_df)

# Assuming you have fx_rates from the previous code, add the year extraction:
fx_rates <- fx_rates %>%
  mutate(year = year(date))

# Merge the two dataframes
combined_data <-
  left_join(fx_rates, df_daily, by = c("date" = "date"))

# Convert the data to a long format for ggplot
fx_rates_vs_ppp_implied_rates <- 
  combined_data %>%
  gather(key = "type_value", value = "rate", EUR.x:INR.x, EUR.y:INR.y) %>%  # Added CNY and INR to selection
  separate(type_value,
           into = c("currency", "type"),
           sep = "\\.")

fx_rates_vs_ppp_implied_rates <- 
  fx_rates_vs_ppp_implied_rates %>%
  mutate(type = case_when(
    type == "x" ~ "Market Rate",
    type == "y" ~ "PPP-Implied Rate",
    TRUE ~ type
  ))


combined_data <- 
  combined_data %>%
  rename(
    EUR_rate = EUR.x,
    USD_rate = USD.x,
    JPY_rate = JPY.x,
    GBP_rate = GBP.x,
    CNY_rate = CNY.x,  # Added CNY
    INR_rate = INR.x,   # Added INR
    
    
    EUR_ppp = EUR.y,
    USD_ppp = USD.y,
    JPY_ppp = JPY.y,
    GBP_ppp = GBP.y,
    CNY_ppp = CNY.y, 
    INR_ppp = INR.y
    
  )


combined_data <- 
  combined_data %>%
  mutate(
    EUR_deviation = (EUR_rate - EUR_ppp) / EUR_ppp,
    USD_deviation = (USD_rate - USD_ppp) / USD_ppp,
    JPY_deviation = (JPY_rate - JPY_ppp) / JPY_ppp,
    GBP_deviation = (GBP_rate - GBP_ppp) / GBP_ppp,
    CNY_deviation = (CNY_rate - CNY_ppp) / CNY_ppp,  # Added CNY
    INR_deviation = (INR_rate - INR_ppp) / INR_ppp   # Added INR
  )

# Reshape the data to long format
long_data <- 
  combined_data %>%
  pivot_longer(
    cols = ends_with("_deviation"), 
    names_to = "Currency", 
    values_to = "Deviation"
  )


# long_data <- long_data %>%
#   filter(date >= as.Date("2009-01-01"))


color_palette <- brewer.pal(length(unique(long_data$Currency)), "Set1")

# Create plotly plot
p <- plot_ly() 

# Loop through each currency to add traces
for (currency in unique(long_data$Currency)) {
  p <- p %>%
    add_trace(
      data = subset(long_data, Currency == currency),
      x = ~date, 
      y = ~Deviation, 
      type = 'scatter', 
      mode = 'lines',
      name = currency,
      line = list(color = color_palette[which(unique(long_data$Currency) == currency)])
    )
}


# Add shaded regions
p <- p %>%
  layout(
    shapes = list(
      # Grey shaded region for overvalued area
      list(
        type = 'rect',
        fillcolor = 'rgba(211, 211, 211, 0.5)', # Light grey with some transparency
        line = list(width = 0),
        x0 = min(long_data$date),
        x1 = max(long_data$date),
        y0 = 0,
        y1 = 1,
        layer = 'below'
      ),
      # Darker grey shaded region for undervalued area
      list(
        type = 'rect',
        fillcolor = 'rgba(169, 169, 169, 0.5)', # Darker grey with some transparency
        line = list(width = 0),
        x0 = min(long_data$date),
        x1 = max(long_data$date),
        y0 = -1,
        y1 = 0,
        layer = 'below'
      )
    )
  )

# Adjust the annotations
p <- p %>%
  layout(
    annotations = list(
      # Annotation for "CHF overvalued"
      list(
        text = "CHF overvalued",
        x = min(long_data$date),
        xanchor = 'left',
        y = 1,  # Position at the very top
        yref = 'paper',
        yanchor = 'top',
        showarrow = FALSE,
        font = list(size = 12)
      ),
      # Annotation for "CHF undervalued"
      list(
        text = "CHF undervalued",
        x = min(long_data$date),
        xanchor = 'left',
        y = 0,  # Position at the very bottom
        yref = 'paper',
        yanchor = 'bottom',
        showarrow = FALSE,
        font = list(size = 12)
      )
    )
  )

# Rest of your plotting code remains unchanged...
final_plot <- p %>%
  layout(
    xaxis = list(title = "Date"),
    yaxis = list(
      title = "Deviation",
      range = c(-1, 1),
      tickformat = '%',  # Format Y axis in percent
      tickvals = seq(-1, 1, 0.25),
      ticktext = scales::percent(seq(-1, 1, 0.25))
    ),
    legend = list(
      title = list(text = "<b>Deviation from PPP-implied exchange rate</b>"),
      orientation = "h",
      xanchor = "center",
      yanchor = "top",
      x = 0.5,
      y = -0.2
    ),
    margin = list(b = 80, t = 40, l = 60, r = 10)  # Adjusted bottom margin for legend
  )

final_plot

# Export to FXRates
saveWidget(final_plot, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/FXRates/DeviationFromPPP.html")






# filtered_long_data <- long_data %>%
#   filter(date >= as.Date("2008-01-01"))
# 
# # Create plotly plot
# p <- plot_ly()
# 
# # Loop through each currency to add traces
# for (currency in unique(filtered_long_data$Currency)) {
#   p <- p %>%
#     add_trace(
#       data = subset(filtered_long_data, Currency == currency),
#       x = ~date,
#       y = ~Deviation,
#       type = 'scatter',
#       mode = 'lines',
#       name = currency,
#       line = list(color = color_palette[which(unique(filtered_long_data$Currency) == currency)])
#     )
# }
# 
# # ... Rest of the code remains the same ...
# 
# # Adjust the y-axis range to -500% to +500%
# p <- p %>%
#   layout(
#     yaxis = list(
#       title = "Deviation",
#       range = c(-5, 5),  # Adjusted y-axis range to -500% to 500%
#       tickformat = '%',
#       tickvals = seq(-5, 5, 1),  # Adjust tick values if needed
#       ticktext = scales::percent(seq(-5, 5, 1))
#     )
#   )
# 
# # ... Rest of the code remains the same ...
# 
# # Display the modified plot
# final_plot <- p %>%
#   layout(
#     xaxis = list(title = "Date"),
#     yaxis = list(
#       title = "Deviation",
#       range = c(-5, 5),  # Adjusted y-axis range to -500% to 500%
#       tickformat = '%',
#       tickvals = seq(-5, 5, 1),  # Adjust tick values if needed
#       ticktext = scales::percent(seq(-5, 5, 1))
#     ),
#     legend = list(
#       title = list(text = "<b>Deviation from PPP-implied exchange rate</b>"),
#       orientation = "h",
#       xanchor = "center",
#       yanchor = "top",
#       x = 0.5,
#       y = -0.2
#     ),
#     margin = list(b = 80, t = 40, l = 60, r = 10)  # Adjusted bottom margin for legend
#     # ... Any other layout settings you want to apply ...
#   )
# 
# final_plot


