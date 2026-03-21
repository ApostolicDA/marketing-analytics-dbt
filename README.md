# Marketing Analytics dbt Project

## The Business Problem

A retail business running campaigns across 5 channels — Search, Organic, Facebook, Email, and Display — had no clear visibility into which channels were actually driving revenue, which customers were at churn risk, and where retention was breaking down.

This project builds a governed analytics pipeline that answers three specific business questions:

1. **Which channels deserve more budget** — and which are underperforming relative to their customer volume?
2. **Which customers are about to churn** — and how do we segment them for retention action?
3. **Where does retention break down** — and how quickly are cohorts dropping off after acquisition?

---

## Stack

| Layer | Tool |
|---|---|
| Cloud Warehouse | BigQuery |
| Transformation | dbt (staging + mart models) |
| Dashboarding | Looker Studio |
| Version Control | Git / GitHub |

---

## Live Dashboard

🔗 [Marketing Channel Performance](https://lookerstudio.google.com/reporting/33236cc2-2028-4e3e-beac-07836e01f2e0)

---

## Dashboard Screenshots

### Marketing Channel Performance
![Marketing Channel Performance](Marketing_Channel_Performance_Dash.png)

### Churn Risk & Cohort Retention
![Churn Risk & Cohort Retention](Churn_Risk_Cohort_Retention__2_.png)

---

## Key Findings

### Channel Performance
- **27.7K customers | 2.7M revenue | 31.4K orders** tracked across all 5 channels
- **Search is the dominant revenue channel** — driving the majority of both customers (~20K) and total revenue, dwarfing every other channel
- **Organic is the clear #2** in both customer volume and revenue — a significant signal that non-paid acquisition is working and worth investing in (content, SEO)
- **Facebook, Email, and Display are distant** — low customer volume and revenue relative to their likely spend, suggesting either poor targeting or attribution gaps worth investigating

### Churn Risk — The Hidden Problem in the Top Channel
- **Search customers show the highest avg days since last order (~1,200 days)** — meaning the channel bringing in the most customers is also producing the most disengaged ones. High acquisition volume masking a retention problem.
- The churn segmentation chart shows a **large churned customer base** relative to active customers — this is not a small edge case, it's a structural problem
- **At Risk customers are a small but actionable segment** — the window to intervene before they churn is narrow

### Cohort Retention
- **Retention drops sharply after month 0** — the first-month falloff is steep across all cohorts, confirming that early engagement is the highest-leverage point for retention
- **Retention rate is volatile over time (30–60% range Jan–Sep)** — no consistent upward trend, indicating retention strategy is reactive rather than systematic
- The **cohort table shows low single-digit retention** for most months beyond acquisition — typical for retail, but the size of the churned segment suggests this has compounded over time

---

## Pipeline Architecture

```
BigQuery (raw data)
    │
    ▼
Staging Layer (dbt)
    ├── stg_customers       — cleaned, typed customer records
    ├── stg_orders          — cleaned order transactions
    └── stg_order_items     — cleaned line-item order data
    │
    ▼
Mart Layer (dbt)
    ├── mart_channel_performance   — revenue, orders, customers by marketing channel
    ├── mart_churn_risk            — customer segmentation by churn risk tier
    └── mart_cohort_retention      — monthly cohort retention rates over time
    │
    ▼
Looker Studio (live dashboard)
```

---

## Models

### Staging
| Model | Purpose |
|---|---|
| `stg_customers` | Cleans and standardises raw customer data — handles nulls, casts data types, deduplicates |
| `stg_orders` | Cleans order records — normalises dates, validates order status, removes test transactions |
| `stg_order_items` | Cleans line-item data — resolves item-level revenue and links to parent orders |

### Marts
| Model | Business Question It Answers |
|---|---|
| `mart_channel_performance` | Which channels are driving revenue, customers, and orders — and which are underperforming? |
| `mart_churn_risk` | Which customers are churned, at risk, or active — based on recency of last order? |
| `mart_cohort_retention` | Of customers acquired in a given month, what % are still purchasing in subsequent months? |

---

## How to Run

### Prerequisites
- dbt Core installed (`pip install dbt-bigquery`)
- BigQuery project with appropriate permissions
- `profiles.yml` configured for your BigQuery connection

### Setup
```bash
# Clone the repo
git clone https://github.com/ApostolicDA/marketing-analytics-dbt
cd marketing-analytics-dbt

# Install dbt dependencies
dbt deps

# Test your connection
dbt debug

# Run all models
dbt run

# Run tests
dbt test

# Generate and serve docs
dbt docs generate
dbt docs serve
```

---

## Project Structure

```
marketing-analytics-dbt/
├── models/
│   ├── staging/
│   │   ├── stg_customers.sql
│   │   ├── stg_orders.sql
│   │   └── stg_order_items.sql
│   └── marts/
│       ├── mart_channel_performance.sql
│       ├── mart_churn_risk.sql
│       └── mart_cohort_retention.sql
├── dbt_project.yml
└── README.md
```

---

## Author

**Proud Ndlovu** — Data Analyst & Analytics Engineer
📩 fanisaproud@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/proud-ndlovu-89070854)
💻 [GitHub Portfolio](https://github.com/ApostolicDA)
