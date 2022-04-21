test_that("SOC groups are OK!", {
  soc_group_names <- paste0("soc_", c(1:4, "label"))
  expect_identical(names(soc_groups), soc_group_names)
  expect_true(is.data.table(soc_groups))
})
