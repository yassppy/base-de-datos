USE retail;
GO

SELECT
    op.order_product_id,
    TRY_CAST(op.order_id   AS INT)                                                   AS order_id,
    TRY_CAST(op.product_id AS INT)                                                   AS product_id,
    CASE
        WHEN TRY_CAST(op.quantity AS INT) > 0 THEN TRY_CAST(op.quantity AS INT)
        ELSE NULL
    END                                                                              AS quantity,
    TRY_CAST(NULLIF(TRIM(op.unit_price), '') AS DECIMAL(10,2))                      AS unit_price,
    COALESCE(TRY_CAST(NULLIF(TRIM(op.discount), '') AS DECIMAL(5,2)), 0)            AS discount,
    CASE
        WHEN LOWER(TRIM(op.subtotal)) IN ('null', '', 'n/a')
          OR TRY_CAST(op.subtotal AS DECIMAL(10,2)) < 0
        THEN TRY_CAST(op.quantity AS INT)
           * TRY_CAST(NULLIF(TRIM(op.unit_price), '') AS DECIMAL(10,2))
        ELSE TRY_CAST(op.subtotal AS DECIMAL(10,2))
    END                                                                              AS subtotal
FROM raw.order_products op
INNER JOIN clean.orders   co ON TRY_CAST(op.order_id   AS INT) = co.order_id
INNER JOIN clean.products cp ON TRY_CAST(op.product_id AS INT) = cp.product_id
WHERE op.order_product_id IS NOT NULL
  AND TRY_CAST(op.order_id   AS INT) IS NOT NULL
  AND TRY_CAST(op.product_id AS INT) IS NOT NULL
  AND TRY_CAST(op.quantity   AS INT) > 0;
GO

INSERT INTO clean.order_products (
    order_product_id, order_id, product_id,
    quantity, unit_price, discount, subtotal
)
SELECT
    op.order_product_id,
    TRY_CAST(op.order_id   AS INT),
    TRY_CAST(op.product_id AS INT),
    CASE
        WHEN TRY_CAST(op.quantity AS INT) > 0 THEN TRY_CAST(op.quantity AS INT)
        ELSE NULL
    END,
    TRY_CAST(NULLIF(TRIM(op.unit_price), '') AS DECIMAL(10,2)),
    COALESCE(TRY_CAST(NULLIF(TRIM(op.discount), '') AS DECIMAL(5,2)), 0),
    CASE
        WHEN LOWER(TRIM(op.subtotal)) IN ('null', '', 'n/a')
          OR TRY_CAST(op.subtotal AS DECIMAL(10,2)) < 0
        THEN TRY_CAST(op.quantity AS INT)
           * TRY_CAST(NULLIF(TRIM(op.unit_price), '') AS DECIMAL(10,2))
        ELSE TRY_CAST(op.subtotal AS DECIMAL(10,2))
    END
FROM raw.order_products op
INNER JOIN clean.orders   co ON TRY_CAST(op.order_id   AS INT) = co.order_id
INNER JOIN clean.products cp ON TRY_CAST(op.product_id AS INT) = cp.product_id
WHERE op.order_product_id IS NOT NULL
  AND TRY_CAST(op.order_id   AS INT) IS NOT NULL
  AND TRY_CAST(op.product_id AS INT) IS NOT NULL
  AND TRY_CAST(op.quantity   AS INT) > 0;
GO

SELECT * FROM clean.order_products;
GO