Workflow for inserting logging data
====================
1. First of all, each logger needs to be registered in the table loggers.logger_info. The logger_id is an automatically generated number should not be specified for a new logger. The rest of the info in the logger table needs to correspond to the lookup tables in the metadata schema. So, any new types of loggers, logger manufacturers etc., needs to be specified in those tables beforehand.

2. The next step is that we start up a logger. This opens a new logging session for that logger. Each logger can only have one logging session open/active at the same time. 

3. We then allocate a logger for an intended species and location.

4. Next, we insert deployment data. 

5. Next, we insert retrieval data. The logging session is then closed. In order to insert new deployments and retrievals, we first need to open a new logging session (perform a startup).

The logging sessions table should not need to be manipulated directly. This is automatically updated on startup, deployment, and retrieval. All insert (new rows of information) of the startup, allocation, deployment, retrieval, and observations tables (see below) can be done via the imports.logger_import table. This should be the default mode of importing new info on loggers. This table is continuously cleared, and only holds the data temporarily as the data is distributed to the relevant tables. You can load all kinds of records on the same row, or optionally put startup, deployment etc. data on each own row. NB! Just make sure the data is entered in the right order! For example, the logger needs to be started before it can be deployed, be retrieved before it can be started up again etc. This is controlled for by checks in the database and the import will/should stop in case of inconsistensies. 

Typically, the logger is then shut down, and this should be noted by updating the table loggers.shutdown. This however, does not influence the logging sessions table. After shutting down, the table loggers.file_archive is updated to reflect which files are associated with which logging session. 

In most cases, it will be easiest to import new data using the access connection. However, for some tasks, it might be necessary to connect to the database via for example pgadmin3 og HeidiSQL.

Overview of table requirements
=========================
This is a running record of the constraints and other things to  keep trackof the logical requirements for filling data into the various tables. 
Several checks are needed to keep internal consistency.


To add a line in startup
-----------------
*  Logger exists in logger info
*  There is no active logging session for the logger

To add a line in Allocation
---------------
*  There is an active logging session for the logger

To add a line in Logging_session
----------------
*  Logger is started in startup
*  There is no active logging session for the logger


To add a line in Deployment
--------------
*  There is an active logging session for the logger
*  The active logging session has no deployment id

To add a line in Retrieval
-----------
*  There is an active logging session for the logger
*  The active logging session has a deployment id 
*  The active logging session has no retrieval id

Add deployment id in logging session
---------------
*  **Done automatically for every new line in deployment id**

Add retrieval id in logging session
--------------------
* **Done automatically for every new line in retrieval id**
* **logger end status/active status set with every new retrieval id**

To add new line in shutdown
------------
*  Must have closed logging session in logging session table



Issues
===============
* Probably need to add new table of logger events that records other bookkeeping events than deployment and retrieval. Need to talk Halfvdan. And what should the event table actually do?

* Add comment column to retrieval (replaces retrival type?) 

* Add metadata table for allowed ages, incl text and numbers as text. ?

* Add blood sampling and wing sample columns to individual status table

* Need to decide how to handle logger fate. Should it really be included in the deployment table?


