# libraries needed

library(dplyr)
library(ggplot2)
library(viridis)
library(gganimate)
library(wbstats)

# rosling chart in one command
rosling <-
# pull the country data down from the World Bank - three indicators
wbstats::wb_data(indicator = c("SP.DYN.LE00.IN", "NY.GDP.PCAP.CD", "SP.POP.TOTL"),
                       country = "countries_only", start_date = 1960, end_date = 2020)  |>
  # pull down mapping of countries to regions and join
  dplyr::left_join(wbstats::wb_countries()  |>
                     dplyr::select(iso3c, region)) |>
  # plot the data
  ggplot2::ggplot(aes(x = log(NY.GDP.PCAP.CD), y = SP.DYN.LE00.IN,
                      size = SP.POP.TOTL)) +
  ggplot2::geom_point(alpha = 0.5, aes(color = region)) +
  ggplot2::scale_size(range = c(.1, 16), guide = "none") +
  ggplot2::scale_x_continuous(limits = c(2.5, 12.5)) +
  ggplot2::scale_y_continuous(limits = c(30, 90)) +
  viridis::scale_color_viridis(discrete = TRUE, name = "Region", option = "viridis") +
  ggplot2::labs(x = "Log GDP per capita",
                y = "Life expectancy at birth") +
  ggplot2::theme_classic() +
  ggplot2::geom_text(aes(x = 7.5, y = 60, label = date), size = 14, color = 'lightgrey', family = 'Oswald') +
  # animate it over years
  gganimate::transition_states(date, transition_length = 1, state_length = 1) +
  gganimate::ease_aes('cubic-in-out')

# save animation as a gif
anim_save("rosling.gif", rosling, nframes = 125, height = 600, width = 1000)

