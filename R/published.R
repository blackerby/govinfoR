published <-
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
        httr2::req_perform_iterative(next_req = next_req)

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
