#' Retrieve documents based on official publication date.
#'
#' The following params correspond to those listed in the
#' [GovInfo](https://www.govinfo.gov/) API documentation, but the `offset` param is not
#' supported. GovInfo documentation indicates that it was to be deprecated in December, 2022, and
#' though it is still available through the API, the `offsetMark` parameter is supported instead.
#' Parameter descriptions are adapted from [GovInfo](https://www.govinfo.gov/) API documentation.
#'
#' @param start_date ISO8601 date and time formatted string (yyyy-MM-dd'T'HH:mm:ss'Z')
#'    Example: 2018-01-28T20:18:10Z
#' @param end_date ISO8601 date and time formatted string (yyyy-MM-dd'T'HH:mm:ss'Z')
#'    Example: 2018-01-28T20:18:10Z
#' @param page_size The number of records to return for a given request.
#' @param collection Filter by GPO collection.
#' @param congress Filter by Congress, e.g., 116, 117
#' @param doc_class Filter by collection-specific categories, which vary among collections.
#' @param modified_since Request only packages modified since a given date/time.
#'    ISO8601 date and time formatted string (yyyy-MM-dd'T'HH:mm:ss'Z')
#'    Example: 2018-01-28T20:18:10Z
#' @param bill_version Specific to the `BILLS` collection. Filter by bill text version code.
#' @param court_code `USCOURTS`collection specific.
#' @param court_type `USCOURTS` collection specific.
#' @param state Collection specific.
#' @param topic Collection specific.
#' @param nature_suit_code Collection specific.
#' @param nature_suit Collection specific.
#' @param offset_mark Indicates starting record for a given request.
#' @param is_glp Collection specific.
#'
#' @return A tibble
#' @export
#'
#' @examplesIf govinfoR::has_govinfo_key()
#'
#' gpo_published(
#'   start_date = "2024-01-01",
#'   end_date = "2024-01-03",
#'   collection = c("BILLS")
#' )
#'
gpo_published <-
  function(start_date,
           end_date = NULL,
           page_size = 10,
           collection,
           congress = NULL,
           doc_class = NULL,
           bill_version = NULL,
           modified_since = NULL,
           court_code = NULL,
           court_type = NULL,
           state = NULL,
           topic = NULL,
           nature_suit_code = NULL,
           nature_suit = NULL,
           offset_mark = "*",
           is_glp = NULL)
  {
    params <- list(
      "pageSize" = page_size,
      "collection" = collection,
      "congress" = congress,
      "docClass" = doc_class,
      "billVersion" = bill_version,
      "modifiedSince" = modified_since,
      "courtCode" = court_code,
      "courtType" = court_type,
      "state" = state,
      "topic" = topic,
      "natureSuitCode" = nature_suit_code,
      "natureSuit" = nature_suit,
      "offsetMark" = offset_mark,
      "isGLP" = is_glp
    )

    req <- httr2::request(base_url()) |>
      httr2::req_url_path_append("published") |>
      httr2::req_url_path_append(start_date) |>
      httr2::req_url_path_append(end_date) |>
      httr2::req_headers(`X-Api-Key` = get_govinfo_key()) |>
      httr2::req_url_query(!!!params, .multi = "comma")

    resp <- req |>
      httr2::req_perform()

    body <- httr2::resp_body_json(resp)
    df <-
      first_n <-
      tidyr::tibble(json = body$packages) |> tidyr::unnest_wider(json)

    if (!is.null(body$nextPage)) {
      resps <- httr2::request(body$nextPage) |>
        httr2::req_headers(`X-Api-Key` = get_govinfo_key()) |>
        httr2::req_perform_iterative(next_req = next_req, max_reqs = Inf)

      remaining_n <- resps |> httr2::resps_data(function(resp) {
        body <- httr2::resp_body_json(resp)
        tidyr::tibble(json = body$packages) |>
          tidyr::unnest_wider(json)
      })

      df <- dplyr::bind_rows(first_n, remaining_n)
    }

    df |>
      janitor::clean_names() |>
      dplyr::mutate(
        doc_class = as.factor(doc_class),
        congress = as.integer(congress),
        last_modified = lubridate::ymd_hms(last_modified),
        date_issued = as.Date(date_issued)
      )
  }
