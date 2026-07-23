# Set up SEATRACK DB credentials for this project

This function will store credentials to access the seatrack database in
a .Renviron file, meaning they can be automatically be used when
connecting to the seatrack database. If the project is git controlled,
.Renviron will be added to .gitignore to avoid credentials being leaked.
This function should only have to be called once, when setting up a new
project. While the option is there to directly put your credentials in
as arguments, do NOT put it in your script with the password in plain
text, as this defeats the purpose.

## Usage

``` r
set_credentials_renviron(user_name = NULL, password = NULL, save = TRUE)
```

## Arguments

- user_name:

  Username to access the seatrack database. If not provided, user will
  be prompted.

- password:

  Password to access the seatrack database If not provided, user will be
  prompted.

- save:

  Boolean. If TRUE, credentials will be saved to .Renviron for future
  use. Default is TRUE.

## Examples

``` r
 if (FALSE) { # \dontrun{
 set_credentials_renviron() # will prompt
 set_credentials_renviron("foo","bar") # only do this in the console
} # }
```
