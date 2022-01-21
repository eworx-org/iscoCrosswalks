test_that("total count is maintained after a crosswalk", {
  dat <- fread("data/isco_3_example.csv")
  res <- crosswalk(dat, "isco_3_label", "isco_1_label")
  expect_equal(res[, sum(count)], dat[, sum(count)])
})
