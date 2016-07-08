
knitr::opts_chunk$set(cache=T,
                      fig.width=7,
                      fig.height=4,
                      dpi=300,
                      dev="png",
                      tidy=FALSE, tidy.opts=list(width.cutoff=75))

presentation_theme <- ggplot2::theme_grey()+
                ggplot2::theme(
                  text = ggplot2::element_text(size = 25, colour = "black"))
ggplot2::theme_set(presentation_theme)
