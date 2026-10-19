-- Bank churn: load the CSV (CRLF line endings). Run from the project root with --local-infile=1.

USE bank_churn;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'data/Customer-Churn-Records.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(@row_number, customer_id, @surname, credit_score, geography, gender, age, tenure,
 balance, num_products, has_credit_card, is_active_member, estimated_salary,
 exited, complained, satisfaction_score, card_type, points_earned);

SELECT COUNT(*) AS rows_loaded FROM customers;
