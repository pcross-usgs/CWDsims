#' Plot stochastic prevalence over time
#'
#' @param dat counts as provided as output from the CWD model
#' @param all.lines TRUE/FALSE for whether to plot a line for every simulation.
#' Default = TRUE.
#' @param error.bars 2 value vector for the hi and lo percentiles on the error
#' bars. If missing, no error bars are shown
#'
#' @return a multiple line plot of the simulation over time
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom tidyr spread
#' @importFrom stats quantile
#' @export

plot_stoch_prev <- function(dat, all.lines, error.bars, ...){

  if(missing(all.lines)){all.lines = TRUE}

  # summarize by year and disease
  dat.sum <- dat %>%
    filter(month %% 12 == 7) %>%
    group_by(year, sim, disease) %>%
    summarize(n = sum(population)) %>%
    spread(key = disease, value = n) %>%
    mutate(prev = yes/ (no + yes)) %>%
    arrange(sim, year)

  # calculate mean, lo and hi percentiles.
  dat.mean <- dat.sum %>%
    group_by(year) %>%
    summarize(avg.prev = mean(prev))

  # Start constructing the plot
  if(all.lines == TRUE){
    p <- ggplot(data = dat.sum, aes(x = year, y = prev, group = sim)) +
      geom_line(color = "grey") +
      geom_line(data = dat.mean, aes(x = year, y = avg.prev, group = NULL),
                size = 1.5)
  }

  if(all.lines == FALSE){
    p <- ggplot(data = dat.mean, aes(x = year, y = avg.prev, group = NULL)) +
      geom_line(size = 1.5)
  }

  if(missing(error.bars) == FALSE){
    # calculate mean, lo and hi percentiles.
    dat.mean <- dat.sum %>%
      group_by(year) %>%
      summarize(avg.prev = mean(prev),
                lo = quantile(prev, error.bars[1]),
                hi = quantile(prev, error.bars[2]))

    # plot the error bars
    p <- p + geom_line(data = dat.mean, aes(x = year, y = lo, group = NULL),
                       linetype = "dashed", color = "red") +
      geom_line(data = dat.mean, aes(x = year, y = hi, group = NULL),
                linetype = "dashed", color = "red")
  }

  p <- p + xlab("Year") + ylab("Prevalence") + theme_light(base_size = 18) +
    ylim(0, 1) +
    theme(panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank())

  p
}
