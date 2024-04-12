test_that("delete_mirror works", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- zen_file(deposit_id = 10959197, file_name = "iris.rds", clear_cache = TRUE, quiet = TRUE)

  delete_mirror(deposit_id = 10959197)

  cache_dir <- rappdirs::user_cache_dir(appname = "zendown")
  cache_path <- fs::path(cache_dir, 10959197)

  expect_false(dir.exists(cache_path))
})

test_that("delete_all_mirrors works", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- zen_file(deposit_id = 10959197, file_name = "iris.rds", clear_cache = TRUE, quiet = TRUE)

  delete_all_mirrors()

  cache_dir <- rappdirs::user_cache_dir(appname = "zendown")

  expect_false(dir.exists(cache_dir))
})

test_that("file_list works", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- list_deposit(deposit_id = 10959197)

  expect_true("tbl_df" %in% class(res))
})

test_that("download_deposit works with file list", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- list_deposit(deposit_id = 10959197)

  temp_dir <- tempdir()

  download_deposit(list_deposit = res, dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","iris.rds")))
})

test_that("download_deposit works with single file", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- list_deposit(deposit_id = 10959197)

  temp_dir <- tempdir()

  download_deposit(list_deposit = res, file_name = "iris.rds", dest = temp_dir, quiet = TRUE)

  expect_true(file.exists(paste0(tempdir(),"/","iris.rds")))
})

test_that("mirror_deposit works", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- mirror_deposit(deposit_id = 10959197, clear_cache = TRUE, quiet = TRUE)

  expect_true(dir.exists(res))
})

test_that("mirror_deposit works with single file", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- mirror_deposit(deposit_id = 10959197, file_name = "iris.rds", clear_cache = TRUE, quiet = TRUE)

  expect_true(dir.exists(res))
})

test_that("zen_file works", {
  skip_if(!(curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)))

  res <- zen_file(deposit_id = 10959197, file_name = "iris.rds", clear_cache = TRUE, quiet = TRUE)

  expect_true(file.exists(res))
})


