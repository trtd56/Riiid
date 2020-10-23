CREATE MODEL Kaggle_Riiid.xgb_v6_02_fold0
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
AS 
SELECT
  * EXCEPT (row_id, user_id, content_id, content_type_id, user_answer,
               cv_fold_0, cv_fold_1, cv_fold_2, cv_fold_3, cv_fold_4, fold,
               prior_question_had_explanation,
               -- 無視する特徴量(importance低い)
               user_part1_avg,
               user_part1_sum,
               user_part2_avg,
               user_part2_sum,
               user_part3_avg,
               user_part3_sum,
               user_part4_avg,
               user_part4_sum,
               user_part5_avg,
               user_part5_sum,
               user_part6_avg,
               user_part6_sum,
               user_part7_avg,
               user_part7_sum,
               user_timestamp_max
               ),
  CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END AS prior_question_had_explanation,
  cv_fold_0 = -1 AS is_test,
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.agg_user_feat_v1_fold0 USING (user_id)
