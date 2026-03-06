-- ALTER TABLE
-- Se va a modificar la estructura de una tabla existente: Como agregar, eliminar o modificar columnas.
USE JavierPradoClinic

-- CASO 1: ADD para añadir una columna nueva

ALTER TABLE [Admission].[Patient]
ADD DateOfBirth DATE NOT NULL;

SELECT * FROM [Admission].[Patient]

-- CASO 2: ALTER COLUMN modificar el tipo de dato de una columna

ALTER TABLE [Admission].[Patient]
ALTER COLUMN [PatientFirstName] VARCHAR(100);

ALTER TABLE [Admission].[Patient]
ALTER COLUMN [PatientFirstName] NVARCHAR(100);

-- CASO 3: DROP COLUMN eliminar una columan de la tabla
ALTER TABLE [Admission].[Patient]
DROP COLUMN DateOfBirth;
