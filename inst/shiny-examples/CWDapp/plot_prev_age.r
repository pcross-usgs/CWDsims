#' Plot the prevalence over time by age
#'
#' Allows for subsetting by sex
#'
#' @param dat counts provided as output from the CWD model functions
#' @param by.sex TRUE or FALSE on whether to facet by sex
#'
#' @return a plot of the prevalence over time
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export

# plot the prevalence
plot_prev_age <- function(dat, by.sex, ...){
  if(missing(by.sex)){by.sex <- F}

  # summarize by year and disease status, calculate the prevalence
  if(by.sex == F){
    dat.sum <- dat %>%
      filter(month %% 12 == 10) %>%
      group_by(year, age, disease) %>%
      summarize(n = sum(population)) %>%
      spread(key = disease, value = n) %>%
      mutate(prev = yes/ (no + yes))
  }

  if(by.sex == T){
    dat.sum <- dat %>%
      filter(month %% 12 == 10) %>%
      group_by(year, age, sex, disease)%>%
      summarize(n = sum(population)) %>%
      spread(key = disease, value = n) %>%
      mutate(prev = yes/ (no + yes))
  }

  #create the plot
  if(by.sex == T){
    p <- ggplot(dat.sum, aes(year, prev, group = age, color = age)) +
      geom_line() + facet_wrap(~sex)
  }

  if(by.sex == F){
    p <- ggplot(dat.sum, aes(year, prev, group = age, color = age)) +
      geom_line()
  }

  p <- p + theme_light() +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

  p
}
