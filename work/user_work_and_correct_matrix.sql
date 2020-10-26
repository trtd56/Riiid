SELECT 
  user_id,
  IFNULL(SUM(CASE WHEN part = 1 THEN 1 END), 0) AS work_part1,
  IFNULL(SUM(CASE WHEN part = 2 THEN 1 END), 0) AS work_part2,
  IFNULL(SUM(CASE WHEN part = 3 THEN 1 END), 0) AS work_part3,
  IFNULL(SUM(CASE WHEN part = 4 THEN 1 END), 0) AS work_part4,
  IFNULL(SUM(CASE WHEN part = 5 THEN 1 END), 0) AS work_part5,
  IFNULL(SUM(CASE WHEN part = 6 THEN 1 END), 0) AS work_part6,
  IFNULL(SUM(CASE WHEN part = 7 THEN 1 END), 0) AS work_part7,
  IFNULL(SUM(CASE WHEN part = 1 AND answered_correctly = 1 THEN 1 END), 0) AS correct_part1,
  IFNULL(SUM(CASE WHEN part = 2 AND answered_correctly = 1 THEN 1 END), 0) AS correct_part2,
  IFNULL(SUM(CASE WHEN part = 3 AND answered_correctly = 1 THEN 1 END), 0) AS correct_part3,
  IFNULL(SUM(CASE WHEN part = 4 AND answered_correctly = 1 THEN 1 END), 0) AS correct_part4,
  IFNULL(SUM(CASE WHEN part = 5 AND answered_correctly = 1 THEN 1 END), 0) AS correct_part5,
  IFNULL(SUM(CASE WHEN part = 6 AND answered_correctly = 1 THEN 1 END), 0) AS correct_part6,
  IFNULL(SUM(CASE WHEN part = 7 AND answered_correctly = 1 THEN 1 END), 0) AS correct_part7, 
FROM Kaggle_Riiid.train
INNER JOIN Kaggle_Riiid.questions ON question_id = content_id
WHERE content_type_id = 0
GROUP BY user_id
