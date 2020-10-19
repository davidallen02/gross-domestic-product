library(magrittr)

dat <- pamngr::get_data("cbopgapp") %>%
  dplyr::filter(dates >= as.Date("2019-01-01")) %>%
  tidyr::pivot_longer(cols = -dates, names_to = "variable")

p <- dat %>%
  pamngr::barplot() %>%
  pamngr::pam_plot(
    plot_title = "US Economic Output Gap",
    plot_subtitle = "CBO Estimate, Percent of GDP",
    show_legend = FALSE
  )

p %>% pamngr::all_output("cbo-output-gap")

