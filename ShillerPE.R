# Import necessary libraries
library(Quandl)
library(plotly)
library(htmlwidgets)

# Fetch the S&P 500 P/E ratio data
sp500_pe_data <- Quandl("MULTPL/SHILLER_PE_RATIO_MONTH", api_key="rsJKAethJVUA76dPfkgh")

# Calculate the median of the P/E ratios
median_pe <- median(sp500_pe_data$Value)

# Create a line chart using the 'plotly' library
# X-axis represents the 'Date' and Y-axis represents 'Value' (P/E Ratio)
# Add layout details like titles and axis labels
p_pe <- 
  plot_ly(data = sp500_pe_data, x = ~Date, y = ~Value, type = "scatter", mode = "lines", name = "S&P500: Case Shiller P/E10") %>%
  layout(
    # title = "S&P 500 P/E Ratio Over Time",
    xaxis = list(title = ""),
    yaxis = list(title = "P/E Ratio"),
    legend = list(
      x = 0.5, 
      y = -0.1, 
      xanchor = "center", 
      orientation = "h"
    )
  ) %>%
  # Add a dashed line at the median P/E ratio
  add_trace(x = ~Date, y = rep(median_pe, length(sp500_pe_data$Date)), 
            type = "scatter", mode = "lines",
            line = list(dash = "dash", color = "black"), name = "Median")

# Show the plot
p_pe

# Update date
saveRDS(Sys.time(), "content/project/ShillerPE/ShillerPE1_update_date.rds")

# Export 
saveWidget(p_pe, "content/project/ShillerPE/ShillerPE1.html")

# Clean-up
rm(list = ls())
gc()
