# Logger info reference

Information about logging session

- #### **logger_serial_no**

  *type: string*

  Logger serial number.

- #### **logger_id**

  *type: string*

  Unique internal database ID of logger.

- #### **starttime_gmt**

  *type: datetime*

  Date time at which logger began recording data.

- #### **logging_mode**

  *type: string*

  Mode in which logger was set to record.

- #### **producer**

  *type: string*

  Logger manufacturer.

- #### **logger_model**

  *type: string*

  Logger model.

- #### **production_year**

  *type: integer*

  Year in which logger was manufactured.

- #### **session_id**

  *type: string*

  Unique ID for each time a logger was deployed.

- #### **project**

  *type: string*

  Name of the project that this session was part of.

- #### **deployment_date**

  *type: date*

  Date when the logger was deployed.

- #### **retrieval_date**

  *type: date*

  Date when the logger was retrieved.

- #### **started_by**

  *type: string*

  Name of person who started this logger.

- #### **started_where**

  *type: string*

  Location logger was started, e.g. ‘Tromsø’.

- #### **days_delayed**

  *type: integer*

  Number of days logger was delayed before it started recording data.

- #### **programmed_gmt_time**

  *type: integer*

  Date time at which logger was programmed. If a logger was programmed
  with a delay, `starttime_gmt` will be this date time + `days_delayed`.

- #### **individ_id**

  *type: string*

  Unique ID for each individual.

- #### **intended_species**

  *type: string*

  English name of the planned deployment species.

- #### **intended_location**

  *type: string*

  Planned deployment location.

- #### **intended_deployer**

  *type: string*

  Planned deployer.

- #### **deployment_species**

  *type: string*

  English name of the species on which the logger was deployed.

- #### **colony**

  *type: string*

  Name of the colony where the logger was deployed and retrieved. Note
  that a SEATRACK colony name can cover several locations

- #### **location**

  *type: string*

  Name of the location where the logger was deployed and retrieved. Note
  that a SEATRACK colony name can cover several locations

- #### **nest_id**

  *type: string*

  Identifier for the nest of the individual on which logger was
  deployed.

- #### **nest_latitude**

  *type: float*

  Latitude of the nest of the individual on which logger was deployed.

- #### **nest_longitude**

  *type: float*

  Longitude of the nest of the individual on which logger was deployed.

- #### **download_type**

  *type: string*

  Logger data download status.

- #### **download_date**

  *type: date*

  Date logger data was downloaded.

- #### **shutdown_date**

  *type: date*

  Date logger was shutdown.

- #### **decomissioned**

  *type: NA*

  Not used.

- #### **field_status**

  *type: NA*

  Not used.

- #### **nest_id**

  *type: string*

  Identifier for the nest of the individual from which logger was
  retrieved.

- #### **nest_latitude**

  *type: float*

  Latitude of the nest of the individual from which logger was
  retrieved.

- #### **nest_longitude**

  *type: float*

  Longitude of the nest of the individual from which logger was
  retrieved.

- #### **deployment_type**

  *type: string*

  Type of logger deployment (first deployment of logger, recapture and
  logger swapped, etc.).
