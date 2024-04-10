test_that("file_list works", {
  skip_on_cran()

  res <- file_list(deposit_id = 10950327)

  expect_true("tbl_df" %in% class(res))
})

test_that("zendown works with file list", {
  skip_on_cran()

  res <- file_list(deposit_id = 10950327)

  temp_dir <- tempdir()

  zendown(file_list = res, dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","indi_0002_regsaude_res_year.parquet")))
})

test_that("zendown works with single file", {
  skip_on_cran()

  res <- file_list(deposit_id = 10950327)

  temp_dir <- tempdir()

  zendown(file_list = res, file_name = "indi_0002_regsaude_res_year.parquet", dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","indi_0002_regsaude_res_year.parquet")))
})
