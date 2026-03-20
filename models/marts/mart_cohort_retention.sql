WITH first_order AS (
    SELECT
        user_id,
        DATE_TRUNC(DATE(MIN(created_at)), MONTH) AS cohort_month
    FROM {{ ref('stg_orders') }}
    WHERE status = 'Complete'
    GROUP BY user_id
),

orders AS (
    SELECT
        user_id,
        DATE_TRUNC(DATE(created_at), MONTH) AS order_month
    FROM {{ ref('stg_orders') }}
    WHERE status = 'Complete'
),

cohort_data AS (
    SELECT
        f.cohort_month,
        DATE_DIFF(o.order_month, f.cohort_month, MONTH) AS month_number,
        COUNT(DISTINCT o.user_id) AS active_customers
    FROM first_order f
    JOIN orders o ON f.user_id = o.user_id
    GROUP BY f.cohort_month, month_number
),

cohort_size AS (
    SELECT
        cohort_month,
        active_customers AS cohort_total
    FROM cohort_data
    WHERE month_number = 0
)

SELECT
    c.cohort_month,
    c.month_number,
    c.active_customers,
    cs.cohort_total,
    ROUND(c.active_customers / cs.cohort_total * 100, 1) AS retention_rate
FROM cohort_data c
JOIN cohort_size cs ON c.cohort_month = cs.cohort_month
WHERE c.month_number <= 6
ORDER BY c.cohort_month, c.month_number