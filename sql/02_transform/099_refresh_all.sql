\set ON_ERROR_STOP on
\i /sql/01_load/010_copy_raw.sql
\i /sql/02_transform/020_staging_transform.sql
\i /sql/03_quality/041_quality_report.sql
\i /sql/02_transform/030_dm_refresh.sql
\i /sql/02_transform/031_dm_marts.sql
