-- set fold number
DECLARE fold INT64 DEFAULT 4;

-- lag features
WITH add_lag_feat_table AS (
SELECT
  *,
  timestamp - LAG (timestamp) OVER (ORDER BY user_id, timestamp, row_id) AS timediff
FROM Kaggle_Riiid.train
ORDER BY user_id, timestamp, row_id
)

-- user features
SELECT
  user_id,
  fold AS cv_fold,
  -- contents features
  COUNT(content_id) AS n_content,
  COUNT(DISTINCT content_id) AS n_unique_content,
  -- answer features
  SUM(answered_correctly) AS user_answered_correctly_sum,
  AVG(answered_correctly) AS user_answered_correctly_avg,
  STDDEV(answered_correctly)　AS user_answered_correctly_std,
  -- time features
  MAX(timestamp) as user_timestamp_max,
  -- timediff features
  MAX(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS user_timediff_max,
  MIN(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS user_timediff_min,
  AVG(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS user_timediff_avg,
  STDDEV(CASE WHEN timediff > 0 THEN timediff ELSE 0 END) AS user_timediff_std,
  -- prior_question_elapsed_time features
  MAX(prior_question_elapsed_time) AS user_prior_question_elapsed_time_max,
  MIN(prior_question_elapsed_time) AS user_prior_question_elapsed_time_min,
  AVG(prior_question_elapsed_time) AS user_prior_question_elapsed_time_avg,
  STDDEV(prior_question_elapsed_time) AS user_prior_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN prior_question_had_explanation THEN 1 END) AS user_prior_question_had_explanation_sum,
  AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS user_prior_question_had_explanation_avg,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) AS user_prior_question_had_explanation_std
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_4 != -1
GROUP BY user_id
