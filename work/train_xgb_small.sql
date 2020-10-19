CREATE MODEL Kaggle_Riiid.xgb_v1_1_fold0
OPTIONS(MODEL_TYPE='BOOSTED_TREE_CLASSIFIER',
        BOOSTER_TYPE = 'GBTREE',
        NUM_PARALLEL_TREE = 1,
        MAX_ITERATIONS = 1000,  -- early stoppingがあるのでなるだけ多く
        TREE_METHOD = 'HIST',
        EARLY_STOP = True,
        MIN_REL_PROGRESS=0.001,
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
  IFNULL(user_id, -1) AS user_id,
  IFNULL(content_id, -1) AS content_id,
  IFNULL(user_answered_correctly_sum, -1) AS user_answered_correctly_sum,
  IFNULL(user_answered_correctly_avg, -1) AS user_answered_correctly_avg,
  IFNULL(content_answered_correctly_avg, -1) AS content_answered_correctly_avg,
  answered_correctly,  -- target
  cv_fold_0　= -1 as is_test,  -- test split rule
FROM Kaggle_Riiid.cv_fold_info_20201015 
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.feat_u_v1 USING (user_id)
INNER JOIN Kaggle_Riiid.feat_q_v1 ON feat_q_v1.question_id = train.content_id
WHERE feat_u_v1.cv_fold = 0 AND feat_q_v1.cv_fold = 0
