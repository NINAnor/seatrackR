#' Check the version of the database
#' Checks the version of the database by querying the flyway_schema_history table. If the table does not exist, it returns 0.
#' @return Numeric version of the database, or 0 if the flyway_schema_history table does not exist.
#' @export
#' @concept general_db
check_db_version<-function(){
    version <- tryCatch({
        dplyr::tbl(con, dbplyr::in_schema("public", "flyway_schema_history"))%>%
            dplyr::mutate(version_n = as.numeric(version)) %>%summarise(max_val = max(version_n, na.rm = TRUE))%>%dplyr::pull(max_val)
    },
    error = function(e) {
      return(0)
    }
    )
    return(version)
}