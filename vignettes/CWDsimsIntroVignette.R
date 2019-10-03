## ----setup, include=FALSE, message=FALSE------------------
library(knitr)
library(CWDsims)
options(continue=" ")
options(width=60)
knitr::opts_chunk$set(echo = TRUE,
                      warning = FALSE,
                      message = FALSE,
                      fig.height = 6,
                      fig.width = 6)

## ----shinyapp, echo=TRUE, eval=FALSE----------------------
#  library(CWDsims)
#  launchCWDapp("CWDapp")

## ----workflow, echo=TRUE, eval=FALSE----------------------
#  # first create a list of parameter values
#  params <- list(fawn.an.sur = 0.6, juv.an.sur = 0.8, ad.an.f.sur = 0.9,
#                 ad.an.m.sur = 0.9, fawn.repro = 0, juv.repro = 0.6,
#                 ad.repro = 1, hunt.mort.fawn = 0.01, hunt.mort.juv.f = 0.1,
#                 hunt.mort.juv.m = 0.1, hunt.mort.ad.f = 0.2,
#                 hunt.mort.ad.m = 0.2, ini.fawn.prev = 0.01, ini.juv.prev = 0.03,
#                 ini.ad.f.prev = 0.04, ini.ad.m.prev = 0.04, n.age.cats = 12,
#                 p = 0.43, env.foi = 0, beta.f = 0.15, beta.m = 0.15, theta = 1,
#                 n0 = 1000, n.years = 10, rel.risk = 1.0)
#  
#  # run the deterministic CWD model
#  out <- cwd_det_model(params)
#  
#  # plot the totals
#  plot_tots(out$counts)

