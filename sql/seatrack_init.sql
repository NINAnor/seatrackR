-- Prepended SQL commands --
CREATE EXTENSION postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
 
---

-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.0-beta
-- PostgreSQL version: 9.6
-- Project Site: pgmodeler.com.br
-- Model Author: ---

SET check_function_bodies = false;
-- ddl-end --

-- object: seatrack_reader | type: ROLE --
-- DROP ROLE IF EXISTS seatrack_reader;
CREATE ROLE seatrack_reader WITH ;
-- ddl-end --

-- object: seatrack_writer | type: ROLE --
-- DROP ROLE IF EXISTS seatrack_writer;
CREATE ROLE seatrack_writer WITH ;
-- ddl-end --

-- object: seatrack_admin | type: ROLE --
-- DROP ROLE IF EXISTS seatrack_admin;

-- Prepended SQL commands --


-- ddl-end --

CREATE ROLE seatrack_admin WITH 
	SUPERUSER
	CREATEROLE;
-- ddl-end --

-- object: testreader | type: ROLE --
-- DROP ROLE IF EXISTS testreader;
CREATE ROLE testreader WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'testreader'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: jens_astrom | type: ROLE --
-- DROP ROLE IF EXISTS jens_astrom;
CREATE ROLE jens_astrom WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'jens_astrom'
	IN ROLE seatrack_admin;
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

-- object: functions | type: SCHEMA --
-- DROP SCHEMA IF EXISTS functions CASCADE;
CREATE SCHEMA functions;
-- ddl-end --
ALTER SCHEMA functions OWNER TO seatrack_admin;
-- ddl-end --

-- object: imports | type: SCHEMA --
-- DROP SCHEMA IF EXISTS imports CASCADE;
CREATE SCHEMA imports;
-- ddl-end --
ALTER SCHEMA imports OWNER TO seatrack_admin;
-- ddl-end --

SET search_path TO pg_catalog,public,config,metadata,loggers,individuals,positions,activity,views,functions,imports;
-- ddl-end --

-- object: loggers.logger_info | type: TABLE --
-- DROP TABLE IF EXISTS loggers.logger_info CASCADE;
CREATE TABLE loggers.logger_info(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_id serial NOT NULL,
	logger_serial_no text NOT NULL,
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

INSERT INTO loggers.logger_info (id, logger_id, logger_serial_no, producer, production_year, logger_model, project) VALUES (DEFAULT, E'1', E'test_1234', E'testproducer', E'2013', E'testmodel', E'seatrack');
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

INSERT INTO metadata.logger_producers (id, producer) VALUES (DEFAULT, E'testproducer');
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

INSERT INTO metadata.logger_models (id, model) VALUES (DEFAULT, E'testmodel');
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

INSERT INTO metadata.logging_modes (id, mode) VALUES (DEFAULT, E'testmode');
-- ddl-end --

-- object: metadata.people | type: TABLE --
-- DROP TABLE IF EXISTS metadata.people CASCADE;
CREATE TABLE metadata.people(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	name text NOT NULL,
	person_id serial NOT NULL,
	CONSTRAINT people_pk PRIMARY KEY (id),
	CONSTRAINT names_unique UNIQUE (name),
	CONSTRAINT person_id_uq UNIQUE (person_id)

);
-- ddl-end --
ALTER TABLE metadata.people OWNER TO seatrack_admin;
-- ddl-end --

INSERT INTO metadata.people (id, name, person_id) VALUES (DEFAULT, E'Jens Åström', DEFAULT);
-- ddl-end --

-- object: loggers.allocation | type: TABLE --
-- DROP TABLE IF EXISTS loggers.allocation CASCADE;
CREATE TABLE loggers.allocation(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer,
	logger_id integer NOT NULL,
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
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer,
	logger_id integer,
	deployment_id integer DEFAULT NULL,
	retrieval_id integer DEFAULT NULL,
	active boolean DEFAULT TRUE,
	colony text,
	species text,
	year_tracked text,
	individ_id integer,
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

INSERT INTO metadata.species (id, species_name_eng, species_name_latin) VALUES (DEFAULT, E'testspecies', E'testus specius');
-- ddl-end --

-- object: metadata.colony | type: TABLE --
-- DROP TABLE IF EXISTS metadata.colony CASCADE;
CREATE TABLE metadata.colony(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	lat double precision,
	lon double precision,
	colony_int_name text,
	colony_nat_name text,
	geom geometry(POINT, 4326),
	CONSTRAINT colony_pk PRIMARY KEY (id),
	CONSTRAINT colony_int_name_unique UNIQUE (colony_int_name),
	CONSTRAINT colony_nat_unique UNIQUE (colony_nat_name)

);
-- ddl-end --
ALTER TABLE metadata.colony OWNER TO seatrack_admin;
-- ddl-end --

INSERT INTO metadata.colony (id, lat, lon, colony_int_name, colony_nat_name, geom) VALUES (DEFAULT, E'73.1', E'15.2', E'testcolony', E'testcolonü', DEFAULT);
-- ddl-end --

-- object: metadata.location | type: TABLE --
-- DROP TABLE IF EXISTS metadata.location CASCADE;
CREATE TABLE metadata.location(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	location_name text NOT NULL,
	colony_int_name text NOT NULL,
	colony_nat_name text NOT NULL,
	lat double precision,
	lon double precision,
	geom geometry(POINT, 4326),
	CONSTRAINT location_pk PRIMARY KEY (id),
	CONSTRAINT location_unique UNIQUE (location_name),
	CONSTRAINT location_nat_unique UNIQUE (colony_nat_name)

);
-- ddl-end --
ALTER TABLE metadata.location OWNER TO seatrack_admin;
-- ddl-end --

INSERT INTO metadata.location (id, location_name, colony_int_name, colony_nat_name, lat, lon, geom) VALUES (DEFAULT, E'testlocation', E'testcolony', E'testcolonü', E'72.1', E'10.22', DEFAULT);
-- ddl-end --

-- object: loggers.deployment | type: TABLE --
-- DROP TABLE IF EXISTS loggers.deployment CASCADE;
CREATE TABLE loggers.deployment(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
	deployment_id serial NOT NULL,
	logger_id integer NOT NULL,
	individ_id integer NOT NULL,
	logger_fate text,
	deployment_species text,
	deployment_location text NOT NULL,
	deployment_date date NOT NULL,
	logger_mount_method text NOT NULL,
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

INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'testfate');
-- ddl-end --

-- object: individuals.individ_info | type: TABLE --
-- DROP TABLE IF EXISTS individuals.individ_info CASCADE;
CREATE TABLE individuals.individ_info(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	individ_id integer NOT NULL,
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

INSERT INTO individuals.individ_info (id, individ_id, metalring_id, species, morph, subspecies, age, sex, sexing_method) VALUES (DEFAULT, E'1', E'1', E'testspecies', E'testmorph', E'testus', E'12', E'm', E'testmethod');
-- ddl-end --

-- object: metadata.sex | type: TABLE --
-- DROP TABLE IF EXISTS metadata.sex CASCADE;
CREATE TABLE metadata.sex(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	sex varchar(20) NOT NULL,
	CONSTRAINT sex_pk PRIMARY KEY (id),
	CONSTRAINT sex_unique UNIQUE (sex)

);
-- ddl-end --
ALTER TABLE metadata.sex OWNER TO seatrack_admin;
-- ddl-end --

INSERT INTO metadata.sex (id, sex) VALUES (DEFAULT, E'm');
-- ddl-end --
INSERT INTO metadata.sex (id, sex) VALUES (DEFAULT, E'f');
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

INSERT INTO metadata.sexing_method (id, method) VALUES (DEFAULT, E'testmethod');
-- ddl-end --

-- object: individuals.individ_status | type: TABLE --
-- DROP TABLE IF EXISTS individuals.individ_status CASCADE;
CREATE TABLE individuals.individ_status(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_id integer NOT NULL,
	status_id serial NOT NULL,
	session_id integer NOT NULL,
	weight double precision,
	scull double precision,
	tarsus double precision,
	wing double precision,
	breeding_stage text,
	eggs smallint,
	chicks smallint,
	hatching_success bit,
	breeding_success bit,
	breeding_success_criterion text,
	data_responsible text NOT NULL,
	back_on_nest date,
	comment text,
	location text NOT NULL,
	CONSTRAINT individ_status_pk PRIMARY KEY (id),
	CONSTRAINT status_id UNIQUE (status_id)

);
-- ddl-end --
ALTER TABLE individuals.individ_status OWNER TO seatrack_admin;
-- ddl-end --

-- object: loggers.retrieval | type: TABLE --
-- DROP TABLE IF EXISTS loggers.retrieval CASCADE;
CREATE TABLE loggers.retrieval(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
	retrieval_id serial NOT NULL,
	attribute_name text NOT NULL,
	logger_id integer NOT NULL,
	individ_id integer NOT NULL,
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
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
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
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	file_id serial NOT NULL,
	session_id integer NOT NULL,
	filename text,
	CONSTRAINT file_archive_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE loggers.file_archive OWNER TO seatrack_admin;
-- ddl-end --

-- object: positions.postable | type: TABLE --
-- DROP TABLE IF EXISTS positions.postable CASCADE;
CREATE TABLE positions.postable(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	date_time timestamp NOT NULL,
	logger text NOT NULL,
	logger_id text NOT NULL,
	logger_model text NOT NULL,
	year_tracked text NOT NULL,
	year_deployed smallint NOT NULL,
	year_retrieved smallint NOT NULL,
	ring_number text NOT NULL,
	euring_code text NOT NULL,
	species text NOT NULL,
	colony text NOT NULL,
	lon_raw double precision,
	lat_raw double precision,
	lon_smooth1 double precision,
	lat_smooth1 double precision,
	lon_smooth2 double precision,
	lat_smooth2 double precision,
	disttocol_s2 double precision,
	eqfilter1 smallint,
	eqfilter2 smallint,
	eqfilter3 smallint,
	lat_smooth2_eqfilt3 double precision,
	sex text,
	morph text,
	subspecies text,
	age text,
	col_lon double precision,
	col_lat double precision,
	tfirst timestamp,
	tsecond timestamp,
	twl_type smallint,
	conf smallint,
	sun double precision,
	software text,
	light_threshold smallint,
	analyzer text,
	data_responsible text,
	logger_yeartracked text,
	posdata_file text,
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
	session_id integer NOT NULL,
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

INSERT INTO metadata.subspecies (id, species_name_latin, sub_species) VALUES (DEFAULT, E'testus specius', E'testus');
-- ddl-end --
INSERT INTO metadata.subspecies (id, species_name_latin, sub_species) VALUES (DEFAULT, E'testus specius', E'specius');
-- ddl-end --

-- object: loggers.events | type: TABLE --
-- DROP TABLE IF EXISTS loggers.events CASCADE;
CREATE TABLE loggers.events(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_id integer NOT NULL,
	event_date date NOT NULL,
	status_id integer NOT NULL,
	deployment_id integer,
	retrieval_id integer,
	CONSTRAINT status_id UNIQUE (status_id),
	CONSTRAINT events_pk PRIMARY KEY (id),
	CONSTRAINT event_id_deployment_id_uq UNIQUE (status_id,deployment_id),
	CONSTRAINT event_id_retrieval_uq UNIQUE (status_id,retrieval_id),
	CONSTRAINT logger_date_uq UNIQUE (logger_id,event_date)

);
-- ddl-end --
ALTER TABLE loggers.events OWNER TO seatrack_admin;
-- ddl-end --

-- object: positions.logger_year_tracked | type: TABLE --
-- DROP TABLE IF EXISTS positions.logger_year_tracked CASCADE;
CREATE TABLE positions.logger_year_tracked(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
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
	session_id integer NOT NULL,
	CONSTRAINT temperature_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE activity.temperature OWNER TO seatrack_admin;
-- ddl-end --

-- object: activity.salinity | type: TABLE --
-- DROP TABLE IF EXISTS activity.salinity CASCADE;
CREATE TABLE activity.salinity(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
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

-- object: loggers.startup | type: TABLE --
-- DROP TABLE IF EXISTS loggers.startup CASCADE;
CREATE TABLE loggers.startup(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id serial NOT NULL,
	logger_id integer NOT NULL,
	startdate_gmt date NOT NULL,
	starttime_gmt timestamp NOT NULL,
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

INSERT INTO loggers.startup (id, session_id, logger_id, startdate_gmt, starttime_gmt, logging_mode, started_by, started_where, days_delayed, programmed_gmt_date, programmed_gmt_time) VALUES (DEFAULT, DEFAULT, E'1', E'2017-05-01', E'2017-05-01 10:00:00', E'testmode', E'Jens Åström', E'NINA', E'2', E'2017-05-01', E'2017-05-01 10:00:00');
-- ddl-end --

-- object: functions.fn_update_location_geom | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_location_geom() CASCADE;
CREATE FUNCTION functions.fn_update_location_geom ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN	
-- as this is an after trigger, NEW contains all the information we need even for INSERT
	UPDATE metadata.location SET 
	geom = ST_SetSRID(ST_MakePoint(NEW.lon,NEW.lat), 4326)
	WHERE id=NEW.id;

	--RAISE NOTICE 'UPDATING geo data for %, [%,%]' , NEW.id, NEW.lat, NEW.lon;	
    RETURN NULL; -- result is ignored since this is an AFTER trigger
  END;


$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_location_geom() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_insert_location_geom | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_insert_location_geom ON metadata.location CASCADE;
CREATE TRIGGER tr_insert_location_geom
	AFTER INSERT 
	ON metadata.location
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_location_geom();
-- ddl-end --

-- object: fn_update_location_geom | type: TRIGGER --
-- DROP TRIGGER IF EXISTS fn_update_location_geom ON metadata.location CASCADE;
CREATE TRIGGER fn_update_location_geom
	AFTER UPDATE OF lat,lon
	ON metadata.location
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_location_geom();
-- ddl-end --

-- object: functions.fn_update_colony_geom | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_colony_geom() CASCADE;
CREATE FUNCTION functions.fn_update_colony_geom ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN	
-- as this is an after trigger, NEW contains all the information we need even for INSERT
	UPDATE metadata.colony SET 
	geom = ST_SetSRID(ST_MakePoint(NEW.lon,NEW.lat), 4326)
	WHERE id=NEW.id;

	--RAISE NOTICE 'UPDATING geo data for %, [%,%]' , NEW.id, NEW.lat, NEW.lon;	
    RETURN NULL; -- result is ignored since this is an AFTER trigger
  END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_colony_geom() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_insert_colony_geom | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_insert_colony_geom ON metadata.colony CASCADE;
CREATE TRIGGER tr_insert_colony_geom
	AFTER INSERT 
	ON metadata.colony
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_colony_geom();
-- ddl-end --

-- object: tr_update_colony_geom | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_colony_geom ON metadata.colony CASCADE;
CREATE TRIGGER tr_update_colony_geom
	AFTER UPDATE OF lat,lon
	ON metadata.colony
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_colony_geom();
-- ddl-end --

-- object: imports.logger_import | type: TABLE --
-- DROP TABLE IF EXISTS imports.logger_import CASCADE;
CREATE TABLE imports.logger_import(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	import_time timestamp NOT NULL,
	import_type varchar(20) NOT NULL,
	logger_id integer NOT NULL,
	startdate_gmt date,
	starttime_gmt timestamp,
	logging_mode varchar(15),
	started_by text,
	started_where text,
	days_delayed smallint,
	programmed_gmt_date date,
	programmed_gmt_time timestamp,
	intended_species text,
	intended_location text,
	intended_deployer text,
	individ_id integer,
	logger_fate text,
	deployment_species text,
	deployment_location text,
	deployment_date date,
	logger_mount_method text,
	attribute_name text,
	retrieval_type text,
	retrieval_location text,
	retrieval_date date,
	weight double precision,
	scull double precision,
	tarsus double precision,
	wing double precision,
	breeding_stage text,
	eggs smallint,
	chicks smallint,
	hatching_success bit,
	breeding_success bit,
	breeding_success_criterion text,
	data_responsible text,
	back_on_nest_date date,
	comment text,
	observation_location text,
	CONSTRAINT logger_import_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE imports.logger_import OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.import_types | type: TABLE --
-- DROP TABLE IF EXISTS metadata.import_types CASCADE;
CREATE TABLE metadata.import_types(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	import_type varchar(20) NOT NULL,
	CONSTRAINT import_types_pk PRIMARY KEY (id),
	CONSTRAINT import_types_uq UNIQUE (import_type)

);
-- ddl-end --
ALTER TABLE metadata.import_types OWNER TO seatrack_admin;
-- ddl-end --

INSERT INTO metadata.import_types (id, import_type) VALUES (DEFAULT, E'startup');
-- ddl-end --
INSERT INTO metadata.import_types (id, import_type) VALUES (DEFAULT, E'allocation');
-- ddl-end --
INSERT INTO metadata.import_types (id, import_type) VALUES (DEFAULT, E'deployment');
-- ddl-end --
INSERT INTO metadata.import_types (id, import_type) VALUES (DEFAULT, E'retrieval');
-- ddl-end --
INSERT INTO metadata.import_types (id, import_type) VALUES (DEFAULT, E'status');
-- ddl-end --

-- object: metadata.mounting_types | type: TABLE --
-- DROP TABLE IF EXISTS metadata.mounting_types CASCADE;
CREATE TABLE metadata.mounting_types(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_mount_method text NOT NULL,
	CONSTRAINT mounting_types_pk PRIMARY KEY (id),
	CONSTRAINT mounting_types_uq UNIQUE (logger_mount_method)

);
-- ddl-end --
ALTER TABLE metadata.mounting_types OWNER TO seatrack_admin;
-- ddl-end --

INSERT INTO metadata.mounting_types (id, logger_mount_method) VALUES (DEFAULT, E'testmethod');
-- ddl-end --

-- object: individuals.observations | type: TABLE --
-- DROP TABLE IF EXISTS individuals.observations CASCADE;
CREATE TABLE individuals.observations(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	metalring_id text NOT NULL,
	lat double precision NOT NULL,
	lon double precision NOT NULL,
	geom geometry(POINT, 4326),
	CONSTRAINT observations_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE individuals.observations OWNER TO seatrack_admin;
-- ddl-end --

-- object: functions.fn_update_observations_geom | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_observations_geom() CASCADE;
CREATE FUNCTION functions.fn_update_observations_geom ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN	
-- as this is an after trigger, NEW contains all the information we need even for INSERT
	UPDATE individuals.observations SET 
	geom = ST_SetSRID(ST_MakePoint(NEW.lon,NEW.lat), 4326)
	WHERE id=NEW.id;

	--RAISE NOTICE 'UPDATING geo data for %, [%,%]' , NEW.id, NEW.lat, NEW.lon;	
    RETURN NULL; -- result is ignored since this is an AFTER trigger
  END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_observations_geom() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_insert_observation_geom | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_insert_observation_geom ON individuals.observations CASCADE;
CREATE TRIGGER tr_insert_observation_geom
	AFTER INSERT 
	ON individuals.observations
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_observations_geom();
-- ddl-end --

-- object: fn_update_observation_geom | type: TRIGGER --
-- DROP TRIGGER IF EXISTS fn_update_observation_geom ON individuals.observations CASCADE;
CREATE TRIGGER fn_update_observation_geom
	AFTER UPDATE OF lat,lon
	ON individuals.observations
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_observations_geom();
-- ddl-end --

-- object: functions.fn_check_logging_session_not_open | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_logging_session_not_open() CASCADE;
CREATE FUNCTION functions.fn_check_logging_session_not_open ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
		IF  bool_or(logging_session.active = TRUE)
				FROM loggers.logging_session
				WHERE logging_session.logger_id = NEW.logger_id
		THEN
		RAISE EXCEPTION 'Logger % already in open logging session. Close open session before starting new one', NEW.logger_id;
	END IF;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_logging_session_not_open() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_check_open_logging_session | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_open_logging_session ON loggers.startup CASCADE;
CREATE TRIGGER tr_check_open_logging_session
	BEFORE INSERT OR UPDATE
	ON loggers.startup
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_logging_session_not_open();
-- ddl-end --

-- object: functions.fn_start_new_logging_session | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_start_new_logging_session() CASCADE;
CREATE FUNCTION functions.fn_start_new_logging_session ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
    INSERT INTO
       loggers.logging_session(session_id,logger_id)
        VALUES(new.session_id,new.logger_id);
           RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_start_new_logging_session() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_insert_new_logging_session | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_insert_new_logging_session ON loggers.startup CASCADE;
CREATE TRIGGER tr_insert_new_logging_session
	AFTER INSERT OR UPDATE
	ON loggers.startup
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_start_new_logging_session();
-- ddl-end --

-- object: functions.fn_check_open_session_on_deployment | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_open_session_on_deployment() CASCADE;
CREATE FUNCTION functions.fn_check_open_session_on_deployment ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
		IF bool_and(logging_session.logger_id != NEW.logger_id) 
			FROM loggers.logging_session
			THEN
			RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id;
		END IF;

		IF bool_and(logging_session.active = FALSE)
			FROM loggers.logging_session
			WHERE logging_session.logger_id = NEW.logger_id
		THEN
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id;
	END IF;

	NEW.session_id := logging_session.session_id
	FROM loggers.logging_session
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_deployment() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_check_open_session_on_deployment | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_open_session_on_deployment ON loggers.deployment CASCADE;
CREATE TRIGGER tr_check_open_session_on_deployment
	BEFORE INSERT OR UPDATE
	ON loggers.deployment
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_open_session_on_deployment();
-- ddl-end --

-- object: functions.fn_update_session_on_deployment | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_session_on_deployment() CASCADE;
CREATE FUNCTION functions.fn_update_session_on_deployment ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	WITH col as (SELECT session_id, colony_int_name
		FROM loggers.deployment d, metadata.location l
		WHERE d.deployment_location = l.location_name
		AND d.session_id = NEW.session_id)
		UPDATE loggers.logging_session update SET
		deployment_id = NEW.deployment_id,
		colony = col.colony_int_name, 
		species = NEW.deployment_species,
		individ_id = NEW.individ_id
		FROM col
		WHERE update.session_id = NEW.session_id
		AND col.session_id = NEW.session_id;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_session_on_deployment() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_update_session_on_deployment | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_session_on_deployment ON loggers.deployment CASCADE;
CREATE TRIGGER tr_update_session_on_deployment
	AFTER INSERT OR UPDATE
	ON loggers.deployment
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_session_on_deployment();
-- ddl-end --

-- object: functions.fn_check_open_session_on_retrieval | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_open_session_on_retrieval() CASCADE;
CREATE FUNCTION functions.fn_check_open_session_on_retrieval ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF  bool_and(logging_session.logger_id != NEW.logger_id)
		FROM loggers.logging_session
	THEN 
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id;
	END IF;
   
	IF bool_and(logging_session.active = FALSE) 			
		FROM loggers.logging_session
		WHERE logging_session.logger_id = NEW.logger_id
	THEN
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id;
	END IF;
   
	IF bool_or(logging_session.deployment_id IS NULL)
			FROM loggers.logging_session
			WHERE logging_session.logger_id = NEW.logger_id
	THEN
		RAISE EXCEPTION 'Logger % not deployed. Logger must be deployed before retrieved.', NEW.logger_id;
	END IF;
		
	NEW.session_id := logging_session.session_id
	FROM loggers.logging_session
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_retrieval() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_check_session_on_retrieval | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_session_on_retrieval ON loggers.retrieval CASCADE;
CREATE TRIGGER tr_check_session_on_retrieval
	BEFORE INSERT 
	ON loggers.retrieval
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_open_session_on_retrieval();
-- ddl-end --

-- object: functions.fn_update_session_on_retrieval | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_session_on_retrieval() CASCADE;
CREATE FUNCTION functions.fn_update_session_on_retrieval ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
		WITH dep as (SELECT r.session_id, deployment_date, retrieval_date
		FROM loggers.retrieval r, loggers.deployment d
		WHERE r.session_id = d.session_id
		AND r.session_id = NEW.session_id)
		UPDATE loggers.logging_session update SET
		retrieval_id = NEW.retrieval_id,
		active = FALSE,
		year_tracked = date_part('year', dep.deployment_date) || '-' || date_part('year', dep.retrieval_date)
		FROM dep
		WHERE update.session_id = NEW.session_id
		AND NEW.session_id = dep.session_id;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_session_on_retrieval() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_update_session_on_retrieval | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_session_on_retrieval ON loggers.retrieval CASCADE;
CREATE TRIGGER tr_update_session_on_retrieval
	AFTER INSERT OR UPDATE
	ON loggers.retrieval
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_session_on_retrieval();
-- ddl-end --

-- object: functions.fn_distribute_from_logger_import_table | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_distribute_from_logger_import_table() CASCADE;
CREATE FUNCTION functions.fn_distribute_from_logger_import_table ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF NEW.import_type = 'startup' THEN
	INSERT INTO loggers.startup 
					(logger_id,  
					startdate_gmt, 
					starttime_gmt, 
					logging_mode, 
					started_by, 
					started_where, 
					days_delayed, 
					programmed_gmt_date, 
					programmed_gmt_time)
	VALUES (NEW.logger_id,  
					NEW.startdate_gmt, 
					NEW.starttime_gmt, 
					NEW.logging_mode, 
					NEW.started_by, 
					NEW.started_where, 
					NEW.days_delayed, 
					NEW.programmed_gmt_date, 
					NEW.programmed_gmt_time);
	END IF;
	IF NEW.import_type = 'allocation' THEN
	INSERT INTO loggers.allocation 
					(logger_id,
					intended_species,
					intended_location,
					intended_deployer)
	VALUES (NEW.logger_id,
					NEW.intended_species,
					NEW.intended_location,
					NEW.intended_deployer);
	END IF;
	IF NEW.import_type = 'deployment' THEN
	INSERT INTO loggers.deployment
				(logger_id,
				individ_id,
				logger_fate,
				deployment_species,
				deployment_location,
				deployment_date,
				logger_mount_method)
	VALUES (NEW.logger_id,
				NEW.individ_id,
				NEW.logger_fate,
				NEW.deployment_species,
				NEW.deployment_location,
				NEW.deployment_date,
				NEW.logger_mount_method);
	END IF;
	IF NEW.import_type = 'retrieval' THEN
		INSERT INTO loggers.retrieval
					(attribute_name,
					logger_id,
					individ_id,
					retrieval_type,
					retrieval_location,
					retrieval_date)
		VALUES (NEW.attribute_name,
					NEW.logger_id,
					NEW.individ_id,
					NEW.retrieval_type,
					NEW.retrieval_location,
					NEW.retrieval_date);
		END IF;
	IF NEW.import_type = 'status' THEN
		INSERT INTO individuals.individ_status
					(logger_id,
					weight,
					scull,
					tarsus,
					wing,
					breeding_stage,
					eggs,
					chicks,
					hatching_success,
					breeding_success,
					breeding_success_criterion,
					data_responsible,
					back_on_nest,
					"comment",
					"location")
	VALUES (NEW.logger_id,
					NEW.weight,
					NEW.scull,
					NEW.tarsus,
					NEW.wing,
					NEW.breeding_stage,
					NEW.eggs,
					NEW.chicks,
					NEW.hatching_success,
					NEW.breeding_success,
					NEW.breeding_success_criterion,
					NEW.data_responsible,
					NEW.back_on_nest_date,
					NEW."comment",
					NEW.observation_location);
	END IF;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_distribute_from_logger_import_table() OWNER TO seatrack_admin;
-- ddl-end --

-- object: functions.fn_check_open_session_on_allocation | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_open_session_on_allocation() CASCADE;
CREATE FUNCTION functions.fn_check_open_session_on_allocation ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
		IF bool_and(logging_session.logger_id != NEW.logger_id) 
			FROM loggers.logging_session
			THEN
			RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding allocation data', NEW.logger_id;
		END IF;

		IF bool_and(logging_session.active = FALSE)
			FROM loggers.logging_session
			WHERE logging_session.logger_id = NEW.logger_id
		THEN
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding allocation data', NEW.logger_id;
	END IF;

	NEW.session_id := logging_session.session_id
	FROM loggers.logging_session
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_allocation() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_check_open_session_on_allocation | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_open_session_on_allocation ON loggers.allocation CASCADE;
CREATE TRIGGER tr_check_open_session_on_allocation
	BEFORE INSERT OR UPDATE
	ON loggers.allocation
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_open_session_on_allocation();
-- ddl-end --

-- object: functions.fn_check_open_session_on_status | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_open_session_on_status() CASCADE;
CREATE FUNCTION functions.fn_check_open_session_on_status ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
		IF bool_and(logging_session.logger_id != NEW.logger_id) 
			FROM loggers.logging_session
			THEN
			RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding status data', NEW.logger_id;
		END IF;

		IF bool_and(logging_session.active = FALSE)
			FROM loggers.logging_session
			WHERE logging_session.logger_id = NEW.logger_id
		THEN
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding status data', NEW.logger_id;
	END IF;

	NEW.session_id := logging_session.session_id
	FROM loggers.logging_session
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_status() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_check_open_session_on_status | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_open_session_on_status ON individuals.individ_status CASCADE;
CREATE TRIGGER tr_check_open_session_on_status
	BEFORE INSERT OR UPDATE
	ON individuals.individ_status
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_open_session_on_status();
-- ddl-end --

-- object: metadata.breeding_stages | type: TABLE --
-- DROP TABLE IF EXISTS metadata.breeding_stages CASCADE;
CREATE TABLE metadata.breeding_stages(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	breeding_stage text NOT NULL,
	CONSTRAINT breeding_stage_uq UNIQUE (breeding_stage),
	CONSTRAINT breeding_stages_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE metadata.breeding_stages OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_distribute_import | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_distribute_import ON imports.logger_import CASCADE;
CREATE TRIGGER tr_distribute_import
	AFTER INSERT 
	ON imports.logger_import
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_distribute_from_logger_import_table();
-- ddl-end --

-- object: functions.fn_delete_rows_from_import | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_delete_rows_from_import() CASCADE;
CREATE FUNCTION functions.fn_delete_rows_from_import ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	DELETE FROM imports.logger_import 
	WHERE imports.id = NEW.id;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_delete_rows_from_import() OWNER TO seatrack_admin;
-- ddl-end --

-- object: views.closed_sessions_not_shutdown | type: VIEW --
-- DROP VIEW IF EXISTS views.closed_sessions_not_shutdown CASCADE;
CREATE VIEW views.closed_sessions_not_shutdown
AS 

SELECT l.session_id, l.logger_id, l.year_tracked
FROM loggers.logging_session l left join loggers.shutdown s
ON l.session_id = s.session_id
WHERE s.session_id IS NULL;
-- ddl-end --
ALTER VIEW views.closed_sessions_not_shutdown OWNER TO seatrack_admin;
-- ddl-end --

-- object: metadata.logger_files | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logger_files CASCADE;
CREATE TABLE metadata.logger_files(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_model text NOT NULL,
	file_basename text NOT NULL,
	CONSTRAINT logger_files_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE metadata.logger_files IS 'Reference table that specifies what files are created by which logger model';
-- ddl-end --
COMMENT ON COLUMN metadata.logger_files.file_basename IS 'base of filetype to be used as appendix on filename';
-- ddl-end --
ALTER TABLE metadata.logger_files OWNER TO seatrack_admin;
-- ddl-end --

INSERT INTO metadata.logger_files (id, logger_model, file_basename) VALUES (DEFAULT, E'testmodel', E'result1.txt');
-- ddl-end --
INSERT INTO metadata.logger_files (id, logger_model, file_basename) VALUES (DEFAULT, E'testmodel', E'result2.csv');
-- ddl-end --

-- object: functions.fn_create_filenames_on_shutdown | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_create_filenames_on_shutdown() CASCADE;
CREATE FUNCTION functions.fn_create_filenames_on_shutdown ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
	WITH foo as (SELECT s.session_id, s.logger_id, l.logger_model, f.file_basename 	
			FROM  loggers.logging_session s INNER JOIN loggers.logger_info l ON s.logger_id = l.logger_id
			INNER JOIN metadata.logger_files f ON l.logger_model = f.logger_model
					)
	INSERT INTO loggers.file_archive (session_id, filename)
		SELECT foo.session_id, 's' || foo.session_id || '_' || foo.file_basename
			FROM foo
			WHERE foo.session_id = NEW.session_id;
	RETURN NULL;
	ELSEIF (TG_OP = 'UPDATE') THEN
		WITH foo as (SELECT s.session_id, s.logger_id, l.logger_model, f.file_basename 	
			FROM  loggers.logging_session s INNER JOIN loggers.logger_info l ON s.logger_id = l.logger_id
			INNER JOIN metadata.logger_files f ON l.logger_model = f.logger_model
					)
			UPDATE loggers.file_archive SET
			session_id = foo.session_id,
			filename = 's' || foo.session_id || '_' || foo.file_basename
			FROM foo
			WHERE NEW.session_id = file_archive.session_id;
	RETURN NULL;
	END IF;
RETURN NULL;

END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_create_filenames_on_shutdown() OWNER TO seatrack_admin;
-- ddl-end --

-- object: tr_create_filenames_on_shutdown | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_create_filenames_on_shutdown ON loggers.shutdown CASCADE;
CREATE TRIGGER tr_create_filenames_on_shutdown
	AFTER INSERT OR UPDATE
	ON loggers.shutdown
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_create_filenames_on_shutdown();
-- ddl-end --

-- object: logging_session_session_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS loggers.logging_session_session_id_idx CASCADE;
CREATE INDEX logging_session_session_id_idx ON loggers.logging_session
	USING btree
	(
	  session_id
	);
-- ddl-end --

-- object: logging_session_logger_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS loggers.logging_session_logger_id_idx CASCADE;
CREATE INDEX logging_session_logger_id_idx ON loggers.logging_session
	USING btree
	(
	  logger_id
	);
-- ddl-end --

-- object: ls_active_idx | type: INDEX --
-- DROP INDEX IF EXISTS loggers.ls_active_idx CASCADE;
CREATE INDEX ls_active_idx ON loggers.logging_session
	USING btree
	(
	  active
	);
-- ddl-end --

-- object: ls_colony_idx | type: INDEX --
-- DROP INDEX IF EXISTS loggers.ls_colony_idx CASCADE;
CREATE INDEX ls_colony_idx ON loggers.logging_session
	USING btree
	(
	  colony
	);
-- ddl-end --

-- object: ls_species_idx | type: INDEX --
-- DROP INDEX IF EXISTS loggers.ls_species_idx CASCADE;
CREATE INDEX ls_species_idx ON loggers.logging_session
	USING btree
	(
	  species
	);
-- ddl-end --

-- object: ls_year_tracked_idx | type: INDEX --
-- DROP INDEX IF EXISTS loggers.ls_year_tracked_idx CASCADE;
CREATE INDEX ls_year_tracked_idx ON loggers.logging_session
	USING btree
	(
	  year_tracked
	);
-- ddl-end --

-- object: ls_individ_idx | type: INDEX --
-- DROP INDEX IF EXISTS loggers.ls_individ_idx CASCADE;
CREATE INDEX ls_individ_idx ON loggers.logging_session
	USING btree
	(
	  individ_id
	);
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

-- object: allocation_people_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.allocation DROP CONSTRAINT IF EXISTS allocation_people_fk CASCADE;
ALTER TABLE loggers.allocation ADD CONSTRAINT allocation_people_fk FOREIGN KEY (intended_deployer)
REFERENCES metadata.people (name) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: allocation_logger_id_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.allocation DROP CONSTRAINT IF EXISTS allocation_logger_id_fk CASCADE;
ALTER TABLE loggers.allocation ADD CONSTRAINT allocation_logger_id_fk FOREIGN KEY (logger_id)
REFERENCES loggers.logger_info (logger_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
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

-- object: logging_session_individ_id_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logging_session DROP CONSTRAINT IF EXISTS logging_session_individ_id_fk CASCADE;
ALTER TABLE loggers.logging_session ADD CONSTRAINT logging_session_individ_id_fk FOREIGN KEY (individ_id)
REFERENCES individuals.individ_info (individ_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logging_session_logger_id_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logging_session DROP CONSTRAINT IF EXISTS logging_session_logger_id_fk CASCADE;
ALTER TABLE loggers.logging_session ADD CONSTRAINT logging_session_logger_id_fk FOREIGN KEY (logger_id)
REFERENCES loggers.logger_info (logger_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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
ALTER TABLE loggers.deployment ADD CONSTRAINT species_fk FOREIGN KEY (deployment_species)
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

-- object: deployment_logger_mount_method_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS deployment_logger_mount_method_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT deployment_logger_mount_method_fk FOREIGN KEY (logger_mount_method)
REFERENCES metadata.mounting_types (logger_mount_method) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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

-- object: status_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS status_logging_session_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT status_logging_session_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: status_logger_id_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS status_logger_id_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT status_logger_id_fk FOREIGN KEY (logger_id)
REFERENCES loggers.logger_info (logger_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: status_breeding_stage_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS status_breeding_stage_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT status_breeding_stage_fk FOREIGN KEY (breeding_stage)
REFERENCES metadata.breeding_stages (breeding_stage) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
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

-- object: import_type_fk | type: CONSTRAINT --
-- ALTER TABLE imports.logger_import DROP CONSTRAINT IF EXISTS import_type_fk CASCADE;
ALTER TABLE imports.logger_import ADD CONSTRAINT import_type_fk FOREIGN KEY (import_type)
REFERENCES metadata.import_types (import_type) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: status_location_fk | type: CONSTRAINT --
-- ALTER TABLE imports.logger_import DROP CONSTRAINT IF EXISTS status_location_fk CASCADE;
ALTER TABLE imports.logger_import ADD CONSTRAINT status_location_fk FOREIGN KEY (observation_location)
REFERENCES metadata.location (location_name) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: observation_metalring_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.observations DROP CONSTRAINT IF EXISTS observation_metalring_fk CASCADE;
ALTER TABLE individuals.observations ADD CONSTRAINT observation_metalring_fk FOREIGN KEY (metalring_id)
REFERENCES individuals.individ_info (metalring_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logger_model_fk | type: CONSTRAINT --
-- ALTER TABLE metadata.logger_files DROP CONSTRAINT IF EXISTS logger_model_fk CASCADE;
ALTER TABLE metadata.logger_files ADD CONSTRAINT logger_model_fk FOREIGN KEY (logger_model)
REFERENCES metadata.logger_models (model) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: grant_d86408c45d | type: PERMISSION --
GRANT CREATE,CONNECT,TEMPORARY
   ON DATABASE seatrack
   TO seatrack_admin WITH GRANT OPTION;
-- ddl-end --

-- object: grant_8fcd29b876 | type: PERMISSION --
GRANT CONNECT
   ON DATABASE seatrack
   TO seatrack_reader;
-- ddl-end --

-- object: grant_3256dadf00 | type: PERMISSION --
GRANT CONNECT
   ON DATABASE seatrack
   TO seatrack_writer;
-- ddl-end --


-- Appended SQL commands --
GRANT SELECT
ON ALL TABLES IN SCHEMA loggers
TO seatrack_reader;

GRANT SELECT
ON ALL TABLES IN SCHEMA metadata
TO seatrack_reader;

GRANT SELECT
ON ALL TABLES IN SCHEMA individuals
TO seatrack_reader;

GRANT SELECT
ON ALL TABLES IN SCHEMA views
TO seatrack_reader;

GRANT SELECT
ON ALL TABLES IN SCHEMA positions
TO seatrack_reader;


GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA loggers
TO seatrack_admin;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA metadata
TO seatrack_admin;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA individuals
TO seatrack_admin;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA views
TO seatrack_admin;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA positions
TO seatrack_admin;

---
