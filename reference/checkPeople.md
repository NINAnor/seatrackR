# Check People String

This function checks if a given people string is valid by calling the
database function `metadata.fn_check_people_string`. It is used to
validate the format of the people string and whether all people exist in
the database. It returns TRUE if the string is valid and the person
exists, and FALSE otherwise.

## Usage

``` r
checkPeople(people_string)
```

## Arguments

- people_string:

  A string representing the people to be checked.

## Value

TRUE if the people string is valid, FALSE otherwise.
