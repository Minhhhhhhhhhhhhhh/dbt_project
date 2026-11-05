
SELECT
    ob_id,
	job_title,
	company_name,
	job_location,
	job_via,
	job_posted_at,
	job_salary,
	job_detected_extensions_raw,
	search_time,
	search_date,
	search_term
FROM '../data/raw/raw_job_postings_*.parquet' AS job_postings
where error is null
