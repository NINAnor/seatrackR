# SEATRACK data infrastructure

## Core component summary

This presentation provides a general overview of the SEATRACK data
infrastructure.

### SEATRACK database

- PostgreSQL (with PostGIS) database hosted at NINA: seatrack.nina.no
  - Only available from Polar institute, UiT and NINA’s IP-range. So use
    VPN when travelling
- Can be accessed with “standard tools” like Dbeaver, PgAdmin, ODBC,
  Access, and R

### Database migrations

- Since 2026 database migrations have been managed using the Flyway
  migration manager system.
- Database migrations can be found in the following repository
  *currently private*

### File archive

- In addition to the database, we also have an FTP-server (file archive)
  that can store the raw data files from the loggers
- After shutdown, each session is expected to yield a set of files,
  which is noted in the `loggers.file_archive` table
- The FTP-server uses SSL security, and shares login credentials with
  the PostgreSQL database
  - The R package provides functions for uploading, checking and
    downloading files.
  - No need for separate user credentials
  - Pretty good security

### R-package “seatrackR”

- Custom functions for working with the database
- Code at:
  <https://github.com/NINAnor/seatrack-db/tree/master/seatrackR>

### Other R packages

- Other R packages are used for internal data management.
  - seatrackRgls: GLS processing/calibration
  - seatrackRgps: GPS collating/processing
  - seatrackRtools: Orchestrates the other packages to perform common
    tasks.

### 

## SEATRACK database

### Database structure

#### Schema summary

![Overview of database stucture](figure/db_diagram-1.png)

Overview of database stucture

This diagram shows most of the important tables in the database.

- **Light blue: `loggers` schema. Deals with the logistics lifecycle of
  the loggers**
  1.  *Registering the start of a logging session:*
      - If the logger is new to the system, writes logger information to
        `logger_info`
      - Writes information about the start (mode, start time etc.) to
        the `startup` table.
      - Writes information about who is to receive the logger to the
        `allocation` table.
      - Writes information about the logging session to the
        `logging_session` table.
  2.  *Registering the deployment of a logger:*
      - Writes basic information about the deployment to the
        `deployment` table.
      - Writes information about samples taken (blood, feathers etc.) to
        the `sampling_events` table.
      - Also writes to tables in the `individuals` schema, see below.
  3.  *Registering the observation of a logger:*
      - Writes basic information about the deployment to the
        `observation` table.
      - Also writes to tables in the `individuals` schema, see below.
  4.  *Registering the retrieval of a logger:*
      - Writes basic information about the deployment to the `retrieval`
        table.
      - Writes information about samples taken (blood, feathers etc.) to
        the `sampling_events` table.
      - Also writes to tables in the `individuals` schema, see below.
  5.  *Registering the end of a logging session:*
      - Writes information about the end of session (date shutdown,
        logger status) to the `shutdown` table.
      - If a logger is registered with a succesful download status,
        writes expected files/filenames to the `file_archive` table.
      - Writes information about the logging session to the
        `logging_session` table.
- **Orange: `individuals` schema. Contains information about
  individuals.** - Current/permanent information such as sex or age is
  stored in `individ_info`. Each individual has one row in this table,
  and this row is updated with each subsequent status. - Record of all
  status updates in `individ_status` (breeding, size, etc.). This is
  written to with each “encounter” with the individual (deployment,
  observation, retrieval)
- **White: `positions` schema. Stores raw recorded/calculated position
  data.** - Seperate tables for different types of positions: -
  `postable`: Positions derived from GLS loggers. - `gps_raw`: GPS
  data. - `gps_gsm_raw`: GPS-GSM data. - `irma_raw`: GLS positions
  enhanced using IRMA. Currently empty.
- **Dark blue: `recordings` schema. Stores other types of raw data
  recorded by loggers.** - Seperate tables for different types of
  recordings: - `accelerometer_raw`: Accelerometer data. -
  `temperature_raw`: Temperature data. - `light_raw`: Light data from
  GLS loggers. - `activity_raw`: Immersion data.
- **Green: `metadata` schema. Additional information to be linked to
  other tables.** - Important tables include: - `people`: Table of data
  responsible or otherwise involved people. - `species` and
  `subspecies`: Information about the species being tracked. Each
  species is also present in the subspecies table, a species may have
  more than one subspecies. - `colony` and `location`: Information about
  the locations where birds are being tracked. Each colony is also
  present in the location table, a colony may have more than one
  location. - `logger_models` and `logger_producers`: Information about
  known logger models and their manufacturers.

As you can see from the diagram, many tables are directly connected to
logging_session. Many tables can therefore be joined by `session_id`.
`logger_id` and `individ_id` are also useful columns present in many
tables. Individual status events can be linked to a session by first
joining the status to an encounter event (`deployment`, `retrieval`,
`observation`) via the `status_id` column found in these tables and then
joining using the `session_id` in the encounter table.

#### Views

There are a number of convenient views that combine information: -
`loggers.session_details`: provides a comprehensive overview of a
logging session, including the deployment and retrieval events and what
data types are available. - `positions.postable`, `positions.gps`,
`positions.gps_gsm`: include both positions and extra metadata about an
individual/logging session. - `recordings.accelerometer`,
`recordings.temperature`, `recordings.light`, `recordings.activity`:
include both recording data and extra metadata about an
individual/logging session. - `views.individual_info`: combines
individual statuses with individual information and logging session
information. - `views.logger_info`: Combines summary of a logger start,
allocation, deployment, retrieval and shutdown. -
`individuals.ring_changes`: Summary table of individuals who have had
multiple ring numbers.

There is scope for adding additional views as neccesary.

### Accessing the database

- You need a personal user name
- You need to be accessing the database from a Polar institute, UiT or
  NINA IP address.
- There are two types of user
  - seatrack_reader (only reads, most users)
  - seatrack_writer (can write to tables and upload files to archive)
- The database can be accessed through any standard database client or
  through the R package.

### Querying the database

#### SQL

You can connect to the database with any suitable client software such
as DBeaver. Here is an example of a basic database query using raw SQL.

``` sql
SELECT * FROM loggers.logger_info WHERE producer = 'Lotek' LIMIT 5
```

| id | logger_id | logger_serial_no | logger_model | producer | production_year | project |
|:---|---:|:---|:---|:---|---:|:---|
| a917291a-0bf8-11f1-a395-005056b165f3 | 46597 | 444 | L250A | Lotek | 2008 | NA |
| a918db52-0bf8-11f1-a395-005056b165f3 | 46598 | 451 | L250A | Lotek | 2008 | NA |
| a91a88d0-0bf8-11f1-a395-005056b165f3 | 46599 | 453 | L250A | Lotek | 2008 | NA |
| a91c39dc-0bf8-11f1-a395-005056b165f3 | 46600 | 455 | L250A | Lotek | 2008 | NA |
| a91dff6a-0bf8-11f1-a395-005056b165f3 | 46601 | 476 | L250A | Lotek | 2008 | NA |

5 records {.table}

#### R

This repository contains an R package to make it convenient to connect
to and get data from the SEATRACK database.

Here is an example of connecting to the database and using a built in
function to get some data

``` r

  library(seatrack)
  connectSeatrackR()
  logger_data <- seatrackR::getLoggerInfo()
  logger_data <- logger_data[logger_data$producer == "Lotek",]
  head(logger_data)
```

    ## # A tibble: 6 × 35
    ##   logger_serial_no logger_id starttime_gmt       logging_mode producer logger_model production_year
    ##   <chr>            <chr>     <dttm>              <chr>        <chr>    <chr>                  <int>
    ## 1 L280-0664        L280-0664 2017-01-01 00:01:00 <NA>         Lotek    LAT                     2017
    ## 2 1150             1150      2009-01-01 00:00:00 <NA>         Lotek    L250A                   2009
    ## 3 1166             1166      2010-01-01 00:00:00 <NA>         Lotek    L250A                   2009
    ## 4 1166             1166      2009-01-01 00:00:00 <NA>         Lotek    L250A                   2009
    ## 5 1172             1172      2009-01-01 00:00:00 <NA>         Lotek    L250A                   2009
    ## 6 1185             1185      2010-01-01 00:00:00 <NA>         Lotek    L250A                   2009
    ## # ℹ 28 more variables: session_id <chr>, project <chr>, deployment_date <date>,
    ## #   retrieval_date <date>, retrieval_type <chr>, started_by <chr>, started_where <chr>,
    ## #   days_delayed <int>, programmed_gmt_time <dttm>, individ_id <chr>, intended_species <chr>,
    ## #   intended_location <chr>, intended_deployer <chr>, deployment_species <chr>, colony <chr>,
    ## #   nest_id <chr>, nest_longitude <dbl>, nest_latitude <dbl>, download_type <chr>,
    ## #   download_date <date>, shutdown_date <date>, downloaded_by <chr>, decomissioned <lgl>,
    ## #   field_status <chr>, retrieval_nest_id <chr>, retrieval_nest_longitude <dbl>, …

For detailed instructions on how to install and use this package, see
the seatrackR: Getting started vignette.
