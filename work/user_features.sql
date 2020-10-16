WITH add_lag_feat_table AS (
SELECT
  *,
  timestamp - LAG (timestamp) OVER (ORDER BY user_id, timestamp, row_id) AS timediff
FROM Kaggle_Riiid.train
ORDER BY user_id, timestamp, row_id
)

-- Fold 0

SELECT
  user_id,
  0 AS cv_fold,
  -- answer features
  COUNT(answered_correctly) AS answered_correctly_count,
  SUM(answered_correctly) AS answered_correctly_sum,
  AVG(answered_correctly) AS answered_correctly_avg,
  STDDEV(answered_correctly)　AS answered_correctly_std,
  -- time features
  MAX(timestamp) as timestamp_max,
  -- timediff features
  MAX(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_max,
  MIN(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_min,
  AVG(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_avg,
  STDDEV(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_std,
  -- prior_question_elapsed_time features
  MAX(prior_question_elapsed_time) AS prior_question_elapsed_time_max,
  MIN(prior_question_elapsed_time) AS prior_question_elapsed_time_min,
  AVG(prior_question_elapsed_time) AS prior_question_elapsed_time_avg,
  STDDEV(prior_question_elapsed_time) AS prior_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN prior_question_had_explanation THEN 1 END) AS prior_question_had_explanation_sum,
  AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_avg,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_std
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 0
GROUP BY user_id

UNION ALL

SELECT
  user_id,
  0 AS cv_fold,
  -- answer features
  COUNT(answered_correctly) AS answered_correctly_count,
  SUM(answered_correctly) AS answered_correctly_sum,
  AVG(answered_correctly) AS answered_correctly_avg,
  STDDEV(answered_correctly)　AS answered_correctly_std,
  -- time features
  MAX(timestamp) as timestamp_max,
  -- timediff features
  MAX(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_max,
  MIN(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_min,
  AVG(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_avg,
  STDDEV(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_std,
  -- prior_question_elapsed_time features
  MAX(prior_question_elapsed_time) AS prior_question_elapsed_time_max,
  MIN(prior_question_elapsed_time) AS prior_question_elapsed_time_min,
  AVG(prior_question_elapsed_time) AS prior_question_elapsed_time_avg,
  STDDEV(prior_question_elapsed_time) AS prior_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN prior_question_had_explanation THEN 1 END) AS prior_question_had_explanation_sum,
  AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_avg,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_std
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 1
GROUP BY user_id

UNION ALL

SELECT
  user_id,
  0 AS cv_fold,
  -- answer features
  COUNT(answered_correctly) AS answered_correctly_count,
  SUM(answered_correctly) AS answered_correctly_sum,
  AVG(answered_correctly) AS answered_correctly_avg,
  STDDEV(answered_correctly)　AS answered_correctly_std,
  -- time features
  MAX(timestamp) as timestamp_max,
  -- timediff features
  MAX(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_max,
  MIN(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_min,
  AVG(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_avg,
  STDDEV(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_std,
  -- prior_question_elapsed_time features
  MAX(prior_question_elapsed_time) AS prior_question_elapsed_time_max,
  MIN(prior_question_elapsed_time) AS prior_question_elapsed_time_min,
  AVG(prior_question_elapsed_time) AS prior_question_elapsed_time_avg,
  STDDEV(prior_question_elapsed_time) AS prior_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN prior_question_had_explanation THEN 1 END) AS prior_question_had_explanation_sum,
  AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_avg,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_std
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 2
GROUP BY user_id

UNION ALL

SELECT
  user_id,
  0 AS cv_fold,
  -- answer features
  COUNT(answered_correctly) AS answered_correctly_count,
  SUM(answered_correctly) AS answered_correctly_sum,
  AVG(answered_correctly) AS answered_correctly_avg,
  STDDEV(answered_correctly)　AS answered_correctly_std,
  -- time features
  MAX(timestamp) as timestamp_max,
  -- timediff features
  MAX(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_max,
  MIN(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_min,
  AVG(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_avg,
  STDDEV(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_std,
  -- prior_question_elapsed_time features
  MAX(prior_question_elapsed_time) AS prior_question_elapsed_time_max,
  MIN(prior_question_elapsed_time) AS prior_question_elapsed_time_min,
  AVG(prior_question_elapsed_time) AS prior_question_elapsed_time_avg,
  STDDEV(prior_question_elapsed_time) AS prior_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN prior_question_had_explanation THEN 1 END) AS prior_question_had_explanation_sum,
  AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_avg,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_std
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 3
GROUP BY user_id

UNION ALL

SELECT
  user_id,
  0 AS cv_fold,
  -- answer features
  COUNT(answered_correctly) AS answered_correctly_count,
  SUM(answered_correctly) AS answered_correctly_sum,
  AVG(answered_correctly) AS answered_correctly_avg,
  STDDEV(answered_correctly)　AS answered_correctly_std,
  -- time features
  MAX(timestamp) as timestamp_max,
  -- timediff features
  MAX(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_max,
  MIN(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_min,
  AVG(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_avg,
  STDDEV(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS timediff_std,
  -- prior_question_elapsed_time features
  MAX(prior_question_elapsed_time) AS prior_question_elapsed_time_max,
  MIN(prior_question_elapsed_time) AS prior_question_elapsed_time_min,
  AVG(prior_question_elapsed_time) AS prior_question_elapsed_time_avg,
  STDDEV(prior_question_elapsed_time) AS prior_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN prior_question_had_explanation THEN 1 END) AS prior_question_had_explanation_sum,
  AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_avg,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS prior_question_had_explanation_std
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 4
GROUP BY user_id
