# My Solution


My main strategy is training my model by using BigQuery ML because I wanted to learn it.
I think it was a good way for me. And one other good thing about BigQuery ML is I can use all data to train.

## Model
### XGBoost
It looks that most people use LGBM but I use XGBoost.
I'm not familiar GBDT algorithm, I hear that LGBM is better than XGBoost.
Unfortunately, BigQuery ML only has XGBoost. So, I use XGBoost.

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

I use the best XGBoost model and two SAKT models.
SAKT models are made by forking [this notebook](https://www.kaggle.com/tarique7/v4-fork-of-riiid-sakt-model-full).
I little updated three in this notebook that:
1. Randomly cut to a length of 200 in train data. (original code had used last 200 data)
2. Save best score epoch model.
3. Parameter tuning.

Each score is here.

|model|CV|LB|
| -- | -- | -- |
|XGB|0.7784|0.781|
|SAKT1|0.772|0.774|
|SAKT2|0.772|0.773|

I weighted averaging 3:1:1 this model and I got 0.787 in the public leaderboard.

I tried iteration ensemble and CV fold ensemble in XGBoost, however, both got the same score as my single model.

Final my submission notebook is [here](https://www.kaggle.com/takamichitoda/riiid-infer-v8-xgb-sakt?scriptVersionId=51291197).

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
  - time window features that size is 200 
    - answer correctry: sum/avg/std
    - question_elapsed_time: avg/max
    - question_had_explanation: sum/avg/std
    - timestamp lag: avg/max
    - number of content_id=0
    - number of content_id=1
  - timestamp lag

## Reference
### Notebook
- Create SQL: https://www.kaggle.com/takamichitoda/riiid-create-sql
- Create Tags Onehot Encode Table: https://www.kaggle.com/takamichitoda/riiid-create-feature-table-csv
- Create CV index: https://www.kaggle.com/takamichitoda/riiid-make-cv-index

# 最後に試すこと

|モデル名|Loss|AUC|LB|memo|
|--|--|--|--|--|
|__xgb_v15_13_f0__|__0.5274__|__0.7763__|__0.779__|__baseline__|
|xgb_v17_01_f0|0.5270|0.7767|モデルでかすぎ|Iter=400, Window=200の正解率|
|xgb_v17_02_f0|0.5266|0.7771|0.779|Iter=300, Window=200の正解率, 特徴量追加→null importanceで選択|
|xgb_v17_03_f0|0.5255|0.7783||Iter=300, Window=200の正解率, 特徴量追加, with answer std|
|xgb_v17_04_f0|0.5266|0.7771||Iter=300, Window=200の正解率, 特徴量追加→null importanceで選択した残りのやつv1~4|
|xgb_v17_05_f0|0.5255|0.7784||DART, TREE|
|xgb_v17_06_f0|0.5255|0.7784|0.781|DART, FOREST-4|
|xgb_v17_07_f0|0.5252|0.7787||DART, FOREST-4, 特徴追加(lectureとworkのカウントを分ける)|
|xgb_v17_08_f0|0.5255|0.7784||DART, FOREST-4, 特徴追加(lectureとworkのカウントを分ける), bug fix|
