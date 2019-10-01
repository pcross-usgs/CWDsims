#' Plot the deaths by category.
#'
#'
#' @param dat deaths as provided as output from the CWD model functions
#' @param percents TRUE/FALSE on whether to plot the totals or the percentage
#' absolute totals are the default
#'
#' @return a plot deaths by category
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom forcats fct_recode fct_reorder
#'
#' @export

plot_deaths <- function(dat, percents){

  if(missing(percents)){percents <- F}

  if(percents == F){
    deaths <- dat %>%
      filter(age >= 2) %>%
      mutate(category = as.factor(str_sub(category, 1, 1))) %>%
      mutate(category = fct_recode(category,
                                   "CWD" = "C",
                                   "Natural" = "D",
                                   "Hunted" = "H"),
             year = floor(year)) %>%
      group_by(year, sex, category) %>%
      summarize(n = sum(population)) %>%
      mutate(category = fct_reorder(category, n))

    p <- ggplot(data = deaths, aes(x = year, y = n, color = category)) +
      geom_line(size = 1.5) + facet_wrap(~sex) +
      xlab("Year") + ylab("# of Adult Deaths")
  }

  if(percents == T){
    deaths <- dat %>%
      filter(age >= 2) %>%
      mutate(category = as.factor(str_sub(category, 1, 1))) %>%
      mutate(category = fct_recode(category,
                                   "CWD" = "C",
                                   "Natural" = "D",
                                   "Hunted" = "H"),
             year = floor(year)) %>%
      group_by(year, sex, category) %>%
      summarize(n = sum(population)) %>%
      spread(key = category, value = n) %>%
      mutate(total = CWD + Natural + Hunted) %>%
      mutate(cwd.p = CWD/total, nat.p = Natural/total, hunt.p = Hunted/total) %>%
      select(year, sex, cwd.p, nat.p, hunt.p) %>%
      gather("cwd.p", "hunt.p", "nat.p", key ="category", value = "percent" ) %>%
      mutate(category = fct_recode(category,
                                   "CWD" = "cwd.p",
                                   "Natural" = "nat.p",
                                   "Hunted" = "hunt.p")) %>%
      mutate(category = fct_reorder(category, percent))
    p <- ggplot(data = deaths, aes(x = year, y = percent, color = category)) +
      geom_line(size = 1.5) + facet_wrap(~sex)+
      xlab("Year") + ylab("% of Adult Deaths")


  }

  p <-  p + theme_light(base_size = 18) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major = element_blank())

  p
}
