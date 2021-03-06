% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/graphics_plotITRCWaves.R
\name{plotFRC}
\alias{plotFRC}
\title{plotFRC}
\usage{
plotFRC(
  model,
  title_ = "Fractional Response Curve",
  xlab_ = "Dose",
  ylab_ = "Cumulative fraction of cells",
  fill.guide_ = "legend",
  ylimits_ = TRUE,
  alpha_ = 0.5,
  getScaleY = getScaleY.SCRC,
  theme.signal = NULL,
  plot.heterogeneity = TRUE,
  ...
)
}
\arguments{
\item{model}{FRAModel object return by FRA function}

\item{title_}{character, specify title of plot, default \code{"Fractional Response Curve"}}

\item{xlab_}{character, label of x axes, default \code{"Dose"}}

\item{ylab_}{character, label of y axes and legend title, default \code{"Cumulative fraction of cells"}}

\item{fill.guide_}{logical, specify if legend should be displayed}

\item{ylimits_}{TRUE FALSE or vector of minimum and maximum of y axes}

\item{theme.signal}{optional, object returned by \code{GetRescaledSignalTheme}}

\item{plot.heterogeneity, }{logical, specify if heterogeneity should be added to FRC plot, default \code{TRUE}}

\item{...}{
  Arguments passed on to \code{\link[=rescaleSignalsValues]{rescaleSignalsValues}}
  \describe{
    \item{\code{rescale.fun}}{parameter, that defines a function used for rescaling signals in plots.
There are three built-in functions, that can be chosen:
(1) \code{'factor'} - signals treated as factors (default) with levels defined in list \code{rescale.fun.args},
(2) \code{'numeric'},
(3) \code{logarithmic} - with base defined in \code{rescale.fun.args} - default: \code{e = exp(1)}.
Function must be defined as a lambda construct \code{function(x, ...){...}}.}
    \item{\code{rescale.fun.args}}{list of the arguments to defaults \code{rescale.fun}}
  }}
}
\description{
This functions return ggplot2 figure that visualise fractional response curve (FRC) that 
quantifies fractions of cells that exhibit different responses to a change in dose, or any other experimental condition.
}
