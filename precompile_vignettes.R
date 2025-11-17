pkgdown_dict <- yaml::read_yaml("_pkgdown.yml")

# Precompile database requiring vignettes

src_dir <- file.path("vignettes", "src")
main_dir <- "vignettes"

article_path <- main_dir
dir.create(article_path, recursive = TRUE, showWarnings = FALSE)

curr_menu <- pkgdown_dict$navbar$components$articles$menu <- list()

pkgdown_dict$navbar$components$articles$menu <- list()
all_vignettes <- list.files(src_dir, ".orig")
for (vignette in all_vignettes) {
    print(vignette)
    new_name <- gsub(".orig", "", vignette)
    curr_path <- file.path(src_dir, vignette)
    metadata <- rmarkdown::yaml_front_matter(curr_path)
    rmd_content <- readLines(curr_path)
    # In case we need to inject some text into the vignette, do it here
    knitr::knit(text = rmd_content, output = file.path(article_path, new_name))
    if (dir.exists("figure")) {
        dest <- file.path(article_path, "figure")
        file.copy("figure", article_path, recursive = TRUE)
    }
    title <- metadata$title
    pkgdown_dict$navbar$components$articles$menu[[title]] <- list(text = title, href = paste0("articles/", gsub("Rmd", "html", new_name)))
}

data_ref_path <- main_dir
# dir.create(data_ref_path, recursive = TRUE, showWarnings = FALSE)

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
    pkgdown_dict$navbar$components$data_ref$menu[[title]] <- list(text = title, href = paste0("articles/", paste0(key, ".html")))
}

yaml::write_yaml(pkgdown_dict, "_pkgdown.yml")
