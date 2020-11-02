-- This query make row features

SELECT
  row_id,
  timestamp - IFNULL(LAG(timestamp) OVER (PARTITION BY user_id  ORDER BY row_id), 0) AS timediff,
  cumulative_answered_correctly/num_work AS correct_rate,
  cumulative_answered_correctly_part1/CASE WHEN work_part1_fillna = 0 THEN 1 ELSE work_part1_fillna END AS part1_correct_rate,
  cumulative_answered_correctly_part2/CASE WHEN work_part2_fillna = 0 THEN 1 ELSE work_part2_fillna END AS part2_correct_rate,
  cumulative_answered_correctly_part3/CASE WHEN work_part3_fillna = 0 THEN 1 ELSE work_part3_fillna END AS part3_correct_rate,
  cumulative_answered_correctly_part4/CASE WHEN work_part4_fillna = 0 THEN 1 ELSE work_part4_fillna END AS part4_correct_rate,
  cumulative_answered_correctly_part5/CASE WHEN work_part5_fillna = 0 THEN 1 ELSE work_part5_fillna END AS part5_correct_rate,
  cumulative_answered_correctly_part6/CASE WHEN work_part6_fillna = 0 THEN 1 ELSE work_part6_fillna END AS part6_correct_rate,
  cumulative_answered_correctly_part7/CASE WHEN work_part7_fillna = 0 THEN 1 ELSE work_part7_fillna END AS part7_correct_rate,
FROM (
SELECT
  *,
  IFNULL(LAST_VALUE(work_part1 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id), 0) AS work_part1_fillna,
  IFNULL(LAST_VALUE(work_part2 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id), 0) AS work_part2_fillna,
  IFNULL(LAST_VALUE(work_part3 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id), 0) AS work_part3_fillna,
  IFNULL(LAST_VALUE(work_part4 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id), 0) AS work_part4_fillna,
  IFNULL(LAST_VALUE(work_part5 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id), 0) AS work_part5_fillna,
  IFNULL(LAST_VALUE(work_part6 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id), 0) AS work_part6_fillna,
  IFNULL(LAST_VALUE(work_part7 IGNORE NULLS) OVER(PARTITION BY user_id ORDER BY row_id), 0) AS work_part7_fillna,
FROM (
SELECT
  -- ### key columns ###
  row_id,
  user_id,
  timestamp,
  answered_correctly,
  
  -- correct cumulative
  ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY row_id) AS num_work,
  SUM(answered_correctly) OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_answered_correctly,
  
  -- each part work
  CASE WHEN part = 1 THEN ROW_NUMBER() OVER (PARTITION BY user_id, part ORDER BY row_id) END AS work_part1,
  CASE WHEN part = 2 THEN ROW_NUMBER() OVER (PARTITION BY user_id, part ORDER BY row_id) END AS work_part2,
  CASE WHEN part = 3 THEN ROW_NUMBER() OVER (PARTITION BY user_id, part ORDER BY row_id) END AS work_part3,
  CASE WHEN part = 4 THEN ROW_NUMBER() OVER (PARTITION BY user_id, part ORDER BY row_id) END AS work_part4,
  CASE WHEN part = 5 THEN ROW_NUMBER() OVER (PARTITION BY user_id, part ORDER BY row_id) END AS work_part5,
  CASE WHEN part = 6 THEN ROW_NUMBER() OVER (PARTITION BY user_id, part ORDER BY row_id) END AS work_part6,
  CASE WHEN part = 7 THEN ROW_NUMBER() OVER (PARTITION BY user_id, part ORDER BY row_id) END AS work_part7,
  -- each part cumulative answered correctly
  part,
  IFNULL(SUM( CASE WHEN part = 1 THEN answered_correctly END) 
    OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS cumulative_answered_correctly_part1,
  IFNULL(SUM( CASE WHEN part = 2 THEN answered_correctly END) 
    OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS cumulative_answered_correctly_part2,
   IFNULL(SUM( CASE WHEN part = 3 THEN answered_correctly END) 
    OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS cumulative_answered_correctly_part3,
   IFNULL(SUM( CASE WHEN part = 4 THEN answered_correctly END) 
    OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS cumulative_answered_correctly_part4,
   IFNULL(SUM( CASE WHEN part = 5 THEN answered_correctly END) 
    OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS cumulative_answered_correctly_part5,
   IFNULL(SUM( CASE WHEN part = 6 THEN answered_correctly END) 
    OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS cumulative_answered_correctly_part6,
   IFNULL(SUM( CASE WHEN part = 7 THEN answered_correctly END) 
    OVER(PARTITION BY user_id ORDER BY row_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) AS cumulative_answered_correctly_part7,
    
FROM Kaggle_Riiid.train
INNER JOIN Kaggle_Riiid.questions ON questions.question_id = train.content_id
-- WHERE user_id = 1763006003 OR user_id=124
))
ORDER BY row_id
