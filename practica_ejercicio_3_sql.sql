SELECT  FROM `core-almanac-436715-v4.keepcoding.ivr_calls` LIMIT 1000


CREATE  TABLE `keepcoding.ivr_detail` AS
SELECT 
    ivr_calls.ivr_id AS calls_ivr_id,
    ivr_calls.phone_number AS calls_phone_number,
    ivr_calls.ivr_result AS calls_ivr_result,
    ivr_calls.vdn_label AS calls_vdn_label,
    ivr_calls.start_date AS calls_start_date,
    FORMAT_DATE('%Y%m%d', ivr_calls.start_date) AS calls_start_date_id,  -- Campo calculado
    ivr_calls.end_date AS calls_end_date,
    FORMAT_DATE('%Y%m%d', ivr_calls.end_date) AS calls_end_date_id,  -- Campo calculado
    ivr_calls.total_duration AS calls_total_duration,
    ivr_calls.customer_segment AS calls_customer_segment,
    ivr_calls.ivr_language AS calls_ivr_language,
    ivr_calls.steps_module AS calls_steps_module,
    ivr_calls.module_aggregation AS calls_module_aggregation,
    ivr_modules.module_sequece,  
    ivr_modules.module_name,
    ivr_modules.module_duration,
    ivr_modules.module_result,
    ivr_steps.step_sequence,
    ivr_steps.step_name,
    ivr_steps.step_result,
    ivr_steps.step_description_error,
    ivr_steps.document_type,
    ivr_steps.document_identification,
    ivr_steps.customer_phone,
    ivr_steps.billing_account_id
FROM 
    `keepcoding.ivr_calls` AS ivr_calls
INNER JOIN 
    `keepcoding.ivr_modules` AS ivr_modules ON ivr_calls.ivr_id = ivr_modules.ivr_id
INNER JOIN 
    `keepcoding.ivr_steps` AS ivr_steps ON ivr_modules.ivr_id = ivr_steps.ivr_id 
    AND ivr_modules.module_sequece = ivr_steps.module_sequece;
































