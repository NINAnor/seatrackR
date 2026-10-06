# changeSeatrackPassword

Changes the password for a user in the SEATRACK database. Since the
passwords for the file archive are fetched from the database, this also
affects the file archive.

## Usage

``` r
changeSeatrackPassword(password = NULL, save_credentials = TRUE)
```

## Arguments

- password:

  A string representing the new password. If NULL, the user will be
  prompted to enter a new password.

- save_credentials:

  Boolean. If TRUE, credentials will be saved to .Renviron for future
  use. Default is TRUE.

## Value

Null

## Examples

``` r
if (FALSE) { # \dontrun{
changeSeatrackPassword("newPassword")
} # }
```
