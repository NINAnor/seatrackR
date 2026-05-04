# The Seatrack database and R

## Database description

- PostgreSQL (with PostGIS) database hosted at NINA: seatrack.nina.no
  - Only available from Polar institute and NINA’s IP-range. So use VPN
    when travelling
- Can be accessed with “standard tools” like PgAdmin, ODBC, Access, and
  R
- This presentation only covers working with the database through R

## R-package “seatrackR”

- Custom functions for working with the database
- Code at:
  <https://github.com/NINAnor/seatrack-db/tree/master/seatrackR>

Install:

``` r

devtools::install_github("NINAnor/seatrack-db/seatrackR",
  build_vignettes = True
)
```

- When in trouble, update the package first and restart R. If the
  problem persists, notify <jens.astrom@nina.no>.

## Connecting

- Note that you need a personal user name
- There are three types of users
  - seatrack_reader (only reads, most users)
  - seatrack_writer (can write logger logistict, position data, and
    upload files to archive)
  - seatrack_metadata_writer (can alter lookup-tables)

``` r

require(seatrackR)
connectSeatrack(
  Username = "testreader",
  Password = "testreader"
)
```

## Connecting

Remember to change your default password!

Don’t use a sensitive password, e.g. something you use on another
important places. I can’t swear that noone will be able to see it!

``` r

changeSeatrackPassword(password = "hunter2")
```

## Querying the database

- The `connectSeatrack` function creates a `DBI` connection called
  `con`. You can use this with the `DBI`, `dplyr`, `sf` packages.
- An example of using R’s ordinary functions, reading an entire table:

``` r
loggers <- dbReadTable(con, Id(schema = "loggers", table = "logger_info"))
head(loggers)
                                    id logger_id logger_serial_no logger_model
1 26070d78-9f13-11e9-be1d-005056b165f3     11599             C101       mk4083
2 26095baa-9f13-11e9-be1d-005056b165f3     11600             C102       mk4083
3 2609bbfe-9f13-11e9-be1d-005056b165f3     11601             C103       mk4083
4 260a1cfc-9f13-11e9-be1d-005056b165f3     11602             C104       mk4083
5 260a75ee-9f13-11e9-be1d-005056b165f3     11603             C105       mk4083
6 260ad192-9f13-11e9-be1d-005056b165f3     11604             C772       mk4083
  producer production_year  project
1 Biotrack            2015 SEATRACK
2 Biotrack            2015 SEATRACK
3 Biotrack            2015 SEATRACK
4 Biotrack            2015 SEATRACK
5 Biotrack            2015 SEATRACK
6 Biotrack            2015 SEATRACK
```

## Querying the database

Writing custom SQL queries in the standard R way.

``` r
LOTEKLoggersQ <- "SELECT * FROM loggers.logger_info WHERE producer = 'LOTEK'"

LOTEKLoggers <- dbGetQuery(con, LOTEKLoggersQ)
head(LOTEKLoggers)
                                    id logger_id logger_serial_no logger_model
1 3db452c6-9f1a-11e9-be1d-005056b165f3     13116        L280-0664          LAT
2 8334d474-90bc-11ec-af42-005056b165f3     30968              118       LAT280
3 835532fa-90bc-11ec-af42-005056b165f3     30969              119       LAT280
4 835c8ece-90bc-11ec-af42-005056b165f3     30970              127       LAT280
5 8365217e-90bc-11ec-af42-005056b165f3     30971              131       LAT280
6 836c1006-90bc-11ec-af42-005056b165f3     30972              134       LAT280
  producer production_year project
1    LOTEK            2017  SEAPOP
2    LOTEK            2012    <NA>
3    LOTEK            2012    <NA>
4    LOTEK            2012    <NA>
5    LOTEK            2012    <NA>
6    LOTEK            2012    <NA>
```

## Querying the database

Simple operations like this could also be done using dplyr/dbplyr. The
filtering here actually happens on the database side, but you can
specify it using dplyr commands in R.

``` r
BASLoggers <- dbReadTable(con, Id(schema = "loggers", table = "logger_info")) %>%
  filter(producer == "BAS")

head(BASLoggers)
                                    id logger_id logger_serial_no logger_model
1 184326b4-618e-11ec-9c8f-005056b165f3     30543            24339         mk15
2 184941a2-618e-11ec-9c8f-005056b165f3     30544            24418         mk15
3 26ec53f6-9f13-11e9-be1d-005056b165f3     11836             8974         mk13
4 26ec8376-9f13-11e9-be1d-005056b165f3     11837             8987         mk13
5 26ecab30-9f13-11e9-be1d-005056b165f3     11838             8986         mk13
6 26f52198-9f13-11e9-be1d-005056b165f3     11839           18B387         mk18
  producer production_year project
1      BAS            2011    <NA>
2      BAS            2011    <NA>
3      BAS            2009  SEAPOP
4      BAS            2009  SEAPOP
5      BAS            2009  SEAPOP
6      BAS            2011  SEAPOP
```

## Querying the database

Dplyr can also do joins using “dbplyr”. A silly example:

``` r

require(dbplyr)
status <- tbl(con, in_schema("individuals", "individ_status"))
loggers <- tbl(con, in_schema("loggers", "logger_info"))

loggerEggs <- status %>%
  inner_join(loggers, by = c("logger_id" = "logger_id")) %>%
  group_by(producer) %>%
  filter(!is.na(eggs)) %>%
  select(
    producer,
    eggs
  )
```

## Querying the database

``` r
ggplot(loggerEggs, aes(eggs, producer)) +
  geom_boxplot()
Error in ggplot(loggerEggs, aes(eggs, producer)): could not find function "ggplot"
```

## Querying the database

- Making your own custom queries of course requires some knowledge of
  how the database is structured.
- If you wan’t to know more about this, pgAdmin can be a good tool to
  get an overview.
- We can also help you construct the queries that you are interested in,
  or give guidance.
- If a query is usted often, we can make a custom function in the
  R-package.
- The database structural model can be viewed by the command:

``` r

viewDatabaseModel()
```

## Database structure

- The database structural model can be viewed by the command:

``` r

viewDatabaseModel()
```

    Error in knitr::include_graphics("images/seatrackModel.png"): Cannot find the file(s): "images/seatrackModel.png"

Understanding this might still be challenging…

## Database structure

- Most of the complexity deals with the logistical lifecycle of the
  loggers
  - This is handled in the schema “loggers”
  - Separate tables for startups, allocations, deployments, retrievals,
    shutdowns, associated filenames
- Much of the rest is lookup-tables, for data-integrity
  - Lookup tables in separate schema “metadata”
- Position data is in the “positions” schema, table “postable”
  - This contains all pre-processed position data.
- Info on individuals is in the “individuals” schema
  - Current info is stored in “individ_info”
  - Record of all status updates in “individ_status” (breeding, size,
    etc.)
- Most data can be linked (merged/joined) by the session_id
  - “Logger_id” and “individ_id” also useful
  - NB! that the position data is linked with the rest through the
    “session_id” column

## Working with the database through the R-package

To simplify the usage of the database, we have created some R functions
to read and write from the database. For example, to get a list all the
active logger sessions (logger started up, but not yet shut down.):

``` r
activeSessions <- getActiveSessions()
activeSessions
# A tibble: 16,197 × 12
   id      session_id logger_id deployment_id retrieval_id active colony species
   <chr>   <chr>          <int>         <int>        <int> <lgl>  <chr>  <chr>  
 1 476057… C102_2015…     11600        366896           NA TRUE   Alkef… Northe…
 2 47860b… R965_2015…     11619        366903           NA TRUE   Alkef… Brünni…
 3 484052… J641_2016…     11673            NA           NA TRUE   <NA>   <NA>   
 4 fdcb0e… G0090_202…     41165        406511           NA TRUE   Chris… Razorb…
 5 a6bc50… B682_2017…     16022        370282           NA TRUE   Grind… Common…
 6 d7b195… C7189_202…     33054        392474           NA TRUE   Kippa… Black-…
 7 a6c25f… B698_2017…     16036        370288           NA TRUE   Grind… Common…
 8 a6be71… B696_2017…     16034        370295           NA TRUE   Grind… Common…
 9 fdbd65… G0086_202…     41161        406512           NA TRUE   Chris… Razorb…
10 b6e967… C3658_201…     16481        370741           NA TRUE   Hjelm… Atlant…
# ℹ 16,187 more rows
# ℹ 4 more variables: year_tracked <chr>, individ_id <chr>,
#   last_updated <dttm>, updated_by <chr>
```

## Working with the database through the R-package

Getting position data:

``` r
lbbg2015 <- getPosdata(
  selectSpecies = "Lesser black-backed gull",
  selectYear = "2015_16"
)
Error in getPosdata(selectSpecies = "Lesser black-backed gull", selectYear = "2015_16"): could not find function "getPosdata"
lbbg2015
Error: object 'lbbg2015' not found
```

## Working with the database through the R-package

Loading it with geometries as an sf object

``` r
lbbg2015sf <- getPosdata(
  selectSpecies = "Lesser black-backed gull",
  selectYear = "2015_16",
  loadGeometries = T
)
Error in getPosdata(selectSpecies = "Lesser black-backed gull", selectYear = "2015_16", : could not find function "getPosdata"

lbbg2015sf
Error: object 'lbbg2015sf' not found
```

## Working with the database through the R-package

- Plotting - native sf way

``` r
plot(lbbg2015sf["colony"],
  pch = 16,
  key.width = lcm(6)
)
Error: object 'lbbg2015sf' not found
```

## Working with the database through the R-package

- Plotting - ggplot2

``` r
require("rnaturalearth")
world <- ne_countries(scale = "medium", returnclass = "sf")
Error in ne_countries(scale = "medium", returnclass = "sf"): could not find function "ne_countries"
p <- ggplot(world) +
  geom_sf() +
  geom_sf(data = lbbg2015sf, aes(
    color = colony,
    fill = colony
  )) +
  coord_sf(xlim = c(-30, 60), ylim = c(-10, 80), expand = FALSE) +
  ggtitle("Lesser black-backed gulls in 2015-2016")
Error in ggplot(world): could not find function "ggplot"
```

## Working with the database through the R-package

    Error: object 'p' not found

## Working with the database through the R-package

- Several other custom R functions exists, see help(package =
  “seatrackR”) for an overview. Look also at the vignettes
  - For example: `getIndividInfo`, `getLoggerInfo`
- Several functions for the few users that imports data

## File archive

- In addition to the database, we also have an FTP-server (file archive)
  that can store the raw data files from the loggers
- After shutdown, each session is expected to yield a set of files,
  which is noted in the loggers.file_archive table
- The files should after that be given the correct names and be uploaded
  to the FTP-server
  - Custom function in the R-package: `uploadFiles`
- The FTP-server uses SSL security, and the R functions gets the login
  credentials from the PostgreSQL database
  - In other words, use the R functions to upload and download files
    from the file archive
  - No need for separate user credentials
  - Pretty good security

## File archive

To see what the file archive contains (and not contains):

``` r

fileArchive <- listFileArchive()
```

``` r
fileArchive$filesInArchive
# A tibble: 39,625 × 1
   filename           
   <chr>              
 1 001_2015_mk5040.lig
 2 003_2015_mk5040.lig
 3 004_2015_mk5040.lig
 4 005_2013_mk5040.lig
 5 005_2015_mk5040.lig
 6 006_2015_mk5040.lig
 7 007_2015_mk5040.lig
 8 007_2015_mk5440.lig
 9 008_2013_mk5040.lig
10 008_2015_mk5040.lig
# ℹ 39,615 more rows
```

``` r
fileArchive$filesNotInArchive
# A tibble: 12,323 × 1
   filename             
   <chr>                
 1 B1141_2019_mk3006.trn
 2 B1146_2019_mk3006.trn
 3 B1952_2019_mk3006.trn
 4 B2453_2019_mk3006.trn
 5 B2474_2019_mk3006.trn
 6 B2476_2019_mk3006.trn
 7 B3220_2019_mk3006.trn
 8 B3222_2019_mk3006.trn
 9 B3223_2019_mk3006.trn
10 B3228_2019_mk3006.trn
# ℹ 12,313 more rows
```

``` r
fileArchive$filesNotInDatabase
# A tibble: 4,660 × 1
   filename           
   <chr>              
 1 007_2015_mk5040.lig
 2 10017_2011_mk15.TXT
 3 10022_2011_mk15.TXT
 4 10022_2011_mk15.act
 5 10022_2011_mk15.lig
 6 10023_2011_mk15.TXT
 7 10029_2011_mk15.TXT
 8 10030_2011_mk15.TXT
 9 10031_2011_mk15.TXT
10 10032_2011_mk15.TXT
# ℹ 4,650 more rows
```

## File archive

To get a summary of the expected files and their related info:

``` r

filesSummary <- getFileArchiveSummary()
filesSummary
```

    # A tibble: 47,288 × 9
      file_id session_id      colony      ring_number euring_code year_tracked
        <int> <chr>           <chr>       <chr>       <chr>       <chr>       
    1  606955 C101_2015-04-10 Alkefjellet 4182654     NOS         2015_16     
    2  606956 C101_2015-04-10 Alkefjellet 4182654     NOS         2015_16     
    3  606957 C101_2015-04-10 Alkefjellet 4182654     NOS         2015_16     
    4  606958 C101_2015-04-10 Alkefjellet 4182654     NOS         2015_16     
    5  606959 C104_2015-04-10 Alkefjellet 4182652     NOS         2015_16     
      logger_serial_no logger_model filename            
      <chr>            <chr>        <chr>               
    1 C101             mk4083       C101_2016_mk4083.txt
    2 C101             mk4083       C101_2016_mk4083.trn
    3 C101             mk4083       C101_2016_mk4083.act
    4 C101             mk4083       C101_2016_mk4083.lig
    5 C104             mk4083       C104_2016_mk4083.txt
    # ℹ 47,283 more rows

## File archive

Example: get the raw files from Røst in season 2014 - 2015.

First we check which files contains this information and see which ones
exists in the file archive

``` r
rost2014ExpectedFiles <- filesSummary %>%
  filter(
    colony == "Rost",
    year_tracked == "2014_15"
  )
# merge with available files
rost2014AvailableFiles <- rost2014ExpectedFiles %>%
  inner_join(fileArchive$filesInArchive)
# all there?
nrow(rost2014ExpectedFiles)
[1] 0
nrow(rost2014AvailableFiles)
[1] 0
```

## File archive

Downloading the files into a local folder.

``` r

downloadFiles(
  files = rost2014AvailableFiles$filename,
  destFolder = "rostRawFiles"
)
```

## File archive

We can also load the contents of a file into R using the `loadFile`
function. Here we look at the second file in the list from Røst in 2014.

``` r
M970_2015Trn <- loadFile(rost2014AvailableFiles$filename[2],
  col_names = F
)
Error in curl::curl_fetch_memory(url, handle = handle): Remote file not found [seatrack.nina.no]:
The file does not exist

M970_2015Trn
Error: object 'M970_2015Trn' not found
```

## File archive

Note that some files have some initial information in a header and
special format, that you have to specify.

``` r
M970_2015Sst <- loadFile(rost2014AvailableFiles$filename[1],
  col_names = F
)
Error in curl::curl_fetch_memory(url, handle = handle): Remote file not found [seatrack.nina.no]:
The file does not exist

M970_2015Sst %>% print(n = 12)
Error: object 'M970_2015Sst' not found
```

## File archive

Specifying rows to skip and custom column delimination.

``` r
M970_2015Sst <- loadFile(rost2014AvailableFiles$filename[1],
  col_names = T,
  skip = 19,
  delim = "\t"
)
Error in curl::curl_fetch_memory(url, handle = handle): Remote file not found [seatrack.nina.no]:
The file does not exist

M970_2015Sst
Error: object 'M970_2015Sst' not found
```
