#' Stochastic Comparison plot
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
#' @importFrom cowplot plot_grid
#' @importFrom stringr str_sub
#' @importFrom forcats fct_recode
#'
#' @export

plot_compare_all <- function(outa, outb, ...){

  outcount <- list(outa$counts, outb$counts)
  outcount <- melt(outcount, id = c("age", "month", "population", "category",
                                    "year", "sex", "disease", "sim")) %>%
    filter(month %% 12 == 10, round(year, 0) == max(round(year, 0))) %>%
    rename(scenario = L1) %>%
    mutate(scenario = fct_recode(as.factor(scenario), A = "1", B = "2"))

  totals <- outcount %>%
    group_by(sim, scenario) %>%
    summarize(n = sum(population))

  prev <- outcount %>%
    group_by(sim, disease, scenario) %>%
    summarize(n = sum(population)) %>%
    spread(key = disease, value = n) %>%
    mutate(prevalence = yes/ (no + yes))

  death <- list(outa$deaths, outb$deaths)

  hunted <- melt(death, id = c("age", "month", "population", "category",
                               "year", "sex", "sim")) %>%
    filter(age >= 2, str_sub(category, 1, 1) == "H") %>%
    rename(scenario = L1) %>%
    mutate(scenario = fct_recode(as.factor(scenario), A = "1", B = "2"))

  tot.hunted <- hunted %>%
    group_by(sim, scenario) %>%
    summarize(n = sum(population))

  males.hunted <- hunted %>%
    filter(sex == "m") %>%
    group_by(sim, scenario) %>%
    summarize(n = sum(population))

  last.hunted <- hunted %>%
    filter(round(year, 0) == max(round(year, 0))) %>%
    group_by(sim, scenario) %>%
    summarize(n = sum(population))

  males.last.hunted <- hunted %>%
    filter(round(year, 0) == max(round(year, 0))) %>%
    filter(sex == "m") %>%
    group_by(sim, scenario) %>%
    summarize(n = sum(population))

  theme_set(theme_bw(base_size = 18))

  # define colors
  cols <- c('#ffff00','#0000ff')

  # totals

  p1 <- ggplot(totals, aes(x = n, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6, scale = 4) + theme_ridges() +
    theme(legend.position = "none") +
    xlab("Total population") + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols)

  # prev
  p2 <- ggplot(prev, aes(x = prevalence, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6, scale = 4) +
    theme_ridges() +theme(legend.position = "none") +
    xlab("Disease prevalence") + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols)

  # plot
  p3 <- ggplot(tot.hunted, aes(x = n, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6, scale = 4) +
    theme_ridges() +theme(legend.position = "none") +
    xlab("Total hunted > 1yr old") + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols)

  p4 <- ggplot(last.hunted, aes(x = n, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6, scale = 4) + theme_ridges() +
    theme(legend.position = "none") +
    xlab("Total hunted > 1yr old in last year") + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols)

  # plot
  p5 <- ggplot(males.hunted, aes(x = n, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6, scale = 4) + theme_ridges() +
    theme(legend.position = "none") +
    xlab("Males hunted > 1yr old") + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols)

  # plot
  p6 <- ggplot(males.last.hunted, aes(x = n, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6, scale = 4) + theme_ridges() +
    theme(legend.position = "none") +
    xlab("Males hunted > 1yr old in last year") + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols)

  p7 <- plot_grid(p1,p2,p3,p4,p5,p6, nrow = 3)
  p7
}
