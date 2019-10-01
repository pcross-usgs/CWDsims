#' hex sticker function
#'
#' @import hexSticker

outline = "#003366"
background = "#003366"
hexSticker::sticker("./man/figures/highrezlogo-01.png",
        package = "CWDsims",
        h_fill = background,
        h_color = outline,
        s_y = 1,
        p_size = 12,
        p_y = 1.6,
        s_width = 0.72,
        s_height = 0.55,
        s_x = 1,
        filename = "./man/figures/logo.png")

