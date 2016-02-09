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
"DB_Entry_ID" serial primary key,
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


create table "Study"(
"DB_Study_ID" serial,
"Name" varchar(2048),
"Type" varchar(128),
"Details" text,
primary key("DB_Study_ID")
);


create table "Study_entry_list"(
"DB_Study_ID" int not null,
"DB_BMRB_accession_code" varchar(15),
"BMRB_entry_description" varchar(127),
"Details" text,
primary key ("DB_Study_ID","DB_BMRB_accession_code")
);
ALTER TABLE "Study_entry_list" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Study_ID") REFERENCES "Study"("DB_Study_ID") ON DELETE CASCADE;



create table "Country"(
"DB_Country_ID" serial,
"Name" varchar(127),
primary key ("DB_Country_ID")
);


create table "City_site"(
"DB_City_site_ID" serial,
"DB_Country_ID" int not null,
"Name" varchar(31),
"State" varchar(31),
primary key ("DB_City_site_ID")
);
ALTER TABLE "City_site" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Country_ID") REFERENCES "Country"("DB_Country_ID") ON DELETE CASCADE;


create table "Organization"(
"DB_Organization_ID" serial,
"Name" varchar(127),
"Acronym" varchar(31),
primary key ("DB_Organization_ID")
);
create table "Organization_unit"(
"DB_Org_unit_ID" serial,
"DB_Organization_ID" int not null,
"DB_City_site_ID" int not null,
"Unit_name" varchar(127),
"Address_1" varchar(127),
"Address_2" varchar(127),
"Address_3" varchar(127),
"Address_4" varchar(127),
"Postal_code" varchar(31),
primary key ("DB_Org_unit_ID")
);
ALTER TABLE "Organization_unit" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Organization_ID") REFERENCES "Organization"("DB_Organization_ID") ON DELETE CASCADE;
ALTER TABLE "Organization_unit" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_City_site_ID") REFERENCES "City_site"("DB_City_site_ID") ON DELETE CASCADE;



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
ALTER TABLE "Person_affiliation" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Person_ID") REFERENCES "Person"("DB_Person_ID") ON DELETE CASCADE;
ALTER TABLE "Person_affiliation" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Org_unit_ID") REFERENCES "Organization_unit"("DB_Org_unit_ID") ON DELETE CASCADE;




create table "Project"(
"DB_Project_ID" serial,
"Name" varchar(127),
"Type" varchar(31),
primary key ("DB_Project_ID")
);


create table "Journal"(
"DB_Journal_ID" serial,
"Abbreviation" varchar(127),
"Name" varchar(125),
"EXT_ASTM" varchar(127),
"EXT_ISSN" varchar(127),
"EXT_CSD" varchar(127),
primary key ("DB_Journal_ID")
);

create table "Journal_paper"(
"DB_Doc_ID" int not null,
"DB_Journal_ID" int not null,
"Volume" varchar(31),
"Issue" varchar(31),
primary key ("DB_Doc_ID","DB_Journal_ID")
);
ALTER TABLE "Journal_paper" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Doc_ID") REFERENCES "Document"("DB_Doc_ID") ON DELETE CASCADE;
ALTER TABLE "Journal_paper" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Journal_ID") REFERENCES "Journal"("DB_Journal_ID") ON DELETE CASCADE;


create table "Book"(
"DB_Book_ID" serial,
"Title" varchar(127),
"Volume" varchar(31),
"Series" varchar(127),
"Publisher" varchar(127),
"DB_City_site_ID" int not null,
"EXT_ISBN" varchar(127),
primary key ("DB_Book_ID")
);
ALTER TABLE "Book" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_City_site_ID") REFERENCES "City_site"("DB_City_site_ID") ON DELETE CASCADE;



create table "Book_chapter"(
"DB_Doc_ID" int not null,
"DB_Book_ID" int not null,
"Super_part_title" varchar(127),
primary key ("DB_Doc_ID","DB_Book_ID")
);
ALTER TABLE "Book_chapter" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Doc_ID") REFERENCES "Document"("DB_Doc_ID") ON DELETE CASCADE;
ALTER TABLE "Book_chapter" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Book_ID") REFERENCES "Book"("DB_Book_ID") ON DELETE CASCADE;

create table "Conference"(
"DB_Conference_ID" serial,
"Name" varchar(127),
"Abbreviation" varchar(127),
primary key ("DB_Conference_ID")
);


create table "Conference_instance"(
"DB_Conference_inst_ID" serial,
"DB_Conference_ID" int not null,
"DB_City_site_ID" int not null,
"Start_date" timestamp,
"End_date" timestamp,
"Conf_number" int,
"Conf_publication_name" varchar(127),
primary key ("DB_Conference_inst_ID")
);

ALTER TABLE "Conference_instance" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Conference_ID") REFERENCES "Conference"("DB_Conference_ID") ON DELETE CASCADE;
ALTER TABLE "Conference_instance" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_City_site_ID") REFERENCES "City_site"("DB_City_site_ID") ON DELETE CASCADE;



create table "Conference_abstract"(
"DB_Doc_ID" int not null,
"DB_Conference_inst_ID" int not null,
"Abstract_number" int,
primary key ("DB_Doc_ID","DB_Conference_inst_ID")
);
ALTER TABLE "Conference_abstract" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Doc_ID") REFERENCES "Document"("DB_Doc_ID") ON DELETE CASCADE;
ALTER TABLE "Conference_abstract" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Conference_inst_ID") REFERENCES "Conference_instance"("DB_Conference_inst_ID") ON DELETE CASCADE;






--chemical compond meta data information

create table "Element"(
"DB_Element_ID" serial,
"Symbol" varchar(2) not null,
"Name" varchar(32) not null,
"Atomic_number" int not null,
"Avg_isotopic_atomic_mass" float not null,
"Van_der_Waals_radius" float,
primary key ("DB_Element_ID")
);


create table "Nucleus"(
"DB_Nucleus_ID" serial,
"DB_Element_ID" int not null,
"Isotope_number" int not null,
"Neutron_number" int not null,
"Spin" varchar(4),
"Natural_abundance_percent" float,
"NMR_default" boolean not null,
primary key ("DB_Nucleus_ID")
);
ALTER TABLE "Nucleus" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Element_ID") REFERENCES "Element"("DB_Element_ID") ON DELETE CASCADE;


create table "Electron_system"(
"DB_Electron_system_ID" serial,
"Electron_configuration" varchar(128) not null,
"Unpaired_electron_number" int not null,
"Oxidation_number" int not null,
"Paramagnetic" boolean not null,
primary key ("DB_Electron_system_ID")
);


create table "Atom"(
"DB_Atom_ID" serial,
"DB_Nucleus_ID" int not null,
"DB_Electron_system_ID" int not null,
"Mono_isotopic_atomic_mass" float,
"Bonding_atom" boolean not null,
primary key ("DB_Atom_ID")
);
ALTER TABLE "Atom" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Nucleus_ID") REFERENCES "Nucleus"("DB_Nucleus_ID") ON DELETE CASCADE;
ALTER TABLE "Atom" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Electron_system_ID") REFERENCES "Electron_system"("DB_Electron_system_ID") ON DELETE CASCADE;


--Chemp comp section

create table "Chem_comp"(
"DB_Chem_comp_ID" serial,
"Provenance" varchar(128) not null,
"Type" varchar(128),
"PDBX_type" varchar(128),
"PDBX_ambiguous_flag" boolean,
"PDB_NSTD_flag" boolean,
"Std_deriv_one_letter_code" varchar(16),
"Std_deriv_three_letter_code" varchar(16),
"Std_deriv_BMRB_code" varchar(16),
"Std_deriv_PDB_code" varchar(16),
"Std_deriv_chem_comp_name" varchar(1024),
"Formal_charge" varchar(16),
"Paramagnetic" boolean,
"Aromatic" boolean,
"Formula" varchar(128),
"Formula_weight" float,
"Formula_mono_iso_wt_nat" float,
"Formula_mono_iso_wt_13C" float,
"Formula_mono_iso_wt_15N" float,
"Formula_mono_iso_wt_13C_15N" float,
"Canonical_image_file_name" varchar(128),
"Canonical_image_file_format" varchar(128),
"Canonical_topo_file_name" varchar(128),
"Canonical_topo_file_format" varchar(128),
"Canonical_struct_file_name" varchar(128),
"Canonical_struct_file_format" varchar(128),
"Canonical_stereochem_param_file_name" varchar(128),
"Canonical_stereochem_param_file_format" varchar(128),
primary key ("DB_Chem_comp_ID")
);

create table "Biological_function"(
"DB_Biological_function_ID" serial,
"Biological_function" varchar(4096) not null,
primary key ("DB_Biological_function_ID")
);


create table "Chem_comp_biological_function"(
"DB_Chem_comp_ID" int not null,
"DB_Biological_function_ID" int not null,
primary key ("DB_Chem_comp_ID","DB_Biological_function_ID")
);
ALTER TABLE "Chem_comp_biological_function" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_ID") REFERENCES "Chem_comp"("DB_Chem_comp_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_biological_function" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Biological_function_ID") REFERENCES "Biological_function"("DB_Biological_function_ID") ON DELETE CASCADE;






create table "Vendor"(
"DB_Vendor_ID" serial,
"Name" varchar(2048),
"Address_1" varchar(128),
"Address_2" varchar(128),
"Address_3" varchar(128),
"Address_4" varchar(128),
"DB_City_site_ID" int,
"Postal_code" varchar(31),
"URL" varchar(2048),
primary key("DB_Vendor_ID")
);
ALTER TABLE "Vendor" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_City_site_ID") REFERENCES "City_site"("DB_City_site_ID") ON DELETE CASCADE;


create table "Product"(
"DB_Product_ID" serial,
"DB_Vendor_ID" int,
"Vendor_product_name" varchar(2048),
"Vendor_product_code" varchar(2048),
primary key ("DB_Product_ID")
);

ALTER TABLE "Product" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Vendor_ID") REFERENCES "Vendor"("DB_Vendor_ID") ON DELETE CASCADE;


create table "Chem_comp_product"(
"DB_Chem_comp_ID" int not null,
"DB_Product_ID" int not null,
primary key ("DB_Chem_comp_ID","DB_Product_ID")
);
ALTER TABLE "Chem_comp_product" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_ID") REFERENCES "Chem_comp"("DB_Chem_comp_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_product" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Product_ID") REFERENCES "Product"("DB_Product_ID") ON DELETE CASCADE;


create table "Chem_comp_systematic_name"(
"DB_Chem_comp_ID" int not null,
"Naming_system" varchar(128) not null,
"Name" varchar(4096) not null,
"Name_form" varchar(128),
primary key("DB_Chem_comp_ID","Naming_system","Name")
);
ALTER TABLE "Chem_comp_systematic_name" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_ID") REFERENCES "Chem_comp"("DB_Chem_comp_ID") ON DELETE CASCADE;


create table "Chem_comp_synonym"(
"DB_Chem_comp_ID" int not null,
"Name" varchar(2048) not null,
"Name_form" varchar(128),
primary key ("DB_Chem_comp_ID","Name")
);
ALTER TABLE "Chem_comp_synonym" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_ID") REFERENCES "Chem_comp"("DB_Chem_comp_ID") ON DELETE CASCADE;


create table "Software"(
"DB_Software_ID" serial,
"Name" varchar(128) not null,
"Version" varchar(32),
primary key("DB_Software_ID")
);

create table "Chem_comp_descriptor"(
"DB_Chem_comp_ID" int not null,
"DB_Software_ID" int not null,
"Description_type" varchar(128) not null,
"Descriptor" varchar(2048) not null,
primary key("DB_Chem_comp_ID","DB_Software_ID","Description_type")
);
ALTER TABLE "Chem_comp_descriptor" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_ID") REFERENCES "Chem_comp"("DB_Chem_comp_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_descriptor" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Software_ID") REFERENCES "Software"("DB_Software_ID") ON DELETE CASCADE;



create table "Chem_comp_atom"(
"DB_Chem_comp_atom_ID" serial,
"DB_Chem_comp_ID" int not null,
"DB_Atom_ID" int not null,
"LCL_Chem_comp_atom_num" int,
"Stereo_config" varchar(16),
"Charge" varchar(16),
"Partial_charge" float,
"PDBX_aromatic_flag" boolean,
"PDBX_leaving_atom_flag" boolean,
"Substruct_code" varchar(16),
"Ionizable" boolean,
primary key ("DB_Chem_comp_atom_ID")
);
ALTER TABLE "Chem_comp_atom" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_ID") REFERENCES "Chem_comp"("DB_Chem_comp_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_atom" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Atom_ID") REFERENCES "Atom"("DB_Atom_ID") ON DELETE CASCADE;




create table "Chem_comp_atom_characteristic"(
"DB_Chem_comp_atom_ID" int not null,
"Characteristic_name" varchar(128) not null,
"DB_Doc_ID" int,
"Val" float not null,
"Val_err" float not null,
"Experimental_source" varchar(128) not null,
primary key("DB_Chem_comp_atom_ID","Characteristic_name")
);
ALTER TABLE "Chem_comp_atom_characteristic" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_atom_ID") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_atom_characteristic" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Doc_ID") REFERENCES "Document"("DB_Doc_ID") ON DELETE CASCADE;



create table "Chem_comp_atom_name"(
"DB_Chem_comp_atom_ID" int not null,
"Naming_system" varchar(128) not null,
"Atom_name" varchar(16) not null,
primary key ("DB_Chem_comp_atom_ID","Naming_system")
);
ALTER TABLE "Chem_comp_atom_name" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_atom_ID") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;

create table "Chem_comp_bond"(
"DB_Chem_comp_bond_ID" serial,
"DB_Chem_comp_atom_ID_1" int not null,
"DB_Chem_comp_atom_ID_2" int not null,
"Name" varchar(128),
"Length" float,
"Stero_config" varchar(16),
"Type" varchar(32),
"Value_order" varchar(32),
primary key("DB_Chem_comp_bond_ID")
);
ALTER TABLE "Chem_comp_bond" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_atom_ID_1") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_bond" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Chem_comp_atom_ID_2") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;


create table "Chem_comp_torsion_angle"(
"DB_Chem_comp_torsion_angle_ID" serial,
"DB_Chem_comp_atom_ID_1" int not null,
"DB_Chem_comp_atom_ID_2" int not null,
"DB_Chem_comp_atom_ID_3" int not null,
"DB_Chem_comp_atom_ID_4" int not null,
"Name" varchar(128) not null,
"Angle" float not null,
primary key("DB_Chem_comp_torsion_angle_ID")
);
ALTER TABLE "Chem_comp_torsion_angle" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_atom_ID_1") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_torsion_angle" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Chem_comp_atom_ID_2") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_torsion_angle" ADD CONSTRAINT fk3 FOREIGN KEY ("DB_Chem_comp_atom_ID_3") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_torsion_angle" ADD CONSTRAINT fk4 FOREIGN KEY ("DB_Chem_comp_atom_ID_4") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;


create table "Chem_comp_angle"(
"DB_Chem_comp_angle_ID" serial,
"DB_Chem_comp_atom_ID_1" int not null,
"DB_Chem_comp_atom_ID_2" int not null,
"DB_Chem_comp_atom_ID_3" int not null,
"Name" varchar(128) not null,
"Angle" float not null,
primary key ("DB_Chem_comp_angle_ID")
);
ALTER TABLE "Chem_comp_angle" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_atom_ID_1") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_angle" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Chem_comp_atom_ID_2") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_angle" ADD CONSTRAINT fk3 FOREIGN KEY ("DB_Chem_comp_atom_ID_3") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;

create table "Chem_comp_atom_group"(
"DB_Chem_comp_atom_group_ID" serial,
"Name" varchar(128) not null,
primary key("DB_Chem_comp_atom_group_ID")
);

create table "Chem_comp_atom_group_characteristic"(
"DB_Chem_comp_atom_group_ID" int not null,
"Characteristic_name" varchar(128) not null,
"DB_Doc_ID" int,
"Val" float not null,
"Val_err" float,
"Experimental_source" varchar(128),
primary key("DB_Chem_comp_atom_group_ID","Characteristic_name")
);
ALTER TABLE "Chem_comp_atom_group_characteristic" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_atom_group_ID") REFERENCES "Chem_comp_atom_group"("DB_Chem_comp_atom_group_ID") ON DELETE CASCADE;

create table "Chem_comp_atom_group_atom"(
"DB_Chem_comp_atom_group_ID" int not null,
"DB_Chem_comp_atom_ID" int not null,
primary key ("DB_Chem_comp_atom_group_ID","DB_Chem_comp_atom_ID")
);
ALTER TABLE "Chem_comp_atom_group_atom" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Chem_comp_atom_group_ID") REFERENCES "Chem_comp_atom_group"("DB_Chem_comp_atom_group_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_atom_group_atom" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Chem_comp_atom_ID") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;


create table "Ambiguity_code"(
"DB_Ambiguity_code_ID" serial,
"Details" text not null,
primary key ("DB_Ambiguity_code_ID")
);


create table "Chem_comp_allowed_amb_code"(
"DB_Chem_comp_atom_ID" int not null,
"DB_Ambiguity_code_ID" int not null,
"Default" boolean not null,
primary key ("DB_Chem_comp_atom_ID","DB_Ambiguity_code_ID")
);
ALTER TABLE "Chem_comp_allowed_amb_code" ADD CONSTRAINT fk1 FOREIGN KEY ("DB_Ambiguity_code_ID") REFERENCES "Ambiguity_code"("DB_Ambiguity_code_ID") ON DELETE CASCADE;
ALTER TABLE "Chem_comp_allowed_amb_code" ADD CONSTRAINT fk2 FOREIGN KEY ("DB_Chem_comp_atom_ID") REFERENCES "Chem_comp_atom"("DB_Chem_comp_atom_ID") ON DELETE CASCADE;
--Tested upto this point


--Entity section
create table "Entity"(
"DB_Entity_ID" serial,
"Type" varchar(128),
"Polymer_common_type" varchar(31),
"Polymer_type" varchar(31),
"Polymer_type_details" text,
"Polymer_seq_one_letter_code_can" text,
"Polymer_seq_one_letter_code" text,
"Ambiguous_conformational_states" varchar(3),
"Ambiguous_chem_comp_sites" varchar(3),
"Nstd_monomer" varchar(3),
"Nstd_chirality" varchar(3),
"Nstd_linkage" varchar(3),
"Number_of_chem_comps" int,
"Number_of_nonpolymer_components" int,
"Paramagnetic" varchar(13),
"Thiol_state" varchar(127),
"Src_method" varchar(127),
"Parent_entity_ID" int,
"Fragment" text,
"Mutation" text,
"Calc_isoelectric_point" float,
"Formula_weight" float,
"Formula_weight_exptl" float,
"Formula_weight_exptl_meth" varchar(127),
);
