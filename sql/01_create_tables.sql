-- Bank churn: create database and table. Surname is not loaded (personal data, not needed).

DROP DATABASE IF EXISTS bank_churn;
CREATE DATABASE bank_churn;
USE bank_churn;

CREATE TABLE customers (
    customer_id        INT            NOT NULL,
    credit_score       SMALLINT       NOT NULL,
    geography          VARCHAR(20)    NOT NULL,
    gender             VARCHAR(10)    NOT NULL,
    age                TINYINT        NOT NULL,
    tenure             TINYINT        NOT NULL,   -- years as a customer, 0-10
    balance            DECIMAL(12,2)  NOT NULL,
    num_products       TINYINT        NOT NULL,
    has_credit_card    TINYINT(1)     NOT NULL,
    is_active_member   TINYINT(1)     NOT NULL,
    estimated_salary   DECIMAL(12,2)  NOT NULL,
    exited             TINYINT(1)     NOT NULL,
    complained         TINYINT(1)     NOT NULL,
    satisfaction_score TINYINT        NOT NULL,   -- 1 (low) to 5 (high)
    card_type          VARCHAR(10)    NOT NULL,
    points_earned      SMALLINT       NOT NULL,
    PRIMARY KEY (customer_id),
    INDEX idx_geography (geography),
    INDEX idx_exited (exited)
);
