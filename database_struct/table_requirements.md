Inserting "metadata"
====================
The logical flow is that we first open a logging session for each logger. Each logger can only have one logging session active at the same time. Second, we insert deployment data. Third, we insert retrieval data. The logging session is then closed. To insert new deployments and retrievals, we first need to open a new logging session (perform a startup).

However, data can be recieved from the fields in a different order, and sometimes there retrievals and deployments in the same day. This means that the logging session is stopped in the field, it then gets a new startup session in the field and is deployed. To insert this data, we need to take things one step at a time. 

To avoid errors we need to split the data up in appropriate time events, and insert them in the right order. We could create R functions that check if the deployments and retrievals can be inserted, or if we have to take things in a different order.

Overview of table requirements
=========================
To keep trackof the logical requirements for filling data into the various tables. Several checks are needed to keep internal consistency.


To add a line in startup
-----------------
*  Logger exists in logger info
*  There is no active logging session for the logger

to add a line in Allocation
---------------
*  There is an active logging session for the logger

to add a line in Logging_session
----------------
*  Logger is started in startup
*  There is no active logging session for the logger
*  **Logger end status/active status set as default for new lines**

to add a line in Deployment
--------------
*  There is an active logging session for the logger
*  The active logging session has no deployment id

to add a line in Retrieval
-----------
*  There is an active logging session for the logger
*  The active logging session has a deployment id 
*  The active logging session has no retrieval id

add deployment id in logging session
---------------
*  **Done automatically for every new line in deployment id**

add retrieval id in logging session
--------------------
* **Done automatically for every new line in retrieval id**
* **logger end status/active status set with every new retrieval id**

to add new line in shutdown
------------
*  Must have closed logging session in logging session table


