test_that("Get SOC code is OK!", {
  data <- fread("data/soc_3_example.csv")
  expect_error(soc_code_data <- get_soc_code(data, lvl = "soc_3"), NA)
  expect_true(soc_code_data[, !any(is.na(code))], NA)
})
