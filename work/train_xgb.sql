CREATE MODEL Kaggle_Riiid.xgb_v1_6_fold0
OPTIONS(MODEL_TYPE='BOOSTED_TREE_CLASSIFIER',
        BOOSTER_TYPE = 'GBTREE',
        NUM_PARALLEL_TREE = 1,
        MAX_ITERATIONS = 1000,  -- early stoppingがあるのでなるだけ多く
        TREE_METHOD = 'HIST',
        EARLY_STOP = True,
        MIN_REL_PROGRESS=0.0001,
        LEARN_RATE =0.1,
        MAX_TREE_DEPTH=5, -- 5 ~ 8
        COLSAMPLE_BYTREE=1.0,
        COLSAMPLE_BYLEVEL=0.3, -- 0.5 ~0.1 を0.1刻み
        SUBSAMPLE = 0.9,
        MIN_TREE_CHILD_WEIGHT=1, -- 2^で増やしていく
        -- 正則化はL1=0, L2=2(デフォルト)
        INPUT_LABEL_COLS = ['answered_correctly'],
        DATA_SPLIT_METHOD='CUSTOM',
        DATA_SPLIT_COL='is_test')    
AS SELECT 
  CAST(user_id AS STRING) AS user_id,
  IFNULL(timestamp, -1) AS timestamp,
  CAST(content_id AS STRING) AS content_id,
  CAST(task_container_id AS STRING) AS task_container_id,
  IFNULL(prior_question_elapsed_time, -1) AS prior_question_elapsed_time,
  CAST(prior_question_had_explanation AS STRING) AS prior_question_had_explanation,
  IFNULL(n_content, -1) AS n_content,  
  IFNULL(n_unique_content, -1) AS n_unique_content,
  IFNULL(user_answered_correctly_sum, -1) AS user_answered_correctly_sum,
  IFNULL(user_answered_correctly_avg, -1) AS user_answered_correctly_avg,
  IFNULL(user_answered_correctly_std, -1) AS user_answered_correctly_std,
  IFNULL(user_timestamp_max, -1) AS user_timestamp_max,
  IFNULL(user_timediff_max, -1) AS user_timediff_max,
  IFNULL(user_timediff_min, -1) AS user_timediff_min,
  IFNULL(user_timediff_avg, -1) AS user_timediff_avg,
  IFNULL(user_timediff_std, -1) AS user_timediff_std,
  IFNULL(user_prior_question_elapsed_time_max, -1) AS user_prior_question_elapsed_time_max,
  IFNULL(user_prior_question_elapsed_time_min, -1) AS user_prior_question_elapsed_time_min,
  IFNULL(user_prior_question_elapsed_time_avg, -1) AS user_prior_question_elapsed_time_avg,
  IFNULL(user_prior_question_elapsed_time_std, -1) AS user_prior_question_elapsed_time_std,
  IFNULL(user_prior_question_had_explanation_sum, -1) AS user_prior_question_had_explanation_sum,
  IFNULL(user_prior_question_had_explanation_avg, -1) AS user_prior_question_had_explanation_avg,
  IFNULL(user_prior_question_had_explanation_std, -1) AS user_prior_question_had_explanation_std,
  CAST(bundle_id AS STRING) AS bundle_id,
  CAST(part AS STRING) AS part,
  IFNULL(n_user, -1) AS n_user,
  IFNULL(n_unique_user, -1) AS n_unique_user,
  IFNULL(content_answered_correctly_sum, -1) AS content_answered_correctly_sum,
  IFNULL(content_answered_correctly_avg, -1) AS content_answered_correctly_avg,
  IFNULL(content_answered_correctly_std, -1) AS content_answered_correctly_std,
  IFNULL(content_question_elapsed_time_max, -1) AS content_question_elapsed_time_max, 
  IFNULL(content_question_elapsed_time_min, -1) AS content_question_elapsed_time_min,
  IFNULL(content_question_elapsed_time_avg, -1) AS content_question_elapsed_time_avg,
  IFNULL(content_question_elapsed_time_std, -1) AS content_question_elapsed_time_std,
  IFNULL(content_question_had_explanation_sum, -1) AS content_question_had_explanation_sum,
  IFNULL(content_question_had_explanation_avg, -1) AS content_question_had_explanation_avg,
  IFNULL(content_question_had_explanation_std, -1) AS content_question_had_explanation_std,
  answered_correctly,  -- target
  cv_fold_0　= -1 as is_test,  -- test split rule
FROM Kaggle_Riiid.cv_fold_info_20201015 
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.feat_u_v1 USING (user_id)
INNER JOIN Kaggle_Riiid.feat_q_v1 ON feat_q_v1.question_id = train.content_id
WHERE feat_u_v1.cv_fold = 0 AND feat_q_v1.cv_fold = 0
