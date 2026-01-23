schema_dict <- yaml::read_yaml(system.file("yaml", "output_schema.yaml", package = "seatrackR"))
usethis::use_data(schema_dict, overwrite = TRUE)
