-- Prepended SQL commands --
CREATE EXTENSION postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
 
---

-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.0-beta
-- PostgreSQL version: 9.5
-- Project Site: pgmodeler.com.br
-- Model Author: ---

-- object: seatrack_admin | type: ROLE --
-- DROP ROLE IF EXISTS seatrack_admin;
CREATE ROLE seatrack_admin WITH 
	SUPERUSER
	CREATEROLE
	LOGIN;
-- ddl-end --

-- object: seatrack_reader | type: ROLE --
-- DROP ROLE IF EXISTS seatrack_reader;
CREATE ROLE seatrack_reader WITH ;
-- ddl-end --

-- object: seatrack_insert | type: ROLE --
-- DROP ROLE IF EXISTS seatrack_insert;
CREATE ROLE seatrack_insert WITH ;
-- ddl-end --


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: seatrack | type: DATABASE --
-- -- DROP DATABASE IF EXISTS seatrack;
-- CREATE DATABASE seatrack
-- 	OWNER = seatrack_admin
-- ;
-- -- ddl-end --
-- 

-- object: config | type: SCHEMA --
-- DROP SCHEMA IF EXISTS config CASCADE;
CREATE SCHEMA config;
-- ddl-end --
ALTER SCHEMA config OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata | type: SCHEMA --
-- DROP SCHEMA IF EXISTS metadata CASCADE;
CREATE SCHEMA metadata;
-- ddl-end --
ALTER SCHEMA metadata OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers | type: SCHEMA --
-- DROP SCHEMA IF EXISTS loggers CASCADE;
CREATE SCHEMA loggers;
-- ddl-end --
ALTER SCHEMA loggers OWNER TO seatrack_admin;
-- ddl-end --

-- object: individuals | type: SCHEMA --
-- DROP SCHEMA IF EXISTS individuals CASCADE;
CREATE SCHEMA individuals;
-- ddl-end --
ALTER SCHEMA individuals OWNER TO seatrack_admin;
-- ddl-end --

-- object: positions | type: SCHEMA --
-- DROP SCHEMA IF EXISTS positions CASCADE;
CREATE SCHEMA positions;
-- ddl-end --
ALTER SCHEMA positions OWNER TO seatrack_admin;
-- ddl-end --

-- object: activity | type: SCHEMA --
-- DROP SCHEMA IF EXISTS activity CASCADE;
CREATE SCHEMA activity;
-- ddl-end --
ALTER SCHEMA activity OWNER TO seatrack_admin;
-- ddl-end --

-- object: views | type: SCHEMA --
-- DROP SCHEMA IF EXISTS views CASCADE;
CREATE SCHEMA views;
-- ddl-end --
ALTER SCHEMA views OWNER TO seatrack_admin;
-- ddl-end --

SET search_path TO pg_catalog,public,config,metadata,loggers,individuals,positions,activity,views;
-- ddl-end --

-- object: loggers.logger_info | type: TABLE --
-- DROP TABLE IF EXISTS loggers.logger_info CASCADE;
CREATE TABLE loggers.logger_info(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_id varchar(80) NOT NULL,
	producer text NOT NULL,
	production_year smallint NOT NULL,
	logger_model text NOT NULL,
	project text,
	CONSTRAINT logger_info_pk PRIMARY KEY (id),
	CONSTRAINT logger_id_unique UNIQUE (logger_id)

);
-- ddl-end --
ALTER TABLE loggers.logger_info OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.logger_producers | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logger_producers CASCADE;
CREATE TABLE metadata.logger_producers(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	producer text NOT NULL,
	CONSTRAINT logger_producers_pk PRIMARY KEY (id),
	CONSTRAINT producer_unique_constraint UNIQUE (producer)

);
-- ddl-end --
ALTER TABLE metadata.logger_producers OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.logger_models | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logger_models CASCADE;
CREATE TABLE metadata.logger_models(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	model text NOT NULL,
	CONSTRAINT logger_models_pk PRIMARY KEY (id),
	CONSTRAINT model_unique UNIQUE (model)

);
-- ddl-end --
ALTER TABLE metadata.logger_models OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.startup | type: TABLE --
-- DROP TABLE IF EXISTS loggers.startup CASCADE;
CREATE TABLE loggers.startup(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id bigint,
	logger_id varchar(80) NOT NULL,
	startdate_gmt date NOT NULL,
	startime_gmt timestamp NOT NULL,
	logging_mode varchar(15) NOT NULL,
	started_by text NOT NULL,
	started_where text NOT NULL,
	days_delayed smallint,
	programmed_gmt_date date,
	programmed_gmt_time timestamp,
	CONSTRAINT startup_pk PRIMARY KEY (id),
	CONSTRAINT session_id_unique UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.startup OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.logging_modes | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logging_modes CASCADE;
CREATE TABLE metadata.logging_modes(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	mode text NOT NULL,
	CONSTRAINT logging_modes_pk PRIMARY KEY (id),
	CONSTRAINT logging_modes_unique UNIQUE (mode)

);
-- ddl-end --
ALTER TABLE metadata.logging_modes OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.people | type: TABLE --
-- DROP TABLE IF EXISTS metadata.people CASCADE;
CREATE TABLE metadata.people(
	id uuid NOT NULL,
	name text NOT NULL,
	CONSTRAINT people_pk PRIMARY KEY (id),
	CONSTRAINT names_unique UNIQUE (name)

);
-- ddl-end --
ALTER TABLE metadata.people OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.allocation | type: TABLE --
-- DROP TABLE IF EXISTS loggers.allocation CASCADE;
CREATE TABLE loggers.allocation(
	id uuid NOT NULL,
	session_id bigint,
	logger_id uuid NOT NULL,
	intended_species text,
	intended_location text,
	intended_deployer text,
	CONSTRAINT allocation_pk PRIMARY KEY (id),
	CONSTRAINT allocation_session_id_unique UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.allocation OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.logging_session | type: TABLE --
-- DROP TABLE IF EXISTS loggers.logging_session CASCADE;
CREATE TABLE loggers.logging_session(
	id uuid NOT NULL,
	session_id bigint,
	logger_id uuid,
	deployment_id bigint DEFAULT NULL,
	retrieval_id bigint DEFAULT NULL,
	active boolean DEFAULT TRUE,
	colony text,
	species text,
	year_tracked text,
	CONSTRAINT logging_session_pk PRIMARY KEY (id),
	CONSTRAINT logging_session_session_id_unique UNIQUE (session_id),
	CONSTRAINT retrieval_id UNIQUE (retrieval_id),
	CONSTRAINT deployment_id UNIQUE (deployment_id)

);
-- ddl-end --
ALTER TABLE loggers.logging_session OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.species | type: TABLE --
-- DROP TABLE IF EXISTS metadata.species CASCADE;
CREATE TABLE metadata.species(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	species_name_eng text NOT NULL,
	species_name_latin text NOT NULL,
	CONSTRAINT species_pk PRIMARY KEY (id),
	CONSTRAINT species_name_unique UNIQUE (species_name_eng),
	CONSTRAINT species_name_latin_unique UNIQUE (species_name_latin)

);
-- ddl-end --
ALTER TABLE metadata.species OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.colony | type: TABLE --
-- DROP TABLE IF EXISTS metadata.colony CASCADE;
CREATE TABLE metadata.colony(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	lat double precision NOT NULL,
	lon double precision NOT NULL,
	colony_int_name text,
	colony_nat_name text,
	geom geometry(POINT, 4326) NOT NULL,
	CONSTRAINT colony_pk PRIMARY KEY (id),
	CONSTRAINT colony_int_name_unique UNIQUE (colony_int_name),
	CONSTRAINT colony_nat_unique UNIQUE (colony_nat_name)

);
-- ddl-end --
ALTER TABLE metadata.colony OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.location | type: TABLE --
-- DROP TABLE IF EXISTS metadata.location CASCADE;
CREATE TABLE metadata.location(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	location_name text NOT NULL,
	colony_int_name text NOT NULL,
	colony_nat_name text NOT NULL,
	location_lat double precision NOT NULL,
	location_lon double precision NOT NULL,
	geom geometry(POINT, 4326) NOT NULL,
	CONSTRAINT location_pk PRIMARY KEY (id),
	CONSTRAINT location_unique UNIQUE (location_name),
	CONSTRAINT location_nat_unique UNIQUE (colony_nat_name)

);
-- ddl-end --
ALTER TABLE metadata.location OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.deployment | type: TABLE --
-- DROP TABLE IF EXISTS loggers.deployment CASCADE;
CREATE TABLE loggers.deployment(
	id uuid NOT NULL,
	session_id bigint NOT NULL,
	deployment_id bigint NOT NULL,
	logger_id uuid NOT NULL,
	individ_id smallint NOT NULL,
	logger_fate text,
	dep_species text,
	deployment_location text NOT NULL,
	deployment_date date NOT NULL,
	CONSTRAINT deployment_pk PRIMARY KEY (id),
	CONSTRAINT deployment_id_unique UNIQUE (deployment_id),
	CONSTRAINT deployment_session_id_uq UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.deployment OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.logger_fate | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logger_fate CASCADE;
CREATE TABLE metadata.logger_fate(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_fate text NOT NULL,
	CONSTRAINT logger_fate_pk PRIMARY KEY (id),
	CONSTRAINT fate_unique UNIQUE (logger_fate)

);
-- ddl-end --
ALTER TABLE metadata.logger_fate OWNER TO seatrack_admin;
-- ddl-end --

-- object: individuals.individ_info | type: TABLE --
-- DROP TABLE IF EXISTS individuals.individ_info CASCADE;
CREATE TABLE individuals.individ_info(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	individ_id smallint NOT NULL,
	metalring_id text NOT NULL,
	species text,
	morph text,
	subspecies text,
	age smallint,
	sex text,
	sexing_method text,
	CONSTRAINT individ_info_pk PRIMARY KEY (id),
	CONSTRAINT metalring_id_unique UNIQUE (metalring_id),
	CONSTRAINT individ_id_uq UNIQUE (individ_id)

);
-- ddl-end --
ALTER TABLE individuals.individ_info OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.sex | type: TABLE --
-- DROP TABLE IF EXISTS metadata.sex CASCADE;
CREATE TABLE metadata.sex(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	sex varchar(10) NOT NULL,
	CONSTRAINT sex_pk PRIMARY KEY (id),
	CONSTRAINT sex_unique UNIQUE (sex)

);
-- ddl-end --
ALTER TABLE metadata.sex OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.sexing_method | type: TABLE --
-- DROP TABLE IF EXISTS metadata.sexing_method CASCADE;
CREATE TABLE metadata.sexing_method(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	method varchar(40),
	CONSTRAINT sexing_method_pk PRIMARY KEY (id),
	CONSTRAINT sexing_method_unique UNIQUE (method)

);
-- ddl-end --
ALTER TABLE metadata.sexing_method OWNER TO seatrack_admin;
-- ddl-end --

-- object: individuals.individ_status | type: TABLE --
-- DROP TABLE IF EXISTS individuals.individ_status CASCADE;
CREATE TABLE individuals.individ_status(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	event_id bigint NOT NULL,
	individ_id smallint NOT NULL,
	weight double precision,
	scull double precision,
	tarsus double precision,
	wing double precision,
	breeding_stage text,
	eggs smallint,
	chicks smallint,
	hatching_success bit,
	breeding_success bit,
	breeding_success_criterion varchar(20),
	data_responsible text NOT NULL,
	back_on_nest date,
	comment text,
	logger_mount_method text,
	CONSTRAINT individ_status_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE individuals.individ_status OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.retrieval | type: TABLE --
-- DROP TABLE IF EXISTS loggers.retrieval CASCADE;
CREATE TABLE loggers.retrieval(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id bigint NOT NULL,
	retrieval_id bigint NOT NULL,
	attribute_name text NOT NULL,
	logger_id text NOT NULL,
	individ_id smallint NOT NULL,
	retrieval_type text NOT NULL,
	retrieval_location text,
	retrieval_date date NOT NULL,
	CONSTRAINT retrieval_pk PRIMARY KEY (id),
	CONSTRAINT retrieval_id_unique UNIQUE (retrieval_id),
	CONSTRAINT retrieval_session_id_uq UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.retrieval OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.shutdown | type: TABLE --
-- DROP TABLE IF EXISTS loggers.shutdown CASCADE;
CREATE TABLE loggers.shutdown(
	id uuid NOT NULL,
	session_id bigint NOT NULL,
	download_type text NOT NULL,
	file_available boolean NOT NULL,
	stop_date date NOT NULL,
	stop_time timestamp NOT NULL,
	ready_for_deployment boolean NOT NULL,
	logger_returned_to_bt boolean NOT NULL,
	CONSTRAINT shutdown_pk PRIMARY KEY (id),
	CONSTRAINT shutdown_session_id_unique UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.shutdown OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.file_archive | type: TABLE --
-- DROP TABLE IF EXISTS loggers.file_archive CASCADE;
CREATE TABLE loggers.file_archive(
	id uuid NOT NULL,
	file_id bigint NOT NULL,
	session_id bigint NOT NULL,
	filename text,
	CONSTRAINT file_archive_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE loggers.file_archive OWNER TO seatrack_admin;
-- ddl-end --

-- object: positions.postable | type: TABLE --
-- DROP TABLE IF EXISTS positions.postable CASCADE;
CREATE TABLE positions.postable(
	id uuid NOT NULL,
	CONSTRAINT postable_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE positions.postable OWNER TO seatrack_admin;
-- ddl-end --

-- object: positions.processing | type: TABLE --
-- DROP TABLE IF EXISTS positions.processing CASCADE;
CREATE TABLE positions.processing(
	id uuid NOT NULL,
	logger_yertracked text NOT NULL,
	session_id bigint NOT NULL,
	firstdate_light date,
	lastdate_light date,
	first_aut_eq date,
	last_aut_eq date,
	first_spring_eq date,
	last_spring_eq date,
	software text,
	light_threshold double precision,
	tm_file text,
	processing_file text,
	posdata_file text,
	logger_download_success boolean,
	logger_data_failed boolean,
	analyzer text,
	logger_id_retrieved bigint,
	year_tracked smallint,
	year_retrieved smallint,
	logger_model_retrieved text,
	logger_producer text,
	ring_number text,
	euring_code text,
	species text,
	sex text,
	morph text,
	subspecies text,
	age smallint,
	colony text,
	CONSTRAINT processing_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE positions.processing OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.subspecies | type: TABLE --
-- DROP TABLE IF EXISTS metadata.subspecies CASCADE;
CREATE TABLE metadata.subspecies(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	species_name_latin text NOT NULL,
	sub_species text NOT NULL,
	CONSTRAINT subspecies_pk PRIMARY KEY (id),
	CONSTRAINT subspecies_unique UNIQUE (sub_species)

);
-- ddl-end --
COMMENT ON CONSTRAINT subspecies_unique ON metadata.subspecies  IS 'Might not be necessarily unique?';
-- ddl-end --
ALTER TABLE metadata.subspecies OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.files | type: TABLE --
-- DROP TABLE IF EXISTS loggers.files CASCADE;
CREATE TABLE loggers.files(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	file_id bigint NOT NULL,
	filename text NOT NULL,
	CONSTRAINT file_id_unique UNIQUE (file_id),
	CONSTRAINT filename_unique UNIQUE (filename),
	CONSTRAINT files_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE loggers.files OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.events | type: TABLE --
-- DROP TABLE IF EXISTS loggers.events CASCADE;
CREATE TABLE loggers.events(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_id bigint NOT NULL,
	event_date date NOT NULL,
	event_id bigint NOT NULL,
	deployment_id bigint,
	retrieval_id bigint,
	CONSTRAINT event_id UNIQUE (event_id),
	CONSTRAINT events_pk PRIMARY KEY (id),
	CONSTRAINT event_id_deployment_id_uq UNIQUE (event_id,deployment_id),
	CONSTRAINT event_id_retrieval_uq UNIQUE (event_id,retrieval_id),
	CONSTRAINT logger_date_uq UNIQUE (logger_id,event_date)

);
-- ddl-end --
ALTER TABLE loggers.events OWNER TO seatrack_admin;
-- ddl-end --

-- object: positions.logger_year_tracked | type: TABLE --
-- DROP TABLE IF EXISTS positions.logger_year_tracked CASCADE;
CREATE TABLE positions.logger_year_tracked(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id bigint NOT NULL,
	logger text NOT NULL,
	logger_year_tracked text NOT NULL,
	CONSTRAINT session_id_uq UNIQUE (session_id),
	CONSTRAINT logger_year_tracked_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE positions.logger_year_tracked OWNER TO seatrack_admin;
-- ddl-end --

-- object: activity.temperature | type: TABLE --
-- DROP TABLE IF EXISTS activity.temperature CASCADE;
CREATE TABLE activity.temperature(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id bigint NOT NULL,
	CONSTRAINT temperature_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE activity.temperature OWNER TO seatrack_admin;
-- ddl-end --

-- object: activity.salinity | type: TABLE --
-- DROP TABLE IF EXISTS activity.salinity CASCADE;
CREATE TABLE activity.salinity(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id bigint NOT NULL,
	CONSTRAINT salinity_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE activity.salinity OWNER TO seatrack_admin;
-- ddl-end --

-- object: views.postable | type: VIEW --
-- DROP VIEW IF EXISTS views.postable CASCADE;
CREATE VIEW views.postable
AS 

SELECT p.* 
FROM positions.postable p;
-- ddl-end --
ALTER VIEW views.postable OWNER TO seatrack_admin;
-- ddl-end --

-- object: views.active_logging_sessions | type: VIEW --
-- DROP VIEW IF EXISTS views.active_logging_sessions CASCADE;
CREATE VIEW views.active_logging_sessions
AS 

SELECT *
FROM loggers.logging_session
WHERE active = TRUE;
-- ddl-end --
ALTER VIEW views.active_logging_sessions OWNER TO seatrack_admin;
-- ddl-end --

-- object: logger_producer_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logger_info DROP CONSTRAINT IF EXISTS logger_producer_fk CASCADE;
ALTER TABLE loggers.logger_info ADD CONSTRAINT logger_producer_fk FOREIGN KEY (producer)
REFERENCES metadata.logger_producers (producer) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logger_model_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logger_info DROP CONSTRAINT IF EXISTS logger_model_fk CASCADE;
ALTER TABLE loggers.logger_info ADD CONSTRAINT logger_model_fk FOREIGN KEY (logger_model)
REFERENCES metadata.logger_models (model) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: logging_modes_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.startup DROP CONSTRAINT IF EXISTS logging_modes_fk CASCADE;
ALTER TABLE loggers.startup ADD CONSTRAINT logging_modes_fk FOREIGN KEY (logging_mode)
REFERENCES metadata.logging_modes (mode) MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: people_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.startup DROP CONSTRAINT IF EXISTS people_fk CASCADE;
ALTER TABLE loggers.startup ADD CONSTRAINT people_fk FOREIGN KEY (started_by)
REFERENCES metadata.people (name) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: startup_logger_id_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.startup DROP CONSTRAINT IF EXISTS startup_logger_id_fk CASCADE;
ALTER TABLE loggers.startup ADD CONSTRAINT startup_logger_id_fk FOREIGN KEY (logger_id)
REFERENCES loggers.logger_info (logger_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: startup_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.allocation DROP CONSTRAINT IF EXISTS startup_fk CASCADE;
ALTER TABLE loggers.allocation ADD CONSTRAINT startup_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE RESTRICT;
-- ddl-end --

-- object: species_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.allocation DROP CONSTRAINT IF EXISTS species_fk CASCADE;
ALTER TABLE loggers.allocation ADD CONSTRAINT species_fk FOREIGN KEY (intended_species)
REFERENCES metadata.species (species_name_eng) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: deployment_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logging_session DROP CONSTRAINT IF EXISTS deployment_logging_session_fk CASCADE;
ALTER TABLE loggers.logging_session ADD CONSTRAINT deployment_logging_session_fk FOREIGN KEY (deployment_id)
REFERENCES loggers.deployment (deployment_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: retrieval_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logging_session DROP CONSTRAINT IF EXISTS retrieval_logging_session_fk CASCADE;
ALTER TABLE loggers.logging_session ADD CONSTRAINT retrieval_logging_session_fk FOREIGN KEY (retrieval_id)
REFERENCES loggers.retrieval (retrieval_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logging_session_startup_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logging_session DROP CONSTRAINT IF EXISTS logging_session_startup_fk CASCADE;
ALTER TABLE loggers.logging_session ADD CONSTRAINT logging_session_startup_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: colony_fk | type: CONSTRAINT --
-- ALTER TABLE metadata.location DROP CONSTRAINT IF EXISTS colony_fk CASCADE;
ALTER TABLE metadata.location ADD CONSTRAINT colony_fk FOREIGN KEY (colony_nat_name)
REFERENCES metadata.colony (colony_nat_name) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: location_colony_int_name_fk | type: CONSTRAINT --
-- ALTER TABLE metadata.location DROP CONSTRAINT IF EXISTS location_colony_int_name_fk CASCADE;
ALTER TABLE metadata.location ADD CONSTRAINT location_colony_int_name_fk FOREIGN KEY (colony_int_name)
REFERENCES metadata.colony (colony_int_name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: species_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS species_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT species_fk FOREIGN KEY (dep_species)
REFERENCES metadata.species (species_name_eng) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: location_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS location_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT location_fk FOREIGN KEY (deployment_location)
REFERENCES metadata.location (location_name) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logger_fate_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS logger_fate_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT logger_fate_fk FOREIGN KEY (logger_fate)
REFERENCES metadata.logger_fate (logger_fate) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individ_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS individ_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT individ_fk FOREIGN KEY (individ_id)
REFERENCES individuals.individ_info (individ_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: deployment_location_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS deployment_location_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT deployment_location_fk FOREIGN KEY (deployment_location)
REFERENCES metadata.location (location_name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: deployment_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS deployment_logging_session_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT deployment_logging_session_fk FOREIGN KEY (session_id)
REFERENCES loggers.logging_session (session_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sexing_method_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_info DROP CONSTRAINT IF EXISTS sexing_method_fk CASCADE;
ALTER TABLE individuals.individ_info ADD CONSTRAINT sexing_method_fk FOREIGN KEY (sexing_method)
REFERENCES metadata.sexing_method (method) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: sex_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_info DROP CONSTRAINT IF EXISTS sex_fk CASCADE;
ALTER TABLE individuals.individ_info ADD CONSTRAINT sex_fk FOREIGN KEY (sex)
REFERENCES metadata.sex (sex) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: species_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_info DROP CONSTRAINT IF EXISTS species_fk CASCADE;
ALTER TABLE individuals.individ_info ADD CONSTRAINT species_fk FOREIGN KEY (species)
REFERENCES metadata.species (species_name_eng) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: subspecies_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_info DROP CONSTRAINT IF EXISTS subspecies_fk CASCADE;
ALTER TABLE individuals.individ_info ADD CONSTRAINT subspecies_fk FOREIGN KEY (subspecies)
REFERENCES metadata.subspecies (sub_species) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: retrieval_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS retrieval_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT retrieval_fk FOREIGN KEY (event_id)
REFERENCES loggers.events (event_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individ_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS individ_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT individ_fk FOREIGN KEY (individ_id)
REFERENCES individuals.individ_info (individ_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individ_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.retrieval DROP CONSTRAINT IF EXISTS individ_fk CASCADE;
ALTER TABLE loggers.retrieval ADD CONSTRAINT individ_fk FOREIGN KEY (individ_id)
REFERENCES individuals.individ_info (individ_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: location_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.retrieval DROP CONSTRAINT IF EXISTS location_fk CASCADE;
ALTER TABLE loggers.retrieval ADD CONSTRAINT location_fk FOREIGN KEY (retrieval_location)
REFERENCES metadata.location (location_name) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: retrieval_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.retrieval DROP CONSTRAINT IF EXISTS retrieval_logging_session_fk CASCADE;
ALTER TABLE loggers.retrieval ADD CONSTRAINT retrieval_logging_session_fk FOREIGN KEY (session_id)
REFERENCES loggers.logging_session (session_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: shutdown_startup_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.shutdown DROP CONSTRAINT IF EXISTS shutdown_startup_fk CASCADE;
ALTER TABLE loggers.shutdown ADD CONSTRAINT shutdown_startup_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: shutdown_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.file_archive DROP CONSTRAINT IF EXISTS shutdown_fk CASCADE;
ALTER TABLE loggers.file_archive ADD CONSTRAINT shutdown_fk FOREIGN KEY (session_id)
REFERENCES loggers.shutdown (session_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: file_id_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.file_archive DROP CONSTRAINT IF EXISTS file_id_fk CASCADE;
ALTER TABLE loggers.file_archive ADD CONSTRAINT file_id_fk FOREIGN KEY (file_id)
REFERENCES loggers.files (file_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: filename_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.file_archive DROP CONSTRAINT IF EXISTS filename_fk CASCADE;
ALTER TABLE loggers.file_archive ADD CONSTRAINT filename_fk FOREIGN KEY (filename)
REFERENCES loggers.files (filename) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: species_latin_fk | type: CONSTRAINT --
-- ALTER TABLE metadata.subspecies DROP CONSTRAINT IF EXISTS species_latin_fk CASCADE;
ALTER TABLE metadata.subspecies ADD CONSTRAINT species_latin_fk FOREIGN KEY (species_name_latin)
REFERENCES metadata.species (species_name_latin) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: events_deployment_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.events DROP CONSTRAINT IF EXISTS events_deployment_fk CASCADE;
ALTER TABLE loggers.events ADD CONSTRAINT events_deployment_fk FOREIGN KEY (deployment_id)
REFERENCES loggers.deployment (deployment_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: events_retrieval_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.events DROP CONSTRAINT IF EXISTS events_retrieval_fk CASCADE;
ALTER TABLE loggers.events ADD CONSTRAINT events_retrieval_fk FOREIGN KEY (retrieval_id)
REFERENCES loggers.retrieval (retrieval_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: logger_year_tracked_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE positions.logger_year_tracked DROP CONSTRAINT IF EXISTS logger_year_tracked_logging_session_fk CASCADE;
ALTER TABLE positions.logger_year_tracked ADD CONSTRAINT logger_year_tracked_logging_session_fk FOREIGN KEY (session_id)
REFERENCES loggers.logging_session (session_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: temp_session_id_fk | type: CONSTRAINT --
-- ALTER TABLE activity.temperature DROP CONSTRAINT IF EXISTS temp_session_id_fk CASCADE;
ALTER TABLE activity.temperature ADD CONSTRAINT temp_session_id_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: salinity_session_id_fk | type: CONSTRAINT --
-- ALTER TABLE activity.salinity DROP CONSTRAINT IF EXISTS salinity_session_id_fk CASCADE;
ALTER TABLE activity.salinity ADD CONSTRAINT salinity_session_id_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --


