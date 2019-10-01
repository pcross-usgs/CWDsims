# CWDsims

R package to run chronic wasting disease models and a shiny app

This is a repository with R code for an interactive Shiny application of CWD disease models. Currently there are deterministic and stochastic models that are intended to project out scenarios for a 5 to 10 year window over which we assume that the management and vital rates are kept constant. The models are sex and age structured with direct and indirect transmission. 

### Webpage for the shiny app ###

Currently available online at: 

https://paulchafeecr.shinyapps.io/comb_app_v2_CWD/

### How do I get set up? ###

Dependencies: shiny, popbio, tidyr, cowplot, magrittr, reshape2, knitr, ggridges, shinydashboard, markdown, stats, forcats, stringr, dplyr, ggplot2, hexSticker  

To install in R first you must install the devtools package. You can do this from CRAN. Invoke R and then type

```{r} 
install.packages("devtools")
```
Load the devtools package.

```{r} 
library(devtools)
```

Then

```{r} 
install_github("pcross-usgs/CWDsims")
```

### Who do I talk to? ###

Paul C Cross  
US Geological Survey  
Northern Rocky Mountain Science Center  
pcross@usgs.gov
