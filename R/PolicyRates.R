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
url <- "https://data.snb.ch/api/cube/snboffzisa/data/csv/de"

# Fetch the data and convert it to a data frame
data <- read_csv(url, show_col_types = FALSE) %>% data.frame()

# Extract column names from the second row and adjust the data accordingly
col_names <- unlist(strsplit(as.character(data[2, "CubeId.snboffzisa"]), ";"))
data <- data[-c(1, 2), ]
data <- data %>% data.frame()

# Separate the columns based on the ";" delimiter
data <- separate(data, col = ".",  into = col_names, sep = ";")

# Rename columns for clearer understanding
colnames(data) <- c("Date", "Central Bank", "Policy Rate")

# Replace empty Policy Rate values with NA and convert the values to numeric, also adjusting the scale
data <- data %>% mutate(`Policy Rate` = ifelse(`Policy Rate` == "", NA, `Policy Rate`))
data$`Policy Rate` <- as.numeric(data$`Policy Rate`) / 100

# Rename values in the Central Bank column for clearer interpretation
data <- 
  data %>%
  mutate(`Central Bank` = case_when(
    `Central Bank` == "LZ" ~ "SNB",
    `Central Bank` == "UG0" ~ "SNB_u",
    `Central Bank` == "OG0" ~ "SNB",
    `Central Bank` == "UG1" ~ "US FED_u",
    `Central Bank` == "OG1" ~ "US FED",
    `Central Bank` == "H" ~ "ECB",
    `Central Bank` == "L0" ~ "BoE",
    `Central Bank` == "L1" ~ "BoJ",
    TRUE ~ `Central Bank`
  ))

# Filter out records with missing Policy Rate and certain Central Bank values
data <- 
  data %>% 
  filter(!is.na(`Policy Rate`), `Central Bank` != "US FED_u", `Central Bank` != "SNB_u")

# Format the date to represent the end of the month
data$Date <- as.Date(paste(data$Date, "-01", sep = ""), format = "%Y-%m-%d")
data$Date <- as.Date(format(data$Date, "%Y-%m-01"), format = "%Y-%m-%d") +  months(1) - 1

# Create a copy of the cleaned data for plotting
data_prime_rates <- data

# Determine the number of colors needed based on unique Central Banks
colors <- brewer.pal(length(unique(data_prime_rates$`Central Bank`)), "Set1")


# Plot the data using plotly
p <- plot_ly(
  data = data_prime_rates,
  x = ~Date, 
  y = ~`Policy Rate`,
  color = ~`Central Bank`,
  colors = colors,
  type = "scatter", 
  mode = "lines",
  line = list(width = 2)
)  %>%
  layout(
    xaxis = list(title = "Date"),
    yaxis = list(
      title = "Interest Rate",
      tickformat = ".2%" 
    ),
    showlegend = TRUE,
    legend = list(
      # title = list(text = "Central Bank"),
      orientation = "h",
      xanchor = "center",
      yanchor = "bottom",
      x = 0.5,
      y = -0.2
    ),
    annotations = list(
      list(
        text = paste("Source: World Bank. Updated:", formatted_today_date),
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
        x0 = min(data_prime_rates$Date),
        x1 = max(data_prime_rates$Date),
        y0 = 0,
        y1 = 0,
        line = list(
          color = "black",
          width = 2,
          dash = "dash" 
        )
      )
    )
  )

p

# Export to PolicyRates
# saveWidget(p, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/PolicyRates/myplot.html")

# Update date
saveRDS(Sys.time(), "content/project/PolicyRates/PolicyRates1_update_date.rds")

# Export 
saveWidget(p, "content/project/PolicyRates/PolicyRates1.html")

# Clean-up
rm(list = ls())
gc()




