
<!-- README.md is generated from README.Rmd. Please edit that file -->

# seatrackR

<!--For a hex-sticker, add the png in inst/figures/ and uncomment this:-->
<!-- <img src="https://github.com/NINAnor/seatrackR/blob/main/inst/figures/seatrackR.png" align="right" width="160px"/> -->
<!-- badges: start -->

[![](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![](https://img.shields.io/badge/devel%20version-0.0.3.0-blue.svg)](https://github.com/NINAnor/seatrackR)
[![](https://www.r-pkg.org/badges/version/seatrackR)](https://cran.r-project.org/package=seatrackR)
[![R build
status](https://github.com/NINAnor/seatrackR/workflows/R-CMD-check/badge.svg)](https://github.com/NINAnor/seatrackR/actions)
[![](https://img.shields.io/github/languages/code-size/NINAnor/seatrackR.svg)](https://github.com/NINAnor/seatrackR)
<!-- adapt this after creating a release and registering it at zenodo -->
<!--[![DOI](https://zenodo.org/badge/508228048.svg)](https://doi.org/10.5281/zenodo.16947368)-->
<!-- badges: end -->

## seatrackR - R package for utilizing the seatrack database

Code to manage and interact with the seatrack database.

Main functionality:

- Connect to the database (seatrackConnect())
- Retrieve data (individ info, logger info, GLS-, IRMA-, GPS-positions,
  recordings, file archive list, active logging session list)
- Check the consistency of new data with current database, before
  inserts.
- Insert data into the database. (“metadata” fieldsheets, GLS-, IRMA-,
  and GPS-positions)
- Interact with the FTP file archive (list files, upload, download,
  delete)

Take a look at the vignettes for a guide to what is available
`help(package = "seatrackR")`.

## Installation

Install the package by:

    devtools::install_github("NINAnor/seatrack-db/seatrackR")

Or with vignettes by:

    devtools::install_github("NINAnor/seatrack-db/seatrackR", build_vignettes = T)
