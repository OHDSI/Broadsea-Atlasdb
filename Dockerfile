ARG PASSWORD_METHOD=default

#
# Vendored build: use pre-generated SQL artifacts committed under vendor
# If you need to regenerate those artifacts, run: make regen-webapi-sql
#

FROM postgres:16.4-alpine AS data-loader-image

WORKDIR /tmp

EXPOSE 5432

# configure postgres database defaults
ENV PGDATA=/data
ENV PGOPTIONS="--search_path=demo_cdm"

# copy the concept recommended csv data file into the container image for Atlas Phoebe recommendations function
COPY ./concept_recommended.csv.gz /tmp/concept_recommended.csv.gz

# copy the atlas demo cdm csv data files into the container image
COPY ./demo_cdm_csv_files/*.csv.gz /tmp/demo_cdm_csv_files/

# copy the below SQL files into the container image - postgresql database will automatically run them in this sequence when it starts up

# 010 - create empty atlas demo_cdm & atlas demo_cdm_results schemas
COPY ./010_create_demo_cdm_schemas.sql /docker-entrypoint-initdb.d/010_create_demo_cdm_schemas.sql

# 020 - create atlas demo_cdm schema tables - use vendored SQL
COPY ./vendor/cdm/omop_cdm_postgres_ddl.sql /docker-entrypoint-initdb.d/020_omop_cdm_postgresql_ddl.sql

# 030 - create empty achilles tables in the atlas demo_cdm_results schema
COPY ./030_achilles_postgresql_ddl.sql /docker-entrypoint-initdb.d/030_achilles_postgresql_ddl.sql

# 035 - create concept_recommended table in the atlas demo_cdm schema for Atlas Phoebe recommendations functionality
COPY ./035_concept_recommended.ddl.sql /docker-entrypoint-initdb.d/035_concept_recommended.ddl.sql

# 037 - load concept recommended csv data into the atlas demo_cdm schema concept_recommended table 
COPY ./037_load_concept_recommended_data.sql /docker-entrypoint-initdb.d/037_load_concept_recommended_data.sql

# 040 - load atlas demo cdm csv data into the atlas demo_cdm schema tables & achilles data into atlas demo_cdm_results schema achilles tables
COPY ./040_load_demo_cdm_data.sql /docker-entrypoint-initdb.d/040_load_demo_cdm_data.sql

# 045 - create atlas demo_cdm schema table primary keys
COPY ./045_omop_cdm_postgresql_primary_keys.sql /docker-entrypoint-initdb.d/045_omop_cdm_postgresql_primary_keys.sql

# 050 - create atlas demo_cdm schema table indexes
COPY ./050_omop_cdm_postgresql_indexes.sql /docker-entrypoint-initdb.d/050_omop_cdm_postgresql_indexes.sql

# 060 - create atlas demo_cdm schema table database constraints - referential integrity
#COPY ./060_omop_cdm_postgresql_constraints.sql /docker-entrypoint-initdb.d/060_omop_cdm_postgresql_constraints.sql

# 065 - create the atlas demo_cdm_results schema tables - use vendored SQL
COPY ./vendor/webapi/results_postgresql.ddl /docker-entrypoint-initdb.d/065_results_schema_ddl_postgresql.sql

# 070 - create an empty webapi schema
COPY ./070_create_webapi_schema_postgresql.sql /docker-entrypoint-initdb.d/070_create_webapi_schema_postgresql.sql

# 075 - apply the webapi schema tables flyway database migration postgresql SQL files up to baseline version V2.2.5.20180212152023 - use vendored SQL
COPY ./vendor/webapi/webapi_baseline_V2.2.5.20180212152023_postgresql.sql /docker-entrypoint-initdb.d/075_webapi_flyway_migrations_postgresql.sql

# 080 - create and populate webapi_security schema - Atlas ohdsi and admin users
COPY ./080_create_and_populate_webapi_security_schema.sql /docker-entrypoint-initdb.d/080_create_and_populate_webapi_security_schema.sql

# 090 - create and populate webapi roles and users - Atlas ohdsi and admin user roles
COPY ./090_create_sec_roles_and_users.sql /docker-entrypoint-initdb.d/090_create_sec_roles_and_users.sql

# 100 - populate the source and source daimon tables in the Atlas webapi schema - enables Atlas connection to this Atlas postgresql database with a demo CDM
COPY ./100_populate_source_source_daimon.sql /docker-entrypoint-initdb.d/100_populate_source_source_daimon.sql

# 110 - create the flyway data migration history table
COPY ./110_create_flyway_schema_history_table.sql /docker-entrypoint-initdb.d/110_create_flyway_schema_history_table.sql

# 120 - populate the flyway database migration history table with the correct entries up to baseline version V2.2.5.20180212152023
# Atlas will automatically migrate the webapi schema tables from this baseline version to the latest version when it starts up and connects to this Atlas postgresql database with a demo CDM
COPY ./120_populate_flyway_schema_history_table.sql /docker-entrypoint-initdb.d/120_populate_flyway_schema_history_table.sql

# 130 - load demo Atlas cohort definitions
COPY ./130_load_demo_atlas_cohort_definitions.sql /docker-entrypoint-initdb.d/130_load_sample_atlas_cohort_definitions.sql

# 140 - load demo Atlas concept set definitions
COPY ./140_load_demo_atlas_conceptset_definitions.sql /docker-entrypoint-initdb.d/140_load_sample_atlas_conceptset_definitions.sql

RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

# Pseudo branching logic - we run 2 stages, 1 for default password auth, the other for secrets auth
FROM data-loader-image AS use-password-default
ENV POSTGRES_PASSWORD=mypass
RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

FROM data-loader-image AS use-password-secret
ENV POSTGRES_PASSWORD_FILE="/run/secrets/ATLASDB_POSTGRES_PASSWORD"
RUN --mount=type=secret,id=ATLASDB_POSTGRES_PASSWORD \
    ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

# then pick the stage based on the PASSWORD_METHOD
FROM use-password-${PASSWORD_METHOD} AS data-loader-image-final


# run the postgres entrypoint script to run the SQL scripts and load the data but do not start the postgres daemon process
FROM postgres:16.4-alpine
COPY --from=data-loader-image-final /data $PGDATA
