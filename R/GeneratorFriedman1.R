#' @title Friedman1 Regression Task Generator
#'
#' @aliases mlr_generators_friedman1
#' @format [R6::R6Class] inheriting from [Generator].
#' @include Generator.R
#'
#' @description
#' A [Generator] for the friedman1 task in [mlbench::mlbench.friedman1()].
#' @export
#' @examples
#' mlr_generators$get("friedman1")$generate(10)$data()
GeneratorFriedman1 = R6Class("GeneratorFriedman1",
  inherit = Generator,
  public = list(
    initialize = function(id = "friedman1") {
      param_set = ParamSet$new(list(
        ParamDbl$new("sd", lower = 0L, default = 1)
      ))
      super$initialize(id = id, "regr", "mlbench", param_set)
    }
  ),

  private = list(
    .generate = function(n) {
      data = invoke(mlbench::mlbench.friedman1, n = n, .args = self$param_set$values)
      colnames(data$x) = c(sprintf("important%i", 1:5), sprintf("unimportant%i", 1:5))
      data = insert_named(as.data.table(data$x), list(y = data$y))
      TaskRegr$new(sprintf("%s_%i", self$id, n), as.data.frame(data), target = "y")
    }
  )
)
