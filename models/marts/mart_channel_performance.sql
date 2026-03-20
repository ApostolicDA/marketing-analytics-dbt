WITH orders AS (
    SELECT * FROM {{ ref('stg_orders') }}
    WHERE status = 'Complete'
),

order_items AS (
    SELECT * FROM {{ ref('stg_order_items') }}
),

customers AS (
    SELECT * FROM {{ ref('stg_customers') }}
),

revenue_by_channel AS (
    SELECT
        c.traffic_source AS channel,
        COUNT(DISTINCT o.order_id) AS total_orders,
        COUNT(DISTINCT o.user_id) AS total_customers,
        ROUND(SUM(oi.sale_price), 2) AS total_revenue,
        ROUND(SUM(oi.sale_price) / COUNT(DISTINCT o.user_id), 2) AS revenue_per_customer,
        ROUND(SUM(oi.sale_price) / COUNT(DISTINCT o.order_id), 2) AS avg_order_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN customers c ON o.user_id = c.user_id
    GROUP BY c.traffic_source
)

SELECT * FROM revenue_by_channel
ORDER BY total_revenue DESC