#' Delete a deposit mirror
#'
#' This function will delete all mirrored files stored locally.
#'
#' @param deposit_id numeric. The Zenodo deposit id.
#' @param cache_type character. If `NULL`, the package will check the enviroment variable `zendown_cache_type` setting and use it. If `zendown_cache_type` is not set, the function will default to a temporary cache. The argument can be set to `temporary` to store the cache in a temporary system folder and `persistent` to store the cache in a persistent system folder.
#'
#' @returns No return value. The function deletes mirrored on the system.
#'
#' @examplesIf curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)
#' # https://zenodo.org/records/10959197
#' file_path <- zen_file(10959197, "iris.rds")
#' print(file_path)
#' file.exists(file_path)
#' delete_mirror(10959197)
#' file.exists(file_path)
#'
#' @export
delete_mirror <- function(deposit_id, cache_type = NULL){
  # Cache path
  cache_path <- fs::path(cache_dir(cache_type), deposit_id)

  if(fs::dir_exists(path = cache_path)){
    fs::dir_delete(path = cache_path)
  }
}
