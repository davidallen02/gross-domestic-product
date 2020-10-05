dat <- pamngr::join_sheets(c("gdp%pce", 
                             "gdp%fixi",
                             "gdp%picg", 
                             "gdp%netx", 
                             "gdp%govc")) %>%
  dplyr::slice_max(dates, n = 6) %>%
  magrittr::set_colnames(c("Date",
                           "Personal\nConsumption",
                           "Fixed\nInvestment",
                           "Private\nInventories",
                           "International\nTrade",
                           "Government\nSpending")) %>%
  dplyr::mutate(Year = Date %>% lubridate::year(),
                Quarter = Date %>% lubridate::quarter(),
                fDate = paste0(Year, " Q", Quarter)) %>%
  dplyr::select(-Year, -Quarter) %>%
  reshape2::melt(id.vars = c("Date", "fDate"))

dat_pos <- dat %>% dplyr::filter(value >= 0)
dat_neg <- dat %>% dplyr::filter(value < 0)

totGrowth <- dat %>% 
  dplyr::ungroup() %>%
  dplyr::group_by(fDate) %>% 
  dplyr::select(fDate, value) %>% 
  dplyr::summarise(total = sum(value))

posCont <- plyr::ddply(dat_pos, "Date", dplyr::summarise, total = sum(value))
negCont <- plyr::ddply(dat_neg, "Date", dplyr::summarise, total = sum(value))
limits <- c(min(negCont$total)-1, max(posCont$total)+2)

b <- ggplot2::ggplot() + 
  ggplot2::geom_bar(data = dat_pos, 
                    ggplot2::aes(x = fDate, y = value, fill = variable), 
                    stat = 'identity') + 
  ggplot2::geom_bar(data = dat_neg, 
                    ggplot2::aes(x = fDate, y = value, fill = variable), 
                    stat = 'identity') +
  ggplot2::scale_fill_manual(values = c(
    'Personal\nConsumption' = '#850237',
    'Fixed\nInvestment'     = '#CBC3B7',
    'Private\nInventories'  = 'gray50',
    'International\nTrade'  = 'gray80',
    'Government\nSpending'  = 'black')) +
  # ggplot2::scale_fill_manual(values = pamngr::pam.pal()) +
  ggplot2::geom_hline(yintercept = 0, size = 1) +
  ggplot2::geom_point(data = totGrowth, 
                      ggplot2::aes(x = fDate, y = total), 
                      size = 23, 
                      color = "black") +
  ggplot2::geom_point(data = totGrowth, 
                      ggplot2::aes(x = fDate, y = total), 
                      size = 22, 
                      color = "white") +
  ggplot2::geom_point(data = totGrowth, 
                      ggplot2::aes(x = fDate, y = total),
                      color = 'black',
                      size = 20) +
  ggplot2::geom_point(data = totGrowth, # for the legend, not visible
                      ggplot2::aes(x = fDate, y = total, color = 'dot'), 
                      size = 5) +
  ggplot2::scale_color_manual(values = c('dot' = 'black'),
                              labels = 'Quarterly GDP\nGrowth, SAAR') +
  ggplot2::geom_text(data = totGrowth, 
                     ggplot2::aes(x = fDate, y = total, label = total), 
                     color = "white")

b <- b %>% pamngr::pam_plot(
  plot_title = "Contributions to GDP Growth",
  axis_titles = TRUE,
  x_lab = "Quarter Ended",
  y_lab = "Contribution in Percentage Points",
  caption = FALSE)

b <- b +
  ggplot2::ylim(limits) +
  ggplot2::theme(
        legend.key.height = ggplot2::unit(.25, 'in'),
        legend.key.width = ggplot2::unit(.25, 'in')
  )

b %>% pamngr::all_output("gdp-contributions")