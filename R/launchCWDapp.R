#' launches the shinyCWDApp
#'
#' @export
#'

# wrapper for shiny::shinyApp()
launchCWDapp <- function() {
  appDir <- system.file("shiny-examples", "CWDapp", package = "CWDsims")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
  #ui = shinyAppUI, server = shinyAppServer)
}
