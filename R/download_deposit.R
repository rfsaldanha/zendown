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
    cli::cli_alert_warning("It appears that your local Internet connection is not working or Zenodo is down. No file was donwloaded. Try again later...")
    return(NULL)
  }

  # Download all files from deposit
  if(is.null(file_name)){

    # Isolate download link and file path
    task <- tibble::tibble(
      url = list_deposit$download,
      file_path = fs::path(dest, list_deposit$filename)
    )

    # Download
    res <- curl::multi_download(urls = task$url, destfiles = task$file_path, progress = !quiet)

    # Checksum files
    for(f in 1:nrow(list_deposit)){
      file_path <- fs::path(dest,list_deposit[[f,"filename"]])

      if(check_md5sum(file_path, list_deposit[[f,"checksum"]]) == FALSE){
        cli::cli_alert_warning("The file {list_deposit[[f,'filename']]} checksum is different from source. Try download again.")
      }
    }

    return(res)

  } else { # A specific file
    # Isolate download link and file path
    file_row <- list_deposit[which(list_deposit$filename==file_name),]
    url <- file_row$download
    file_path <- fs::path(dest,file_name)

    # Download
    res <- curl::curl_download(url = url, destfile = file_path, quiet = quiet)

    # Checksum files
    if(check_md5sum(file_path, file_row$checksum) == FALSE){
      cli::cli_alert_danger("The file {file_name} checksum is different from source. Try download again.")
    }

    return(res)
  }
}
