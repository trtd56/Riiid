-- set fold number
DECLARE fold INT64 DEFAULT 0;

-- lag features
WITH add_lag_feat_table AS (
SELECT
  *,
  LEAD (prior_question_elapsed_time) OVER (ORDER BY user_id, timestamp, row_id) AS question_elapsed_time,
  LEAD (prior_question_had_explanation) OVER (ORDER BY user_id, timestamp, row_id) AS question_had_explanation
FROM Kaggle_Riiid.train
ORDER BY user_id, timestamp, row_id
),

-- contents features
contents_feat_table AS (
SELECT
  content_id as question_id,
  *
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  add_lag_feat_table USING (row_id)
WHERE cv_fold_0 != -1
)

-- joint question
SELECT
  part,
  fold AS cv_fold,
  -- question features
  COUNT(content_id) AS part_n_content_id,
  COUNT(bundle_id) AS part_bundle_id,
  -- user features
  COUNT(user_id) AS part_n_user,
  COUNT(DISTINCT user_id) AS part_n_unique_user,
  -- answer features
  COUNT(answered_correctly) AS part_answered_correctly_count,
  SUM(answered_correctly) AS part_answered_correctly_sum,
  AVG(answered_correctly) AS part_answered_correctly_avg,
  STDDEV(answered_correctly)　AS part_answered_correctly_std,
  -- prior_question_elapsed_time features
  MAX(question_elapsed_time) AS part_question_elapsed_time_max,
  MIN(question_elapsed_time) AS part_question_elapsed_time_min,
  AVG(question_elapsed_time) AS part_question_elapsed_time_avg,
  STDDEV(question_elapsed_time) AS part_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN question_had_explanation THEN 1 END) AS part_question_had_explanation_sum,
  AVG(CASE WHEN question_had_explanation THEN 1 ELSE 0 END) AS part_question_had_explanation_avg,
  STDDEV(CASE WHEN question_had_explanation THEN 1 ELSE 0 END) AS part_question_had_explanation_std,
  -- listening or readiing
  CASE WHEN part < 5 THEN "L" ELSE "R" END AS part_type
FROM Kaggle_Riiid.questions
INNER JOIN  contents_feat_table ON questions.question_id = contents_feat_table.content_id
GROUP BY part
