#' Use the "magic" file that comes with the package
#'
#' The \code{magic_load()} functon from \code{libmagic} can't take ZIP files
#' and the \code{magic.mgc} file that ships with the package is too large to
#' be shipped uncompressed. Using this function as the \code{magic_db}
#' parameter will copy and uncompress the database to a cache directory and
#' return the full path to the magic file. Subsequent calls will not have to
#' perform the decompression unless \code{force} is \code{TRUE} or the
#' cache directory has been cleared.
#'
#' @param refresh ensure the lastest copy of the pacakge "magic"
#'   database is used.
#' @note 'magic' files are highly coupled with the version of the \code{file}
#'   utility they were built with. This function is provided solely for the
#'   off chance that a macOS or Linux/UNIX system's \code{libmagic} library
#'   was not configured properly and cannot find the system 'magic' file.
#' @export
#' @examples
#' library(dplyr)
#'
#' system.file("extdata/img", package="wand") %>%
#'   list.files(full.names=TRUE) %>%
#'   incant(magic_wand_file()) %>%
#'   glimpse()
magic_wand_file <- function(refresh=FALSE) {

  cache <- rappdirs::user_cache_dir("wandr")

  if (!dir.exists(cache)) dir.create(cache, recursive=TRUE, showWarnings=FALSE)
  if (!dir.exists(cache)) return(NULL)

  if (lib_version() >= 528) vers <- "new" else vers <- "old"

  if (refresh | (!file.exists(file.path(rappdirs::user_cache_dir("wandr"), "magic.mgc")))) {
    unzip(system.file("extdata", "db", vers, "magic.mgc.zip", package="wand"),
                           exdir=cache, overwrite=TRUE)
  }

  file.path(rappdirs::user_cache_dir("wandr"), "magic.mgc")

}