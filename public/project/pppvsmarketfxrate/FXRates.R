# Create a data frame for exchange rates against the Swiss franc
exchange_rates <- data.frame(
  dollar = 0.92,    # Just an example rate, replace with the actual rate
  pound = 1.28,     # Just an example rate, replace with the actual rate
  yen = 0.0085,     # Just an example rate, replace with the actual rate
  euro = 1.10,      # Just an example rate, replace with the actual rate
  renminbi = 0.14   # Just an example rate, replace with the actual rate
)

# Print the data frame
print(exchange_rates)



exchange_rates$dollar  # This will give you the dollar exchange rate


library(ggplot2)
library(ggimage)
library(dplyr)

exchange_rates_long <- exchange_rates %>% 
  gather(currency, rate) 

# It should look like:
#   currency   rate
#1    dollar   0.92
#2    pound    1.28
#... and so on


flags <- c(
  dollar = "https://flagcdn.com/128x96/us.png",
  pound = "https://flagcdn.com/128x96/gb.png",
  yen = "https://flagcdn.com/128x96/jp.png",
  euro = "https://flagcdn.com/128x96/eu.png",
  renminbi = "https://flagcdn.com/128x96/cn.png"
)

exchange_rates_long$flag <- flags[exchange_rates_long$currency]


ggplot(exchange_rates_long, aes(x=currency, y=rate)) + 
  geom_bar(stat="identity", fill="skyblue") +
  geom_image(aes(image=flag), y=1, size=0.1) +  # Adjust y and size as needed
  labs(title="Exchange Rates Against S
       wiss Franc", 
       y="Rate") +
  theme_minimal()


install.packages("gt")
library(gt)

exchange_rates_long %>%
  gt() %>%
  tab_header(
    title = "Exchange Rates Against Swiss Franc"
  ) %>%
  cols_label(
    currency = "Currency",
    rate = "Rate",
    flag = "Flag"
  ) %>%
  fmt_number(
    columns = vars(rate),
    decimals = 2
  ) %>%
  text_transform(
    locations = cells_body(vars(flag)),
    fn = function(value) {
      paste0('<img src="', value, '" width="60" height="40"/>')
    }
  )


library(gt)

table_output <- 
  exchange_rates_long %>%
  gt() %>%
  tab_header(
    title = "Exchange Rates Against Swiss Franc"
  ) %>%
  cols_label(
    currency = "Currency",
    rate = "Rate",
    flag = "Flag"
  ) %>%
  fmt_number(
    columns = vars(rate),
    decimals = 2
  ) %>%
  text_transform(
    locations = cells_body(vars(flag)),
    fn = function(value) {
      paste0('<img src="', value, '" width="60" height="40"/>')
    }
  )


gtsave(table_output, filename = "/Users/timodaehler_1/Desktop/websiteJuly2023/content/project/FXRates/myplot3.html")


