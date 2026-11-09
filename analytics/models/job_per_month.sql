
SELECT 
    DATE_TRUNC('month', search_date) AS search_month,
    search_term as role,
    count(*) AS postings
FROM {{ ref('job_postings') }}
GROUP BY 1, 2
ORDER BY 1, 2

