## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  tidy = T
)

## ------------------------------------------------------------------------
devtools::install_github("NINAnor/seatrack-db/seatrackR")

## ----connect-------------------------------------------------------------
library(seatrackR)
connectSeatrack(Username = "testwriter", Password = "testwriter")

