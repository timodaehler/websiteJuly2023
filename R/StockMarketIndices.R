# Required Libraries ---------------------------------------------------------
library(quantmod)
library(tidyverse)
library(zoo)
library(plotly)
library(htmlwidgets)

# Fetching Data --------------------------------------------------------------
symbols <- c("^GSPC", "^SSMI", "^GDAXI", "^FCHI", "^N225", "^FTSE") # Adding "^FTSE"
names(symbols) <- c("S&P 500 (USA)", "SMI (Switzerland)", "DAX (Germany)", "CAC40 (France)", "Nikkei225 (Japan)", "FTSE (UK)")

data_list <- lapply(symbols, function(sym) {
  getSymbols(sym, auto.assign = FALSE)
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
    xaxis = list(title = "Date"),
    yaxis = list(title = "Normalized Value"),
    showlegend = TRUE,
    legend = list(
      title = list(text = "Index"),
      orientation = "h",
      xanchor = "center",
      yanchor = "bottom",
      x = 0.5,
      y = -0.2
    ),
    annotations = list(
      list(
        text = "Source: Yahoo Finance",
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


# Export to StockMarketIndices
saveWidget(p_stock_indices, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/StockMarketIndices/myplot.html", selfcontained = FALSE)









# Required Libraries ---------------------------------------------------------
library(quantmod)
library(tidyverse)
library(plotly)
library(htmlwidgets)
library(zoo)  # Load the zoo package for the na.approx() function

# Fetching Data --------------------------------------------------------------
symbols <- c("^GSPC", "^SSMI", "^GDAXI", "^FCHI", "^N225", "^FTSE")

data_list <- lapply(symbols, function(sym) {
  getSymbols(sym, auto.assign = FALSE)
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
                          y = -0.1,
                          title = list(text = "Index")
                        )
)

combined_plot


# Export to StockMarketIndices
saveWidget(p_stock_indices_raw, "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/StockMarketIndices/myplot2.html", selfcontained = FALSE)































