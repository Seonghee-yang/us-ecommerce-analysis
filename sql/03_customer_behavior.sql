-- 카테고리별 재구매주기
WITH category_order_dates AS (
    SELECT DISTINCT
        category,
        customer_id,
        order_date
    FROM records
),
lagged AS (
    SELECT
        category,
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY category, customer_id
            ORDER BY order_date
        ) AS prev_order_date
    FROM category_order_dates
)
SELECT
    category,
    ROUND(AVG(DATEDIFF(order_date, prev_order_date)), 2) AS avg_cycle_days
FROM lagged
WHERE prev_order_date IS NOT NULL
GROUP BY category
ORDER BY avg_cycle_days;

-- 고객별 구매 주기
WITH customer_order_dates AS (
    SELECT DISTINCT
        customer_id,
        order_date
    FROM records
),
lagged AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS prev_order_date
    FROM customer_order_dates
)
SELECT
    customer_id,
    order_date,
    prev_order_date,
    DATEDIFF(order_date, prev_order_date) AS days_between_orders,
    ROUNG(AVG(DATEDIFF(order_date, prev_order_date)), 2) AS avg_cycle_days
FROM lagged
WHERE prev_order_date IS NOT NULL
ORDER BY customer_id, order_date;

-- 코호트 생성
WITH first_order AS (
    SELECT
        customer_id,
        DATE_FORMAT(MIN(order_date), '%Y-%m') AS cohort_month
    FROM records
    GROUP BY customer_id
),
activity AS (
    SELECT DISTINCT
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS order_month
    FROM records
)
SELECT
    f.cohort_month,
    a.order_month,
    PERIOD_DIFF(
        DATE_FORMAT(
            STR_TO_DATE(CONCAT(a.order_month, '-01'), '%Y-%m-%d'),
            '%Y%m'
        ),
        DATE_FORMAT(
            STR_TO_DATE(CONCAT(f.cohort_month, '-01'), '%Y-%m-%d'),
            '%Y%m'
        )
    ) AS month_index,
    COUNT(DISTINCT a.customer_id) AS active_customer_cnt
FROM first_order f
JOIN activity a
    ON a.customer_id = f.customer_id
GROUP BY
    f.cohort_month,
    a.order_month,
    month_index
ORDER BY
    f.cohort_month,
    month_index;