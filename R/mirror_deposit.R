#' Mirror a Zenodo deposit locally
#'
#' Mirror an entire Zenodo deposit or a specific file locally. The mirror is a folder with the deposit files created at the cache folder of the operating system.
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
#' @return a string with the mirror path.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' # https://zenodo.org/records/10959197
#' mirror_path <- mirror_deposit(deposit_id = 10959197)
#' file.exists(file.path(mirror_path, "iris.rds"))
#' file.exists(file.path(mirror_path, "mtcars.rds"))
#'
#' @export
#'
mirror_deposit <- function(deposit_id, file_name = NULL, cache_dir = NULL, cache_type = NULL, clear_cache = FALSE, quiet = FALSE){
  # Assertions
  checkmate::assert_number(x = deposit_id)
  checkmate::assert_logical(x = clear_cache)
  checkmate::assert_logical(x = quiet)

  # Cache path
  cache_path <- fs::path(cache_dir(cache_type, cache_dir), deposit_id)

  # Clear mirror
  if(clear_cache & fs::dir_exists(cache_path)){
    if(is.null(file_name)){
      fs::dir_delete(cache_path)
    } else if(!is.null(file_name) & fs::file_exists(fs::path(cache_path,file_name))){
      fs::file_delete(fs::path(cache_path,file_name))
    }
  }

  # Create mirror for deposit
  if(!fs::dir_exists(cache_path)){
    fs::dir_create(cache_path)
  }

  # Download
  if(!is.null(file_name)){ # Single file
    # File path
    file_path <- fs::path(cache_path, file_name)

    # Download single file to mirror if not cached
    if(!fs::file_exists(file_path)){

      # Check internet and Zenodo access
      if(check_internet() == FALSE){
        cli::cli_alert_warning("It appears that your local Internet connection is not working or Zenodo is down. Try again later...")
        return(NULL)
      }

      # Get file list
      deposit_file_list <- list_deposit(deposit_id = deposit_id)

      # Assert if the file exists on Zenodo
      checkmate::assert_choice(x = file_name, null.ok = TRUE, choices = deposit_file_list$filename)

      # Download file
      download_deposit(
        list_deposit = deposit_file_list,
        file_name = file_name,
        dest = cache_path,
        quiet = quiet
      )
    }
  } else if(is.null(file_name)){ # All deposit
    # Check internet and Zenodo access
    if(check_internet() == FALSE){
      cli::cli_alert_warning("It appears that your local Internet connection is not working or Zenodo is down. Try again later...")
      return(NULL)
    }

    # Get file list
    deposit_file_list <- list_deposit(deposit_id = deposit_id)

    # Check which files needs to be downloaded
    cached_files <- list.files(path = cache_path)
    deposit_file_list <- deposit_file_list[which(!deposit_file_list$filename %in% cached_files),]

    # Download files
    if(nrow(deposit_file_list) > 0){
      download_deposit(
        list_deposit = deposit_file_list,
        dest = cache_path,
        quiet = quiet
      )
    }
  }

  # Load file
  return(cache_path)
}



