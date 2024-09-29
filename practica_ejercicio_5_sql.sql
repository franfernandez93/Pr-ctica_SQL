SELECT  FROM `core-almanac-436715-v4.keepcoding.ivr_detail` LIMIT 1000

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

