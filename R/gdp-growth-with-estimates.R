qtr_to_date <- function(x){
  if(x == "q1") { return("03-31")} else {
    if (x == "q2") {return("06-30")} else {
      if(x == "q3") {return("09-30")} else{
        if(x == "q4") {return("12-31")}
      }
    }
  }
}

reported <- pamngr::get_data("gdp cqoq") %>%
  magrittr::set_colnames(c("dates", "value")) %>%
  dplyr::mutate(variable = "Reported")

estimates <- pamngr::join_sheets(c("ecgdus q320", 
                                   "ecgdus q420", 
                                   "ecgdus q121",
                                   "ecgdus q221",
                                   "ecgdus q321",
                                   "ecgdus q421")) %>%
  dplyr::slice_max(dates, n = 1) %>%
  reshape2::melt(id.vars = "dates") %>%
  dplyr::select(variable, value) %>%
  dplyr::mutate(
    qtr = variable %>% stringr::str_sub(start = 8, end = 9) %>%  purrr::map_chr(qtr_to_date),
    yr = variable %>% stringr::str_sub(start = 10, end = 11) %>% paste0("20", .),
    dates = paste(yr, qtr, sep = "-") %>% lubridate::as_datetime(),
    variable = variable %>% 
      stringr::str_sub(start = 8, end = 9) %>% 
      stringr::str_to_upper() %>%
      paste(yr, .)
  ) %>%
  dplyr::select(dates, variable, value) %>%
  tibble::as_tibble() 

periods <- estimates %>% dplyr::select(variable) %>% dplyr::pull()

p <- reported %>%
  dplyr::bind_rows(estimates) %>%
  dplyr::arrange(dates) %>%
  dplyr::slice_max(dates, n = 16) %>%
  dplyr::mutate(variable = variable %>% factor(levels = c("Reported", periods))) %>%
  pamngr::barplot() %>%
  pamngr::pam_plot(
    plot_title = "US Gross Domestic Product",
    plot_subtitle = "QoQ SAAR",
    caption = FALSE
  )

p %>% pamngr::all_output("gdp-growth-with-estimates")