#' Download files from a Zenodo deposit
#'
#' @param list_deposit data.frame or tibble. Obtained with [list_deposit].
#' @param file_name character. If `NULL`, all files from the file list. If a file name is specified, only this file will be downloaded.
#' @param dest character. Destination folder.
#' @param quiet logical. Show download info and progress bar.
#'
#' @returns No return value. The function downloads files to the specified destination.
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' res <- list_deposit(deposit_id = 10959197)
#' temp_dir <- tempdir()
#' download_deposit(list_deposit = res, dest = temp_dir, quiet = FALSE)
#' file.exists(file.path(temp_dir, "iris.rds"))
#' file.exists(file.path(temp_dir, "mtcars.rds"))
#'
#' @export
download_deposit <- function(list_deposit, file_name = NULL, dest, quiet = FALSE){
  # Assertions
  checkmate::assert_data_frame(list_deposit)
  checkmate::assert_choice(x = file_name, null.ok = TRUE, choices = list_deposit$filename)
  checkmate::assert_logical(x = quiet)

  # Check internet and Zenodo access
  if(check_internet() == FALSE){
    cli::cli_alert("It appears that your local Internet connection is not working.")
    return(NULL)
  }

  # All files from deposit
  if(is.null(file_name)){
    for(f in 1:nrow(list_deposit)){
      url <- list_deposit[[f,"download"]]

      file_path <- fs::path(dest,list_deposit[[f,"filename"]])
      checkmate::assert_path_for_output(x = file_path, overwrite = TRUE)

      utils::download.file(url = url, destfile = file_path,
                    quiet = quiet, mode = "wb")

      if(check_md5sum(file_path, list_deposit[[f,"checksum"]]) == FALSE){
        cli::cli_abort("The file {list_deposit[[f,'filename']]} checksum is different from source. Try download again.")
      }
    }
  } else { # A specific file
    file_row <- list_deposit[which(list_deposit$filename==file_name),]
    url <- file_row$download

    file_path <- fs::path(dest,file_name)
    checkmate::assert_path_for_output(x = file_path, overwrite = TRUE)

    utils::download.file(url = url, destfile = file_path,
                  quiet = quiet, mode = "wb")

    if(check_md5sum(file_path, file_row$checksum) == FALSE){
      cli::cli_alert_danger("The file {file_name} checksum is different from source. Try download again.")
    }
  }
}
