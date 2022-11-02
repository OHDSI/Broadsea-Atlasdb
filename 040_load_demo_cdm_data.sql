-- load cdm tables that have data

set search_path = demo_cdm;

set datestyle to 'ymd';
copy care_site from '/tmp/demo_cdm_csv_files/care_site.csv' with csv header;
copy cdm_source from '/tmp/demo_cdm_csv_files/cdm_source.csv' with csv header;
--copy cohort_definition from '/tmp/demo_cdm_csv_files/cohort_definition.csv' with csv header;
--copy cohort from '/tmp/demo_cdm_csv_files/cohort.csv' with csv header;
copy concept_ancestor from '/tmp/demo_cdm_csv_files/concept_ancestor.csv' with csv header;
copy concept_class from '/tmp/demo_cdm_csv_files/concept_class.csv' with csv header;
copy concept_relationship from '/tmp/demo_cdm_csv_files/concept_relationship.csv' with csv header;
copy concept_synonym from '/tmp/demo_cdm_csv_files/concept_synonym.csv' with csv header;
copy concept from '/tmp/demo_cdm_csv_files/concept.csv' with csv header;
--copy concept from '/tmp/demo_cdm_csv_files/omop_generated_metadata_concepts.csv' with csv header;
copy condition_era from '/tmp/demo_cdm_csv_files/condition_era.csv' with csv header;
copy condition_occurrence from '/tmp/demo_cdm_csv_files/condition_occurrence.csv' with csv header;
copy cost from '/tmp/demo_cdm_csv_files/cost.csv' with csv header;
copy death from '/tmp/demo_cdm_csv_files/death.csv' with csv header;
copy device_exposure from '/tmp/demo_cdm_csv_files/device_exposure.csv' with csv header;
copy domain from '/tmp/demo_cdm_csv_files/domain.csv'  with csv header;
copy dose_era from '/tmp/demo_cdm_csv_files/dose_era.csv'  with csv header;
copy drug_era from '/tmp/demo_cdm_csv_files/drug_era.csv' with csv header;
copy drug_exposure from '/tmp/demo_cdm_csv_files/drug_exposure.csv' with csv header;
copy drug_strength from '/tmp/demo_cdm_csv_files/drug_strength.csv' with csv header;
--copy episode_event from '/tmp/demo_cdm_csv_files/episode_event.csv' with csv header;
--copy episode from '/tmp/demo_cdm_csv_files/episode.csv' with csv header;
copy fact_relationship from '/tmp/demo_cdm_csv_files/fact_relationship.csv' with csv header;
copy location from '/tmp/demo_cdm_csv_files/location.csv' with csv header;
copy measurement from '/tmp/demo_cdm_csv_files/measurement.csv' with csv header;
copy metadata from '/tmp/demo_cdm_csv_files/metadata.csv' with csv header;
copy note_nlp from '/tmp/demo_cdm_csv_files/note_nlp.csv' with csv header;
copy note from '/tmp/demo_cdm_csv_files/note.csv' with csv header;
copy observation_period from '/tmp/demo_cdm_csv_files/observation_period.csv' with csv header;
copy observation from '/tmp/demo_cdm_csv_files/observation.csv' with csv header;
copy payer_plan_period from '/tmp/demo_cdm_csv_files/payer_plan_period.csv' with csv header;
copy person from '/tmp/demo_cdm_csv_files/person.csv' with csv header;
copy procedure_occurrence from '/tmp/demo_cdm_csv_files/procedure_occurrence.csv' with csv header;
copy provider from '/tmp/demo_cdm_csv_files/provider.csv' with csv header;
copy relationship from '/tmp/demo_cdm_csv_files/relationship.csv' with csv header;
copy source_to_concept_map from '/tmp/demo_cdm_csv_files/source_to_concept_map.csv' with csv header;
copy specimen from '/tmp/demo_cdm_csv_files/specimen.csv' with csv header;
copy visit_detail from '/tmp/demo_cdm_csv_files/visit_detail.csv' with csv header;
copy visit_occurrence from '/tmp/demo_cdm_csv_files/visit_occurrence.csv' with csv header;
copy vocabulary from '/tmp/demo_cdm_csv_files/vocabulary.csv' with csv header;


-- load demo cdm achilles data into cdm results achilles tables

set search_path = demo_cdm_results;
--
copy achilles_analysis from '/tmp/demo_cdm_csv_files/achilles_analysis.csv' with csv header;
--copy achilles_heel_results from '/tmp/demo_cdm_csv_files/achilles_heel_results.csv' with csv header;
copy achilles_results from '/tmp/demo_cdm_csv_files/achilles_results.csv' with csv header;
--copy achilles_results_derived from '/tmp/demo_cdm_csv_files/achilles_results_derived.csv' with csv header;
copy achilles_results_dist from '/tmp/demo_cdm_csv_files/achilles_results_dist.csv' with csv header;
--
set search_path = demo_cdm;

