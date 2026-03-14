-- ============================================================
--  BASE DE DATOS PARA PRACTICAR JOINs EN SQL SERVER
--  Escenario: empresa de ventas
--  Autor: generado con Claude
-- ============================================================

-- 1. CREAR Y USAR LA BASE DE DATOS
-- ============================================================
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'EmpresaVentas')
    DROP DATABASE EmpresaVentas;
GO

CREATE DATABASE EmpresaVentas;
GO

USE EmpresaVentas;
GO


-- 2. CREAR TABLAS
-- ============================================================

CREATE TABLE Categorias (
    id_categoria  INT           PRIMARY KEY IDENTITY(1,1),
    nombre        VARCHAR(50)   NOT NULL,
    descripcion   VARCHAR(200)
);

CREATE TABLE Productos (
    id_producto   INT           PRIMARY KEY IDENTITY(1,1),
    nombre        VARCHAR(100)  NOT NULL,
    precio        DECIMAL(10,2) NOT NULL,
    stock         INT           NOT NULL DEFAULT 0,
    id_categoria  INT           REFERENCES Categorias(id_categoria)
);

CREATE TABLE Clientes (
    id_cliente      INT           PRIMARY KEY IDENTITY(1,1),
    nombre          VARCHAR(100)  NOT NULL,
    email           VARCHAR(100),
    ciudad          VARCHAR(50),
    fecha_registro  DATE          DEFAULT GETDATE()
);

CREATE TABLE Empleados (
    id_empleado   INT           PRIMARY KEY IDENTITY(1,1),
    nombre        VARCHAR(100)  NOT NULL,
    cargo         VARCHAR(50),
    id_supervisor INT           REFERENCES Empleados(id_empleado)  -- auto-referencia
);

CREATE TABLE Pedidos (
    id_pedido    INT           PRIMARY KEY IDENTITY(1,1),
    fecha        DATE          NOT NULL DEFAULT GETDATE(),
    estado       VARCHAR(20)   NOT NULL DEFAULT 'Pendiente',
    id_cliente   INT           NOT NULL REFERENCES Clientes(id_cliente),
    id_empleado  INT           REFERENCES Empleados(id_empleado)  -- puede ser NULL (venta online)
);

CREATE TABLE Detalle_Pedido (
    id_detalle       INT           PRIMARY KEY IDENTITY(1,1),
    id_pedido        INT           NOT NULL REFERENCES Pedidos(id_pedido),
    id_producto      INT           NOT NULL REFERENCES Productos(id_producto),
    cantidad         INT           NOT NULL,
    precio_unitario  DECIMAL(10,2) NOT NULL
);
GO


-- 3. INSERTAR DATOS
-- ============================================================

-- Categorias (5 registros)
INSERT INTO Categorias (nombre, descripcion) VALUES
('Electrónica',    'Dispositivos y gadgets tecnológicos'),
('Ropa',           'Prendas de vestir para todas las edades'),
('Hogar',          'Artículos para el hogar y cocina'),
('Deportes',       'Equipamiento y ropa deportiva'),
('Sin asignar',    'Categoría temporal para productos nuevos');  -- categoría que usarán pocos productos
GO

-- Productos (10 registros — algunos SIN ventas, uno sin categoría de los comunes)
INSERT INTO Productos (nombre, precio, stock, id_categoria) VALUES
('Laptop HP 15"',         2500.00, 10, 1),   -- id_producto = 1
('Smartphone Samsung A54', 1200.00, 25, 1),  -- id_producto = 2
('Auriculares Bluetooth',   150.00, 40, 1),  -- id_producto = 3
('Camiseta Polo Classic',    80.00, 100, 2), -- id_producto = 4
('Zapatillas Running',      250.00, 30, 4),  -- id_producto = 5
('Licuadora Oster 600W',    180.00, 20, 3),  -- id_producto = 6
('Cafetera Nespresso',      450.00, 8,  3),  -- id_producto = 7
('Pelota Fútbol Pro',        90.00, 50, 4),  -- id_producto = 8
('Teclado Mecánico RGB',    320.00, 15, 1),  -- id_producto = 9  (sin ventas aún)
('Mochila Deportiva',       120.00, 35, NULL);-- id_producto = 10 (sin categoría asignada)
GO

-- Clientes (7 registros — algunos SIN pedidos)
INSERT INTO Clientes (nombre, email, ciudad, fecha_registro) VALUES
('Carlos Mendoza',   'carlos@gmail.com',   'Lima',      '2023-01-15'),
('Ana Torres',       'ana.torres@hotmail.com', 'Arequipa', '2023-03-20'),
('Luis Paredes',     'luis.p@gmail.com',   'Lima',      '2023-05-10'),
('María Quispe',     'maria.q@yahoo.com',  'Cusco',     '2023-06-01'),
('Roberto Díaz',     'roberto@gmail.com',  'Trujillo',  '2024-01-08'),
('Sofía Ramos',      NULL,                 'Lima',      '2024-02-14'),  -- sin email
('Pedro Castillo',   'pedro.c@gmail.com',  'Piura',     '2024-03-01'); -- sin pedidos todavía
GO

-- Empleados (5 registros — con jerarquía y uno SIN pedidos asignados)
INSERT INTO Empleados (nombre, cargo, id_supervisor) VALUES
('Miguel Ángel Cruz',  'Gerente de Ventas', NULL),  -- id_empleado = 1 (jefe máximo)
('Valeria Soto',       'Vendedor Senior',   1),      -- id_empleado = 2
('Jorge Huanca',       'Vendedor Senior',   1),      -- id_empleado = 3
('Claudia Vega',       'Vendedor Junior',   2),      -- id_empleado = 4
('Renzo Palomino',     'Vendedor Junior',   3);      -- id_empleado = 5 (sin pedidos asignados)
GO

-- Pedidos (8 registros)
-- Nota: id_empleado = NULL en el pedido 4 (cliente compró online sin asesor)
INSERT INTO Pedidos (fecha, estado, id_cliente, id_empleado) VALUES
('2024-01-10', 'Entregado',  1, 2),   -- id_pedido = 1  Carlos → Valeria
('2024-01-25', 'Entregado',  2, 3),   -- id_pedido = 2  Ana → Jorge
('2024-02-05', 'Entregado',  1, 2),   -- id_pedido = 3  Carlos → Valeria (repite)
('2024-02-20', 'Entregado',  3, NULL),-- id_pedido = 4  Luis → sin asesor (venta online)
('2024-03-01', 'En proceso', 4, 4),   -- id_pedido = 5  María → Claudia
('2024-03-15', 'Pendiente',  5, 3),   -- id_pedido = 6  Roberto → Jorge
('2024-04-01', 'En proceso', 6, 4),   -- id_pedido = 7  Sofía → Claudia
('2024-04-10', 'Pendiente',  2, 2);   -- id_pedido = 8  Ana → Valeria (segunda compra)
GO

-- Detalle de pedidos
INSERT INTO Detalle_Pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 2500.00),   -- Pedido 1: Laptop
(1, 3, 2,  150.00),   -- Pedido 1: 2 Auriculares
(2, 4, 3,   80.00),   -- Pedido 2: 3 Camisetas
(2, 5, 1,  250.00),   -- Pedido 2: Zapatillas
(3, 2, 1, 1200.00),   -- Pedido 3: Smartphone
(3, 6, 1,  180.00),   -- Pedido 3: Licuadora
(4, 7, 1,  450.00),   -- Pedido 4: Cafetera
(5, 8, 2,   90.00),   -- Pedido 5: 2 Pelotas
(5, 5, 1,  250.00),   -- Pedido 5: Zapatillas
(6, 1, 1, 2500.00),   -- Pedido 6: Laptop
(7, 4, 2,   80.00),   -- Pedido 7: 2 Camisetas
(8, 3, 1,  150.00);   -- Pedido 8: Auriculares
-- Productos 9 (Teclado) y 10 (Mochila) NO tienen ventas → perfectos para LEFT JOIN
GO


-- ============================================================
--  4. CONSULTAS DE PRÁCTICA
-- ============================================================


-- ============================================================
-- INNER JOIN
-- Devuelve solo las filas que tienen COINCIDENCIA en ambas tablas.
-- Si un cliente no tiene pedidos → NO aparece.
-- Si un pedido no tiene empleado → NO aparece.
-- ============================================================

-- Ejercicio 1: Clientes que SÍ han realizado pedidos
SELECT
    C.nombre       AS cliente,
    C.ciudad,
    P.id_pedido,
    P.fecha,
    P.estado
FROM Clientes C
INNER JOIN Pedidos P ON C.id_cliente = P.id_cliente
ORDER BY C.nombre, P.fecha;
-- Resultado: NO aparece Pedro Castillo (no tiene pedidos)

-- Ejercicio 2: Detalle completo de pedidos (productos comprados)
SELECT
    P.id_pedido,
    P.fecha,
    C.nombre          AS cliente,
    PR.nombre         AS producto,
    DP.cantidad,
    DP.precio_unitario,
    DP.cantidad * DP.precio_unitario AS subtotal
FROM Pedidos P
INNER JOIN Clientes C         ON P.id_cliente  = C.id_cliente
INNER JOIN Detalle_Pedido DP  ON P.id_pedido   = DP.id_pedido
INNER JOIN Productos PR       ON DP.id_producto = PR.id_producto
ORDER BY P.id_pedido;

-- Ejercicio 3: Total vendido por empleado (solo pedidos CON asesor asignado)
SELECT
    E.nombre          AS empleado,
    E.cargo,
    COUNT(P.id_pedido) AS total_pedidos,
    SUM(DP.cantidad * DP.precio_unitario) AS monto_total
FROM Empleados E
INNER JOIN Pedidos P        ON E.id_empleado = P.id_empleado
INNER JOIN Detalle_Pedido DP ON P.id_pedido  = DP.id_pedido
GROUP BY E.id_empleado, E.nombre, E.cargo
ORDER BY monto_total DESC;
-- NO aparece Renzo Palomino (sin pedidos) ni la venta online sin asesor


-- ============================================================
-- LEFT JOIN
-- Devuelve TODAS las filas de la tabla de la IZQUIERDA,
-- aunque no haya coincidencia en la tabla de la derecha.
-- Las columnas de la tabla derecha vendrán en NULL.
-- ============================================================

-- Ejercicio 4: Todos los clientes, tengan o no pedidos
SELECT
    C.nombre       AS cliente,
    C.ciudad,
    COUNT(P.id_pedido) AS total_pedidos
FROM Clientes C
LEFT JOIN Pedidos P ON C.id_cliente = P.id_cliente
GROUP BY C.id_cliente, C.nombre, C.ciudad
ORDER BY total_pedidos DESC;
-- Pedro Castillo aparece con total_pedidos = 0

-- Ejercicio 5: Clientes que NUNCA han comprado
-- (el truco clásico: filtrar donde la columna de la derecha es NULL)
SELECT
    C.nombre,
    C.email,
    C.ciudad,
    C.fecha_registro
FROM Clientes C
LEFT JOIN Pedidos P ON C.id_cliente = P.id_cliente
WHERE P.id_pedido IS NULL;
-- Solo muestra: Pedro Castillo

-- Ejercicio 6: Todos los productos con sus ventas (incluye los que nunca se vendieron)
SELECT
    PR.nombre          AS producto,
    CAT.nombre         AS categoria,
    PR.precio,
    ISNULL(SUM(DP.cantidad), 0)                           AS unidades_vendidas,
    ISNULL(SUM(DP.cantidad * DP.precio_unitario), 0.00)   AS ingresos
FROM Productos PR
LEFT JOIN Categorias CAT    ON PR.id_categoria  = CAT.id_categoria
LEFT JOIN Detalle_Pedido DP ON PR.id_producto   = DP.id_producto
GROUP BY PR.id_producto, PR.nombre, CAT.nombre, PR.precio
ORDER BY ingresos DESC;
-- Teclado Mecánico y Mochila aparecen con 0 ventas

-- Ejercicio 7: Empleados y sus pedidos asignados (incluyendo los que no gestionaron ninguno)
SELECT
    E.nombre   AS empleado,
    E.cargo,
    P.id_pedido,
    P.fecha,
    P.estado
FROM Empleados E
LEFT JOIN Pedidos P ON E.id_empleado = P.id_empleado
ORDER BY E.nombre, P.fecha;
-- Renzo Palomino aparece con los campos de Pedidos en NULL


-- ============================================================
-- RIGHT JOIN
-- Devuelve TODAS las filas de la tabla de la DERECHA,
-- aunque no haya coincidencia en la tabla de la izquierda.
-- En la práctica, siempre puedes reescribirlo como LEFT JOIN
-- intercambiando el orden de las tablas. Aquí lo verás en acción.
-- ============================================================

-- Ejercicio 8: Todos los pedidos aunque no tengan empleado asignado
-- (equivalente al LEFT JOIN del ejercicio 7 pero al revés)
SELECT
    E.nombre   AS empleado,
    E.cargo,
    P.id_pedido,
    P.fecha,
    P.estado,
    C.nombre   AS cliente
FROM Empleados E
RIGHT JOIN Pedidos P ON E.id_empleado = P.id_empleado
INNER JOIN Clientes C ON P.id_cliente = C.id_cliente
ORDER BY P.id_pedido;
-- El pedido 4 (venta online) aparece con empleado = NULL

-- Ejercicio 9: Todos los productos, estén o no relacionados con una categoría
SELECT
    CAT.nombre   AS categoria,
    PR.nombre    AS producto,
    PR.precio,
    PR.stock
FROM Categorias CAT
RIGHT JOIN Productos PR ON CAT.id_categoria = PR.id_categoria
ORDER BY CAT.nombre, PR.nombre;
-- La Mochila Deportiva aparece con categoria = NULL


-- ============================================================
-- FULL JOIN (FULL OUTER JOIN)
-- Devuelve TODAS las filas de AMBAS tablas,
-- rellenando con NULL donde no hay coincidencia.
-- Útil para comparar dos listas y ver qué falta en cada lado.
-- ============================================================

-- Ejercicio 10: Ver qué clientes tienen pedidos y qué pedidos tienen cliente
-- (en este modelo siempre habrá coincidencia, pero sirve para ilustrar)
SELECT
    C.nombre      AS cliente,
    C.ciudad,
    P.id_pedido,
    P.fecha,
    P.estado
FROM Clientes C
FULL OUTER JOIN Pedidos P ON C.id_cliente = P.id_cliente
ORDER BY C.nombre, P.fecha;

-- Ejercicio 11: Productos vs categorías — ver los que quedan huérfanos en cada lado
SELECT
    CAT.nombre   AS categoria,
    PR.nombre    AS producto,
    PR.precio
FROM Categorias CAT
FULL OUTER JOIN Productos PR ON CAT.id_categoria = PR.id_categoria
ORDER BY CAT.nombre, PR.nombre;
-- "Sin asignar" aparecerá sin producto (no hay productos con esa categoría)
-- La Mochila Deportiva aparecerá sin categoría


-- ============================================================
-- SELF JOIN (JOIN de una tabla consigo misma)
-- Muy útil para jerarquías: empleados y sus supervisores
-- ============================================================

-- Ejercicio 12: Empleados con el nombre de su supervisor
SELECT
    E.nombre          AS empleado,
    E.cargo,
    SUP.nombre        AS supervisor,
    SUP.cargo         AS cargo_supervisor
FROM Empleados E
LEFT JOIN Empleados SUP ON E.id_supervisor = SUP.id_empleado
ORDER BY SUP.nombre, E.nombre;
-- Miguel Ángel Cruz aparece con supervisor = NULL (es el jefe)


-- ============================================================
-- PREGUNTAS DE REFLEXIÓN PARA PRACTICAR
-- ============================================================
/*
  1. ¿Por qué en el ejercicio 1 (INNER JOIN) no aparece Pedro Castillo?
     → Porque no tiene ningún registro en la tabla Pedidos.
     
  2. ¿Qué diferencia hay entre el ejercicio 4 y el ejercicio 5?
     → El 4 usa COUNT y muestra todos; el 5 filtra WHERE IS NULL para aislar
       solo los que no tienen pedidos.
       
  3. ¿Cuándo usarías RIGHT JOIN en lugar de LEFT JOIN?
     → Son equivalentes. LEFT JOIN es más legible porque ponemos la tabla
       "principal" a la izquierda. RIGHT JOIN se usa cuando ya tienes una
       consulta con muchos JOINs y añadir otro LEFT JOIN sería incómodo.
       
  4. ¿Qué pasa si combinas LEFT JOIN con una condición WHERE en la tabla derecha?
     → El LEFT JOIN se convierte en un INNER JOIN implícito. Para filtrar
       correctamente en LEFT JOIN, la condición debe ir en el ON, no en el WHERE.
       
  5. ¿Para qué sirve el FULL OUTER JOIN del ejercicio 11?
     → Para auditar: detectar categorías sin productos Y productos sin categoría
       en una sola consulta.
*/
GO
