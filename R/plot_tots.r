#' Plot the total of S and I over time
#'
#' @param dat counts provided as output from the CWD model functions
#' @return a plot of the population totals split by age.
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom forcats fct_reorder fct_recode
#'
#' @export

plot_tots <- function(dat, ...){

  # summarize by year and sex
  dat.sum <- dat %>%
    filter(month %% 12 == 10) %>%
    group_by(year, disease) %>%
    summarize(n = sum(population)) %>%
    spread(key = disease, value = n) %>%
    mutate(total = no + yes) %>%
    gather ("no", "yes", "total", key = "disease", value = "n" ) %>%
    mutate(disease = fct_recode(disease,
                                "negative" = "no",
                                "positive" = "yes",
                                "total" = "total")) %>%
    mutate(disease = fct_reorder(disease, n))

  #plot
  p <- ggplot(dat.sum, aes(year, n, color = disease)) +
    geom_line(size = 1.5) +
    xlab("Year") + ylab("Population") + theme_light(base_size = 18) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())
  p
}
