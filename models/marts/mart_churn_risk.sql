WITH last_order AS (
    SELECT
        user_id,
        MAX(created_at) AS last_order_date,
        COUNT(order_id) AS total_orders
    FROM {{ ref('stg_orders') }}
    WHERE status = 'Complete'
    GROUP BY user_id
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

rfm AS (
    SELECT
        c.user_id,
        c.traffic_source,
        c.country,
        l.total_orders,
        l.last_order_date,
        DATE_DIFF(CURRENT_DATE(), DATE(l.last_order_date), DAY) AS days_since_order,
        CASE
            WHEN DATE_DIFF(CURRENT_DATE(), DATE(l.last_order_date), DAY) <= 30 THEN 'Active'
            WHEN DATE_DIFF(CURRENT_DATE(), DATE(l.last_order_date), DAY) <= 90 THEN 'At Risk'
            WHEN DATE_DIFF(CURRENT_DATE(), DATE(l.last_order_date), DAY) <= 180 THEN 'Churning'
            ELSE 'Churned'
        END AS churn_segment
    FROM customers c
    JOIN last_order l ON c.user_id = l.user_id
)

SELECT
    churn_segment,
    traffic_source,
    COUNT(user_id) AS total_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders,
    ROUND(AVG(days_since_order), 0) AS avg_days_since_order
FROM rfm
GROUP BY churn_segment, traffic_source
ORDER BY churn_segment, total_customers DESC