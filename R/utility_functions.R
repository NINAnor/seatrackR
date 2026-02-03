#' Convert an R value to its corresponding database representation
#'
#' This function takes an R value and converts it to its corresponding database representation.
#' It handles different data types such as Date, NA, character, and others.
#' @param r_value An R value to be converted.
#' @param force_type An optional string specifying the database type to force for NULL values.
#' @return A string representing the database value.
#' @export
#' @concept db_utility
R_value_to_db_value <- function(r_value, force_type = "") {
    if (is.na(r_value)) {
        if (force_type != "") {
            db_value <- glue::glue("NULL::{force_type}")
        } else {
            db_value <- "NULL"
        }
    } else if ("Date" %in% class(r_value)) {
        db_value <- glue::glue("DATE '{format(r_value)}'")
    } else if (any(class(r_value) %in% c("POSIXct", "POSIXt"))) {
        db_value <- glue::glue("TIMESTAMP '{format(r_value, '%Y-%m-%d %H:%M:%S')}'")
    } else if ("character" %in% class(r_value)) {
        db_value <- glue::glue("'{r_value}'")
    } else {
        db_value <- as.character(r_value)
    }
    return(db_value)
}

#' Convert a dataframe of R values to a string of database values for SQL insertion
#'
#' This function takes a dataframe of R values and converts each value to its corresponding database representation.
#' It then constructs a string of database values formatted for SQL insertion.
#' @param db_cols A dataframe containing the columns to be converted.
#' @param db_types A named vector specifying the database types for each column. Default is an empty string for each column.
#' @return A string of database values formatted for SQL insertion.
#' @export
#' @concept db_utility
R_df_to_db_values <- function(db_cols, db_types = rep("", length(db_cols))) {
    names(db_types) <- names(db_cols)
    db_values <- lapply(seq_len(nrow(db_cols)), function(row_idx) {
        curr_row <- db_cols[row_idx, ]
        db_strings <- sapply(names(db_cols), function(col_name) R_value_to_db_value(curr_row[[col_name]], db_types[col_name]))
        db_row <- paste(db_strings, collapse = ", ")
        db_row <- paste0("(", db_row, ")")
    })
    combined_db_values <- paste(db_values, collapse = ", \n")
    return(combined_db_values)
}

#' Convert an R vector to a string of database values
#'
#' This function takes an R vector and converts each value to its corresponding database representation.
#'
#' @param vector An R vector to be converted.
#' @param dbtype An optional string specifying the database type to force for NULL values.
#' @return A string representing the database values.
#' @concept db_utility
#' @export
R_vector_to_db_values <- function(vector, dbtype = "") {
    db_strings <- sapply(vector, function(x) R_value_to_db_value(x, dbtpe))
    db_vector <- paste(db_strings, collapse = ", ")
    return(db_vector)
}
