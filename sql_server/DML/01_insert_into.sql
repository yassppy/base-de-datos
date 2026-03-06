-- DML: Manipulación de datos dentro de las tablas
USE JavierPradoClinic

-- Insertar un registro
INSERT INTO [HR].[Specialty] VALUES (N'Cardiología');
SELECT SpecialtyId, SpecialtyName FROM [HR].[Specialty]

-- Insertar varios registros

INSERT INTO [HR].[Specialty] VALUES
	(N'Pediatría'),
	(N'Neumología')
;
SELECT SpecialtyId, SpecialtyName FROM [HR].[Specialty]