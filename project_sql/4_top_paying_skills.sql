/*
Problem Statements:
1. Which skills are associated with higher average salaries for Data Analysts?
2. How does average salary vary by skill in remote Data Analyst roles?
3. What skills provide the highest salary potential for Data Analysts?
*/
SELECT
    skills,
    round(avg(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND
      job_work_from_home = true AND
      salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
