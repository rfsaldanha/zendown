#' Mirror a Zenodo deposit locally
#'
#' Mirror an entire Zenodo deposit or a specific file locally. The mirror is a folder with the deposit files created at the cache folder of the operating system.
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
#' @return a string with the mirror path.
#'
#' @examplesIf curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)
#' # https://zenodo.org/records/10959197
#' mirror_path <- mirror_deposit(deposit_id = 10959197)
#' file.exists(file.path(mirror_path, "iris.rds"))
#' file.exists(file.path(mirror_path, "mtcars.rds"))
#'
#' @export
#'
mirror_deposit <- function(deposit_id, file_name = NULL, cache_type = NULL, clear_cache = FALSE, quiet = FALSE){
  # Assertions
  checkmate::assert_number(x = deposit_id)
  checkmate::assert_logical(x = clear_cache)
  checkmate::assert_logical(x = quiet)

  # Cache path
  cache_path <- fs::path(cache_dir(cache_type), deposit_id)

  # Clear mirror
  if(clear_cache & fs::dir_exists(cache_path)){
    if(is.null(file_name)){
      fs::dir_delete(cache_path)
    } else if(!is.null(file_name)){
      fs::file_delete(fs::path(cache_path,file_name))
    }
  }

  # Create mirror for deposit
  if(!fs::dir_exists(cache_path)){
    fs::dir_create(cache_path)
  }

  # Download deposit files to mirror if not present
  if(!is.null(file_name)){ # Single file
    file_path <- fs::path(cache_path, file_name)
    if(!fs::file_exists(file_path)){
      deposit_file_list <- list_deposit(deposit_id = deposit_id)
      checkmate::assert_choice(x = file_name, null.ok = TRUE, choices = deposit_file_list$filename)

      download_deposit(
        list_deposit = deposit_file_list,
        file_name = file_name,
        dest = cache_path,
        quiet = quiet
      )
    }
  } else if(is.null(file_name)){ # All deposit
    deposit_file_list <- list_deposit(deposit_id = deposit_id)

    for(f in deposit_file_list$filename){
      checkmate::assert_choice(x = f, null.ok = TRUE, choices = deposit_file_list$filename)
      file_path <- fs::path(cache_path, f)

      if(!fs::file_exists(file_path)){
        download_deposit(
          list_deposit = deposit_file_list,
          file_name = f,
          dest = cache_path,
          quiet = quiet
        )
      }
    }
  }

  # Load file
  return(cache_path)
}



