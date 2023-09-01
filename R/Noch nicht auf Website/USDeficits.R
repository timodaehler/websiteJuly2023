library(fredr)

# Fetch the data
data_fred <- fredr(series_id = "FYFSGDA188S", observation_start = as.Date("1959-01-01"), observation_end = as.Date("2023-12-31"))

# Convert the data to a tibble for easier manipulation
data_fred_tibble <- as_tibble(data_fred)

# Create a Plotly line plot
plot_fred <- data_fred_tibble %>%
  plot_ly(x = ~date, y = ~value, type = 'scatter', mode = 'lines') %>%
  layout(title = "Federal Surplus or Deficit as Percent of GDP",
         xaxis = list(title = "Year"),
         yaxis = list(title = "Percentage"))

# Display the plot
plot_fred






# 
# library(plotly)
# library(dplyr)
# 
# # Load the datasets
# data_fred <- read.csv("FYFSGDA188S.csv")
# recession_dates <- read.csv("USREC.csv")
# 
# # Convert DATE columns to Date type
# data_fred$DATE <- as.Date(data_fred$DATE)
# recession_dates$DATE <- as.Date(recession_dates$DATE)
# 
# # Get the start and end dates of recessions
# recession_starts <- recession_dates$DATE[recession_dates$USREC == 1]
# recession_ends <- c(recession_starts[-1] - 1, tail(recession_dates$DATE, n=1))
# 
# # Plot the data with shaded recession bars
# plot_fred <- data_fred %>%
#   plot_ly(x = ~DATE, y = ~FYFSGDA188S, type = 'scatter', mode = 'lines', name = "Deficit/Surplus") %>%
#   layout(title = "Federal Surplus or Deficit as Percent of GDP",
#          xaxis = list(title = "Year"),
#          yaxis = list(title = "Percentage"))
# 
# # Add recession bars
# for (i in 1:length(recession_starts)) {
#   plot_fred <- plot_fred %>%
#     layout(shapes = list(list(type = "rect",
#                               fillcolor = "gray",
#                               line = list(width = 0),
#                               x0 = recession_starts[i],
#                               x1 = recession_ends[i],
#                               y0 = -Inf,
#                               y1 = Inf,
#                               opacity = 0.5)))
# }
# 
# # Display the plot
# plot_fred






library(dplyr)
library(plotly)

# Convert xts objects to data frames
df_deficit <- data.frame(date = index(FYFSGDA188S), deficit = coredata(FYFSGDA188S))
df_recession <- data.frame(date = index(USREC), recession = coredata(USREC))

# Merge datasets
merged_data <- left_join(df_deficit, df_recession, by = "date")

# Create the plot
plot_deficit <- plot_ly(data = merged_data, x = ~date) %>%
  
  # Add recession bands
  add_ribbons(ymin = -20, ymax = 20, 
              xmin = ~date[USREC == 1], xmax = ~date[lead(USREC) == 0 & USREC == 1],
              fillcolor = "gray", alpha = 0.5, name = "Recession", inherit = FALSE) %>%
  
  # Add deficit line
  add_lines(y = ~deficit, name = "Deficit", line = list(color = "blue")) %>%
  
  # Layout details
  layout(title = "US Deficit with Recession Shading",
         yaxis = list(title = "Deficit (%)"),
         xaxis = list(title = "Date"))

# Display the plot
plot_deficit

