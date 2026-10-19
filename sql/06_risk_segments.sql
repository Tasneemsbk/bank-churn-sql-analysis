-- Bank churn: simple risk score (1 point each: age 40-59, inactive, Germany, not 2 products)

USE bank_churn;


CREATE OR REPLACE VIEW customer_risk AS
SELECT customer_id,
       geography,
       gender,
       age,
       num_products,
       is_active_member,
       balance,
       exited,
       (age BETWEEN 40 AND 59)
     + (is_active_member = 0)
     + (geography = 'Germany')
     + (num_products <> 2)          AS risk_score
FROM customers;


-- Churn by risk score
SELECT risk_score,
       COUNT(*)                     AS customers,
       SUM(exited)                  AS churned,
       ROUND(100 * AVG(exited), 1)  AS churn_pct
FROM customer_risk
GROUP BY risk_score
ORDER BY risk_score;


-- Share of all churn in the high-risk group (score 3-4)
WITH by_group AS (
    SELECT IF(risk_score >= 3, 'high risk (3-4)', 'lower risk (0-2)') AS risk_group,
           COUNT(*)    AS customers,
           SUM(exited) AS churned
    FROM customer_risk
    GROUP BY risk_group
)
SELECT risk_group,
       customers,
       churned,
       ROUND(100 * churned / customers, 1)                  AS churn_pct,
       ROUND(100 * customers / SUM(customers) OVER (), 1)  AS share_of_customers_pct,
       ROUND(100 * churned / SUM(churned) OVER (), 1)      AS share_of_churn_pct
FROM by_group
ORDER BY risk_group;


-- Highest-risk customers still with the bank, biggest balances first
SELECT customer_id, geography, gender, age, num_products,
       IF(is_active_member = 1, 'active', 'inactive') AS activity,
       balance, risk_score
FROM customer_risk
WHERE exited = 0 AND risk_score = 4
ORDER BY balance DESC
LIMIT 10;


-- Summary view for Tableau
CREATE OR REPLACE VIEW churn_by_segment AS
SELECT geography,
       gender,
       CASE WHEN age < 30 THEN '18-29' WHEN age < 40 THEN '30-39'
            WHEN age < 50 THEN '40-49' WHEN age < 60 THEN '50-59' ELSE '60+' END AS age_band,
       num_products,
       IF(is_active_member = 1, 'active', 'inactive') AS activity,
       COUNT(*)    AS customers,
       SUM(exited) AS churned
FROM customers
GROUP BY geography, gender, age_band, num_products, activity;

SELECT COUNT(*) AS segments, SUM(customers) AS customers FROM churn_by_segment;
