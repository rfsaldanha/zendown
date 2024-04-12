check_md5sum <- function(file, original_checksum){
  file_md5sum <- tools::md5sum(files = file)
  if(file_md5sum == original_checksum){
    return(TRUE)
  } else {
    return(FALSE)
  }
}

