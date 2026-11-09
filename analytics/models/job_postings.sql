
SELECT 
	job_id,
	job_title,
	company_name,
	job_location,
	job_via,
	job_salary,
	job_schedule_type,
	job_work_from_home,
	job_extensions_raw,
	(search_time AT TIME ZONE 'Asia/Bangkok')::DATE AS search_date,
	(search_time AT TIME ZONE 'Asia/Bangkok')::TIME AS search_time,
	search_term,
	search_location
FROM {{ source('raw', 'job_postings') }} AS job_postings
where error is null

