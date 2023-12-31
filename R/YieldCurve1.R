# Das Skript dient zur Visualisierung von Renditekurven für die Schweiz. Es lädt die Daten von einer externen Quelle, bereitet sie vor und stellt sie in drei verschiedenen Formen dar:
#   
# Eine 3D-Renditekurve für verschiedene Laufzeiten.
# Eine einfache Renditekurve für das aktuellste Datum.
# Einen Plot, der die Renditen für verschiedene Laufzeiten über die Zeit zeigt.

# Load the required libraries for data visualization and manipulation
library(RColorBrewer)
library(tidyverse)
library(scales)
library(htmlwidgets)
library(plotly)

# Retrieve the current system date and format it
update_date <- Sys.Date()
formatted_today_date <- format(update_date, format = "%d %B %Y")

# Define the URL where the data is hosted
url <- "https://data.snb.ch/api/cube/rendoblid/data/csv/de"

# Fetch the data and convert it to a data frame
data <- read_csv(url, show_col_types = FALSE) %>% data.frame()

# Extract column names from the second row and adjust the data accordingly
col_names <- unlist(strsplit(as.character(data[2, "CubeId.rendoblid"]), ";"))
data <- data[-c(1, 2), ]
data <- data %>% data.frame()

# Separate the columns based on the ";" delimiter
data <- separate(data, col = ".",  into = col_names, sep = ";") 
data <- data %>% filter(D0 %in% c("1J", "2J", "3J", "4J", "5J", "6J", "7J", "8J", "9J", "10J0", "15J", "20J", "30J"))

# Rename columns for clearer understanding
colnames(data) <- c("Date", "Maturity", "Yield")

# Replace empty Policy Rate values with NA and convert the values to numeric, also adjusting the scale
data <- data %>% mutate(`Yield` = ifelse(`Yield` == "", NA, `Yield`))

# Fill NA values with the previous non-NA values
data <- data %>% group_by(Maturity) %>% fill(Yield, .direction = "down") %>% ungroup()

# Rename values in the Central Bank column for clearer interpretation
data <- 
  data %>%
  mutate(`Maturity` = case_when(
    `Maturity` == "1J" ~ "1",
    `Maturity` == "2J" ~ "2",
    `Maturity` == "3J" ~ "3",
    `Maturity` == "4J" ~ "4",
    `Maturity` == "5J" ~ "5",
    `Maturity` == "6J" ~ "6",
    `Maturity` == "7J" ~ "7",
    `Maturity` == "8J" ~ "8",
    `Maturity` == "9J" ~ "9",
    `Maturity` == "10J0" ~ "10",
    `Maturity` == "15J" ~ "15",
    `Maturity` == "20J" ~ "20",
    `Maturity` == "30J" ~ "30",
    TRUE ~ `Maturity`
  ))

data <- data %>% 
  spread(key = Maturity, value = Yield, sep = "_")


# Ensure data is sorted by Date and Date is in proper format
data <- data %>% 
  arrange(as.Date(Date, format = "%Y-%m-%d"))

# Define the maturity values in years for Switzerland
maturity_vals_swiss <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 15, 20, 30)  

# Find the range of your yields to help normalize zero
min_yield_swiss <- min(as.numeric(unlist(data[,2:14])), na.rm = TRUE)
max_yield_swiss <- max(as.numeric(unlist(data[,2:14])), na.rm = TRUE)

# Compute the relative position of zero within the range for Switzerland
zero_pos_swiss <- (0 - min_yield_swiss) / (max_yield_swiss - min_yield_swiss)

# Define the custom color scale (similar to US data)
color_scale_swiss <- list(
  c(0, "red"),               # Red for minimum yield (most negative)
  c(zero_pos_swiss, "lightblue"), # Light blue for zero
  c(1, "darkblue")          # Dark blue for maximum yield (most positive)
)

# Plot the yield curve for Switzerland
plot_3d_Swiss_yield_curve <- 
  plot_ly(data = data, x = ~maturity_vals_swiss, y = ~Date, z = as.matrix(data[,-(1:2)]), type = "surface", colorscale = color_scale_swiss) %>%
  layout(scene = list(
    xaxis = list(title = "Maturity (yr)", autorange = "reversed"),
    yaxis = list(title = ""),
    zaxis = list(title = "Yield (%)"),
    camera = list(
      eye = list(x = 2, y = 4.5, z = 2)  # Adjust these values as necessary
    ),
    aspectratio = list(x=1, y=4, z=1)  # Adjust this to make y-axis longer relative to others
  ))

plot_3d_Swiss_yield_curve

# Update date
saveRDS(Sys.time(), "content/project/YieldCurves/plot_3d_Swiss_yield_curve_update_date.rds")

# Export 
saveWidget(plot_3d_Swiss_yield_curve, "content/project/YieldCurves/plot_3d_Swiss_yield_curve.html")










# Convert the Date column to Date format if it's not already
data$Date <- as.Date(data$Date)

# Find the most recent date
most_recent_date <- max(data$Date)

# Filter the data for the most recent date
recent_data <- data %>% filter(Date == most_recent_date)

# Transform the data to long format for plotting
long_recent_data <- recent_data %>% 
  select(-Date) %>% 
  gather(key = "Maturity", value = "Yield") %>%
  mutate(Maturity_Number = as.numeric(gsub("Maturity_", "", Maturity)),
         Yield = as.numeric(Yield)) %>%  # Convert Yield to numeric
  arrange(Maturity_Number) # Arrange by numeric value

# Find the maximum Y value
max_yield <- max(long_recent_data$Yield, na.rm = TRUE)

# Creating the yield curve plot with customized y-axis limits
plot_simple_Swiss_yield_curve <-
  plot_ly(
    data = long_recent_data,
    x = ~ Maturity_Number,
    y = ~ Yield,
    type = 'scatter',
    mode = 'lines',
    text = ~ Maturity,
    hoverinfo = 'text+y'
  )

# Customize the plot
plot_simple_Swiss_yield_curve <-
  plot_simple_Swiss_yield_curve %>% layout(
    title = paste("Yield Curve on", most_recent_date),
    xaxis = list(title = "Maturity (Years)"),
    yaxis = list(title = "Yield (%)", range = c(-0.5, max_yield + 0.5))
  )

# Print the plot
plot_simple_Swiss_yield_curve


# Export 
saveWidget(plot_simple_Swiss_yield_curve, "content/project/YieldCurves/plot_simple_Swiss_yield_curve.html")









# Plot mit den Yields für verschiedene Laufzeiten pro Zeitpunkt über die Zeit --------

# Transform the data to long format
long_data <- data %>%
  gather(key = "Maturity", value = "Yield", -Date) %>%
  mutate(
    Maturity = gsub("Maturity_", "", Maturity),  # Remove 'Maturity_' prefix
    Maturity_Label = ifelse(as.numeric(Maturity) == 1, paste(Maturity, "yr"), paste(Maturity, "yrs")),  # Add 'yr' or 'yrs'
    Yield = as.numeric(Yield)  # Ensure Yield is numeric
  )

# Create the plot with custom hover text
p <- plot_ly(data = long_data, x = ~Date, y = ~Yield, color = ~Maturity_Label, type = 'scatter', mode = 'lines',
             hoverinfo = 'text', text = ~paste(format(Date, "%d %b %Y"), ", ", format(Yield, digits = 4), ", ", Maturity_Label))

# Customize the plot
p <- p %>% layout(title = "Yield vs. Date for Different Maturities",
                  xaxis = list(title = "Date"),
                  yaxis = list(title = "Yield", tickformat = ".2f"))

# Print the plot
p








# Clean-up
rm(list = ls())
gc()


