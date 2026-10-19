-- Bank churn: products, activity and balances

USE bank_churn;


-- Churn by number of products (3-4 products: only 326 customers)
SELECT num_products,
       COUNT(*)                     AS customers,
       SUM(exited)                  AS churned,
       ROUND(100 * AVG(exited), 1)  AS churn_pct
FROM customers
GROUP BY num_products
ORDER BY num_products;


-- Products and activity together
SELECT num_products,
       IF(is_active_member = 1, 'active', 'inactive') AS activity,
       COUNT(*)                                       AS customers,
       ROUND(100 * AVG(exited), 1)                    AS churn_pct
FROM customers
GROUP BY num_products, activity
ORDER BY num_products, activity;


-- Balance, split by country (Germany has no zero balances)
SELECT geography,
       IF(balance > 0, 'has balance', 'zero balance') AS balance_group,
       COUNT(*)                                        AS customers,
       ROUND(AVG(balance), 0)                          AS avg_balance,
       ROUND(100 * AVG(exited), 1)                     AS churn_pct
FROM customers
GROUP BY geography, balance_group
ORDER BY geography, balance_group;


-- Credit score and salary in fifths (NTILE)
WITH quintiles AS (
    SELECT exited,
           NTILE(5) OVER (ORDER BY credit_score)     AS credit_q,
           NTILE(5) OVER (ORDER BY estimated_salary) AS salary_q
    FROM customers
)
SELECT q.quintile,
       ROUND(100 * AVG(CASE WHEN credit_q = q.quintile THEN exited END), 1) AS churn_pct_by_credit_score,
       ROUND(100 * AVG(CASE WHEN salary_q = q.quintile THEN exited END), 1) AS churn_pct_by_salary
FROM quintiles
CROSS JOIN (SELECT 1 AS quintile UNION ALL SELECT 2 UNION ALL SELECT 3
            UNION ALL SELECT 4 UNION ALL SELECT 5) q
GROUP BY q.quintile
ORDER BY q.quintile;

SELECT tenure,
       COUNT(*)                    AS customers,
       ROUND(100 * AVG(exited), 1) AS churn_pct
FROM customers
GROUP BY tenure
ORDER BY tenure;


-- Card type and satisfaction score
SELECT card_type,
       COUNT(*)                    AS customers,
       ROUND(100 * AVG(exited), 1) AS churn_pct
FROM customers
GROUP BY card_type
ORDER BY churn_pct DESC;

SELECT satisfaction_score,
       COUNT(*)                    AS customers,
       ROUND(100 * AVG(exited), 1) AS churn_pct
FROM customers
GROUP BY satisfaction_score
ORDER BY satisfaction_score;
