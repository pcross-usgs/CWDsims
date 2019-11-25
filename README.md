CWDsims <img src="man/figures/logo.png" alt="toxEval" height="150px" align="right" />
=====================================================================================
R package to run chronic wasting disease (CWD) models and a Shiny app. This project has moved to  https://code.usgs.gov/usgs/norock/cross_p/cwdsims


This is a repository with R code for an interactive Shiny application of CWD disease models. Currently there are deterministic and stochastic models that are intended to model hunting scenarios for a 5 to 10 year time horizon. The models are sex and age structured with direct and indirect transmission. 

### Installation ###

To use this package, you should be using R 3.4+. You can install the package from GitHub using the `remotes` package. To build the vignettes (long-form documentation) included with the package, you'll need the `knitr` and `markdown` libraries installed.

To install all 3 packages:

```r
install.packages(c("remotes", "knitr", "rmarkdown"))
```

Then to install the stable, approved package with vignettes:

```r
remotes::install_git("https://code.usgs.gov/usgs/norock/cross_p/cwdsims", ref = "v0.1.1", build_vignettes = TRUE, build_manual = TRUE)
```

Or to install the most recent development version:

```r
remotes::install_github("https://code.usgs.gov/usgs/norock/cross_p/cwdsims", build_vignettes = TRUE, build_manual = TRUE)
```

Note some Mac users may need to first install xQuartz (https://www.xquartz.org).

This may prompt you to update some of the necessary packages. Press "1" to update all packages. In some cases, the compilation of the *later* package has failed. If this occurs, re-run the install_github command above and when prompted

> Do you want to install from sources the package which needs compilation? (Yes/no/cancel)

Type "no"

### Introductory material

Once "CWDsims" is installed, you can find more introductory material about the package in the vignettes. 

```r
library(CWDsims)
vignette(package = "CWDsims") # all vignettes available
vignette("CWDsimsIntroVignette") # load the introduction
```
For a list of the available functions: 

```r
?CWDsims
```

### Reporting bugs ###

Please consider reporting bugs and asking questions on the Issues page:

[https://code.usgs.gov/usgs/norock/cross_p/cwdsims/issues](https://code.usgs.gov/usgs/norock/cross_p/cwdsims/issues)


Follow `@USGS_R` on Twitter for updates on USGS R packages:

[![Twitter Follow](https://img.shields.io/twitter/follow/USGS_R.svg?style=social&label=Follow%20USGS_R)](https://twitter.com/USGS_R)

### Citing CWDsims ###

``` r
citation(package = "CWDsims")

># To cite CWDsims in publications, please
># use:
># 
>#   Cross, P.C. and E.S. Almberg. 2019. CWDsims: 
>#   An R package for simulating chronic wasting
>#   disease scenarios, doi.org/10.5066/P9QZTTLY
># 
># A BibTeX entry for LaTeX users is
># 
>#   @Manual{,
>#     author = {Paul C. Cross and Emily S. Almberg},
>#     title = {CWDsims: An R package for simulating chronic wasing disease
>#     scenarios},
>#     publisher = {U.S. Geological Survey},
>#     address = {Reston, VA},
>#     version = {0.1.1},
>#     institution = {U.S. Geological Survey},
>#     year = {2019},
>#     url = {https://code.usgs.gov/usgs/norock/cross_p/cwdsims},
>#   }
```

This R package relates to USGS IPDS #IP-108402. 
