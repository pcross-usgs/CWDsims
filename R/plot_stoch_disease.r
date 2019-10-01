#' Plot stochastic totals of positives and negatives over time
#'
#' @param dat counts as provided as output from the CWD model
#' @param error.bars error bars = vector of high and low percentiles
#' (2 values only). If missing, no error bars are shown.
#'
#' @return a multiple line plot of the simulation over time
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr spread
#' @importFrom forcats fct_recode fct_reorder
#' @importFrom stringr str_sub
#' @importFrom stats quantile
#'
#' @export

plot_stoch_disease <- function(dat, error.bars){

  dat.sum <- dat %>%
    filter(month %% 12 == 10) %>%
    group_by(year, sim, disease) %>%
    summarize(n = sum(population)) %>%
    spread(key = disease, value = n) %>%
    mutate(total = no + yes) %>%
    gather ("no", "yes", "total", key = "disease", value = "n" ) %>%
    mutate(disease = fct_recode(disease,
                                "negative" = "no",
                                "positive" = "yes",
                                "total" = "total")) %>%
    mutate(disease = fct_reorder(disease,n)) %>%
    arrange(sim, year)

  # calculate the mean
  dat.mean <- dat.sum %>%
    group_by(year, disease) %>%
    summarize(avg = mean(n)) %>%
    mutate(disease = fct_reorder(disease, avg))

  p <-   ggplot(data = dat.mean, aes(x = year, y = avg, color = disease)) +
    geom_line(size = 1.5) +
    xlab("Year") + ylab("Population")

  if(missing(error.bars) == FALSE){
    # calculate the mean
    dat.mean <- dat.sum %>%
      group_by(year, disease) %>%
      summarize(lo = quantile(n, error.bars[1]),
                hi = quantile(n, error.bars[2]),
                avg = mean(n)) %>%
      mutate(disease = fct_reorder(disease, avg))

    p <- p + geom_line(data = dat.mean, aes(x = year, y = lo, color = disease),
                       linetype = "dashed") +
      geom_line(data = dat.mean, aes(x = year, y = hi, color = disease),
                linetype = "dashed")
  }

  p <- p + theme_light(base_size = 18) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

  p

}
