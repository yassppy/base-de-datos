CREATE DATABASE clinica
GO
USE clinica
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'dbo')
BEGIN
    EXEC('CREATE SCHEMA [dbo]');
END;
CREATE TABLE [dbo].[pacientes] (
    [id_paciente] bigint NOT NULL,
    [nombre] nvarchar(50) NOT NULL,
    [apellido_paterno] nvarchar(50) NOT NULL,
    [apellido_materno] nvarchar(50) NOT NULL,
    [correo] nvarchar(100) NOT NULL,
    [dni] char(8) NOT NULL,
    [fecha_nacimiento] date NOT NULL,
    PRIMARY KEY ([id_paciente])
);


CREATE TABLE [dbo].[citas] (
    [id_cita] bigint NOT NULL,
    [fecha] datetime NOT NULL,
    [tipo_consulta] nvarchar(50) NOT NULL,
    [paciente_id] bigint NOT NULL,
    [medico_id] bigint NOT NULL,
    PRIMARY KEY ([id_cita])
);


CREATE TABLE [dbo].[medicos] (
    [id_medico] bigint NOT NULL,
    [nombre] nvarchar(50) NOT NULL,
    [apellido_paterno] nvarchar(50) NOT NULL,
    [apellido_materno] nvarchar(50) NOT NULL,
    [correo] nvarchar(100) NOT NULL,
    [telefono] char(9) NOT NULL,
    [especialidad_id] bigint NOT NULL,
    PRIMARY KEY ([id_medico])
);


CREATE TABLE [dbo].[especialidades] (
    [id_especialidad] bigint NOT NULL,
    [nombre] nvarchar(50) NOT NULL,
    [precio] decimal(10, 2) NOT NULL,
    PRIMARY KEY ([id_especialidad])
);


-- Foreign key constraints
-- Schema: dbo
ALTER TABLE [dbo].[citas] ADD CONSTRAINT [pacientes_id_paciente_fk] FOREIGN KEY([paciente_id]) REFERENCES [dbo].[pacientes]([id_paciente]);
ALTER TABLE [dbo].[citas] ADD CONSTRAINT [citas_medico_id_fk] FOREIGN KEY([medico_id]) REFERENCES [dbo].[medicos]([id_medico]);
ALTER TABLE [dbo].[medicos] ADD CONSTRAINT [medicos_especialidad_id_fk] FOREIGN KEY([especialidad_id]) REFERENCES [dbo].[especialidades]([id_especialidad]);