-- TRUNCATE TABLE
-- Elimina de manera rápida todo los registros de la tabla
-- Resetea el IDENTITY A 1

USE JavierPradoClinic

INSERT INTO [Admission].[Patient] VALUES
	('12345678', N'Lucía', N'Quisñe Torres', 'lucia.quisne@email.com'),
	('87654321', N'Héctor', N'Peñaloza Díaz', 'hector.penaloza@email.com');

SELECT * FROM [Admission].[Patient]

-- Eliminado la relación ya que no debe haber FK relacionado

ALTER TABLE [Appointments].[Booking]
DROP CONSTRAINT FK_Booking_Patient;
GO

TRUNCATE TABLE [Admission].[Patient]
SELECT * FROM [Admission].[Patient]

INSERT INTO [Admission].[Patient] VALUES
	('12345678', N'Lucía', N'Quisñe Torres', 'lucia.quisne@email.com'),
	('87654321', N'Héctor', N'Peñaloza Díaz', 'hector.penaloza@email.com');
SELECT * FROM [Admission].[Patient]
