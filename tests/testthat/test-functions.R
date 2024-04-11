test_that("file_list works", {
  skip_on_cran()

  res <- list_deposit(deposit_id = 10959197)

  expect_true("tbl_df" %in% class(res))
})

test_that("download_deposit works with file list", {
  skip_on_cran()

  res <- list_deposit(deposit_id = 10959197)

  temp_dir <- tempdir()

  download_deposit(list_deposit = res, dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","iris.rds")))
})

test_that("download_deposit works with single file", {
  skip_on_cran()

  res <- list_deposit(deposit_id = 10959197)

  temp_dir <- tempdir()

  download_deposit(list_deposit = res, file_name = "iris.rds", dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","iris.rds")))
})

test_that("mirror_deposit works", {
  skip_on_cran()

  res <- mirror_deposit(deposit_id = 10959197)

  expect_true(dir.exists(res))
})

test_that("mirror_deposit works with single file", {
  skip_on_cran()

  res <- mirror_deposit(deposit_id = 10959197, file_name = "iris.rds")

  expect_true(dir.exists(res))
})

test_that("zen_file works", {
  skip_on_cran()

  res <- zen_file(deposit_id = 10959197, file_name = "iris.rds")

  expect_true(file.exists(res))
})

test_that("delete_mirror works", {
  skip_on_cran()

  delete_mirror(deposit_id = 10950327)

  cache_dir <- rappdirs::user_cache_dir(appname = "zendown")
  cache_path <- fs::path(cache_dir, 10950327)

  expect_false(dir.exists(cache_path))
})

test_that("delete_all_mirrors works", {
  skip_on_cran()

  delete_all_mirrors()

  cache_dir <- rappdirs::user_cache_dir(appname = "zendown")

  expect_false(dir.exists(cache_dir))
})
