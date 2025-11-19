# changeSeatrackPassword

Changes the password for a user in the Seatrack database. Since the
passwords for the file archive are fetched from the database, this also
affects the file archive.

## Usage

``` r
changeSeatrackPassword(password = NULL)
```

## Arguments

- password:

  Your new password (character string).

## Value

Null

## Examples

``` r
if (FALSE) { # \dontrun{
changeSeatrackPassword("newPassword")
} # }
```
