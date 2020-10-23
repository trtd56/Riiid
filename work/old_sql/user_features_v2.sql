-- set fold number
DECLARE fold INT64 DEFAULT 0;

-- lag features
WITH add_lag_feat_table AS (
SELECT
  *,
  timestamp - prior_question_elapsed_time AS timediff_start,
  timestamp - LAG (timestamp, 2) OVER (ORDER BY user_id, timestamp, row_id) AS timediff_2,
  timestamp - LAG (timestamp, 4) OVER (ORDER BY user_id, timestamp, row_id) AS timediff_4,
  timestamp - LAG (timestamp, 8) OVER (ORDER BY user_id, timestamp, row_id) AS timediff_8,
  timestamp - LAG (timestamp, 16) OVER (ORDER BY user_id, timestamp, row_id) AS timediff_16,
  #AVG(answered_correctly) OVER (ORDER BY row_id RANGE BETWEEN 4 PRECEDING AND CURRENT ROW) AS answered_correctly_w4,
  #AVG(answered_correctly) OVER (ORDER BY row_id RANGE BETWEEN 8 PRECEDING AND CURRENT ROW) AS answered_correctly_w8,
  #AVG(answered_correctly) OVER (ORDER BY row_id RANGE BETWEEN 16 PRECEDING AND CURRENT ROW) AS answered_correctly_w16,
  #AVG(answered_correctly) OVER (ORDER BY row_id RANGE BETWEEN 32 PRECEDING AND CURRENT ROW) AS answered_correctly_w32,
FROM Kaggle_Riiid.train
ORDER BY user_id, timestamp, row_id
)

-- user features
SELECT
  user_id,
  fold AS cv_fold,
  -- time features
  MAX(timediff_start) AS timediff_start_max,
  MIN(timediff_start) AS timediff_start_min,
  AVG(timediff_start) AS timediff_start_avg,
  STDDEV(timediff_start) AS timediff_start_std,
  -- timediff_2 features
  MAX(CASE WHEN timediff_2 > 0 THEN timediff_2 ELSE 0 END) AS user_timediff_2_max,
  MIN(CASE WHEN timediff_2 > 0 THEN timediff_2 ELSE 0 END) AS user_timediff_2_min,
  AVG(CASE WHEN timediff_2 > 0 THEN timediff_2 ELSE 0 END) AS user_timediff_2_avg,
  STDDEV(CASE WHEN timediff_2 > 0 THEN timediff_2 ELSE 0 END) AS user_timediff_2_std,
  -- timediff_4 features
  MAX(CASE WHEN timediff_4 > 0 THEN timediff_4 ELSE 0 END) AS user_timediff_4_max,
  MIN(CASE WHEN timediff_4 > 0 THEN timediff_4 ELSE 0 END) AS user_timediff_4_min,
  AVG(CASE WHEN timediff_4 > 0 THEN timediff_4 ELSE 0 END) AS user_timediff_4_avg,
  STDDEV(CASE WHEN timediff_4 > 0 THEN timediff_4 ELSE 0 END) AS user_timediff_4_std,
  -- timediff_8 features
  MAX(CASE WHEN timediff_8 > 0 THEN timediff_8 ELSE 0 END) AS user_timediff_8_max,
  MIN(CASE WHEN timediff_8 > 0 THEN timediff_8 ELSE 0 END) AS user_timediff_8_min,
  AVG(CASE WHEN timediff_8 > 0 THEN timediff_8 ELSE 0 END) AS user_timediff_8_avg,
  STDDEV(CASE WHEN timediff_8 > 0 THEN timediff_8 ELSE 0 END) AS user_timediff_8_std,
  -- timediff_16 features
  MAX(CASE WHEN timediff_16 > 0 THEN timediff_16 ELSE 0 END) AS user_timediff_16_max,
  MIN(CASE WHEN timediff_16 > 0 THEN timediff_16 ELSE 0 END) AS user_timediff_16_min,
  AVG(CASE WHEN timediff_16 > 0 THEN timediff_16 ELSE 0 END) AS user_timediff_16_avg,
  STDDEV(CASE WHEN timediff_16 > 0 THEN timediff_16 ELSE 0 END) AS user_timediff_16_std,
  -- answered_correctly_w4 features
  #MAX(answered_correctly_w4) AS user_answered_correctly_w4_max,
  #MIN(answered_correctly_w4) AS user_answered_correctly_w4_min,
  #AVG(answered_correctly_w4) AS user_answered_correctly_w4_avg,
  #STDDEV(answered_correctly_w4) AS user_answered_correctly_w4_std,
  -- answered_correctly_w8 features
  #MAX(answered_correctly_w8) AS user_answered_correctly_w8_max,
  #MIN(answered_correctly_w8) AS user_answered_correctly_w8_min,
  #AVG(answered_correctly_w8) AS user_answered_correctly_w8_avg,
  #STDDEV(answered_correctly_w8) AS user_answered_correctly_w8_std,
  -- answered_correctly_w16 features
  #MAX(answered_correctly_w16) AS user_answered_correctly_w16_max,
  #MIN(answered_correctly_w16) AS user_answered_correctly_w16_min,
  #AVG(answered_correctly_w16) AS user_answered_correctly_w16_avg,
  #STDDEV(answered_correctly_w16) AS user_answered_correctly_w16_std,
  -- answered_correctly_w32 features
  #MAX(answered_correctly_w32) AS user_answered_correctly_w32_max,
  #MIN(answered_correctly_w32) AS user_answered_correctly_w32_min,
  #AVG(answered_correctly_w32) AS user_answered_correctly_w32_avg,
  #STDDEV(answered_correctly_w32) AS user_answered_correctly_w32_std,
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1
GROUP BY user_id
