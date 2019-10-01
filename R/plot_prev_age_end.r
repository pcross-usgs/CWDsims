
#' Plot the prevalence by age at the end of the simulation
#'
#' @param dat counts provided as output from the CWD model functions
#'
#' @return a plot of the prevalence by age
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#'
#' @export

plot_prev_age_end <- function(dat, ...){

  # summarize disease status on the last year, calculate the prevalence
  dat.sum <- dat %>%
    filter(month %% 12 == 10, round(year, 0) == max(round(year, 0))) %>%
    group_by(age, sex, disease)%>%
    summarize(n = sum(population)) %>%
    spread(key = disease, value = n) %>%
    mutate(prev = yes/ (no + yes)) %>%
    select(age, sex, prev)

  #prevalence by age
  ggplot(dat.sum, aes(x = age, y = prev, color = sex)) +
    geom_line(size = 1.5) + ylim(0,1) +
    ylab("") + xlab("Age") +
    theme_light()  + theme(text = element_text(size = 18),
                           panel.grid.minor = element_blank(),
                           panel.grid.major = element_blank(),
                           legend.position = c(.25,.85))
}
