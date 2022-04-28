isco_3 <- fread("data/isco_3_example.csv")
isco_3_brkdwn <- fread("data/isco_3_brkdwn_example.csv")
isco_1_brkdwn <- fread("data/isco_1_brkdwn_example.csv")

test_that("ISCO_3 to SOC_2 crosswalk is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_3)
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(nchar(soc10)))])
})

test_that("ISCO_3 to SOC_1 crosswalk is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_3, soc_lvl = "soc_1")
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_3 to SOC_3 crosswalk is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_3, soc_lvl = "soc_3")
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_3 to SOC_4 crosswalk is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_3, soc_lvl = "soc_4")
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_3 to SOC_1 crosswalk for indicators is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_3,
                                     soc_lvl = "soc_3", indicator = TRUE)
  expect_true(isco_3[, sum(value)] <= soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_3 to SOC_2 with brkdwn crosswalk is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_3_brkdwn, brkd_cols = "gender")
  expect_equal(isco_3_brkdwn[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(nchar(soc10)))])
  expect_equal(ncol(soc_estimate), ncol(isco_3_brkdwn) + 1)
})

test_that("ISCO_3 to SOC_1 with brkdwn  crosswalk for indicators is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_3_brkdwn,
                                     soc_lvl = "soc_3",
                                     indicator = TRUE,
                                     brkd_cols = "gender")
  expect_true(isco_3_brkdwn[, sum(value)] <= soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_1 to SOC_1 with brkdwn crosswalk is OK!", {
  soc_estimate <- isco_soc_crosswalk(isco_1_brkdwn,
                                     isco_lvl = 1,
                                     soc_lvl = "soc_1",
                                     brkd_cols = "gender")
  expect_equal(isco_1_brkdwn[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(nchar(soc10)))])
  expect_equal(ncol(soc_estimate), ncol(isco_1_brkdwn) + 1)
})
