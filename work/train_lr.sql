CREATE MODEL Kaggle_Riiid.lr_v1_01_fold0
OPTIONS(MODEL_TYPE='LOGISTIC_REG',
        INPUT_LABEL_COLS = ['answered_correctly'],
        DATA_SPLIT_METHOD='CUSTOM',
        DATA_SPLIT_COL='is_test')    
AS 
SELECT
  * EXCEPT (row_id, user_id, content_id, content_type_id, user_answer,
               cv_fold_0, cv_fold_1, cv_fold_2, cv_fold_3, cv_fold_4, fold,
               prior_question_had_explanation,
               question_id, content_part,
               -- ignore user agg feat
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
               user_timestamp_max,
               user_lda_lecture_0,
               user_lda_lecture_1,
               user_lda_lecture_2,
               user_lda_lecture_3,
               user_lda_lecture_4,
               user_task_container_id_max,
               user_correct_part1_std,
               user_correct_part2_std,
               user_correct_part3_std,
               user_correct_part4_std,
               user_correct_part5_std,
               user_correct_part6_std,
               user_correct_part7_std,
               user_correct_part1_sum,
               user_correct_part2_sum,
               user_correct_part3_sum,
               user_correct_part4_sum,
               user_correct_part5_sum,
               user_correct_part6_sum,
               user_correct_part7_sum,
               user_n_unique_content,
               user_prior_question_elapsed_time_std,
               user_prior_question_elapsed_time_min,
               user_prior_question_elapsed_time_avg,
               user_prior_question_elapsed_time_max,
               user_prior_question_had_explanation_inv_avg,
               user_prior_question_had_explanation_inv_std,
               user_n_unique_task_container_id,
               user_n_content,
               -- ignore content agg feat
               content_timestamp_min,
               content_timestamp_max,
               content_timestamp_std,
               content_timestamp_avg,
               content_question_elapsed_time_std,
               content_question_elapsed_time_min,
               content_question_elapsed_time_avg,
               content_task_container_id_max,
               content_task_container_id_min,
               content_task_container_id_avg,
               content_task_container_id_std,
               content_user_answer_0_sum,
               content_user_answer_1_sum,
               content_user_answer_2_sum,
               content_user_answer_3_sum,
               content_n_user,
               content_tags_pca_0,
               content_tags_pca_1
               -- ignore part agg feat
               -- part_n_content_id,
               -- part_n_unique_user,
               -- part_task_container_id_avg,
               -- part_task_container_id_std
               ),
  CASE WHEN prior_question_had_explanation THEN 1 ELSE 0 END AS prior_question_had_explanation,
  cv_fold_0 = -1 AS is_test,
FROM Kaggle_Riiid.cv_fold_info_20201015
INNER JOIN  Kaggle_Riiid.train USING (row_id)
INNER JOIN Kaggle_Riiid.agg_user_feat_v1_fold0 USING (user_id)
INNER JOIN Kaggle_Riiid.agg_contents_feat_v1_fold0 ON question_id = content_id
INNER JOIN Kaggle_Riiid.agg_part_feat_v1_fold0 ON content_part = part