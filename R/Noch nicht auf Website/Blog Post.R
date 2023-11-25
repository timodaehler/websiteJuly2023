# # Load necessary libraries
# library(fredr)
# library(ggplot2)
# library(dplyr)
# 
# # Download U.S. federal surplus or deficit data (FYFSGDA188S)
# deficit_data <- fredr(series_id = "FYFSGDA188S", observation_start = as.Date("1900-01-01"))
# 
# # Download U.S. recession data (USREC)
# recession_data <- fredr(series_id = "USARECDM", observation_start = as.Date("1900-01-01"))
# 
# # Prepare the recession data
# recession_periods <- recession_data %>%
#   filter(value == 1) %>%
#   group_by(year = as.integer(format(date, "%Y"))) %>%
#   summarize(start = min(date), end = max(date)) %>%
#   ungroup() %>% 
#   filter(year >= 1995)
# 
# # Convert TIME to Date format in deficit data
# deficit_data <- deficit_data %>%
#   mutate(date = as.Date(paste0(date, "-01-01")))  %>% # Assuming date is just the year
#   filter(date >= as.Date("1995-01-01"))
# 
# # # Create the ggplot
# # ggplot_deficit <- ggplot(deficit_data, aes(x = date, y = value)) +
# #   geom_line() +  # Plotting the time series
# #   geom_rect(data = recession_periods, inherit.aes = FALSE, 
# #             aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
# #             fill = "grey", alpha = 0.5) +  # Adding the recession periods
# #   geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Horizontal line at 0
# #   labs(title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods", 
# #        x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
# #   theme_minimal()
# 
# 
# 
# library(plotly)
# 
# # Find the range for y-axis to define the height of the rectangles
# y_range <- range(deficit_data$value, na.rm = TRUE)
# 
# plotly_deficit <- plot_ly(deficit_data, x = ~date, y = ~value, type = 'scatter', mode = 'lines') %>%
#   layout(
#     title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods",
#     xaxis = list(title = "Year"),
#     yaxis = list(title = "Federal Surplus or Deficit (% of GDP)"),
#     shapes = lapply(1:nrow(recession_periods), function(i) {
#       list(
#         type = "rect",
#         x0 = recession_periods$start[i],
#         x1 = recession_periods$end[i],
#         y0 = y_range[1] - abs(y_range[1] * 0.1),  # Slightly below the minimum value
#         y1 = y_range[2] + abs(y_range[2] * 0.1),  # Slightly above the maximum value
#         fillcolor = "grey",
#         opacity = 0.5,
#         line = list(width = 0)
#       )
#     })
#   )
# 
# # Optionally, add a horizontal line at y = 0
# plotly_deficit <- plotly_deficit %>%
#   add_trace(x = c(min(deficit_data$date), max(deficit_data$date)), y = c(0, 0),
#             type = "scatter", mode = "lines", 
#             line = list(color = "black", dash = "dash"))
# 
# plotly_deficit
# 
# 
# 
# 
# 
# 
# 
# 
# 
# # Switzerland -------------------------------------------------------------
# 
# # Load necessary libraries
# library(fredr)
# library(ggplot2)
# library(dplyr)
# library(httr)
# library(readr)
# library(countrycode)
# 
# # Set FRED API key
# # fredr_set_key('your_api_key') # Uncomment and set your key if needed
# 
# # Download Swiss recession data (CHEREC) from FRED
# swiss_recession_data <- fredr(series_id = "CHEREC", observation_start = as.Date("1970-01-01"))
# 
# # Download OECD data for general government net lending/borrowing
# url <- "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.GGNLEND.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en"
# response <- read_csv(url)
# response <- as.data.frame(response)
# 
# 
# # Filter OECD data for Switzerland (use the LOCATION code for Switzerland, usually 'CHE')
# swiss_oecd_data <- response %>%
#   filter(LOCATION == "CHE", MEASURE == "PC_GDP") %>%
#   mutate(TIME = as.integer(TIME), Value = as.numeric(Value))
# 
# # Convert TIME to Date format
# swiss_oecd_data <- swiss_oecd_data %>%
#   mutate(date = as.Date(paste0(TIME, "-01-01")))
# 
# # You might want to check the range of years and adjust if needed
# 
# 
# # Prepare the recession data for Switzerland
# swiss_recession_periods <- swiss_recession_data %>%
#   filter(value == 1) %>%
#   group_by(year = as.integer(format(date, "%Y"))) %>%
#   summarize(start = min(date), end = max(date)) %>%
#   ungroup() %>% 
#   filter(year >= min(swiss_oecd_data$TIME)) # Adjust the start year based on the OECD data
# 
# # Find the range for y-axis to define the height of the rectangles
# swiss_y_range <- range(swiss_oecd_data$Value, na.rm = TRUE)
# 
# # Create the plotly plot
# plotly_swiss_deficit <- plot_ly(swiss_oecd_data, x = ~date, y = ~Value, type = 'scatter', mode = 'lines') %>%
#   layout(
#     title = "Swiss Federal Surplus or Deficit (% of GDP) with Recession Periods",
#     xaxis = list(title = "Year"),
#     yaxis = list(title = "Federal Surplus or Deficit (% of GDP)"),
#     shapes = lapply(1:nrow(swiss_recession_periods), function(i) {
#       list(
#         type = "rect",
#         x0 = swiss_recession_periods$start[i],
#         x1 = swiss_recession_periods$end[i],
#         y0 = swiss_y_range[1] - abs(swiss_y_range[1] * 0.1),
#         y1 = swiss_y_range[2] + abs(swiss_y_range[2] * 0.1),
#         fillcolor = "grey",
#         opacity = 0.5,
#         line = list(width = 0)
#       )
#     })
#   )
# 
# # Optionally, add a horizontal line at y = 0
# plotly_swiss_deficit <- plotly_swiss_deficit %>%
#   add_trace(x = c(min(swiss_oecd_data$date), max(swiss_oecd_data$date)), y = c(0, 0),
#             type = "scatter", mode = "lines", 
#             line = list(color = "black", dash = "dash"))
# 
# plotly_swiss_deficit
# 
# 
# # 
# # 
# # # Convert LOCATION codes to country names
# # oecd_data$CountryName <- countrycode(oecd_data$LOCATION, "iso3c", "country.name")
# # 
# # # Filter OECD data for Switzerland from 1970 onwards
# # swiss_data <- oecd_data %>%
# #   filter(CountryName == "Switzerland", TIME >= 1970)
# # 
# # # Prepare the recession data for Switzerland
# # swiss_recession_periods <- swiss_recession_data %>%
# #   filter(value == 1) %>%
# #   group_by(year = as.integer(format(date, "%Y"))) %>%
# #   summarize(start = min(date), end = max(date)) %>%
# #   ungroup() %>%
# #   filter(start >= as.Date("1995-01-01"))
# # 
# # # Convert TIME to Date format in Swiss data
# # swiss_data <- swiss_data %>%
# #   mutate(TIME = as.Date(paste0(TIME, "-01-01")))  # Assuming TIME is just the year
# # 
# # # Create the ggplot for Switzerland
# # ggplot(swiss_data, aes(x = TIME, y = Value)) +
# #   geom_line() +  # Plotting the time series
# #   geom_rect(data = swiss_recession_periods, inherit.aes = FALSE, 
# #             aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
# #             fill = "grey", alpha = 0.5) +  # Adding the recession periods
# #   geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Horizontal line at 0
# #   labs(title = "Swiss Federal Surplus or Deficit (% of GDP) with Recession Periods", 
# #        x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
# #   theme_minimal()
# # 
# # 
# # 
# # 
# # 
# # library(gridExtra)
# # # Store the U.S. plot in a variable instead of displaying it
# # us_plot <- ggplot(deficit_data, aes(x = date, y = value)) +
# #   geom_line() +
# #   geom_rect(data = recession_periods, inherit.aes = FALSE, 
# #             aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
# #             fill = "grey", alpha = 0.5) +
# #   geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
# #   labs(title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods", 
# #        x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
# #   theme_minimal()
# # 
# # # [Your existing code for creating the Swiss plot]
# # # ...
# # 
# # # Store the Swiss plot in a variable instead of displaying it
# # swiss_plot <- ggplot(swiss_data, aes(x = TIME, y = Value)) +
# #   geom_line() +
# #   geom_rect(data = swiss_recession_periods, inherit.aes = FALSE, 
# #             aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
# #             fill = "grey", alpha = 0.5) +
# #   geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
# #   labs(title = "Swiss Federal Surplus or Deficit (% of GDP) with Recession Periods", 
# #        x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
# #   theme_minimal()
# # 
# # # Load the gridExtra package
# # library(gridExtra)
# # 
# # # Combine the plots into one chart
# # grid.arrange(us_plot, swiss_plot, ncol = 1)
# 
# 
# 
# # United States -------------------------------------------------------------
# 
# # Load necessary libraries
# library(fredr)
# library(ggplot2)
# library(dplyr)
# library(httr)
# library(readr)
# library(countrycode)
# 
# # Set FRED API key
# # fredr_set_key('your_api_key') # Uncomment and set your key if needed
# 
# # Download U.S. recession data (USARECDM) from FRED
# us_recession_data <- fredr(series_id = "USARECDM", observation_start = as.Date("1970-01-01"))
# 
# # Download OECD data for general government net lending/borrowing
# url <- "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.GGNLEND.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en"
# response <- read_csv(url)
# response <- as.data.frame(response)
# 
# # Filter OECD data for the United States (use the LOCATION code for the United States, usually 'USA')
# us_oecd_data <- response %>%
#   filter(LOCATION == "USA", MEASURE == "PC_GDP") %>%
#   mutate(TIME = as.integer(TIME), Value = as.numeric(Value))
# 
# # Convert TIME to Date format
# us_oecd_data <- us_oecd_data %>%
#   mutate(date = as.Date(paste0(TIME, "-01-01")))
# 
# # Prepare the recession data for the United States
# us_recession_periods <- us_recession_data %>%
#   filter(value == 1) %>%
#   group_by(year = as.integer(format(date, "%Y"))) %>%
#   summarize(start = min(date), end = max(date)) %>%
#   ungroup() %>% 
#   filter(year >= min(us_oecd_data$TIME)) # Adjust the start year based on the OECD data
# 
# # Find the range for y-axis to define the height of the rectangles
# us_y_range <- range(us_oecd_data$Value, na.rm = TRUE)
# 
# 
# # Create the main plotly plot for deficit data
# plotly_us_deficit <- plot_ly() %>%
#   add_trace(data = us_oecd_data, x = ~date, y = ~Value, 
#             type = 'scatter', mode = 'lines', 
#             name = "Deficit",  
#             text = ~paste(format(date, "%b %Y, "), sprintf("%.1f%%", Value)),  # Custom text for each point
#             hoverinfo = "text") %>%
#   layout(
#     title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods (1995 onwards)",
#     xaxis = list(title = "Year"),
#     yaxis = list(title = "Federal Surplus or Deficit (% of GDP)"),
#     shapes = lapply(1:nrow(us_recession_periods), function(i) {
#       list(
#         type = "rect",
#         x0 = us_recession_periods$start[i],
#         x1 = us_recession_periods$end[i],
#         y0 = us_y_range[1] - abs(us_y_range[1] * 0.1),
#         y1 = us_y_range[2] + abs(us_y_range[2] * 0.1),
#         fillcolor = "grey",
#         opacity = 0.5,
#         line = list(width = 0)
#       )
#     })
#   )
# 
# # Add a horizontal line at y = 0 separately
# plotly_us_deficit <- plotly_us_deficit %>%
#   add_trace(x = c(min(us_oecd_data$date), max(us_oecd_data$date)), y = c(0, 0),
#             type = "scatter", mode = "lines", 
#             line = list(color = "black", dash = "dash"),
#             showlegend = FALSE)  # Hide this from the legend
# 
# plotly_us_deficit
# 
# 
# 






# Swiss 
# # Switzerland -------------------------------------------------------------

# Load necessary libraries
library(fredr)
library(ggplot2)
library(dplyr)
library(httr)
library(readr)
library(countrycode)
library(lubridate)



# Download Swiss recession data (CHEREC) from FRED, starting from 1995
swiss_recession_data <- fredr(series_id = "CHEREC", observation_start = as.Date("1995-01-01"))

# Download OECD data for general government net lending/borrowing
url <- "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.GGNLEND.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en"
response <- read_csv(url)
response <- as.data.frame(response)

# Filter OECD data for Switzerland (use the LOCATION code for Switzerland, usually 'CHE'), starting from 1995
swiss_oecd_data <- response %>%
  filter(LOCATION == "CHE", MEASURE == "PC_GDP", TIME >= 1995) %>%
  mutate(TIME = as.integer(TIME), Value = as.numeric(Value))

# Convert TIME to Date format
swiss_oecd_data <- swiss_oecd_data %>%
  mutate(date = as.Date(paste0(TIME, "-01-01")))

# Prepare the recession data for Switzerland, adjusted to start from 1995
swiss_recession_periods <- swiss_recession_data %>%
  filter(value == 1) %>%
  group_by(year = as.integer(format(date, "%Y"))) %>%
  summarize(start = min(date), end = max(date)) %>%
  ungroup() %>% 
  filter(year >= 1995) # Ensure data starts from 1995

# Adjust the end date of each recession period to the end of the month
swiss_recession_periods <- swiss_recession_periods %>%
  mutate(end = ceiling_date(end, unit = "month") - days(1))

# Find the range for y-axis to define the height of the rectangles
swiss_y_range <- range(swiss_oecd_data$Value, na.rm = TRUE)

plotly_swiss_deficit <- plot_ly() %>%
  add_trace(data = swiss_oecd_data, x = ~date, y = ~Value, 
            type = 'scatter', mode = 'lines', 
            name = "Deficit",  
            text = ~paste(format(date, "%Y"), sprintf("%.1f%%", Value)),  # Custom text for each point, showing only year
            hoverinfo = "text") %>%
  layout(
    title = "Swiss Federal Surplus or Deficit (% of GDP) with Recession Periods (1995 onwards)",
    xaxis = list(title = "Year"),
    yaxis = list(title = "Federal Surplus or Deficit (% of GDP)", range = c(-16, 2)),
    shapes = lapply(1:nrow(swiss_recession_periods), function(i) {
      list(
        type = "rect",
        x0 = swiss_recession_periods$start[i],
        x1 = swiss_recession_periods$end[i],
        y0 = -16,  # Common y-axis lower limit
        y1 = 2,    # Common y-axis upper limit
        fillcolor = "grey",
        opacity = 0.5,
        line = list(width = 0)
      )
    })
  )


# Add a horizontal line at y = 0 separately
plotly_swiss_deficit <- plotly_swiss_deficit %>%
  add_trace(x = c(min(swiss_oecd_data$date), max(swiss_oecd_data$date)), y = c(0, 0),
            type = "scatter", mode = "lines", 
            line = list(color = "black", dash = "dash"),
            showlegend = FALSE)  # Hide this from the legend

plotly_swiss_deficit








# United States -------------------------------------------------------------

# Load necessary libraries
library(fredr)
library(ggplot2)
library(dplyr)
library(httr)
library(readr)
library(countrycode)

# Set FRED API key
# fredr_set_key('your_api_key') # Uncomment and set your key if needed

# Download U.S. recession data (USARECDM) from FRED, starting from 1995
us_recession_data <- fredr(series_id = "USARECDM", observation_start = as.Date("1995-01-01"))

# Download OECD data for general government net lending/borrowing
url <- "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.GGNLEND.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en"
response <- read_csv(url)
response <- as.data.frame(response)

# Filter OECD data for the United States (use the LOCATION code for the United States, usually 'USA'), starting from 1995
us_oecd_data <- response %>%
  filter(LOCATION == "USA", MEASURE == "PC_GDP", TIME >= 1995) %>%
  mutate(TIME = as.integer(TIME), Value = as.numeric(Value))

# Convert TIME to Date format
us_oecd_data <- us_oecd_data %>%
  mutate(date = as.Date(paste0(TIME, "-01-01")))

# Prepare the recession data for the United States, adjusted to start from 1995
us_recession_periods <- us_recession_data %>%
  filter(value == 1) %>%
  group_by(year = as.integer(format(date, "%Y"))) %>%
  summarize(start = min(date), end = max(date)) %>%
  ungroup() %>% 
  filter(year >= 1995) # Ensure data starts from 1995

# Find the range for y-axis to define the height of the rectangles
us_y_range <- range(us_oecd_data$Value, na.rm = TRUE)

# Create the main plotly plot for deficit data
plotly_us_deficit <- plot_ly() %>%
  add_trace(data = us_oecd_data, x = ~date, y = ~Value, 
            type = 'scatter', mode = 'lines', 
            name = "Deficit",  
            text = ~paste(format(date, "%Y"), sprintf("%.1f%%", Value)),  # Custom text for each point, showing only year
            hoverinfo = "text") %>%
  layout(
    title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods (1995 onwards)",
    xaxis = list(title = "Year"),
    yaxis = list(title = "Federal Surplus or Deficit (% of GDP)", range = c(-16, 2)),
    shapes = lapply(1:nrow(us_recession_periods), function(i) {
      list(
        type = "rect",
        x0 = us_recession_periods$start[i],
        x1 = us_recession_periods$end[i],
        y0 = -16,  # Common y-axis lower limit
        y1 = 2,    # Common y-axis upper limit
        fillcolor = "grey",
        opacity = 0.5,
        line = list(width = 0)
      )
    })
  )


# Add a horizontal line at y = 0 separately
plotly_us_deficit <- plotly_us_deficit %>%
  add_trace(x = c(min(us_oecd_data$date), max(us_oecd_data$date)), y = c(0, 0),
            type = "scatter", mode = "lines", 
            line = list(color = "black", dash = "dash"),
            showlegend = FALSE)  # Hide this from the legend

plotly_us_deficit
