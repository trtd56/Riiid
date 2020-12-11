# My Solution

- Model: XGBoost
- Ensemble: iteration ensemble
- CV strategy: one out of fold
- feature:
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
  
I train my model by using BigQuery ML because I wanted to study SQL.
I think it was a good way for me.
And one other good thing about BigQuery ML is I can use all data to train.

# 最後に試すこと
## パラメータ調整
- [ ] DART, FOREST 複数設定
- [ ] LR=0.5
- [ ] Iter=400

## 特徴量
- [ ] Window=200の正解率
- [ ] Window=200の正解率(問題のみ)
- [ ] Window=200のlecture数
- [ ] 時間ごとの正解率/解いた問題数
- [ ] prior_question_had_explanation累計,　平均
- [ ] prior_question_elapsed_time平均
