p <- pamngr::join_sheets(c("gpgsfedc", "gpgsslc")) %>%
  magrittr::set_colnames(c("dates", "Federal", "State & Local")) %>%
  reshape2::melt(id.vars = "dates") %>%
  ggplot2::ggplot(ggplot2::aes(dates, value, fill = variable)) + 
  ggplot2::geom_area() +
  ggplot2::scale_fill_manual(values = c("#028550", "#03B76E")) 

p %>%
  pamngr::pam_plot(
    plot_title = "Composition of Government Spending",
    plot_subtitle = "Billions of USD, Chain Linked 2012 Prices",
    caption = FALSE) %>%
  pamngr::all_output("government-spending-composition")