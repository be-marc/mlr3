% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LearnerClassif.R
\docType{data}
\name{LearnerClassif}
\alias{LearnerClassif}
\title{Classification Learner}
\format{\link[R6:R6Class]{R6::R6Class} object inheriting from \link{Learner}.}
\description{
This Learner specializes \link{Learner} for classification problems.

Predefined learners can be found in the \link{Dictionary} \link{mlr_learners}.
}
\section{Construction}{
\preformatted{l = LearnerClassif$new(id, param_set = ParamSet$new(), param_vals = list(), predict_types = character(),
     feature_types = character(), properties = character(), data_formats = "data.table", packages = character())
}

For a description of the arguments, see \link{Learner}.
\code{task_type} is set to \code{"classif"}.
Possible values for \code{predict_types} are a subset of \code{c("response", "prob")}.
}

\section{Fields}{

See \link{Learner}.
}

\section{Methods}{

See \link{Learner}.
}

\examples{
# get all classification learners from mlr_learners:
lrns = mlr_learners$mget(mlr_learners$keys("^classif"))
names(lrns)

# get a specific learner from mlr_learners:
lrn = mlr_learners$get("classif.rpart")
print(lrn)
}
\seealso{
Other Learner: \code{\link{LearnerRegr}},
  \code{\link{Learner}}, \code{\link{mlr_learners}}
}
\concept{Learner}
\keyword{datasets}
