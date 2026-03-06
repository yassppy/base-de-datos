USE retail;
GO

SELECT
    o.order_id,
    TRY_CAST(o.customer_id AS INT) AS customer_id,
    COALESCE(
        TRY_CONVERT(DATE, TRIM(o.order_date), 23),
        TRY_CONVERT(DATE, TRIM(o.order_date), 103),
        TRY_CONVERT(DATE, TRIM(o.order_date), 101)
    )                              AS order_date,
    CASE
        WHEN LOWER(TRIM(o.total_amount)) IN ('null', '', 'n/a') THEN NULL
        WHEN TRY_CAST(o.total_amount AS DECIMAL(10,2)) < 0      THEN NULL
        ELSE TRY_CAST(o.total_amount AS DECIMAL(10,2))
    END                            AS total_amount,
    CASE
        WHEN LOWER(TRIM(o.status)) IN ('completed', 'completd', 'complete') THEN 'completed'
        WHEN LOWER(TRIM(o.status)) IN ('pending')                            THEN 'pending'
        WHEN LOWER(TRIM(o.status)) IN ('shipped')                            THEN 'shipped'
        WHEN LOWER(TRIM(o.status)) IN ('cancelled', 'canceled')              THEN 'cancelled'
        WHEN LOWER(TRIM(o.status)) IN ('refunded')                           THEN 'refunded'
        ELSE NULL
    END                            AS status,
    CASE
        WHEN LOWER(REPLACE(TRIM(o.payment_method), ' ', '_')) IN ('credit_card') THEN 'credit_card'
        WHEN LOWER(REPLACE(TRIM(o.payment_method), ' ', '_')) IN ('debit_card')  THEN 'debit_card'
        WHEN LOWER(TRIM(o.payment_method)) IN ('cash')                           THEN 'cash'
        ELSE LOWER(TRIM(o.payment_method))
    END                            AS payment_method,
    UPPER(LEFT(TRIM(o.shipping_city), 1))
    + LOWER(SUBSTRING(TRIM(o.shipping_city), 2, 100))      AS shipping_city,
    NULLIF(TRIM(o.notes), '')      AS notes
FROM raw.orders o
INNER JOIN clean.customers c ON TRY_CAST(o.customer_id AS INT) = c.customer_id
WHERE o.order_id IS NOT NULL
  AND TRY_CAST(o.customer_id AS INT) IS NOT NULL;
GO

INSERT INTO clean.orders (
    order_id, customer_id, order_date, total_amount,
    status, payment_method, shipping_city, notes
)
SELECT
    o.order_id,
    TRY_CAST(o.customer_id AS INT),
    COALESCE(
        TRY_CONVERT(DATE, TRIM(o.order_date), 23),
        TRY_CONVERT(DATE, TRIM(o.order_date), 103),
        TRY_CONVERT(DATE, TRIM(o.order_date), 101)
    ),
    CASE
        WHEN LOWER(TRIM(o.total_amount)) IN ('null', '', 'n/a') THEN NULL
        WHEN TRY_CAST(o.total_amount AS DECIMAL(10,2)) < 0      THEN NULL
        ELSE TRY_CAST(o.total_amount AS DECIMAL(10,2))
    END,
    CASE
        WHEN LOWER(TRIM(o.status)) IN ('completed', 'completd', 'complete') THEN 'completed'
        WHEN LOWER(TRIM(o.status)) IN ('pending')                            THEN 'pending'
        WHEN LOWER(TRIM(o.status)) IN ('shipped')                            THEN 'shipped'
        WHEN LOWER(TRIM(o.status)) IN ('cancelled', 'canceled')              THEN 'cancelled'
        WHEN LOWER(TRIM(o.status)) IN ('refunded')                           THEN 'refunded'
        ELSE NULL
    END,
    CASE
        WHEN LOWER(REPLACE(TRIM(o.payment_method), ' ', '_')) IN ('credit_card') THEN 'credit_card'
        WHEN LOWER(REPLACE(TRIM(o.payment_method), ' ', '_')) IN ('debit_card')  THEN 'debit_card'
        WHEN LOWER(TRIM(o.payment_method)) IN ('cash')                           THEN 'cash'
        ELSE LOWER(TRIM(o.payment_method))
    END,
    UPPER(LEFT(TRIM(o.shipping_city), 1)) + LOWER(SUBSTRING(TRIM(o.shipping_city), 2, 100)),
    NULLIF(TRIM(o.notes), '')
FROM raw.orders o
INNER JOIN clean.customers c ON TRY_CAST(o.customer_id AS INT) = c.customer_id
WHERE o.order_id IS NOT NULL
  AND TRY_CAST(o.customer_id AS INT) IS NOT NULL;
GO

SELECT * FROM clean.orders;
GO