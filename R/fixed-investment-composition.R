p <- pamngr::join_sheets(c("gpdinrsc", "gpdiresc")) %>%
  magrittr::set_colnames(c("dates", "Nonresidential", "Residential")) %>%
  reshape2::melt(id.vars = "dates") %>%
  ggplot2::ggplot(ggplot2::aes(dates, value, fill = variable)) + 
  ggplot2::geom_area() +
  ggplot2::scale_fill_manual(values = c("#788502", "#A5B703")) 

p %>%
  pamngr::pam_plot(
    plot_title = "Composition of Fixed Investment",
    plot_subtitle = "Billions of USD, Chain Linked 2012 Prices",
    caption = FALSE) %>%
  pamngr::all_output("fixed-investment-composition")