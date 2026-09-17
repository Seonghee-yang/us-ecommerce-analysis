-- customer_stats 생성
CREATE TABLE customer_stats AS
SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    COUNT(DISTINCT order_id) AS cnt_orders,
    ROUND(SUM(sales), 2) AS sum_sales
FROM records
GROUP BY customer_id;

## 핵심 KPI 검증
SELECT COUNT(*) AS customer_cnt -- 고객 수
     , ROUND(SUM(sum_sales), 2) AS total_sales -- 총 매출
     , SUM(cnt_orders) AS total_orders -- 총 주문 수
FROM customer_stats;