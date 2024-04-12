cache_dir <- function(cache_type = NULL){
  checkmate::assert_choice(x = cache_type, choices = c("temporary","persistent"), null.ok = TRUE)

  if(is.null(cache_type)){
    res <- Sys.getenv("zendown_cache_type")

    if(res == ""){
      c_dir <- tempdir()
    } else if(res == "temporary"){
      c_dir <- tempdir()
    } else if(res == "persistent"){
      c_dir <- rappdirs::user_cache_dir(appname = "zendown")
    } else {
      c_dir <- tempdir()
    }
  } else if(cache_type == "temporary"){
    c_dir <- tempdir()
  } else if(cache_type == "persistent"){
    c_dir <- rappdirs::user_cache_dir(appname = "zendown")
  }

  return(c_dir)
}