#' Plot the prevalence over time
#'
#' @param dat counts provided as output from the CWD model functions
#' @return a plot of the prevalence over time
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr spread
#'
#' @export

plot_prev_time <- function(dat, ...){

  # summarize by year and disease status, calculate the prevalence
  dat.sum <- dat %>%
    filter(month %% 12 == 10) %>%
    group_by(year, disease) %>%
    summarize(n = sum(population)) %>%
    spread(key = disease, value = n) %>%
    mutate(prev = yes/ (no + yes))

  ggplot(dat.sum, aes(x = year, y = prev)) +
    geom_line(size = 1.5) + ylim(0,1) +
    ylab("Prevalence") + xlab("Year") +
    theme_light()  + theme(text = element_text(size = 18),
                           panel.grid.minor = element_blank(),
                           panel.grid.major = element_blank())

}
