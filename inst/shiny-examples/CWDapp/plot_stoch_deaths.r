#' Death types stochastic plot
#'
#' @param dat counts as provided as output from the CWD model
#' @param error.bars error bars = vector of high and low percentiles
#' (2 values only). If missing, no error bars are shown.
#'
#' @return a plot of death types over time.
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom forcats fct_recode fct_reorder
#' @importFrom stringr str_sub
#' @importFrom stats quantile
#'
#'
#' @export

plot_stoch_deaths <- function(dat, error.bars){

  dat.sum <- dat %>%
    filter(age >= 2) %>%
    mutate(category = as.factor(str_sub(category, 1, 1))) %>%
    mutate(category = fct_recode(category,
                                 "CWD" = "C",
                                 "Natural" = "D",
                                 "Hunted" = "H"),
           year = floor(year)) %>%
    group_by(year, sex, category, sim) %>%
    summarize(n = sum(population))


  # calculate the mean
  dat.mean <- dat.sum %>%
    group_by(year, sex, category) %>%
    summarize(avg = mean(n, na.rm = T)) %>%
    mutate(category = fct_reorder(category, avg))

  p <-   ggplot(data = dat.mean, aes(x = year, y = avg, color = category)) +
    geom_line(size = 1.5) +
    xlab("Year") + ylab("# of Adult Deaths")

  if(missing(error.bars) == FALSE){
    # calculate the error bars
    dat.mean <- dat.sum %>%
      group_by(year, sex, category) %>%
      summarize(lo = quantile(n, error.bars[1]),
                hi = quantile(n, error.bars[2]),
                avg = mean(n)) %>%
      mutate(category = fct_reorder(category, avg))

    p <- p + geom_line(data = dat.mean, aes(x = year, y = lo, color = category),
                       linetype = "dashed") +
      geom_line(data = dat.mean, aes(x = year, y = hi, color = category),
                linetype = "dashed")

    }

  p <- p + theme_light(base_size = 18) + facet_wrap(~sex) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

  p
}
