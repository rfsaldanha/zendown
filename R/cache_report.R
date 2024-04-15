#' Cache report
#'
#' Print a report at the console with cache statistics
#'
#' @param cache_type character. Use `temporary` to a session temporary folder, `persistent` for a persistent cache folder or `NULL` to use the environment default. Check the section Cache Type for more details.
#' @param cache_dir character. User specified cache directory for persistent cache type.
#'
#' @returns No return value. The function prints a report on the console.
#' @export
#'
#' @examplesIf identical(tolower(Sys.getenv("NOT_CRAN")), "true")
#' mirror_deposit(deposit_id = 10959197)
#' cache_report()
#'
cache_report <- function(cache_type = NULL, cache_dir = NULL){

  # Cache dir
  c_dir <- cache_dir(cache_type,cache_dir)

  # Get info
  if(!fs::dir_exists(path = c_dir)){
    cli::cli_alert_warning("The cache directory was not created.")
    return(NULL)
  } else {
    res <- fs::dir_info(path = c_dir, type = "file", recurse = TRUE)

    if(nrow(res) == 0){
      cli::cli_alert_warning("The cache is empty.")
      return(NULL)
    } else {
      # Isolate deposit_id path
      res$deposit_id <- fs::path_rel(path = res$path, start = cache_dir(cache_type,cache_dir)) |>
        fs::path_dir()

      # Create a constant for count
      res$const <- 1

      # Sum file sizes
      res_agg <- stats::aggregate(res$size, list(res$deposit_id), FUN=sum)
      names(res_agg) <- c("deposit_id", "size")
      res_agg$size <-  fs::fs_bytes(res_agg$size)

      # Count number of files
      res_agg$files_n <- stats::aggregate(res$const, list(res$deposit_id), FUN=sum)$x

      # Creation time
      res_agg$creation_time <- stats::aggregate(res$birth_time, list(res$deposit_id), FUN=min)$x

      # Modification time
      res_agg$modification_time <- stats::aggregate(res$modification_time, list(res$deposit_id), FUN=max)$x

      # Access time
      res_agg$access_time <- stats::aggregate(res$access_time, list(res$deposit_id), FUN=max)$x

      # Report
      cli::cli_h1("Cache report")
      cli::cli_bullets(c(
        "*" = "Path: {c_dir}",
        "*" = "Cached deposits: {nrow(res_agg)}",
        "*" = "Total size: {sum(res_agg$size)}",
        "*" = "Files: {sum(res_agg$files_n)}"
      ))

      cli::cli_h1("Cached deposits")
      for(i in 1:nrow(res_agg)){
        cli::cli_h2("Zenodo id: {res_agg[i,'deposit_id']}")
        cli::cli_bullets(c(
          "*" = "Size: {res_agg[i,'size']}",
          "*" = "Files: {res_agg[i,'files_n']}",
          "*" = "Creation time: {format(res_agg[i,'creation_time'])}",
          "*" = "Modification time: {format(res_agg[i,'modification_time'])}",
          "*" = "Access time: {format(res_agg[i,'access_time'])}"
        ))
      }
    }
  }
}
