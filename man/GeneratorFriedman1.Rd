% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/GeneratorFriedman1.R
\docType{data}
\name{GeneratorFriedman1}
\alias{GeneratorFriedman1}
\alias{mlr_generators_friedman1}
\title{Friedman1 Regression Task Generator}
\format{\link[R6:R6Class]{R6::R6Class} inheriting from \link{Generator}.}
\usage{
GeneratorFriedman1
}
\description{
A \link{Generator} for the friedman1 task in \code{\link[mlbench:mlbench.friedman1]{mlbench::mlbench.friedman1()}}.
}
\examples{
mlr_generators$get("friedman1")$generate(10)$data()
}
\keyword{datasets}
