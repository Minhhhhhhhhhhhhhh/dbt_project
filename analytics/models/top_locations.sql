

SELECT 
    job_location,
    count(1) AS postings
FROM {{ ref('job_postings') }} 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

