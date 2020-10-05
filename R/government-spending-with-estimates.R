qtr_to_date <- function(x){
  
  if(x == "q1") { return("03-31")} else {
    if (x == "q2") {return("06-30")} else {
      if(x == "q3") {return("09-30")} else{
        if(x == "q4") {return("12-31")}
      }
    }
  }
}

reported <- pamngr::get_data("gpgstoc%") %>%
  magrittr::set_colnames(c("dates", "value")) %>%
  dplyr::mutate(variable = "Reported")

estimates <- pamngr::join_sheets(c("ecgvus q320", 
                                   "ecgvus q420", 
                                   "ecgvus q121",
                                   "ecgvus q221")) %>%
  dplyr::slice_max(dates, n = 1) %>%
  reshape2::melt(id.vars = "dates") %>%
  dplyr::select(variable, value) %>%
  dplyr::mutate(
    qtr = variable %>% stringr::str_sub(start = 8, end = 9) %>%  purrr::map_chr(qtr_to_date),
    yr = variable %>% stringr::str_sub(start = 10, end = 11) %>% paste0("20", .),
    dates = paste(yr, qtr, sep = "-") %>% lubridate::as_datetime(),
    variable = "Estimate"
  ) %>%
  dplyr::select(dates, value, variable) %>%
  tibble::as_tibble() 

government_spending_growth_with_estimates <- reported %>%
  dplyr::bind_rows(estimates) %>%
  dplyr::arrange(dates) %>%
  dplyr::slice_max(dates, n = 16) %>%
  dplyr::mutate(variable = variable %>% factor(levels = c("Reported","Estimate"))) %>%
  pamngr::barplot() %>%
  pamngr::pam_plot(
    plot_title = "US Government Spending",
    plot_subtitle = "QoQ SAAR",
    caption = FALSE
  ) %>%
  pamngr::all_output("government-spending-growth-with-estimates")

