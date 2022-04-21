dat <- data.table::fread("data/isco_3_example.csv")
test_that("Match job title to ISCO code is OK!", {
  expect_error(dat_codes <- get_isco_code(dat, lvl = 3), NA)
  expect_true(dat_codes[, all(nchar(code) == 3)])
  expect_equal(dat_codes[, class(code)], "character")
})
