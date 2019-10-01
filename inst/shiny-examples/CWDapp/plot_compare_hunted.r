#' Stochastic Comparison plot of all hunted
#'
#' @param outa counts as provided as output from the CWD model functions for the
#'  first simulation
#' @param outb counts as provided as output from the CWD model functions for the
#'  second simulation
#' @param end TRUE/FALSE for whether to show just the last timepoint
#'  (end = TRUE), or the cumulative number over the whole simulation.
#'  Default = FALSE.
#' @param males.only TRUE/FALSE for whether to show only males
#'  Default = FALSE.
#' @param old.only TRUE/FALSE for whether to show just those hunted over 3yrs.
#'  Default = FALSE.
#'
#' @return a density plot comparison
#'
#' @import ggplot2
#' @import dplyr
#' @importFrom magrittr %>%
#' @importFrom reshape2 melt
#' @importFrom tidyr spread
#'
#' @export

plot_compare_hunted <- function(outa, outb, end, males.only, old.only, ...){

  if(missing(end) == TRUE){end <- FALSE}
  if(missing(males.only) == TRUE){males.only <- FALSE}
  if(missing(old.only) == TRUE){old.only <- FALSE}

  # combine the two outputs
  dat <- list(outa, outb)
  dat <- melt(dat, id = c("age", "month", "population", "category",
                          "year", "sex", "sim")) %>%
    filter(age >= 2, str_sub(category, 1, 1) == "H") %>%
    rename(scenario = L1) %>%
    mutate(scenario = fct_recode(as.factor(scenario), A = "1", B = "2"),
           year = floor(year))

 if(males.only == TRUE){
    dat <- dat %>% filter(sex == "m")
  }

 if(old.only == TRUE){
    dat <- dat %>% filter(age >= 4)
  }

 if(end == TRUE){
   dat <- dat %>% filter(round(year, 0) == max(round(year, 0)))
 }

  dat <- dat %>%
    group_by(sim, scenario) %>%
    summarize(n = sum(population))

  # define some color options
  cols <- c('#ffff00','#0000ff')

  # plot
  p <- ggplot(dat, aes(x = n, y = scenario, fill = scenario)) +
    geom_density_ridges(alpha= 0.6) + theme_ridges() + ylab("") +
    scale_y_discrete() + scale_fill_manual(values = cols) +
    theme_set(theme_bw(base_size = 18))

  if(end == FALSE){
    if(males.only == FALSE){
      if(old.only == FALSE){
        p <- p + xlab("Total hunted > 1yr old")
      }
    }
  }

  if(end == TRUE){
    if(males.only == FALSE){
      if(old.only == FALSE){
        p <- p + xlab("Total hunted > 1yr old in last year")
      }
    }
  }

  if(end == FALSE){
    if(males.only == TRUE){
      if(old.only == FALSE){
        p <- p + xlab("Total males hunted > 1yr old")
      }
    }
  }

  if(end == TRUE){
    if(males.only == TRUE){
      if(old.only == FALSE){
        p <- p + xlab("Total males hunted > 1yr old in last year")
      }
    }
  }

  if(end == FALSE){
    if(males.only == FALSE){
      if(old.only == T){
        p <- p + xlab("Total hunted > 3yr old")
      }
    }
  }

  if(end == TRUE){
    if(males.only == FALSE){
      if(old.only == T){
        p <- p + xlab("Total hunted > 3yr old in last year")
      }
    }
  }

  if(end == FALSE){
    if(males.only == TRUE){
      if(old.only == T){
        p <- p + xlab("Total males hunted > 3yr old")
      }
    }
  }

  if(end == TRUE){
    if(males.only == TRUE){
      if(old.only == T){
        p <- p + xlab("Total males hunted > 3yr old in last year")
      }
    }
  }


}
