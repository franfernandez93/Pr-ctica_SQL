SELECT  FROM `core-almanac-436715-v4.keepcoding.ivr_detail` LIMIT 1000




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




