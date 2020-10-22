WITH t AS (
SELECT
  user_id,
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  Kaggle_Riiid.train USING (row_id)
WHERE cv_fold_0 != -1 
GROUP BY user_id
),
add_lag_feat_table AS (
SELECT
  *,
  timestamp - LAG (timestamp) OVER (ORDER BY user_id, timestamp, row_id) AS timediff
FROM Kaggle_Riiid.train
ORDER BY user_id, timestamp, row_id
),
lect_feat_t1 AS (
SELECT
  user_id,
  COUNT(content_id) AS lecture_n_content_id,
  MAX(task_container_id) AS lecture_task_container_id_max,
  MIN(task_container_id) AS lecture_task_container_id_min,
  AVG(task_container_id) AS lecture_task_container_id_avg,
  STDDEV(task_container_id) AS lecture_task_container_id_std,
  MAX(timestamp) AS lecture_timestamp_max,
  MIN(timestamp) AS lecture_timestamp_min,
  MAX(timediff) AS lecture_timediff_max,
  MIN(timediff) AS lecture_timediff_min,
  AVG(timediff) AS lecture_timediff_avg,
  STDDEV(timediff) AS lecture_timediff_std,
FROM t
INNER JOIN add_lag_feat_table USING (user_id)
WHERE content_type_id = 1
GROUP BY user_id
)

SELECT * FROM lect_feat_t1
LEFT OUTER JOIN Kaggle_Riiid.lecture_lda_v1_fold0 USING (user_id)
