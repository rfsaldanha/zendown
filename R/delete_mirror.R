#' Delete a deposit mirror
#'
#' This function will delete all mirrored files stored locally.
#'
#' @param deposit_id numeric. The Zenodo deposit id.
#'
#' @returns No return value. The function deletes mirrored on the system.
#'
#' @examplesIf curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)
#' # https://zenodo.org/records/10959197
#' file_path <- zen_file(10959197, "iris.rds")
#' print(file_path)
#' delete_mirror(10959197)
#' file.exists(file_path)
#'
#' @export
delete_mirror <- function(deposit_id){
  # Cache path
  cache_dir <- rappdirs::user_cache_dir(appname = "zendown")
  cache_path <- fs::path(cache_dir, deposit_id)

  if(fs::dir_exists(path = cache_path)){
    fs::dir_delete(path = cache_path)
  }
}

#' Delete all deposit mirrors
#'
#' This will delete all deposit mirrors stored locally.
#'
#' @returns No return value. The function deletes all deposits mirrored on the system.
#'
#' @examplesIf curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)
#' # https://zenodo.org/records/10959197
#' file_path <- zen_file(10959197, "iris.rds")
#' print(file_path)
#' delete_all_mirrors(10959197)
#' file.exists(file_path)
#'
#' @export
delete_all_mirrors <- function(){
  # Cache path
  cache_dir <- rappdirs::user_cache_dir(appname = "zendown")

  if(fs::dir_exists(path = cache_dir)){
    fs::dir_delete(path = cache_dir)
  }
}
