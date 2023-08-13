# An optional custom script to run before Hugo builds your site.
# You can delete it if you do not need it.


library(RColorBrewer)
library(tidyverse)
library(scales)
library(hrbrthemes)
library(htmlwidgets)

# Assuming you have today's date in a variable like this:
update_date <- Sys.Date()  # This gives today's date

# Format today's date in a readable format:
formatted_today_date <- format(update_date, format = "%d %B %Y")  # e.g., "05 August 2023"


# Dieser Teil funktioniert ------------------------------------------------
# Replace the URL with the actual API link
url <- "https://data.snb.ch/api/cube/snboffzisa/data/csv/de"

# Use read_csv() to import the data into R
data <- read_csv(url, show_col_types = FALSE) %>% data.frame()

# Step 1: Extract the second row and use it as column names
col_names <- unlist(strsplit(as.character(data[2, "CubeId.snboffzisa"]), ";"))
data <- data[-c(1, 2), ]  # Remove the second row from the dataframe
data <- data %>% data.frame()

data <- separate(data, col = ".",  into = col_names, sep = ";")

colnames(data) <- col_names

data <- data %>% mutate(Value = ifelse(Value == "", NA, Value))
# Convert 'Value' column to numeric
data$Value <- as.numeric(data$Value)

# Convert 'Value' column to numeric and divide by 100
data$Value <- as.numeric(data$Value) / 100

data <- 
  data %>%
  mutate(D0 = case_when(
    D0 == "LZ" ~ "SNB",
    D0 == "UG0" ~ "SNB_u",
    D0 == "OG0" ~ "SNB",
    D0 == "UG1" ~ "FED_u",
    D0 == "OG1" ~ "FED",
    D0 == "H" ~ "EZB",
    D0 == "L0" ~ "UK",
    D0 == "L1" ~ "JPY",
    TRUE ~ D0  # Keep the original value if not matched to any of the above
  ))

data <- 
  data %>% 
  filter(!is.na(Value), D0 != "FED_u", D0 != "SNB_u")

# Convert "Date" column to a proper Date object with the last day of each month
data$Date <- as.Date(paste(data$Date, "-01", sep = ""), format = "%Y-%m-%d")
data$Date <- as.Date(format(data$Date, "%Y-%m-01"), format = "%Y-%m-%d") +  months(1) - 1

data_prime_rates <- data

# Plot using ggplot
ggplot(data_prime_rates, aes(x = Date, y = Value, color = D0)) +
  geom_line() +
  geom_hline(yintercept = 0, color = "black", size = 0.5) + 
  labs(x = "Date", 
       y = "Interest Rate", 
       title = "Prime Rate over Time", 
       color = "Central Bank", 
       caption = paste("Source: World Bank. Updated:", formatted_today_date)) +
  # scale_color_manual(values = c("SNB" = "red", "FED_u" = "blue", "FED_o" = "green", "EZB" = "purple", "UK" = "orange", "JPY" = "yellow") ) +
  scale_y_continuous(labels = percent) +
  # theme_light()
  scale_color_ipsum() +           
  theme_ipsum() 






# Load the necessary packages
library(ggplot2)
library(plotly)
library(jsonlite)
library(htmlwidgets)

data_prime_rates <- 
  data_prime_rates %>% 
  as_tibble() %>% 
  mutate(Bank = D0) %>% 
  select(-D0)

# Create a ggplot
p <- 
  ggplot(data_prime_rates, aes(x = Date, y = Value, color = Bank, group = Bank)) +
  geom_line() +
  geom_hline(yintercept = 0, color = "black", size = 0.5) + 
  labs(x = "Date", 
       y = "Interest Rate", 
       title = "Prime Rate over Time", 
       color = "Central Bank", 
       caption = paste("Source: World Bank. Updated:", formatted_today_date)) +
  scale_y_continuous(labels = percent) +
  # theme_minimal()
  scale_color_ipsum() +
  theme_ipsum()

# Convert it to a Plotly plot
p_plotly <- ggplotly(p)

# Extract the underlying list structure
p_build <- plotly_build(p_plotly)
p_list <- list(data = p_build$x$data, layout = p_build$x$layout)
  
# Save as a JSON file
write_json(p_list, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/example/myplot.json")


library(plotly)
library(htmlwidgets)

# Generate a sample plotly plot
p <- plot_ly(data = mtcars, x = ~mpg, y = ~wt, type = "scatter", mode = "markers")

# Save the plot as an HTML widget
saveWidget(p, "/Users/timodaehler_1/Desktop/websiteJuly2023/static/project/example/myplot.html")





num_colors <- length(unique(data_prime_rates$D0))
colors <- brewer.pal(num_colors, "Set1")










library(plotly)

# Create the plotly plot
p <- plot_ly(
  data = data_prime_rates,
  x = ~Date, 
  y = ~Value,
  color = ~D0,
  colors = colors,  # Use the colors from RColorBrewer
  type = "scatter", 
  mode = "lines",
  line = list(width = 2)
)  %>%
  layout(
    title = paste("Prime Rate over Time<br><sub>Source: World Bank. Updated:", formatted_today_date, "</sub>"), 
    xaxis = list(
      title = "Date",
      titlefont = list(family = "Arial"),
      tickfont = list(family = "Arial")
    ),
    yaxis = list(
      title = "Interest Rate",
      titlefont = list(family = "Arial"),
      tickfont = list(family = "Arial"),
      tickformat = ".2%" 
    ),
    font = list(family = "Arial"),
    showlegend = TRUE,
    legend = list(
      title = list(text = "Central Bank", font = list(family = "Arial")),
      font = list(family = "Arial")
    ),
    annotations = list(
      list(
        text = paste("Source: World Bank. Updated:", formatted_today_date),
        font = list(family = "Arial"),
        xref = "paper",
        yref = "paper",
        x = 1,
        xanchor = "right",
        y = -0.2,
        yanchor = "top",
        showarrow = FALSE
      )
    ),
    shapes = list(
      # Line at y=0
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




# If you want to use specific colors like in your commented scale_color_manual(), 
# you can set them using layout() and colorscale option.
# colorscale <- list(
#   list(0, "red"),
#   list(0.2, "blue"),
#   list(0.4, "green"),
#   list(0.6, "purple"),
#   list(0.8, "orange"),
#   list(1, "yellow")
# )

# p <- p %>% layout(colorscale = colorscale)
# ... [previous code]
p
# To save it as an HTML widget, you'd use:


saveWidget(p, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/example/myplot.html", selfcontained = FALSE)












# Zweieter TEil -----------------------------------------------------------
library(quantmod)
library(tidyverse)  # for data manipulation functions like gather()
library(zoo)        # for na.approx()
library(plotly)     # for ggplotly() and other plotly functionalities
library(htmlwidgets) # for saveWidget()

# Define the list of symbols (all are price indices except for the DAX)
symbols <- c("^GSPC", "^SSMI", "^GDAXI", "^FCHI", "^N225")
names(symbols) <- c("S&P500", "SMI", "DAX", "CAC40", "Nikkei225")

# Load data into a list of xts objects
data_list <- lapply(symbols, function(sym) {
  getSymbols(sym, auto.assign = FALSE)
})

# Merge all xts objects into one by their "Adjusted" column
merged_data <- do.call(merge, lapply(data_list, function(x) Cl(x)))

# Extract the values from January 12, 2022
reference_date <- as.Date("2007-01-04")
reference_values <- merged_data[reference_date,]

# Normalize each index based on those values
normalized_data <- sweep(merged_data, 2, as.numeric(reference_values), FUN = "/") * 100

# Interpolate missing values for normalized_data
normalized_data_interpolated <- na.approx(normalized_data)

# Convert xts to data frame and gather for plotting
df_normalized <- data.frame(Date=index(normalized_data_interpolated), coredata(normalized_data_interpolated)) %>%
  gather(key="Index", value="NormalizedValue", -Date)

# Create ggplot plot
g <- ggplot(df_normalized, aes(x=Date, y=NormalizedValue, color=Index)) +
  geom_line() +
  theme_minimal() +
  labs(title="Stock Market Indices Over Time (Normalized to 12 Jan 2022)", y="Normalized Value", x="Date")

# Convert ggplot object to plotly object
p <- ggplotly(g)

# Save the plotly plot as an HTML file
saveWidget(p, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/example/myplot_2.html", selfcontained = FALSE)









