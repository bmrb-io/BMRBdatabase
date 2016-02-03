-- create table sql script for curated database

create table "Document"(
"DB_Doc_ID" serial primary key,
"EXT_CAS_abstract_code" varchar(31),
"EXT_MEDLINE_UI_code" varchar(31),
"EXT_DOI" varchar(31),
"EXT_PubMed_ID" varchar(31),
"Title" text,
"Status" varchar(31),
"Class" varchar(31) not null,
"URL" varchar(127),
"Page_first" int,
"Page_last" int,
"Year" int
);

CREATE TABLE "Entry"
(
"DB_Doc_ID" int not null,
"DB_entry_ID" serial primary key,
"Title" text not null,
"Version_type" varchar(127) not null,
"Submission_date" timestamp not null,
"Accession_date" timestamp   not null,
"Last_release_date" timestamp,
"Original_release_date" timestamp  ,
"Origination" varchar(31) not null,
"NMR_STAR_version" varchar(31) not null,
"Original_NMR_STAR_version" varchar(31),
"Experimental_method" varchar(127) not null,
"Experimental_method_subtype" varchar(31),
"Dep_release_code_coordinates" varchar(31),
"Dep_release_code_nmr_constraints" varchar(31),
"Dep_release_code_chemical_shifts" varchar(31),
"Dep_release_code_nmr_exptl" varchar(31),
"Dep_release_code_sequence" varchar(31),
"CASP_target" varchar(31),
"Details" text,
"Special_processing_instructions" text,
"Update_BMRB_accession_code" char(12),
"Replace_BMRB_accession_code" char(12),
"Update_PDB_accession_code" varchar(15),
"Replace_PDB_accession_code" varchar(15),
"BMRB_update_details" text,
"PDB_update_details" text,
"Release_request" varchar(127),
"Release_date_request" timestamp  ,
"Release_date_justification" text,
"Status_code" varchar(31),
"Recvd_deposit_form" varchar(3),
"Date_deposition_form" timestamp  ,
"Recvd_coordinates" varchar(3),
"Date_coordinates" timestamp  ,
"Recvd_nmr_constraints" varchar(3),
"Date_nmr_constraints" timestamp  ,
"Recvd_chemical_shifts" varchar(3),
"Date_chemical_shifts" timestamp  ,
"Recvd_manuscript" varchar(3),
"Date_manuscript" timestamp  ,
"Recvd_author_approval" varchar(3),
"Date_author_approval" timestamp  ,
"Recvd_initial_deposition_date" varchar(3),
"PDB_date_submitted" timestamp  ,
"Author_release_status_code" varchar(31),
"Date_of_PDB_release" timestamp  ,
"Date_hold_coordinates" timestamp  ,
"Date_hold_nmr_constraints" timestamp  ,
"Date_hold_chemical_shifts" timestamp  ,
"PDB_deposit_site" varchar(31),
"PDB_process_site" varchar(31),
"BMRB_deposit_site" varchar(31),
"BMRB_process_site" varchar(31),
"BMRB_annotator" varchar(31),
"BMRB_internal_directory_name" varchar(255),
"RCSB_annotator" varchar(31),
"Author_approval_type" varchar(31),
"Assigned_BMRB_accession_code" varchar(15),
"Assigned_BMRB_deposition_code" varchar(15),
"Assigned_PDB_accession_code" varchar(15),
"Assigned_PDB_deposition_code" varchar(15),
"Assigned_restart_ID" varchar(255)
);
ALTER TABLE "Entry" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Doc_ID") REFERENCES "Document"("DB_Doc_ID") ON DELETE CASCADE;


create table "Study_entry_list"(
"DB_Study_ID" serial,
"DB_BMRB_accession_code" char(12),
"BMRB_entry_description" varchar(127),
"Details" text,
primary key ("DB_Study_ID","DB_BMRB_accession_code")
);

create table "Person_affiliation"(
"DB_Person_affiliations_ID" serial,
"DB_Person_ID" int not null,
"DB_Org_unit_ID" int not null,
"From_date" timestamp,
"To_date" timestamp,
"Email_address" varchar(127),
"Mailing_address_ext" varchar(127),
"Phone_number" varchar(31),
"Cell_phone_number" varchar(31),
"FAX_number" varchar(31),
"URL" varchar(127),
primary key ("DB_Person_affiliations_ID")
);


create table "Person"(
"DB_Person_ID" serial,
"Name_salutation" varchar(31),
"Given_name" varchar(31),
"Family_name" varchar(31),
"First_initial" varchar(15),
"Middle_initials" varchar(15),
"Family_title" varchar(15),
primary key ("DB_Person_ID")
);


create table "Project"(
"DB_Project_ID" serial,
"Name" varchar(127),
"Type" varchar(31),
primary key ("DB_Project_ID")
);


create table "Organization"(
"DB_Organization_ID" serial,
"Name" varchar(127),
"Acronym" varchar(31),
primary key ("DB_Organization_ID")
);


create table "Organization_unit"(
"DB_Org_unit_ID" serial,
"DB_Organization_ID" int not null,
"DB_City_Site_ID" int not null,
"Unit_name" varchar(127),
"Address_1" varchar(127),
"Address_2" varchar(127),
"Address_3" varchar(127),
"Address_4" varchar(127),
"Postal_code" varchar(31),
primary key ("DB_Org_unit_ID")
);

create table "City_Site"(
"DB_City_Site_ID" serial,
"DB_Country_ID" int not null,
"Name" varchar(31),
"State" varchar(31),
primary key ("DB_City_Site_ID")
);

create table "Country"(
"DB_Country_ID" serial,
"Name" varchar(127),
primary key ("DB_Country_ID")
);


--alter table City_Site add foreign key (DB_Country_ID) references Country(DB_Country_ID);
ALTER TABLE "City_Site" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Country_ID") REFERENCES "Country"("DB_Country_ID") ON DELETE CASCADE;
--alter table Organization_unit add foreign key (DB_Organization_ID) references Organization(DB_Organization_ID);
ALTER TABLE "Organization_unit" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Organization_ID") REFERENCES "Organization"("DB_Organization_ID") ON DELETE CASCADE;
--alter table Organization_unit add foreign key (DB_City_Site_ID) references City_Site(DB_City_Site_ID);
ALTER TABLE "Organization_unit" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_City_Site_ID") REFERENCES "City_Site"("DB_City_Site_ID") ON DELETE CASCADE;
--alter table Person_affiliation add foreign key (DB_Person_ID) references Person(DB_Person_ID);
ALTER TABLE "Person_affiliation" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Person_ID") REFERENCES "Person"("DB_Person_ID") ON DELETE CASCADE;
--alter table Person_affiliation add foreign key (DB_Org_unit_ID) references Organization_unit(DB_Org_unit_ID);
ALTER TABLE "Person_affiliation" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Org_unit_ID") REFERENCES "Organization_unit"("DB_Org_unit_ID") ON DELETE CASCADE;
