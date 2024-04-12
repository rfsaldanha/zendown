#' Access a Zenodo deposit file
#'
#' Get the local path to a Zenodo deposit file. It not cached in a mirror yet, it will download the file to a deposit mirror cache locally.
#'
#' @param deposit_id numeric. The Zenodo deposit id.
#' @param file_name character. If `NULL`, all files from the file list. If a file name is specified, only this file will be downloaded.
#' @param clear_cache logical. If the mirror already exists, clear its content.
#' @param quiet logical. Show download info and progress bar.
#'
#' @return a string with the mirror file path.
#'
#' @examplesIf curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)
#' # https://zenodo.org/records/10959197
#' zen_file(10959197, "iris.rds")
#'
#' @export
zen_file <- function(deposit_id, file_name, clear_cache = FALSE, quiet = FALSE){
  mirror_path <- mirror_deposit(
    deposit_id = deposit_id,
    file_name = file_name,
    clear_cache = clear_cache,
    quiet = quiet
  )

  return(fs::path(mirror_path, file_name))
}
