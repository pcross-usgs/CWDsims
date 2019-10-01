#' Stochastic Comparison plot of totals over time
#'
#' @param outa counts as provided as output from the CWD model functions for the
#'  first simulation
#' @param outb counts as provided as output from the CWD model functions for the
#'  second simulation
#'
#' @return a density plot comparison
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom reshape2 melt
#' @importFrom tidyr spread
#' @importFrom forcats fct_recode
#'
#' @export

plot_compare_tots <- function(outa, outb, ...){
dat <- list(outa, outb)

dat <- melt(dat, id = c("age", "month", "population", "category",
                        "year", "sex", "disease", "sim")) %>%
  filter(month %% 12 == 10, round(year, 0) == max(round(year, 0))) %>%
  rename(scenario = L1) %>%
  mutate(scenario = fct_recode(as.factor(scenario), A = "1", B = "2")) %>%
  group_by(sim, scenario) %>%
  summarize(n = sum(population))

theme_set(theme_bw(base_size = 18))

# define some color options
cols <- c('#ffff00','#0000ff')

# plot
ggplot(dat, aes(x = n, y = scenario, fill = scenario)) +
  geom_density_ridges(alpha= 0.6) + theme_bw(base_size = 18) + theme_ridges() +
  xlab("Total population") + ylab("") +
  scale_y_discrete() + scale_fill_manual(values = cols)

}

