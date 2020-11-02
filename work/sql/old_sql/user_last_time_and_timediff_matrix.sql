WITH t AS (
SELECT 
  row_id,
  user_id,
  timestamp,
  timestamp - LAG(timestamp) OVER(ORDER BY row_id) AS timediff
FROM Kaggle_Riiid.train
)

SELECT
  user_id,
  timestamp AS last_timestamp,
  timediff
FROM t
WHERE row_id IN (
  SELECT
    MAX(row_id),
  FROM t
  GROUP BY user_id
)
