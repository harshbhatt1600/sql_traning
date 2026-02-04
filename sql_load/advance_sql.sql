SELECT
    
    quarter_one_jobs.job_title_short,
    quarter_one_jobs.job_via,
    quarter_one_jobs.job_location,
    quarter_one_jobs.job_posted_date:: date,
    quarter_one_jobs.salary_year_avg
    
FROM(
    SELECT*
    from january_jobs
    UNION ALL
    SELECT*
    from february_jobs
    UNION ALL
    SELECT*
    from march_jobs
)as quarter_one_jobs
WHERE quarter_one_jobs.salary_year_avg>70000 AND quarter_one_jobs.job_title_short='Data Analyst'
ORDER BY quarter_one_jobs.salary_year_avg DESC