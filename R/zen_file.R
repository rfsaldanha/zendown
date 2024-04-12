#' Access a Zenodo deposit file
#'
#' Get the local path to a Zenodo deposit file. It not cached in a mirror yet, it will download the file to a deposit mirror cache locally.
#'
#' @param deposit_id numeric. The Zenodo deposit id.
#' @param file_name character. If `NULL`, all files from the file list. If a file name is specified, only this file will be downloaded.
#' @param cache_type character. If `NULL`, the package will check the enviroment variable `zendown_cache_type` setting and use it. If `zendown_cache_type` is not set, the function will default to a temporary cache. The argument can be set to `temporary` to store the cache in a temporary system folder and `persistent` to store the cache in a persistent system folder.
#' @param clear_cache logical. If the mirror already exists, clear its content.
#' @param quiet logical. Show download info and progress bar.
#'
#' @section Cache type:
#'
#' The Zenodo mirror will be stored locally on a system folder. This folder can be temporary, cleared when the R session is ended, or persistent across sections and reboots.
#'
#' If the `cache_type` argument is `NULL` the package will check the environment variable `zendown_cache_type`. If set, the package will use its value. If not set, a temporary cache folder will be used as default.
#'
#' You can set the environment variable with `Sys.setenv("zendown_cache_type" = "persistent")` or `Sys.setenv("zendown_cache_type" = "temporary")`. To unset this variable, use `Sys.unsetenv("zendown_cache_type")`.
#'
#' The `cache_type` argument can also be set directly as `temporary` or `persistent`.
#'
#' @return a string with the mirror file path.
#'
#' @examplesIf curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)
#' # https://zenodo.org/records/10959197
#' zen_file_path <- zen_file(10959197, "iris.rds")
#' file.exists(zen_file_path)
#'
#' @export
zen_file <- function(deposit_id, file_name, cache_type = NULL, clear_cache = FALSE, quiet = FALSE){
  mirror_path <- mirror_deposit(
    deposit_id = deposit_id,
    file_name = file_name,
    cache_type = cache_type,
    clear_cache = clear_cache,
    quiet = quiet
  )

  return(fs::path(mirror_path, file_name))
}
