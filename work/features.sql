-- iinitial feature extract
WITH
fold_tables AS (
  SELECT row_id
  FROM Kaggle_Riiid.cv_fold_info_20201015
  WHERE cv_fold_0 != -1 AND cv_fold_0 != 0
),
user_tables AS (
  SELECT
    user_id,
    #COUNT(answered_correctly) as answer_count,
    #SUM(answered_correctly) as answer_sum,
    #AVG(answered_correctly) as answer_average,
    #MAX(timestamp) as timestamp_max,
    #MAX(prior_question_elapsed_time) as prior_question_elapsed_time_max,
    #MIN(prior_question_elapsed_time) as prior_question_elapsed_time_min,
    #AVG(prior_question_elapsed_time) as prior_question_elapsed_time_avg,
    #SUM(CASE WHEN prior_question_had_explanation THEN 1 END) as prior_question_had_explanation_sum,
    #AVG(CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END) as prior_question_had_explanation_avg
  FROM Kaggle_Riiid.train
  GROUP BY user_id
)

SELECT row_id FROM Kaggle_Riiid.cv_fold_info_20201015


-- maege each fold
SELECT row_id, timestamp, user_id, answered_correctly, prior_question_elapsed_time, CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END as prior_question_had_explanation
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN Kaggle_Riiid.train USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 0

UNION ALL

SELECT row_id, timestamp, user_id, answered_correctly, prior_question_elapsed_time, CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END as prior_question_had_explanation
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN Kaggle_Riiid.train USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 1

UNION ALL

SELECT row_id, timestamp, user_id, answered_correctly, prior_question_elapsed_time, CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END as prior_question_had_explanation
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN Kaggle_Riiid.train USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 2

UNION ALL

SELECT row_id, timestamp, user_id, answered_correctly, prior_question_elapsed_time, CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END as prior_question_had_explanation
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN Kaggle_Riiid.train USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 3

UNION ALL

SELECT row_id, timestamp, user_id, answered_correctly, prior_question_elapsed_time, CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END as prior_question_had_explanation
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN Kaggle_Riiid.train USING (row_id)
WHERE cv_fold_0 != -1 AND cv_fold_0 != 4
