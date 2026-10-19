-- Bank churn: data checks

USE bank_churn;


-- Row count and duplicate IDs
SELECT COUNT(*)                    AS customers,
       COUNT(DISTINCT customer_id) AS distinct_ids
FROM customers;


-- Value ranges
SELECT MIN(credit_score) AS min_credit, MAX(credit_score) AS max_credit,
       MIN(age)          AS min_age,    MAX(age)          AS max_age,
       MIN(tenure)       AS min_tenure, MAX(tenure)       AS max_tenure,
       MIN(balance)      AS min_balance, MAX(balance)     AS max_balance,
       MIN(num_products) AS min_products, MAX(num_products) AS max_products,
       MIN(satisfaction_score) AS min_sat, MAX(satisfaction_score) AS max_sat
FROM customers;


-- Category values
SELECT geography, gender, COUNT(*) AS customers
FROM customers
GROUP BY geography, gender
ORDER BY geography, gender;

SELECT card_type, COUNT(*) AS customers
FROM customers
GROUP BY card_type;


-- Zero balances: 36% of customers, none in Germany
SELECT geography,
       COUNT(*)                          AS customers,
       SUM(balance = 0)                  AS zero_balance,
       ROUND(100 * AVG(balance = 0), 1)  AS zero_balance_pct,
       ROUND(AVG(balance), 0)            AS avg_balance
FROM customers
GROUP BY geography;


-- Complaints vs churn: they match 99.8%, so complained is recorded at exit. Not used as a predictor.
SELECT complained, exited, COUNT(*) AS customers
FROM customers
GROUP BY complained, exited
ORDER BY complained, exited;
