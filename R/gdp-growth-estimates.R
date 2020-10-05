gdp_growth_estimates <- pamngr::join_sheets(
  c("ecgdus q320", "ecgdus q420", "ecgdus q121", "ecgdus q221")) %>%
  dplyr::filter(dates >= as.POSIXct("2020-03-01")) %>%
  reshape2::melt(id.vars = "dates") %>%
  dplyr::mutate(
    qtr = variable %>% stringr::str_sub(start = 7, end = 9),
    yr  = variable %>% stringr::str_sub(start = 10) %>% paste0("20", .),
    variable = paste0(yr, qtr) %>% stringr::str_to_upper()
  ) %>%
  pamngr::lineplot() %>%
  pamngr::pam_plot(
    plot_title    = "Consensus GDP Growth Estimates",
    plot_subtitle = "Bloomberg Survey of Economists Median"
  ) %>%
  pamngr::all_output("gdp-growth-estimates")

