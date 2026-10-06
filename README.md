
<!-- README.md is generated from README.Rmd. Please edit that file -->

# seatrackR

<!--For a hex-sticker, add the png in inst/figures/ and uncomment this:-->

<!-- <img src="https://github.com/NINAnor/seatrackR/blob/main/inst/figures/seatrackR.png" align="right" width="160px"/> -->

<!-- badges: start -->

[![](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
[![](https://img.shields.io/badge/devel%20version-0.0.6-blue.svg)](https://github.com/NINAnor/seatrackR)
[![R build
status](https://github.com/NINAnor/seatrackR/workflows/R-CMD-check/badge.svg)](https://github.com/NINAnor/seatrackR/actions)
[![](https://img.shields.io/github/languages/code-size/NINAnor/seatrackR.svg)](https://github.com/NINAnor/seatrackR)
<!-- adapt this after creating a release and registering it at zenodo -->
<!--[![DOI](https://zenodo.org/badge/508228048.svg)](https://doi.org/10.5281/zenodo.16947368)-->
<!-- badges: end -->

## seatrackR - R package for utilizing the seatrack database

Code to manage and interact with the [seatrack
database](https://ninanor.github.io/seatrackR/articles/Intro_presentation.html).

Main functionality:

- Connect to the database
- Retrieve data
- Import data into the database.
- Interact with the FTP file archive (list files, upload, download,
  delete)

Take a look at the
[Reference](https://ninanor.github.io/seatrackR/reference/index.html)
for a guide to what is available.

## Installation

Install the package using:

    pak::pkg_install("NINAnor/seatrackR")

For detailed instructions on how to install and use this package, see
the [seatrackR: Getting
started](https://ninanor.github.io/seatrackR/articles/getting_started.html)
vignette.
