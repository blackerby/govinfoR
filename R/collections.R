#' Retrieve GPO collections data
#'
#' The following params correspond to those listed in the [GovInfo](https://www.govinfo.gov/) API documentation],
#' but the `offset` param is not supported. GovInfo documentation indicates that it was to be deprecated in December,
#' 2022, and though it is still available through the API, the `offsetMark` parameter is supported instead. Parameter
#' descriptions are adapted from [GovInfo](https://www.govinfo.gov/) API documentation.
#'
#' Calling `gpo_collections()` without specifying a collection returns metadata about all collections.
#'
#' @param collection The collectionCode that you want to retrieve (e.g. BILLS, CREC, FR, PLAW, USCOURTS)
#' @param start_date ISO8601 date and time formatted string (yyyy-MM-dd'T'HH:mm:ss'Z') Example: 2018-01-28T20:18:10Z
#' @param end_date ISO8601 date and time formatted string (yyyy-MM-dd'T'HH:mm:ss'Z') Example: 2018-01-28T20:18:10Z
#' @param page_size The number of records to return for a given request.
#' @param congress Filter by Congress, e.g., 116, 117
#' @param doc_class Filter by collection-specific categories, which vary among collections.
#' @param bill_version Specific to the `BILLS` collection. Filter by bill text version code.
#' @param court_code `USCOURTS`collection specific.
#' @param court_type `USCOURTS` collection specific.
#' @param state Collection specific.
#' @param topic Collection specific.
#' @param is_glp Collection specific.
#' @param nature_suit_code Collection specific.
#' @param nature_suit Collection specific.
#' @param offset_mark Indicates starting record for a given request.
#'
#' @return A tibble
#' @export
#'
#' @examplesIf govinfoR::has_govinfo_key()
#'
#' gpo_collections(collection = "BILLS", start_date = "2024-02-17T00:00:00Z")
#' gpo_collections()
#'
gpo_collections <-
  function(collection = NULL,
           start_date = NULL,
           end_date = NULL,
           page_size = 10,
           doc_class = NULL,
           congress = NULL,
           bill_version = NULL,
           court_code = NULL,
           court_type = NULL,
           state = NULL,
           topic = NULL,
           is_glp = NULL,
           nature_suit_code = NULL,
           nature_suit = NULL,
           offset_mark = "*")
  {
    params <- list(
      "pageSize" = page_size,
      "docClass" = doc_class,
      "congress" = congress,
      "billVersion" = bill_version,
      "courtCode" = court_code,
      "courtType" = court_type,
      "state" = state,
      "topic" = topic,
      "isGLP" = is_glp,
      "natureSuitCode" = nature_suit_code,
      "natureSuit" = nature_suit,
      "offsetMark" = offset_mark
    )
    req <- httr2::request(base_url()) |>
      httr2::req_url_path_append("collections") |>
      httr2::req_url_path_append(collection) |>
      httr2::req_url_path_append(start_date) |>
      httr2::req_url_path_append(end_date) |>
      httr2::req_headers(`X-Api-Key` = get_govinfo_key()) |>
      httr2::req_url_query(!!!params)

    resp <- req |>
      httr2::req_perform()

    body <- httr2::resp_body_json(resp)

    if (!is.null(body$nextPage)) {
      first_n <- body$packages

      resps <- httr2::request(body$nextPage) |>
        httr2::req_headers(`X-Api-Key` = get_govinfo_key()) |>
        httr2::req_perform_iterative(next_req = next_req, max_reqs = Inf)

      remaining_n <- resps |> httr2::resps_data(function(resp) {
        body <- httr2::resp_body_json(resp)
        tidyr::tibble(json = body$packages) |>
          tidyr::unnest_wider(json)
      })

      df <- dplyr::bind_rows(first_n, remaining_n)
    } else {
      df <- tidyr::tibble(json = body$collections) |> tidyr::unnest_wider(json)
    }

    if (!is.null(collection)) {
      df |>
        janitor::clean_names() |>
        dplyr::mutate(
          last_modified = lubridate::ymd_hms(last_modified),
          doc_class = as.factor(doc_class),
          congress = as.integer(congress),
          date_issued = as.Date(date_issued)
        )
    } else {
      df |>
        janitor::clean_names()
    }
  }
