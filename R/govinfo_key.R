#' Check or Get GovInfo API Key
#'
#' Adapted, with gratitude, from Christopher Kenny's
#' [congress](https://github.com/christopherkenny/congress/blob/main/R/congress_key.R)
#' package
#'
#' @return logical if `has`, key if `get`
#' @export
#'
#' @name key
#'
#' @examples
#' has_govinfo_key()
has_govinfo_key <- function() {
  Sys.getenv('GOVINFO_KEY') != ''
}

#' @rdname key
#' @export
get_govinfo_key <- function() {
  key <- Sys.getenv('GOVINFO_KEY')

  key
}

#' Adds api.data.gov key to .Renviron
#'
#' @param key Character. API key to add.
#' @param overwrite Defaults to FALSE. Boolean. Should existing `GOVINFO_KEY` in .Renviron  be overwritten?
#' @param install Defaults to FALSE. Boolean. Should `key` be added to '~/.Renviron' file?
#'
#' @return key, invisibly
#' @export
#'
#' @examples
#' \dontrun{
#'   set_govinfo_key("DEMO_KEY")
#' }
set_govinfo_key <-
  function(key,
           overwrite = FALSE,
           install = FALSE) {
    if (missing(key)) {
      cli::cli_abort("Input {.arg key} is required.")
    }
    name <- 'GOVINFO_KEY'

    key <- list(key)
    names(key) <- name

    if (install) {
      r_env <- file.path(Sys.getenv("HOME"), ".Renviron")

      if (!file.exists(r_env)) {
        file.create(r_env)
      }

      lines <- readLines(r_env)
      newline <- paste0(name, " = ", key)

      already_exists <- stringr::str_detect(lines, paste0(name, " ="))

      if (any(exists)) {
        if (sum(exists) > 1) {
          cli::cli_abort(
            "Multiple entries in .Renviron found.\nEdit manually with {.fn usethis::edit_r_environ}."
          )
        }

        if (overwrite) {
          line[exists] <- newline
          writeLines(lines, r_env)
          do.call(Sys.setenv, key)
        } else {
          cli::cli_inform(
            "{.arg GOVINFO_KEY} already exists in .Renviron. \nEdit manually with {.fn usethis::edit_r_environ} or set {.code overwrite = TRUE}."
          )
        }
      } else {
        lines[length(lines) + 1] <- newline
        writeLines(lines, r_env)
        do.call(Sys.setenv, key)
      }
    } else {
      do.call(Sys.setenv, key)
    }

    invisible(key)
  }
