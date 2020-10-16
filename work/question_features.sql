-- set fold number
DECLARE fold INT64 DEFAULT 0;

WITH add_lag_feat_table AS (
SELECT
  *,
  LEAD (prior_question_elapsed_time) OVER (ORDER BY user_id, timestamp, row_id) AS question_elapsed_time,
  LEAD (prior_question_had_explanation) OVER (ORDER BY user_id, timestamp, row_id) AS question_had_explanation
FROM Kaggle_Riiid.train
ORDER BY user_id, timestamp, row_id
)

SELECT
  content_id,
  fold AS cv_fold,
  -- user features
  COUNT(user_id) AS n_user,
  COUNT(DISTINCT user_id) AS n_unique_user,
  -- answer features
  COUNT(answered_correctly) AS answered_correctly_count,
  SUM(answered_correctly) AS answered_correctly_sum,
  AVG(answered_correctly) AS answered_correctly_avg,
  STDDEV(answered_correctly)　AS answered_correctly_std,
  -- prior_question_elapsed_time features
  MAX(question_elapsed_time) AS question_elapsed_time_max,
  MIN(question_elapsed_time) AS question_elapsed_time_min,
  AVG(question_elapsed_time) AS question_elapsed_time_avg,
  STDDEV(question_elapsed_time) AS question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN question_had_explanation THEN 1 END) AS question_had_explanation_sum,
  AVG(CASE WHEN question_had_explanation THEN 1 ELSE 0 END) AS question_had_explanation_avg,
  STDDEV(CASE WHEN question_had_explanation THEN 1 ELSE 0 END) AS question_had_explanation_std
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 0
GROUP BY content_id
