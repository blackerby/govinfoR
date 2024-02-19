#' Given a GPO package id, return summary metadata for that package.
#'
#' @param package_id String. The Package Id. Ex: CREC-2018-01-04
#'
#' @return A single row tibble.
#' @export
#'
#' @examplesIf govinfoR::has_govinfo_key()
#'
#' gpo_package_summary("CREC-2018-01-04")
#'
gpo_package_summary <- function(package_id) {
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
#' The `offset` param provide by the API is not supported. GovInfo documentation indicates that it was to
#' be deprecated in December, 2022, and though it is still available through the API, the `offsetMark` parameter
#' is supported instead. Parameter descriptions are adapted from
#' [GovInfo](https://www.govinfo.gov/) API documentation.
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
#' @examplesIf govinfoR::has_govinfo_key()
#'
#' gpo_package_granules("CREC-2018-01-04")
#'
gpo_package_granules <-
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
        httr2::req_perform_iterative(next_req = next_req, max_reqs = Inf)

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

#' Given a package id and a granule id, return a metadata summary for the granule.
#'
#' @param package_id String. The Package Id. Ex: CREC-2018-01-04
#' @param granule_id String. The granule ID, e.g. CREC-2018-01-04-pt1-PgD7-2
#'
#' @return A single row tibble
#' @export
#'
#' @examplesIf govinfoR::has_govinfo_key()
#'
#' gpo_package_granules_summary("CREC-2018-01-04", "CREC-2018-01-04-pt1-PgD7-2")
#'
gpo_package_granules_summary <- function(package_id, granule_id) {
  req <- httr2::request(base_url()) |>
    httr2::req_url_path_append("packages") |>
    httr2::req_url_path_append(package_id) |>
    httr2::req_url_path_append("granules") |>
    httr2::req_url_path_append(granule_id) |>
    httr2::req_url_path_append("summary") |>
    httr2::req_headers(`X-Api-Key` = get_govinfo_key())

  resp <- req |>
    httr2::req_perform()

  httr2::resp_body_json(resp) |>
    t() |>
    dplyr::as_tibble() |>
    tidyr::unnest_wider(download) |>
    dplyr::mutate_all(unlist) |>
    janitor::clean_names() |>
    dplyr::mutate(
      collection_code = as.factor(collection_code),
      granule_class = as.factor(granule_class),
      sub_granule_class = as.factor(sub_granule_class),
      doc_class = as.factor(doc_class),
      last_modified = lubridate::ymd_hms(last_modified),
      granule_date = as.Date(granule_date)
    )
}
