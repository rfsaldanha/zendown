#' Get a list of files available at a Zenodo deposit
#'
#' @param deposit_id numeric. The Zenodo deposit id.
#'
#' @return a tibble.
#'
#' @examplesIf curl::has_internet() & RCurl::url.exists("https://zenodo.org/records/10959197", timeout.ms = 5000)
#' # https://zenodo.org/records/10959197
#' list_deposit(deposit_id = 10959197)
#'
#' @export
list_deposit <- function(deposit_id){
  # Assertions
  checkmate::assert_number(x = deposit_id)

  # Check internet
  if(!curl::has_internet()) cli::cli_abort("It appears that your local Internet connection is not working.")

  # Check Zenodo
  if(!RCurl::url.exists("https://zenodo.org/", timeout.ms = 5000)) stop("It appears that Zenodo is down.")

  # Base url
  base_url <- glue::glue("https://zenodo.org/api/deposit/depositions/{deposit_id}/files")

  # Request from API
  res <- httr2::request(base_url = base_url) |>
    httr2::req_retry() |>
    httr2::req_perform() |>
    httr2::resp_body_json() |>
    tibble::tibble() |>
    tidyr::unnest_wider(1) |>
    tidyr::unnest_wider(col = "links")

  return(res)
}
