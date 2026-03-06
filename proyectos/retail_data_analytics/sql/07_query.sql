-- Tops de productos más vendidos

SELECT
	p.product_name,
	p.category,
    SUM(op.quantity)   AS unidades_vendidas,
    SUM(op.subtotal)   AS ingresos_total
FROM [clean].[order_products] op
INNER JOIN [clean].[products] p ON op.product_id = p.product_id
INNER JOIN [clean].[orders] o ON op.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_name, p.category
ORDER BY unidades_vendidas DESC;

-- Cantidad de clientes

SELECT COUNT(*) AS cantidad
FROM [clean].[customers]

-- Ventas por ciudad
SELECT
    shipping_city as ciudad,
    COUNT(order_id)      AS total_ordenes,
    SUM(total_amount)    AS ingresos
FROM [clean].[orders]
WHERE status = 'completed'
GROUP BY shipping_city
ORDER BY ingresos DESC;