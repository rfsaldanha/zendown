check_internet <- function(){
  if(!any(c(
    curl::has_internet(),
    RCurl::url.exists("https://zenodo.org/", timeout.ms = 5000)
  ))){
    cli::cli_alert("It appears that your local Internet connection is not working.")
    return(FALSE)
  } else {
    return(TRUE)
  }
}
