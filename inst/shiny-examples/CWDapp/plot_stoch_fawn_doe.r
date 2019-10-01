#' Fawn:doe stochastic plot
#'
#' @param dat counts as provided as output from the CWD model
#' @param all.lines TRUE/FALSE for whether to plot a line for every simulation
#' @param error.bars 2 value vector for the hi and lo percentiles on the error
#' bars. If missing, no error bars will be shown.
#'
#' @return a plot of the percent of the population in each age class
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom stats quantile
#' @importFrom tidyr unite
#'
#' @export

plot_stoch_fawn_doe <- function(dat, all.lines, error.bars, ...){
  if(missing(all.lines)){all.lines = TRUE}

  dat$age.cat <- "adult"
  dat$age.cat[dat$age == 1] <- "fawn"

  # summarize by year and sex
  dat.sum <- dat %>%
    filter(month %% 12 == 11) %>%
    group_by(year, sex, age.cat, sim) %>%
    summarize(n = sum(population)) %>%
    unite(sex.age, sex, age.cat) %>%
    spread(key = sex.age, value = n) %>%
    mutate(fawn.doe = (m_fawn + f_fawn) / f_adult)

  # calculate the mean
  dat.mean <- dat.sum %>%
    group_by(year) %>%
    summarize(avg = mean(fawn.doe))

  if(all.lines == TRUE){
    p <- ggplot(data = dat.sum, aes(x = year, y = fawn.doe, group = sim)) +
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
      summarize(avg = mean(fawn.doe), lo = quantile(fawn.doe,error.bars[1]),
                hi = quantile(fawn.doe,error.bars[2]))

    p <- p + geom_line(data = dat.mean, aes(x = year, y = lo, group = NULL),
                       linetype = "dashed", color = "red") +
      geom_line(data = dat.mean, aes(x = year, y = hi, group = NULL),
                linetype = "dashed", color = "red")
  }

  p <- p + xlab("Year") + ylab("Fawn:Doe") + theme_light(base_size = 18) +
    ylim(0.1, 1) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())


  p


}
