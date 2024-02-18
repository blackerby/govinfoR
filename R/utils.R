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
#' @param resp Callback response.
#' @param req Callback response.
next_req <- function(resp, req) {
  body <- httr2::resp_body_json(resp)
  next_url <- body$nextPage
  if (is.null(next_url)) {
    return(NULL)
  }
  httr2::request(next_url) |>
    httr2::req_headers(`X-Api-Key` = get_govinfo_key())
}

# Addressing global variable note from running `devtools::check()`
# https://community.rstudio.com/t/how-to-solve-no-visible-binding-for-global-variable-note/28887
utils::globalVariables(
  c(
    "json",
    "date_issued",
    "download",
    "granule_class",
    "sub_granule_class",
    "doc_class",
    "last_modified",
    "granule_date",
    "otherIdentifier",
    "date_issued",
    "bill_version",
    "bill_version_label",
    "collection_code"
  )
)
