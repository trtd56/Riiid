CREATE TABLE Kaggle_Riiid.create_feat_window_v3 AS
SELECT
  * EXCEPT(timestamp),
  IFNULL(SAFE_DIVIDE(work_sum_all, timestamp), 0) AS work_per_time,
  IFNULL(SAFE_DIVIDE(correct_sum_all , timestamp), 0) AS correct_per_time,
  IFNULL(SAFE_DIVIDE(prior_question_had_explanation_count, timestamp ), 0)AS prior_question_per_time,
FROM (
SELECT

  -- Origin Features
  row_id,
  timestamp,
  
  -- All Count
  IFNULL(LAG (work_sum_all, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS work_sum_all,
  IFNULL(LAG (lecture_sum_all, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS lecture_sum_all,
  IFNULL(LAG (correct_sum_all, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS correct_sum_all,
  IFNULL(LAG (rate_sum_all, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS rate_sum_all,
  IFNULL(LAG (prior_question_had_explanation_count_v2, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS prior_question_had_explanation_count,
  
  -- Windw 正解率
  IFNULL(LAG (correct_sum_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS correct_sum_w201,
  IFNULL(LAG (correct_std_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS correct_std_w201,
  IFNULL(LAG (rate_sum_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS rate_sum_w201,
  
  -- timediff
  IFNULL(LAG (timediff_max_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS timediff_max_w201,
  IFNULL(LAG (timediff_avg_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS timediff_avg_w201,
  IFNULL(LAG (timediff_std_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS timediff_std_w201,
  
  -- prior_question_elapsed_time
  IFNULL(LAG (prior_question_elapsed_time_max_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS prior_question_elapsed_time_max_w201,  
  IFNULL(LAG (prior_question_elapsed_time_avg_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS prior_question_elapsed_time_avg_w201,
  IFNULL(LAG (prior_question_elapsed_time_std_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS prior_question_elapsed_time_std_w201,
  
  -- prior_question_had_explanation
  IFNULL(LAG (prior_question_had_explanation_avg_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS prior_question_had_explanation_avg_w201,
  IFNULL(LAG (prior_question_had_explanation_std_w201, 1) OVER (PARTITION BY user_id ORDER BY row_id), 0) AS prior_question_had_explanation_std_w201,
  
FROM (
SELECT
  *,
  IFNULL(SAFE_DIVIDE(correct_sum_all, work_sum_all), 0) AS rate_sum_all,
  CASE WHEN work_sum_all>200 THEN correct_sum_w201/201 ELSE IFNULL(SAFE_DIVIDE(correct_sum_w201, work_sum_all), 0) END AS rate_sum_w201,
  LAST_VALUE(prior_question_had_explanation_count_v1 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id) AS prior_question_had_explanation_count_v2,
FROM (
SELECT

  -- Origin Features
  row_id,
  user_id,
  content_type_id,
  timestamp,
  prior_question_had_explanation,
  
  -- All Count
  SUM(CASE WHEN content_type_id=0 THEN 1 ELSE 0 END) OVER (PARTITION BY user_id ORDER BY row_id) AS work_sum_all,
  SUM(CASE WHEN content_type_id=1 THEN 1 ELSE 0 END) OVER (PARTITION BY user_id ORDER BY row_id) AS lecture_sum_all,
  SUM(CASE WHEN answered_correctly=1 THEN 1 ELSE 0 END) OVER (PARTITION BY user_id ORDER BY row_id) AS correct_sum_all,
  CASE WHEN prior_question_had_explanation THEN ROW_NUMBER() OVER (PARTITION BY user_id, prior_question_had_explanation ORDER BY row_id) END AS prior_question_had_explanation_count_v1,
  
  -- Windw 正解率
  SUM(CASE WHEN answered_correctly=1 THEN 1 ELSE 0 END) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS correct_sum_w201,
  STDDEV(CASE WHEN answered_correctly=1 THEN 1 ELSE 0 END) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS correct_std_w201,
  
  -- timediff
  AVG( timediff ) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS timediff_avg_w201,
  STDDEV(timediff) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS timediff_std_w201,
  MAX(timediff) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS timediff_max_w201,
  
  -- prior_question_elapsed_time
  MAX(prior_question_elapsed_time) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS prior_question_elapsed_time_max_w201,
  AVG(prior_question_elapsed_time) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS prior_question_elapsed_time_avg_w201,
  STDDEV(prior_question_elapsed_time) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS prior_question_elapsed_time_std_w201,
  
  -- prior_question_had_explanation
  AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS prior_question_had_explanation_avg_w201,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) OVER (PARTITION BY user_id ORDER BY row_id RANGE BETWEEN 200 PRECEDING AND CURRENT ROW) AS prior_question_had_explanation_std_w201,
  
FROM Kaggle_Riiid.train
LEFT JOIN  Kaggle_Riiid.create_feat_timestamp_diff USING (row_id)
)))
