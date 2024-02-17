#' yesterday
#'
#' A helper for specifying time stamps to the GovInfo API
#'
#' @return String. Represents the earliest possible UTC time for the previous day.
#' @export
#'
#' @examples
#' yesterday()
#'
yesterday <- function() {
  paste0(Sys.Date() - 1, "T00:00:00Z")
}

#' today
#'
#' A helper for specifying time stamps to the GovInfo API
#'
#' @return String. Represents the earliest possible UTC time for today's date.
#' @export
#'
#' @examples
#' today()
#'
today <- function() {
  paste0(Sys.Date(), "T00:00:00Z")
}

#' tomorrow
#'
#' A helper for specifying time stamps to the GovInfo API
#'
#' @return String. Represents the earliest possible UTC time for tomorrow's date.
#' @export
#'
#' @examples
#' tomorrow()
#'
tomorrow <- function() {
  paste0(Sys.Date() + 1, "T00:00:00Z")
}

#' next_req
#'
#' A callback for use with httr2::req_perform_iterative
#'
#'
next_req <- function(resp, req) {
  body <- httr2::resp_body_json(resp)
  next_url <- body$nextPage
  if (is.null(next_url)) {
    return(NULL)
  }
  httr2::request(next_url) |>
    httr2::req_headers(`X-Api-Key` = get_govinfo_key())
}
