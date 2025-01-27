context("PredictionClassif")

test_that("Construction", {
  task = mlr_tasks$get("boston_housing")
  p = PredictionRegr$new(row_ids = task$row_ids, truth = task$truth(), response = task$truth())
  expect_prediction(p)
  expect_prediction_regr(p)
})

test_that("Internally constructed Prediction", {
  task = mlr_tasks$get("boston_housing")
  lrn = mlr_learners$get("regr.featureless")
  lrn$predict_type = "se"
  e = Experiment$new(task, lrn)$train()
  e$predict()
  p = e$prediction
  expect_prediction(p)
  expect_prediction_regr(p)
})


test_that("rbind", {
  task = mlr_tasks$get("boston_housing")
  lrn = mlr_learners$get("regr.featureless")
  lrn$predict_type = "se"
  rr = resample(task, lrn, "cv3")

  pred = do.call(rbind, map(rr$experiments(), "prediction"))
  expect_prediction(pred)
  expect_prediction_regr(pred)

  dt = as.data.table(pred)
  expect_data_table(dt, nrow = task$nrow, ncol = 4L, any.missing = FALSE)
})
