# Bank Customer Churn (MySQL)

Why do bank customers leave? 10,000 customers from France, Germany and Spain, 20.4% of whom closed
their accounts. Data: [Kaggle - Bank Customer Churn](https://www.kaggle.com/datasets/radheshyamkollipara/bank-customer-churn).

## What I found

| Group | Churn rate |
|---|---|
| All customers | 20.4% |
| Aged 50-59 | 56.0% |
| Germany | 32.4% (vs about 16% in France and Spain) |
| Women | 25.1% (vs 16.5% for men) |
| 1 product | 27.7% |
| 2 products | 7.6% |
| 3-4 products | 83-100% (only 326 customers) |
| Inactive members | 26.9% (vs 14.3% active) |

Credit score, salary, tenure, card type and satisfaction score barely matter - churn stays around
17-23% across all of them.

Balance looks like it matters, but Germany has no zero-balance customers, so I split by country.
Within France and Spain, customers with a balance still churn more (18-20% vs about 14%).

**Risk score:** one point each for age 40-59, inactive, Germany, and not holding exactly 2
products. Customers scoring 3 or 4 are 20% of the base but 52% of everyone who left. Score 0
churns at 2.8%.

## A data problem

The `Complain` column matches churn almost perfectly (99.8% of leavers complained, 99.5% of
complainers left). It was almost certainly filled in when the customer left, so I didn't use it to
predict churn - it would look great in a model and be useless on new customers.

## Files

- `sql/01-02` create the table and load the CSV
- `sql/03` data checks
- `sql/04` churn by country, gender and age
- `sql/05` products, activity, balance and the factors that don't matter
- `sql/06` risk score and a summary view for Tableau
- `results/` saved output of each script

To run: put `Customer-Churn-Records.csv` in `data/`, then run the scripts in order with
`mysql -u root -p --table < sql/0X_name.sql` (`02` also needs `--local-infile=1`).
