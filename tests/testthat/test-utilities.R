library(data.table)

test_that("total count is maintained after a crosswalk", {
  dat <- fread("data/isco_3_example.csv")
  res <- isco_crosswalk(dat, "isco_3_label", "isco_1_label")
  expect_equal(res[, sum(value)], dat[, sum(value)])
})

test_that("crosswalk between levels of the same taxonomy is correct", {
  dat <- fread("data/isco_3_example.csv")
  exp <- fread("data/isco_1_example.csv")
  res <- isco_crosswalk(dat, "isco_3_label", "isco_1_label")
  expect_equal(res, exp)
})

test_that("original counts can be recovered if data is not aggregated", {
  dat <- fread("data/isco_3_example.csv")
  res <- isco_crosswalk(dat, "isco_3_label", "isco_1_label", aggr = FALSE)
  exp_count <- dat[order(job), value]
  res_count <- res[, .(value = sum(value)), by = "isco_3_label"][, value]
  expect_equal(res_count, exp_count)
})
