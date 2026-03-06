-- UPDATE: Modificar las filas existentes

USE JavierPradoClinic

-- Insertar registros en la tabla doctor primero
INSERT INTO [HR].[Doctor] VALUES (N'María', 'Garcia', '085187', 1)
SELECT * FROM [HR].[Doctor]

-- UPDATE: Actualizar la especialidad a 2, siempre poner WHERE
UPDATE [HR].[Doctor]
SET [SpecialtyId] = 2
WHERE [DoctorId] = 1;

SELECT * FROM [HR].[Doctor]