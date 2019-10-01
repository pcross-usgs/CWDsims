#' Plot the age distribution at the end
#'
#'
#' @param dat counts provided as output from the CWD model functions
#'
#' @return a plot the age distribution at the end point
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export

plot_age_dist <- function(dat, ...){

  # summarize disease status on the last year, calculate the prevalence
  dat.sum <- dat %>%
    filter(month %% 12 == 10, round(year, 0) == max(round(year, 0))) %>%
    group_by(age, sex, age) %>%
    summarize(n = sum(population)) %>%
    select(age, sex, n)

  #create the plot
  p <- ggplot(dat.sum, aes(x = age, y = n, color = sex)) +
    geom_line(size = 1.5) +
    ylab("Population") + xlab("Age") +
    theme_light()  + theme(text = element_text(size = 18),
                           panel.grid.minor = element_blank(),
                           panel.grid.major = element_blank(), legend.position = c(.15,.8))

  p
}

