cache_dir <- function(cache_type = NULL, cache_dir = NULL){
  # Assertion
  checkmate::assert_choice(x = cache_type, choices = c("temporary","persistent"), null.ok = TRUE)

  # Default folders
  temporary_cache_dir <- fs::path_temp("zendown")
  persistent_cache_dir <- tools::R_user_dir("zendown", which = "cache")

  # If cache_type is NULL, check environment values
  if(is.null(cache_type)){
    res_type <- Sys.getenv("zendown_cache_type")
    res_dir <- Sys.getenv("zendown_cache_dir")

    if(res_type == ""){
      c_dir <- temporary_cache_dir
    } else if(res_type == "temporary"){
      c_dir <- temporary_cache_dir
    } else if(res_type == "persistent"){
      if(res_dir == ""){
        c_dir <- persistent_cache_dir
      } else {
        c_dir = res_dir
      }

    } else {
      cli::cli_abort("The zendown_cache_type key '{zendown_cache_type}' is not recognized. You may set as 'temporary' or 'persistent'")
    }
  } else if(cache_type == "temporary"){
    c_dir <- temporary_cache_dir
  } else if(cache_type == "persistent"){
    if(is.null(cache_dir)){
      c_dir <- persistent_cache_dir
    } else {
      c_dir = cache_dir
    }
  }

  return(c_dir)
}
