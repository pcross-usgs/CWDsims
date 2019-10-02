#' Vital rate plot
#'
#' Creates a plot of the survival and reproduction distributions that are
#' defined by the CWD model parameters
#'
#' @param params list of the parameters provided to the CWD model
#' @return a plot of the vital rate distributions
#'
#' @importFrom tidyr gather
#' @importFrom magrittr %>% %$%
#' @importFrom stats rbeta
#' @importFrom ggridges geom_density_ridges theme_ridges
#' @import ggplot2
#'
#' @export

plot_vitals <- function(params){

  # First draw some values from the distribution
  sur.fawn <- params %$%
    est_beta_params(fawn.an.sur, fawn.sur.var) %$%
    rbeta(1000, alpha, beta)
  sur.juv <- params %$%
    est_beta_params(juv.an.sur, sur.var) %$%
    rbeta(1000, alpha, beta)
  sur.ad.f <- params %$%
    est_beta_params(ad.an.f.sur, sur.var) %$%
    rbeta(1000, alpha, beta)
  sur.ad.m <- params %$%
    est_beta_params(ad.an.m.sur, sur.var) %$%
    rbeta(1000, alpha, beta)

  hunt.fawn <- params %$%
    est_beta_params(hunt.mort.fawn, hunt.var) %$%
    rbeta(1000, alpha, beta)
  hunt.juv.m <- params %$%
    est_beta_params(hunt.mort.juv.f, hunt.var) %$%
    rbeta(1000, alpha, beta)
  hunt.juv.f <- params %$%
    est_beta_params(hunt.mort.juv.m, hunt.var) %$%
    rbeta(1000, alpha, beta)
  hunt.ad.f <- params %$%
    est_beta_params(hunt.mort.ad.f, hunt.var) %$%
    rbeta(1000, alpha, beta)
  hunt.ad.m <- params %$%
    est_beta_params(hunt.mort.ad.m, hunt.var) %$%
    rbeta(1000, alpha, beta)

  sur.tot.fawn <- sur.fawn*(1 - hunt.fawn)
  sur.tot.juv.f <- sur.juv*(1 - hunt.juv.f)
  sur.tot.juv.m <- sur.juv*(1 - hunt.juv.m)
  sur.tot.ad.f <- sur.ad.f*(1 - hunt.ad.f)
  sur.tot.ad.m <- sur.ad.m*(1 - hunt.ad.m)

  repro.juv <-  params %$%
    est_beta_params(juv.repro/2, repro.var) %$%
    rbeta(1000, alpha, beta) * 2
  repro.ad <-  params %$%
    est_beta_params(ad.repro/2, repro.var) %$%
    rbeta(1000, alpha, beta) * 2

  #create a wide data.frame
  params.stoch <- data.frame(sur.tot.fawn = sur.tot.fawn,
                             sur.tot.juv.f = sur.tot.juv.f,
                             sur.tot.juv.m = sur.tot.juv.m,
                             sur.tot.ad.f = sur.tot.ad.f,
                             sur.tot.ad.m = sur.tot.ad.m,
                             repro.juv = repro.juv,
                             repro.ad = repro.ad)

  params.stoch.2 <-  params.stoch %>%
    gather('sur.tot.fawn', 'sur.tot.juv.f', 'sur.tot.juv.m','sur.tot.ad.f',
      'sur.tot.ad.m', 'repro.juv', 'repro.ad',
      key = "parameter", value = "value")


  # plot
  ggplot(params.stoch.2, aes(x = value, y = parameter)) +
    geom_density_ridges() + theme_ridges() + ylab("") +
    scale_y_discrete(labels = c("reproduction adult",
                                "reproduction juvenile",
                                "survival female",
                                "survival male",
                                "survival fawn",
                                "survival juvenile male",
                                "survival juvenile female")) +
    theme_set(theme_bw(base_size = 18))

  }
