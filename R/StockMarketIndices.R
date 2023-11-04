# Required Libraries ---------------------------------------------------------
library(quantmod)
library(tidyverse)
library(zoo)
library(plotly)
library(htmlwidgets)

# Fetching Data --------------------------------------------------------------
symbols <- c("^GSPC", "^SSMI", "^GDAXI", "^FCHI", "^N225", "^FTSE") # Adding "^FTSE"
names(symbols) <- c("S&P 500 (USA)", "SMI (Switzerland)", "DAX (Germany)", "CAC40 (France)", "Nikkei225 (Japan)", "FTSE (UK)")

# data_list <- lapply(symbols, function(sym) {
#   getSymbols(sym, auto.assign = FALSE)
# })

data_list <- lapply(symbols, function(sym) {
  suppressWarnings(getSymbols(sym, auto.assign = FALSE))
})

merged_data <- do.call(merge, lapply(data_list, function(x) Cl(x)))
reference_date <- as.Date("2007-01-04")
reference_values <- merged_data[reference_date,]
normalized_data <- sweep(merged_data, 2, as.numeric(reference_values), FUN = "/") * 100
normalized_data_interpolated <- na.approx(normalized_data)

df_normalized <- data.frame(Date=index(normalized_data_interpolated), coredata(normalized_data_interpolated)) %>%
  pivot_longer(cols = -Date, names_to = "Index", values_to = "NormalizedValue")

# Plotting with Plotly -------------------------------------------------------
colors = brewer.pal(length(unique(df_normalized$Index)), "Set1")

p_stock_indices <- plot_ly(
  data = df_normalized,
  x = ~Date, 
  y = ~NormalizedValue,
  color = ~Index,
  colors = colors,
  type = "scatter", 
  mode = "lines",
  line = list(width = 2)
)  %>%
  layout(
    # xaxis = list(title = "Date"),
    yaxis = list(title = "Normalized Value"),
    showlegend = TRUE,
    legend = list(
      # title = list(text = "Index"),
      orientation = "h",
      xanchor = "center",
      yanchor = "bottom",
      x = 0.5,
      y = -0.2
    ),
    annotations = list(
      list(
        # text = "Source: Yahoo Finance",
        xref = "paper",
        yref = "paper",
        x = 1,
        xanchor = "right",
        y = -0.3,
        yanchor = "top",
        showarrow = FALSE
      )
    ),
    shapes = list(
      list(
        type = "line",
        x0 = min(df_normalized$Date),
        x1 = max(df_normalized$Date),
        y0 = 100, # as we've normalized to 100
        y1 = 100,
        line = list(
          color = "black",
          width = 2,
          dash = "dash" 
        )
      )
    )
  )

p_stock_indices

# Update date
saveRDS(Sys.time(), "content/project/StockMarketIndices/StockMarketIndices1_update_date.rds")

# Export 
saveWidget(p_stock_indices, "content/project/StockMarketIndices/StockMarketIndices1.html", selfcontained = FALSE)

# # Clean-up
# rm(list = ls())
# gc()






# Required Libraries ---------------------------------------------------------
library(quantmod)
library(tidyverse)
library(plotly)
library(htmlwidgets)
library(zoo)  # Load the zoo package for the na.approx() function

# Fetching Data --------------------------------------------------------------
symbols <- c("^GSPC", "^SSMI", "^GDAXI", "^FCHI", "^N225", "^FTSE")

data_list <- lapply(symbols, function(sym) {
  suppressWarnings(getSymbols(sym, auto.assign = FALSE))
})


merged_data <- do.call(merge, lapply(data_list, function(x) Cl(x)))

# Rename columns for better clarity and association
colnames(merged_data) <- c("S&P 500 (USA)", "SMI (Switzerland)", "DAX (Germany)", "CAC40 (France)", "Nikkei225 (Japan)", "FTSE (UK)")

# Handle Missing Data with Interpolation -------------------------------------
interpolated_data <- na.approx(merged_data)
df_raw <- data.frame(Date=index(interpolated_data), coredata(interpolated_data)) %>%
  pivot_longer(cols = -Date, names_to = "Index", values_to = "Value")

# Create individual plots for each index and store them in a list -------------
colors = brewer.pal(length(unique(df_raw$Index)), "Set1")

plot_list <- lapply(unique(df_raw$Index), function(indx) {
  df_sub <- df_raw %>% filter(Index == indx)
  
  plot_ly(
    data = df_sub,
    x = ~Date, 
    y = ~Value,
    type = "scatter", 
    mode = "lines",
    line = list(width = 2),
    name = indx,
    hoverinfo = "x+y", 
    hovertemplate = paste("<b>", indx, "</b><br>Date: %{x|%d.%m.%Y}<br>Value: %{y:,.0f}")
  ) %>%
    layout(
      xaxis = list(title = "Date"),
      yaxis = list(
        title = "Index Value",
        tickformat = ",.0s"  # Format for 'K'
      ),
      showlegend = FALSE
    )
})

# Combine the plots -----------------------------------------------------------
combined_plot <- subplot(plot_list, nrows=length(unique(df_raw$Index)))

# Adjust the layout for the combined plot to position the legend at the bottom and add a title
combined_plot <- layout(combined_plot,
                        showlegend = TRUE,
                        legend = list(
                          orientation = "h",
                          xanchor = "center",
                          yanchor = "bottom",
                          x = 0.5,
                          y = -0.1
                          # title = list(text = "Index")
                        )
)

combined_plot

# Update date
saveRDS(Sys.time(), "content/project/StockMarketIndices/StockMarketIndices2_update_date.rds")

# Export 
saveWidget(combined_plot, "content/project/StockMarketIndices/StockMarketIndices2.html", selfcontained = FALSE)

# # Clean-up
# rm(list = ls())
# gc()




# 
# # Stockmarkets and Map  ---------------------------------------------------
# # Load Packages
# library(tidyquant)
# library(tidyverse)
# library(lubridate)
# library(htmlwidgets)
# 
# # List of Stock Indices (excluding the unavailable ones, and adding Wilshire 5000, Mexican Bolsa, and TSE)
# indices <- c("^DJI", "^GSPC", "^IXIC", "^FTSE", "^GDAXI", "^FCHI", 
#              "^STOXX50E", "^N225", "^HSI", "000001.SS", "^BSESN", 
#              "^AXJO", "^BVSP", "^SSMI", "^W5000", "BOLSAA.MX", "^GSPTSE")
# 
# # Create a named vector to map index symbols to names
# index_names <- c("^DJI" = "Dow Jones", "^GSPC" = "S&P 500", "^IXIC" = "NASDAQ",
#                  "^FTSE" = "FTSE 100", "^GDAXI" = "DAX", "^FCHI" = "CAC 40", 
#                  "^STOXX50E" = "Euro Stoxx 50", "^N225" = "Nikkei 225", "^HSI" = "Hang Seng",
#                  "000001.SS" = "Shanghai Composite", "^BSESN" = "SENSEX",
#                  "^AXJO" = "ASX 200", "^BVSP" = "Bovespa",
#                  "^SSMI" = "Swiss Market Index (SMI)", "^W5000" = "Wilshire 5000",
#                  "BOLSAA.MX" = "Mexican Bolsa", "^GSPTSE" = "Toronto Stock Exchange")
# 
# # Map index symbols to countries
# index_countries <- c("^DJI" = "United States", "^GSPC" = "United States", "^IXIC" = "United States",
#                      "^FTSE" = "United Kingdom", "^GDAXI" = "Germany", "^FCHI" = "France", 
#                      "^STOXX50E" = "Europe", "^N225" = "Japan", "^HSI" = "Hong Kong",
#                      "000001.SS" = "China", "^BSESN" = "India",
#                      "^AXJO" = "Australia", "^BVSP" = "Brazil",
#                      "^SSMI" = "Switzerland", "^W5000" = "United States",
#                      "BOLSAA.MX" = "Mexico", "^GSPTSE" = "Canada")
# 
# # Date Range
# start_date <- "2017-01-01"
# end_date <- today()  # Today's date
# 
# # Fetch Data
# index_data <- tq_get(indices, 
#                      from = start_date,
#                      to = end_date,
#                      get = "stock.prices")
# 
# # Add index name and country based on the symbol
# index_data <- index_data %>% 
#   mutate(index_name = index_names[symbol],
#          country = index_countries[symbol])
# 
# # View unique index names
# unique(index_data$index_name)
# 
# # View Data
# head(index_data)
# 
# index_data %>% distinct(country, index_name)
# 
# 
# 
# 
# 
# # Define function
# get_index_summary <- function(index_data) {
#   index_summary <- index_data %>%
#     group_by(index_name, country) %>%
#     filter(!is.na(close)) %>%  # Remove NA closing prices
#     arrange(date) %>%
#     summarise(
#       most_recent_close = last(close),
#       most_recent_date = last(date),
#       last_year_close = last(close[date < ymd(paste(year(today()) - 1, "-12-31"))]),
#       last_year_date = last(date[date < ymd(paste(year(today()) - 1, "-12-31"))]),
#       one_year_ago_close = last(close[date <= (most_recent_date - years(1))]),
#       one_year_ago_date = last(date[date <= (most_recent_date - years(1))]),
#       two_years_ago_close = last(close[date <= (most_recent_date - years(2))]),
#       two_years_ago_date = last(date[date <= (most_recent_date - years(2))]),
#       three_years_ago_close = last(close[date <= (most_recent_date - years(3))]),
#       three_years_ago_date = last(date[date <= (most_recent_date - years(3))]),
#       five_years_ago_close = last(close[date <= (most_recent_date - years(5))]),
#       five_years_ago_date = last(date[date <= (most_recent_date - years(5))])
#     )
#   
#   return(index_summary)
# }
# 
# # Generate the summary DataFrame
# index_summary <- get_index_summary(index_data)
# 
# # Print out the DataFrame
# print(index_summary)
# 
# 
# # Create a new DataFrame with percentage changes
# # Modify the index_percentage_changes dataframe to include most_recent_close
# index_percentage_changes <- index_summary %>%
#   mutate(
#     ytd_percentage_change = ((most_recent_close - last_year_close) / last_year_close) * 100,
#     one_year_percentage_change = ((most_recent_close - one_year_ago_close) / one_year_ago_close) * 100,
#     two_year_percentage_change = ((most_recent_close - two_years_ago_close) / two_years_ago_close) * 100,
#     three_year_percentage_change = ((most_recent_close - three_years_ago_close) / three_years_ago_close) * 100,
#     five_year_percentage_change = ((most_recent_close - five_years_ago_close) / five_years_ago_close) * 100
#   ) %>%
#   select(country, index_name, most_recent_close, ytd_percentage_change, one_year_percentage_change, two_year_percentage_change, three_year_percentage_change, five_year_percentage_change)
# 
# 
# # Install required packages if not already installed
# if (!requireNamespace("leaflet", quietly = TRUE)) {
#   install.packages("leaflet")
# }
# 
# # Load packages
# library(leaflet)
# 
# # Create a dataset with country latitude and longitude information
# # Updated country_lat_lon dataframe with all countries from index_percentage_changes
# country_lat_lon <- data.frame(
#   country = c("Australia", "Brazil", "France", "Germany", "United States", "Europe", "United Kingdom", "Hong Kong", "Mexico", "Japan", "India", "China", "Switzerland", "Canada"),
#   latitude = c(-25.2744, -14.2350, 46.6034, 51.1657, 37.0902, 51.1657, 55.3781, 22.3964, 23.6345, 36.2048, 20.5937, 35.8617, 46.8182, 56.1304),
#   longitude = c(133.7751, -51.9253, 2.3522, 10.4515, -95.7129, 10.4515, -3.4360, 114.1095, -102.5528, 138.2529, 78.9629, 104.1954, 8.2275, -106.3468)
# )
# 
# 
# # Merge the dataframes based on the country column
# final_data <- merge(index_percentage_changes, country_lat_lon, by = "country")
# 
# # Print out the new DataFrame
# print(index_percentage_changes)
# 
# index_percentage_changes
# 
# 
# 
# 
# # Merge the dataframes based on the country column
# final_data <- merge(index_percentage_changes, country_lat_lon, by = "country")
# 
# # Einschub
# library(countrycode)
# library(gt)
# library(dplyr)
# 
# # Add alpha2 column
# final_data$alpha2 <- countrycode(final_data$country, "country.name", "iso2c")
# # Handle "Europe" -> "EU"
# final_data$alpha2[final_data$country == "Europe"] <- "EU"
# 
# # Function to generate the image tag with new dimensions
# img_tag <- function(alpha2_code) {
#   return(paste0('<img src="flags/', tolower(alpha2_code), '.png" width="60" height="40"/>'))
# }
# 
# # Create a directory to store flags
# dir.create("flags", showWarnings = FALSE)
# 
# # Download flags based on alpha2 code
# for (code in unique(final_data$alpha2)) {
#   url <- paste0("https://flagcdn.com/128x96/", tolower(code), ".png")
#   destfile <- paste0("flags/", tolower(code), ".png")
#   download.file(url, destfile, mode = "wb")
# }
# 
# # Add img tag column
# final_data$img <- sapply(final_data$alpha2, img_tag)
# 
# # Drop unnecessary columns and rename others
# final_data <- final_data %>%
#   select(-alpha2, -latitude, -longitude) %>%
#   rename(
#     "Index level" = most_recent_close,
#     "YTD % Δ" = ytd_percentage_change,
#     "1Yr % Δ" = one_year_percentage_change,
#     "2Yr % Δ" = two_year_percentage_change,
#     "3Yr % Δ" = three_year_percentage_change,
#     "5Yr % Δ" = five_year_percentage_change,
#     Country = country,
#     Index = index_name
#   )
# 
# # Create the table with gt
# gt_table <- final_data %>%
#   select(img, everything()) %>% # Move 'img' column to the front
#   gt() %>%
#   tab_options(table.width = px(1000)) %>% 
#   fmt_markdown(columns = vars(img)) %>%
#   fmt_number(columns = vars("YTD % Δ", "1Yr % Δ", "2Yr % Δ", "3Yr % Δ", "5Yr % Δ"), decimals = 2) %>%
#   cols_label(img = "")
# 
# gt_table
# 
# 
# # Update date
# saveRDS(Sys.time(), "content/project/StockMarketIndices/StockMarketIndices3_update_date.rds")
# 
# # Export 
# gtsave(gt_table, filename = "~/Desktop/websiteJuly2023/themes/starter-hugo-academic/static/uploads/current_index_performances.html")
# 
# # gtsave(gt_table, "~/Desktop/websiteJuly2023/themes/starter-hugo-academic/static/uploads/my_map.html", selfcontained = TRUE)
# 
# # saveWidget(my_map, "~/Desktop/websiteJuly2023/themes/starter-hugo-academic/static/uploads/my_map.html", selfcontained = TRUE)
# 
# # Manually adjust coordinates for specific indices to avoid overlap
# # final_data <-
# #   final_data %>%
# #   mutate(
# #     latitude = case_when(
# #       index_name == "FTSE 100" ~ 60,  # Move more towards North Atlantic
# #       index_name == "CAC 40" ~ 42,   # Move more towards South West
# #       index_name == "DAX" ~ 54,      # Move more towards North East
# #       index_name == "Swiss Market Index (SMI)" ~ 50, # Move more towards North East
# #       index_name == "Euro Stoxx 50" ~ 60,  # Move more towards North East
# #       index_name == "SENSEX" ~ 10,   # Move Indian index more South
# #       index_name == "Nikkei 225" ~ 45, # Move Japan further Northeast
# #       TRUE ~ latitude
# #     ),
# #     longitude = case_when(
# #       index_name == "FTSE 100" ~ -30, # Move more towards North Atlantic
# #       index_name == "CAC 40" ~ -13,  # Move more towards South West
# #       index_name == "DAX" ~ 20,      # Move more towards North East
# #       index_name == "Swiss Market Index (SMI)" ~ 20, # Move more towards North East
# #       index_name == "Euro Stoxx 50" ~ 40,  # Move more towards North East
# #       index_name == "SENSEX" ~ 80,   # Keep longitude the same for the Indian index
# #       index_name == "Nikkei 225" ~ 160, # Move Japan further Northeast
# #       TRUE ~ longitude
# #     )
# #   )
# 
# # Aggregate index names and YTD changes for each country
# # agg_data <- final_data %>%
# #   group_by(country, latitude, longitude) %>%
# #   summarise(
# #     popup_text = paste0("<strong>", index_name, ":</strong> ", sprintf("%.2f%%", ytd_percentage_change), " YTD", collapse = "<br>")
# #   ) %>%
# #   ungroup()
# 
# agg_data <- agg_data %>%
#   mutate(
#     label_direction = case_when(
#       country == "United Kingdom" ~ 'left',
#       TRUE ~ 'auto'
#     )
#   )
# 
# # Create Leaflet map
# leaflet(agg_data) %>%
#   addProviderTiles(providers$OpenStreetMap) %>%
#   addCircleMarkers(
#     lng = ~longitude,
#     lat = ~latitude,
#     popup = ~sprintf("<strong>Country:</strong> %s <br> %s", country, popup_text),
#     label = ~country,
#     labelOptions = labelOptions(
#       noHide = TRUE, 
#       direction = ~label_direction
#     )
#   )
# 
# # # Create Leaflet map
# # leaflet(agg_data) %>%
# #   addProviderTiles(providers$OpenStreetMap) %>%
# #   addCircleMarkers(
# #     lng = ~longitude,
# #     lat = ~latitude,
# #     popup = ~sprintf(
# #       "<strong>Country:</strong> %s <br> %s",
# #       country,
# #       popup_text
# #     ),
# #     label = ~sprintf("<strong>Country:</strong> %s <br> %s", country, popup_text),
# #     labelOptions = labelOptions(noHide = TRUE, direction = 'auto')
# #   )
# 
# # Save map
# # Create Leaflet map
# my_map <- 
#   leaflet(agg_data) %>%
#   addTiles(
#     urlTemplate = "https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png",
#     attribution = '&copy; <a href="https://www.openstreetmap.org/copyright" target="_blank">OpenStreetMap</a> &copy; <a href="https://carto.com/attributions" target="_blank">CARTO</a>'
#   ) %>%
#   addCircleMarkers(
#     lng = ~longitude,
#     lat = ~latitude,
#     color = "#1664c0", # setting the circle color to darker blue
#     popup = ~sprintf("<strong>Country:</strong> %s <br> %s", country, popup_text),
#     label = ~country,
#     labelOptions = labelOptions(
#       noHide = TRUE, 
#       direction = ~label_direction
#     )
#   ) %>%
#   setView(lng = 2, lat = 48, zoom = 2) # set default center to (0, 0) and zoom level to 2
# 
# my_map
# 
# 
# 
# # Update date
# saveRDS(Sys.time(), "content/project/StockMarketIndices/StockMarketIndices4_update_date.rds")
# 
# # Export 
# # saveWidget(combined_plot, "content/project/StockMarketIndices/StockMarketIndices2.html", selfcontained = FALSE)
# saveWidget(my_map, "~/Desktop/websiteJuly2023/themes/starter-hugo-academic/static/uploads/my_map.html", selfcontained = TRUE)
# 
# # # Clean-up
# # rm(list = ls())
# # gc()


