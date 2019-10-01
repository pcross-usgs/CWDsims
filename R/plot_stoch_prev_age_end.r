#' Prevalence versus age plot
#'
#' @param dat counts as provided as output from the CWD model
#' @param error.bars vector with 2 values for the low and high percentiles. If
#' missing, then no error bars will be shown.
#'
#' @return a plot of prevalence versus age at the last timepoint of the
#' simulation
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr spread
#' @importFrom stats quantile
#'
#' @export

plot_stoch_prev_age_end <- function(dat, error.bars, ...){

  # summarize disease status on the last year, calculate the prevalence
  dat.sum <- dat %>%
    filter(month %% 12 == 10, round(year, 0) == max(round(year, 0))) %>%
    group_by(age, sex, sim, disease)%>%
    summarize(n = sum(population)) %>%
    spread(key = disease, value = n) %>%
    mutate(prev = yes / (no + yes)) %>%
    select(age, sex, prev, sim)

  dat.mean <- dat.sum %>%
    group_by(age, sex) %>%
    summarize(avg = mean(prev, na.rm = T)) %>%
    arrange(sex, age)

  p <-   ggplot(data = dat.mean, aes(x = age, y = avg, color = sex)) +
    geom_line(size = 1.5) + ylim(0,1) +
    xlab("Age") + ylab("Prevalence")

  if(missing(error.bars) == FALSE){
    # calculate the mean
    dat.mean <- dat.sum %>%
    group_by(age, sex) %>%
    summarize(lo = quantile(prev, error.bars[1], na.rm = T),
              hi = quantile(prev, error.bars[2], na.rm = T),
              avg = mean(prev, na.rm = T)) %>%
    arrange(sex, age)

    p <- p + geom_line(data = dat.mean, aes(x = age, y = lo, color = sex),
                     linetype = "dashed") +
    geom_line(data = dat.mean, aes(x = age, y = hi, color = sex),
              linetype = "dashed")

  }

  p <- p + theme_light(base_size = 18) + theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank(),
          legend.position = c(.15,.85))

  p
}
