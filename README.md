# Marketing Analytics dbt Project

## Overview
A production-style dbt project built on BigQuery, modelling marketing and customer data for a retail business.

## Stack
- **dbt** — data transformation and modelling
- **BigQuery** — cloud data warehouse
- **Looker Studio** — dashboarding and visualization
- **Git/GitHub** — version control

## Models
### Staging
- `stg_customers` — cleaned customer data
- `stg_orders` — cleaned orders data
- `stg_order_items` — cleaned order items

### Marts
- `mart_channel_performance` — revenue, orders and customers by marketing channel
- `mart_churn_risk` — customer segmentation by churn risk
- `mart_cohort_retention` — cohort retention analysis over time

## Dashboard
Built in Looker Studio connected live to BigQuery.