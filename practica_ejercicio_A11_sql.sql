SELECT  FROM `core-almanac-436715-v4.keepcoding.ivr_detail` LIMIT 1000

WITH calls_with_two_flags AS (
    SELECT 
        calls_ivr_id,
        calls_phone_number,
        calls_start_date
    FROM 
        `keepcoding.ivr_detail`
)

SELECT 
    calls_with_two_flags.calls_ivr_id,
    calls_with_two_flags.calls_phone_number,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM calls_with_two_flags AS calls_inner
            WHERE calls_inner.calls_phone_number = calls_with_two_flags.calls_phone_number
              AND calls_inner.calls_start_date < calls_with_two_flags.calls_start_date
              AND calls_inner.calls_start_date >= TIMESTAMP_SUB(calls_with_two_flags.calls_start_date, INTERVAL 24 HOUR)
        ) THEN 1
        ELSE 0
    END AS repeated_phone_24H,
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM calls_with_two_flags AS calls_inner
            WHERE calls_inner.calls_phone_number = calls_with_two_flags.calls_phone_number
              AND calls_inner.calls_start_date > calls_with_two_flags.calls_start_date
              AND calls_inner.calls_start_date <= TIMESTAMP_ADD(calls_with_two_flags.calls_start_date, INTERVAL 24 HOUR)
        ) THEN 1
        ELSE 0
    END AS cause_recall_phone_24H
FROM 
    calls_with_two_flags
ORDER BY 
    calls_with_two_flags.calls_ivr_id;




