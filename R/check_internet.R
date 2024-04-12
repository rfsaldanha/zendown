check_internet <- function(){
  if(!any(c(
    curl::has_internet(),
    RCurl::url.exists("https://zenodo.org/", timeout.ms = 5000)
  ))){
    return(FALSE)
  } else {
    return(TRUE)
  }
}
