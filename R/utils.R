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
