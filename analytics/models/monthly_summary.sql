-- models/monthly_summary.sql: monthly totals + remote share from two refs
{{ config(
	materialized='table'
)}}

WITH totals AS (
    SELECT search_month, SUM(postings) AS total_postings
    FROM {{ ref('job_per_month') }}
    GROUP BY search_month
),
remote AS (
    SELECT DATE_TRUNC('month', search_date) AS search_month, COUNT(*) AS remote_postings
    FROM {{ ref('job_postings') }}
    WHERE job_work_from_home
    GROUP BY search_month
)

SELECT search_month, total_postings, remote_postings,
       ROUND(100.0 * remote_postings / total_postings, 1) AS pct_remote
FROM totals
JOIN remote USING (search_month)
ORDER BY search_month
