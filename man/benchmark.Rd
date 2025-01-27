% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/benchmark.R
\name{benchmark}
\alias{benchmark}
\title{Benchmark Multiple Learners on Multiple Tasks}
\usage{
benchmark(design, measures = NULL, ctrl = list(store_model = FALSE))
}
\arguments{
\item{design}{:: \code{\link[=data.frame]{data.frame()}}\cr
Data frame (or \code{\link[=data.table]{data.table()}}) with three columns: "task", "learner", and "resampling".
Each row defines a set of resampled experiments by providing a \link{Task}, \link{Learner} and \link{Resampling} strategy.
The helper function \code{\link[=expand_grid]{expand_grid()}} can assist in generating an exhaustive design (see examples) and properly
instantiate the \link{Resampling}s per \link{Task}.}

\item{measures}{:: list of \link{Measure}\cr
List of performance measures to calculate.
Defaults to the measures specified in the each respective \link{Task}.
The measures will be cloned.}

\item{ctrl}{:: (named \code{list()})\cr
Object to control experiment execution. See \code{\link[=mlr_control]{mlr_control()}} for details.
Note that per default, fitted learner models are discarded after the prediction in order to save
some memory.}
}
\value{
\link{BenchmarkResult}.
}
\description{
Runs a benchmark on arbitrary combinations of learners, tasks, and resampling strategies (possibly in parallel).
Resamplings which are not already instantiated will be instantiated automatically.
However, these auto-instantiated resamplings will not be synchronized per task, i.e. different learners will
work on different splits of the same task.

To generate exhaustive designs and automatically instantiate resampling strategies per task, use \code{\link[=expand_grid]{expand_grid()}}.
}
\section{Parallelization}{

This function can be parallelized with the \CRANpkg{future} package.
Each row in the \code{design} creates as many jobs as there are resampling iterations.
All jobs are forwarded to the \CRANpkg{future} package together.
To select a parallel backend, use \code{\link[future:plan]{future::plan()}}.
}

\examples{
tasks = mlr_tasks$mget(c("iris", "sonar"))
learners = mlr_learners$mget(c("classif.featureless", "classif.rpart"))
resamplings = mlr_resamplings$mget("holdout")

design = expand_grid(tasks, learners, resamplings)
print(design)

set.seed(123)
bmr = benchmark(design)

# performance for all conducted experiments
head(as.data.table(bmr))

# aggregated performance values
bmr$aggregated(objects = FALSE)

# Overview of of resamplings that were conducted internally
rrs = bmr$resample_results
print(rrs)

# Extract first ResampleResult
rr = bmr$resample_result(hash = rrs$hash[1])
print(rr)

# Extract predictions of first experiment of this resampling
head(as.data.table(rr$experiment(1)$prediction))
}
