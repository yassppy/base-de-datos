USE EmpresaVentas
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES

-- TEMA JOINS: Unir 2 o más tablas

-- Inner Join: Solo me va a dar las filas que tienen coincidencia en ambas tablas

/*
CASO1:  El jefe de ventas quiere ver el detalle de todos los pedidos que ya fueron entregados. 
Necesita saber el nombre del cliente, la fecha del pedido y el estado.
*/

SELECT
	c.nombre,
	p.fecha,
	p.estado
FROM Pedidos as p 
INNER JOIN Clientes as c ON (p.id_cliente = c.id_cliente)
WHERE p.estado = 'Entregado'

-- LEFT JOIN: Todas las columnas de la izquierda aunque no tengan coincidencia en la derecha se le coloca NULL

/*
CASO 1: El área de marketing quiere hacer una campaña para reactivar clientes que nunca han comprado.
Necesitan la lista de esos clientes. Necesita el nombre del cliente, email y ciudad solamente clientes que no tengan
ningún pedido.
*/

SELECT
	p.id_cliente,
	c.nombre,
	c.email,
	c.ciudad
FROM Clientes as c
LEFT JOIN Pedidos as p ON(p.id_cliente = c.id_cliente)
WHERE p.id_cliente IS NULL

-- RIGHT JOIN: Es exactamente lo mismo que LEFT JOIN pero al revés.

/*
CASO 1: El gerente quiere ver todos los pedidos, incluyendo los que fueron hechos online 
sin un empleado asignado. Quiere saber qué empleado gestionó cada pedido.
nombre del empleado, id_pedido, fecha, estado
*/

SELECT
	e.nombre,
	p.id_pedido,
	p.fecha,
	p.estado
FROM Empleados as e
RIGHT JOIN Pedidos as p ON(p.id_empleado = e.id_empleado)

/*FULL OUTER JOIN:
 la tabla de la izquierda Y la tabla de la derecha mandan. Aparecen todos los registros de ambas tablas.
 Donde no hay coincidencia, llega NULL de cualquier lado.
*/

/*
CASO 1:
El equipo de catálogo quiere auditar la relación entre productos y categorías. Quieren ver:
Productos que no tienen categoría asignada
Categorías que no tienen ningún producto
nombre de la categoría, nombre del producto y precio
*/

SELECT c.nombre, p.nombre, p.precio
FROM Productos as p
FULL OUTER JOIN Categorias as c ON (p.id_categoria = c.id_categoria)


SELECT * FROM Categorias