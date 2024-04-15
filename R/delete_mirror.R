#' Delete a deposit mirror
#'
#' This function will delete all mirrored files stored locally.
#'
#' @param deposit_id numeric. The Zenodo deposit id.
#' @param cache_type character. Use `temporary` to a session temporary folder, `persistent` for a persistent cache folder or `NULL` to use the environment default. Check the section Cache Type for more details.
#' @param cache_dir character. User specified cache directory for persistent cache type.
#'
#' @returns No return value. The function deletes mirrored on the system.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # https://zenodo.org/records/10959197
#' file_path <- zen_file(10959197, "iris.rds")
#' print(file_path)
#' file.exists(file_path)
#' delete_mirror(10959197)
#' file.exists(file_path)
#'
#' @export
delete_mirror <- function(deposit_id, cache_type = NULL, cache_dir = NULL){
  # Cache path
  cache_path <- fs::path(cache_dir(cache_type,cache_dir), deposit_id)

  if(fs::dir_exists(path = cache_path)){
    fs::dir_delete(path = cache_path)
    cli::cli_alert_info("The cache of deposit {deposit_id} was deleted")
  } else {
    cli::cli_alert_warning("The cache of deposit {deposit_id} does not exist.")
  }
}
