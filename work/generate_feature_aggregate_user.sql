DECLARE fold INT64 DEFAULT 0;

-- This query make aggregation features by user

SELECT

  -- ### key columns ###
  user_id,
  fold AS fold,

  -- ### target encoding features ###
  -- aggregation by user
  SUM(answered_correctly) AS user_answered_correctly_sum,
  AVG(answered_correctly) AS user_answered_correctly_avg,
  STDDEV(answered_correctly)　AS user_answered_correctly_std,
  -- aggregation by user and part
  AVG(CASE WHEN part = 1 THEN answered_correctly END) AS user_correct_part1_avg,
  AVG(CASE WHEN part = 2 THEN answered_correctly END) AS user_correct_part2_avg,
  AVG(CASE WHEN part = 3 THEN answered_correctly END) AS user_correct_part3_avg,
  AVG(CASE WHEN part = 4 THEN answered_correctly END) AS user_correct_part4_avg,
  AVG(CASE WHEN part = 5 THEN answered_correctly END) AS user_correct_part5_avg,
  AVG(CASE WHEN part = 6 THEN answered_correctly END) AS user_correct_part6_avg,
  AVG(CASE WHEN part = 7 THEN answered_correctly END) AS user_correct_part7_avg,
  SUM(CASE WHEN part = 1 THEN answered_correctly END) AS user_correct_part1_sum,
  SUM(CASE WHEN part = 2 THEN answered_correctly END) AS user_correct_part2_sum,
  SUM(CASE WHEN part = 3 THEN answered_correctly END) AS user_correct_part3_sum,
  SUM(CASE WHEN part = 4 THEN answered_correctly END) AS user_correct_part4_sum,
  SUM(CASE WHEN part = 5 THEN answered_correctly END) AS user_correct_part5_sum,
  SUM(CASE WHEN part = 6 THEN answered_correctly END) AS user_correct_part6_sum,
  SUM(CASE WHEN part = 7 THEN answered_correctly END) AS user_correct_part7_sum,
  STDDEV(CASE WHEN part = 1 THEN answered_correctly END) AS user_correct_part1_std,
  STDDEV(CASE WHEN part = 2 THEN answered_correctly END) AS user_correct_part2_std,
  STDDEV(CASE WHEN part = 3 THEN answered_correctly END) AS user_correct_part3_std,
  STDDEV(CASE WHEN part = 4 THEN answered_correctly END) AS user_correct_part4_std,
  STDDEV(CASE WHEN part = 5 THEN answered_correctly END) AS user_correct_part5_std,
  STDDEV(CASE WHEN part = 6 THEN answered_correctly END) AS user_correct_part6_std,
  STDDEV(CASE WHEN part = 7 THEN answered_correctly END) AS user_correct_part7_std,
  
  -- ### other aggregated user features ###
  -- time features
  MAX(timestamp) as user_timestamp_max,
  -- contents features
  COUNT(content_id) AS user_n_content,
  COUNT(DISTINCT content_id) AS user_n_unique_content,
  -- task_container_id features
  MAX(task_container_id) AS user_task_container_id_max,
  COUNT(DISTINCT task_container_id) AS user_n_unique_task_container_id,
  -- prior_question_elapsed_time features
  MAX(prior_question_elapsed_time) AS user_prior_question_elapsed_time_max,
  MIN(prior_question_elapsed_time) AS user_prior_question_elapsed_time_min,
  AVG(prior_question_elapsed_time) AS user_prior_question_elapsed_time_avg,
  STDDEV(prior_question_elapsed_time) AS user_prior_question_elapsed_time_std,
  -- prior_question_had_explanation features
  SUM(CASE WHEN prior_question_had_explanation THEN 0 ELSE 1 END) AS user_prior_question_had_explanation_inv_sum,
  AVG(CASE WHEN prior_question_had_explanation THEN 0 ELSE 1 END) AS user_prior_question_had_explanation_inv_avg,
  STDDEV(CASE WHEN prior_question_had_explanation THEN 0 ELSE 1 END) AS user_prior_question_had_explanation_inv_std,
  
  -- ### other aggregated question features ###
  -- bundle features
  COUNT(DISTINCT bundle_id) AS user_n_unique_bundle,
  -- part features
  SUM(CASE WHEN part = 1 THEN 1 END) AS user_part1_sum,
  SUM(CASE WHEN part = 2 THEN 1 END) AS user_part2_sum,
  SUM(CASE WHEN part = 3 THEN 1 END) AS user_part3_sum,
  SUM(CASE WHEN part = 4 THEN 1 END) AS user_part4_sum,
  SUM(CASE WHEN part = 5 THEN 1 END) AS user_part5_sum,
  SUM(CASE WHEN part = 6 THEN 1 END) AS user_part6_sum,
  SUM(CASE WHEN part = 7 THEN 1 END) AS user_part7_sum,
  SUM(CASE WHEN part = 1 THEN 1 END) /COUNT(content_id) AS user_part1_avg, 
  SUM(CASE WHEN part = 2 THEN 1 END) /COUNT(content_id) AS user_part2_avg,  
  SUM(CASE WHEN part = 3 THEN 1 END) /COUNT(content_id) AS user_part3_avg,  
  SUM(CASE WHEN part = 4 THEN 1 END) /COUNT(content_id) AS user_part4_avg,  
  SUM(CASE WHEN part = 5 THEN 1 END) /COUNT(content_id) AS user_part5_avg,  
  SUM(CASE WHEN part = 6 THEN 1 END) /COUNT(content_id) AS user_part6_avg,  
  SUM(CASE WHEN part = 7 THEN 1 END) /COUNT(content_id) AS user_part7_avg,  
  
  -- ### LDA features ###
  -- lecture
  MAX(lecture_0) AS user_lda_lecture_0,
  MAX(lecture_1) AS user_lda_lecture_1,
  MAX(lecture_2) AS user_lda_lecture_2,
  MAX(lecture_3) AS user_lda_lecture_3,
  MAX(lecture_4) AS user_lda_lecture_4,
  -- contents
  MAX(content_correct_0) AS user_lda_content_correct_0, 
  MAX(content_correct_1) AS user_lda_content_correct_1, 
  MAX(content_correct_2) AS user_lda_content_correct_2, 
  MAX(content_correct_3) AS user_lda_content_correct_3, 
  MAX(content_correct_4) AS user_lda_content_correct_4, 
  MAX(content_miss_0) AS user_lda_content_miss_0, 
  MAX(content_miss_1) AS user_lda_content_miss_1, 
  MAX(content_miss_2) AS user_lda_content_miss_2, 
  MAX(content_miss_3) AS user_lda_content_miss_3, 
  MAX(content_miss_4) AS user_lda_content_miss_4, 

FROM Kaggle_Riiid.cv_fold_info_20201027
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.questions ON questions.question_id = train.content_id
INNER JOIN Kaggle_Riiid.lda_user_feat_v1_fold0 USING (user_id)
INNER JOIN Kaggle_Riiid.lda_lecture_feat_v1_fold0 USING (user_id)
WHERE valid_fold != fold
GROUP BY user_id
