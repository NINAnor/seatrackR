-- Prepended SQL commands --
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "adminpack";
CREATE EXTENSION IF NOT EXISTS "tsm_system_rows";
---

-- Database generated with pgModeler (PostgreSQL Database Modeler).
-- pgModeler  version: 0.9.0
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
CREATE ROLE seatrack_writer WITH 
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: admin | type: ROLE --
-- DROP ROLE IF EXISTS admin;

-- Prepended SQL commands --


-- ddl-end --

CREATE ROLE admin WITH 
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

-- object: shinyuser | type: ROLE --
-- DROP ROLE IF EXISTS shinyuser;
CREATE ROLE shinyuser WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'shinyuser'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: seatrack_metadata_writer | type: ROLE --
-- DROP ROLE IF EXISTS seatrack_metadata_writer;
CREATE ROLE seatrack_metadata_writer WITH 
	IN ROLE seatrack_writer;
-- ddl-end --

-- object: testwriter | type: ROLE --
-- DROP ROLE IF EXISTS testwriter;
CREATE ROLE testwriter WITH 
	LOGIN
	ENCRYPTED PASSWORD 'testwriter'
	IN ROLE seatrack_metadata_writer,seatrack_writer;
-- ddl-end --

-- object: jens_astrom | type: ROLE --
-- DROP ROLE IF EXISTS jens_astrom;
CREATE ROLE jens_astrom WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'jens_astrom'
	IN ROLE admin;
-- ddl-end --

-- object: vegard_braathen | type: ROLE --
-- DROP ROLE IF EXISTS vegard_braathen;
CREATE ROLE vegard_braathen WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'vegard_braathen'
	IN ROLE seatrack_writer;
-- ddl-end --

-- object: halfdan_helgason | type: ROLE --
-- DROP ROLE IF EXISTS halfdan_helgason;
CREATE ROLE halfdan_helgason WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'halfdan_helgason';
-- ddl-end --

-- object: borge_moe | type: ROLE --
-- DROP ROLE IF EXISTS borge_moe;
CREATE ROLE borge_moe WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'borge_moe'
	IN ROLE seatrack_writer;
-- ddl-end --

-- object: hallvard_strom | type: ROLE --
-- DROP ROLE IF EXISTS hallvard_strom;
CREATE ROLE hallvard_strom WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'hallvard_strom'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: sebastien_descamps | type: ROLE --
-- DROP ROLE IF EXISTS sebastien_descamps;
CREATE ROLE sebastien_descamps WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'sebastien_descamps'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: benjamin_merkel | type: ROLE --
-- DROP ROLE IF EXISTS benjamin_merkel;
CREATE ROLE benjamin_merkel WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'benjamin_merkel'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: conrad_helgeland | type: ROLE --
-- DROP ROLE IF EXISTS conrad_helgeland;
CREATE ROLE conrad_helgeland WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'conrad_helgeland'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: per_fauchald | type: ROLE --
-- DROP ROLE IF EXISTS per_fauchald;
CREATE ROLE per_fauchald WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'per_fauchald'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: arnaud_tarroux | type: ROLE --
-- DROP ROLE IF EXISTS arnaud_tarroux;
CREATE ROLE arnaud_tarroux WITH 
	INHERIT
	LOGIN
	ENCRYPTED PASSWORD 'arnaud_tarroux'
	IN ROLE seatrack_reader;
-- ddl-end --

-- object: pure_ftp | type: ROLE --
-- DROP ROLE IF EXISTS pure_ftp;
CREATE ROLE pure_ftp WITH 
	LOGIN
	ENCRYPTED PASSWORD 'aRw8GEF6';
-- ddl-end --

-- object: restricted | type: ROLE --
-- DROP ROLE IF EXISTS restricted;
CREATE ROLE restricted WITH 
	ADMIN pure_ftp;
-- ddl-end --

-- Tablespaces creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: temp | type: TABLESPACE --
-- -- DROP TABLESPACE IF EXISTS temp CASCADE;
-- CREATE TABLESPACE temp
-- 	OWNER postgres
-- 	LOCATION '/data';
-- -- ddl-end --
-- 


-- Database creation must be done outside an multicommand file.
-- These commands were put in this file only for convenience.
-- -- object: seatrack | type: DATABASE --
-- -- DROP DATABASE IF EXISTS seatrack;
-- CREATE DATABASE seatrack
-- 	TEMPLATE = template0
-- 	ENCODING = 'UTF8'
-- 	LC_COLLATE = 'en_US.UTF-8'
-- 	LC_CTYPE = 'en_US.UTF-8'
-- 	OWNER = admin
-- ;
-- -- ddl-end --
-- 

-- object: config | type: SCHEMA --
-- DROP SCHEMA IF EXISTS config CASCADE;
CREATE SCHEMA config;
-- ddl-end --
ALTER SCHEMA config OWNER TO admin;
-- ddl-end --

-- object: metadata | type: SCHEMA --
-- DROP SCHEMA IF EXISTS metadata CASCADE;
CREATE SCHEMA metadata;
-- ddl-end --
ALTER SCHEMA metadata OWNER TO admin;
-- ddl-end --

-- object: loggers | type: SCHEMA --
-- DROP SCHEMA IF EXISTS loggers CASCADE;
CREATE SCHEMA loggers;
-- ddl-end --
ALTER SCHEMA loggers OWNER TO admin;
-- ddl-end --

-- object: individuals | type: SCHEMA --
-- DROP SCHEMA IF EXISTS individuals CASCADE;
CREATE SCHEMA individuals;
-- ddl-end --
ALTER SCHEMA individuals OWNER TO admin;
-- ddl-end --

-- object: positions | type: SCHEMA --
-- DROP SCHEMA IF EXISTS positions CASCADE;
CREATE SCHEMA positions;
-- ddl-end --
ALTER SCHEMA positions OWNER TO admin;
-- ddl-end --

-- object: activity | type: SCHEMA --
-- DROP SCHEMA IF EXISTS activity CASCADE;
CREATE SCHEMA activity;
-- ddl-end --
ALTER SCHEMA activity OWNER TO admin;
-- ddl-end --

-- object: views | type: SCHEMA --
-- DROP SCHEMA IF EXISTS views CASCADE;
CREATE SCHEMA views;
-- ddl-end --
ALTER SCHEMA views OWNER TO admin;
-- ddl-end --

-- object: functions | type: SCHEMA --
-- DROP SCHEMA IF EXISTS functions CASCADE;
CREATE SCHEMA functions;
-- ddl-end --
ALTER SCHEMA functions OWNER TO admin;
-- ddl-end --

-- object: imports | type: SCHEMA --
-- DROP SCHEMA IF EXISTS imports CASCADE;
CREATE SCHEMA imports;
-- ddl-end --
ALTER SCHEMA imports OWNER TO admin;
-- ddl-end --

-- object: seatrack | type: SCHEMA --
-- DROP SCHEMA IF EXISTS seatrack CASCADE;
CREATE SCHEMA seatrack;
-- ddl-end --
ALTER SCHEMA seatrack OWNER TO postgres;
-- ddl-end --
COMMENT ON SCHEMA seatrack IS 'temporary for importing from existing database';
-- ddl-end --

-- object: restricted | type: SCHEMA --
-- DROP SCHEMA IF EXISTS restricted CASCADE;
CREATE SCHEMA restricted;
-- ddl-end --
ALTER SCHEMA restricted OWNER TO admin;
-- ddl-end --

SET search_path TO pg_catalog,public,config,metadata,loggers,individuals,positions,activity,views,functions,imports,seatrack,restricted;
-- ddl-end --

-- object: loggers.logger_info | type: TABLE --
-- DROP TABLE IF EXISTS loggers.logger_info CASCADE;
CREATE TABLE loggers.logger_info(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_id serial NOT NULL,
	logger_serial_no text NOT NULL,
	logger_model text NOT NULL,
	producer text NOT NULL,
	production_year smallint NOT NULL,
	project text,
	CONSTRAINT logger_info_pk PRIMARY KEY (id),
	CONSTRAINT logger_id_unique UNIQUE (logger_id),
	CONSTRAINT logger_mod_serial_uq UNIQUE (logger_model,logger_serial_no)

);
-- ddl-end --
ALTER TABLE loggers.logger_info OWNER TO admin;
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
ALTER TABLE metadata.logger_producers OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.logger_producers (id, producer) VALUES (DEFAULT, E'testproducer');
-- ddl-end --
INSERT INTO metadata.logger_producers (id, producer) VALUES (DEFAULT, E'Migrate Technology');
-- ddl-end --
INSERT INTO metadata.logger_producers (id, producer) VALUES (DEFAULT, E'Biotrack');
-- ddl-end --
INSERT INTO metadata.logger_producers (id, producer) VALUES (DEFAULT, E'BAS');
-- ddl-end --
INSERT INTO metadata.logger_producers (id, producer) VALUES (DEFAULT, E'LOTEK');
-- ddl-end --
INSERT INTO metadata.logger_producers (id, producer) VALUES (DEFAULT, E'UNKNOWN');
-- ddl-end --

-- object: metadata.logger_models | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logger_models CASCADE;
CREATE TABLE metadata.logger_models(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	producer text NOT NULL,
	model text NOT NULL,
	CONSTRAINT logger_models_pk PRIMARY KEY (id),
	CONSTRAINT model_unique UNIQUE (producer,model)

);
-- ddl-end --
ALTER TABLE metadata.logger_models OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'testproducer', E'testmodel');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Migrate Technology', E'c330');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Migrate Technology', E'f100');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Migrate Technology', E'c250');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Migrate Technology', E'c65');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Migrate Technology', E'w65');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Biotrack', E'mk3005');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Biotrack', E'mk3006');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Biotrack', E'mk4083');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'Biotrack', E'mk4093');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'BAS', E'mk9');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'BAS', E'mk13');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'BAS', E'mk14');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'BAS', E'mk15');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'BAS', E'mk18');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'BAS', E'mk4');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'LOTEK', E'LAT');
-- ddl-end --
INSERT INTO metadata.logger_models (id, producer, model) VALUES (DEFAULT, E'UNKNOWN', E'other');
-- ddl-end --

-- object: metadata.logging_modes | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logging_modes CASCADE;
CREATE TABLE metadata.logging_modes(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	mode text NOT NULL,
	clipped_lightrange boolean,
	CONSTRAINT logging_modes_pk PRIMARY KEY (id),
	CONSTRAINT logging_modes_unique UNIQUE (mode)

);
-- ddl-end --
ALTER TABLE metadata.logging_modes OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'testmode', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'1', E'T');
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'2', E'F');
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'3', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'4', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'5', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'6', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'7', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'8', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'9', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'10', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'11', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'12', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'13', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'14', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logging_modes (id, mode, clipped_lightrange) VALUES (DEFAULT, E'15', DEFAULT);
-- ddl-end --

-- object: metadata.people | type: TABLE --
-- DROP TABLE IF EXISTS metadata.people CASCADE;
CREATE TABLE metadata.people(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	name text NOT NULL,
	person_id serial NOT NULL,
	abrev_name text NOT NULL,
	CONSTRAINT people_pk PRIMARY KEY (id),
	CONSTRAINT names_unique UNIQUE (name),
	CONSTRAINT person_id_uq UNIQUE (person_id)

);
-- ddl-end --
ALTER TABLE metadata.people OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Alexei Ezhov', E'A_Ezhov', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Arild Breistøl', E'A_Breistøl', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Arne Follestad', E'A_Follestad', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Arnt Kvinnesland', E'A_Kvinnesland', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Oskar Bjørnstad', E'O_Bjørnstad', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Bergur Olsen', E'B_Olsen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Børge Moe', E'B_Moe', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Olivier Chastel', E'O_Chastel', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Dorothee Ehrlich', E'D_Ehrlich', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Ekaterina Tolmacheva', E'E_Tolmacheva', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Erlend Lorentzen', E'E_Lorentzen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Erpur Snær Hansen', E'ES_Hansen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Francis Daunt', E'F_Daunt', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Geir Helge Systad', E'GH_Systad', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Grigori Tertitski', E'G_Tertitski', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Hallvard Strøm', E'H_Strøm', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Ingar Støyle Bringsvor', E'IS_Bringsvor', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Ingve Birkeland', E'I_Birkeland', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Jan Ove Bustnes', E'JO_Bustnes', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Johannis Danielsen', E'J_Danielsen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Jón Einar Jónsson', E'JE_Jónsson', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Kjell Einar Erikstad', E'KE_Erikstad', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Magdalene Langset', E'M_Langset', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Maria Gavrilo', E'M_Gavrilo', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Morten Helberg', E'M_Helberg', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Paul Thompson', E'P_Thompson', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Runar Jåbekk', E'R_Jåbekk', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Sebastien Descamps', E'S_Descamps', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Signe Christensen-Dalsgaard', E'S_Christensen-Dalsgaard', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Sunna Bjork Ragnarsdottir', E'SB_Ragnarsdottir', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Gunnar Thor Hallgrimsson', E'GT_Hallgrimsson', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Svein-Håkon Lorentsen', E'SH_Lorentsen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Olav Runde', E'O_Runde', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Sveinn Are Hanssen', E'SA_Hanssen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Thorkell Lindberg Thorarinsson', E'TL_Thórarinsson', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Tycho Anker-Nilssen', E'T_Anker-Nilssen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Vegard Finset', E'V_Finset', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Vegard Sandøy Bråthen', E'VS_Bråthen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Per Fauchald', E'P_Fauchald', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Hálfdán Helgi Helgason', E'HH_Helgason', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Benjamin Merkel', E'B_Merkel', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Tim Guilford', E'T_Guilford', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Morten Frederiksen', E'M_Frederiksen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Lorrain Chivers', E'L_Chivers', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Sara Wanless', E'S_Wanless', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Maria Bogdanova', E'M_Bogdanova', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Jacob', E'J_González-Solís', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Deryk Shaw', E'D_Shaw', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Yuri V Krasnov', E'Y_Krasnov', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Thierry Boulinier', E'T_Boulinier', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Sabrina Tartu', E'S_Tartu', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Tone Reiertsen', E'T_Reiertsen', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Aurore Ponchon', E'A_Ponchon', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Michael P Harris', E'MP_Harris', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Celine Clement Chastel', E'CC_Chastel', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Rob T Barret', E'RT_Barret', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Pierre Blevin', E'P_Blevin', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Frederic Angelier', E'F_Angelier', DEFAULT, DEFAULT);
-- ddl-end --
INSERT INTO metadata.people (name, abrev_name, id, person_id) VALUES (E'Jens Åström', E'J_Åström', DEFAULT, DEFAULT);
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
ALTER TABLE loggers.allocation OWNER TO admin;
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
	individ_id uuid,
	last_updated timestamp,
	updated_by text,
	CONSTRAINT logging_session_pk PRIMARY KEY (id),
	CONSTRAINT logging_session_session_id_unique UNIQUE (session_id),
	CONSTRAINT retrieval_id UNIQUE (retrieval_id),
	CONSTRAINT deployment_id UNIQUE (deployment_id)

);
-- ddl-end --
ALTER TABLE loggers.logging_session OWNER TO admin;
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
ALTER TABLE metadata.species OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Common guillemot', E'Uria aalge', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Brünnich''s guillemot', E'Uria lomvia', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Little auk', E'Alle alle', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Atlantic puffin', E'Fratercula arctica', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Black-legged kittiwake', E'Rissa tridactyla', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Northern fulmar', E'Fulmarus glacialis', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Lesser black-backed gull', E'Larus fuscus', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Herring gull', E'Larus argentatus', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Glaucous gull', E'Larus hyperboreus', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'European shag', E'Phalacrocorax aristotelis', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'Common eider', E'Somateria mollissima', DEFAULT);
-- ddl-end --
INSERT INTO metadata.species (species_name_eng, species_name_latin, id) VALUES (E'testspecies', E'Testus specius', DEFAULT);
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
ALTER TABLE metadata.colony OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'62.436', E'5.874', E'Runde and Aalesund', E'Runde and Ålesund');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'69.065', E'15.170', E'Anda', E'Anda');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'74.503', E'18.956', E'Bear Island', E'Bjørnøya');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'69.635', E'18.848', E'Grindoya', E'Grindøya');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'71.113', E'24.732', E'Hjelmsoya', E'Hjelmsøya');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'60.668', E'4.749', E'Hordaland', E'Hordaland');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'70.383', E'31.150', E'Hornoya', E'Hornøya');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'78.253', E'15.508', E'Isfjorden', E'Isfjorden');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'70.921', E'-8.718', E'Jan Mayen', E'Jan Mayen');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'67.447', E'11.910', E'Rost', E'Røst');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'66.585', E'12.229', E'Selvaer', E'Selvær');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65.320', E'11.630', E'Horsvaer', E'Horsvær');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65.202', E'10.995', E'Sklinna', E'Sklinna');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'78.900', E'12.217', E'Kongsfjorden', E'Kongsfjorden');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'69.031', E'16.905', E'Lemmingsvaer', E'Lemmingsvær');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'70.358', E'21.398', E'Loppa', E'Loppa');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'58.008', E'7.368', E'Mandal and Lindesnes', E'Mandal and Lindesnes');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'79.585', E'18.459', E'Alkefjellet', E'Alkefjellet');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'59.150', E'5.174', E'Jarsteinen', E'Jarsteinen');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65.081', E'-22.740', E'Breidafjordur', E'Breiðafjörður');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65.004', E'-23.368', E'Melrakkaey', E'Melrakkaey');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'63.968', E'-22.221', E'Reykjanes', E'Reykjanes');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'66.180', E'-15.985', E'Langanes and Skjalfandi', E'Langanes and Skjálfandi');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'66.529', E'-17.992', E'Grimsey', E'Grímsey');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65.707', E'-18.135', E'Eyjafjordur', E'Eyjafjörður');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'64.588', E'-14.172', E'Papey', E'Papey');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'61.950', E'-6.798', E'Faroe Islands', E'Føroyar');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'56.186', E'-2.558', E'Isle of May', E'Isle of May');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'59.142', E'-3.115', E'Eynhallow', E'Eynhallow');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'80.144', E'51.468', E'Franz Josef Land', E'Zemlya Frantsa-Iosifa');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'69.583', E'32.937', E'Cape Gorodetskiy', E'Gorodetskye ptich`i bazary');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'69.151', E'35.948', E'Cape Krutik', E'Mys Krutik');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'68.748', E'37.570', E'Seven Islands', E'Sem'' Ostrovov');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'77.069', E'67.642', E'Oranskie Islands', E'Oranskie Ostrova');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'70.593', E'55.021', E'Cape Sakhanin', E'Mys Sakhanina');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65.048', E'35.786', E'Solovetsky archipelago', E'Solovetskiye Ostrova');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'77.000', E'15.550', E'Hornsund', E'Hornsund');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65.54', E'-13.78', E'Hafnarholmi', E'Hafnarhólmi');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'57.158259', E'9.025082', E'Bulbjerg', E'Bulbjerg');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'59.512853', E'-1.650526', E'Fair Isle', E'Fair Isle');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'64.1716', E'9.4078', E'Halten', E'Halten');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'73.716698', E'-56.6633301', E'Kippaku', E'Kippaku');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'55.29777', E'-6.28041', E'Rathlin', E'Rathlin');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'51.737687', E'-5.300236', E'Skomer', E'Skomer');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'69.8', E'-51.21', E'Ritenbenk', E'Ritenbenk');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'64.6522', E'-50.59185', E'Nuuk', E'Nuuk');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'70.68996946', E'23.5989887', E'Melkoya', E'Melkøya');
-- ddl-end --
INSERT INTO metadata.colony (lat, lon, colony_int_name, colony_nat_name) VALUES (E'65', E'10', E'testcolony', E'testcolonü');
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
	CONSTRAINT location_unique UNIQUE (location_name)

);
-- ddl-end --
ALTER TABLE metadata.location OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Ærvikurbjarg', E'Langanes and Skjalfandi', E'Langanes and Skjálfandi', E'70.92056', E'-8.71778');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Agneskjær', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Alkefjellet', E'Alkefjellet', E'Alkefjellet', E'60.66761', E'4.74869');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Anda', E'Anda', E'Anda', E'62.40000', E'5.62000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Båly', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Bjørndalen', E'Isfjorden', E'Isfjorden', E'74.36450', E'19.14751');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Bjørnøya', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Cape Flora', E'Franz Josef Land', E'Zemlya Frantsa-Iosifa', E'64.74000', E'10.77000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Cape Krutik', E'Cape Krutik', E'Mys Krutik', E'78.94400', E'12.43900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Diabas', E'Isfjorden', E'Isfjorden', E'74.36450', E'19.14751');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Dolgaya Bay', E'Solovetsky archipelago', E'Solovetskiye Ostrova', E'70.35833', E'21.39833');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Eastern Bolshie Oranskye', E'Oranskie Islands', E'Oranskie Ostrova', E'78.90000', E'12.21667');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Ellefsnyken', E'Rost', E'Røst', E'74.23110', E'19.10320');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Evjebukta', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Eyjafjordur', E'Eyjafjordur', E'Eyjafjörður', E'67.44700', E'11.91400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Eynhallow', E'Eynhallow', E'Eynhallow', E'65.20200', E'10.99500');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Feiringfjellet', E'Kongsfjorden', E'Kongsfjorden', E'69.63505', E'18.84826');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Fontur', E'Langanes and Skjalfandi', E'Langanes and Skjálfandi', E'70.92056', E'-8.71778');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Gardahraun', E'Reykjanes', E'Reykjanes', E'78.21500', E'15.27000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Gassadalur', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Glyvursnes', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Gorodetskiy Kape', E'Cape Gorodetskiy', E'Gorodetskye ptich`i bazary', E'79.00500', E'12.41100');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Grimsey', E'Grimsey', E'Grímsey', E'67.50500', E'12.07900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Grindavik', E'Reykjanes', E'Reykjanes', E'78.21500', E'15.27000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Grindøya', E'Grindoya', E'Grindøya', E'74.34257', E'19.10117');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Grumant', E'Isfjorden', E'Isfjorden', E'74.36450', E'19.14751');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Hafnarholmi', E'Hafnarholmi', E'Hafnarhólmi', E'65.54', E'-13.78');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Hårkniba', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Havnardalur', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Hernyken', E'Rost', E'Røst', E'74.23110', E'19.10320');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Hillesund', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Hjallsey', E'Breidafjordur', E'Breiðafjörður', E'78.36400', E'16.14100');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Hornøya', E'Hornoya', E'Hornøya', E'74.35122', E'19.10070');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Horsvær', E'Horsvaer', E'Horsvær', E'74.36585', E'19.14922');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Husholmen', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Isle of May', E'Isle of May', E'Isle of May', E'65.32000', E'11.63000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Jan Mayen', E'Jan Mayen', E'Jan Mayen', E'74.34665', E'19.09100');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Jarsteinen', E'Jarsteinen', E'Jarsteinen', E'70.38333', E'31.15000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Kalsvikholmen', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Kapp Kolthoff', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Kårøy', E'Rost', E'Røst', E'74.23110', E'19.10320');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Keila', E'Hjelmsoya', E'Hjelmsøya', E'74.35559', E'19.11467');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Kirkjubøholmur', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Kjorten', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Kongsfjorden', E'Kongsfjorden', E'Kongsfjorden', E'69.63505', E'18.84826');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Krægan', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Krykkjedamdalen', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Krykkjefjellet', E'Kongsfjorden', E'Kongsfjorden', E'69.63505', E'18.84826');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Laksmannen', E'Hjelmsoya', E'Hjelmsøya', E'74.35559', E'19.11467');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lamba grotbrot', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Landey', E'Breidafjordur', E'Breiðafjörður', E'78.36400', E'16.14100');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lauholmen', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Leiholmen', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lemmingsvær', E'Lemmingsvaer', E'Lemmingsvær', E'71.11291', E'24.73238');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Leynavatni', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Likkudalur', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lille Einerholmen', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lille Feitnakken', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lille Kamøya', E'Hjelmsoya', E'Hjelmsøya', E'74.35559', E'19.11467');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Litsky Maly Island', E'Seven Islands', E'Sem'' Ostrovov', E'78.89700', E'12.19300');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lonin', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Lyngøya', E'Hordaland', E'Hordaland', E'74.34703', E'19.09058');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Mandalselva Kastellet', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Matmorstua', E'Loppa', E'Loppa', E'71.10927', E'24.74736');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Mellom Lille Feitnakken og Feitnakken', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Melrakkaey', E'Melrakkaey', E'Melrakkaey', E'78.17400', E'15.12900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Merra', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Migade', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Migande N', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Mittinga', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Nordre Krægan', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'NW Sennaya island', E'Solovetsky archipelago', E'Solovetskiye Ostrova', E'70.35833', E'21.39833');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Olavskjær', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Ossian Sars', E'Kongsfjorden', E'Kongsfjorden', E'69.63505', E'18.84826');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Østre Gunningsholme', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Ostrov Bolshoy Zelenets', E'Seven Islands', E'Sem'' Ostrovov', E'78.89700', E'12.19300');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Papey', E'Papey', E'Papey', E'67.42700', E'11.88400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Parusnyi island', E'Solovetsky archipelago', E'Solovetskiye Ostrova', E'70.35833', E'21.39833');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Revdalen', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Rif', E'Breidafjordur', E'Breiðafjörður', E'78.36400', E'16.14100');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Rubini', E'Franz Josef Land', E'Zemlya Frantsa-Iosifa', E'64.74000', E'10.77000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Runde', E'Runde and Aalesund', E'Runde and Ålesund', E'62.47111', E'6.12861');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Russehamna', E'Bear Island', E'Bjørnøya', E'69.06500', E'15.17000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sakhanina Cape', E'Cape Sakhanin', E'Mys Sakhanina', E'69.03100', E'16.90500');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Saltvik', E'Langanes and Skjalfandi', E'Langanes and Skjálfandi', E'70.92056', E'-8.71778');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sandavagur litla grotbroti', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sandavagur stora grotbroti', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sandavagur timburhandilin', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sånumstranda', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Selvær', E'Selvaer', E'Selvær', E'74.34806', E'19.09142');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sennaya island', E'Solovetsky archipelago', E'Solovetskiye Ostrova', E'70.35833', E'21.39833');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sklinna', E'Sklinna', E'Sklinna', E'74.50250', E'18.95556');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Skoruvikurbjarg', E'Langanes and Skjalfandi', E'Langanes and Skjálfandi', E'70.92056', E'-8.71778');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Skugvoy', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Småholmane', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Småskjæran', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sør-Gjæslingan', E'Sklinna', E'Sklinna', E'74.50250', E'18.95556');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Stakksey', E'Breidafjordur', E'Breiðafjörður', E'78.36400', E'16.14100');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Steinsvågen', E'Runde and Aalesund', E'Runde and Ålesund', E'62.47111', E'6.12861');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Stora Dimun', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Store Torungen', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Store Vengelsholmen', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Storøy', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Storøytåa', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Storskjær', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sundi', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Svarthellaren', E'Loppa', E'Loppa', E'71.10927', E'24.74736');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sydrugøtu grotbrot', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Sydrugøtu waterfront', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Tikhaya Bay', E'Franz Josef Land', E'Zemlya Frantsa-Iosifa', E'64.74000', E'10.77000');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Veshnyak Island', E'Seven Islands', E'Sem'' Ostrovov', E'78.89700', E'12.19300');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Vestmanna', E'Faroe Islands', E'Føroyar', E'66.58500', E'12.22900');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'Vestre Røysa', E'Mandal and Lindesnes', E'Mandal and Lindesnes', E'70.84875', E'23.06400');
-- ddl-end --
INSERT INTO metadata.location (location_name, colony_int_name, colony_nat_name, lat, lon) VALUES (E'testlocation', E'testcolony', E'testcolonü', E'58.00528', E'7.44306');
-- ddl-end --

-- object: loggers.deployment | type: TABLE --
-- DROP TABLE IF EXISTS loggers.deployment CASCADE;
CREATE TABLE loggers.deployment(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
	deployment_id serial NOT NULL,
	logger_id integer NOT NULL,
	individ_id uuid NOT NULL,
	logger_fate text,
	deployment_species text,
	deployment_location text NOT NULL,
	deployment_date date NOT NULL,
	logger_mount_method text,
	CONSTRAINT deployment_pk PRIMARY KEY (id,deployment_date),
	CONSTRAINT deployment_id_unique UNIQUE (deployment_id),
	CONSTRAINT deployment_session_id_uq UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.deployment OWNER TO admin;
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
ALTER TABLE metadata.logger_fate OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'testfate');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Calibration');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Deployed');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Double tagging');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Lost');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Lost before deployment');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Redeployed');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Sent to producer');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Stored');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Stored at location');
-- ddl-end --
INSERT INTO metadata.logger_fate (id, logger_fate) VALUES (DEFAULT, E'Assigned to another project');
-- ddl-end --

-- object: individuals.individ_info | type: TABLE --
-- DROP TABLE IF EXISTS individuals.individ_info CASCADE;
CREATE TABLE individuals.individ_info(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	individ_id uuid NOT NULL DEFAULT uuid_generate_v1(),
	ring_number text,
	euring_code text,
	species text,
	color_ring text,
	morph text,
	subspecies text,
	age text,
	sex text,
	sexing_method text,
	latest_info_date date NOT NULL,
	CONSTRAINT individ_info_pk PRIMARY KEY (id),
	CONSTRAINT individ_id_uq UNIQUE (individ_id),
	CONSTRAINT metalring_uq UNIQUE (ring_number,euring_code)

);
-- ddl-end --
ALTER TABLE individuals.individ_info OWNER TO admin;
-- ddl-end --
















-- object: metadata.sex | type: TABLE --
-- DROP TABLE IF EXISTS metadata.sex CASCADE;
CREATE TABLE metadata.sex(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	sex text NOT NULL,
	CONSTRAINT sex_pk PRIMARY KEY (id),
	CONSTRAINT sex_unique UNIQUE (sex)

);
-- ddl-end --
ALTER TABLE metadata.sex OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.sex (id, sex) VALUES (DEFAULT, E'male');
-- ddl-end --
INSERT INTO metadata.sex (id, sex) VALUES (DEFAULT, E'female');
-- ddl-end --
INSERT INTO metadata.sex (id, sex) VALUES (DEFAULT, E'unknown');
-- ddl-end --

-- object: metadata.sexing_method | type: TABLE --
-- DROP TABLE IF EXISTS metadata.sexing_method CASCADE;
CREATE TABLE metadata.sexing_method(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	method text,
	CONSTRAINT sexing_method_pk PRIMARY KEY (id),
	CONSTRAINT sexing_method_unique UNIQUE (method)

);
-- ddl-end --
ALTER TABLE metadata.sexing_method OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.sexing_method (id, method) VALUES (DEFAULT, E'testmethod');
-- ddl-end --
INSERT INTO metadata.sexing_method (id, method) VALUES (DEFAULT, E'dna');
-- ddl-end --
INSERT INTO metadata.sexing_method (id, method) VALUES (DEFAULT, E'morphology');
-- ddl-end --
INSERT INTO metadata.sexing_method (id, method) VALUES (DEFAULT, E'behaviour');
-- ddl-end --
INSERT INTO metadata.sexing_method (id, method) VALUES (DEFAULT, E'none_yet');
-- ddl-end --

-- object: individuals.individ_status | type: TABLE --
-- DROP TABLE IF EXISTS individuals.individ_status CASCADE;
CREATE TABLE individuals.individ_status(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_id integer NOT NULL,
	status_date date,
	status_id serial NOT NULL,
	session_id integer,
	weight double precision,
	scull double precision,
	tarsus double precision,
	wing double precision,
	breeding_stage text,
	eggs smallint,
	chicks smallint,
	hatching_success boolean,
	breeding_success boolean,
	breeding_success_criterion text,
	data_responsible text NOT NULL,
	back_on_nest boolean,
	comment text,
	location text,
	ring_number text NOT NULL,
	euring_code text NOT NULL,
	species text,
	color_ring text,
	morph text,
	subspecies text,
	age text,
	sex text,
	sexing_method text,
	CONSTRAINT individ_status_pk PRIMARY KEY (id),
	CONSTRAINT status_id UNIQUE (status_id)

);
-- ddl-end --
ALTER TABLE individuals.individ_status OWNER TO admin;
-- ddl-end --

-- object: loggers.retrieval | type: TABLE --
-- DROP TABLE IF EXISTS loggers.retrieval CASCADE;
CREATE TABLE loggers.retrieval(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
	retrieval_id serial NOT NULL,
	attribute_name text,
	logger_id integer NOT NULL,
	individ_id uuid NOT NULL,
	retrieval_type text,
	retrieval_location text,
	retrieval_date date NOT NULL,
	CONSTRAINT retrieval_pk PRIMARY KEY (id,retrieval_date),
	CONSTRAINT retrieval_id_unique UNIQUE (retrieval_id),
	CONSTRAINT retrieval_session_id_uq UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.retrieval OWNER TO admin;
-- ddl-end --

-- object: loggers.shutdown | type: TABLE --
-- DROP TABLE IF EXISTS loggers.shutdown CASCADE;
CREATE TABLE loggers.shutdown(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
	download_type text NOT NULL,
	download_date date,
	field_status text,
	downloaded_by text,
	decomissioned boolean,
	shutdown_date date,
	CONSTRAINT shutdown_pk PRIMARY KEY (id),
	CONSTRAINT shutdown_session_id_unique UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.shutdown OWNER TO admin;
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
ALTER TABLE loggers.file_archive OWNER TO admin;
-- ddl-end --

-- object: positions.postable | type: TABLE --
-- DROP TABLE IF EXISTS positions.postable CASCADE;
CREATE TABLE positions.postable(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	date_time timestamp(0) NOT NULL,
	logger text NOT NULL,
	logger_id text NOT NULL,
	logger_model text NOT NULL,
	year_tracked text NOT NULL,
	session_id integer,
	year_deployed integer NOT NULL,
	year_retrieved integer NOT NULL,
	ring_number text,
	euring_code text,
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
	tfirst timestamp(0),
	tsecond timestamp(0),
	twl_type smallint,
	conf smallint,
	sun double precision,
	software text,
	light_threshold smallint,
	analyzer text,
	data_responsible text,
	logger_yeartracked text,
	posdata_file text,
	import_date date,
	data_version integer DEFAULT 1,
	database_version integer DEFAULT 2,
	CONSTRAINT postable_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE positions.postable OWNER TO admin;
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
	trn_file text,
	processing_file text,
	posdata_file text,
	logger_download_success boolean,
	logger_date_failed boolean,
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
ALTER TABLE positions.processing OWNER TO admin;
-- ddl-end --

-- object: metadata.subspecies | type: TABLE --
-- DROP TABLE IF EXISTS metadata.subspecies CASCADE;
CREATE TABLE metadata.subspecies(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	species_name_eng text NOT NULL,
	species_name_latin text NOT NULL,
	sub_species text,
	CONSTRAINT subspecies_pk PRIMARY KEY (id),
	CONSTRAINT species_uq UNIQUE (sub_species,species_name_eng),
	CONSTRAINT species_latin_subspecies_uq UNIQUE (species_name_latin,sub_species)

);
-- ddl-end --
COMMENT ON CONSTRAINT species_uq ON metadata.subspecies  IS 'Might not be necessarily unique?';
-- ddl-end --
ALTER TABLE metadata.subspecies OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Uria aalge', DEFAULT, DEFAULT, E'Common guillemot');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Uria lomvia', DEFAULT, DEFAULT, E'Brünnich''s guillemot');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Alle alle', E'Alle alle alle', DEFAULT, E'Little auk');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Alle alle', E'Alle alle polaris', DEFAULT, E'Little auk');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Fratercula arctica', DEFAULT, DEFAULT, E'Atlantic puffin');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Rissa tridactyla', DEFAULT, DEFAULT, E'Black-legged kittiwake');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Fulmarus glacialis', DEFAULT, DEFAULT, E'Northern fulmar');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Larus fuscus', E'Larus fuscus intermedius', DEFAULT, E'Lesser black-backed gull');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Larus fuscus', E'Larus fuscus fuscus', DEFAULT, E'Lesser black-backed gull');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Larus fuscus', E'Larus fuscus graellsii', DEFAULT, E'Lesser black-backed gull');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Larus argentatus', DEFAULT, DEFAULT, E'Herring gull');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Larus hyperboreus', DEFAULT, DEFAULT, E'Glaucous gull');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Phalacrocorax aristotelis', DEFAULT, DEFAULT, E'European shag');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Somateria mollissima', DEFAULT, DEFAULT, E'Common eider');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Testus specius', E'testus', DEFAULT, E'testspecies');
-- ddl-end --
INSERT INTO metadata.subspecies (species_name_latin, sub_species, id, species_name_eng) VALUES (E'Testus specius', E'specius', DEFAULT, E'testspecies');
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
	blood_sample text,
	feather_sample text,
	other_samples text,
	CONSTRAINT status_id UNIQUE (status_id),
	CONSTRAINT events_pk PRIMARY KEY (id),
	CONSTRAINT event_id_deployment_id_uq UNIQUE (status_id,deployment_id),
	CONSTRAINT event_id_retrieval_uq UNIQUE (status_id,retrieval_id),
	CONSTRAINT logger_date_uq UNIQUE (logger_id,event_date)

);
-- ddl-end --
ALTER TABLE loggers.events OWNER TO admin;
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
ALTER TABLE positions.logger_year_tracked OWNER TO admin;
-- ddl-end --

-- object: activity.temperature | type: TABLE --
-- DROP TABLE IF EXISTS activity.temperature CASCADE;
CREATE TABLE activity.temperature(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
	CONSTRAINT temperature_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE activity.temperature OWNER TO admin;
-- ddl-end --

-- object: activity.salinity | type: TABLE --
-- DROP TABLE IF EXISTS activity.salinity CASCADE;
CREATE TABLE activity.salinity(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id integer NOT NULL,
	CONSTRAINT salinity_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE activity.salinity OWNER TO admin;
-- ddl-end --

-- object: views.postable | type: VIEW --
-- DROP VIEW IF EXISTS views.postable CASCADE;
CREATE VIEW views.postable
AS 

SELECT p.* 
FROM positions.postable p;
-- ddl-end --
ALTER VIEW views.postable OWNER TO admin;
-- ddl-end --

-- object: views.active_logging_sessions | type: VIEW --
-- DROP VIEW IF EXISTS views.active_logging_sessions CASCADE;
CREATE VIEW views.active_logging_sessions
AS 

SELECT *
FROM loggers.logging_session
WHERE active = TRUE;
-- ddl-end --
ALTER VIEW views.active_logging_sessions OWNER TO admin;
-- ddl-end --

-- object: loggers.startup | type: TABLE --
-- DROP TABLE IF EXISTS loggers.startup CASCADE;
CREATE TABLE loggers.startup(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	session_id serial NOT NULL,
	logger_id integer NOT NULL,
	starttime_gmt timestamp(0),
	logging_mode varchar(15),
	started_by text,
	started_where text,
	days_delayed smallint,
	programmed_gmt_time timestamp,
	CONSTRAINT startup_pk PRIMARY KEY (id),
	CONSTRAINT session_id_unique UNIQUE (session_id)

);
-- ddl-end --
ALTER TABLE loggers.startup OWNER TO admin;
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
ALTER FUNCTION functions.fn_update_location_geom() OWNER TO admin;
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
ALTER FUNCTION functions.fn_update_colony_geom() OWNER TO admin;
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
	import_time timestamp(0) NOT NULL DEFAULT NOW()::timestamp(0),
	logger_serial_no text NOT NULL,
	logger_model text NOT NULL,
	producer text,
	production_year smallint,
	project text,
	starttime_gmt timestamp(0),
	logging_mode varchar(15),
	started_by text,
	started_where text,
	days_delayed smallint,
	programmed_gmt_time timestamp(0),
	intended_species text,
	intended_location text,
	intended_deployer text,
	shutdown_session boolean,
	field_status text,
	downloaded_by text,
	download_date date,
	download_type text,
	decomissioned boolean,
	comment text,
	shutdown_date date,
	CONSTRAINT logger_import_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE imports.logger_import OWNER TO admin;
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
ALTER TABLE metadata.import_types OWNER TO admin;
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
ALTER TABLE metadata.mounting_types OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.mounting_types (id, logger_mount_method) VALUES (DEFAULT, E'testmethod');
-- ddl-end --
INSERT INTO metadata.mounting_types (id, logger_mount_method) VALUES (DEFAULT, E'tarsus');
-- ddl-end --
INSERT INTO metadata.mounting_types (id, logger_mount_method) VALUES (DEFAULT, E'tibia');
-- ddl-end --

-- object: individuals.observations | type: TABLE --
-- DROP TABLE IF EXISTS individuals.observations CASCADE;
CREATE TABLE individuals.observations(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	individ_id uuid NOT NULL,
	lat double precision NOT NULL,
	lon double precision NOT NULL,
	geom geometry(POINT, 4326),
	CONSTRAINT observations_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE individuals.observations OWNER TO admin;
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
ALTER FUNCTION functions.fn_update_observations_geom() OWNER TO admin;
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

	IF  bool_and(logging_session.active = TRUE 
		AND date_part('year', ls.starttime_gmt) = date_part('year', NEW.starttime_gmt))
		FROM loggers.logging_session,loggers.startup ls
		WHERE logging_session.logger_id = NEW.logger_id
		AND ls.logger_id = NEW.logger_id
		THEN
		RAISE EXCEPTION 'Logger % already in open logging session started the same year. Close this open session before starting new one', NEW.logger_id;
	
	ELSIF  bool_or(logging_session.active = TRUE)
		FROM loggers.logging_session
		WHERE logging_session.logger_id = NEW.logger_id
		THEN
		RAISE WARNING 'Logger % already in open logging session, started another year.', NEW.logger_id;
	END IF;


RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_logging_session_not_open() OWNER TO admin;
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
ALTER FUNCTION functions.fn_start_new_logging_session() OWNER TO admin;
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
	FROM loggers.logging_session, loggers.startup
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE
	AND logging_session.session_id = startup.session_id
	AND date_part('year', startup.starttime_gmt) = date_part('year', NEW.deployment_date);
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_deployment() OWNER TO admin;
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

	    IF NEW.deployment_location != a.intended_location
		FROM (SELECT a.intended_location 
		FROM loggers.allocation a
		WHERE a.session_id = NEW.session_id) a THEN
            RAISE WARNING '% deployment location does not match indended location in allocation table', NEW.deployment_location;
        END IF;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_session_on_deployment() OWNER TO admin;
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
   
	IF bool_and(logging_session.deployment_id IS NULL)
			FROM loggers.logging_session
			WHERE logging_session.logger_id = NEW.logger_id
	THEN
		RAISE EXCEPTION 'Logger % not deployed. Logger must be deployed before retrieved.', NEW.logger_id;
	END IF;
		
	NEW.session_id := logging_session.session_id
	FROM loggers.logging_session
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE
	AND logging_session.individ_id = NEW.individ_id;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_retrieval() OWNER TO admin;
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
		year_tracked = date_part('year', dep.deployment_date) || '_' || date_part('year', dep.retrieval_date)::integer % 100
		FROM dep
		WHERE update.session_id = NEW.session_id
		AND NEW.session_id = dep.session_id;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_session_on_retrieval() OWNER TO admin;
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

IF NEW.logger_serial_no || NEW.logger_model NOT IN (SELECT logger_serial_no || logger_model FROM loggers.logger_info)
	 THEN
	INSERT INTO loggers.logger_info
					(logger_serial_no,
					producer, 
					logger_model,
					production_year,
					project)
	VALUES(NEW.logger_serial_no,
					NEW.producer,
					NEW.logger_model,
					NEW.production_year,
					NEW.project);
	END IF;
	IF NEW.starttime_gmt IS NOT NULL AND NEW.shutdown_session IS False THEN
	INSERT INTO loggers.startup 
					(logger_id,  
					starttime_gmt, 
					logging_mode, 
					started_by, 
					started_where, 
					days_delayed, 
					programmed_gmt_time)
	SELECT logger_info.logger_id,  
		NEW.starttime_gmt, 
		NEW.logging_mode, 
		NEW.started_by, 
		NEW.started_where, 
		NEW.days_delayed, 
		NEW.programmed_gmt_time
	FROM loggers.logger_info 
	WHERE logger_info.logger_model = NEW.logger_model
	AND logger_info.logger_serial_no = NEW.logger_serial_no;
	END IF;
	IF NEW.intended_species IS NOT NULL THEN
	INSERT INTO loggers.allocation 
					(logger_id,
					intended_species,
					intended_location,
					intended_deployer,
					starttime_gmt)
	SELECT logger_info.logger_id,
		NEW.intended_species,
		NEW.intended_location,
		NEW.intended_deployer,
		NEW.starttime_gmt
		FROM loggers.logger_info 
	WHERE logger_info.logger_model = NEW.logger_model
	AND logger_info.logger_serial_no = NEW.logger_serial_no;
	END IF;
	IF NEW.shutdown_session IS True THEN
		
		IF NEW.logger_serial_no || NEW.logger_model IN (SELECT logger_serial_no || logger_model  FROM (SELECT ls.session_id, ls.logger_id, li.logger_serial_no, li.logger_model, ls.active
							FROM loggers.logging_session ls , loggers.logger_info li, loggers.startup
							WHERE li.logger_serial_no = NEW.logger_serial_no
							AND li.logger_model = NEW.logger_model
							AND li.logger_id = ls.logger_id
							AND active IS True
							AND ls.session_id = startup.session_id
							AND startup.starttime_gmt = NEW.starttime_gmt) foo) THEN
			INSERT INTO loggers.shutdown (session_id,
																download_type,
																download_date,
																field_status,
																downloaded_by,
																decomissioned,
																shutdown_date)
							SELECT ls.session_id,
								
										NEW.download_type,
										NEW.download_date,
										NEW.field_status,
										NEW.downloaded_by,
										NEW.decomissioned,
										NEW.shutdown_date
							FROM loggers.logger_info li, loggers.logging_session ls, loggers.startup
							WHERE li.logger_serial_no = NEW.logger_serial_no
							AND li.logger_model = NEW.logger_model
							AND li.logger_id = ls.logger_id
							AND ls.active IS True
							AND ls.session_id = startup.session_id
							AND startup.starttime_gmt = NEW.starttime_gmt;
		ELSE RAISE EXCEPTION 'Logger % of model % not in an open logging session',  NEW.logger_serial_no, NEW.logger_model;
		END IF;
	END IF;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_distribute_from_logger_import_table() OWNER TO admin;
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
			FROM loggers.logging_session, loggers.startup
			WHERE logging_session.logger_id = NEW.logger_id
			AND logging_session.session_id = startup.session_id
			AND startup.starttime_gmt = NEW.starttime_gmt
		THEN
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding allocation data', NEW.logger_id;
	END IF;
	NEW.session_id := logging_session.session_id
	FROM loggers.logging_session, loggers.startup
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE
	AND logging_session.session_id = startup.session_id
	AND startup.starttime_gmt = NEW.starttime_gmt;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_allocation() OWNER TO admin;
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
	FROM loggers.logging_session, individuals.individ_info
	WHERE NEW.logger_id = logging_session.logger_id
	AND logging_session.active = TRUE
	AND individ_info.individ_id = logging_session.individ_id
	AND NEW.ring_number = individ_info.ring_number
	AND NEW.euring_code = individ_info.euring_code;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_status() OWNER TO admin;
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
ALTER TABLE metadata.breeding_stages OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.breeding_stages (id, breeding_stage) VALUES (DEFAULT, E'nonbreeding/failed_breeder');
-- ddl-end --
INSERT INTO metadata.breeding_stages (id, breeding_stage) VALUES (DEFAULT, E'prebreeding');
-- ddl-end --
INSERT INTO metadata.breeding_stages (id, breeding_stage) VALUES (DEFAULT, E'incubating');
-- ddl-end --
INSERT INTO metadata.breeding_stages (id, breeding_stage) VALUES (DEFAULT, E'rearing chicks');
-- ddl-end --
INSERT INTO metadata.breeding_stages (id, breeding_stage) VALUES (DEFAULT, E'breeding/stage_unknown');
-- ddl-end --
INSERT INTO metadata.breeding_stages (id, breeding_stage) VALUES (DEFAULT, E'failed breeder');
-- ddl-end --
INSERT INTO metadata.breeding_stages (id, breeding_stage) VALUES (DEFAULT, E'unknown');
-- ddl-end --

-- object: tr_distribute_import | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_distribute_import ON imports.logger_import CASCADE;
CREATE TRIGGER tr_distribute_import
	BEFORE INSERT 
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
	WHERE logger_import.id = NEW.id;
	RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_delete_rows_from_import() OWNER TO admin;
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
ALTER VIEW views.closed_sessions_not_shutdown OWNER TO admin;
-- ddl-end --

-- object: metadata.logger_files | type: TABLE --
-- DROP TABLE IF EXISTS metadata.logger_files CASCADE;
CREATE TABLE metadata.logger_files(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	logger_model text NOT NULL,
	file_basename text NOT NULL,
	logger_producer text NOT NULL,
	CONSTRAINT logger_files_pk PRIMARY KEY (id)

);
-- ddl-end --
COMMENT ON TABLE metadata.logger_files IS 'Reference table that specifies what files are created by which logger model';
-- ddl-end --
COMMENT ON COLUMN metadata.logger_files.file_basename IS 'base of filetype to be used as appendix on filename';
-- ddl-end --
ALTER TABLE metadata.logger_files OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c250', E'.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c250', E'driftadj.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c250', E'.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c250', E'driftadj.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c250', E'.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c250', E'driftadj.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c250', E'.sst', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3006', E'.tem', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3006', E'.trn', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3006', E'.txt', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3006', E'.act', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3006', E'.lig', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c330', E'.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c330', E'driftadj.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c330', E'.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c330', E'driftadj.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c330', E'.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c330', E'driftadj.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c330', E'.sst', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'f100', E'.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'f100', E'driftadj.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'f100', E'.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'f100', E'driftadj.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'f100', E'.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'f100', E'driftadj.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'f100', E'.sst', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c65', E'.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c65', E'driftadj.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c65', E'.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c65', E'driftadj.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c65', E'.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c65', E'driftadj.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'c65', E'.sst', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'w65', E'.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'w65', E'driftadj.deg', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'w65', E'.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'w65', E'driftadj.lux', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'w65', E'.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'w65', E'driftadj.trn', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'w65', E'.sst', E'Migrate Technology', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.trn', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.txt', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.act', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.lig', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.trn', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.txt', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.act', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk18', E'.lig', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk14', E'.trn', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk14', E'.txt', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk14', E'.act', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk14', E'.lig', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk13', E'.trn', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk13', E'.txt', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk13', E'.act', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk13', E'.lig', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk15', E'.tem', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk15', E'.trn', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk15', E'.txt', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk15', E'.act', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk15', E'.lig', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4', E'.trn', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4', E'.txt', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4', E'.act', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4', E'.lig', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3005', E'.tem', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3005', E'.trn', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3005', E'.txt', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3005', E'.act', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk3005', E'.lig', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4083', E'.trn', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4083', E'.txt', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4083', E'.act', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4083', E'.lig', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4093', E'.trn', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4093', E'.txt', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4093', E'.act', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk4093', E'.lig', E'Biotrack', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk9', E'.trn', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk9', E'.txt', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk9', E'.act', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'mk9', E'.lig', E'BAS', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'LAT', E'.bin', E'LOTEK', DEFAULT);
-- ddl-end --
INSERT INTO metadata.logger_files (logger_model, file_basename, logger_producer, id) VALUES (E'LAT', E'_o.bin', E'LOTEK', DEFAULT);
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
	IF (TG_OP = 'INSERT' AND (NEW.download_type = 'Successfully downloaded' 
									OR NEW.download_type = 'Reconstructed')) THEN
		WITH foo as (SELECT s.session_id, s.logger_id, l.logger_serial_no, l.logger_model, f.file_basename, EXTRACT(YEAR from r.retrieval_date) year_retr
		FROM  loggers.logging_session s INNER JOIN loggers.logger_info l ON s.logger_id = l.logger_id
		INNER JOIN loggers.retrieval r ON r.session_id = s.session_id 
		INNER JOIN metadata.logger_files f ON l.logger_model = f.logger_model	)
		INSERT INTO loggers.file_archive (session_id, filename)
		SELECT foo.session_id, logger_serial_no || '_' || foo.year_retr || '_' || foo.logger_model || foo.file_basename
		FROM foo
		WHERE foo.session_id = NEW.session_id;
	ELSEIF (TG_OP = 'UPDATE' AND (NEW.download_type = 'Successfully downloaded'
									OR NEW.download_type = 'Reconstructed')) THEN
		WITH foo as (SELECT s.session_id, s.logger_id, l.logger_serial_no, l.logger_model, f.file_basename , EXTRACT(YEAR from r.retrieval_date) year_retr
		FROM  loggers.logging_session s INNER JOIN loggers.logger_info l ON s.logger_id = l.logger_id
		INNER JOIN loggers.retrieval r ON r.session_id = s.session_id 
		INNER JOIN metadata.logger_files f ON l.logger_model = f.logger_model	)
		UPDATE loggers.file_archive SET
		session_id = foo.session_id,
		filename = foo.logger_serial_no || '_' || foo.year_retr || '_' || foo.logger_model || foo.file_basename
		FROM foo
		WHERE NEW.session_id = file_archive.session_id;
	END IF;
RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_create_filenames_on_shutdown() OWNER TO admin;
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

-- object: metadata.retrieval_type | type: TABLE --
-- DROP TABLE IF EXISTS metadata.retrieval_type CASCADE;
CREATE TABLE metadata.retrieval_type(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	type text NOT NULL,
	CONSTRAINT retrieval_type_pk PRIMARY KEY (id),
	CONSTRAINT retrieval_type_uq UNIQUE (type)

);
-- ddl-end --
ALTER TABLE metadata.retrieval_type OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'testtype');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual caught (logger retrieved, bird released without logger)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual observed (logger still attached)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual caught (first deployment)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual caught (logger retrieved and replaced)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual caught (logger lost and replaced)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual observed (logger lost)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual observed (logger status unknown)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'individual found dead (logger still attached)');
-- ddl-end --
INSERT INTO metadata.retrieval_type (id, type) VALUES (DEFAULT, E'logger not used');
-- ddl-end --

-- object: metadata.download_types | type: TABLE --
-- DROP TABLE IF EXISTS metadata.download_types CASCADE;
CREATE TABLE metadata.download_types(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	download_type text NOT NULL,
	CONSTRAINT download_types_pk PRIMARY KEY (id),
	CONSTRAINT download_type_uq UNIQUE (download_type)

);
-- ddl-end --
ALTER TABLE metadata.download_types OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Error');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Failed');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Lost');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Nonresponsive');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Reconstructed');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Successfully downloaded');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Unknown');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Unsuccessful reconstruction');
-- ddl-end --
INSERT INTO metadata.download_types (id, download_type) VALUES (DEFAULT, E'Sleep mode');
-- ddl-end --

-- object: tr_delete_after_import | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_delete_after_import ON imports.logger_import CASCADE;
CREATE TRIGGER tr_delete_after_import
	AFTER INSERT 
	ON imports.logger_import
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_delete_rows_from_import();
-- ddl-end --

-- object: metadata.breeding_success_criterion | type: TABLE --
-- DROP TABLE IF EXISTS metadata.breeding_success_criterion CASCADE;
CREATE TABLE metadata.breeding_success_criterion(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	breeding_success_criterion text NOT NULL,
	CONSTRAINT breeding_success_criterion_pk PRIMARY KEY (id),
	CONSTRAINT breeding_success_criterion_uq UNIQUE (breeding_success_criterion)

);
-- ddl-end --
ALTER TABLE metadata.breeding_success_criterion OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'10d');
-- ddl-end --
INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'15d');
-- ddl-end --
INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'20d');
-- ddl-end --
INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'25d');
-- ddl-end --
INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'30d');
-- ddl-end --
INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'fledging');
-- ddl-end --
INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'none');
-- ddl-end --
INSERT INTO metadata.breeding_success_criterion (id, breeding_success_criterion) VALUES (DEFAULT, E'unknown');
-- ddl-end --

-- object: functions.reject_process_colony_not_matching_any_type_name | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.reject_process_colony_not_matching_any_type_name() CASCADE;
CREATE FUNCTION functions.reject_process_colony_not_matching_any_type_name ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF NEW.colony NOT IN (SELECT DISTINCT x 
FROM metadata.location CROSS JOIN LATERAL
	(values(colony_int_name), (colony_nat_name)) as t(x)
WHERE x IS NOT NULL) THEN
RAISE EXCEPTION 'Colony name not present as native or international name in metadatal.locations table', NEW.colony;
END IF;
RETURN NEW;
END;

$$;
-- ddl-end --
ALTER FUNCTION functions.reject_process_colony_not_matching_any_type_name() OWNER TO postgres;
-- ddl-end --

-- object: tr_before_insert_or_update_process_check_colony_name | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_before_insert_or_update_process_check_colony_name ON positions.processing CASCADE;
CREATE TRIGGER tr_before_insert_or_update_process_check_colony_name
	BEFORE INSERT OR UPDATE OF colony
	ON positions.processing
	FOR EACH ROW
	EXECUTE PROCEDURE functions.reject_process_colony_not_matching_any_type_name();
-- ddl-end --

-- object: functions.fn_update_individ_info_logging_session | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_individ_info_logging_session() CASCADE;
CREATE FUNCTION functions.fn_update_individ_info_logging_session ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN	
	UPDATE individuals.individ_status 
	SET session_id= foo.session_id
	FROM (SELECT s.session_id
				FROM loggers.logging_session s
				WHERE s.logger_id = NEW.logger_id
				AND s.active IS True) foo
	
	WHERE id=NEW.id;
    RETURN NULL; -- result is ignored since this is an AFTER trigger
  END;

$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_individ_info_logging_session() OWNER TO postgres;
-- ddl-end --

-- object: tr_update_individ_info_logging_session_on_insert_or_update | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_individ_info_logging_session_on_insert_or_update ON individuals.individ_status CASCADE;
CREATE TRIGGER tr_update_individ_info_logging_session_on_insert_or_update
	AFTER INSERT OR UPDATE OF logger_id
	ON individuals.individ_status
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_individ_info_logging_session();
-- ddl-end --

-- object: imports.metadata_import | type: TABLE --
-- DROP TABLE IF EXISTS imports.metadata_import CASCADE;
CREATE TABLE imports.metadata_import(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	date date,
	ring_number text NOT NULL,
	euring_code text NOT NULL,
	color_ring text,
	logger_status text,
	logger_model_retrieved text,
	logger_id_retrieved text,
	logger_model_deployed text,
	logger_id_deployed text,
	species text,
	morph text,
	subspecies text,
	age text,
	sex text,
	sexing_method text,
	weight double precision,
	scull double precision,
	tarsus double precision,
	wing double precision,
	breeding_stage text,
	eggs smallint,
	chicks smallint,
	hatching_success boolean,
	breeding_success boolean,
	breeding_success_criterion text,
	country text,
	colony text,
	colony_latitude double precision,
	colony_longitude double precision,
	nest_id text,
	blood_sample text,
	feather_sample text,
	other_samples text,
	data_responsible text NOT NULL,
	back_on_nest boolean,
	logger_mount_method text,
	comment text,
	other text,
	old_ring_number text,
	last_updated timestamp,
	updated_by text
);
-- ddl-end --
ALTER TABLE imports.metadata_import OWNER TO admin;
-- ddl-end --

-- object: metadata.euring_codes | type: TABLE --
-- DROP TABLE IF EXISTS metadata.euring_codes CASCADE;
CREATE TABLE metadata.euring_codes(
	id uuid NOT NULL DEFAULT uuid_generate_v1(),
	euring_code text NOT NULL,
	CONSTRAINT euring_codes_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE metadata.euring_codes OWNER TO admin;
-- ddl-end --

INSERT INTO metadata.euring_codes (id, euring_code) VALUES (DEFAULT, E'NOS');
-- ddl-end --
INSERT INTO metadata.euring_codes (id, euring_code) VALUES (DEFAULT, E'NOO');
-- ddl-end --
INSERT INTO metadata.euring_codes (id, euring_code) VALUES (DEFAULT, E'RUM');
-- ddl-end --
INSERT INTO metadata.euring_codes (id, euring_code) VALUES (DEFAULT, E'GBT');
-- ddl-end --
INSERT INTO metadata.euring_codes (id, euring_code) VALUES (DEFAULT, E'ISR');
-- ddl-end --
INSERT INTO metadata.euring_codes (id, euring_code) VALUES (DEFAULT, E'DKC');
-- ddl-end --

-- object: functions.fn_distribute_from_metadata_table | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_distribute_from_metadata_table() CASCADE;
CREATE FUNCTION functions.fn_distribute_from_metadata_table ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
IF NEW.ring_number || NEW.euring_code NOT IN (SELECT ring_number || euring_code FROM individuals.individ_info) THEN
INSERT INTO individuals.individ_info (ring_number,
															euring_code,
															species,
															color_ring,
															morph,
															subspecies,
															age,
															sex,
															sexing_method,
															latest_info_date)		
					VALUES(NEW.ring_number,
									NEW.euring_code,
									NEW.species,
									NEW.color_ring,
									NEW.morph,
									NEW.subspecies,
									NEW.age,
									NEW.sex,
									NEW.sexing_method,
									NEW."date");
END IF;
	IF NEW.logger_model_deployed IS NOT NULL THEN
	INSERT INTO loggers.deployment
				(logger_id,
				individ_id,
				deployment_species,
				deployment_location,
				deployment_date,
				logger_mount_method)
	SELECT logging_session.logger_id,
				individ_info.individ_id,
				NEW.species,
				NEW.colony,
				NEW.date,
				NEW.logger_mount_method
FROM loggers.logging_session, loggers.logger_info, individuals.individ_info, loggers.startup
WHERE logging_session.logger_id = logger_info.logger_id
AND logger_info.logger_model = NEW.logger_model_deployed
AND logger_info.logger_serial_no = NEW.logger_id_deployed
AND logging_session.active IS True
AND individ_info.ring_number = NEW.ring_number
AND individ_info.euring_code = NEW.euring_code
AND logging_session.session_id =  startup.session_id
AND date_part('year', NEW.date) = date_part('year', startup.starttime_gmt);
	END IF;
IF NEW.date IN (SELECT individ_status.status_date
						FROM loggers.logging_session, individuals.individ_info, individuals.individ_status 
						WHERE individ_info.ring_number = NEW.ring_number
						AND individ_info.euring_code = NEW.euring_code
						AND individ_info.individ_id = logging_session.individ_id
						AND logging_session.active Is True
						AND logging_session.session_id = individ_status.session_id) 
THEN
	UPDATE individuals.individ_status
	SET 			weight = NEW.weight,
					scull = NEW.scull,
					tarsus = NEW.tarsus,
					wing = NEW.wing, 
					breeding_stage = NEW.breeding_stage,
					eggs = NEW.eggs,
					chicks = NEW.chicks, 
					hatching_success = NEW.hatching_success,
					breeding_success = NEW.breeding_success,
					breeding_success_criterion = NEW.breeding_success_criterion,
					data_responsible = NEW.data_responsible,
					back_on_nest = NEW.back_on_nest,
					"comment" = NEW."comment",
					"location" = NEW.colony,
						ring_number = NEW.ring_number,
						euring_code = NEW.euring_code,
						species = NEW.species, 
						color_ring = NEW.color_ring,
						morph = NEW.morph,
						subspecies = NEW.subspecies,
						age = NEW.age,
						sex = NEW.sex,
						sexing_method = NEW.sexing_method
		FROM loggers.logging_session, individuals.individ_info
		WHERE individ_status.logger_id = logging_session.logger_id
		AND status_date = NEW.date
		AND  individ_status.session_id = logging_session.session_id
		AND individ_info.ring_number = NEW.ring_number
		AND individ_info.euring_code = NEW.euring_code
		AND individ_info.individ_id = logging_session.individ_id
		AND logging_session.active Is True;
	
ELSE
	INSERT INTO individuals.individ_status	(logger_id,
					"status_date",
					session_id,
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
					"location",
						ring_number,
						euring_code,
						species,
						color_ring,
						morph,
						subspecies,
						age,
						sex,
						sexing_method)
	SELECT logging_session.logger_id,
					NEW.date,
					logging_session.session_id,
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
					NEW.back_on_nest,
					NEW."comment",
					NEW.colony,
						NEW.ring_number,
						NEW.euring_code,
						NEW.species,
						NEW.color_ring,
						NEW.morph,
						NEW.subspecies,
						NEW.age,
						NEW.sex,
						NEW.sexing_method
				FROM loggers.logging_session, individuals.individ_info
				WHERE individ_info.ring_number = NEW.ring_number
				AND individ_info.euring_code = NEW.euring_code
				AND individ_info.individ_id = logging_session.individ_id
				AND logging_session.active Is True;
END IF;
	
	
IF NEW.logger_model_retrieved IS NOT NULL THEN
		INSERT INTO loggers.retrieval
					(logger_id,
					individ_id,
					retrieval_type,
					retrieval_location,
					retrieval_date)
		SELECT logging_session.logger_id,
					individ_info.individ_id,
					NEW.logger_status,
					NEW.colony,
					NEW.date
FROM loggers.logging_session, loggers.logger_info, individuals.individ_info
WHERE logging_session.logger_id = logger_info.logger_id
AND logger_info.logger_model = NEW.logger_model_retrieved
AND logger_info.logger_serial_no = NEW.logger_id_retrieved
AND logging_session.active IS True
AND individ_info.ring_number = NEW.ring_number
AND individ_info.euring_code = NEW.euring_code
AND logging_session.individ_id =  individ_info.individ_id;
END IF;
NEW.updated_by := current_user;
NEW.last_updated := now();
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_distribute_from_metadata_table() OWNER TO postgres;
-- ddl-end --

-- object: functions.fn_deleted_uuid | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_deleted_uuid() CASCADE;
CREATE FUNCTION functions.fn_deleted_uuid ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
    INSERT INTO
        positions.deleted_uuid(id, import_date, deleted_date, posdata_file, user_name)
        VALUES(old.id,old.import_date, CURRENT_DATE, old.posdata_file, user);

           RETURN OLD;
END;

$$;
-- ddl-end --
ALTER FUNCTION functions.fn_deleted_uuid() OWNER TO postgres;
-- ddl-end --

-- object: functions.fn_update_data_version | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_data_version() CASCADE;
CREATE FUNCTION functions.fn_update_data_version ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
  NEW.data_version := OLD.data_version + 1;
  RETURN NEW;
END; 

$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_data_version() OWNER TO postgres;
-- ddl-end --

-- object: functions.fn_update_import_date | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_import_date() CASCADE;
CREATE FUNCTION functions.fn_update_import_date ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
  NEW.import_date := CURRENT_DATE;
  RETURN NEW;
END; 

$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_import_date() OWNER TO postgres;
-- ddl-end --

-- object: functions.fn_used_uuid | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_used_uuid() CASCADE;
CREATE FUNCTION functions.fn_used_uuid ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
    INSERT INTO
        positions.used_uuid(id, import_date,posdata_file, user_name)
        VALUES(new.id,new.import_date, new.posdata_file, user);
           RETURN new;
END;

$$;
-- ddl-end --
ALTER FUNCTION functions.fn_used_uuid() OWNER TO postgres;
-- ddl-end --

-- object: positions.deleted_uuid | type: TABLE --
-- DROP TABLE IF EXISTS positions.deleted_uuid CASCADE;
CREATE TABLE positions.deleted_uuid(
	id uuid NOT NULL,
	import_date date,
	deleted_date date,
	posdata_file text,
	user_name text,
	CONSTRAINT deleted_uuid_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE positions.deleted_uuid OWNER TO admin;
-- ddl-end --

-- object: positions.used_uuid | type: TABLE --
-- DROP TABLE IF EXISTS positions.used_uuid CASCADE;
CREATE TABLE positions.used_uuid(
	id uuid NOT NULL,
	import_date date,
	posdata_file text,
	user_name text,
	CONSTRAINT used_uuid_pk PRIMARY KEY (id)

);
-- ddl-end --
ALTER TABLE positions.used_uuid OWNER TO admin;
-- ddl-end --

-- object: tr_deleted_uuid_trigger | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_deleted_uuid_trigger ON positions.postable CASCADE;
CREATE TRIGGER tr_deleted_uuid_trigger
	BEFORE DELETE 
	ON positions.postable
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_deleted_uuid();
-- ddl-end --

-- object: tr_update_data_version | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_data_version ON positions.postable CASCADE;
CREATE TRIGGER tr_update_data_version
	BEFORE UPDATE
	ON positions.postable
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_data_version();
-- ddl-end --

-- object: tr_update_import_date | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_import_date ON positions.postable CASCADE;
CREATE TRIGGER tr_update_import_date
	BEFORE INSERT 
	ON positions.postable
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_import_date();
-- ddl-end --

-- object: tr_used_uuid | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_used_uuid ON positions.postable CASCADE;
CREATE TRIGGER tr_used_uuid
	AFTER INSERT 
	ON positions.postable
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_used_uuid();
-- ddl-end --

-- object: tr_distribute_on_metadata_import | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_distribute_on_metadata_import ON imports.metadata_import CASCADE;
CREATE TRIGGER tr_distribute_on_metadata_import
	BEFORE INSERT OR UPDATE
	ON imports.metadata_import
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_distribute_from_metadata_table();
-- ddl-end --

-- object: postable_datarespons_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_datarespons_idx CASCADE;
CREATE INDEX postable_datarespons_idx ON positions.postable
	USING btree
	(
	  data_responsible
	);
-- ddl-end --

-- object: postable_datetime_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_datetime_idx CASCADE;
CREATE INDEX postable_datetime_idx ON positions.postable
	USING btree
	(
	  date_time
	);
-- ddl-end --

-- object: postable_eqfilter3_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_eqfilter3_idx CASCADE;
CREATE INDEX postable_eqfilter3_idx ON positions.postable
	USING btree
	(
	  eqfilter3
	);
-- ddl-end --

-- object: postable_id_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_id_idx CASCADE;
CREATE INDEX postable_id_idx ON positions.postable
	USING btree
	(
	  id
	);
-- ddl-end --

-- object: postable_postdatafile_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_postdatafile_idx CASCADE;
CREATE INDEX postable_postdatafile_idx ON positions.postable
	USING btree
	(
	  posdata_file
	);
-- ddl-end --

-- object: postable_species_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_species_idx CASCADE;
CREATE INDEX postable_species_idx ON positions.postable
	USING btree
	(
	  species
	);
-- ddl-end --

-- object: postable_ring_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_ring_idx CASCADE;
CREATE INDEX postable_ring_idx ON positions.postable
	USING btree
	(
	  ring_number
	);
-- ddl-end --

-- object: postable_logger_idx | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_logger_idx CASCADE;
CREATE INDEX postable_logger_idx ON positions.postable
	USING btree
	(
	  logger_id
	);
-- ddl-end --

-- object: functions.fn_check_open_session_on_metadata_deployment | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_open_session_on_metadata_deployment() CASCADE;
CREATE FUNCTION functions.fn_check_open_session_on_metadata_deployment ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
		IF bool_and(logging_session.logger_id != logger_info.logger_id) 
			FROM loggers.logging_session, loggers.logger_info, individuals.individ_info
			WHERE logger_info.logger_model = NEW.logger_model_deployed
			AND logger_info.logger_serial_no = NEW.logger_id_deployed
		THEN
			RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id_deployed;
		END IF;
		IF bool_and(logging_session.active = FALSE)
			FROM loggers.logging_session, loggers.logger_info, individuals.individ_info
			WHERE logging_session.logger_id = logger_info.logger_id
			AND logger_info.logger_model = NEW.logger_model_deployed
			AND logger_info.logger_serial_no = NEW.logger_id_deployed
		THEN
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id_deployed;
	END IF;
RETURN NEW;
END;




$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_metadata_deployment() OWNER TO admin;
-- ddl-end --

-- object: tr_check_open_session_on_metadata_deployment | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_open_session_on_metadata_deployment ON imports.metadata_import CASCADE;
CREATE TRIGGER tr_check_open_session_on_metadata_deployment
	BEFORE INSERT OR UPDATE
	ON imports.metadata_import
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_open_session_on_metadata_deployment();
-- ddl-end --

-- object: functions.fn_check_open_session_on_metadata_retrieval | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_open_session_on_metadata_retrieval() CASCADE;
CREATE FUNCTION functions.fn_check_open_session_on_metadata_retrieval ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF  bool_and(logging_session.logger_id != logger_info.logger_id)
			FROM loggers.logging_session, loggers.logger_info, individuals.individ_info
			WHERE logger_info.logger_model = NEW.logger_model_retrieved
			AND logger_info.logger_serial_no = NEW.logger_id_retrieved
	THEN 
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id_retrieved;
	END IF;
   
	IF bool_and(logging_session.active = FALSE) 			
			FROM loggers.logging_session, loggers.logger_info, individuals.individ_info
			WHERE logging_session.logger_id = logger_info.logger_id
			AND logger_info.logger_model = NEW.logger_model_retrieved
			AND logger_info.logger_serial_no = NEW.logger_id_retrieved
	THEN
		RAISE EXCEPTION 'Logger % not in open logging session. Open session before adding deployment data', NEW.logger_id_retrieved;
	END IF;
   
	IF bool_and(logging_session.deployment_id IS NULL)
			FROM loggers.logging_session, loggers.logger_info, individuals.individ_info
			WHERE logging_session.logger_id = logger_info.logger_id
			AND logger_info.logger_model = NEW.logger_model_retrieved
			AND logger_info.logger_serial_no = NEW.logger_id_retrieved
	THEN
		RAISE EXCEPTION 'Logger % not deployed. Logger must be deployed before retrieved.', NEW.logger_id_retrieved;
	END IF;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_open_session_on_metadata_retrieval() OWNER TO admin;
-- ddl-end --

-- object: tr_check_open_session_on_metadata_retrieval | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_open_session_on_metadata_retrieval ON imports.metadata_import CASCADE;
CREATE TRIGGER tr_check_open_session_on_metadata_retrieval
	BEFORE INSERT OR UPDATE
	ON imports.metadata_import
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_open_session_on_metadata_retrieval();
-- ddl-end --

-- object: views.categories | type: MATERIALIZED VIEW --
-- DROP MATERIALIZED VIEW IF EXISTS views.categories CASCADE;
CREATE MATERIALIZED VIEW views.categories
AS 

SELECT
    species as species_cat, colony as colony_cat, data_responsible as responsible_cat
    , ring_number as ring_number_cat
    FROM positions.postable
    GROUP BY species, colony, data_responsible, ring_number;
-- ddl-end --
ALTER MATERIALIZED VIEW views.categories OWNER TO admin;
-- ddl-end --

-- object: views.longersum | type: MATERIALIZED VIEW --
-- DROP MATERIALIZED VIEW IF EXISTS views.longersum CASCADE;
CREATE MATERIALIZED VIEW views.longersum
AS 

SELECT
   year_tracked år, species, count(distinct(ring_number)) antall_unike_ring_nummer, count(*) antall_posisjoner, count(distinct(colony)) antall_kolonier
    FROM positions.postable
    GROUP BY år, species
    ORDER BY år, species;
-- ddl-end --
ALTER MATERIALIZED VIEW views.longersum OWNER TO admin;
-- ddl-end --

-- object: views.shorttable | type: MATERIALIZED VIEW --
-- DROP MATERIALIZED VIEW IF EXISTS views.shorttable CASCADE;
CREATE MATERIALIZED VIEW views.shorttable
AS 

SELECT
    count(DISTINCT postable.species) AS "Antall arter",
    count(DISTINCT postable.colony) AS "Antall kolonier",
    count(DISTINCT postable.year_tracked) AS "Antall år",
    count(*) AS "Antall positions",
    count(DISTINCT postable.ring_number) AS "Antall individer"
   FROM positions.postable;
-- ddl-end --
ALTER MATERIALIZED VIEW views.shorttable OWNER TO admin;
-- ddl-end --

-- object: views.shorttableeqfilter3 | type: VIEW --
-- DROP VIEW IF EXISTS views.shorttableeqfilter3 CASCADE;
CREATE VIEW views.shorttableeqfilter3
AS 

SELECT
   count(DISTINCT postable.species) AS "Antall arter",
    count(DISTINCT postable.colony) AS "Antall kolonier",
    count(DISTINCT postable.year_tracked) AS "Antall år",
    count(*) AS "Antall positions",
    count(DISTINCT postable.ring_number) AS "Antall individer"
   FROM positions.postable
  WHERE postable.eqfilter3 = 1;
-- ddl-end --
ALTER VIEW views.shorttableeqfilter3 OWNER TO admin;
-- ddl-end --

-- object: functions.fn_update_materialized_views_on_postable_update | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_materialized_views_on_postable_update() CASCADE;
CREATE FUNCTION functions.fn_update_materialized_views_on_postable_update ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
REFRESH MATERIALIZED VIEW views.categories;
REFRESH MATERIALIZED VIEW views.longersum;
REFRESH MATERIALIZED VIEW views.shorttable;
RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_materialized_views_on_postable_update() OWNER TO admin;
-- ddl-end --

-- object: tr_update_matviews_on_postable_update | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_matviews_on_postable_update ON positions.postable CASCADE;
CREATE TRIGGER tr_update_matviews_on_postable_update
	AFTER INSERT OR DELETE OR UPDATE
	ON positions.postable
	FOR EACH STATEMENT
	EXECUTE PROCEDURE functions.fn_update_materialized_views_on_postable_update();
-- ddl-end --

-- object: views.all_depl_mismatch | type: VIEW --
-- DROP VIEW IF EXISTS views.all_depl_mismatch CASCADE;
CREATE VIEW views.all_depl_mismatch
AS 

SELECT
   
a.session_id, a.logger_id, a.intended_species, a.intended_location, a.intended_deployer , d.deployment_species, d.deployment_location, d.deployment_date
FROM loggers.allocation a join loggers.deployment d on
a.session_id = d.session_id
WHERE intended_location != deployment_location;
-- ddl-end --
ALTER VIEW views.all_depl_mismatch OWNER TO postgres;
-- ddl-end --

-- object: functions.fn_update_individ_info_from_individ_status | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_individ_info_from_individ_status() CASCADE;
CREATE FUNCTION functions.fn_update_individ_info_from_individ_status ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	
	IF NEW.ring_number || NEW.euring_code IN (SELECT ring_number || euring_code FROM individuals.individ_info) THEN
		IF NEW.species != (SELECT(foo.species)
		FROM (SELECT species, ring_number, euring_code FROM individuals.individ_info) foo
		WHERE NEW.ring_number = foo.ring_number
		AND NEW.euring_code = foo.euring_code) THEN
		RAISE EXCEPTION 'Species id for metalring number % does not match old species', NEW.ring_number;
		END IF;

		UPDATE individuals.individ_info
		SET latest_info_date = NEW.status_date
		WHERE ring_number = NEW.ring_number
		AND euring_code = NEW.euring_code; 
		IF NEW.color_ring IS NOT NULL THEN
			UPDATE individuals.individ_info
				SET color_ring = NEW.color_ring
				WHERE ring_number = NEW.ring_number
				AND euring_code = NEW.euring_code;
		END IF;
		IF NEW.morph IS NOT NULL THEN
			UPDATE individuals.individ_info
				SET morph = NEW.morph
				WHERE ring_number = NEW.ring_number
				AND euring_code = NEW.euring_code;
		END IF;
		IF NEW.subspecies IS NOT NULL THEN
			UPDATE individuals.individ_info
				SET subspecies = NEW.subspecies
				WHERE ring_number = NEW.ring_number
				AND euring_code = NEW.euring_code;
		END IF;
		IF NEW.age IS NOT NULL THEN
			UPDATE individuals.individ_info
				SET age = NEW.age
				WHERE ring_number = NEW.ring_number
				AND euring_code = NEW.euring_code;
		END IF;
		IF NEW.sex IS NOT NULL THEN
			UPDATE individuals.individ_info
				SET sex = NEW.sex,
				sexing_method = NEW.sexing_method
				WHERE ring_number = NEW.ring_number
				AND euring_code = NEW.euring_code;
		END IF;
	END IF;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_individ_info_from_individ_status() OWNER TO admin;
-- ddl-end --

-- object: tr_update_individ_info_from_individ_status | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_individ_info_from_individ_status ON individuals.individ_status CASCADE;
CREATE TRIGGER tr_update_individ_info_from_individ_status
	AFTER INSERT OR UPDATE
	ON individuals.individ_status
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_individ_info_from_individ_status();
-- ddl-end --

-- object: functions.fn_check_retrieval_match_with_deployment | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_retrieval_match_with_deployment() CASCADE;
CREATE FUNCTION functions.fn_check_retrieval_match_with_deployment ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF NEW.individ_id != d.individ_id 
	FROM loggers.deployment d
	WHERE NEW.session_id = d.session_id THEN
	RAISE EXCEPTION 'Retrieved individual % does not match deployed individual ', NEW.individ_id;
	END IF;
RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_retrieval_match_with_deployment() OWNER TO admin;
-- ddl-end --

-- object: tr_check_mismatch_with_deployment | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_mismatch_with_deployment ON loggers.retrieval CASCADE;
CREATE TRIGGER tr_check_mismatch_with_deployment
	AFTER INSERT OR UPDATE
	ON loggers.retrieval
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_retrieval_match_with_deployment();
-- ddl-end --

-- object: functions.fn_update_session_on_shutdown | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_session_on_shutdown() CASCADE;
CREATE FUNCTION functions.fn_update_session_on_shutdown ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	UPDATE loggers.logging_session
	SET active = 'False'
	WHERE session_id = NEW.session_id;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_session_on_shutdown() OWNER TO postgres;
-- ddl-end --

-- object: tr_update_session_on_shutdown | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_session_on_shutdown ON loggers.shutdown CASCADE;
CREATE TRIGGER tr_update_session_on_shutdown
	AFTER INSERT 
	ON loggers.shutdown
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_update_session_on_shutdown();
-- ddl-end --

-- object: functions.fn_check_shutdown_after_startup | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_shutdown_after_startup() CASCADE;
CREATE FUNCTION functions.fn_check_shutdown_after_startup ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF NEW.download_date < (SELECT starttime_gmt::date
				FROM loggers.startup
				WHERE NEW.session_id = startup.session_id) THEN

				SELECT raise_logger_session_exception(logger_serial_no, session_id)
				FROM (SELECT starttime_gmt::date, logger_info.logger_serial_no, logging_session.session_id 
				FROM loggers.startup, loggers.logger_info, loggers.logging_session
				WHERE NEW.session_id = logging_session.session_id
				AND logging_session.logger_id = logger_info.logger_id) fo;

	
	END IF;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_shutdown_after_startup() OWNER TO admin;
-- ddl-end --

-- object: functions.fn_check_retr_after_depl | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_retr_after_depl() CASCADE;
CREATE FUNCTION functions.fn_check_retr_after_depl ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF NEW.retrieval_date < (SELECT deployment_date
				FROM loggers.deployment
				WHERE NEW.session_id = deployment.session_id) THEN 

				SELECT functions.fn_raise_download_date_exception(logger_serial_no, session_id)
				FROM (SELECT logger_info.logger_serial_no, logging_session.session_id 
				FROM loggers.logger_info, loggers.logging_session
				WHERE NEW.session_id = logging_session.session_id
				AND logging_session.logger_id = logger_info.logger_id) fo;
	
	END IF;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_retr_after_depl() OWNER TO admin;
-- ddl-end --

-- object: tr_check_retr_after_depl | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_retr_after_depl ON loggers.retrieval CASCADE;
CREATE TRIGGER tr_check_retr_after_depl
	AFTER INSERT OR UPDATE
	ON loggers.retrieval
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_retr_after_depl();
-- ddl-end --

-- object: functions.fn_check_depl_after_startup | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_check_depl_after_startup() CASCADE;
CREATE FUNCTION functions.fn_check_depl_after_startup ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	IF (
	(NEW.deployment_date < (SELECT programmed_gmt_time::date
				FROM loggers.startup
				WHERE NEW.session_id = startup.session_id)) 
				OR
				
	(NEW.deployment_date < (SELECT starttime_gmt::date
				FROM loggers.startup
				WHERE NEW.session_id = startup.session_id) 
				AND
				
				(SELECT programmed_gmt_time::date
				FROM loggers.startup
				WHERE NEW.session_id = startup.session_id) IS NULL)
				) 
				THEN
				
				SELECT functions.fn_raise_deployment_date_exception(logger_serial_no, session_id)
				FROM (SELECT logger_info.logger_serial_no, logging_session.session_id 
				FROM loggers.startup, loggers.logger_info, loggers.logging_session
				WHERE NEW.session_id = logging_session.session_id
				AND logging_session.logger_id = logger_info.logger_id) fo;
	
	END IF;
	RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_check_depl_after_startup() OWNER TO admin;
-- ddl-end --

-- object: tr_check_depl_after_startup | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_check_depl_after_startup ON loggers.deployment CASCADE;
CREATE TRIGGER tr_check_depl_after_startup
	AFTER INSERT OR UPDATE
	ON loggers.deployment
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_check_depl_after_startup();
-- ddl-end --

-- object: functions.fn_raise_download_date_exception | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_raise_download_date_exception(text,integer) CASCADE;
CREATE FUNCTION functions.fn_raise_download_date_exception ( logger_id text,  session_id integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
  RAISE EXCEPTION 'Download date of logger % in session % is earlier than startup date', $1, $2;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_raise_download_date_exception(text,integer) OWNER TO admin;
-- ddl-end --

-- object: functions.fn_raise_deployment_date_exception | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_raise_deployment_date_exception(text,integer) CASCADE;
CREATE FUNCTION functions.fn_raise_deployment_date_exception ( logger_id text,  session_id integer)
	RETURNS void
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
  RAISE EXCEPTION 'Deployment date of logger % in session % is earlier than startup date', $1, $2;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_raise_deployment_date_exception(text,integer) OWNER TO admin;
-- ddl-end --

-- object: functions.fn_record_metadata_last_updated | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_record_metadata_last_updated() CASCADE;
CREATE FUNCTION functions.fn_record_metadata_last_updated ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
	NEW.updated_by := current_user;
	NEW.last_updated := now();

RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_record_metadata_last_updated() OWNER TO admin;
-- ddl-end --

-- object: tr_record_metadata_last_updated | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_record_metadata_last_updated ON imports.metadata_import CASCADE;
CREATE TRIGGER tr_record_metadata_last_updated
	BEFORE INSERT OR UPDATE
	ON imports.metadata_import
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_record_metadata_last_updated();
-- ddl-end --

-- object: functions.fn_record_logging_session_last_updated | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_record_logging_session_last_updated() CASCADE;
CREATE FUNCTION functions.fn_record_logging_session_last_updated ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
NEW.last_updated := now();
NEW.updated_by := current_user;
RETURN NEW;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_record_logging_session_last_updated() OWNER TO admin;
-- ddl-end --

-- object: tr_update_session_last_modified | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_session_last_modified ON loggers.logging_session CASCADE;
CREATE TRIGGER tr_update_session_last_modified
	BEFORE INSERT OR UPDATE
	ON loggers.logging_session
	FOR EACH ROW
	EXECUTE PROCEDURE functions.fn_record_logging_session_last_updated();
-- ddl-end --

-- object: postable_logger_model | type: INDEX --
-- DROP INDEX IF EXISTS positions.postable_logger_model CASCADE;
CREATE INDEX postable_logger_model ON positions.postable
	USING btree
	(
	  logger_model
	);
-- ddl-end --

-- object: functions.fn_update_postable_logging_session | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_update_postable_logging_session() CASCADE;
CREATE FUNCTION functions.fn_update_postable_logging_session ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN
UPDATE positions.postable pos
SET session_id = foo.session_id 
FROM (SELECT ls.session_id, p.id
FROM loggers.logging_session ls, loggers.logger_info li, positions.postable p
WHERE p.logger_id = li.logger_serial_no
AND p.logger_model = li.logger_model
AND li.logger_id = ls.logger_id
AND p.year_tracked = ls.year_tracked) foo
WHERE pos.id = foo.id;
RETURN NULL;
END;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_update_postable_logging_session() OWNER TO admin;
-- ddl-end --

-- object: tr_update_postable_logging_session | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_update_postable_logging_session ON positions.postable CASCADE;
CREATE TRIGGER tr_update_postable_logging_session
	AFTER INSERT OR UPDATE
	ON positions.postable
	FOR EACH STATEMENT
	WHEN (pg_trigger_depth() = 0)
	EXECUTE PROCEDURE functions.fn_update_postable_logging_session();
-- ddl-end --

-- object: functions.fn_delete_individ_info_on_delete_individ_status | type: FUNCTION --
-- DROP FUNCTION IF EXISTS functions.fn_delete_individ_info_on_delete_individ_status() CASCADE;
CREATE FUNCTION functions.fn_delete_individ_info_on_delete_individ_status ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	COST 1
	AS $$
BEGIN

DELETE FROM individuals.individ_info
WHERE ring_number NOT IN (SELECT DISTINCT ring_number FROM individuals.individ_status) AND
euring_code NOT IN (SELECT DISTINCT ring_number FROM individuals.individ_status);

RETURN NULL;
$$;
-- ddl-end --
ALTER FUNCTION functions.fn_delete_individ_info_on_delete_individ_status() OWNER TO admin;
-- ddl-end --

-- object: tr_delete_individ_info_on_delete_individ_status | type: TRIGGER --
-- DROP TRIGGER IF EXISTS tr_delete_individ_info_on_delete_individ_status ON individuals.individ_status CASCADE;
CREATE TRIGGER tr_delete_individ_info_on_delete_individ_status
	AFTER DELETE 
	ON individuals.individ_status
	FOR EACH STATEMENT
	EXECUTE PROCEDURE functions.fn_delete_individ_info_on_delete_individ_status();
-- ddl-end --

-- object: restricted.ftp_credentials | type: VIEW --
-- DROP VIEW IF EXISTS restricted.ftp_credentials CASCADE;
CREATE VIEW restricted.ftp_credentials
AS 

SELECT DISTINCT ON (foo.username) foo.username::text AS "User",
    "right"(foo.rolpassword, '-3'::integer) AS "Password",
    foo.username::character varying AS "Uid",
        CASE
            WHEN foo.groups ~~ '%writer'::text THEN 'write'::character varying
            WHEN foo.groups ~~ 'admin'::text THEN 'write'::character varying
            ELSE 'read'::character varying
        END AS "Gid",
    '/data/local/ftp'::text AS "Dir"
   FROM ( SELECT pg_authid.rolname AS username,
            pg_roles.rolname AS groups,
            pg_authid.rolpassword
           FROM pg_user
             JOIN pg_auth_members ON pg_user.usesysid = pg_auth_members.member
             JOIN pg_roles ON pg_roles.oid = pg_auth_members.roleid
             JOIN pg_authid ON pg_user.usename = pg_authid.rolname
          WHERE pg_authid.rolcanlogin IS TRUE) foo
  ORDER BY foo.username;
-- ddl-end --
ALTER VIEW restricted.ftp_credentials OWNER TO admin;
-- ddl-end --

-- object: logger_model_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.logger_info DROP CONSTRAINT IF EXISTS logger_model_fk CASCADE;
ALTER TABLE loggers.logger_info ADD CONSTRAINT logger_model_fk FOREIGN KEY (producer,logger_model)
REFERENCES metadata.logger_models (producer,model) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logger_mod_prod_fk | type: CONSTRAINT --
-- ALTER TABLE metadata.logger_models DROP CONSTRAINT IF EXISTS logger_mod_prod_fk CASCADE;
ALTER TABLE metadata.logger_models ADD CONSTRAINT logger_mod_prod_fk FOREIGN KEY (producer)
REFERENCES metadata.logger_producers (producer) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_allocation_session_id | type: CONSTRAINT --
-- ALTER TABLE loggers.allocation DROP CONSTRAINT IF EXISTS fk_allocation_session_id CASCADE;
ALTER TABLE loggers.allocation ADD CONSTRAINT fk_allocation_session_id FOREIGN KEY (session_id)
REFERENCES loggers.logging_session (session_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
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
ON DELETE RESTRICT ON UPDATE CASCADE;
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
ON DELETE RESTRICT ON UPDATE CASCADE;
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
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: deployment_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.deployment DROP CONSTRAINT IF EXISTS deployment_logging_session_fk CASCADE;
ALTER TABLE loggers.deployment ADD CONSTRAINT deployment_logging_session_fk FOREIGN KEY (session_id)
REFERENCES loggers.logging_session (session_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
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
ALTER TABLE individuals.individ_info ADD CONSTRAINT species_fk FOREIGN KEY (species,subspecies)
REFERENCES metadata.subspecies (species_name_eng,sub_species) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: status_logging_session_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS status_logging_session_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT status_logging_session_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: breeding_success_criterion_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS breeding_success_criterion_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT breeding_success_criterion_fk FOREIGN KEY (breeding_success_criterion)
REFERENCES metadata.breeding_success_criterion (breeding_success_criterion) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: individ_status_data_responsible_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS individ_status_data_responsible_fk CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT individ_status_data_responsible_fk FOREIGN KEY (data_responsible)
REFERENCES metadata.people (name) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_species | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS fk_species CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT fk_species FOREIGN KEY (species,subspecies)
REFERENCES metadata.subspecies (species_name_eng,sub_species) MATCH SIMPLE
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_sex | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS fk_sex CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT fk_sex FOREIGN KEY (sex)
REFERENCES metadata.sex (sex) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_sexing_method | type: CONSTRAINT --
-- ALTER TABLE individuals.individ_status DROP CONSTRAINT IF EXISTS fk_sexing_method CASCADE;
ALTER TABLE individuals.individ_status ADD CONSTRAINT fk_sexing_method FOREIGN KEY (sexing_method)
REFERENCES metadata.sexing_method (method) MATCH FULL
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
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: retrieval_type_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.retrieval DROP CONSTRAINT IF EXISTS retrieval_type_fk CASCADE;
ALTER TABLE loggers.retrieval ADD CONSTRAINT retrieval_type_fk FOREIGN KEY (retrieval_type)
REFERENCES metadata.retrieval_type (type) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: shutdown_startup_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.shutdown DROP CONSTRAINT IF EXISTS shutdown_startup_fk CASCADE;
ALTER TABLE loggers.shutdown ADD CONSTRAINT shutdown_startup_fk FOREIGN KEY (session_id)
REFERENCES loggers.startup (session_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: download_type_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.shutdown DROP CONSTRAINT IF EXISTS download_type_fk CASCADE;
ALTER TABLE loggers.shutdown ADD CONSTRAINT download_type_fk FOREIGN KEY (download_type)
REFERENCES metadata.download_types (download_type) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: shutdown_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.file_archive DROP CONSTRAINT IF EXISTS shutdown_fk CASCADE;
ALTER TABLE loggers.file_archive ADD CONSTRAINT shutdown_fk FOREIGN KEY (session_id)
REFERENCES loggers.shutdown (session_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: events_deployment_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.events DROP CONSTRAINT IF EXISTS events_deployment_fk CASCADE;
ALTER TABLE loggers.events ADD CONSTRAINT events_deployment_fk FOREIGN KEY (deployment_id)
REFERENCES loggers.deployment (deployment_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: events_retrieval_fk | type: CONSTRAINT --
-- ALTER TABLE loggers.events DROP CONSTRAINT IF EXISTS events_retrieval_fk CASCADE;
ALTER TABLE loggers.events ADD CONSTRAINT events_retrieval_fk FOREIGN KEY (retrieval_id)
REFERENCES loggers.retrieval (retrieval_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
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
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: fk_startup_session_id | type: CONSTRAINT --
-- ALTER TABLE loggers.startup DROP CONSTRAINT IF EXISTS fk_startup_session_id CASCADE;
ALTER TABLE loggers.startup ADD CONSTRAINT fk_startup_session_id FOREIGN KEY (session_id)
REFERENCES loggers.logging_session (session_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: observation_individ_fk | type: CONSTRAINT --
-- ALTER TABLE individuals.observations DROP CONSTRAINT IF EXISTS observation_individ_fk CASCADE;
ALTER TABLE individuals.observations ADD CONSTRAINT observation_individ_fk FOREIGN KEY (individ_id)
REFERENCES individuals.individ_info (individ_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logger_model_fk | type: CONSTRAINT --
-- ALTER TABLE metadata.logger_files DROP CONSTRAINT IF EXISTS logger_model_fk CASCADE;
ALTER TABLE metadata.logger_files ADD CONSTRAINT logger_model_fk FOREIGN KEY (logger_model,logger_producer)
REFERENCES metadata.logger_models (model,producer) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: logger_retrieved_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS logger_retrieved_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT logger_retrieved_fk FOREIGN KEY (logger_id_retrieved,logger_model_retrieved)
REFERENCES loggers.logger_info (logger_serial_no,logger_model) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: logger_deployed_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS logger_deployed_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT logger_deployed_fk FOREIGN KEY (logger_id_deployed,logger_model_deployed)
REFERENCES loggers.logger_info (logger_serial_no,logger_model) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: species_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS species_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT species_fk FOREIGN KEY (species,subspecies)
REFERENCES metadata.subspecies (species_name_eng,sub_species) MATCH SIMPLE
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sex_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS sex_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT sex_fk FOREIGN KEY (sex)
REFERENCES metadata.sex (sex) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: sexing_method_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS sexing_method_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT sexing_method_fk FOREIGN KEY (sexing_method)
REFERENCES metadata.sexing_method (method) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: breeding_stages_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS breeding_stages_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT breeding_stages_fk FOREIGN KEY (breeding_stage)
REFERENCES metadata.breeding_stages (breeding_stage) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: breeding_success_criterion_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS breeding_success_criterion_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT breeding_success_criterion_fk FOREIGN KEY (breeding_success_criterion)
REFERENCES metadata.breeding_success_criterion (breeding_success_criterion) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: colony_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS colony_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT colony_fk FOREIGN KEY (colony)
REFERENCES metadata.location (location_name) MATCH FULL
ON DELETE RESTRICT ON UPDATE NO ACTION;
-- ddl-end --

-- object: data_responsible_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS data_responsible_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT data_responsible_fk FOREIGN KEY (data_responsible)
REFERENCES metadata.people (name) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: logger_mount_fk | type: CONSTRAINT --
-- ALTER TABLE imports.metadata_import DROP CONSTRAINT IF EXISTS logger_mount_fk CASCADE;
ALTER TABLE imports.metadata_import ADD CONSTRAINT logger_mount_fk FOREIGN KEY (logger_mount_method)
REFERENCES metadata.mounting_types (logger_mount_method) MATCH FULL
ON DELETE NO ACTION ON UPDATE NO ACTION;
-- ddl-end --

-- object: grant_0ff5b2c673 | type: PERMISSION --
GRANT CONNECT
   ON DATABASE seatrack
   TO seatrack_reader;
-- ddl-end --

-- object: grant_e164f99ea7 | type: PERMISSION --
GRANT CONNECT
   ON DATABASE seatrack
   TO seatrack_writer;
-- ddl-end --

-- object: grant_57b178ec24 | type: PERMISSION --
GRANT USAGE
   ON SCHEMA metadata
   TO seatrack_reader;
-- ddl-end --

-- object: grant_565c260782 | type: PERMISSION --
GRANT USAGE
   ON SCHEMA metadata
   TO seatrack_writer;
-- ddl-end --

-- object: grant_be34c9b222 | type: PERMISSION --
GRANT SELECT
   ON TABLE activity.temperature
   TO seatrack_reader;
-- ddl-end --

-- object: grant_a377dd0534 | type: PERMISSION --
GRANT SELECT,INSERT,UPDATE,DELETE,TRIGGER
   ON TABLE activity.temperature
   TO seatrack_writer;
-- ddl-end --

-- object: grant_1868831bab | type: PERMISSION --
GRANT SELECT
   ON TABLE views.active_logging_sessions
   TO seatrack_reader;
-- ddl-end --

-- object: grant_d77875aac0 | type: PERMISSION --
GRANT SELECT
   ON TABLE views.closed_sessions_not_shutdown
   TO seatrack_reader;
-- ddl-end --

-- object: grant_6f6b40bb05 | type: PERMISSION --
GRANT USAGE
   ON SCHEMA views
   TO seatrack_reader;
-- ddl-end --

-- object: grant_5d101cda13 | type: PERMISSION --
GRANT USAGE
   ON SCHEMA activity
   TO seatrack_reader;
-- ddl-end --

-- object: grant_61c7c4b953 | type: PERMISSION --
GRANT USAGE
   ON SCHEMA restricted
   TO restricted;
-- ddl-end --

-- object: grant_706b8dd9b3 | type: PERMISSION --
GRANT SELECT
   ON TABLE restricted.ftp_credentials
   TO restricted;
-- ddl-end --


-- Appended SQL commands --
-----------usage permissions
GRANT USAGE ON SCHEMA metadata, loggers, positions, views, imports, individuals, functions
TO seatrack_reader, seatrack_writer, seatrack_metadata_writer;

----------Reader permissions
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
ON ALL TABLES IN SCHEMA metadata
TO seatrack_metadata_writer;

-------Writer permissions
GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA loggers
TO seatrack_writer;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA individuals
TO seatrack_writer;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA positions
TO seatrack_writer;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA activity
TO seatrack_writer;

GRANT SELECT, INSERT, UPDATE, DELETE, TRIGGER
ON ALL TABLES IN SCHEMA imports
TO seatrack_writer;

GRANT SELECT
ON ALL TABLES IN SCHEMA views
TO seatrack_reader;

GRANT SELECT
ON ALL TABLES IN SCHEMA metadata
TO seatrack_reader;

----------Sequence permissions
GRANT USAGE 
ON ALL SEQUENCES IN SCHEMA metadata 
TO seatrack_writer, seatrack_reader;

GRANT USAGE 
ON ALL SEQUENCES IN SCHEMA loggers 
TO seatrack_writer, seatrack_reader;

GRANT USAGE 
ON ALL SEQUENCES IN SCHEMA individuals 
TO seatrack_writer, seatrack_reader;

GRANT USAGE 
ON ALL SEQUENCES IN SCHEMA imports
TO seatrack_writer, seatrack_reader;

GRANT USAGE 
ON ALL SEQUENCES IN SCHEMA positions 
TO seatrack_writer,  seatrack_reader;




---
