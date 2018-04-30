seatrackR - R package for utilizing the seatrack database
==============

Much of the basic functionality is now in place, but will continue to be developed. Please take a look at the vignettes for a guide to what is available. Note that all functions might not be showed in the vignettes. 


Functionality that exists:
*  Connect to the database
*  Retrive data (various )
*  Check the consistency of new data with current database, before insertion. (of "metadata" field sheets)
*  Insert data into the database. (logger data and "metadata" fieldsheets)
*
*  ...plus more


Installation
============
Install the package by

```
devtools::install_github("NINAnor/seatrack-db/seatrackR", build_vignettes = T)
```
