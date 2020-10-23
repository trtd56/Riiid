SELECT
  * EXCEPT (row_id, user_id, content_id, content_type_id, user_answer,
               cv_fold_0, cv_fold_1, cv_fold_2, cv_fold_3, cv_fold_4, fold,
               prior_question_had_explanation),
  CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END AS prior_question_had_explanation,
  cv_fold_0 = -1 AS is_test,
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.agg_user_feat_v1_fold0 USING (user_id)
