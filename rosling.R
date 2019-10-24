# install.packages("xfun")
xfun::pkg_attach(c("tidyverse", "viridis", "gganimate", "wbstats"))

# rosling chart in one command

# pull the country data down from the World Bank - three indicators
wb(indicator = c("SP.DYN.LE00.IN", "NY.GDP.PCAP.CD", "SP.POP.TOTL"), 
            country = "countries_only", startdate = 1960, enddate = 2018)  %>% 
  # pull down mapping of countries to regions and join
  left_join(wbcountries() %>% 
              select(iso3c, region)) %>% 
  # spread the three indicators
  pivot_wider(id_cols = c("date", "country", "region"), names_from = indicator, 
              values_from = value) %>% 
  # plot the data
  ggplot(aes(x = log(`GDP per capita (current US$)`), 
             y = `Life expectancy at birth, total (years)`,
             size = `Population, total`)) +
  geom_point(alpha = 0.5, aes(color = region)) +
  scale_size(range = c(.1, 16), guide = FALSE) +
  scale_x_continuous(limits = c(2.5, 12.5)) +
  scale_y_continuous(limits = c(30, 90)) +
  scale_color_viridis(discrete = TRUE, name = "Region", option = "viridis") +
  labs(x = "Log GDP per capita", y = "Life expectancy at birth") +
  theme_classic() +
  geom_text(aes(x = 7.5, y = 60, label = date), size = 14, color = 'lightgrey', 
            family = 'Oswald') +
  # animate it over years
  transition_states(date, transition_length = 1, state_length = 1) +
  ease_aes('cubic-in-out')

