#' Check People String
#'
#' This function checks if a given people string is valid by calling a database function.
#' It returns TRUE if the string is valid, and FALSE otherwise.
#'
#' @param people_string A string representing the people to be checked.
#' @return TRUE if the people string is valid, FALSE otherwise.
#'
#' @export
#' @concept metadata
checkPeople <- function(people_string) {
    result <- tryCatch(
        {
            res <- DBI::dbSendStatement(
                con,
                glue::glue_sql(
                    "
                    DO $$
                    BEGIN
                        PERFORM metadata.fn_check_people_string({people_string});
                    END;
                    $$;
                    ",
                    .con = con
                )
            )
            DBI::dbClearResult(res)
        },
        error = function(e) {
            e
        }
    )
    if (inherits(result, "error")) {
        msg <- conditionMessage(result)
        clipped_msg <- sub(
            ".*ERROR:\\s*(.*?)\\s*CONTEXT:.*",
            "\\1",
            msg
        )
        cat(sprintf("%s\n", clipped_msg))
        return(FALSE)
    }

    return(TRUE)
}
