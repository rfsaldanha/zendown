#' Access a Zenodo deposit file
#'
#' Get the local path to a Zenodo deposit file. It not cached in a mirror yet, it will download the file to a deposit mirror cache locally.
#'
#' @param deposit_id numeric. The Zenodo deposit id.
#' @param file_name character. If `NULL`, all files from the file list. If a file name is specified, only this file will be downloaded.
#' @param cache_type character. Use `temporary` to a session temporary folder, `persistent` for a persistent cache folder or `NULL` to use the environment default. Check the section Cache Type for more details.
#' @param cache_dir character. User specified cache directory for persistent cache type.
#' @param clear_cache logical. If the mirror already exists, clear its content.
#' @param quiet logical. Show download info and progress bar.
#'
#' @section Cache type:
#'
#' The Zenodo mirror will be cached locally on a system folder. This folder can be temporary, being cleared when the R session is ended, or persistent across sections and reboots.
#'
#' If the `cache_type` argument is `NULL` (the default) the package will check first the environment variable `zendown_cache_type`. If set, the package will use its value. If not set, a temporary cache folder will be used as default.
#'
#' You can set an environment variable with `usethis::edit_r_environ()` and write as bellow for a persistent cache storage.
#'
#' `zendown_cache_type = "persistent"`
#'
#' After saving the file, remember to restart the session. With this setting, the cache will be persistent and stored at the directory given by `tools::R_user_dir("zendown", which = "cache")`
#'
#' You may also use a different folder for persistent storage by setting the `zendown_cache_dir` environment variable. For example:
#'
#' `zendown_cache_dir = C:\my_cache\`
#'
#' If you set the `cache_type` argument directly as `temporary` or `persistent`, it will override the environment setting.
#'
#' @return a string with the mirror file path.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # https://zenodo.org/records/10959197
#' zen_file_path <- zen_file(10959197, "iris.rds")
#' print(zen_file_path)
#' file.exists(zen_file_path)
#'
#' @export
zen_file <- function(deposit_id, file_name, cache_type = NULL, cache_dir = NULL, clear_cache = FALSE, quiet = FALSE){
  mirror_path <- mirror_deposit(
    deposit_id = deposit_id,
    file_name = file_name,
    cache_type = cache_type,
    cache_dir = cache_dir,
    clear_cache = clear_cache,
    quiet = quiet
  )

  return(fs::path(mirror_path, file_name))
}
