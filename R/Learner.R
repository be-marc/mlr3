#' @title Learner Class
#'
#' @usage NULL
#' @format [R6::R6Class] object.
#' @include mlr_reflections.R
#'
#' @description
#' This is the abstract base class for learner objects like [LearnerClassif] and [LearnerRegr].
#'
#' Learners consist of the following parts:
#'
#' - Methods `train()` and `predict()` to perform the respective steps.
#' - The fitted model, after calling `train()`.
#' - A [paradox::ParamSet] which stores meta-information about available hyperparameters, and also stores hyperparameter settings.
#' - Meta-information about the requirements and capabilities of the learner.
#'
#' Predefined learners are stored in the [Dictionary] [mlr_learners].
#'
#' @section Construction:
#' Note: This object is typically constructed via a derived classes, e.g. [LearnerClassif] or [LearnerRegr].
#'
#' ```
#' l = Learner$new(id, task_type, param_set = ParamSet$new(), param_vals = list(), predict_types = character(),
#'      feature_types = character(), properties = character(), packages = character())
#' ```
#'
#' * `id` :: `character(1)`\cr
#'   Identifier for the learner.
#'
#' * `task_type` :: `character(1)`\cr
#'   Type of the task the learner can operator on. E.g., `"classif"` or `"regr"`.
#'
#' * `param_set` :: [paradox::ParamSet]\cr
#'   Set of hyperparameters.
#'
#' * `param_vals` :: named `list()`\cr
#'   List of hyperparameter settings.
#'
#' * `predict_types` :: `character()`\cr
#'   Supported predict types. Must be a subset of [`mlr_reflections$learner_predict_types`][mlr_reflections].
#'
#' * `feature_types` :: `character()`\cr
#'   Feature types the learner operates on. Must be a subset of `mlr_reflections$task_feature_types`.
#'
#' * `properties` :: `character()`\cr
#'   Set of properties of the learner. Must be a subset of [`mlr_reflections$learner_properties`][mlr_reflections].
#'
#' * `data_formats` :: `character()`\cr
#'   Vector of supported data formats which can be processed during `$train()` and `$predict()`.
#'   Defaults to `"data.table"`.
#'
#' * `packages` :: `character()`\cr
#'   Set of required packages.
#'   Note that these packages will be loaded via [requireNamespace()], and are not attached.
#'
#' @section Fields:
#' * `id` :: `character(1)`\cr
#'   Identifier of the learner.
#'
#' * `task_type` :: `character(1)`\cr
#'   Stores the type of class this learner can operate on, e.g. `"classif"` or `"regr"`.
#'   A complete list of task types is stored in [`mlr_reflections$task_types`][mlr_reflections].
#'
#' * `param_set` :: [paradox::ParamSet]\cr
#'   Description of available hyperparameters and hyperparameter settings.
#'
#' * `predict_types` :: `character()`\cr
#'   Stores the possible predict types the learner is capable of.
#'   A complete list of candidate predict types, grouped by task type, is stored in [`mlr_reflections$learner_predict_types`][mlr_reflections].
#'
#' * `predict_type` :: `character(1)`\cr
#'   Stores the currently selected predict type. Must be an element of `l$predict_types`.
#'
#' * `feature_types` :: `character()`\cr
#'   Stores the feature types the learner can handle, e.g. `"logical"`, `"numeric"`, or `"factor"`.
#'   A complete list of candidate feature types, grouped by task type, is stored in [`mlr_reflections$task_feature_types`][mlr_reflections].
#'
#' * `properties` :: `character()`\cr
#'   Stores a set of properties/capabilities the learner has.
#'   A complete list of candidate properties, grouped by task type, is stored in [`mlr_reflections$learner_properties`][mlr_reflections].
#'
#' * `packages` :: `character()`\cr
#'   Stores the names of required packages.
#'
#' * `hash` :: `character(1)`\cr
#'   Hash (unique identifier) for this object.
#'
#' @section Methods:
#' * `params(tag)`\cr
#'   `character(1)` -> named `list()`\cr
#'   Returns a list of hyperparameter settings from `param_set` where the corresponding parameters in `param_set` are tagged
#'   with `tag`. I.e., `l$params("train")` returns all settings of hyperparameters relevant in the training step.
#'
#' * `train(task)`\cr
#'   [Task] -> [Learner]\cr
#'   Train the learner on the complete [Task], sets `self$model` to the learner model and returns itself.
#'
#' * `predict(task)`\cr
#'   [Task] -> [Prediction]\cr
#'   Uses `model` (fitted and stored during `train()`) to return a [Prediction] object.
#'   Note: Argument `model` defaults to the model stored inside the learner.
#'   The learner and the model are stored separately for performance reasons.
#'   However, if you retrieve the learner via the [Experiment], `mlr3` automatically inserts the model into the slot `$model`,
#'   so that you do not need to pass the model to each method of the learner yourself.
#'
#'
#' @section Optional Extractors:
#'
#' Specific learner implementations are free to implement additional getters to ease the access of certain parts
#' of the model in the inherited subclasses.
#'
#' For the following operations, extractors are standardized:
#'
#' * `importance(...)`: Returns a feature importance score as `numeric()`.
#'   The learner must be tagged with property "importance".
#'
#'   The higher the score, the more important the variable.
#'   The returned vector is named with feature names and sorted in decreasing order.
#'   Note that the model might omit features it has not used at all.
#'
#' * `selected_features(...)`: Returns a subset of selected features as `character()`.
#'   The learner must be tagged with property "selected_features".
#'
#' * `oob_error(...)`: Returns the out-of-bag error of the model as `numeric(1)`.
#'   The learner must be tagged with property "oob_error".
#'
#' @section Setting Hyperparameters:
#'
#' All information about hyperparameters is stored in the slot `param_set` which is a [paradox::ParamSet].
#' The printer gives an overview about the ids of available hyperparameters, their storage type, lower and upper bounds,
#' possible levels (for factors), default values and assigned values.
#' To set hyperparameters, assign a named list to the subslot `values`:
#' ```
#' lrn = mlr_learners$get("classif.rpart")
#' lrn$param_set$values = list(minsplit = 3, cp = 0.01)
#' ```
#' Note that this operation erases all previously set hyperparameter values.
#' If you only intend to change one specific hyperparameter value and leave the others as-is, you can use the helper function [mlr3misc::insert_named()]:
#' ```
#' lrn$param_set$values = mlr3misc::insert_named(lrn$param_set$values, list(cp = 0.001))
#' ```
#' If the learner has additional hyperparameters which are not encoded in the [ParamSet][paradox::ParamSet], you can easily extend the learner.
#' Here, we add a hyperparameter with id "foo" possible levels "a" and "b":
#' ```
#' lrn$param_set$add(paradox::ParamFct$new("foo", levels = c("a", "b")))
#' ```
#'
#' @family Learner
#' @export
Learner = R6Class("Learner",
  public = list(
    id = NULL,
    task_type = NULL,
    predict_types = NULL,
    feature_types = NULL,
    properties = NULL,
    data_formats = NULL,
    packages = NULL,
    model = NULL,

    initialize = function(id, task_type, param_set = ParamSet$new(), param_vals = list(), predict_types = character(),
      feature_types = character(), properties = character(), data_formats = "data.table", packages = character()) {

      self$id = assert_id(id)
      self$task_type = assert_choice(task_type, mlr_reflections$task_types)
      private$.param_set = assert_param_set(param_set)
      self$param_set$values = param_vals
      self$feature_types = assert_sorted_subset(feature_types, mlr_reflections$task_feature_types)
      self$predict_types = assert_sorted_subset(predict_types, mlr_reflections$learner_predict_types[[task_type]], empty.ok = FALSE)
      private$.predict_type = predict_types[1L]
      self$packages = assert_set(packages)
      self$properties = sort(assert_subset(properties, mlr_reflections$learner_properties[[task_type]]))
      self$data_formats = assert_subset(data_formats, mlr_reflections$task_data_formats)
    },

    format = function() {
      sprintf("<%s:%s>", class(self)[1L], self$id)
    },

    print = function() {
      learner_print(self)
    },

    params = function(tag) {
      assert_string(tag)
      pv = self$param_set$values
      pv[map_lgl(self$param_set$tags[names(pv)], is.element, el = tag)]
    }
  ),

  active = list(
    hash = function() {
      hash(list(class(self), self$id, self$param_set$values, private$.predict_type))
    },

    predict_type = function(rhs) {
      if (missing(rhs)) {
        return(private$.predict_type)
      }
      assert_choice(rhs, mlr_reflections$learner_predict_types[[self$task_type]])
      if (rhs %nin% self$predict_types) {
        stopf("Learner does not support predict type '%s'", rhs)
      }
      private$.predict_type = rhs
    },

    param_set = function(rhs) {
      if (!missing(rhs) && !identical(rhs, private$.param_set)) {
        stop("param_set is read-only.")
      }
      private$.param_set
    }
  ),

  private = list(
    .predict_type = NULL,
    .param_set = NULL
  )
)

learner_print = function(self) {
  catf(format(self))
  catf(str_indent("Parameters:", as_short_string(self$param_set$values, 1000L)))
  catf(str_indent("Packages:", self$packages))
  catf(str_indent("Predict Type:", self$predict_type))
  catf(str_indent("Feature types:", self$feature_types))
  catf(str_indent("Properties:", self$properties))
}
