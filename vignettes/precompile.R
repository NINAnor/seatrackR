pkgdown_dict <- yaml::read_yaml("_pkgdown.yml")

# Precompile database requiring vignettes

src_dir <- file.path("vignettes", "src")
main_dir <- "vignettes"

article_path <- file.path(main_dir, "articles")
unlink(article_path)
dir.create(article_path, recursive = TRUE, showWarnings = FALSE)

curr_menu <- pkgdown_dict$navbar$components$articles$menu <- list()

pkgdown_dict$navbar$components$articles$menu <- list()
all_vignettes <- list.files(src_dir, ".orig")
for (vignette in all_vignettes) {
    print(vignette)
    new_name <- gsub(".orig", "", vignette)
    curr_path <- file.path(src_dir, vignette)
    metadata <- rmarkdown::yaml_front_matter(curr_path)
    knitr::knit(curr_path, output = file.path(article_path, new_name))
    title <- metadata$title
    pkgdown_dict$navbar$components$articles$menu[[title]] <- list(text = title, href = paste0("articles/articles/", gsub("Rmd", "html", new_name)))
}

data_ref_path <- file.path(main_dir, "data_reference")
unlink(data_ref_path)
dir.create(data_ref_path, recursive = TRUE, showWarnings = FALSE)

# Copy yaml file into pkgdown assets folder
asset_path <- file.path("pkgdown", "assets", "yaml")
dir.create(asset_path, recursive = TRUE, showWarnings = FALSE)

file.copy(system.file("yaml", "output_schema.yaml", package = "seatrackR"),
    file.path(asset_path, "output_schema.yaml"),
    overwrite = TRUE
)

curr_menu <- pkgdown_dict$navbar$components$data_ref$menu <- list()
# Generate individual references from yaml
schema_dict <- yaml::read_yaml(system.file("yaml", "output_schema.yaml", package = "seatrackR"))
for (key in names(schema_dict$datasets)) {
    print(paste("Generating reference for", key))
    title <- paste(gsub("_", " ", tools::toTitleCase(key)), "reference")
    params <- list()
    params$title <- title
    params$key <- key
    knitr::knit(system.file("rmd", "table_ref_template.Rmd", package = "seatrackR"),
        output = file.path(data_ref_path, paste0(key, ".Rmd"))
    )
    pkgdown_dict$navbar$components$data_ref$menu[[title]] <- list(text = title, href = paste0("articles/data_reference/", paste0(key, ".html")))
}

yaml::write_yaml(pkgdown_dict, "_pkgdown.yml")
