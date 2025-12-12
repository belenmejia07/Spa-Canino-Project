create database SpaCanino
use SpaCanino
/*-------------------------------------------------------------
	PROYECTO: Spa Canino
	DESCRIPCION: Definicion De Tablas y Restricciones
-------------------------------------------------------------*/
Create Table Recepcionista (
	ID_Recepcionista INT IDENTITY (1,1) PRIMARY KEY,
	Nombre VARCHAR (50) NOT NULL,
	Telefono VARCHAR(10) NOT NULL
)

Create Table Cliente(
	ID_Cliente INT IDENTITY (1,1) PRIMARY KEY,
	Nombre VARCHAR (50) NOT NULL,
	Telefono VARCHAR(10) NOT NULL,
	Direccion VARCHAR (50) NULL,
	FechaRegistro DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE))
)

Create Table Mascota (
	ID_Mascota INT IDENTITY (1,1) PRIMARY KEY,
	Nombre VARCHAR (50) NOT NULL,
	Raza VARCHAR (50) NULL,
	FechaNacimiento DATE NULL
		CHECK(FechaNacimiento IS NULL OR FechaNacimiento < CAST(GETDATE() AS DATE)),
	Temperamento VARCHAR (50) NOT NULL,
	ID_Cliente INT NOT NULL,
	FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
)

Create Table Groomer(
	ID_Groomer INT IDENTITY (1,1) PRIMARY KEY,
	Nombre VARCHAR (50) NOT NULL,
	Telefono VARCHAR(10) NULL,
	Especialidad VARCHAR(50) NULL
)

create Table Cita (
	ID_Cita INT IDENTITY(1,1) PRIMARY KEY,
	FechayHora DATETIME NOT NULL
		CHECK(FechayHora > CAST(GETDATE() AS DATE)),
	Estado VARCHAR (15) NOT NULL
			CHECK (Estado in ('Pendiente', 'Confirmada', 'Atendida', 'Cancelada')),
	Nota VARCHAR (200) NULL,
	ID_Mascota INT NOT NULL,
	ID_Groomer INT NOT NULL,
	ID_Recepcionista INT NOT NULL,
	FOREIGN KEY (ID_Mascota) REFERENCES Mascota(ID_Mascota),
	FOREIGN KEY (ID_Groomer) REFERENCES Groomer(ID_Groomer),
	FOREIGN KEY (ID_Recepcionista) REFERENCES Recepcionista(ID_Recepcionista)
)

Create Table Servicio(
	ID_Servicio INT IDENTITY (1,1) PRIMARY KEY,
	NombreServicio VARCHAR (50) NOT NULL,
	Precio INT NOT NULL,
	Descripcion VARCHAR (1000) NOT NULL,
	Duracion INT NOT NULL
)

Create Table Factura(
	ID_Factura INT IDENTITY (1,1) PRIMARY KEY,
	FechaDeFactura DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),
	Total INT NOT NULL
		CHECK (Total > 0),
	Metodo  VARCHAR (10) NOT NULL
		CHECK (Metodo in ('Tarjeta', 'QR', 'Efectivo')),
	ID_Cita INT NOT NULL UNIQUE,
	FOREIGN KEY (ID_Cita) REFERENCES Cita(ID_Cita)
)