MeasureResubstitution = R6Class("MeasureResubstitution",
  inherit = Measure,
  cloneable = FALSE,
  public = list(
    measure = NULL,

    initialize = function(id = NULL, measure) {
      self$measure = assert_measure(measure)
      if (is.null(id))
        id = paste0(measure$id, ".train")
      super$initialize(
        id = id,
        task_type = measure$task_type,
        range = measure$range,
        minimize = measure$minimize,
        predict_type = measure$predict_type,
        task_properties = measure$task_properties,
        na_score = measure$na_score,
        packages = measure$packages
      )
    },

    calculate = function(experiment = NULL, prediction = experiment$prediction) {
      task = experiment$task
      nt = task$clone()$filter(experiment$train_set)
      prediction = experiment$learner$predict(task)
      self$measure$calculate(experiment = experiment, prediction = prediction)
    }
  )
)

if (FALSE) {
  m = mlr_measures$get("classif.ce")
  m = MeasureResubstitution$new(measure = m)

  task = mlr_tasks$get("iris")
  task$measures = list(m, mlr_measures$get("classif.ce"))

  resample(task, "classif.rpart", "cv")

}
