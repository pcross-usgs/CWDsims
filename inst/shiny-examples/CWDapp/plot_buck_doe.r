#' Plot the buck:doe ratio
#'
#'
#' @param dat counts provided as output from the CWD model functions
#'
#' @return a plot the buck:doe ratio
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr unite
#'
#' @export

plot_buck_doe <- function(dat, ...){

  dat$age.cat <- "adult"
  dat$age.cat[dat$age == 1] <- "fawn"

  # summarize by year and disease status, calculate the prevalence
  dat.sum <- dat %>%
    filter(month %% 12 == 8) %>% # december of every year
    group_by(year, sex, age.cat) %>%
    summarize(n = sum(population)) %>%
    unite(sex.age, sex, age.cat) %>%
    spread(key = sex.age, value = n) %>%
    mutate(buck.doe = m_adult / f_adult)

  ggplot(dat.sum, aes(x = year, y = buck.doe)) +
    geom_line(size = 1.5) + ylim(0, 1.2) +
    ylab("Buck:Doe ratio") + xlab("Year") +
    theme_light()  + theme(text = element_text(size = 18),
                           panel.grid.minor = element_blank(),
                           panel.grid.major = element_blank())

}
