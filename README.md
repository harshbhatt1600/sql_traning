# Introduction
This project focuses on analyzing the Data Analyst job market using SQL.  
The goal is to understand salary trends, in-demand skills, and which technical skills provide the best balance between market demand and compensation, with a focus on remote roles.

---

# Background
The demand for Data Analysts continues to grow, but not all skills provide the same career or salary outcomes.  
This project uses real job posting data to answer practical questions such as:
- Which Data Analyst roles pay the most?
- What skills are most frequently required?
- Which skills are associated with higher salaries?

The analysis is designed to help aspiring Data Analysts make informed learning and career decisions.

---

# Tools I Used
The following tools and technologies were used to complete this project:
- **SQL (PostgreSQL)** for data querying and analysis  
- **pgAdmin** for executing SQL queries  
- **VS Code** for writing and organizing SQL scripts  
- **Git & GitHub** for version control and project documentation  

---

# The Analysis
The analysis was broken into multiple focused SQL queries, each answering a specific business question:

- Identified the **top-paying remote Data Analyst roles**.
- Analyzed the **skills required for high-paying jobs**.
- Determined the **most in-demand skills** for remote Data Analyst positions.
- Calculated the **average salary associated with each skill**.
- Identified **optimal skills** that balance both high demand and high salary.

Each query builds on the previous one to form a complete picture of the Data Analyst job market.


 **Which remote Data Analyst roles offer the highest salaries?**
```sql
SELECT 
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM job_postings_fact
LEFT JOIN company_dim 
    ON company_dim.company_id = job_postings_fact.company_id
WHERE job_title_short = 'Data Analyst'
  AND job_location = 'Anywhere'
  AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10;
```
### Top 10 Highest Paying Remote Data Analyst Jobs



| Job Title                                   | Job Location |
|--------------------------------------------|--------------|
| Data Analyst                                | Anywhere     |
| Director of Analytics                      | Anywhere     |
| Associate Director – Data Insights         | Anywhere     |
| Data Analyst, Marketing                    | Anywhere     |
| Data Analyst (Hybrid/Remote)               | Anywhere     |
| Principal Data Analyst (Remote)            | Anywhere     |
| Director, Data Analyst – Hybrid            | Anywhere     |
| Principal Data Analyst, AV Performance     | Anywhere     |
| Principal Data Analyst                     | Anywhere     |
| ERM Data Analyst                           | Anywhere     |

**Insight:**  
Senior and leadership-level Data Analyst roles, especially those requiring advanced analytics and cloud expertise, command significantly higher salaries in remote and hybrid job markets.

 **What skills are required for the highest-paying remote Data Analyst roles?**

```sql
WITH top_paying_jobs AS (
    SELECT 
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM job_postings_fact
    LEFT JOIN company_dim 
        ON company_dim.company_id = job_postings_fact.company_id
    WHERE job_title_short = 'Data Analyst'
      AND job_location = 'Anywhere'
      AND salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim 
    ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC;
```
### Top Paying Data Analyst Roles and Associated Skills (Sample)
![Analysis Output](assests\output.png)



**Insight:**  
Top-paying Data Analyst roles consistently require strong SQL and Python skills, with visualization tools and cloud platforms frequently appearing as complementary requirements for higher compensation.

 **Which skills are most in demand for remote Data Analyst roles?**

```sql
SELECT 
    skills,
    COUNT(job_postings_fact.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim 
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim 
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND job_work_from_home = TRUE
GROUP BY skills
ORDER BY demand_count DESC
LIMIT 5;
```
### Most In-Demand Skills for Remote Data Analyst Roles

| Skill     | Demand Count |
|-----------|--------------|
| SQL       | 7,291        |
| Excel     | 4,611        |
| Python    | 4,330        |
| Tableau   | 3,745        |
| Power BI | 2,609        |
**Insight:**  
SQL is the most in-demand skill for remote Data Analyst roles by a significant margin, indicating that strong database querying skills are essential. Excel and Python remain highly valued, while visualization tools like Tableau and Power BI continue to play a critical role in data analysis and reporting.

 **Which skills are associated with higher average salaries for remote Data Analyst roles?**

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim
    ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim
    ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE job_title_short = 'Data Analyst'
  AND job_work_from_home = TRUE
  AND salary_year_avg IS NOT NULL
GROUP BY skills
ORDER BY avg_salary DESC
LIMIT 25;
```
### Top Skills by Average Salary (Remote Data Analyst Roles)

| Skill        | Average Salary (USD) |
|--------------|----------------------|
| PySpark      | 208,172              |
| Bitbucket    | 189,155              |
| Couchbase    | 160,515              |
| Watson       | 160,515              |
| DataRobot    | 155,486              |
| GitLab       | 154,500              |
| Swift        | 153,750              |
| PostgreSQL   | 123,879              |

**Insight:**  
Skills associated with big data processing, DevOps, and advanced analytics frameworks command higher average salaries. PostgreSQL’s presence highlights the continued importance of strong database skills alongside modern data engineering and cloud-oriented tools.

**Which Data Analyst skills provide the best balance between high demand and high salary?**

```sql
WITH skill_demand AS (
    SELECT 
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(job_postings_fact.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim 
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim 
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
      AND job_work_from_home = TRUE
    GROUP BY skills_dim.skill_id, skills_dim.skills
),
average_salary AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim
        ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim
        ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE job_title_short = 'Data Analyst'
      AND job_work_from_home = TRUE
      AND salary_year_avg IS NOT NULL
    GROUP BY skills_dim.skill_id, skills_dim.skills
)
SELECT 
    skill_demand.skill_id,
    skill_demand.skills,
    demand_count,
    avg_salary
FROM skill_demand
INNER JOIN average_salary 
    ON skill_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY avg_salary DESC,
         demand_count DESC
LIMIT 25;
```
### Top 10 High-Paying Skills for Remote Data Analyst Roles

| Skill          | Demand Count | Average Salary (USD) |
|----------------|--------------|----------------------|
| PySpark        | 111          | 208,172              |
| Bitbucket      | 38           | 189,155              |
| GitLab         | 57           | 154,500              |
| Swift          | 32           | 153,750              |
| Jupyter        | 83           | 152,777              |
| Pandas         | 291          | 151,821              |
| Elasticsearch  | 33           | 145,000              |
| NumPy          | 171          | 143,513              |
| Databricks     | 277          | 141,907              |
| Linux          | 115          | 136,508              |

---

# What I Learned
Through this project, I learned:
- How to write complex SQL queries using **CTEs, joins, aggregations, and filtering**.
- How to structure SQL projects in a clean, readable, and scalable way.
- How to translate raw data into **meaningful business insights**.
- How skill demand and salary do not always correlate, making data-driven analysis essential.

This project also improved my confidence in working with real-world datasets.

---

# Conclusions
The analysis shows that skills such as **SQL and Python** remain foundational for Data Analyst roles, while cloud and data-engineering tools are increasingly linked to higher salaries.  
Focusing on skills that are both **in-demand and well-paid** can significantly improve career outcomes for Data Analysts.

This project demonstrates how SQL can be used not just for querying data, but for answering real market-driven questions.
