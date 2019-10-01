#' Buck:doe stochastic plot
#'
#' @param dat counts as provided as output from the CWD model
#' @param all.lines TRUE/FALSE for whether to plot a line for every simulation
#' @param error.bars error bars = vector of high and low percentiles
#' (2 values only). If missing, no error bars are shown.
#'
#' @return a plot of the ratio of adult males to adult females over time
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr unite
#' @importFrom stats quantile
#'
#' @export

plot_stoch_buck_doe <- function(dat, all.lines, error.bars, ...){
  if(missing(all.lines)){all.lines = TRUE}
  dat$age.cat <- "adult"
  dat$age.cat[dat$age == 1] <- "fawn"

  # summarize by year and sex
  dat.sum <- dat %>%
    filter(month %% 12 == 8) %>% # december of every year
    group_by(year, age.cat, sex, sim) %>%
    summarize(n = sum(population)) %>%
    unite(sex.age, sex, age.cat) %>%
    spread(key = sex.age, value = n) %>%
    mutate(buck.doe = m_adult / f_adult)

  # calculate the mean
  dat.mean <- dat.sum %>%
    group_by(year) %>%
    summarize(avg = mean(buck.doe))


  if(all.lines == TRUE){
    p <- ggplot(data = dat.sum, aes(x = year, y = buck.doe, group = sim)) +
      geom_line(color = "grey") +
      geom_line(data = dat.mean, aes(x = year, y = avg, group = NULL), size = 1.5)
  }

  if(all.lines == FALSE){
    p <- ggplot(data = dat.mean, aes(x = year, y = avg, group = NULL)) +
      geom_line(size = 1.5)
  }

  if(missing(error.bars) == FALSE){
    # calculate the mean, and the error bars
    dat.mean <- dat.sum %>%
      group_by(year) %>%
      summarize(avg = mean(buck.doe), lo = quantile(buck.doe, error.bars[1]),
                hi = quantile(buck.doe, error.bars[2]))

    p <- p + geom_line(data = dat.mean, aes(x = year, y = lo, group = NULL),
                       linetype = "dashed", color = "red") +
      geom_line(data = dat.mean, aes(x = year, y = hi, group = NULL),
                linetype = "dashed", color = "red")
  }

  p <- p + xlab("Year") + ylab("Buck:Doe") + theme_light(base_size = 18) +
    ylim(0.1,1) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())
  p
}
