DECLARE fold INT64 DEFAULT 0;

-- This query make aggregation features by part

-- lag features
WITH add_lag_feat_table AS (
SELECT
  *,
  LEAD (prior_question_elapsed_time) OVER (ORDER BY user_id, timestamp, row_id) AS question_elapsed_time,
  LEAD (prior_question_had_explanation) OVER (ORDER BY user_id, timestamp, row_id) AS question_had_explanation
FROM Kaggle_Riiid.train
ORDER BY user_id, timestamp, row_id
)

SELECT
  -- ### key columns ###
  part as part,
  fold AS fold,
  
  -- ### target encoding features ###
  -- answer features
  COUNT(answered_correctly) AS part_answered_correctly_count,
  SUM(answered_correctly) AS part_answered_correctly_sum,
  AVG(answered_correctly) AS part_answered_correctly_avg,
  STDDEV(answered_correctly)　AS part_answered_correctly_std,
  
  -- ### other aggregated contenst features ###
  -- question features
  COUNT(content_id) AS part_n_content_id,
  -- user features
  COUNT(DISTINCT user_id) AS part_n_unique_user,
  -- task_container_id features
  MAX(task_container_id) AS part_task_container_id_max,
  MIN(task_container_id) AS part_task_container_id_min,
  AVG(task_container_id) AS part_task_container_id_avg,
  STDDEV(task_container_id) AS part_task_container_id_std,
  -- prior_question_elapsed_time features
  MAX(question_elapsed_time) AS part_question_elapsed_time_max,
  MIN(question_elapsed_time) AS part_question_elapsed_time_min,
  AVG(question_elapsed_time) AS part_question_elapsed_time_avg,
  STDDEV(question_elapsed_time) AS part_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN question_had_explanation THEN 0 ELSE 1 END) AS part_question_had_explanation_inv_sum,
  AVG(CASE WHEN question_had_explanation THEN 0 ELSE 1 END) AS part_question_had_explanation_inv_avg,
  STDDEV(CASE WHEN question_had_explanation THEN 0 ELSE 1 END) AS part_question_had_explanation_inv_std,
  
FROM Kaggle_Riiid.cv_fold_info_20201027
INNER JOIN  add_lag_feat_table USING (row_id)
INNER JOIN Kaggle_Riiid.questions ON question_id = content_id
WHERE valid_fold != fold
GROUP BY part
