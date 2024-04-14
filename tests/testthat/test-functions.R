test_that("delete_mirror works with temporary cache", {
  testthat::skip_on_cran()

  res <- zen_file(deposit_id = 10959197, file_name = "iris.rds", cache_type = "temporary", clear_cache = TRUE, quiet = TRUE)

  delete_mirror(deposit_id = 10959197, cache_type = "temporary")

  cache_path <- cache_dir("temporary")
  mirror_path <- fs::path(cache_path, 10959197)

  expect_false(dir.exists(mirror_path))
})

test_that("delete_mirror works with persistent cache", {
  testthat::skip_on_cran()

  res <- zen_file(deposit_id = 10959197, file_name = "iris.rds", cache_type = "persistent", clear_cache = TRUE, quiet = TRUE)

  delete_mirror(deposit_id = 10959197, cache_type = "persistent")

  cache_path <- cache_dir("persistent")
  mirror_path <- fs::path(cache_path, 10959197)

  expect_false(dir.exists(mirror_path))
})

test_that("file_list works", {
  testthat::skip_on_cran()

  res <- list_deposit(deposit_id = 10959197)

  expect_true("tbl_df" %in% class(res))
})

test_that("download_deposit works with file list", {
  testthat::skip_on_cran()

  res <- list_deposit(deposit_id = 10959197)

  temp_dir <- tempdir()

  download_deposit(list_deposit = res, dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","iris.rds")))
})

test_that("download_deposit works with single file", {
  testthat::skip_on_cran()

  res <- list_deposit(deposit_id = 10959197)

  temp_dir <- tempdir()

  download_deposit(list_deposit = res, file_name = "iris.rds", dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","iris.rds")))
})

test_that("mirror_deposit works with temporary cache", {
  testthat::skip_on_cran()

  res <- mirror_deposit(deposit_id = 10959197, cache_type = "temporary", clear_cache = TRUE, quiet = TRUE)

  expect_true(dir.exists(res))
})

test_that("mirror_deposit works with persistent cache", {
  testthat::skip_on_cran()

  res <- mirror_deposit(deposit_id = 10959197, cache_type = "persistent", clear_cache = TRUE, quiet = TRUE)

  expect_true(dir.exists(res))
})

test_that("mirror_deposit works with single file", {
  testthat::skip_on_cran()

  res <- mirror_deposit(deposit_id = 10959197, file_name = "iris.rds", clear_cache = TRUE, quiet = TRUE)

  expect_true(dir.exists(res))
})

test_that("zen_file works", {
  testthat::skip_on_cran()

  res <- zen_file(deposit_id = 10959197, file_name = "iris.rds", clear_cache = TRUE, quiet = TRUE)

  expect_true(file.exists(res))
})

test_that("list_deposit without internet", {
  testthat::skip_on_cran()

  local_mocked_bindings(check_internet = function(...) FALSE)

  suppressMessages({
    res <- list_deposit(10959197)
  })

  expect_null(res)
})
