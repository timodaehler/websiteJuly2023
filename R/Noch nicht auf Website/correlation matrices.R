library(quantmod)
library(tibble)
library(dplyr)

getSymbols("SPY")
getSymbols("BND")

returns_SPY <- dailyReturn(SPY)
returns_BND <- dailyReturn(BND)

# Merging the returns based on their common dates
data <- merge(returns_SPY, returns_BND)

# Rename columns for clarity
colnames(data) <- c("SPY_Returns", "BND_Returns")

# Compute the correlation matrix
correlation_matrix <- cor(data, use = "complete.obs")

# Display the correlation matrix
print(correlation_matrix)
