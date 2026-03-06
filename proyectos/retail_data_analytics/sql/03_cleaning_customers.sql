-- Limpieza de datos

USE retail;
GO

SELECT * FROM [raw].[customers]
-- Haciendo limpieza en la tabla
SELECT
	customer_id,
	UPPER(TRIM(first_name)) AS first_name,
	UPPER(TRIM(last_name)) AS last_name,
	NULLIF(
		CASE WHEN LOWER(TRIM(email)) LIKE '%@%.%'
			 THEN LOWER(TRIM(email))
			 ELSE NULL
		END, ''
	) AS email,
	CASE 
		WHEN TRIM(phone) IN ('N/A', '', 'NULL') THEN NULL
		WHEN REPLACE(REPLACE(TRIM(phone), '-', ''), ' ', '') = '000000000' THEN NULL
		ELSE
            RIGHT(
                REPLACE(
                    REPLACE(
                        REPLACE(TRIM(phone), '+51', ''),
                    '-', ''),
                ' ', ''),
            9)
	END AS phone,
	UPPER(TRIM(city)) AS city,
	UPPER(TRIM(country)) AS country,
	COALESCE( -- Convierte a uno de esos formatos y devuelve el que no es nulo.
        TRY_CONVERT(DATE, TRIM(registration_date), 23),   -- 2023-01-15
        TRY_CONVERT(DATE, TRIM(registration_date), 103),  -- 15/01/2023
        TRY_CONVERT(DATE, TRIM(registration_date), 101)   -- 01/15/2023
    ) AS registration_date
FROM [raw].[customers]
GO

-- Cambiar Per por PERU
UPDATE [raw].[customers]
SET [country] = 'PERU'
WHERE [customer_id] = 18;

-- Eliminar la columna age de ambas tablas
ALTER TABLE [raw].[customers]
DROP COLUMN [age];

ALTER TABLE [clean].[customers]
DROP COLUMN [age];

-- Insertando los registros a la tabla limpia
INSERT INTO [clean].[customers] (
	[customer_id],
	[first_name],
	[last_name],
	[email],
	[phone],
	[city],
	[country],
	[registration_date]
)
SELECT
	customer_id,
	UPPER(TRIM(first_name)) AS first_name,
	UPPER(TRIM(last_name)) AS last_name,
	NULLIF(
		CASE WHEN LOWER(TRIM(email)) LIKE '%@%.%'
			 THEN LOWER(TRIM(email))
			 ELSE NULL
		END, ''
	) AS email,
	CASE 
		WHEN TRIM(phone) IN ('N/A', '', 'NULL') THEN NULL
		WHEN REPLACE(REPLACE(TRIM(phone), '-', ''), ' ', '') = '000000000' THEN NULL
		ELSE
            RIGHT(
                REPLACE(
                    REPLACE(
                        REPLACE(TRIM(phone), '+51', ''),
                    '-', ''),
                ' ', ''),
            9)
	END AS phone,
	UPPER(TRIM(city)) AS city,
	UPPER(TRIM(country)) AS country,
	COALESCE( -- Convierte a uno de esos formatos y devuelve el que no es nulo.
        TRY_CONVERT(DATE, TRIM(registration_date), 23),   -- 2023-01-15
        TRY_CONVERT(DATE, TRIM(registration_date), 103),  -- 15/01/2023
        TRY_CONVERT(DATE, TRIM(registration_date), 101)   -- 01/15/2023
    ) AS registration_date
FROM [raw].[customers]
GO

SELECT * FROM [clean].[customers]