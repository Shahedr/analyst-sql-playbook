# Analyst SQL Playbook

A hands-on PostgreSQL practice repo built around realistic analyst questions instead of isolated syntax drills.

The dataset models a small online retailer with customers, orders, products, and order items. The exercises move from core KPI work into window functions, customer segmentation, and retention analysis.

## What is inside

| Section | Focus |
|---|---|
| Core analytics | joins, aggregations, CASE, business KPIs |
| Window functions | ranking, NTILE, LAG, rolling metrics |
| Customer analysis | repeat purchasing, second purchase, cohorts |

Each challenge file contains the business question without the answer. Matching solution files are kept separately so the repo can be used for practice.

## Quick start with Docker

~~~bash
docker compose up -d
docker compose exec postgres psql -U analyst -d sql_playbook
~~~

Inside psql:

~~~sql
\i /workspace/sql/00_schema.sql
\i /workspace/sql/01_seed.sql
~~~

Or run the setup in one command:

~~~bash
docker compose exec postgres psql -U analyst -d sql_playbook -f /workspace/sql/00_schema.sql
docker compose exec postgres psql -U analyst -d sql_playbook -f /workspace/sql/01_seed.sql
~~~

The seed script generates a deterministic practice dataset, so everyone gets the same results.

## Practice order

1. challenges/01_core_analytics.sql
2. challenges/02_window_functions.sql
3. challenges/03_customer_retention.sql

Try each question first, then compare your approach with the matching file under solutions/.

## Dataset

The seed creates:

- 120 customers
- 12 products across four categories
- 900 orders during 2025
- 1–3 line items per order
- completed, returned, and cancelled orders
- web, mobile, and store channels
- deterministic discounts and quantities

No company or customer data is used.

## Repository structure

~~~text
analyst-sql-playbook/
├── challenges/
├── solutions/
├── sql/
│   ├── 00_schema.sql
│   └── 01_seed.sql
├── tests/
├── .github/workflows/sql-tests.yml
├── docker-compose.yml
├── CONTRIBUTING.md
└── README.md
~~~

## A note on solutions

SQL rarely has only one correct answer. The solution files show one readable approach and call out the business assumption behind the query. If your query produces the same result with a different approach, that can still be a good solution.

## Roadmap

- add inventory and fulfillment questions
- add data-cleaning SQL exercises
- add query-performance examples with EXPLAIN
- add a second case study focused on operations
- accept community challenge submissions

## License

MIT
