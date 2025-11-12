#' @title Export Data Request Package
#' Export a data request package
#'
#' This function will create a zip file of seatrack data. This includes:
#' - Writing each data type as a compressed parquet file
#' - Creating a README file with metadata about the data request
#'
#' @param all_data A named list of data.frames containing the data to be exported. Each name corresponds to a data type.
#' @param request_name A string representing the name of the data request.
#' @param additional_notes An optional string containing additional notes to be included in the README file.
#' @param output_dir An optional string specifying the directory where the zip file will be saved.
#' @param additional_files An optional list of additional files to include in the exported zip file. Each element of the list should contain the file path to the file to be included and a description.
#' If NULL, it will be saved in a default location based on the current year.
#' @return None. The function creates a zip file in the specified output directory.
#' @concept data_requests
#' @export
export_data_package <- function(all_data, request_name, output_dir = NULL, additional_notes = "", additional_files = list()) {
    creation_date <- Sys.Date()

    tmp_dir <- tempfile(pattern = paste0(request_name, "_"))
    dir.create(tmp_dir, showWarnings = FALSE, recursive = TRUE)
    dir.create(file.path(tmp_dir, "data"), recursive = TRUE)
    print(paste0("Creating data package in temporary directory: ", tmp_dir))
    file_list <- c()
    for (type in names(all_data)) {
        print(paste0("Writing data type: ", type))
        file_name <- paste0(request_name, "_", type, "_", creation_date, ".gz.parquet")
        file_list <- c(file_list, file_name)
        arrow::write_parquet(all_data[[type]], file.path(tmp_dir, "data", file_name), compression = "gzip")
    }

    species <- unique(all_data$morph_and_breeding$species)
    times <- c(min(as.Date(all_data$seatrackGLS_posdata$date_time)), max(as.Date(all_data$seatrackGLS_posdata$date_time)))
    colonies <- unique(all_data$morph_and_breeding$colony)

    if (length(additional_files) > 0) {
        for (additional_file in additional_files) {
            print(paste0("Adding additional file to data package: ", additional_file$path))
            current_path <- additional_file$path
            new_path <- file.path(tmp_dir, basename(current_path))
            file.copy(current_path, new_path)
        }
    }

    # render markdown template to the temp dir
    create_readme(
        request_name = request_name,
        file_list = file_list,
        species = species,
        colonies = colonies,
        times = times,
        data_types = names(all_data),
        data_dir = tmp_dir,
        additional_notes = additional_notes,
        additional_files = additional_files,
        output_file = file.path(tmp_dir, paste0("README_", request_name, "_", creation_date, ".html"))
    )

    if (is.null(output_dir)) {
        output_dir <- file.path("data", format(creation_date, "%Y"))
    }
    dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
    print(paste0("Creating zip file in output directory: ", output_dir))
    zipfile <- file.path(output_dir, paste0(request_name, "_", creation_date, ".zip"))
    zip::zipr(
        zipfile = zipfile,
        files = tmp_dir,
        include_directories = TRUE,
        recurse = TRUE
    )
    print(paste0("Data package created: ", zipfile))
    unlink(tmp_dir)
    print("Temporary files cleaned up.")
}

#' Create SEATRACK documentation README
#'
#' This function generates a README file for a SEATRACK data request package using R Markdown.
#' The README includes metadata about the data request, such as species, colonies, time span, and additional notes.
#' @param request_name A string representing the name of the data request.
#' @param file_list A character vector of file names included in the data request.
#' @param species A character vector of species included in the data request.
#' @param colonies A character vector of colonies included in the data request.
#' @param times A vector of two dates representing the start and end of the data request
#' @param data_types A character vector of data types included in the data request.
#' @param creation_date A date object representing the creation date of the data request.
#' @param data_dir A string representing the directory where the data files are located.
#' @param additional_notes An optional string containing additional notes to be included in the README file
#' @param additional_files An optional list of additional files to include in the README file. Each element of the list should contain the file path to the file to be included and a description.
#' @return None. The function creates a README file in the specified data directory.
#' @concept data_requests
#' @export
create_readme <- function(request_name, file_list, species, colonies, times, data_types, data_dir, additional_notes = "", additional_files = list(), output_file = "README.html") {
    print("Creating README file...")
    rmarkdown::render(
        system.file("rmd", "README_template.Rmd", package = "seatrackR"),
        params = list(
            request_name = request_name,
            file_list = file_list,
            species = species,
            colonies = colonies,
            times = times,
            data_types = data_types,
            data_dir = data_dir,
            notes = additional_notes,
            additional_files = additional_files
        ),
        knit_root_dir = getwd(),
        output_file = output_file,
        envir = new.env()
    )
}


#' Get SEATRACK data request
#'
#' This function retrieves SEATRACK data for a specified request, including position data, morphological and breeding data, and recordings of light, temperature, and activity.
#' If `export` is TRUE the `export_data_package` function is used to create a zip file containing the data. This includes writing each data type as a compressed parquet file and creating a README file with metadata about the data request.
#' If `export` is FALSE the function returns a named list of data.frames containing the requested data. This can be edited and passed to `export_data_package` later if desired.
#' Requires an active connection to the SEATRACK database.
#' TODO: Currently there is no way of specifying the types of data, so it will always export the data types stated above.
#' @param request_name A string representing the name of the data request.
#' @param start_year An integer representing the start year for the data request.
#' @param end_year An integer representing the end year for the data request. Defaults to the current year.
#' @param species An optional string specifying the species to filter the data. If NULL, data for all species will be retrieved.
#' @param colony An optional string specifying the colony to filter the data. If NULL, data for all colonies will be retrieved.
#' @param export A boolean indicating whether to export the data package as a zip file. If FALSE, the function will return the data as a list instead.
#' @param output_dir An optional string specifying the directory where the exported zip file will be saved.
#' @param additional_notes An optional string containing additional notes to be included in the README file in the export.
#' @param additional_files An optional list of additional files to include in the exported zip file. Each element of the list should contain the file path to the file to be included and a description.
#' If NULL, it will be saved in a default location based on the current year.
#' @return If `export` is `TRUE`: None. The function creates a zip file in the specified output directory.
#' If `export` is `FALSE`: A named list of data.frames containing the requested data.
#' @examples
#' \dontrun{
#' data_request("Mosbech_120925", 2023, 2025, "Common eider", "Christiansø")
#' }
#' @export
#' @concept data_requests
data_request <- function(request_name, start_year, end_year = format(Sys.Date(), "%Y"), species = NULL, colony = NULL, export = TRUE, output_dir = NULL, additional_notes = "", additional_files = list()) {
    start_date <- as.Date(paste0(start_year, "-01-01"))
    end_date <- as.Date(paste0(end_year, "-12-31")) + 1
    all_data <- list()

    print("Fetching position data...")
    all_pos <- getPositions(species = species, colony = colony)
    all_data$seatrackGLS_posdata <- all_pos[all_pos$date_time >= start_date & all_pos$date_time < end_date, ]

    print("Fetching individual data...")
    individuals <- getIndividInfo(colony = colony, year = NULL)
    all_data$morph_and_breeding <- individuals[individuals$individ_id %in% all_data$seatrackGLS_posdata$individ_id, ]

    types <- c("light", "temperature", "activity")
    activity_light_temp <- lapply(types, function(type) {
        print(paste0("Fetching ", type, " data..."))
        all_indivs <- lapply(individuals$individ_id, function(indiv_id) {
            getRecordings(type = type, individId = indiv_id)
        })
        do.call(rbind, all_indivs)
    })
    names(activity_light_temp) <- types
    names(activity_light_temp)[names(activity_light_temp) == "activity"] <- "immersion"
    all_data <- c(all_data, activity_light_temp)
    if (export) {
        print("Exporting data package...")
        export_data_package(
            all_data,
            request_name,
            output_dir,
            additional_notes,
            additional_files
        )
    } else {
        return(all_data)
    }
}
