SELECT
    id AS user_id,
    first_name,
    last_name,
    email,
    country,
    traffic_source,
    created_at AS signup_date,
    age
FROM `bigquery-public-data.thelook_ecommerce.users`