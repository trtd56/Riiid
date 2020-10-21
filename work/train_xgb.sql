CREATE MODEL Kaggle_Riiid.xgb_v2_10_fold0
OPTIONS(MODEL_TYPE='BOOSTED_TREE_CLASSIFIER',
        BOOSTER_TYPE = 'GBTREE',
        NUM_PARALLEL_TREE = 1,
        MAX_ITERATIONS = 1000,  -- early stoppingがあるのでなるだけ多く
        TREE_METHOD = 'HIST',
        EARLY_STOP = True,
        MIN_REL_PROGRESS=0.0001,
        LEARN_RATE =0.1,
        MAX_TREE_DEPTH=8, -- 5 ~ 8
        COLSAMPLE_BYTREE=1.0,
        COLSAMPLE_BYLEVEL=0.1, -- 0.5 ~0.1 を0.1刻み
        SUBSAMPLE = 0.9,
        MIN_TREE_CHILD_WEIGHT=2, -- 2^で増やしていく
        -- 正則化はL1=0, L2=2(デフォルト)
        INPUT_LABEL_COLS = ['answered_correctly'],
        DATA_SPLIT_METHOD='CUSTOM',
        DATA_SPLIT_COL='is_test')    
AS SELECT
  -- v1 features
  -- CAST(user_id AS STRING) AS user_id,　膨大→embedする？
  IFNULL(timestamp, -1) AS timestamp,
  -- CAST(content_id AS STRING) AS content_id, 膨大→embedする？
  IFNULL(task_container_id, -1) AS task_container_id,
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
  -- CAST(bundle_id AS STRING) AS bundle_id, 膨大→embedする？
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
  -- v2 features
  IFNULL(timediff_start_max, -1) AS timediff_start_max,
  IFNULL(timediff_start_min, -1) AS timediff_start_min,
  IFNULL(timediff_start_avg, -1) AS timediff_start_avg,
  IFNULL(timediff_start_std, -1) AS timediff_start_std,
  IFNULL(user_timediff_2_max, -1) AS user_timediff_2_max,
  IFNULL(user_timediff_2_min, -1) AS user_timediff_2_min,
  IFNULL(user_timediff_2_avg, -1) AS user_timediff_2_avg,
  IFNULL(user_timediff_2_std, -1) AS user_timediff_2_std,
  IFNULL(user_timediff_4_max, -1) AS user_timediff_4_max,
  IFNULL(user_timediff_4_min, -1) AS user_timediff_4_min,
  IFNULL(user_timediff_4_avg, -1) AS user_timediff_4_avg,
  IFNULL(user_timediff_4_std, -1) AS user_timediff_4_std,
  IFNULL(user_timediff_8_max, -1) AS user_timediff_8_max,
  IFNULL(user_timediff_8_min, -1) AS user_timediff_8_min,
  IFNULL(user_timediff_8_avg, -1) AS user_timediff_8_avg,
  IFNULL(user_timediff_8_std, -1) AS user_timediff_8_std,
  IFNULL(user_timediff_16_max, -1) AS user_timediff_16_max,
  IFNULL(user_timediff_16_min, -1) AS user_timediff_16_min,
  IFNULL(user_timediff_16_avg, -1) AS user_timediff_16_avg,
  IFNULL(user_timediff_16_std, -1) AS user_timediff_16_std,
  IFNULL(part_n_content_id, -1) AS part_n_content_id,
  IFNULL(part_bundle_id, -1) AS part_bundle_id,
  IFNULL(part_n_user, -1) AS part_n_user,
  IFNULL(part_n_unique_user, -1) AS part_n_unique_user,
  IFNULL(part_answered_correctly_count, -1) AS part_answered_correctly_count,
  IFNULL(part_answered_correctly_sum, -1) AS part_answered_correctly_sum,
  IFNULL(part_answered_correctly_avg, -1) AS part_answered_correctly_avg,
  IFNULL(part_answered_correctly_std, -1) AS part_answered_correctly_std,
  IFNULL(part_question_elapsed_time_max, -1) AS part_question_elapsed_time_max,
  IFNULL(part_question_elapsed_time_min, -1) AS part_question_elapsed_time_min,
  IFNULL(part_question_elapsed_time_avg, -1) AS part_question_elapsed_time_avg,
  IFNULL(part_question_elapsed_time_std, -1) AS part_question_elapsed_time_std,
  IFNULL(part_question_had_explanation_sum, -1) AS part_question_had_explanation_sum,
  IFNULL(part_question_had_explanation_avg, -1) AS part_question_had_explanation_avg,
  IFNULL(part_question_had_explanation_std, -1) AS part_question_had_explanation_std,
  CAST(part_type AS STRING) AS part_type,  
  answered_correctly,  -- target
  cv_fold_0　= -1 as is_test,  -- test split rule
FROM Kaggle_Riiid.cv_fold_info_20201015 
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.feat_u_v1 USING (user_id)
INNER JOIN Kaggle_Riiid.feat_u_v2 USING (user_id)
INNER JOIN Kaggle_Riiid.feat_q_v1 ON feat_q_v1.question_id = train.content_id
INNER JOIN Kaggle_Riiid.feat_p_v1 USING (part)
WHERE feat_u_v1.cv_fold = 0 AND feat_q_v1.cv_fold = 0
