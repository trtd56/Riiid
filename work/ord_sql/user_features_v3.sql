-- set fold number
DECLARE fold INT64 DEFAULT 0;

-- user features
SELECT
  user_id,
  fold AS cv_fold,
  AVG(CASE WHEN part = 1 THEN answered_correctly END) AS part1_avg,
  AVG(CASE WHEN part = 2 THEN answered_correctly END) AS part2_avg,
  AVG(CASE WHEN part = 3 THEN answered_correctly END) AS part3_avg,
  AVG(CASE WHEN part = 4 THEN answered_correctly END) AS part4_avg,
  AVG(CASE WHEN part = 5 THEN answered_correctly END) AS part5_avg,
  AVG(CASE WHEN part = 6 THEN answered_correctly END) AS part6_avg,
  AVG(CASE WHEN part = 7 THEN answered_correctly END) AS part7_avg,
  SUM(CASE WHEN part = 1 THEN answered_correctly END) AS part1_sum,
  SUM(CASE WHEN part = 2 THEN answered_correctly END) AS part2_sum,
  SUM(CASE WHEN part = 3 THEN answered_correctly END) AS part3_sum,
  SUM(CASE WHEN part = 4 THEN answered_correctly END) AS part4_sum,
  SUM(CASE WHEN part = 5 THEN answered_correctly END) AS part5_sum,
  SUM(CASE WHEN part = 6 THEN answered_correctly END) AS part6_sum,
  SUM(CASE WHEN part = 7 THEN answered_correctly END) AS part7_sum,
  STDDEV(CASE WHEN part = 1 THEN answered_correctly END) AS part1_std,
  STDDEV(CASE WHEN part = 2 THEN answered_correctly END) AS part2_std,
  STDDEV(CASE WHEN part = 3 THEN answered_correctly END) AS part3_std,
  STDDEV(CASE WHEN part = 4 THEN answered_correctly END) AS part4_std,
  STDDEV(CASE WHEN part = 5 THEN answered_correctly END) AS part5_std,
  STDDEV(CASE WHEN part = 6 THEN answered_correctly END) AS part6_std,
  STDDEV(CASE WHEN part = 7 THEN answered_correctly END) AS part7_std,
  MAX(task_container_id) AS task_container_id_max,
  COUNT(DISTINCT task_container_id) AS n_unique_task_container_id,
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.questions ON questions.question_id = train.content_id
WHERE cv_fold_0 != -1
GROUP BY user_id
