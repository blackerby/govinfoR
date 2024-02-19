#' gpo_related()
#'
#' @param access_id GPO package id or granule id
#' @param collection Collection to search for relationships. Must be one of BILLS, BILLSTATUS,
#'    PLAW, FR, or CHRG.
#' @param granule_class A type of granule.
#' @param sub_granule_class A type of subgranule.
#'
#' @return A tibble.
#' @export
#'
#' @examplesIf govinfoR::has_govinfo_key()
#'
#' gpo_related("BILLS-116hr748enr")
#' gpo_related("BILLS-116hr748enr", collection = "BILLS")
#'
gpo_related <-
  function(access_id,
           collection = NULL,
           granule_class = NULL,
           sub_granule_class = NULL) {
    params <-
      list("granuleClass" = granule_class, "subGranuleClass" = sub_granule_class)

    req <- httr2::request(base_url()) |>
      httr2::req_url_path_append("related") |>
      httr2::req_url_path_append(access_id) |>
      httr2::req_url_path_append(collection) |>
      httr2::req_headers(`X-Api-Key` = get_govinfo_key()) |>
      httr2::req_url_query(!!!params)

    resp <- req |>
      httr2::req_perform()

    body <- httr2::resp_body_json(resp)

    if (is.null(collection)) {
      df <-
        tidyr::tibble(json = body$relationships) |> tidyr::unnest_wider(json) |>
        janitor::clean_names()
    } else {
      df <-
        tidyr::tibble(json = body$results) |> tidyr::unnest_wider(json) |>
        janitor::clean_names() |>
        dplyr::mutate(
          date_issued = as.Date(date_issued),
          bill_version = as.factor(bill_version),
          bill_version_label = as.factor(bill_version_label),
          last_modified = lubridate::ymd_hms(last_modified)
        )
    }
    df
  }
