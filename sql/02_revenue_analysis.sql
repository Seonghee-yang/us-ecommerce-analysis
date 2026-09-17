-- 월별 주문 수 / PU / 매출 / AOV / ARPPU 
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(DISTINCT order_id) AS order_cnt,
    COUNT(DISTINCT customer_id) AS PU,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS AOV,
    ROUND(SUM(sales) / COUNT(DISTINCT customer_id), 2) AS ARPPU
FROM records
GROUP BY month
ORDER BY month;

-- 카테고리별 매출 및 이익 구조
SELECT
    category,
    COUNT(DISTINCT order_id) AS order_cnt,
    COUNT(DISTINCT customer_id) AS customer_cnt,
    SUM(quantity) AS total_qty,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(sales), 0) * 100, 2) AS profit_margin,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS sales_per_order,
    ROUND(SUM(sales) / COUNT(DISTINCT customer_id), 2) AS sales_per_customer,
    COUNT(DISTINCT product_id) AS product_cnt
FROM records
GROUP BY category
ORDER BY revenue DESC;


-- 월별 카테고리 성과
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    category,
    COUNT(DISTINCT customer_id) AS PU,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(
        SUM(sales) / COUNT(DISTINCT customer_id),
        2
    ) AS ARPPU
FROM records
GROUP BY
    DATE_FORMAT(order_date, '%Y-%m'),
    category
ORDER BY month, category;

-- 고객 유형별 매출 구조
SELECT
    segment,
    COUNT(DISTINCT customer_id) AS customer_cnt,
    COUNT(DISTINCT order_id) AS order_cnt,
    ROUND(SUM(sales), 2) AS revenue,
    ROUND(
        COUNT(DISTINCT order_id)
        / COUNT(DISTINCT customer_id),
        2
    ) AS orders_per_customer,
    ROUND(
        SUM(sales)
        / COUNT(DISTINCT customer_id),
        2
    ) AS sales_per_customer,
    ROUND(
        SUM(sales)
        / COUNT(DISTINCT order_id),
        2
    ) AS AOV,
    ROUND(
        SUM(sales) * 100
        / (SELECT SUM(sales) FROM records),
        2
    ) AS revenue_rate,
    ROUND(
        COUNT(DISTINCT order_id) * 100
        / (SELECT COUNT(DISTINCT order_id) FROM records),
        3
    ) AS order_rate,
    ROUND(
        COUNT(DISTINCT customer_id) * 100
        / (SELECT COUNT(DISTINCT customer_id) FROM records),
        2
    ) AS customer_rate,
    ROUND(SUM(profit), 2) AS profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM records
GROUP BY segment
ORDER BY revenue DESC;

-- 재구매 고객 비율
SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN cnt_orders >= 2 THEN 1
            ELSE 0
        END
    ) AS repeat_customers,
    ROUND(
        SUM(
            CASE
                WHEN cnt_orders >= 2 THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS repeat_rate_pct
FROM customer_stats;