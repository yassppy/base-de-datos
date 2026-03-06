-- DELETE: ELIMINAR FILA, SE DEBE PONER WHERE PARA ELIMINAR UNA FILA ESPECIFICA

USE JavierPradoClinic

DELETE FROM [HR].[Doctor]
WHERE [DoctorId] = 1

SELECT * FROM [HR].[Doctor]

-- Cuando se utiliza el DELETE, el IDENTITY continúa desde el último valor usado
INSERT INTO [HR].[Doctor] VALUES (N'María', 'Garcia', '085187', 1)
SELECT * FROM [HR].[Doctor]