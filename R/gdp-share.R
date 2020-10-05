p <- pamngr::join_sheets(c("gdpctot", "gpditotc", "gpgstotc")) %>%
  dplyr::rowwise() %>%
  dplyr::mutate(
    total = sum(gdpctot, gpditotc, gpgstotc),
    gdpctot = gdpctot %>% magrittr::divide_by(total),
    gpditotc = gpditotc %>% magrittr::divide_by(total),
    gpgstotc = gpgstotc %>% magrittr::divide_by(total)
  ) %>%
  dplyr::select(-total) %>%
  magrittr::set_colnames(c("dates",
                           "Personal Consumption", 
                           "Private Investment", 
                           "Government Spending")) %>%
  reshape2::melt(id.vars = "dates") %>%
  ggplot2::ggplot(ggplot2::aes(dates, value, fill = variable)) + 
  ggplot2::geom_area() +
  ggplot2::scale_fill_manual(values = pamngr::pam.pal()) 

p %>%
  pamngr::pam_plot(
    plot_title = "Share of US Economy",
    plot_subtitle = "Percent of Real GDP Less International Trade",
    caption = FALSE) %>%
  pamngr::all_output("gdp-share")