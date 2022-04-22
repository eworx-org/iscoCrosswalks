test_that("ISCO_3 to SOC_2 crosswalk is OK!", {
  isco_3 <- fread("data/isco_3_example.csv")
  soc_estimate <- isco_soc_crosswalk(isco_3)
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(nchar(soc10)))])
})

test_that("ISCO_3 to SOC_1 crosswalk is OK!", {
  isco_3 <- fread("data/isco_3_example.csv")
  soc_estimate <- isco_soc_crosswalk(isco_3, soc_lvl = "soc_1")
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_3 to SOC_3 crosswalk is OK!", {
  isco_3 <- fread("data/isco_3_example.csv")
  soc_estimate <- isco_soc_crosswalk(isco_3, soc_lvl = "soc_3")
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_3 to SOC_4 crosswalk is OK!", {
  isco_3 <- fread("data/isco_3_example.csv")
  soc_estimate <- isco_soc_crosswalk(isco_3, soc_lvl = "soc_4")
  expect_equal(isco_3[, sum(value)],
               soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})

test_that("ISCO_3 to SOC_1 crosswalk for indicators is OK!", {
  isco_3 <- fread("data/isco_3_example.csv")
  soc_estimate <- isco_soc_crosswalk(isco_3,
                                     soc_lvl = "soc_3", indicator = TRUE)
  expect_true(isco_3[, sum(value)] <= soc_estimate[, sum(value)])
  expect_true(soc_estimate[, all(!is.na(soc10))])
})
