# libraries needed

library(tidyverse)
library(ggplot2)
library(viridis)
library(gganimate)
library(wbstats)

# rosling chart in one command

wbstats::wb(indicator = c("SP.DYN.LE00.IN", "NY.GDP.PCAP.CD", "SP.POP.TOTL"), 
                       country = "countries_only", startdate = 1960, enddate = 2018)  %>% 
  dplyr::left_join(wbstats::wbcountries() %>% 
                     dplyr::select(iso3c, region)) %>% 
  tidyr::pivot_wider(id_cols = c("date", "country", "region"), names_from = indicator, values_from = value) %>% 
  ggplot2::ggplot(aes(x = log(`GDP per capita (current US$)`), y = `Life expectancy at birth, total (years)`,
                      size = `Population, total`)) +
  ggplot2::geom_point(alpha = 0.5, aes(color = region)) +
  ggplot2::scale_size(range = c(.1, 16), guide = FALSE) +
  ggplot2::scale_x_continuous(limits = c(2.5, 12.5)) +
  ggplot2::scale_y_continuous(limits = c(30, 90)) +
  viridis::scale_color_viridis(discrete = TRUE, name = "Region", option = "viridis") +
  ggplot2::labs(x = "Log GDP per capita",
       y = "Life expectancy at birth") +
  ggplot2::theme_classic() +
  ggplot2::geom_text(aes(x = 7.5, y = 60, label = date), size = 14, color = 'lightgrey', family = 'Oswald') +
  gganimate::transition_states(date, 
                    transition_length = 1, state_length = 1) +
  gganimate::ease_aes('cubic-in-out')
  

