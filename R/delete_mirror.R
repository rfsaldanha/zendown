#' Delete a deposit mirror
#'
#' This will delete all mirrored files stored locally.
#'
#' @param deposit_id numeric. The Zenodo deposit id.
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

#' Delete all mirrors
#'
#' This will delete all mirrors stored locally.
#'
#' @export
delete_all_mirrors <- function(){
  # Cache path
  cache_dir <- rappdirs::user_cache_dir(appname = "zendown")

  if(fs::dir_exists(path = cache_dir)){
    fs::dir_delete(path = cache_dir)
  }
}
