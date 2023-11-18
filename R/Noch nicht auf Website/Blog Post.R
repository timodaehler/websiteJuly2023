# Load necessary libraries
library(fredr)
library(ggplot2)
library(dplyr)

# Download U.S. federal surplus or deficit data (FYFSGDA188S)
deficit_data <- fredr(series_id = "FYFSGDA188S", observation_start = as.Date("1900-01-01"))

# Download U.S. recession data (USREC)
recession_data <- fredr(series_id = "USREC", observation_start = as.Date("1900-01-01"))

# Prepare the recession data
recession_periods <- recession_data %>%
  filter(value == 1) %>%
  group_by(year = as.integer(format(date, "%Y"))) %>%
  summarize(start = min(date), end = max(date)) %>%
  ungroup() %>% 
  filter(year >= 1995)

# Convert TIME to Date format in deficit data
deficit_data <- deficit_data %>%
  mutate(date = as.Date(paste0(date, "-01-01")))  %>% # Assuming date is just the year
  filter(date >= as.Date("1995-01-01"))

# Create the ggplot
ggplot(deficit_data, aes(x = date, y = value)) +
  geom_line() +  # Plotting the time series
  geom_rect(data = recession_periods, inherit.aes = FALSE, 
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
            fill = "grey", alpha = 0.5) +  # Adding the recession periods
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Horizontal line at 0
  labs(title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods", 
       x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
  theme_minimal()










# Switzerland -------------------------------------------------------------

# Load necessary libraries
library(fredr)
library(ggplot2)
library(dplyr)
library(httr)
library(readr)
library(countrycode)

# Set FRED API key
# fredr_set_key('your_api_key') # Uncomment and set your key if needed

# Download Swiss recession data (CHEREC) from FRED
swiss_recession_data <- fredr(series_id = "CHEREC", observation_start = as.Date("1970-01-01"))

# Download OECD data for general government net lending/borrowing
url <- "https://stats.oecd.org/sdmx-json/data/DP_LIVE/.GGNLEND.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en"
response <- GET(url)
if (status_code(response) == 200) {
  data <- content(response, "text", encoding = "UTF-8")
  tmp_file <- tempfile(fileext = ".csv")
  writeLines(data, tmp_file)
  oecd_data <- read_csv(tmp_file)
} else {
  stop("Error in downloading OECD data")
}

# Convert LOCATION codes to country names
oecd_data$CountryName <- countrycode(oecd_data$LOCATION, "iso3c", "country.name")

# Filter OECD data for Switzerland from 1970 onwards
swiss_data <- oecd_data %>%
  filter(CountryName == "Switzerland", TIME >= 1970)

# Prepare the recession data for Switzerland
swiss_recession_periods <- swiss_recession_data %>%
  filter(value == 1) %>%
  group_by(year = as.integer(format(date, "%Y"))) %>%
  summarize(start = min(date), end = max(date)) %>%
  ungroup() %>%
  filter(start >= as.Date("1995-01-01"))

# Convert TIME to Date format in Swiss data
swiss_data <- swiss_data %>%
  mutate(TIME = as.Date(paste0(TIME, "-01-01")))  # Assuming TIME is just the year

# Create the ggplot for Switzerland
ggplot(swiss_data, aes(x = TIME, y = Value)) +
  geom_line() +  # Plotting the time series
  geom_rect(data = swiss_recession_periods, inherit.aes = FALSE, 
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
            fill = "grey", alpha = 0.5) +  # Adding the recession periods
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +  # Horizontal line at 0
  labs(title = "Swiss Federal Surplus or Deficit (% of GDP) with Recession Periods", 
       x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
  theme_minimal()





library(gridExtra)
# Store the U.S. plot in a variable instead of displaying it
us_plot <- ggplot(deficit_data, aes(x = date, y = value)) +
  geom_line() +
  geom_rect(data = recession_periods, inherit.aes = FALSE, 
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
            fill = "grey", alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  labs(title = "U.S. Federal Surplus or Deficit (% of GDP) with Recession Periods", 
       x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
  theme_minimal()

# [Your existing code for creating the Swiss plot]
# ...

# Store the Swiss plot in a variable instead of displaying it
swiss_plot <- ggplot(swiss_data, aes(x = TIME, y = Value)) +
  geom_line() +
  geom_rect(data = swiss_recession_periods, inherit.aes = FALSE, 
            aes(xmin = start, xmax = end, ymin = -Inf, ymax = Inf), 
            fill = "grey", alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  labs(title = "Swiss Federal Surplus or Deficit (% of GDP) with Recession Periods", 
       x = "Year", y = "Federal Surplus or Deficit (% of GDP)") +
  theme_minimal()

# Load the gridExtra package
library(gridExtra)

# Combine the plots into one chart
grid.arrange(us_plot, swiss_plot, ncol = 1)
