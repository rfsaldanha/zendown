#' Check the MD5SUM of a downloaded file against the Zenodo MD5SUM informed value
#'
#' @param file character. The downloaded file path.
#' @param original_checksum character. The MD5SUM informed by Zenodo.
#'
#' @return logical. `TRUE` if the MD5SUM matches.
#'
check_md5sum <- function(file, original_checksum){
  file_md5sum <- tools::md5sum(files = file)
  if(file_md5sum == original_checksum){
    return(TRUE)
  } else {
    return(FALSE)
  }
}

