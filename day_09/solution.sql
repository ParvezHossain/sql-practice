SELECT dates,
	product_id::text AS PRODUCTS
FROM orders
WHERE customer_id = 1
	AND dates = '2024-02-18'
UNION
SELECT dates,
	STRING_AGG(product_id::text, ',') AS PRODUCTS
FROM orders
WHERE customer_id = 1
	AND dates = '2024-02-18'
GROUP BY customer_id,
	dates;
-- 
SELECT dates,
	product_id::text AS PRODUCTS
FROM orders
UNION
SELECT dates,
	STRING_AGG(product_id::text, ',') AS PRODUCTS
FROM orders
GROUP BY customer_id,
	dates
ORDER BY 1,
	2;