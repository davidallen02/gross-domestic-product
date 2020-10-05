p <- pamngr::join_sheets(c("gdpcgood", "gdpcsrv")) %>%
  magrittr::set_colnames(c("dates", "Goods", "Services")) %>%
  reshape2::melt(id.vars = "dates") %>%
  ggplot2::ggplot(ggplot2::aes(dates, value, fill = variable)) + 
  ggplot2::geom_area() +
  ggplot2::scale_fill_manual(values = c("#850237", "#B7034C")) 

p %>%
  pamngr::pam_plot(
    plot_title = "Composition of Personal Consumption",
    plot_subtitle = "Billions of USD, Chain Linked 2012 Prices",
    caption = FALSE) %>%
  pamngr::all_output("personal-consumption-composition")