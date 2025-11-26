# Retrieve standard data from Seatrack

## Connecting to the database

Users at NINA and the Polarinstitute (using a computer that is within
these networks’ IP-addresses) can connect to the Seatrack database. It
is a PostgreSQL (9.6) database answering to the address
`seatrack.nina.no`, on the standard port 5432. Users should use their
individual login user names and passwords. Contact Jens Åström
(<jens.astrom@nina.no>) for details about usernames and passwords.

This instruction deals with the preferred way of connecting to the
database, using R and the `seatrackR` package. Another option is to
connect through a dedicated database management software, such as
Pgadmin3 (or 4), HeidiSQL, or similar. Some users may prefer to use the
MS Access interface.

To simplify the connection, use the convenience function
`connectSeatrack`. This creates a connection named `con` by using the
packages `DBI` and `RPostgres`.

``` r
require(seatrackR)

connectSeatrack(Username = "testreader", Password = "testreader")
```

## Custom queries

As of now, 4 functions exist to retreive data from the database through
prebuilt queries. Apart from that, users are free to use their own
queries through the functions in `DBI` and `dplyr`, using the connection
named `con` made by the
[`connectSeatrack()`](https://ninanor.github.io/seatrackR/reference/connectSeatrack.md)-function.

It is perfecty fine to download data through your own custom queries.
Creating interesting queries requires some knowledge about the structure
of the database however. Pgadmin3(4) would be a useful tool to get
further info on that. For now, we show a simple query involving just one
table. Here we get the different locations currently recorded from the
Faroe Islands (Coordinates not updated). Note that you have to load the
`DBI` package and use its query functions.

``` r
require(DBI)
```

    ## Loading required package: DBI

``` r
myQuery <- "SELECT * from metadata.location
              WHERE colony_int_name = 'Faroe Islands'"

faroeLocations <- dbGetQuery(con, myQuery)
head(faroeLocations)
```

    ##                                     id        location_name colony_int_name
    ## 1 b8136dfe-0bf0-11e8-82b0-005056b165f3   Sydrugøtu grotbrot   Faroe Islands
    ## 2 b8140854-0bf0-11e8-82b0-005056b165f3 Sydrugøtu waterfront   Faroe Islands
    ## 3 b8161d4c-0bf0-11e8-82b0-005056b165f3            Vestmanna   Faroe Islands
    ## 4 b8121e18-0bf0-11e8-82b0-005056b165f3                Sundi   Faroe Islands
    ## 5 b7e1f8fa-0bf0-11e8-82b0-005056b165f3           Glyvursnes   Faroe Islands
    ## 6 b7e67e98-0bf0-11e8-82b0-005056b165f3          Havnardalur   Faroe Islands
    ##   colony_nat_name   lat    lon
    ## 1         Føroyar 61.95 -6.798
    ## 2         Føroyar 61.95 -6.798
    ## 3         Føroyar 61.95 -6.798
    ## 4         Føroyar 61.95 -6.798
    ## 5         Føroyar 61.95 -6.798
    ## 6         Føroyar 61.95 -6.798
    ##                                                 geom
    ## 1 0101000020E6100000FED478E926311BC09A99999999F94E40
    ## 2 0101000020E6100000FED478E926311BC09A99999999F94E40
    ## 3 0101000020E6100000FED478E926311BC09A99999999F94E40
    ## 4 0101000020E6100000FED478E926311BC09A99999999F94E40
    ## 5 0101000020E6100000FED478E926311BC09A99999999F94E40
    ## 6 0101000020E6100000FED478E926311BC09A99999999F94E40

## Position data

The primary data of the positions of the birds is stored in the table
`positions.postable`. This includes all entered positions in the
database.

The `getPosdata` function retrieves this table, with options to
subselect only specific species, colonies, responsible contact person,
specific ring numbers, and years. There is also an option to limit the
records to a set number of rows, and to load the position coordinates as
a spatial object.

``` r
eynhallowPositions <- getPositions(colony = "Eynhallow", loadGeometries = TRUE)
```

    ## Error in st_read(dsn = con, query = dbplyr::sql_render(res)): could not find function "st_read"

``` r
eynhallowPositions
```

    ## Error: object 'eynhallowPositions' not found

``` r
plot(eynhallowPositions["ring_number"])
```

    ## Error: object 'eynhallowPositions' not found

## Position data for export

The data sent to the Polar institute also have the subspecies names
added to the records. The export ready positions data can be retrieved
most easily through a specific export view. Note that this will download
all records, and will take some time. Note that this export does not
contain information on the used and deleted uuids.

``` r
newExport <- dbReadTable(con, Id(schema = "views", table = "export"))
nrow(newExport)
write.csv(newExport, file = "seatrack_export_2018-08-09.csv")
```

If you are interested in knowing separate old, deleted rows, these are
found in the table `positions.deleted_uuid`.

``` r
deletedUuids <- dbReadTable(con, Id(schema = "positions", table = "deleted_uuid"))
nrow(deletedUuids)
write.csv(deletedUuids, file = "deletedUuids_2018-08-09.csv")
```

## Other functions for download

There are some more convenience functions for retrieving information
from the database as well. Here follows a quich demo.

### The `getFileArchiveSummary` function

This function pulls together data from several tables with focus on the
file archive. It should contain enough information to know what the
individual raw files contain.

``` r
eynhallowFiles <- getFileArchiveSummary(selectColony = "Eynhallow")
```

    ## Error in getFileArchiveSummary(selectColony = "Eynhallow"): unused argument (selectColony = "Eynhallow")

``` r
eynhallowFiles
```

    ## Error: object 'eynhallowFiles' not found

### The `getIndividInfo` function

This function summarizes all observation data for the individual birds.
We can subselect the colony and year interval the bird where tracked.

``` r
hornoyaIndivids <- getIndividInfo(selectColony = "Hornoya", selectYear = "2014_15")
```

    ## Error in getIndividInfo(selectColony = "Hornoya", selectYear = "2014_15"): unused arguments (selectColony = "Hornoya", selectYear = "2014_15")

``` r
hornoyaIndivids
```

    ## Error: object 'hornoyaIndivids' not found

!Note the weird duplicate records here! **TO BE FIXED**

``` r
hornoyaIndivids %>%
    print(width = Inf)
```

    ## Error: object 'hornoyaIndivids' not found

### Commonly used info

I have made a couple of views for som common information, that are
displayed on the shiny app <http://view.nina.no/seatrack/>. These can be
found like this as well.

``` r
shorttable <- dbReadTable(con, Id(schema = "views", table = "shorttable"))
shorttable
```

    ##   Antall.arter Antall.kolonier Antall.år Antall.positions Antall.individer
    ## 1           17             100       104          7504533             7412
    ##   Antall.tracks..year_tracked.
    ## 1                          104

``` r
shorttableeqfilter3 <- dbReadTable(con, Id(schema = "views", table = "shorttableeqfilter3"))
shorttableeqfilter3
```

    ##   Antall.arter Antall.kolonier Antall.år Antall.positions Antall.individer
    ## 1           17             100       104          5558527             7412
    ##   Antall.tracks..year_tracked.
    ## 1                          104
