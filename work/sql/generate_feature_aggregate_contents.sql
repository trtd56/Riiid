DECLARE fold INT64 DEFAULT 0;

-- This query make aggregation features by contents

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
  content_id as question_id,
  fold AS fold,

  -- ### target encoding features ###
  -- aggregation by contents
  COUNT(answered_correctly) AS content_answered_correctly_count,
  SUM(answered_correctly) AS content_answered_correctly_sum,
  AVG(answered_correctly) AS content_answered_correctly_avg,
  STDDEV(answered_correctly)　AS content_answered_correctly_std,
  
  -- ### other aggregated contenst features ###
  -- time features
  MAX(timestamp) as content_timestamp_max,
  MIN(timestamp) as content_timestamp_min,
  AVG(timestamp) as content_timestamp_avg,
  STDDEV(timestamp) as content_timestamp_std,
  -- user features
  COUNT(user_id) AS content_n_user,
  COUNT(DISTINCT user_id) AS content_n_unique_user,
  -- task_container_id features
  MAX(task_container_id) AS content_task_container_id_max,
  MIN(task_container_id) AS content_task_container_id_min,
  AVG(task_container_id) AS content_task_container_id_avg,
  STDDEV(task_container_id) AS content_task_container_id_std,
  -- user_answer
  SUM(CASE WHEN user_answer = 0 THEN 1 ELSE 0 END) AS content_user_answer_0_sum,
  SUM(CASE WHEN user_answer = 1 THEN 1 ELSE 0 END) AS content_user_answer_1_sum,
  SUM(CASE WHEN user_answer = 2 THEN 1 ELSE 0 END) AS content_user_answer_2_sum,
  SUM(CASE WHEN user_answer = 3 THEN 1 ELSE 0 END) AS content_user_answer_3_sum,
  AVG(CASE WHEN user_answer = 0 THEN 1 ELSE 0 END) AS content_user_answer_0_avg,
  AVG(CASE WHEN user_answer = 1 THEN 1 ELSE 0 END) AS content_user_answer_1_avg,
  AVG(CASE WHEN user_answer = 2 THEN 1 ELSE 0 END) AS content_user_answer_2_avg,
  AVG(CASE WHEN user_answer = 3 THEN 1 ELSE 0 END) AS content_user_answer_3_avg,
  STDDEV(CASE WHEN user_answer = 0 THEN 1 ELSE 0 END) AS content_user_answer_0_std,
  STDDEV(CASE WHEN user_answer = 1 THEN 1 ELSE 0 END) AS content_user_answer_1_std,
  STDDEV(CASE WHEN user_answer = 2 THEN 1 ELSE 0 END) AS content_user_answer_2_std,
  STDDEV(CASE WHEN user_answer = 3 THEN 1 ELSE 0 END) AS content_user_anser_3_std,
  -- prior_question_elapsed_time features
  MAX(question_elapsed_time) AS content_question_elapsed_time_max,
  MIN(question_elapsed_time) AS content_question_elapsed_time_min,
  AVG(question_elapsed_time) AS content_question_elapsed_time_avg,
  STDDEV(question_elapsed_time) AS content_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN question_had_explanation THEN 0 ELSE 1 END) AS content_question_had_explanation_inv_sum,
  AVG(CASE WHEN question_had_explanation THEN 0 ELSE 1 END) AS content_question_had_explanation_inv_avg,
  STDDEV(CASE WHEN question_had_explanation THEN 0 ELSE 1 END) AS content_question_had_explanation_inv_std,
  
  -- ### constant & LDA & PCA  features ###
  -- part 
  MAX(part) AS content_part,
  -- LDA
  MAX(user_correct_0) AS content_user_correct_0,
  MAX(user_correct_1) AS content_user_correct_1,
  MAX(user_correct_2) AS content_user_correct_2,
  MAX(user_correct_3) AS content_user_correct_3,
  MAX(user_correct_4) AS content_user_correct_4,
  MAX(user_miss_0) AS content_user_miss_0,
  MAX(user_miss_1) AS content_user_miss_1,
  MAX(user_miss_2) AS content_user_miss_2,
  MAX(user_miss_3) AS content_user_miss_3,
  MAX(user_miss_4) AS content_user_miss_4,
  -- PCA
  MAX(tags_pca_0) AS content_tags_pca_0,
  MAX(tags_pca_1) AS content_tags_pca_1,
  
FROM Kaggle_Riiid.cv_fold_info_20201027
INNER JOIN  add_lag_feat_table USING (row_id)
INNER JOIN Kaggle_Riiid.questions ON question_id = content_id
INNER JOIN  Kaggle_Riiid.lda_content_feat_v1_fold0 USING (content_id)
WHERE valid_fold != fold
GROUP BY content_id
