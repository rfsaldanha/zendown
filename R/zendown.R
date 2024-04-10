#' Download files from a Zenodo deposition list of files
#'
#' @param file_list data.frame or tibble. Obtained with `file_list`.
#' @param file_name character. If `NULL`, all files from the file list. If a file name is specified, only this file will be downloaded.
#' @param dest character. Destination folder.
#' @param quiet logical. Show download info and progress bar.
#'
#' @return the downloaded file(s).
#' @export
zendown <- function(file_list, file_name = NULL, dest, quiet = FALSE){
  # Assertions
  checkmate::assert_data_frame(file_list)
  checkmate::assert_choice(x = file_name, null.ok = TRUE, choices = file_list$filename)
  checkmate::assert_logical(x = quiet)

  # Check internet
  if(!curl::has_internet()) stop("It appears that your local Internet connection is not working.")

  # Check Zenodo
  if(!RCurl::url.exists("https://zenodo.org/", timeout.ms = 5000)) stop("It appears that Zenodo is down.")

  if(is.null(file_name)){
    for(f in 1:nrow(file_list)){
      url <- file_list[["links"]][[f]]$download

      file_path <- file.path(dest,file_list[['filename']][[f]])
      checkmate::assert_path_for_output(x = file_path, overwrite = TRUE)

      utils::download.file(url = url, destfile = file_path,
                    quiet = quiet, mode = "wb")
    }
  } else {
    file_row <- file_list[which(file_list$filename==file_name),]
    url <- file_row[["links"]][[1]]$download

    file_path <- file.path(dest,file_name)
    checkmate::assert_path_for_output(x = file_path, overwrite = TRUE)

    utils::download.file(url = url, destfile = file_path,
                  quiet = quiet, mode = "wb")
  }
}
