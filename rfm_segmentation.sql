WITH rfm AS(
SELECT
  CustomerID,
  DATE_DIFF(CURRENT_DATE(), MAX(CAST(InvoiceDate AS DATE)), DAY) AS recency,
  COUNT(DISTINCT InvoiceNo) AS frequency,
  SUM(Total_Price) AS monetary
FROM `robotic-energy-468108-d9.online_store_transaction654.online_store_clean`
WHERE Invoicestatus = 'Complete'
GROUP BY CustomerID
),
rfm_scores AS (
  SELECT
    CustomerID,
    recency,
    frequency,
    monetary,
    NTILE(4) OVER (ORDER BY recency DESC) AS r_score,
    NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
    NTILE(4) OVER (ORDER BY monetary ASC) AS m_score
  FROM
    rfm
)
SELECT
  CustomerID,
  recency,
  frequency,
  monetary,
  r_score,
  f_score,
  m_score,
  CONCAT(r_score, f_score, m_score) AS rfm_score,
  CASE
    WHEN r_score = 4 AND f_score = 4 AND m_score = 4 THEN 'Champions'
    WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customer'
    WHEN r_score >= 3 AND m_score >= 3 THEN 'Big Spenders'
    WHEN r_score = 4 AND f_score = 1 AND m_score = 1 THEN 'New Customers'
    WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At-Risk'
    WHEN r_score <= 2 THEN 'Hibernating'
    ELSE 'Other'
  END AS rfm_segment
FROM
  rfm_scores
    
