# checkMetadata before import

This is a collection of functions to check the integrity of the metadata
table before importing it.

## Usage

``` r
checkMetadata(myTable)

checkRetrievedMatchDeployed(myTable)

checkOpenSession(myTable)

checkLoggers(myTable)

checkNames(myTable)
```

## Arguments

- myTable:

  A metadata table to check.

## Value

Various errors.

## Functions

- `checkRetrievedMatchDeployed()`: Check loggers to be deployed or
  retrieved is in an open logging session

- `checkOpenSession()`: Check loggers to be deployed or retrieved is in
  an open logging session

- `checkLoggers()`: Check if loggers are registered in the
  loggers.logger_info table

- `checkNames()`: Check if names in data_responsible exists in the
  metadata.people table.

## Examples

``` r
if (FALSE) { # \dontrun{
connectSeatrack(Username = "testreader", Password = "testreader")
myCheck <- checkMetadata(sampleMetadata)
plot(myCheck) # quickly see how many problems there are
myCheck # check the print function for a complete list of the errors

# Or run a single test separately
checkOpenSession(sampleMetadata)
} # }
```
