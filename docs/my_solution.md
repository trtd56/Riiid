# My Solution


I train my model by using BigQuery ML because I wanted to study SQL.
I think it was a good way for me.
And one other good thing about BigQuery ML is I can use all data to train.

## Model
### XGBoost
It looks that most people use LGBM but I use XGBoost.
I'm not familiar GBDT algorithm, I hear that LGBM is better than XGBoost.
Unfortunately, BigQuery ML only has XGBoost. So, I use XGBoost. (prioritized studying SQL)

BigQuery ML has other ML models. For example, Logistic Regression, ARIMA, and Neural Network.
I tried them but XGBoost was best.

### Parameter

This is my BigQuery code to train my XGB model.
The parameter can be seen here.

```sql
CREATE MODEL `<My model PATH>`
OPTIONS(MODEL_TYPE='BOOSTED_TREE_CLASSIFIER',
        BOOSTER_TYPE = 'GBTREE',
        NUM_PARALLEL_TREE = 1,
        MAX_ITERATIONS = 300,
        TREE_METHOD = 'HIST',
        EARLY_STOP = False,
        MIN_REL_PROGRESS=0.0001,
        LEARN_RATE =0.3,
        MAX_TREE_DEPTH=11,
        COLSAMPLE_BYTREE=1.0,
        COLSAMPLE_BYLEVEL=0.4,
        SUBSAMPLE = 0.9,
        MIN_TREE_CHILD_WEIGHT=2,
        L1_REG=0,
        L2_REG=1.0,
        INPUT_LABEL_COLS = ['answered_correctly'],
        DATA_SPLIT_METHOD='CUSTOM',
        DATA_SPLIT_COL='is_test')    
AS 
SELECT `<My Feature Tables>`
```

## CV strategy
### leave-one-out
I use [this strategy](https://www.kaggle.com/its7171/cv-strategy) by leave-one-out. It has looked good to me.

## Ensemble
### NO
I use a single model.
I tried iteration ensemble and CV fold ensemble, however, both got the same score as my single model.

## Feature
My features is:
  - aggregation by contents
    - answered_correctl: count/sum/avg/std
    - timestamp: max/min/avg/std
    - user_id: count/unique_count
    - task_container_id: max/min/avg/std
    - user_answer_0~3: sum/avg/std
    - question_elapsed_time: max/min/avg/std
    - question_had_explanation: sum/avg/std
  - each question tags cumulative sum
    - number of try
    - number of correct answer
    - correct answer rate
  - each lecture tag cumulative sum
    - number of try
  - timestamp diff
  
## Reference
### Notebook
- Create SQL: https://www.kaggle.com/takamichitoda/riiid-create-sql
- Create Tags Onehot Encode Table: https://www.kaggle.com/takamichitoda/riiid-create-feature-table-csv
- Create CV index: https://www.kaggle.com/takamichitoda/riiid-make-cv-index

# 最後に試すこと

|モデル名|Loss|AUC|LB|memo|
|--|--|--|--|--|
|__xgb_v15_13_f0__|__0.5274__|__0.7763__|__0.779__|__baseline__|
|xgb_v17_01_f0||||Iter=400, Window=200の正解率|
|xgb_v17_02_f0||||xgb_v17_01_f0に特徴量追加|
|xgb_v17_03_f0||||LR=0.5|

## 特徴量
- Window=200
  - lecture: count/avg/std
  - timediff: avg/std
  - prior_question_elapsed_time: avg/std
  - prior_question_had_explanation: count/avg/std
- prior_question_had_explanation: 累計, 平均 
- 時間ごとの解いた問題数/正解率

## LGBM
- LGBMモデル学習: https://www.kaggle.com/takamichitoda/riiid-lgbm-bagging2-trainn?scriptVersionId=49472329
- パラメータ調整: https://www.kaggle.com/ammarnassanalhajali/riiid-lgbm-bagging2-sakt-0-781
- 少量データで？1000万行とか

## SAKT
- 4th model予測(train auc = 0.774)
  - https://www.kaggle.com/takamichitoda/riiid-sakt-infer-only?scriptVersionId=49571864
  
## アンサンブル
- SANK + XGB, 90%
  - https://www.kaggle.com/takamichitoda/riiid-infer-v4-xgb-sakt?scriptVersionId=49549159
- SANK + XGB, no limit
- SANK + XGB, SANKのみno limit
- SANK best + XGB

## 確認
- https://www.kaggle.com/c/riiid-test-answer-prediction/discussion/203184
