CREATE MODEL Kaggle_Riiid.xgb_v1
OPTIONS(MODEL_TYPE='BOOSTED_TREE_CLASSIFIER',
        BOOSTER_TYPE = 'GBTREE',
        NUM_PARALLEL_TREE = 1,
        MAX_ITERATIONS = 50,
        TREE_METHOD = 'HIST',
        EARLY_STOP = FALSE,
        SUBSAMPLE = 0.85,
        INPUT_LABEL_COLS = ['answered_correctly'])
AS SELECT 
  user_id,
  timestamp,
  content_id,
  task_container_id,
  prior_question_elapsed_time,
  prior_question_had_explanation,
  n_content,
  n_unique_content,
  user_answered_correctly_sum,
  user_answered_correctly_avg,
  user_answered_correctly_std,
  user_timestamp_max,
  user_timediff_max,
  user_timediff_min,
  user_timediff_avg,
  user_timediff_std,
  user_prior_question_elapsed_time_max,
  user_prior_question_elapsed_time_min,
  user_prior_question_elapsed_time_avg,
  user_prior_question_elapsed_time_std,
  user_prior_question_had_explanation_sum,
  user_prior_question_had_explanation_avg,
  user_prior_question_had_explanation_std,
  bundle_id,
  part,
  n_user,
  n_unique_user,
  -- content_answered_correctly_count,  n_userと同義
  content_answered_correctly_sum,
  content_answered_correctly_avg,
  content_answered_correctly_std,
  content_question_elapsed_time_max,
  content_question_elapsed_time_min,
  content_question_elapsed_time_avg,
  content_question_elapsed_time_std,
  content_question_had_explanation_sum,
  content_question_had_explanation_avg,
  content_question_had_explanation_std,
  answered_correctly  -- target
FROM Kaggle_Riiid.cv_fold_info_20201015 
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.feat_u_v1 USING (user_id)
INNER JOIN Kaggle_Riiid.feat_q_v1 ON feat_q_v1.question_id = train.content_id
WHERE cv_fold_0 != -1 AND feat_u_v1.cv_fold = 0 AND feat_q_v1.cv_fold = 0
