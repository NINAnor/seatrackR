# Check the version of the database Checks the version of the database by querying the flyway_schema_history table. If the table does not exist, it returns 0.

Check the version of the database Checks the version of the database by
querying the flyway_schema_history table. If the table does not exist,
it returns 0.

## Usage

``` r
check_db_version()
```

## Value

Numeric version of the database, or 0 if the flyway_schema_history table
does not exist.
