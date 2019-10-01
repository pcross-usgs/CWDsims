#' Stochastic Comparison plot of prevalence over time
#'
#' @param outa counts as provided as output from the CWD model functions for the
#'  first simulation
#' @param outb counts as provided as output from the CWD model functions for the
#'  second simulation
#'
#' @return a comparison plot of prevalence
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom reshape2 melt
#' @importFrom tidyr spread
#' @importFrom forcats fct_recode
#'
#' @export

plot_compare_prev <- function(outa, outb, ...){
  dat <- list(outa, outb)

  dat <- melt(dat, id = c("age", "month", "population", "category",
                          "year", "sex", "disease", "sim")) %>%
    filter(month %% 12 == 10, round(year, 0) == max(round(year, 0))) %>%
    rename(scenario = L1) %>%
    mutate(scenario = fct_recode(as.factor(scenario), A = "1", B = "2")) %>%
    group_by(disease, sim, scenario) %>%
    summarize(n = sum(population))%>%
    spread(key = disease, value = n) %>%
    mutate(prev = yes / (no + yes))

  theme_set(theme_bw(base_size = 18))

  # define some color options
  cols <- c('#ffff00','#0000ff')

  # plot
  ggplot(dat, aes(x = prev, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6) + theme_ridges() +
    xlab("Disease prevalence") + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols)
}


