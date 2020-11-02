CREATE MODEL Kaggle_Riiid.xgb_v10_03
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
  * EXCEPT (row_id, user_id, content_id, content_type_id, user_answer, valid_fold,
               prior_question_had_explanation, question_id
               ),
  CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END AS prior_question_had_explanation,
  valid_fold = 0 AS is_test,
FROM Kaggle_Riiid.cv_fold_info_20201027
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN  Kaggle_Riiid.row_features_v1 USING (row_id)
INNER JOIN Kaggle_Riiid.question_tags_ohe ON question_id = content_id
INNER JOIN Kaggle_Riiid.agg_contents_feat_v3 ON agg_contents_feat_v3.question_id = content_id
