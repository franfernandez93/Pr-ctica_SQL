CREATE TABLE `core-almanac-436715-v4.keepcoding.vdn_aggregation` AS-- Creo la tabla vdn_agreggation
SELECT 
     calls_ivr_id,calls_vdn_label,

    
    CASE 
        WHEN calls_vdn_label LIKE 'ATC%' THEN 'FRONT'
        WHEN calls_vdn_label LIKE 'TECH%' THEN 'TECH'
        WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
        ELSE 'RESTO'
    END AS vdn_aggregation

FROM 
    `keepcoding.ivr_detail`;



------------------------------------------------------------------------------------


CREATE TABLE `core-almanac-436715-v4.keepcoding.document_type_identification` AS -- Creo la tabla documnet_type_identification

WITH ranked_calls AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY calls_start_date) AS rn
    FROM 
        `keepcoding.ivr_detail`
    WHERE 
        document_type IS NOT NULL AND
        document_identification IS NOT NULL
        AND document_type != 'UNKNOWN'
        AND document_identification != 'UNKNOWN'
)

SELECT 
    calls_ivr_id,
    calls_phone_number,
    document_type,
    document_identification
FROM 
    ranked_calls
WHERE 
    rn = 1
ORDER BY 
    calls_start_date;


------------------------------------------------------------------------------------

CREATE TABLE `core-almanac-436715-v4.keepcoding.customer_phone` AS -- Creo la tabla customer_phone


WITH ranked_calls AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY calls_start_date) AS rn
    FROM 
        `keepcoding.ivr_detail`
    WHERE 
        customer_phone IS NOT NULL
        AND customer_phone != "UNKNOWN"
)

SELECT 
    calls_ivr_id,
    customer_phone,
    
FROM 
    ranked_calls
WHERE 
    rn = 1
ORDER BY 
    calls_start_date;


------------------------------------------------------------------------------------


CREATE TABLE `core-almanac-436715-v4.keepcoding.billing_account_id` AS -- Creo la tabla billing_account_id

WITH ranked_calls AS (
    SELECT 
        calls_ivr_id,
        billing_account_id,
        ROW_NUMBER() OVER (PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY calls_start_date) AS rn
    FROM 
        `keepcoding.ivr_detail`
    WHERE 
        billing_account_id IS NOT NULL
        AND billing_account_id != "UNKNOWN"
)

SELECT 
    calls_ivr_id,
    billing_account_id
FROM 
    ranked_calls
WHERE 
    rn = 1
ORDER BY 
    calls_ivr_id;



------------------------------------------------------------------------------------

CREATE TABLE `core-almanac-436715-v4.keepcoding.masiva_lg` AS -- Creo la tabla masiva_lg


WITH calls_with_flag AS (
    SELECT 
        calls_ivr_id,
        CASE 
            WHEN TRIM(module_name) = 'AVERIA_MASIVA' THEN 1 
            ELSE 0 
        END AS masiva_lg
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls_ivr_id,
    MAX(masiva_lg) AS masiva_lg
FROM 
    calls_with_flag
GROUP BY 
    calls_ivr_id
ORDER BY 
    calls_ivr_id;



------------------------------------------------------------------------------------

CREATE TABLE `core-almanac-436715-v4.keepcoding.info_by_phone_lg` AS --Creo la tabla info_by_phone_lg

WITH calls_with_flag AS (
    SELECT 
        calls_ivr_id,
        CASE 
            WHEN TRIM(step_name) = 'CUSTOMERINFOBYPHONE.TX' AND TRIM(step_result) = 'OK' THEN 1 
            ELSE 0 
        END AS info_by_phone_lg
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls_ivr_id,
    MAX(info_by_phone_lg) AS info_by_phone_lg
FROM 
    calls_with_flag
GROUP BY 
    calls_ivr_id
ORDER BY 
    calls_ivr_id;

------------------------------------------------------------------------------------


CREATE TABLE `core-almanac-436715-v4.keepcoding.info_by_dni_lg` AS --Creo la tabla info_by_dni_lg

WITH calls_with_flag AS (
    SELECT 
        calls_ivr_id,
        CASE 
            WHEN TRIM(step_name) = 'CUSTOMERINFOBYDNI.TX' AND TRIM(step_result) = 'OK' THEN 1 
            ELSE 0 
        END AS info_by_dni_lg
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls_ivr_id,
    MAX(info_by_dni_lg) AS info_by_dni_lg
FROM 
    calls_with_flag
GROUP BY 
    calls_ivr_id
ORDER BY 
    calls_ivr_id;


------------------------------------------------------------------------------------



CREATE TABLE `core-almanac-436715-v4.keepcoding.repeated_phone_24H` AS -- Creo la tabla repeated_phone_24H
WITH calls AS (
    SELECT 
        calls_ivr_id,
        calls_phone_number,
        calls_start_date
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls.calls_ivr_id,
    calls.calls_phone_number,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM calls AS calls_inner
            WHERE calls_inner.calls_phone_number = calls.calls_phone_number
              AND calls_inner.calls_start_date < calls.calls_start_date
              AND calls_inner.calls_start_date >= TIMESTAMP_SUB(calls.calls_start_date, INTERVAL 24 HOUR)
        ) THEN 1
        ELSE 0
    END AS repeated_phone_24H
FROM 
    calls
ORDER BY 
    calls.calls_ivr_id;




------------------------------------------------------------------------------------

CREATE TABLE `core-almanac-436715-v4.keepcoding.cause_recall_phone_24H` AS -- Creo la tabla recall_phone_24H
WITH calls AS (
    SELECT 
        calls_ivr_id,
        calls_phone_number,
        calls_start_date
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls.calls_ivr_id,
    calls.calls_phone_number,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM calls AS calls_inner
            WHERE calls_inner.calls_phone_number = calls.calls_phone_number
              AND calls_inner.calls_start_date > calls.calls_start_date
              AND calls_inner.calls_start_date <= TIMESTAMP_ADD(calls.calls_start_date, INTERVAL 24 HOUR)
        ) THEN 1
        ELSE 0
    END AS cause_recall_phone_24H
FROM 
    calls
ORDER BY 
    calls.calls_ivr_id;


------------------------------------------------------------------------------------
CREATE TABLE `core-almanac-436715-v4.keepcoding.ivr_summary` AS
SELECT 
    ivr_detail.calls_ivr_id,
    ivr_detail.calls_phone_number,
    ivr_detail.calls_ivr_result,
    vdn_aggregation.vdn_aggregation,
    ivr_detail.calls_start_date,
    ivr_detail.calls_end_date,
    ivr_detail.calls_total_duration,
    ivr_detail.calls_customer_segment,
    ivr_detail.calls_ivr_language,
    ivr_detail.calls_steps_module,
    ivr_detail.calls_module_aggregation,
    document_type_identification.document_type,
    document_type_identification.document_identification,
    customer_phone.customer_phone,
    billing_account_id.billing_account_id,
    masiva_lg.masiva_lg,
    info_by_phone_lg.info_by_phone_lg,
    info_by_dni_lg.info_by_dni_lg,
    repeated_phone_24H.repeated_phone_24H,
    cause_recall_phone_24H.cause_recall_phone_24H
FROM 
    `keepcoding.ivr_detail` AS ivr_detail
INNER JOIN 
    `keepcoding.vdn_aggregation` ON ivr_detail.calls_ivr_id = vdn_aggregation.calls_ivr_id
INNER JOIN 
    `keepcoding.document_type_identification` ON ivr_detail.calls_ivr_id = document_type_identification.calls_ivr_id
INNER JOIN 
    `keepcoding.customer_phone` ON ivr_detail.calls_ivr_id = customer_phone.calls_ivr_id
INNER JOIN 
    `keepcoding.billing_account_id` ON ivr_detail.calls_ivr_id = billing_account_id.calls_ivr_id
INNER JOIN 
    `keepcoding.masiva_lg` ON ivr_detail.calls_ivr_id = masiva_lg.calls_ivr_id
INNER JOIN 
    `keepcoding.info_by_phone_lg` ON ivr_detail.calls_ivr_id = info_by_phone_lg.calls_ivr_id
INNER JOIN 
    `keepcoding.info_by_dni_lg` ON ivr_detail.calls_ivr_id = info_by_dni_lg.calls_ivr_id
INNER JOIN 
    `keepcoding.repeated_phone_24H` ON ivr_detail.calls_ivr_id = repeated_phone_24H.calls_ivr_id
INNER JOIN 
    `keepcoding.cause_recall_phone_24H` ON ivr_detail.calls_ivr_id = cause_recall_phone_24H.calls_ivr_id;




















