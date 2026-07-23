library(devtools)
library(formatR)
library(badger)
library(styler)
library(NinaR)
library(yaml)
library(rmarkdown)
library(knitr)

install_cellar <- function(path = ".") {
    cellar <- renv:::renv_paths_cellar()
    if (!dir.exists(cellar)) {
        dir.create(cellar)
    }
    pkgbuild::build(path, dest_path = cellar)
}
