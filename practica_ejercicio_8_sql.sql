SELECT  FROM `core-almanac-436715-v4.keepcoding.ivr_detail` LIMIT 1000


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







