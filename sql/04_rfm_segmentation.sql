-- RFM_df
WITH ref AS (
    SELECT
        DATE_ADD(
            MAX(order_date),
            INTERVAL 1 DAY
        ) AS ref_date
    FROM records
)
SELECT
    customer_id,
    DATEDIFF(
        (SELECT ref_date FROM ref),
        MAX(order_date)
    ) AS recency,
    COUNT(DISTINCT order_id) AS frequency,
    ROUND(SUM(sales), 2) AS monetary
FROM records
GROUP BY customer_id;

-- RFM 1~5 점수화
WITH ref AS (
	SELECT DATE_ADD(MAX(order_date), INTERVAL 1 DAY) AS ref_date
    FROm records
), 
base_rfm AS (
    SELECT 
        customer_id,
        DATEDIFF((SELECT ref_date FROM ref), MAX(order_date)) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        ROUND(SUM(sales), 2) AS monetary
    FROM records
    GROUP BY customer_id
),
rfm_score AS (
    SELECT *,
        CASE 
            WHEN recency <= 29 THEN 5
            WHEN recency <= 59 THEN 4
            WHEN recency <= 89 THEN 3 
            WHEN recency <= 115 THEN 2
            ELSE 1 
        END AS r_score,
        
        CASE 
            WHEN frequency >= 5 THEN 5
            WHEN frequency = 4 THEN 4
            WHEN frequency = 3 THEN 3
            WHEN frequency = 2 THEN 2
            ELSE 1
        END AS f_score,
        
        CASE 
            WHEN monetary > 1315 THEN 5
            WHEN monetary > 1052 THEN 4
            WHEN monetary > 599  THEN 3
            WHEN monetary > 203  THEN 2
            ELSE 1 
        END AS m_score
    FROM base_rfm
)
SELECT 
    *,
    (r_score + f_score + m_score) AS total_score
FROM rfm_score
ORDER BY total_score DESC, monetary DESC;

-- rfm_segment_new
WITH rfm_raw_data AS (
    -- 고객별 R, F, M 기초 지표 산출
    SELECT 
        customer_id,
        DATEDIFF('2021-01-01', MAX(order_date)) AS recency_days,
        COUNT(DISTINCT order_id) AS frequency_cnt,
        SUM(sales) AS monetary_amt
    FROM records
    GROUP BY customer_id
),

rfm_scoring AS (
    -- NTILE(5)로 1~5점 점수 부여
    SELECT 
        customer_id,
        recency_days,
        frequency_cnt,
        monetary_amt,
        NTILE(5) OVER (ORDER BY recency_days DESC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency_cnt ASC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary_amt ASC) AS m_score
    FROM rfm_raw_data
)

SELECT 
    customer_id,
    recency_days,
    frequency_cnt,
    monetary_amt,
    r_score,
    f_score,
    m_score,
    CASE 
        -- 1) VIP: 모든 지표 최상위 (최근성 4~5, 빈도 4~5, 금액 4~5)
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'VIP'
        
        -- 2) Lost VIP: 과거 우량 고객이었으나 현재 이탈 (최근성 1~2, 빈도 4~5, 금액 4~5)
        WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN 'Lost VIP'
        
        -- 3) Potential Loyal: 빈도와 금액이 양호한 성장 잠재 고객 (최근성 3~5, 빈도 3~5, 금액 3~5)
        WHEN r_score >= 3 AND f_score >= 3 AND m_score >= 3 THEN 'Potential Loyal'
        
        -- 4) Need Attention: 금액은 크지만 최근 방문이 뜸하거나 빈도가 낮은 고객 (최근성 2~3, 금액 4~5)
        WHEN r_score BETWEEN 2 AND 3 AND m_score >= 4 THEN 'Need Attention'
        
        -- 5) New Customers: 최근 유입되어 활동을 시작한 신규 고객 (최근성 4~5, 빈도 1~2)
        WHEN r_score >= 4 AND f_score <= 2 THEN 'New Customers'
        
        -- 6) About to Sleep: 최근성이 떨어지기 시작하는 이탈 경고 고객 (최근성 3, 빈도 및 금액 하위)
        WHEN r_score = 3 AND f_score <= 2 THEN 'About to sleep'
        
        -- 7) Lost Customers: 완전히 이탈한 일반 고객 (최근성 1~2, 빈도 및 금액 보통 이하)
        WHEN r_score <= 2 AND (f_score BETWEEN 2 AND 3 OR m_score BETWEEN 2 AND 3) THEN 'Lost customers'
        
        -- 8) Hibernating: 오랫동안 방문이 없고 모든 지표가 최하위인 고객 (나머지 조건 전원 흡수)
        ELSE 'Hibernating'
    END AS segment
FROM rfm_scoring;

-- 최종 RFM segment 별 고객수, 주문수, 매출, ARPPU, AOV, 매출 기여도 비교
SELECT
    s.segment AS rfm_segment,
    COUNT(DISTINCT s.customer_id) AS customer_cnt,
    COUNT(DISTINCT r.order_id) AS order_cnt,
    ROUND(SUM(r.sales), 2) AS revenue,
    ROUND(SUM(r.sales)/ COUNT(DISTINCT s.customer_id), 2) AS arppu,
    ROUND(SUM(r.sales) / COUNT(DISTINCT r.order_id), 2) AS aov,
    ROUND(SUM(r.sales) * 100 / (SELECT SUM(sales) FROM records), 2) AS revenue_rate
FROM rfm_segment_new3 s
JOIN records r
    ON s.customer_id = r.customer_id
GROUP BY s.segment
ORDER BY revenue DESC;

-- Potential Loyal vs VIP Category Analysis
WITH target_transactions AS (
    SELECT
        r.customer_id,
        r.category,
        s.segment AS rfm_segment
    FROM records r
    INNER JOIN rfm_segment_new3 s
        ON r.customer_id = s.customer_id
    WHERE s.segment IN (
        'Potential Loyal',
        'VIP'
    )
)
SELECT
    rfm_segment,
    category,
    ROUND(
        COUNT(*) * 100
        / SUM(COUNT(*)) OVER (
            PARTITION BY rfm_segment
        ),
        1
    ) AS purchase_share_pct
FROM target_transactions
GROUP BY
    rfm_segment,
    category
ORDER BY
    rfm_segment,
    purchase_share_pct DESC;