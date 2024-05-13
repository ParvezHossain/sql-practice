WITH filter_rows
AS
  (
         SELECT *,
                CASE
                       WHEN substring( day_indicator, extract( isodow FROM dates )::INT, 1 ) = '1' THEN 1
                       ELSE 0
                end AS is_matched
         FROM   day_indicator )
  SELECT product_id,
         day_indicator,
         to_char(DATES::DATE, 'FMMM/DD/YYYY')
  FROM   filter_rows
  WHERE  is_matched = 1
  -- Another Solution
  SELECT product_id,
         day_indicator,
         to_char(DATES::DATE, 'FMMM/DD/YYYY')
  FROM   (
                SELECT product_id,
                       day_indicator,
                       dates,
                       CASE
                              WHEN substring(day_indicator, extract(isodow FROM dates)::INT, 1) = '1' THEN 1
                              ELSE 0
                       end AS is_matched
                FROM   day_indicator) AS filter_rows
  WHERE  is_matched = 1;