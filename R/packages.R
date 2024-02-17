#' Given a GPO package id, return summary metadata for that package.
#'
#' @param package_id String. The Package Id. Ex: CREC-2018-01-04
#'
#' @return A single row tibble.
#' @export
#'
#' @examples
#' set_govinfo_key("DEMO_KEY")
#' package_summary("CREC-2018-01-04")
package_summary <- function(package_id) {
  req <- httr2::request(base_url()) |>
    httr2::req_url_path_append("packages") |>
    httr2::req_url_path_append(package_id) |>
    httr2::req_url_path_append("summary") |>
    httr2::req_headers(`X-Api-Key` = get_govinfo_key())

  resp <- req |>
    httr2::req_perform()

  httr2::resp_body_json(resp) |>
    t() |>
    dplyr::as_tibble() |>
    tidyr::unnest_wider(download) |>
    tidyr::unnest_wider(otherIdentifier) |>
    dplyr::mutate_all(unlist) |>
    janitor::clean_names()
}

#' Given a GPO package id, get a list of granules associated with that package.
#'
#' @param package_id String. The Package Id. Ex: CREC-2018-01-04
#' @param page_size Integer. The number of records to retrieve per request. Defaults to 20.
#' @param offset_mark Indicates starting record for a given request.
#' @param md5 String. md5 hash value of the html content file - can be used to identify changes
#'    in individual granules for the HOB and CRI collections.
#' @param granule_class String. Filter the results by overarching collection-specific categories.
#'    Varies by collection.
#'
#' @return A tibble
#' @export
#'
#' @examples
#' set_govinfo_key("DEMO_KEY")
#' package_granules("CREC-2018-01-04")
package_granules <-
  function(package_id,
           page_size = 20,
           offset_mark = "*",
           md5 = NULL,
           granule_class = NULL) {
    params <- list(
      "pageSize" = page_size,
      "md5" = md5,
      "granuleClass" = granule_class,
      "offsetMark" = offset_mark
    )

    req <- httr2::request(base_url()) |>
      httr2::req_url_path_append("packages") |>
      httr2::req_url_path_append(package_id) |>
      httr2::req_url_path_append("granules") |>
      httr2::req_headers(`X-Api-Key` = get_govinfo_key()) |>
      httr2::req_url_query(!!!params)

    resp <- req |>
      httr2::req_perform()

    body <- httr2::resp_body_json(resp)
    df <- first_n <- body$granules

    if (!is.null(body$nextPage)) {
      resps <- httr2::request(body$nextPage) |>
        httr2::req_headers(`X-Api-Key` = get_govinfo_key()) |>
        httr2::req_perform_iterative(next_req = next_req)

      remaining_n <- resps |> httr2::resps_data(function(resp) {
        body <- httr2::resp_body_json(resp)
        tidyr::tibble(json = body$granules) |>
          tidyr::unnest_wider(json)
      })

      df <- dplyr::bind_rows(first_n, remaining_n)
    }

    df |>
      janitor::clean_names() |>
      dplyr::mutate(granule_class = as.factor(granule_class))
  }

package_granules_summary <- function() {

}
