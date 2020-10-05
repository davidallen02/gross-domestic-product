gdp_growth <- pamngr::get_data("gdp cqoq") %>%
  dplyr::filter(dates >= as.POSIXct("1960-01-01")) %>%
  reshape2::melt(id.vars = "dates") %>%
  pamngr::barplot() %>%
  pamngr::pam_plot(
    plot_title = "US Economic Growth",
    plot_subtitle = "Real GDP QoQ SAAR",
    show_legend = FALSE,
    caption = FALSE
  ) %>%
  pamngr::all_output("gdp-growth")

