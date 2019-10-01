#' Age distribution plot
#'
#' @param dat counts as provided as output from the CWD model
#'
#' @return a plot of the percent of the population in each age class
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export

plot_stoch_age_dist <- function(dat, ...){

  # summarize disease status on the last year, calculate the prevalence
  dat.sum <- dat %>%
    filter(month %% 12 == 10, round(year, 0) == max(round(year, 0))) %>%
    group_by(age, sex, sim) %>%
    summarize(n = sum(population)) %>%
    select(age, sex, n, sim) %>%
    group_by(age, sex) %>%
    summarize(avg = mean(n, na.rm = T)) %>%
    arrange(sex, age)

  #create the plot
  p <-   ggplot(data = dat.sum, aes(x = age, y = avg, color = sex)) +
    geom_line(size = 1.5) +
    xlab("Age") + ylab("Population") + theme_light(base_size = 18) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

  p
}
