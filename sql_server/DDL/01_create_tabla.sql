-- La base de datos lo crea un administrador experimentado
-- Debe estar estimado para 5 años.
-- Crear una carpeta SQLData en el disco C
CREATE DATABASE JavierPradoClinic
ON PRIMARY (
	NAME = 'JavierPradoClinic_Data',
	FILENAME = 'C:\SQLData\JavierPradoClinic_Data.mdf',-- Donde va a estar mi data
	SIZE = 10MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 5MB
)
LOG ON (
	NAME = 'JavierPradoClinic_Log',
	FILENAME = 'C:\SQLData\JavierPradoClinic_Log.ldf',-- Registro de operaciones
	SIZE = 5MB,
	MAXSIZE = 500MB,
	FILEGROWTH = 10MB
);
GO

USE JavierPradoClinic
GO

-- Crear los esquemas de las diferentes áreas del negocio
CREATE SCHEMA HR;
GO
CREATE SCHEMA Admission;
GO
CREATE SCHEMA Appointments;
GO

-- Tipos de datos definido por el usuario (UDTs)
CREATE TYPE dbo.UdtNationalId FROM CHAR(8) NOT NULL;
GO
CREATE TYPE dbo.UdtMedicalLicense FROM CHAR(6) NOT NULL;
GO

-- Creación de las tablas
CREATE TABLE HR.Specialty (
	SpecialtyId INT IDENTITY(1,1) PRIMARY KEY,
	SpecialtyName NVARCHAR(100) NOT NULL
);

CREATE TABLE HR.Doctor (
    DoctorId INT IDENTITY(1,1) PRIMARY KEY,
    DoctorFirstName NVARCHAR(100) NOT NULL,
	DoctorLastName NVARCHAR(100) NOT NULL,
    MedicalLicenseNumber dbo.UdtMedicalLicense,
	SpecialtyId INT FOREIGN KEY REFERENCES HR.Specialty(SpecialtyId)
);

CREATE TABLE Admission.Patient (
    PatientId INT IDENTITY(1,1) PRIMARY KEY,
    NationalId dbo.UdtNationalId,
    PatientFirstName NVARCHAR(100) NOT NULL,
    PatientLastName NVARCHAR(100) NOT NULL,
    Email VARCHAR(150)
);

CREATE TABLE Appointments.Booking (
    BookingId INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    PatientId INT NOT NULL,
    DoctorId INT NOT NULL,
    AppointmentStatus VARCHAR(20) DEFAULT 'Scheduled',   -- Scheduled / Completed / Cancelled

    CONSTRAINT FK_Booking_Patient FOREIGN KEY (PatientId) REFERENCES Admission.Patient(PatientId),
    CONSTRAINT FK_Booking_Doctor  FOREIGN KEY (DoctorId)  REFERENCES HR.Doctor(DoctorId)
);