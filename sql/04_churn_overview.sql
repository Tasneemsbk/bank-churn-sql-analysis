-- Bank churn: who leaves? Churn rate = share of customers with exited = 1.

USE bank_churn;


-- Overall churn rate
SELECT COUNT(*)                     AS customers,
       SUM(exited)                  AS churned,
       ROUND(100 * AVG(exited), 1)  AS churn_pct
FROM customers;


-- Churn by country and gender, with subtotals (WITH ROLLUP)
SELECT IF(GROUPING(geography), 'All', geography) AS geography,
       IF(GROUPING(gender), 'All', gender)       AS gender,
       COUNT(*)                                  AS customers,
       ROUND(100 * AVG(exited), 1)               AS churn_pct
FROM customers
GROUP BY geography, gender WITH ROLLUP;


-- Churn by age band
SELECT CASE
           WHEN age < 30 THEN '18-29'
           WHEN age < 40 THEN '30-39'
           WHEN age < 50 THEN '40-49'
           WHEN age < 60 THEN '50-59'
           ELSE '60+'
       END                          AS age_band,
       COUNT(*)                     AS customers,
       SUM(exited)                  AS churned,
       ROUND(100 * AVG(exited), 1)  AS churn_pct
FROM customers
GROUP BY age_band
ORDER BY age_band;


-- Age and gender together
SELECT gender,
       CASE WHEN age < 40 THEN 'under 40' WHEN age < 60 THEN '40-59' ELSE '60+' END AS age_group,
       COUNT(*)                    AS customers,
       ROUND(100 * AVG(exited), 1) AS churn_pct
FROM customers
GROUP BY gender, age_group
ORDER BY gender, FIELD(age_group, 'under 40', '40-59', '60+');


-- Average profile of churned against retained customers
SELECT IF(exited = 1, 'churned', 'retained') AS status,
       COUNT(*)                         AS customers,
       ROUND(AVG(age), 1)               AS avg_age,
       ROUND(AVG(credit_score), 1)      AS avg_credit_score,
       ROUND(AVG(tenure), 2)            AS avg_tenure_years,
       ROUND(AVG(balance), 0)           AS avg_balance,
       ROUND(AVG(estimated_salary), 0)  AS avg_salary,
       ROUND(AVG(num_products), 2)      AS avg_products
FROM customers
GROUP BY exited;
