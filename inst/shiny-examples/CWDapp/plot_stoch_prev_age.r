#' Plot stochastic prevalence by age over time
#'
#' @param dat counts as provided as output from the CWD model
#' @param by.sex TRUE/FALSE on whether to facet by sex. Default = FALSE
#'
#' @return a multiple line plot of the simulation over time
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr spread
#'
#' @export

plot_stoch_prev_age <- function(dat, by.sex, ...){

  if(missing(by.sex)){by.sex = F}

  if(by.sex == F){
    # summarize by year and sex
    dat.sum <- dat %>%
      filter(month %% 12 == 7) %>%
      group_by(year, age, disease, sim) %>%
      summarize(n = sum(population)) %>%
      arrange(sim, year) %>%
      spread(key = disease, value = n) %>%
      mutate(prev = yes/ (no + yes))

    # calculate the mean
    dat.mean <- dat.sum %>%
      group_by(age, year) %>%
      summarize(avg = mean(prev))

    p <- ggplot(dat.mean, aes(year, avg, group = age, color = age)) +
      geom_line()
  }

  if(by.sex == T){
    # summarize by year and sex
    dat.sum <- dat %>%
      filter(month %% 12 == 7) %>%
      group_by(year, age, sex, disease, sim) %>%
      summarize(n = sum(population)) %>%
      spread(key = disease, value = n) %>%
      mutate(prev = yes/ (no + yes))

    # calculate the mean
    dat.mean <- dat.sum %>%
      group_by(age, sex, year) %>%
      summarize(avg = mean(prev))

    p <- ggplot(dat.mean, aes(year, avg, group = age, color = age)) +
      geom_line() + facet_wrap(~sex)

  }

  p <- p + xlab("Year") + ylab("Prevalence") +
    theme_light(base_size = 18) + theme(panel.grid.minor = element_blank(),
                                        panel.grid.major.x = element_blank())

  p
}
