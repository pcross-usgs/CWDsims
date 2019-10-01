#' Plot the fawn to doe ratio over time
#'
#'
#' @param dat counts provided as output from the CWD model functions
#'
#' @return a plot the fawn:doe ratio
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr unite
#'
#' @export

plot_fawn_doe <- function(dat, ...){

  dat$age.cat <- "adult"
  dat$age.cat[dat$age == 1] <- "fawn"

  # summarize by year and disease status, calculate the prevalence
  dat.sum <- dat %>%
    filter(month %% 12 == 11) %>%
    group_by(year, sex, age.cat) %>%
    summarize(n = sum(population)) %>%
    unite(sex.age, sex, age.cat) %>%
    spread(key = sex.age, value = n) %>%
    mutate(fawn.doe = (m_fawn + f_fawn) / f_adult)

  ggplot(dat.sum, aes(x = year, y = fawn.doe)) +
    geom_line(size = 1.5) + ylim(0, 1.2) +
    ylab("Fawn:Doe ratio") + xlab("Year") +
    theme_light()  + theme(text = element_text(size = 18),
                           panel.grid.minor = element_blank(),
                           panel.grid.major = element_blank())

}

