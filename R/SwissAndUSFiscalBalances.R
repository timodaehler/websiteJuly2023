
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
library(htmlwidgets)


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
    # title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods (1995 onwards)",
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

# plotly_us_deficit



# Update date
saveRDS(Sys.time(), "content/post/writing-technical-content/USFederalDeficit1_update_date.rds")

# Export the plot
saveWidget(plotly_us_deficit, "content/post/writing-technical-content/USFederalDeficit1.html")

