# Extending seatrackR queries

The functions provided by seatrackR join and fetch data from a number of
tables and can be filtered in a number of way, depending on the
function. However, you may want to make a query that is not covered in
any existing function. This article covers a number of ways you can go
beyond the provided functions.

## R packages

As well as seatrackR, you will require the following packages to be
loaded:

``` r

library(DBI)
library(dplyr)
library(dbplyr)
```

These let us work directly with the database tables.

## Working with lazy queries

Several seatrackR functions have the argument `asTibble`. By default
this is `TRUE`, meaning that all the data requested will be collected
from the database and downloaded into R as a local object. If you set
this argument to `FALSE`, the function will instead return a lazy query.

``` r

lazy_result <- getSessionInfo(
    colony = "Røst",
    species = "Atlantic puffin",
    logger_type = "GLS",
    has_positions = TRUE,
    as_tibble = FALSE
)
class(lazy_result)
```

    ## [1] "tbl_PqConnection" "tbl_dbi"          "tbl_sql"          "tbl_lazy"         "tbl"

Inspecting the class of the returned object, we can see that it is
`tbl_PqConnection` and `tbl_lazy`. This means the data is not actually
local to your R environment. If you try something like:

``` r

puffin_2024 <- lazy_result[lazy_result$deployment_year == 2024, ] # Filter the results to just 2024
unique_session_ids <- unique(puffin_2024$session_id) # Get unique session IDs
n_session <- length(unique_session_ids) # Count the number of session IDs
```

You will get an error. We need to use the functions provided by `dbplyr`
and `dplyr` to work with lazy data. These packages translate your R code
into SQL queries behind the scenes. For example:

``` r

puffin_2024 <- filter(lazy_result, deployment_year == 2024) # Filter the results to just 2024
unique_session_ids <- distinct(puffin_2024, session_id)
n_session <- count(unique_session_ids)
```

Note that this is still considered a table and is still lazy. We haven’t
actually got the data yet. For a single variable, we can use the `pull`
function:

``` r

n_session_local <- pull(n_session, n) # the count variable in n_sessions is n.
print(n_session_local)
```

    ## [1] 6

This returns a vector (in this case a vector of length 1)

For a whole table, we can use `collect`.

``` r

puffin_2024_local <- collect(puffin_2024)
print(puffin_2024_local)
```

    ## # A tibble: 6 × 33
    ##   session_id   individ_id project logger_serial_no logger_model producer logger_type logger_deployed
    ##   <chr>        <chr>      <chr>   <chr>            <chr>        <chr>    <pq_lggr_>  <lgl>          
    ## 1 G0106_2024-… NOO_MA204… SEATRA… G0106            mk4083       Lotek    GLS         TRUE           
    ## 2 G0109_2024-… NOS_51205… SEATRA… G0109            mk4083       Lotek    GLS         TRUE           
    ## 3 C9697_2024-… NOO_MA284… SEATRA… C9697            mk4083       Lotek    GLS         TRUE           
    ## 4 G0102_2024-… NOO_MA284… SEATRA… G0102            mk4083       Lotek    GLS         TRUE           
    ## 5 G0095_2024-… NOS_51208… SEATRA… G0095            mk4083       Lotek    GLS         TRUE           
    ## 6 G0110_2024-… NOS_51205… SEATRA… G0110            mk4083       Lotek    GLS         TRUE           
    ## # ℹ 25 more variables: logger_retrieved <lgl>, active <lgl>, colony <chr>, species <chr>,
    ## #   age <chr>, sex <chr>, sexing_method <chr>, years_tracked <chr>, logger_start_time <dttm>,
    ## #   logger_start_year <int>, logging_mode <chr>, deployment_date <date>, deployment_year <int>,
    ## #   deployment_logger_status <chr>, deployment_age <chr>, retrieval_date <date>,
    ## #   retrieval_year <int>, retrieval_logger_status <chr>, shutdown_date <date>, shutdown_year <int>,
    ## #   download_type <chr>, has_positions <lgl>, has_irma <lgl>, embargoed <lgl>,
    ## #   age_deployment_class <chr>

Ideally, we keep a query lazy as long as possible. This saves us from
downloading uneccesary data.

## Directly accessing tables

While the functions provided by seatrackR act as interfaces to a number
of tables and views, you may sometimes want to access a raw table
directly.

### IMPORTANT NOTE

While we make sure that database views and the seatrackR functions
connected to them will always be backwards compatible after a database
migration, we cannot guarantee the future stability of raw tables.
Column names may change, columns may be removed or tables might be
moved. **Writing code that relies on accessing the raw tables is
therefore done entirely at your own risk.** If you need advice on this,
please contact Julian.

### Checking table availability

If you are uncertain about the exact name of a table, you can check the
tables in a schema first:

``` r

# con is a globabl object created by connectSeatrack(). 
# We specify we are using this connection in all these functions.
dbListObjects(con, Id(schema = "metadata"))
```

    ##                                      table is_prefix
    ## 1        <Id> "metadata"."breeding_stages"     FALSE
    ## 2                 <Id> "metadata"."colony"     FALSE
    ## 3       <Id> "metadata"."database_version"     FALSE
    ## 4         <Id> "metadata"."download_types"     FALSE
    ## 5           <Id> "metadata"."euring_codes"     FALSE
    ## 6           <Id> "metadata"."import_types"     FALSE
    ## 7               <Id> "metadata"."location"     FALSE
    ## 8            <Id> "metadata"."logger_fate"     FALSE
    ## 9           <Id> "metadata"."logger_files"     FALSE
    ## 10         <Id> "metadata"."logger_models"     FALSE
    ## 11      <Id> "metadata"."logger_producers"     FALSE
    ## 12         <Id> "metadata"."logger_status"     FALSE
    ## 13         <Id> "metadata"."logging_modes"     FALSE
    ## 14        <Id> "metadata"."mounting_types"     FALSE
    ## 15                <Id> "metadata"."people"     FALSE
    ## 16            <Id> "metadata"."people_old"     FALSE
    ## 17               <Id> "metadata"."project"     FALSE
    ## 18        <Id> "metadata"."project_people"     FALSE
    ## 19 <Id> "metadata"."seapop_species_colony"     FALSE
    ## 20                   <Id> "metadata"."sex"     FALSE
    ## 21         <Id> "metadata"."sexing_method"     FALSE
    ## 22               <Id> "metadata"."species"     FALSE
    ## 23            <Id> "metadata"."subspecies"     FALSE
    ## 24           <Id> "metadata"."all_species"     FALSE

If you are uncertain about what schema are available, you can refer to
the database description or use this command

``` r

all_objects <- dbListObjects(con)# List all top level database objects
all_objects[all_objects$is_prefix, ]# Limit to only schema prefixes
```

    ##                        table is_prefix
    ## 8             <Id> "loggers"      TRUE
    ## 9          <Id> "pg_catalog"      TRUE
    ## 10            <Id> "imports"      TRUE
    ## 11              <Id> "areas"      TRUE
    ## 12 <Id> "information_schema"      TRUE
    ## 13          <Id> "positions"      TRUE
    ## 14           <Id> "seatrack"      TRUE
    ## 15         <Id> "restricted"      TRUE
    ## 16             <Id> "public"      TRUE
    ## 17           <Id> "metadata"      TRUE
    ## 18              <Id> "views"      TRUE
    ## 19        <Id> "individuals"      TRUE
    ## 20         <Id> "recordings"      TRUE

### Connecting to a table

When you know which table you want to access, you can use the `tbl`
command to make a connection. For example, here we connect to the
`logger_models` table in the `metadata` schema.

``` r

logger_models <- tbl(con, in_schema("metadata", "logger_models"))
# OR (for less typing)
logger_models <- tbl(con, I("metadata.logger_models"))
```

### Example of querying several tables

logger_models will be a lazy query. We can use this for filters and
joins. Here is an example of a join

``` r

# Connect to table of all loggers
logger_info <- tbl(con, I("loggers.logger_info")) 

# Join logger_info to logger models, see below for a detailed explanation
logger_info_filtered <- left_join(
    logger_info, 
    logger_models, 
    by = join_by(logger_model == model), 
    suffix = c("", ".y")
    ) %>%
    filter( # filter by only GLS and production year
        logger_type == "GLS",
        production_year == 2024
    ) %>%
    select( # restrict to a few columns
        logger_model, logger_serial_no, producer
    ) %>%
    collect() # download the resulting table
head(logger_info_filtered)
```

    ## # A tibble: 6 × 3
    ##   logger_model logger_serial_no producer
    ##   <chr>        <chr>            <chr>   
    ## 1 mk3006       B9426            Lotek   
    ## 2 mk3006       B9426            Lotek   
    ## 3 mk3006       B9427            Lotek   
    ## 4 mk3006       B9427            Lotek   
    ## 5 mk3006       B9428            Lotek   
    ## 6 mk3006       B9428            Lotek

Going through some aspects of this step by step:

- Here I am using pipes `%>%` to pass the result of one function as the
  first argument of the next. This can be useful when performing a
  series of operations like this, but using too many can make your code
  hard to read/debug.

- Consider which sections of query you might want to reuse later. For
  example, I could store the lazy query as an object after the join was
  completed

``` r

logger_info_joined <- left_join(
    logger_info, 
    logger_models, 
    by = join_by(logger_model == model), 
    suffix = c("", ".y")
    )
```

This would let me use the joined tables again later, filtering them
differently or performing some other operation.

- A left join means that in cases where no match is found, there will be
  NAs in the added columns. In this example, if a logger model did not
  exist in `logger_models`, we would get NAs for added columns. *(This
  is actually impossible because a model has to exist in the database
  before it can be added to the `logger_info` table)*

- `by = join_by(logger_model == model)` - This argument tells the
  function that we want to join the two tables using the column
  `logger_model` in `logger_info` and `model` in `logger_models`.

- By default, `left_join` will add suffixes of `.x` and `.y` to columns
  with the same names in the tho tables being joined. So by default in
  the resulting joined table, we would have `producer.x` and
  `producer.y`. The `producer` column would no longer exist. In this
  example we give a custom `suffix` argument of `c("", ".y")`. This
  means the first occurence of this column name receives no suffix, so
  `producer` still exists and only `producer.y` is added. We could then
  drop the extra columns with:

``` r

select(-ends_with(".y"))
```

However, we could also avoid this by pre-selecting the columns we want
from both tables to ensure this no overlap!

- As above, do as much as you can before collecting or pulling the data.
  Operations done on the database will be much faster than downloading
  large amount of data into R.

## Writing SQL queries

While `dbplyr` can perform most SQL queries, there are a few functions
it can’t carry out. Additionally, if you are comfortable with SQL, you
may want the convenience of writing queries in SQL but having the data
returned directly into R.

Sending an SQL statement through R is relatively simple using the DBI
library.

``` r

# As above, we use the con object
lotek_loggers <- dbGetQuery(con, "SELECT * FROM loggers.logger_info WHERE producer = 'Lotek' LIMIT 5")
print(lotek_loggers)
```

    ##                                     id logger_id logger_serial_no logger_model producer
    ## 1 a917291a-0bf8-11f1-a395-005056b165f3     46597              444        L250A    Lotek
    ## 2 a918db52-0bf8-11f1-a395-005056b165f3     46598              451        L250A    Lotek
    ## 3 a91a88d0-0bf8-11f1-a395-005056b165f3     46599              453        L250A    Lotek
    ## 4 a91c39dc-0bf8-11f1-a395-005056b165f3     46600              455        L250A    Lotek
    ## 5 a91dff6a-0bf8-11f1-a395-005056b165f3     46601              476        L250A    Lotek
    ##   production_year project
    ## 1            2008    <NA>
    ## 2            2008    <NA>
    ## 3            2008    <NA>
    ## 4            2008    <NA>
    ## 5            2008    <NA>

Note that this is NOT returning a lazy query, but rather a standard R
dataframe.

## Is your query something others could use?

If you have written some code that carries out a useful set of joins and
filters, perhaps this is something that others might also benefit from?
Consider contributing this to the `seatrackR` package as a re-usable
function.

Additionally, if a set of joins and filters is being performed
particularly frequently, we can consider adding it as a database view.

Please contact Julian if you are interested.
