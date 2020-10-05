p <- pamngr::join_sheets(c("gdpctot","gpditotc","gpgstotc","gdptnet")) %>%
  magrittr::set_colnames(c("dates",
                           "Personal Consumption", 
                           "Private Investment", 
                           "Government Spending",
                           "International Trade")) %>%
  reshape2::melt(id.vars = "dates") %>%
  ggplot2::ggplot(ggplot2::aes(dates, value, fill = variable)) + 
  ggplot2::geom_area() +
  ggplot2::scale_fill_manual(values = pamngr::pam.pal()) 

p %>%
  pamngr::pam_plot(
    plot_title = "Composition of US Economy",
    plot_subtitle = "Billions of USD, Chain Linked 2012 Prices",
    caption = FALSE) %>%
  pamngr::all_output("gdp-composition")