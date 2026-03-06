USE retail;
GO

SELECT
    product_id,
    UPPER(LEFT(TRIM(product_name), 1)) + LOWER(SUBSTRING(TRIM(product_name), 2, 150)) AS product_name,
    UPPER(LEFT(TRIM(category), 1))     + LOWER(SUBSTRING(TRIM(category), 2, 50))      AS category,
    CASE
        WHEN TRY_CAST(NULLIF(TRIM(price), '') AS DECIMAL(10,2)) > 0
        THEN TRY_CAST(TRIM(price) AS DECIMAL(10,2))
        ELSE NULL
    END                                                                                AS price,
    CASE
        WHEN TRIM(stock) IN ('NULL', '', 'N/A')  THEN NULL
        WHEN TRY_CAST(stock AS INT) < 0          THEN NULL
        ELSE TRY_CAST(stock AS INT)
    END                                                                                AS stock,
    NULLIF(TRIM(supplier), '')                                                         AS supplier,
    COALESCE(
        TRY_CONVERT(DATE, TRIM(created_at), 23),
        TRY_CONVERT(DATE, TRIM(created_at), 103),
        TRY_CONVERT(DATE, TRIM(created_at), 101)
    )                                                                                  AS created_at
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY LOWER(TRIM(product_name))
            ORDER BY product_id ASC
        ) AS rn
    FROM raw.products
    WHERE product_id IS NOT NULL
) AS dedup
WHERE rn = 1;
GO

INSERT INTO clean.products (
    product_id, product_name, category,
    price, stock, supplier, created_at
)
SELECT
    product_id,
    UPPER(LEFT(TRIM(product_name), 1)) + LOWER(SUBSTRING(TRIM(product_name), 2, 150)),
    UPPER(LEFT(TRIM(category), 1))     + LOWER(SUBSTRING(TRIM(category), 2, 50)),
    CASE
        WHEN TRY_CAST(NULLIF(TRIM(price), '') AS DECIMAL(10,2)) > 0
        THEN TRY_CAST(TRIM(price) AS DECIMAL(10,2))
        ELSE NULL
    END,
    CASE
        WHEN TRIM(stock) IN ('NULL', '', 'N/A')  THEN NULL
        WHEN TRY_CAST(stock AS INT) < 0          THEN NULL
        ELSE TRY_CAST(stock AS INT)
    END,
    NULLIF(TRIM(supplier), ''),
    COALESCE(
        TRY_CONVERT(DATE, TRIM(created_at), 23),
        TRY_CONVERT(DATE, TRIM(created_at), 103),
        TRY_CONVERT(DATE, TRIM(created_at), 101)
    )
FROM (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY LOWER(TRIM(product_name))
            ORDER BY product_id ASC
        ) AS rn
    FROM raw.products
    WHERE product_id IS NOT NULL
) AS dedup
WHERE rn = 1;
GO

SELECT * FROM clean.products;
GO