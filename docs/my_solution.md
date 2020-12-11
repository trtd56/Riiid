# My Solution

- Model: XGBoost
- Ensemble: iteration ensemble
- CV strategy: one out of fold
- feature:

I train my model by using BigQuery ML because I wanted to study SQL.
I think it was a good way for me.

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
