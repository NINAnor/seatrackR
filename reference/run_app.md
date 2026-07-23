# Run the seatrackR Shiny app

Function to run the seatrackR Shiny app. The app can be run from the
package directory or from a separate directory where the app is
installed.

## Usage

``` r
run_app(settings_path = file.path(getwd(), "seatrackR_app"), test = FALSE)
```

## Arguments

- settings_path:

  Character. Path to the directory where the app is installed. Default
  is the current working directory. The app will look for a subdirectory
  called "seatrackR_app" in this directory.

- test:

  Logical. If TRUE, the app will run in test mode. Default is FALSE. In
  test mode, the app will use a test database.

## Value

None. The function runs the Shiny app.

## Examples

``` r
if (FALSE) { # \dontrun{
run_app()
} # }
```
