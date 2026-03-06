USE retail
GO

-- Cargar datos de csv a las tablas
BULK INSERT [raw].[customers]
FROM 'C:\Users\HP\Documents\base-de-datos\proyectos\retail_data_analytics\data\customers.csv'
WITH (
	FORMAT = 'CSV',
	CODEPAGE = '65001', --UTF8
	FIRSTROW = 2, -- Comienza desde la fila 2
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a', -- final de cada fila
	TABLOCK -- Bloquea la tabla para que no se pueda interumpir la carga
);

BULK INSERT [raw].[products]
FROM 'C:\Users\HP\Documents\base-de-datos\proyectos\retail_data_analytics\data\products.csv'
WITH (
	FORMAT = 'CSV',
	CODEPAGE = '65001', --UTF8
	FIRSTROW = 2, -- Comienza desde la fila 2
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a', -- final de cada fila
	FIELDQUOTE = '`', -- Cuando el carácter tiene comillas
	TABLOCK -- Bloquea la tabla para que no se pueda interumpir la carga
)

BULK INSERT [raw].[orders]
FROM 'C:\Users\HP\Documents\base-de-datos\proyectos\retail_data_analytics\data\orders.csv'
WITH (
	FORMAT = 'CSV',
	CODEPAGE = '65001', --UTF8
	FIRSTROW = 2, -- Comienza desde la fila 2
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a', -- final de cada fila
	TABLOCK -- Bloquea la tabla para que no se pueda interumpir la carga
);

BULK INSERT [raw].[order_products]
FROM 'C:\Users\HP\Documents\base-de-datos\proyectos\retail_data_analytics\data\order_products.csv'
WITH (
	FORMAT = 'CSV',
	CODEPAGE = '65001', --UTF8
	FIRSTROW = 2, -- Comienza desde la fila 2
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a', -- final de cada fila
	TABLOCK -- Bloquea la tabla para que no se pueda interumpir la carga
);

SELECT * FROM [raw].[customers]
SELECT * FROM [raw].[products]
SELECT * FROM [raw].[orders]
SELECT * FROM [raw].[order_products]