soc_3 <- fread("data/soc_3_example.csv")
soc_3_brkd <- fread("data/soc_3_brkdwn_example.csv")

test_that("SOC_3 to ISCO_3 crosswalk is OK!", {
  isco_estimate <- soc_isco_crosswalk(soc_3, isco_lvl = 3, soc_lvl = "soc_3")
  expect_equal(soc_3[, sum(value)],
               isco_estimate[, sum(value)])
  expect_true(isco_estimate[, all(!is.na(nchar(isco08)))])
})

test_that("SOC_3 to ISCO_2 crosswalk is OK!", {
  isco_estimate <- soc_isco_crosswalk(soc_3, isco_lvl = 2, soc_lvl = "soc_3")
  expect_equal(soc_3[, sum(value)],
               isco_estimate[, sum(value)])
  expect_true(isco_estimate[, all(!is.na(nchar(isco08)))])
})

test_that("SOC_3 to ISCO_1 crosswalk is OK!", {
  isco_estimate <- soc_isco_crosswalk(soc_3, isco_lvl = 1, soc_lvl = "soc_3")
  expect_equal(soc_3[, sum(value)],
               isco_estimate[, sum(value)])
  expect_true(isco_estimate[, all(!is.na(nchar(isco08)))])
})

test_that("SOC_3 to ISCO_1 with breakdown crosswalk is OK!", {
  isco_estimate <- soc_isco_crosswalk(soc_3_brkd,
                                      isco_lvl = 1,
                                      soc_lvl = "soc_3",
                                      brkd_col = "gender")
  expect_equal(soc_3_brkd[, sum(value)],
               isco_estimate[, sum(value)])
  expect_true(isco_estimate[, all(!is.na(nchar(isco08)))])
})

test_that("SOC_3 to ISCO_1 indicator with breakdown crosswalk is OK!", {
  isco_estimate <- soc_isco_crosswalk(soc_3_brkd,
                                      isco_lvl = 1,
                                      soc_lvl = "soc_3",
                                      brkd_col = "gender",
                                      indicator = TRUE)
  expect_true(soc_3_brkd[, sum(value)] > isco_estimate[, sum(value)])
  expect_true(isco_estimate[, all(!is.na(nchar(isco08)))])
})
