CREATE FUNCTION `keepcoding.clean_integer`(input_value INT64)
RETURNS INT64 AS (
    IF(input_value IS NULL, -999999, input_value)
);



